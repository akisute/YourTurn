//
//  YTUserDefaults.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/27.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <Foundation/Foundation.h>

// Increment USERDEFAULTS_VERSION_VALUE when you add, modify, or remove any
// NSUserDefaults value for this application.
#define USERDEFAULTS_VERSION_VALUE 2
#define USERDEFAULTS_VERSION_KEY @"userDefaults.version"
#define USERDEFAULTS_TIMEPICKER_INITIALVALUE_KEY @"timePicker.initialValue"
#define USERDEFAULTS_TIMEPICKER_INITIALVALUE_DEFAULT 300
#define USERDEFAULTS_GRAPHIC_LANDSCAPEENABLED_KEY @"graphic.landscapeEnabled"
#define USERDEFAULTS_GRAPHIC_LANDSCAPEENABLED_DEFAULT YES
#define USERDEFAULTS_GRAPHIC_YOURTURNVIEW_KEY @"graphic.YourTurnView" //not used yet
#define USERDEFAULTS_GRAPHIC_YOURTURNVIEW_DEFAULT @"Gradation"        //not used yet
#define USERDEFAULTS_SOUND_TURNEND_KEY @"sound.turnEnd"
#define USERDEFAULTS_SOUND_TURNEND_DEFAULT @"Bell"
#define USERDEFAULTS_INTERMISSION_ENABLED_KEY @"intermission.enabled"
#define USERDEFAULTS_INTERMISSION_ENABLED_DEFAULT NO
#define USERDEFAULTS_INTERMISSION_DURATION_KEY @"intermission.duration"
#define USERDEFAULTS_INTERMISSION_DURATION_DEFAULT 60

@interface YTUserDefaults : NSObject {
}

+ (void)setupDefaultValueForCurrentVersion;
+ (void)clearAndSetupDefaultValueForCurrentVersion;
+ (BOOL)isCurrentVersionUserDefaults;

@end
