//
//  YTYourTurnViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/05.
//

#import <AudioToolbox/AudioToolbox.h>
#import "YTYourTurnViewController.h"
#import "YTQueue.h"
#import "YTAttendee.h"
#import "NSString+YourTurn.h"

#define TIME_INTERVAL_ANIMATION 1.0
#define TIME_INTERVAL_TIMER 1.0


@interface YTYourTurnViewController (Private)
/*! Loads current attendee from YTQueue and set up the view for it. */
- (void)loadCurrentAttendee;
@end

@implementation YTYourTurnViewController

@synthesize displayLabel;
@synthesize timerLabel;
@synthesize initialBackgroundColorRGBA;
@synthesize endBackgroundColorRGBA;

#pragma mark init, dealloc, memory management

- (void)viewDidLoad
{
    self.title = @"";
    // TODO: load this value from preferences or attendee data
    initialBackgroundColorRGBA = malloc(4 * sizeof(CGFloat));
    endBackgroundColorRGBA = malloc(4 * sizeof(CGFloat));
    currentBackgroundColorRGBA = malloc(4 * sizeof(CGFloat));
    deltaBackgroundColorRGBA = malloc(4 * sizeof(CGFloat));
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
    free(initialBackgroundColorRGBA);
    free(endBackgroundColorRGBA);
    free(currentBackgroundColorRGBA);
    free(deltaBackgroundColorRGBA);
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
    self.timerLabel.text = [NSString stringColonFormatsWithAllottedTime:time];
    currentBackgroundColorRGBA[0] = initialBackgroundColorRGBA[0];
    currentBackgroundColorRGBA[1] = initialBackgroundColorRGBA[1];
    currentBackgroundColorRGBA[2] = initialBackgroundColorRGBA[2];
    currentBackgroundColorRGBA[3] = initialBackgroundColorRGBA[3];
    self.view.backgroundColor = [UIColor colorWithRed:currentBackgroundColorRGBA[0]
                                                green:currentBackgroundColorRGBA[1]
                                                 blue:currentBackgroundColorRGBA[2]
                                                alpha:currentBackgroundColorRGBA[3]];
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
        self.timerLabel.text = [NSString stringColonFormatsWithAllottedTime:time];
        currentBackgroundColorRGBA[0] = currentBackgroundColorRGBA[0] + deltaBackgroundColorRGBA[0];
        currentBackgroundColorRGBA[1] = currentBackgroundColorRGBA[1] + deltaBackgroundColorRGBA[1];
        currentBackgroundColorRGBA[2] = currentBackgroundColorRGBA[2] + deltaBackgroundColorRGBA[2];
        currentBackgroundColorRGBA[3] = currentBackgroundColorRGBA[3] + deltaBackgroundColorRGBA[3];
        self.view.backgroundColor = [UIColor colorWithRed:currentBackgroundColorRGBA[0]
                                                    green:currentBackgroundColorRGBA[1]
                                                     blue:currentBackgroundColorRGBA[2]
                                                    alpha:currentBackgroundColorRGBA[3]];
    }
}

- (IBAction)endTurn:(id)sender
{
    // End current turn
    YTQueue *queue = [YTQueue instance];
    [queue endCurrentTurn];
    
    // Reset timer and attendee-related variables
    [self loadCurrentAttendee];
    [self setTimerWithInterval:TIME_INTERVAL_ANIMATION + TIME_INTERVAL_TIMER];
    
    // Animations
    [UIView beginAnimations:@"endTurn" context:NULL];
    [UIView setAnimationDuration:TIME_INTERVAL_ANIMATION];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
    // Sounds
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"bell" ofType:@"aif"];
    NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
    LOG(@"Opening the sound file %d", audioURL);
    SystemSoundID soundID;
    OSStatus status = AudioServicesCreateSystemSoundID((CFURLRef)audioURL, &soundID);
    LOG(@"AudioServicesCreateSystemSoundID result=%d", status);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark private methods

- (void)loadCurrentAttendee
{
    YTQueue *queue = [YTQueue instance];
    YTAttendee *attendee = queue.currentTurnAttendee;
    self.displayLabel.text = [NSString stringWithFormat:@"Current: %@", attendee.name];
    allottedTime = attendee.allottedTime;
    // TODO: set up background color
    initialBackgroundColorRGBA[0] = 0.0;
    initialBackgroundColorRGBA[1] = 1.0;
    initialBackgroundColorRGBA[2] = 0.0;
    initialBackgroundColorRGBA[3] = 1.0;
    endBackgroundColorRGBA[0] = 1.0;
    endBackgroundColorRGBA[1] = 0.0;
    endBackgroundColorRGBA[2] = 0.0;
    endBackgroundColorRGBA[3] = 1.0;
    deltaBackgroundColorRGBA[0] = (endBackgroundColorRGBA[0] - initialBackgroundColorRGBA[0]) / allottedTime;
    deltaBackgroundColorRGBA[1] = (endBackgroundColorRGBA[1] - initialBackgroundColorRGBA[1]) / allottedTime;
    deltaBackgroundColorRGBA[2] = (endBackgroundColorRGBA[2] - initialBackgroundColorRGBA[2]) / allottedTime;
    deltaBackgroundColorRGBA[3] = (endBackgroundColorRGBA[3] - initialBackgroundColorRGBA[3]) / allottedTime;
}

@end
