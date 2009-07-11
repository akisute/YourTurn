//
//  YTTextFieldCell.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTCustomCell.h"


@interface YTTextFieldCell : UITableViewCell<UITextFieldDelegate, YTCustomCell> {
    id delegate;
    UILabel *label;
    UITextField *textField;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly, retain) UILabel *label;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *placeholder;

- (IBAction)focus:(id)sender;

@end

@interface NSObject (YTTextFieldCellDelegate)
- (void)textFieldCellWillBeginEditing:(YTTextFieldCell *)aTextFieldCell;
- (void)textFieldCellWillEndEditing:(YTTextFieldCell *)aTextFieldCell;
- (void)textFieldCellWillReturn:(YTTextFieldCell *)aTextFieldCell;
- (void)textFieldCellWillChangeCharacters:(YTTextFieldCell *)aTextFieldCell;
@end
