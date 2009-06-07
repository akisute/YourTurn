//
//  YTQueueTableCell.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/06.
//

#import <UIKit/UIKit.h>

@class YTAttendee;

@interface YTQueueTableCell : UITableViewCell {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *indexLabel;
    IBOutlet UILabel *timeLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *indexLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

- (void)setLabelsWithIndex:(NSUInteger)index andAttendee:(YTAttendee *)attendee;

@end
