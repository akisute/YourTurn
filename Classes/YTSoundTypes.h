//
//  YTSoundTypes.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/28.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTSound;

@interface YTSoundTypes : NSObject {
    NSMutableDictionary *sounds;
}

@property (nonatomic, readonly) NSArray *soundIds;
@property (nonatomic, readonly) NSUInteger count;

+ (YTSoundTypes *)instance;
+ (YTSoundTypes *)newInstance;
- (YTSound *)soundForIndex:(NSUInteger)index;
- (YTSound *)soundForId:(NSString *)fileId;
- (void)load;

@end
