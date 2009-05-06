//
//  YTAttendee.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import <Foundation/Foundation.h>


@interface YTAttendee : NSObject {
    NSString *name;
}

@property (nonatomic, retain) NSString *name;

- (id)initWithDataString:(NSString *)dataString;
- (NSString *)dataString;

@end
