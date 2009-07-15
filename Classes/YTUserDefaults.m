//
//  YTUserDefaults.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/27.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTUserDefaults.h"


@implementation YTUserDefaults

/*! Sets up default NSUserDefaults values for the current YTUserDefaults version.
 This method does not override existing values. If you want to override any
 existing values of NSUserDefaults, use clearAndSetupDefaultValueForCurrentVersion instead.
 */
+ (void)setupDefaultValueForCurrentVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![YTUserDefaults isCurrentVersionUserDefaults])
    {
        //timePicker.initialValue
        if ([defaults integerForKey:USERDEFAULTS_TIMEPICKER_INITIALVALUE_KEY] == 0)
        {
            [defaults setInteger:USERDEFAULTS_TIMEPICKER_INITIALVALUE_DEFAULT
                          forKey:USERDEFAULTS_TIMEPICKER_INITIALVALUE_KEY];
        }
        //graphic.landscapeEnabled
        if (![defaults stringForKey:USERDEFAULTS_GRAPHIC_LANDSCAPEENABLED_KEY])
        {
            [defaults setBool:USERDEFAULTS_GRAPHIC_LANDSCAPEENABLED_DEFAULT
                       forKey:USERDEFAULTS_GRAPHIC_LANDSCAPEENABLED_KEY];
        }
        //graphic.YourTurnView
        if (![defaults stringForKey:USERDEFAULTS_GRAPHIC_YOURTURNVIEW_KEY])
        {
            [defaults setObject:USERDEFAULTS_GRAPHIC_YOURTURNVIEW_DEFAULT
                         forKey:USERDEFAULTS_GRAPHIC_YOURTURNVIEW_KEY];
        }
        //sound.turnEnd
        if (![defaults stringForKey:USERDEFAULTS_SOUND_TURNEND_KEY])
        {
            [defaults setObject:USERDEFAULTS_SOUND_TURNEND_DEFAULT
                         forKey:USERDEFAULTS_SOUND_TURNEND_KEY];
        }
        //intermission.enabled
        if (![defaults stringForKey:USERDEFAULTS_INTERMISSION_ENABLED_KEY])
        {
            [defaults setBool:USERDEFAULTS_INTERMISSION_ENABLED_DEFAULT
                       forKey:USERDEFAULTS_INTERMISSION_ENABLED_KEY];
        }
        //intermission.duration
        if ([defaults integerForKey:USERDEFAULTS_INTERMISSION_DURATION_KEY] == 0)
        {
            [defaults setInteger:USERDEFAULTS_INTERMISSION_DURATION_DEFAULT
                          forKey:USERDEFAULTS_INTERMISSION_DURATION_KEY];
        }
    }
}

/*! Clear up all NSUserDefaults value of this application, then setup its default values.
 This method force removes all current NSUserDefaults value.
 */
+ (void)clearAndSetupDefaultValueForCurrentVersion;
{
    [NSUserDefaults resetStandardUserDefaults];
    [YTUserDefaults setupDefaultValueForCurrentVersion];
}

/*! Returns YES if the current NSUserDefaults value is up to date.
 */
+ (BOOL)isCurrentVersionUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger currentVersion = [defaults integerForKey:USERDEFAULTS_VERSION_KEY];
    return currentVersion >= USERDEFAULTS_VERSION_VALUE;
}

@end
