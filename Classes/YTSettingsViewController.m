//
//  YTSettingsViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/26.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSettingsViewController.h"
#import "YTSetSoundTurnEndViewController.h"
#import "YTSetIntervalViewController.h"
#import "YTSwitchCell.h"
#import "YTSelectionCell.h"
#import "YTUserDefaults.h"
#import "YTSound.h"
#import "YTSoundTypes.h"
#import "NSString+YourTurn.h"

#define _REUSE_IDENTIFIER_SELECTION @"YTSelectionCell"
#define _REUSE_IDENTIFIER_SWITCH @"YTSwitchCell"
#define _SECTION_GRAPHICS 0
#define _SECTION_SOUND 1
#define _SECTION_INTERMISSION 2
#define _CELL_GRAPHICS_ENABLELANDSCAPEMODE 0
#define _CELL_SOUND_TURNEND_SETTINGS 0
#define _CELL_INTERMISSION_SETTINGS 0


@implementation YTSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = YES;
    self.tableView.allowsSelectionDuringEditing = NO;
    // TODO: Selection will be broken up when scrollEnabled = NO due to the bug of the OS 3.0.
    //    self.tableView.scrollEnabled = NO;
    //    self.tableView.canCancelContentTouches = NO;
    //    self.tableView.delaysContentTouches = NO;
    self.title = NSLocalizedString(@"Settings", @"Title of the settings view");
    enableLandscapeModeCell = [[YTSwitchCell alloc] initWithFrame:CGRectZero
                                                  reuseIdentifier:_REUSE_IDENTIFIER_SWITCH];
    soundTurnEndSettingsCell = [[YTSelectionCell alloc] initWithFrame:CGRectZero
                                               reuseIdentifier:_REUSE_IDENTIFIER_SELECTION];
    intermissionSettingsCell = [[YTSelectionCell alloc] initWithFrame:CGRectZero
                                                      reuseIdentifier:_REUSE_IDENTIFIER_SELECTION];
}

- (void)dealloc
{
    [enableLandscapeModeCell release];
    [soundTurnEndSettingsCell release];
    [intermissionSettingsCell release];
    [super dealloc];
}

#pragma mark ViewController methods

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Unselect any selections
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Save current settings of cells
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enableLandscapeModeCell.switchCondition forKey:USERDEFAULTS_GRAPHIC_LANDSCAPEENABLED_KEY];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_GRAPHICS:
            return 1;
        case _SECTION_SOUND:
            return 1;
        case _SECTION_INTERMISSION:
            return 1;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_GRAPHICS:
            return NSLocalizedString(@"Graphics", @"Section header of the settings view");
        case _SECTION_SOUND:
            return NSLocalizedString(@"Sound", @"Section header of the settings view");
        case _SECTION_INTERMISSION:
            return NSLocalizedString(@"Intermission", @"Section header of the settings view");
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = NO;
    NSString *string = nil;
    switch (indexPath.section) {
        case _SECTION_GRAPHICS:
            enabled = [defaults boolForKey:USERDEFAULTS_GRAPHIC_LANDSCAPEENABLED_KEY];
            enableLandscapeModeCell.label.text = NSLocalizedString(@"Enable landscape", @"Cell text of the settings view");
            enableLandscapeModeCell.switchCondition = enabled;
            return enableLandscapeModeCell;
        case _SECTION_SOUND:
            string = [[YTSoundTypes instance] soundForId:[defaults stringForKey:USERDEFAULTS_SOUND_TURNEND_KEY]].displayName;
            soundTurnEndSettingsCell.label.text = NSLocalizedString(@"Sound", @"Cell text of the settings view");
            soundTurnEndSettingsCell.selectionLabel.text = string;
            return soundTurnEndSettingsCell;
        case _SECTION_INTERMISSION:
            enabled = [defaults boolForKey:USERDEFAULTS_INTERMISSION_ENABLED_KEY];
            string = (enabled)
            ? [NSString stringHMSFormatWithAllottedTime:[defaults integerForKey:USERDEFAULTS_INTERMISSION_DURATION_KEY]]
            : NSLocalizedString(@"OFF", @"On / Off.");
            intermissionSettingsCell.label.text = NSLocalizedString(@"Intermission", @"Cell text of the settings view");
            intermissionSettingsCell.selectionLabel.text = string;
            return intermissionSettingsCell;
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    switch (indexPath.section) {
        case _SECTION_INTERMISSION:
            viewController = [[YTSetIntervalViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        case _SECTION_SOUND:
            viewController = [[YTSetSoundTurnEndViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        default:
            break;
    }
}

@end