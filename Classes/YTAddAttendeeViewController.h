//
//  YTAddAttendeeViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/05.
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
