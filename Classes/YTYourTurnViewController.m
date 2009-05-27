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

#define TIME_INTERVAL_ANIMATION 1.0
#define TIME_INTERVAL_TIMER 1.0


@implementation YTYourTurnViewController

@synthesize displayLabel;
@synthesize timerLabel;

#pragma mark init, dealloc, memory management

- (id)init
{
    if (self = [super init]) 
    {
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"";
    
    YTAttendee *attendee = [YTQueue instance].currentTurnAttendee;
    self.displayLabel.text = [NSString stringWithFormat:@"Current: %@", attendee.name];
    
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

#pragma mark other methods

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
    
    time = 15;
    self.timerLabel.text = [NSString stringWithFormat:@"%d", time];
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
        self.timerLabel.text = [NSString stringWithFormat:@"%d", time];
    }
}

- (IBAction)endTurn:(id)sender
{
    // End current turn
    YTQueue *queue = [YTQueue instance];
    [queue endCurrentTurn];
    YTAttendee *attendee = queue.currentTurnAttendee;
    
    // Reset timer
    [self setTimerWithInterval:TIME_INTERVAL_ANIMATION + TIME_INTERVAL_TIMER];
    
    // Animations
    [UIView beginAnimations:@"endTurn" context:NULL];
    [UIView setAnimationDuration:TIME_INTERVAL_ANIMATION];
    self.displayLabel.text = [NSString stringWithFormat:@"Current: %@", attendee.name];
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

@end
