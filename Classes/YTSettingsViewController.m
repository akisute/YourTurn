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
#import "YTSetIntermissionViewController.h"
#import "YTSetFirstBellViewController.h"
#import "YTSetSoundFirstBellViewController.h"
#import "YTSwitchCell.h"
#import "YTSelectionCell.h"
#import "YTUserDefaults.h"
#import "YTSound.h"
#import "YTSoundTypes.h"
#import "NSString+YourTurn.h"

#define _REUSE_IDENTIFIER_SELECTION @"YTSelectionCell"
#define _REUSE_IDENTIFIER_SWITCH @"YTSwitchCell"
#define _SECTION_SESSION 0
#define _SECTION_INTERMISSION 1
#define _SECTION_FIRSTBELL 2
#define _CELL_SESSION_ENABLELANDSCAPEMODE 0
#define _CELL_SESSION_SOUND_TURNEND_SETTINGS 1
#define _CELL_INTERMISSION_SETTINGS 0
#define _CELL_FIRSTBELL_SETTINGS 0
#define _CELL_FIRSTBELL_SOUND_SETTINGS 1


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
    firstBellSettingsCell = [[YTSelectionCell alloc] initWithFrame:CGRectZero
                                                   reuseIdentifier:_REUSE_IDENTIFIER_SELECTION];
    soundFirstBellSettingsCell = [[YTSelectionCell alloc] initWithFrame:CGRectZero
                                                        reuseIdentifier:_REUSE_IDENTIFIER_SELECTION];
}

- (void)dealloc
{
    [enableLandscapeModeCell release];
    [soundTurnEndSettingsCell release];
    [intermissionSettingsCell release];
    [firstBellSettingsCell release];
    [soundFirstBellSettingsCell release];
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
    [defaults setBool:enableLandscapeModeCell.switchCondition forKey:USERDEFAULTS_SESSION_LANDSCAPEENABLED_KEY];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_SESSION:
            return 2;
        case _SECTION_INTERMISSION:
            return 1;
        case _SECTION_FIRSTBELL:
            return 2;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_SESSION:
            return NSLocalizedString(@"Session", @"Section header of the settings view");
        case _SECTION_INTERMISSION:
            return NSLocalizedString(@"Intermission", @"Section header of the settings view");
        case _SECTION_FIRSTBELL:
            return NSLocalizedString(@"First bell", @"Section header of the settings view");
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
        case _SECTION_SESSION:
            switch (indexPath.row) {
                case _CELL_SESSION_ENABLELANDSCAPEMODE:
                    enabled = [defaults boolForKey:USERDEFAULTS_SESSION_LANDSCAPEENABLED_KEY];
                    enableLandscapeModeCell.label.text = NSLocalizedString(@"Enable rotation", @"Cell text of the settings view");
                    enableLandscapeModeCell.switchCondition = enabled;
                    return enableLandscapeModeCell;
                case _CELL_SESSION_SOUND_TURNEND_SETTINGS:
                    string = [[YTSoundTypes instance] soundForId:[defaults stringForKey:USERDEFAULTS_SESSION_SOUND_TURNEND_KEY]].displayName;
                    soundTurnEndSettingsCell.label.text = NSLocalizedString(@"Turn end sound", @"Cell text of the settings view");
                    soundTurnEndSettingsCell.selectionLabel.text = string;
                    return soundTurnEndSettingsCell;
                default:
                    return nil;
            }
            break;
        case _SECTION_INTERMISSION:
            switch (indexPath.row) {
                case _CELL_INTERMISSION_SETTINGS:
                    enabled = [defaults boolForKey:USERDEFAULTS_INTERMISSION_ENABLED_KEY];
                    string = (enabled)
                    ? [NSString stringHMSFormatWithAllottedTime:[defaults integerForKey:USERDEFAULTS_INTERMISSION_DURATION_KEY]]
                    : NSLocalizedString(@"OFF", @"On / Off.");
                    intermissionSettingsCell.label.text = NSLocalizedString(@"Intermission", @"Cell text of the settings view");
                    intermissionSettingsCell.selectionLabel.text = string;
                    return intermissionSettingsCell;
                default:
                    return nil;;
            }
            break;
        case _SECTION_FIRSTBELL:
            switch (indexPath.row) {
                case _CELL_FIRSTBELL_SETTINGS:
                    enabled = [defaults boolForKey:USERDEFAULTS_FIRSTBELL_ENABLED_KEY];
                    if (enabled)
                    {
                        string = [NSString stringHMSShortFormatWithAllottedTime:[defaults integerForKey:USERDEFAULTS_FIRSTBELL_TIMER_BEFORETURNEND_KEY]];
                        string = [NSString stringWithFormat:NSLocalizedString(@"%@ before",
                                                                              @"Cell text of the settings view"), string];
                    }
                    else
                    {
                        string = NSLocalizedString(@"OFF", @"On / Off.");
                    }
                    firstBellSettingsCell.label.text = NSLocalizedString(@"First bell", @"Cell text of the settings view");
                    firstBellSettingsCell.selectionLabel.text = string;
                    return firstBellSettingsCell;
                case _CELL_FIRSTBELL_SOUND_SETTINGS:
                    string = [[YTSoundTypes instance] soundForId:[defaults stringForKey:USERDEFAULTS_FIRSTBELL_SOUND_KEY]].displayName;
                    soundFirstBellSettingsCell.label.text = NSLocalizedString(@"First bell sound", @"Cell text of the settings view");
                    soundFirstBellSettingsCell.selectionLabel.text = string;
                    return soundFirstBellSettingsCell;
                default:
                    return nil;
            }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    switch (indexPath.section) {
        case _SECTION_SESSION:
            switch (indexPath.row) {
                case _CELL_SESSION_SOUND_TURNEND_SETTINGS:
                    viewController = [[YTSetSoundTurnEndViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    break;
                default:
                    break;
            }
            break;
        case _SECTION_INTERMISSION:
            switch (indexPath.row) {
                case _CELL_INTERMISSION_SETTINGS:
                    viewController = [[YTSetIntermissionViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    break;
                default:
                    break;
            }
            break;
        case _SECTION_FIRSTBELL:
            switch (indexPath.row) {
                case _CELL_FIRSTBELL_SETTINGS:
                    viewController = [[YTSetFirstBellViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    break;
                case _CELL_FIRSTBELL_SOUND_SETTINGS:
                    viewController = [[YTSetSoundFirstBellViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end