//
//  YTQueueTableTopCell.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/06.
//

#import "YTQueueTableAddAttendeeCell.h"


@implementation YTQueueTableAddAttendeeCell

# pragma mark init, dealloc, memory management

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
        // TODO: initialize code for addattendee cell
//        self.text = @"Add new attendee";
//        self.textAlignment = ;
//        self.font = [UIFont systemFontSize];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
# pragma mark TableCell method

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
