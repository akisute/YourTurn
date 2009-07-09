//
//  YTYourTurnBackgroundView.h
//  YourTurn
//
//  Created by Masashi Ono on 09/07/07.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YTYourTurnBackgroundView : UIView {
    NSTimeInterval allottedTime;
    NSTimeInterval currentTime;
    NSTimer *timer;
    BOOL gradient;
    CGFloat *initialBackgroundColorHSBA;      // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *endBackgroundColorHSBA;          // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *currentBackgroundColorHSBA;      // [hue, satulation, brightness, alpha]  0.0~1.0
    CGFloat *deltaBackgroundColorHSBA;        // [hue, satulation, brightness, alpha]  0.0~1.0
}

- (void)setTimerWithAllottedTime:(int)time
                   initialColor:(CGFloat *)initialColor
                       endColor:(CGFloat *)endColor
                       gradient:(BOOL)grad;
- (void)timerFired;
- (void)releaseTimer;

@end
