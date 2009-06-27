//
//  YTQueueTableCell.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTQueueTableCell.h"
#import "YTAttendee.h"
#import "NSString+YourTurn.h"  

@implementation YTQueueTableCell

#pragma mark properties

- (CGFloat)height
{
    return 72.0;
}

# pragma mark init, dealloc, memory management

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
    {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = [UIFont boldSystemFontOfSize:26.0];
        indexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        indexLabel.font = [UIFont systemFontOfSize:16.0];
        indexLabel.textColor = [UIColor colorWithHue:0.33 saturation:1.0 brightness:0.5 alpha:1.0];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.font = [UIFont fontWithName:@"Courier New" size:16.0];
        timeLabel.textAlignment = UITextAlignmentRight;

        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:indexLabel];
        [self.contentView addSubview:timeLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)dealloc
{
    // Do not release attendee since it's not retained
    [nameLabel release];
    [indexLabel release];
    [timeLabel release];
    [super dealloc];
}

#pragma mark UITableViewCell method

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    indexLabel.frame = CGRectMake(10.0, 2.0, 40.0, 20.0);
    nameLabel.frame = CGRectMake(40.0, 0, bounds.size.width, 72.0 - 1.0); // Leave a space for sparator
    timeLabel.frame = CGRectMake(bounds.size.width - 140.0, 50.0, 120.0, 22.0 - 1.0); // Leave a space for sparator
}

#pragma mark other method

- (void)setLabelsWithIndex:(NSUInteger)index andAttendee:(YTAttendee *)attendee
{
    nameLabel.text = attendee.name;
    indexLabel.text = [NSString stringWithFormat:@"# %d", index];
    timeLabel.text = [NSString stringHMSFormatWithAllottedTime:attendee.allottedTime];
    [self setNeedsDisplay];
}

@end
