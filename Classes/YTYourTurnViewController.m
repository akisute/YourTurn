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
    //TODO: reuse timer, only invalidate when timer is expired also repeats should be NO
    time = 15;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    self.title = @"";
    
    YTAttendee *attendee = [YTQueue instance].currentTurnAttendee;
    self.displayLabel.text = [NSString stringWithFormat:@"Current: %@", attendee.name];
    self.timerLabel.text = [NSString stringWithFormat:@"%d", time];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [displayLabel release];
    [timerLabel release];
    [timer invalidate];
    [timer release];
    [super dealloc];
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

- (void)resetTimer
{
//    if (timer)
//    {
//        [timer invalidate];
//        [timer release];
//        timer = nil;
//    }
    time = 15;
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
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
    [self resetTimer];
    
    // Animations
    [UIView beginAnimations:@"endTurn" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.title = [NSString stringWithFormat:@"%@'s Turn!", attendee.name];
    self.displayLabel.text = [NSString stringWithFormat:@"%@'s Turn!", attendee.name];
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
