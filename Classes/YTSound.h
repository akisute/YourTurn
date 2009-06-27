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
    NSString *fileId;
    NSString *fileName;
    NSString *fileExtension;
    SystemSoundID soundId;
}

@property (nonatomic, readonly) NSString *fileId;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *fileExtension;

- (id)initWithId:(NSString *)aSoundId fileName:(NSString *)aFileName fileExtension:(NSString *)aFileExtension;
- (void)play;

@end
