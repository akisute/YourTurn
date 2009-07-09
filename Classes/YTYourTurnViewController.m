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
#import "YTYourTurnBackgroundView.h"
#import "YTQueue.h"
#import "YTAttendee.h"
#import "YTSound.h"
#import "YTSoundTypes.h"
#import "YTUserDefaults.h"
#import "NSString+YourTurn.h"

#define TIME_INTERVAL_ANIMATION 1.0
#define TIME_INTERVAL_TIMER 1.0


@interface YTYourTurnViewController (Private)
/*! Loads current attendee from YTQueue and set up the view for it. */
- (void)loadCurrentAttendee;
/*! Loads intermission settings from NSUserDefaults if set, and set up the view for it. */
- (void)loadIntermission;
@end

@implementation YTYourTurnViewController

@synthesize backgroundView;
@synthesize displayLabel;
@synthesize timerLabel;

#pragma mark init, dealloc, memory management

- (void)viewDidLoad
{
    self.title = @"";
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
    [backgroundView releaseTimer];
    [backgroundView release];
    [displayLabel release];
    [timerLabel release];
    [super dealloc];
}

#pragma mark UIViewController method

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // disable idle timer while session is going
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // enable idle timer again since session is finished
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    // invalidate the current timer
    if (timer)
    {
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
    }
}

- (IBAction)endTurn:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // End current turn and reset timer + attendee-related variables
    BOOL intermissionEnabled = [defaults boolForKey:USERDEFAULTS_INTERMISSION_ENABLED_KEY];
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
    YTSound *sound = [[YTSoundTypes instance] soundForId:[defaults stringForKey:USERDEFAULTS_SOUND_TURNEND_KEY]];
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
    self.displayLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textColor = [UIColor whiteColor];
    allottedTime = attendee.allottedTime;
    intermission = NO;
    CGFloat initialColor[4] = {0.33, 0.8, 0.6, 1.0};
    CGFloat endColor[4] = {0.00, 0.8, 0.6, 1.0};
    [backgroundView setTimerWithAllottedTime:allottedTime
                                        wait:TIME_INTERVAL_ANIMATION
                                initialColor:initialColor
                                    endColor:endColor
                                    gradient:YES];
}

- (void)loadIntermission
{
    YTQueue *queue = [YTQueue instance];
    YTAttendee *attendee = queue.nextTurnAttendee;
    self.title = NSLocalizedString(@"Intermission", @"Title of the YourTurn view when in intermission");
    self.displayLabel.numberOfLines = 2;
    self.displayLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Next person:\n%@",
                                                                          @"Text of the display label on the YourTurn view"),
                              attendee.name];
    self.displayLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textColor = [UIColor whiteColor];
    allottedTime = [[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_INTERMISSION_DURATION_KEY];
    intermission = YES;
    CGFloat initialColor[4] = {0.00, 1.0, 0.0, 1.0};
    CGFloat endColor[4] = {0.00, 1.0, 0.0, 1.0};
    [backgroundView setTimerWithAllottedTime:allottedTime
                                        wait:TIME_INTERVAL_ANIMATION
                                initialColor:initialColor
                                    endColor:endColor
                                    gradient:NO];
}

@end
