//
//  YTSelectionCell.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/26.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTCustomCell.h"


@interface YTSelectionCell : UITableViewCell<YTCustomCell> {
    UILabel *label;
    UILabel *selectionLabel;
}

@property (nonatomic, readonly, retain) UILabel *label;
@property (nonatomic, readonly, retain) UILabel *selectionLabel;

@end
