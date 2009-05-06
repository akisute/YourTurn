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

- (IBAction)focus:(id)sender;

@end
