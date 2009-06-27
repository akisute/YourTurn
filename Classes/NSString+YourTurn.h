//
//  NSString+YTAttendee.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (YourTurn)
+ (NSString *)stringHMSFormatWithAllottedTime:(NSInteger)allottedTime;
+ (NSString *)stringColonFormatWithAllottedTime:(NSInteger)allottedTime;
@end
