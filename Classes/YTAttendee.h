//
//  YTAttendee.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
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
