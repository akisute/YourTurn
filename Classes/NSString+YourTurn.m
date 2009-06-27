//
//  NSString+YTAttendee.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "NSString+YourTurn.h"


@implementation NSString (YourTurn)

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

+ (NSString *)stringColonFormatWithAllottedTime:(NSInteger)allottedTime
{
    NSInteger hour = (NSInteger)(allottedTime / 3600);
    NSInteger minute = (NSInteger)(allottedTime % 3600 / 60);
    NSInteger second = (allottedTime % 3600 % 60);
    if (hour > 0)
    {
        return [NSString stringWithFormat:@"%d:%02d:%02d", hour, minute, second];
    }
    else if (minute > 0)
    {
        return [NSString stringWithFormat:@"%d:%02d", minute, second];
    }
    else
    {
        return [[NSNumber numberWithInteger:allottedTime] stringValue];
    }
}

@end