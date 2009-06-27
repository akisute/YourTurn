//
//  YTQueue.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTAttendee;

@interface YTQueue : NSObject {
    NSMutableArray *queue;
}

@property (nonatomic, readonly) YTAttendee *currentTurnAttendee;
@property (nonatomic, readonly) YTAttendee *nextTurnAttendee;
@property (nonatomic, readonly) NSUInteger count;

+ (YTQueue *)instance;
+ (YTQueue *)newInstance;
- (BOOL)isCurrentTurnAttendee:(YTAttendee *)anAttendee;
- (YTAttendee *)attendeeAtIndex:(NSUInteger)index;
- (void)addAttendee:(YTAttendee *)anAttendee;
- (void)removeAttendee:(YTAttendee *)anAttendee;
- (void)removeAttendeeAtIndex:(NSUInteger)index;
- (void)moveAttendeeAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)endCurrentTurn;
- (void)save;
- (void)load;
- (void)clearSavedData;

@end
