//
//  YTQueueTableViewManager.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YTQueueTableViewController : UITableViewController {
}

- (IBAction)segmentedControlClicked:(id)sender;
- (IBAction)addAttendee:(id)sender;
- (IBAction)openYourTurnView:(id)sender;

@end
