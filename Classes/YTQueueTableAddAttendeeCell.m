//
//  YTQueueTableAddAttendeeCell.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/06.
//

#import "YTQueueTableAddAttendeeCell.h"


@implementation YTQueueTableAddAttendeeCell

@synthesize message;
// TODO: create a height property, and YTCustomCell protocol with a height property

# pragma mark init, dealloc, memory management

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
    {
        // TODO: move layouting to the layoutSubviews method
        self.message = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 72)] autorelease];
        self.message.text = @"Add new attendee";
        self.message.font = [UIFont boldSystemFontOfSize:20.0];
        self.message.textColor = [UIColor blueColor];
        self.message.backgroundColor = [UIColor clearColor];
        self.message.textAlignment = UITextAlignmentCenter;
        self.message.opaque = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.backgroundView.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.94 alpha:1.0];
        // Add subview directly under the cell itself
        [self addSubview:self.message];
    }
    return self;
}

- (void)dealloc
{
    [message release];
    [super dealloc];
}

@end
