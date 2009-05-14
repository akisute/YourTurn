//
//  YTTextFieldCell.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/06.
//

#import <UIKit/UIKit.h>


@interface YTTextFieldCell : UITableViewCell<UITextFieldDelegate> {
    UILabel *label;
    UITextField *textField;
}

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, readonly) CGFloat height;

// TODO: create a delegate-like system for callback when Return key is pressed
- (IBAction)focus:(id)sender;

@end
