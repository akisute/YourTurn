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
#define SWIPE_HORIZONTAL 100.0
#define SWIPE_VERTICAL 100.0
#define SWIPE_NO 0
#define SWIPE_LEFT 1
#define SWIPE_RIGHT 2


@interface YTYourTurnViewController (Private)
/*! Loads current attendee from YTQueue and set up the view for it. */
- (void)loadCurrentAttendee;
/*! Loads intermission settings from NSUserDefaults if set, and set up the view for it. */
- (void)loadIntermission;
/*! Set current view mode to full screen (YES) or normal (NO) with animation. */
- (void)fullScreenMode:(BOOL)mode animated:(BOOL)animated;
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.wantsFullScreenLayout = YES;
    [self fullScreenMode:NO animated:animated];
    // disable idle timer while session is going
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.wantsFullScreenLayout = NO;
    [self fullScreenMode:NO animated:NO];
    // enable idle timer again since session is finished
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    // invalidate the current timer
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Layout subviews to match the current interface orientation
    UIInterfaceOrientation interfaceOrientation = [UIDevice currentDevice].orientation;
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        // These values must be same with those of YourTurnView.xib
        timerLabel.frame = CGRectMake(0.0, 140.0, 320.0, 100.0);
        displayLabel.frame = CGRectMake(20.0, 248.0, 280.0, 84.0);
    }
    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        timerLabel.frame = CGRectMake(0.0, 90.0, 480.0, 100.0);
        displayLabel.frame = CGRectMake(30.0, 198.0, 420.0, 84.0);
    }
}

#pragma mark UIResponder method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSUInteger numTaps = [touch tapCount];
    if (numTaps == 1)
    {
        swipeStartPoint = [touch locationInView:backgroundView];
        swipeDirection = SWIPE_NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:backgroundView];
    if (fabsf(currentPoint.x - swipeStartPoint.x) > SWIPE_HORIZONTAL
        && abs(currentPoint.y - swipeStartPoint.y) < SWIPE_VERTICAL)
    {
        swipeDirection = (currentPoint.x > swipeStartPoint.x) ? SWIPE_RIGHT : SWIPE_LEFT;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (swipeDirection == SWIPE_NO)
    {
        [self fullScreenMode:!fullScreenMode animated:YES];
    }
    else
    {
        [self endTurn:self];
        swipeDirection = SWIPE_NO;
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
    UIViewAnimationTransition transition = (swipeDirection == SWIPE_LEFT)
    ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft;
    swipeDirection = SWIPE_NO;
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
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

- (void)fullScreenMode:(BOOL)mode animated:(BOOL)animated
{
    fullScreenMode = mode;
    // Force set the frame of the navigation bar
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.origin.y = 20.0;
    self.navigationController.navigationBar.frame = frame;
    // Show/Hide statusbar
    [[UIApplication sharedApplication]  setStatusBarHidden:mode animated:animated];
    // Show/Hide navigationbar (using zero alpha value)
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
    }
    self.navigationController.navigationBar.alpha = mode ? 0 : 1;
    if (animated)
    {
        [UIView commitAnimations];
    }
}

@end
