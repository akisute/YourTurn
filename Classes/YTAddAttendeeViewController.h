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
@class YTAttendee;

@interface YTAddAttendeeViewController : UITableViewController {
    YTTextFieldCell *nameCell;
    YTTimePickerView *timePicker;
    YTAttendee *editingAttendee;
}

- (id)initWithNibName:(NSString *)nibNameOrNill bundle:(NSBundle *)nibBundleOrNill attendee:(YTAttendee *)anAttendeeOrNil;
- (IBAction)done:(id)sender;

@end
