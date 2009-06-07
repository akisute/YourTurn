//
//  NSString+YTAttendee.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/07.
//

#import "NSString+YourTurn.h"


@implementation NSString (YourTurn)

//+ (NSString *)stringWithAllottedTime:(NSInteger)allottedTime format:(enum YTAllottedTimeFormat)format
//{
//    NSInteger hour = (NSInteger)(allottedTime / 3600);
//    NSInteger minute = (NSInteger)(allottedTime % 3600 / 60);
//    NSInteger second = (allottedTime % 3600 % 60);
//    if (hour > 0)
//    {
//        switch (format) {
//        case YTAllottedTimeHMS:
//            return [NSString stringWithFormat:@"%dh %dm %ds", hour, minute, second];
//        case YTAllottedTimeColon:
//            return [NSString stringWithFormat:@"%d:%d:%d", hour, minute, second];
//        default:
//            // return the raw value
//            return [[NSNumber numberWithInteger:allottedTime] stringValue];
//        }
//    }
//    else if (minute > 0)
//    {
//        switch (format) {
//        case YTAllottedTimeHMS:
//            return [NSString stringWithFormat:@"%dm %ds", minute, second];
//        case YTAllottedTimeColon:
//            return [NSString stringWithFormat:@"%d:%d", minute, second];
//        default:
//            // return the raw value
//            return [[NSNumber numberWithInteger:allottedTime] stringValue];
//        }
//    }
//    else
//    {
//        switch (format) {
//        case YTAllottedTimeHMS:
//            return [NSString stringWithFormat:@"%ds", second];
//        case YTAllottedTimeColon:
//            return [[NSNumber numberWithInteger:second] stringValue];
//        default:
//            // return the raw value
//            return [[NSNumber numberWithInteger:allottedTime] stringValue];
//        }
//    }
//}

+ (NSString *)stringHMSFormatWithAllottedTime:(NSInteger)allottedTime
{
    NSInteger hour = (NSInteger)(allottedTime / 3600);
    NSInteger minute = (NSInteger)(allottedTime % 3600 / 60);
    NSInteger second = (allottedTime % 3600 % 60);
    if (hour > 0)
    {
        return [NSString stringWithFormat:@"%dh %dm %ds", hour, minute, second];
    }
    else if (minute > 0)
    {
        return [NSString stringWithFormat:@"%dm %ds", minute, second];
    }
    else
    {
        return [NSString stringWithFormat:@"%ds", second];
    }
}

+ (NSString *)stringColonFormatsWithAllottedTime:(NSInteger)allottedTime
{
    NSInteger hour = (NSInteger)(allottedTime / 3600);
    NSInteger minute = (NSInteger)(allottedTime % 3600 / 60);
    NSInteger second = (allottedTime % 3600 % 60);
    if (hour > 0)
    {
        return [NSString stringWithFormat:@"%d:%d:%d", hour, minute, second];
    }
    else if (minute > 0)
    {
        return [NSString stringWithFormat:@"%d:%d", minute, second];
    }
    else
    {
        return [[NSNumber numberWithInteger:allottedTime] stringValue];
    }
}

@end