//
//  NSString+YTAttendee.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/07.
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
