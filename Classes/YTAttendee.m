//
//  YTAttendee.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import "YTAttendee.h"


@implementation YTAttendee

@synthesize name;

- (id)initWithDataString:(NSString *)dataString
{
    if (self = [super init])
    {
        NSArray *array = [dataString componentsSeparatedByString:@","];
        if ([array count] == 2)
        {
            NSString *strName = [array objectAtIndex:0];
            self.name = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    //   Masashi Ono,
    //   akisute,
    //   abesix bakasu,
    // -------------------------------
    NSString *dataString = [NSString stringWithFormat:@"%@, ", self.name];
    return dataString;
}
@end
