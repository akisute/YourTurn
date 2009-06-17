//
//  YTQueueTableCell.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/06.
//

#import "YTQueueTableCell.h"
#import "YTAttendee.h"
#import "NSString+YourTurn.h"  

@implementation YTQueueTableCell

#pragma mark properties

@synthesize nameLabel;
@synthesize indexLabel;
@synthesize timeLabel;

# pragma mark init, dealloc, memory management

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
    {
        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:26.0];
        self.indexLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.indexLabel.font = [UIFont systemFontOfSize:16.0];
        self.indexLabel.textColor = [UIColor colorWithHue:0.33 saturation:1.0 brightness:0.5 alpha:1.0];
        self.timeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.timeLabel.font = [UIFont fontWithName:@"Courier New" size:16.0];
        self.timeLabel.textAlignment = UITextAlignmentRight;
//        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//        self.backgroundView.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.94 alpha:1.0];

//        [self addSubview:self.nameLabel];
//        [self addSubview:self.indexLabel];
//        [self addSubview:self.timeLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.timeLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)dealloc
{
    // Do not release attendee since it's not retained
    [super dealloc];
}

#pragma mark UITableViewCell method

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    self.indexLabel.frame = CGRectMake(10.0, 2.0, 40.0, 20.0);
    self.nameLabel.frame = CGRectMake(40.0, 0, bounds.size.width, 72.0 - 1.0); // Leave a space for sparator
    self.timeLabel.frame = CGRectMake(bounds.size.width - 140.0, 50.0, 120.0, 22.0 - 1.0); // Leave a space for sparator
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

#pragma mark other method

- (void)setLabelsWithIndex:(NSUInteger)index andAttendee:(YTAttendee *)attendee
{
    self.nameLabel.text = attendee.name;
    self.indexLabel.text = [NSString stringWithFormat:@"# %d", index];
    self.timeLabel.text = [NSString stringHMSFormatWithAllottedTime:attendee.allottedTime];
    [self setNeedsDisplay];
}

@end
