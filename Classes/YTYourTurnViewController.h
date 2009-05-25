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
    int time;
}

@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *timerLabel;

- (void)resetTimer;
- (void)timerFired;
- (IBAction)endTurn:(id)sender;

@end
