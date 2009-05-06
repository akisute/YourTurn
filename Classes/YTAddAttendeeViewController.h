//
//  YTAddAttendeeViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/05.
//

#import <UIKit/UIKit.h>

@class YTTextFieldCell;

@interface YTAddAttendeeViewController : UITableViewController {
    YTTextFieldCell *nameCell;
}

- (IBAction)done:(id)sender;

@end
