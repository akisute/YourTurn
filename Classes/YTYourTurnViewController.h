//
//  YTYourTurnViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTYourTurnBackgroundView;


@interface YTYourTurnViewController : UIViewController {
    YTYourTurnBackgroundView *backgroundView;
    UILabel *displayLabel;
    UILabel *timerLabel;
    NSTimer *timer;
    int allottedTime;
    int time;
    BOOL intermission;
    CGFloat *initialBackgroundColorHSBA; // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *endBackgroundColorHSBA;     // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *currentBackgroundColorHSBA; // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *deltaBackgroundColorHSBA;   // [hue, satulation, brightness, alpha]  0.0~1.0
}

@property (nonatomic, retain) IBOutlet YTYourTurnBackgroundView *backgroundView;
@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic) CGFloat *initialBackgroundColorHSBA;
@property (nonatomic) CGFloat *endBackgroundColorHSBA;

- (void)setTimerWithInterval:(NSTimeInterval)interval;
- (void)timerFired;
- (IBAction)endTurn:(id)sender;

@end
