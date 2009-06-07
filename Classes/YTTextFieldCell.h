//
//  YTTextFieldCell.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/06.
//

#import <UIKit/UIKit.h>


@interface YTTextFieldCell : UITableViewCell<UITextFieldDelegate> {
    id delegate;
    UILabel *label;
    UITextField *textField;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, readonly) CGFloat height;

- (IBAction)focus:(id)sender;

@end

@interface NSObject (YTTextFieldCellDelegate)
- (void)textFieldCellWillBeginEditing:(YTTextFieldCell *)aTextFieldCell;
- (void)textFieldCellWillEndEditing:(YTTextFieldCell *)aTextFieldCell;
- (void)textFieldCellWillReturn:(YTTextFieldCell *)aTextFieldCell;
- (void)textFieldCellWillChangeCharacters:(YTTextFieldCell *)aTextFieldCell;
@end
