//
//  NSString+YTAttendee.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum _YTAllotedTimeFormat
//{
//    YTAllottedTimeHMS = 0,
//    YTAllottedTimeColon = 1,
//} YTAllotedTimeFormat;

@interface NSString (YourTurn)
//+ (NSString *)stringWithAllottedTime:(NSInteger)allottedTime format:(enum YTAllottedTimeFormat)format;
+ (NSString *)stringHMSFormatWithAllottedTime:(NSInteger)allottedTime;
+ (NSString *)stringColonFormatsWithAllottedTime:(NSInteger)allottedTime;
@end
