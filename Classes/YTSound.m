//
//  YTSound.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/27.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSound.h"


static NSUInteger _instanceCount = 0;

@implementation YTSound

#pragma mark properties

@synthesize instanceId;
@synthesize fileId;
@synthesize fileName;
@synthesize fileExtension;
@synthesize displayName;

- (NSString *)displayName
{
    // Use fileId instead of displayName if no displayName is available
    return (displayName) ? displayName : fileId;
}

#pragma mark init, dealloc, memory management

- (id)initWithId:(NSString *)aFileId fileName:(NSString *)aFileName fileExtension:(NSString *)aFileExtension
{
    if (self = [super init])
    {
        instanceId = _instanceCount++;
        fileId = [aFileId retain];
        fileName = [aFileName retain];
        fileExtension = [aFileExtension retain];
        if (fileName && fileExtension)
        {
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
            NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
            LOG(@"Creating the sound object from file: %d", audioURL);
            OSStatus status = AudioServicesCreateSystemSoundID((CFURLRef)audioURL, &soundId);
            LOG(@"AudioServicesCreateSystemSoundID result=%d", status);
        }
    }
    return self;
}

- (void)dealloc
{
    [fileId release];
    [fileName release];
    [fileExtension release];
    [super dealloc];
}

#pragma mark other methods

- (void)play
{
    AudioServicesPlaySystemSound(soundId);
}

- (NSComparisonResult)compare:(YTSound *)aSound
{
    if (self.instanceId < aSound.instanceId)
    {
        return NSOrderedAscending;
    }
    else if (self.instanceId == aSound.instanceId)
    {
        return NSOrderedSame;
    }
    else
    {
        return NSOrderedDescending;
    }
}

@end
