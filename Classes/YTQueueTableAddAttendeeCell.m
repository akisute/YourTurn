//
//  YTQueueTableAddAttendeeCell.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTQueueTableAddAttendeeCell.h"


@implementation YTQueueTableAddAttendeeCell

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
        message = [[UILabel alloc] initWithFrame:CGRectZero];
        message.text = @"Add new attendee";
        message.font = [UIFont boldSystemFontOfSize:20.0];
        message.textColor = [UIColor blueColor];
        message.backgroundColor = [UIColor clearColor];
        message.textAlignment = UITextAlignmentCenter;
        message.opaque = NO;
        // Add subview directly under the cell itself
        [self addSubview:message];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.backgroundView.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.94 alpha:1.0];
    }
    return self;
}

- (void)dealloc
{
    [message release];
    [super dealloc];
}

#pragma mark TableCell methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    message.frame = CGRectMake(0, 0, 280, 72);
}

@end
