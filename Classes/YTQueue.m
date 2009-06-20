//
//  YTQueue.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTQueue.h"
#import "YTAttendee.h"


static YTQueue *_instance;

@interface YTQueue (Private)
- (NSString *)pathForDataFile;
@end

@implementation YTQueue

#pragma mark Properties

- (YTAttendee *)currentTurnAttendee
{
    // Validate current state and return nil when queue is empty.
    // It's possible for this method to be called when queue is empty.
    return ([queue count] == 0) ? nil : [queue objectAtIndex:0];
}

- (NSUInteger)count
{
    return [queue count];
}

#pragma mark Instanciation, deallocation

+ (YTQueue *)instance
{
    if (!_instance)
    {
        return [YTQueue newInstance];
    }
    return _instance;
}

+ (YTQueue *)newInstance
{
    if (_instance)
    {
        [_instance release];
        _instance = nil;
    }

    _instance = [[YTQueue alloc] init];
    _instance->queue = [[NSMutableArray array] retain];
    return _instance;
}

- (void)dealloc
{
    [queue release];
    [super dealloc];
}

#pragma mark Get, add, remove, rearrange attendees

- (YTAttendee *)attendeeAtIndex:(NSUInteger)index
{
    return (YTAttendee *)[queue objectAtIndex:index];
}

- (BOOL)isCurrentTurnAttendee:(YTAttendee *)anAttendee
{
    return anAttendee == self.currentTurnAttendee;
}

- (void)addAttendee:(YTAttendee *)anAttendee
{
    [queue addObject:anAttendee];
}

- (void)removeAttendee:(YTAttendee *)anAttendee
{
    [queue removeObject:anAttendee];
}

- (void)removeAttendeeAtIndex:(NSUInteger)index
{
    [queue removeObjectAtIndex:index];
}

- (void)moveAttendeeAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    // When invalid fromIndex and toIndex passed to this method, exception will be raised.
    YTAttendee *attendee = [queue objectAtIndex:fromIndex];
    [attendee retain];
    [queue removeObjectAtIndex:fromIndex];
    [queue insertObject:attendee atIndex:toIndex];
    [attendee release];
}

#pragma mark Turn managements

- (void)endCurrentTurn
{
    // Ends current turn. Move the top attendee to the bottom of the queue.
    YTAttendee *attendee = self.currentTurnAttendee;
    if (attendee)
    {
        [attendee retain];
        [queue removeObjectAtIndex:0];
        [queue addObject:attendee];
        [attendee release];
    }
}

#pragma mark Save and load queue

- (void)save
{
    NSMutableString *buffer = [NSMutableString string];
    for (YTAttendee *attendee in queue)
    {
        LOG(@"Parsing attendee object %p into the data string...", attendee);
        [buffer appendString:[attendee dataString]];
        [buffer appendString:@"\n"];
    }
    LOG(@"Saving queue data string: %@", buffer);
    //[buffer writeToFile:_YTQUEUE_DATA_FILE_NAME atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    NSData *data = [buffer dataUsingEncoding:NSUTF8StringEncoding];
    BOOL result = [[NSFileManager defaultManager] createFileAtPath:[self pathForDataFile] contents:data attributes:nil];
    LOG(@"Saving finished. Result code is %d.", result);
}

- (void)load
{
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[self pathForDataFile]];
    LOG(@"Finding queue data from disk. Result code is %d.", isExist);
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:[self pathForDataFile]];
    NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    //NSString *str = [NSString stringWithContentsOfFile:_YTQUEUE_DATA_FILE_NAME encoding:NSUTF8StringEncoding error:NULL];
    LOG(@"Loading queue data string: %@", str);
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    for (NSString *substr in array)
    {
        if ([@"" isEqualToString:[substr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
        {
            continue;
        }
        LOG(@"Parsing the data string %@ into the attendee object...", substr);
        YTAttendee *attendee = [[[YTAttendee alloc] initWithDataString:substr] autorelease];
        if (attendee)
        {
            [queue addObject:attendee];
        }
    }
}

- (void)clearSavedData
{
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForDataFile] error:nil];
}

#pragma mark Private method

- (NSString *)pathForDataFile
{
    return [NSString stringWithFormat:@"%@/Documents/queue.dat", NSHomeDirectory()];
}

@end
