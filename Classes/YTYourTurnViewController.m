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
    YTAttendee *attendee = [YTQueue instance].currentTurnAttendee;
    self.title = [NSString stringWithFormat:@"%@'s Turn!", attendee.name];
    self.displayLabel.text = [NSString stringWithFormat:@"%@'s Turn!", attendee.name];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
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
        // End current turn
        YTQueue *queue = [YTQueue instance];
        [queue endCurrentTurn];
        YTAttendee *attendee = queue.currentTurnAttendee;
        
        // Animations
        [UIView beginAnimations:@"endTurn" context:NULL];
        [UIView setAnimationDuration:1.0];
        self.title = [NSString stringWithFormat:@"%@'s Turn!", attendee.name];
        self.displayLabel.text = [NSString stringWithFormat:@"%@'s Turn!", attendee.name];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView commitAnimations];
        
        // Sounds
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"bell" ofType:@"mp3"];
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((CFURLRef)audioURL, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    else
    {
        // Just ignore too many touches
    }
}

@end
