//
//  YTSetIntervalViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/27.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTSwitchCell;
@class YTTimePickerView;

@interface YTSetIntervalViewController : UITableViewController {
    YTSwitchCell *enableCell;
    YTTimePickerView *timePicker;
}

@end
