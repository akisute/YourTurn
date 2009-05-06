//
//  YTQueueTest.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import "YTQueueTest.h"
#import "YTQueue.h"
#import "YTAttendee.h"


@implementation YTQueueTest

- (void)setUp
{
//  LOG(@"setUp");
}

- (void)tearDown
{
//  LOG(@"tearDown");
    YTQueue *queue = [YTQueue newInstance];
    [queue clearSavedData];
}

- (void)testLoadWhenNoDataFileExists
{
    YTQueue *queue = [YTQueue newInstance];
    // Make sure that the queue data file doesn't exist.
    [queue clearSavedData];
    [queue load];
}

- (void)testSaveAndLoad
{
    YTQueue *queue = [YTQueue newInstance];
    int count = -1;
    count = [queue.queue count];
    STAssertEquals(count, 0, @"Queue must be empty when initially instanciated");

    [queue save];
    queue = [YTQueue newInstance];
    count = -1;

    [queue load];
    count = [queue.queue count];
    STAssertEquals(count, 0, @"Queue is still empty because saved queue was empty");
}

- (void)testSaveAddAndLoad
{
    YTQueue *queue = [YTQueue newInstance];
    YTAttendee *attendee = [[[YTAttendee alloc] init] autorelease];
    attendee.no = 1;
    attendee.name = @"Masashi Ono";
    attendee.nextDue = nil;
    attendee.hasTurn = NO;
    [queue.queue addObject:attendee];
    int count = -1;
    count = [queue.queue count];
    STAssertEquals(count, 1, @"Queue has exactly 1 data");

    [queue save];
    queue = [YTQueue newInstance];
    count = -1;

    [queue load];
    count = [queue.queue count];
    STAssertEquals(count, 1, @"Queue data is correctly loaded");
    attendee = [queue.queue objectAtIndex:0];
    STAssertEquals(attendee.no, 1, nil);
    STAssertEqualStrings(attendee.name, @"Masashi Ono", nil);
    STAssertNil(attendee.nextDue, nil);
    STAssertFalse(attendee.hasTurn, nil);
}

- (void)testSaveAddMultipulAttendeesAndSave
{
    YTQueue *queue = [YTQueue newInstance];
    YTAttendee *attendee1before = [[[YTAttendee alloc] init] autorelease];
    attendee1before.no = 1;
    attendee1before.name = @"Masashi Ono";
    attendee1before.nextDue = nil;
    attendee1before.hasTurn = NO;
    [queue.queue addObject:attendee1before];
    YTAttendee *attendee2before = [[[YTAttendee alloc] init] autorelease];
    attendee2before.no = 2;
    attendee2before.name = @"akisutesama";
    attendee2before.nextDue = nil;
    attendee2before.hasTurn = YES;
    [queue.queue addObject:attendee2before];
    YTAttendee *attendee3before = [[[YTAttendee alloc] init] autorelease];
    attendee3before.no = 3;
    attendee3before.name = @"Abesix Bakasu";
    attendee3before.nextDue = [[[NSDate alloc] init] autorelease];
    attendee3before.hasTurn = NO;
    [queue.queue addObject:attendee3before];

    int count = -1;
    count = [queue.queue count];
    STAssertEquals(count, 3, @"Queue has exactly 3 data");

    [queue save];
    queue = [YTQueue newInstance];
    count = -1;

    [queue load];
    count = [queue.queue count];
    STAssertEquals(count, 3, @"Queue data is correctly loaded");

    int delta = 1;
    YTAttendee *attendee1after = [queue.queue objectAtIndex:1-delta];
    STAssertEquals(attendee1after.no, attendee1before.no, nil);
    STAssertEqualStrings(attendee1after.name, attendee1before.name, nil);
    STAssertNil(attendee1after.nextDue, nil);
    STAssertEquals(attendee1after.hasTurn, attendee1before.hasTurn, nil);
    YTAttendee *attendee2after = [queue.queue objectAtIndex:2-delta];
    STAssertEquals(attendee2after.no, attendee2before.no, nil);
    STAssertEqualStrings(attendee2after.name, attendee2before.name, nil);
    STAssertNil(attendee2after.nextDue, nil);
    STAssertEquals(attendee2after.hasTurn, attendee2before.hasTurn, nil);
    YTAttendee *attendee3after = [queue.queue objectAtIndex:3-delta];
    STAssertEquals(attendee3after.no, attendee3before.no, nil);
    STAssertEqualStrings(attendee3after.name, attendee3before.name, nil);
    STAssertTrue([attendee3after.nextDue isEqualToDate:attendee3after.nextDue], nil);
    STAssertEquals(attendee3after.hasTurn, attendee3before.hasTurn, nil);
}

- (void)failWithException:(NSException *)e
{
    [self printError:[e reason]];
}

@end
