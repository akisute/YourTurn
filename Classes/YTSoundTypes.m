//
//  YTSoundTypes.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/28.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSoundTypes.h"
#import "YTSound.h"


static YTSoundTypes *_instance;

@implementation YTSoundTypes

#pragma mark properties

- (NSArray *)soundIds
{
    return [sounds keysSortedByValueUsingSelector:@selector(compare:)];
}
- (NSUInteger)count
{
    return [sounds count];
}

#pragma mark Instanciation, deallocation

+ (YTSoundTypes *)instance
{
    if (!_instance)
    {
        return [YTSoundTypes newInstance];
    }
    return _instance;
}

+ (YTSoundTypes *)newInstance
{
    if (_instance)
    {
        [_instance release];
        _instance = nil;
    }
    
    _instance = [[YTSoundTypes alloc] init];
    _instance->sounds = [[NSMutableDictionary dictionary] retain];
    return _instance;
}

- (void)dealloc
{
    [sounds release];
    [super dealloc];
}

#pragma mark add, remove, get sounds

- (YTSound *)soundForIndex:(NSUInteger)index
{
    NSString *soundId = [self.soundIds objectAtIndex:index];
    return (YTSound *)[self soundForId:soundId];
}

- (YTSound *)soundForId:(NSString *)fileId
{
    return (YTSound *)[sounds objectForKey:fileId];
}

- (void)load
{
    YTSound *sound = nil;
    
    //None
    sound = [[[YTSound alloc] initWithId:@"None"] autorelease];
    sound.displayName = NSLocalizedString(@"None", @"Display name of a sound object");
    [sounds setObject:sound forKey:sound.soundId];
    
    //Vibration
    sound = [[[YTVibrationSound alloc] initWithId:@"Vibration"] autorelease];
    sound.displayName = NSLocalizedString(@"Vibration", @"Display name of a sound object");
    [sounds setObject:sound forKey:sound.soundId];
    
    //bell.aif
    sound = [[[YTFileSound alloc] initWithId:@"Bell"
                                fileName:@"bell"
                           fileExtension:@"aif"] autorelease];
    sound.displayName = NSLocalizedString(@"Bell", @"Display name of a sound object");
    [sounds setObject:sound forKey:sound.soundId];
    
    //gong.aif
    sound = [[[YTFileSound alloc] initWithId:@"Gong"
                                fileName:@"gong"
                           fileExtension:@"aif"] autorelease];
    sound.displayName = NSLocalizedString(@"Gong", @"Display name of a sound object");
    [sounds setObject:sound forKey:sound.soundId];
    
    //ring.aif
    sound = [[[YTFileSound alloc] initWithId:@"Ring"
                                fileName:@"ring"
                           fileExtension:@"aif"] autorelease];
    sound.displayName = NSLocalizedString(@"Ring (single)", @"Display name of a sound object");
    [sounds setObject:sound forKey:sound.soundId];
    
    //ring_double.aif
    sound = [[[YTFileSound alloc] initWithId:@"Double Ring"
                                fileName:@"ring_double"
                           fileExtension:@"aif"] autorelease];
    sound.displayName = NSLocalizedString(@"Ring (double)", @"Display name of a sound object");
    [sounds setObject:sound forKey:sound.soundId];
}

@end
