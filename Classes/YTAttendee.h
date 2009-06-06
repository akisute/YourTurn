//
//  YTAttendee.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import <Foundation/Foundation.h>


@interface YTAttendee : NSObject {
    NSString *name;
    NSInteger allottedTime; // in seconds
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger allottedTime;

- (id)initWithDataString:(NSString *)dataString;
- (NSString *)dataString;

@end
