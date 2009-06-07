//
//  YTYourTurnViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/05.
//

#import <UIKit/UIKit.h>


@interface YTYourTurnViewController : UIViewController {
    UILabel *displayLabel;
    UILabel *timerLabel;
    NSTimer *timer;
    int allottedTime;
    int time;
    CGFloat *initialBackgroundColorHSBA; // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *endBackgroundColorHSBA;     // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *currentBackgroundColorHSBA; // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *deltaBackgroundColorHSBA;   // [hue, satulation, brightness, alpha]  0.0~1.0
}

@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic) CGFloat *initialBackgroundColorHSBA;
@property (nonatomic) CGFloat *endBackgroundColorHSBA;

- (void)setTimerWithInterval:(NSTimeInterval)interval;
- (void)timerFired;
- (IBAction)endTurn:(id)sender;

@end
