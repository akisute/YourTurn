//
//  YTQueueTableCell.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTCustomCell.h"

@class YTAttendee;

@interface YTQueueTableCell : UITableViewCell<YTCustomCell> {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *indexLabel;
    IBOutlet UILabel *timeLabel;
}

- (void)setLabelsWithIndex:(NSUInteger)index andAttendee:(YTAttendee *)attendee;

@end
