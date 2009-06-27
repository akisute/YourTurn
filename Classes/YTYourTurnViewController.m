//
//  YTYourTurnViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "YTYourTurnViewController.h"
#import "YTQueue.h"
#import "YTAttendee.h"
#import "YTSound.h"
#import "YTUserDefaults.h"
#import "NSString+YourTurn.h"

#define TIME_INTERVAL_ANIMATION 1.0
#define TIME_INTERVAL_TIMER 1.0


@interface YTYourTurnViewController (Private)
/*! Loads current attendee from YTQueue and set up the view for it. */
- (void)loadCurrentAttendee;
/*! Loads intermission settings from NSUserDefaults if set, and set up the view for it. */
- (void)loadIntermission;
/*! Calculate the delta between start hue and end hue. Takes as small delta as possible. */
- (CGFloat)calculateHueDeltaWithStartHue:(CGFloat)s endHue:(CGFloat)e time:(CGFloat)t;
@end

@implementation YTYourTurnViewController

@synthesize displayLabel;
@synthesize timerLabel;
@synthesize initialBackgroundColorHSBA;
@synthesize endBackgroundColorHSBA;

#pragma mark init, dealloc, memory management

- (void)viewDidLoad
{
    self.title = @"";
    initialBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
    endBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
    currentBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
    deltaBackgroundColorHSBA = malloc(4 * sizeof(CGFloat));
    intermission = NO;
    [self loadCurrentAttendee];
    [self setTimerWithInterval:TIME_INTERVAL_TIMER];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [displayLabel release];
    [timerLabel release];
    // timer is released when the view will disappear
    // this invalidate will be never called...
//    [timer invalidate];
//    [timer release];
    free(initialBackgroundColorHSBA);
    free(endBackgroundColorHSBA);
    free(currentBackgroundColorHSBA);
    free(deltaBackgroundColorHSBA);
    [super dealloc];
}

#pragma mark UIViewController method

- (void)viewWillDisappear:(BOOL)animated
{
    // invalidate the current timer
    if (timer)
    {
        // timer is retained by NSRunLoop object, not by this ViewController
        // thus timer should not be released
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark UIResponder method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSUInteger numTaps = [touch tapCount];
    if (numTaps < 2)
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    else if (numTaps == 2)
    {
        [self endTurn:self];
    }
    else
    {
        // Just ignore too many touches
    }
}

#pragma mark other public methods

- (void)setTimerWithInterval:(NSTimeInterval)interval
{
    if (timer)
    {
        // set a new interval for current timer
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
    else
    {
        // create a new timer with given interval
        // timer is just assigned, not retained here
        timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                 target:self
                                               selector:@selector(timerFired)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    time = allottedTime;
    self.timerLabel.text = [NSString stringColonFormatWithAllottedTime:time];
    currentBackgroundColorHSBA[0] = initialBackgroundColorHSBA[0];
    currentBackgroundColorHSBA[1] = initialBackgroundColorHSBA[1];
    currentBackgroundColorHSBA[2] = initialBackgroundColorHSBA[2];
    currentBackgroundColorHSBA[3] = initialBackgroundColorHSBA[3];
    self.view.backgroundColor = [UIColor colorWithHue:currentBackgroundColorHSBA[0]
                                           saturation:currentBackgroundColorHSBA[1]
                                           brightness:currentBackgroundColorHSBA[2]
                                                alpha:currentBackgroundColorHSBA[3]];
}

- (void)timerFired
{
    time -= 1;
    if (time <= 0)
    {
        [self endTurn:self];
    }
    else
    {
        self.timerLabel.text = [NSString stringColonFormatWithAllottedTime:time];
        currentBackgroundColorHSBA[0] = currentBackgroundColorHSBA[0] + deltaBackgroundColorHSBA[0];
        currentBackgroundColorHSBA[1] = currentBackgroundColorHSBA[1] + deltaBackgroundColorHSBA[1];
        currentBackgroundColorHSBA[2] = currentBackgroundColorHSBA[2] + deltaBackgroundColorHSBA[2];
        currentBackgroundColorHSBA[3] = currentBackgroundColorHSBA[3] + deltaBackgroundColorHSBA[3];
        self.view.backgroundColor = [UIColor colorWithHue:currentBackgroundColorHSBA[0]
                                               saturation:currentBackgroundColorHSBA[1]
                                               brightness:currentBackgroundColorHSBA[2]
                                                    alpha:currentBackgroundColorHSBA[3]];
    }
}

- (IBAction)endTurn:(id)sender
{
    // End current turn and reset timer + attendee-related variables
    BOOL intermissionEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULTS_INTERMISSION_ENABLED_KEY];
    if (intermissionEnabled && !intermission)
    {
        [self loadIntermission];
    }
    else
    {
        YTQueue *queue = [YTQueue instance];
        [queue endCurrentTurn];
        [self loadCurrentAttendee];
    }
    [self setTimerWithInterval:TIME_INTERVAL_ANIMATION + TIME_INTERVAL_TIMER];
    
    // Animations
    [UIView beginAnimations:@"endTurn" context:NULL];
    [UIView setAnimationDuration:TIME_INTERVAL_ANIMATION];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
    // Sounds
    YTSound *sound = [[[YTSound alloc] initWithId:@"bell"
                                         fileName:@"bell"
                                    fileExtension:@"aif"] autorelease];
    [sound play];
}

#pragma mark private methods

- (void)loadCurrentAttendee
{
    YTQueue *queue = [YTQueue instance];
    YTAttendee *attendee = queue.currentTurnAttendee;
    self.title = attendee.name;
    self.displayLabel.numberOfLines = 1;
    self.displayLabel.text = attendee.name;
    self.displayLabel.textColor = [UIColor blackColor];
    self.timerLabel.textColor = [UIColor blackColor];
    allottedTime = attendee.allottedTime;
    intermission = NO;
    initialBackgroundColorHSBA[0] = 0.33;
    initialBackgroundColorHSBA[1] = 0.5;
    initialBackgroundColorHSBA[2] = 1.0;
    initialBackgroundColorHSBA[3] = 1.0;
    endBackgroundColorHSBA[0] = 0.0;
    endBackgroundColorHSBA[1] = 0.5;
    endBackgroundColorHSBA[2] = 1.0;
    endBackgroundColorHSBA[3] = 1.0;
    deltaBackgroundColorHSBA[0] = [self calculateHueDeltaWithStartHue:initialBackgroundColorHSBA[0]
                                                               endHue:endBackgroundColorHSBA[0]
                                                                 time:(CGFloat)allottedTime];
    deltaBackgroundColorHSBA[1] = (endBackgroundColorHSBA[1] - initialBackgroundColorHSBA[1]) / allottedTime;
    deltaBackgroundColorHSBA[2] = (endBackgroundColorHSBA[2] - initialBackgroundColorHSBA[2]) / allottedTime;
    deltaBackgroundColorHSBA[3] = (endBackgroundColorHSBA[3] - initialBackgroundColorHSBA[3]) / allottedTime;
    LOG(@"[color delta]hue=%f, saturation=%f, brightness=%f alpha=%f", deltaBackgroundColorHSBA[0], deltaBackgroundColorHSBA[1], deltaBackgroundColorHSBA[2]);
}

- (void)loadIntermission
{
    YTQueue *queue = [YTQueue instance];
    YTAttendee *attendee = queue.nextTurnAttendee;
    self.title = @"Intermission";
    self.displayLabel.numberOfLines = 2;
    self.displayLabel.text = [NSString stringWithFormat:@"Next person:\n%@", attendee.name];
    self.displayLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textColor = [UIColor whiteColor];
    allottedTime = [[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_INTERMISSION_DURATION_KEY];
    intermission = YES;
    initialBackgroundColorHSBA[0] = 0.0;
    initialBackgroundColorHSBA[1] = 0.0;
    initialBackgroundColorHSBA[2] = 0.0;
    initialBackgroundColorHSBA[3] = 1.0;
    endBackgroundColorHSBA[0] = 0.0;
    endBackgroundColorHSBA[1] = 0.0;
    endBackgroundColorHSBA[2] = 0.0;
    endBackgroundColorHSBA[3] = 1.0;
    deltaBackgroundColorHSBA[0] = [self calculateHueDeltaWithStartHue:initialBackgroundColorHSBA[0]
                                                               endHue:endBackgroundColorHSBA[0]
                                                                 time:(CGFloat)allottedTime];
    deltaBackgroundColorHSBA[1] = (endBackgroundColorHSBA[1] - initialBackgroundColorHSBA[1]) / allottedTime;
    deltaBackgroundColorHSBA[2] = (endBackgroundColorHSBA[2] - initialBackgroundColorHSBA[2]) / allottedTime;
    deltaBackgroundColorHSBA[3] = (endBackgroundColorHSBA[3] - initialBackgroundColorHSBA[3]) / allottedTime;
}

- (CGFloat)calculateHueDeltaWithStartHue:(CGFloat)s endHue:(CGFloat)e time:(CGFloat)t
{
    LOG(@"[hue calculation]start=%f, end=%f, time=%f", s, e, t);
    CGFloat end = (e < s) ? e + 1.0 : e;
    CGFloat diff = end - s;
    if (diff < 0.5)
    {
        LOG(@"[hue calculation]diff=%f - Clockwise rotation", diff);
        return diff / t;
    }
    else
    {
        LOG(@"[hue calculation]diff=%f - Counter-Clockwise rotation", diff);
        return (diff - 1.0) / t;
    }
}

@end
