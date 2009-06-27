//
//  YTSound.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/27.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSound.h"


@implementation YTSound

@synthesize fileId;
@synthesize fileName;
@synthesize fileExtension;

- (id)initWithId:(NSString *)aFileId fileName:(NSString *)aFileName fileExtension:(NSString *)aFileExtension
{
    if (self = [super init])
    {
        fileId = [aFileId retain];
        fileName = [aFileName retain];
        fileExtension = [aFileExtension retain];
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
        NSURL *audioURL = [NSURL fileURLWithPath:audioPath];
        LOG(@"Creating the sound object from file: %d", audioURL);
        OSStatus status = AudioServicesCreateSystemSoundID((CFURLRef)audioURL, &soundId);
        LOG(@"AudioServicesCreateSystemSoundID result=%d", status);
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

- (void)play
{
    AudioServicesPlaySystemSound(soundId);
}

@end
