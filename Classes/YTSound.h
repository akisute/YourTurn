//
//  YTSound.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/27.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface YTSound : NSObject {
    NSUInteger instanceId;
    NSString *soundId;
    NSString *displayName;
}

@property (nonatomic, readonly) NSUInteger instanceId;
@property (nonatomic, readonly) NSString *soundId;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, readonly) BOOL available;

- (id)initWithId:(NSString *)aSoundId;
- (void)play;
- (NSComparisonResult)compare:(YTSound *)aSound;

@end


@interface YTFileSound : YTSound {
    NSString *fileId;
    NSString *fileName;
    NSString *fileExtension;
    SystemSoundID systemSoundId;
    OSStatus status;
}

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *fileExtension;

- (id)initWithId:(NSString *)aSoundId fileName:(NSString *)aFileName fileExtension:(NSString *)aFileExtension;

@end


@interface YTVibrationSound : YTSound {
}
@end