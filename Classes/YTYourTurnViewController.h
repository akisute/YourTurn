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
    int firstBellTime;
    int time;
    BOOL intermission;
    BOOL fullScreenMode;
    CGPoint swipeStartPoint;
    int swipeDirection;
}

@property (nonatomic, retain) IBOutlet YTYourTurnBackgroundView *backgroundView;
@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;

- (void)setTimerWithInterval:(NSTimeInterval)interval;
- (void)timerFired;
- (IBAction)endTurn:(id)sender;

@end
