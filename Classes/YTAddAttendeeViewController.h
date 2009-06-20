//
//  YTAddAttendeeViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTTextFieldCell;
@class YTTimePickerView;

@interface YTAddAttendeeViewController : UITableViewController {
    YTTextFieldCell *nameCell;
    YTTimePickerView *timePicker;
}

- (IBAction)done:(id)sender;

@end
