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
    CGFloat *initialBackgroundColorRGBA; // [r, g, b, a]  0.0~1.0
    CGFloat *endBackgroundColorRGBA;     // [r, g, b, a]  0.0~1.0
    CGFloat *currentBackgroundColorRGBA; // [r, g, b, a]  0.0~1.0
    CGFloat *deltaBackgroundColorRGBA;   // [r, g, b, a]  0.0~1.0
}

@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic) CGFloat *initialBackgroundColorRGBA;
@property (nonatomic) CGFloat *endBackgroundColorRGBA;

- (void)setTimerWithInterval:(NSTimeInterval)interval;
- (void)timerFired;
- (IBAction)endTurn:(id)sender;

@end
