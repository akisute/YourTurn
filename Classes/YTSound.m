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

@synthesize instanceId;
@synthesize soundId;
@synthesize displayName;

- (NSString *)displayName
{
    return (displayName) ? displayName : soundId;
}

- (id)initWithId:(NSString *)aSoundId
{
    if (self = [super init])
    {
        instanceId = _instanceCount++;
        soundId = [aSoundId retain];
        displayName = nil;
    }
    return self;
}

- (void)dealloc
{
    [displayName release];
    [soundId release];
    [super dealloc];
}

/*! Override this method to play the sound */
- (void)play
{
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


@implementation YTFileSound

@synthesize fileName;
@synthesize fileExtension;

- (id)initWithId:(NSString *)aSoundId fileName:(NSString *)aFileName fileExtension:(NSString *)aFileExtension
{
    if (self = [super initWithId:aSoundId])
    {
        fileName = [aFileName retain];
        fileExtension = [aFileExtension retain];
        if (fileName && fileExtension)
        {
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
            NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
            LOG(@"Creating the sound object from file: %d", audioURL);
            OSStatus status = AudioServicesCreateSystemSoundID((CFURLRef)audioURL, &systemSoundId);
            LOG(@"AudioServicesCreateSystemSoundID result=%d", status);
        }
    }
    return self;
}

- (void)dealloc
{
    [fileName release];
    [fileExtension release];
    [super dealloc];
}

- (void)play
{
    AudioServicesPlaySystemSound(systemSoundId);
}

@end


@implementation YTVibrationSound

- (void)play
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
