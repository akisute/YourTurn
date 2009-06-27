//
//  YTSwitchCell.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/26.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSwitchCell.h"


@implementation YTSwitchCell

#pragma mark properties

- (NSString *)label
{
    return label.text;
}
- (void)setLabel:(NSString *)aLabel
{
    label.text = aLabel;
}
- (BOOL)switchCondition
{
    return uiSwitch.on;
}
- (void)setSwitchCondition:(BOOL)aCondition
{
    uiSwitch.on = aCondition;
}
- (CGFloat)height
{
    return 44.0;
}

#pragma mark init, dealloc, memory management

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
    {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont boldSystemFontOfSize:16.0];
        [self addSubview:label];
        uiSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self addSubview:uiSwitch];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark TableCell method

- (void)layoutSubviews
{
    label.frame = CGRectMake(25, 12, 200, 24);
    uiSwitch.frame = CGRectMake(206, 10, 89, 27);
}

@end
