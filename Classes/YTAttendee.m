//
//  YTAttendee.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTAttendee.h"


@implementation YTAttendee

@synthesize name;
@synthesize allottedTime;

// TODO: json format, initWithJSON:jsonString
- (id)initWithDataString:(NSString *)dataString
{
    if (self = [super init])
    {
        NSArray *array = [dataString componentsSeparatedByString:@","];
        if ([array count] == 3)
        {
            NSString *strName = [array objectAtIndex:0];
            NSString *strAllottedTime = [array objectAtIndex:1];
            self.name = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.allottedTime = [[strAllottedTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
        }
        else
        {
            LOG(@"initFromDataString failed. Invalid dataString format:%@", dataString);
            return nil;
        }
    }
    return self; 
}

- (NSString *)dataString
{
    // dataString format is like this:
    // -------------------------------
    //   Masashi Ono, 180, 
    //   akisute, 100, 
    //   abesix bakasu, 300,
    // -------------------------------
    NSString *dataString = [NSString stringWithFormat:@"%@, %d, ", self.name, self.allottedTime];
    return dataString;
}
@end
