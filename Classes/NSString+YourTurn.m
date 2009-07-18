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
        return [NSString stringWithFormat:NSLocalizedString(@"%dh %dm %ds", @"Time format string (HMS)"),
                hour,
                minute,
                second];
    }
    else if (minute > 0)
    {
        return [NSString stringWithFormat:NSLocalizedString(@"%dm %ds", @"Time format string (HMS)"),
                minute,
                second];
    }
    else
    {
        return [NSString stringWithFormat:NSLocalizedString(@"%ds", @"Time format string (HMS)"),
                second];
    }
}

+ (NSString *)stringHMSShortFormatWithAllottedTime:(NSInteger)allottedTime
{
    NSInteger hour = (NSInteger)(allottedTime / 3600);
    NSInteger minute = (NSInteger)(allottedTime % 3600 / 60);
    NSInteger second = (allottedTime % 3600 % 60);
    if (hour > 0)
    {
        if (minute == 0 && second == 0)
        {
            return [NSString stringWithFormat:NSLocalizedString(@"%dh", @"Time format string (HMS)"),
                    hour];
        }
        else if (minute == 0)
        {
            return [NSString stringWithFormat:NSLocalizedString(@"%dh %ds", @"Time format string (HMS)"),
                    hour,
                    second];
        }
        else if (second == 0)
        {
            return [NSString stringWithFormat:NSLocalizedString(@"%dh %dm", @"Time format string (HMS)"),
                    hour,
                    minute];
        }
        else
        {
            return [NSString stringWithFormat:NSLocalizedString(@"%dh %dm %ds", @"Time format string (HMS)"),
                    hour,
                    minute,
                    second];
        }
    }
    else if (minute > 0)
    {
        if (second == 0)
        {
            return [NSString stringWithFormat:NSLocalizedString(@"%dm", @"Time format string (HMS)"),
                    minute];
        }
        else
        {
            return [NSString stringWithFormat:NSLocalizedString(@"%dm %ds", @"Time format string (HMS)"),
                    minute,
                    second];
        }
    }
    else
    {
        return [NSString stringWithFormat:NSLocalizedString(@"%ds", @"Time format string (HMS)"),
                second];
    }
}

+ (NSString *)stringColonFormatWithAllottedTime:(NSInteger)allottedTime
{
    NSInteger hour = (NSInteger)(allottedTime / 3600);
    NSInteger minute = (NSInteger)(allottedTime % 3600 / 60);
    NSInteger second = (allottedTime % 3600 % 60);
    if (hour > 0)
    {
        return [NSString stringWithFormat:NSLocalizedString(@"%d:%02d:%02d", @"Time format string (Colon)"),
                hour,
                minute,
                second];
    }
    else if (minute > 0)
    {
        return [NSString stringWithFormat:NSLocalizedString(@"%d:%02d", @"Time format string (Colon)"),
                minute,
                second];
    }
    else
    {
        return [[NSNumber numberWithInteger:allottedTime] stringValue];
    }
}

@end