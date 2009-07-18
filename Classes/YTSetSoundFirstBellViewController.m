//
//  YTSetSoundFirstBellViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/07/18.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSetSoundFirstBellViewController.h"
#import "YTSound.h"
#import "YTSoundTypes.h"
#import "YTUserDefaults.h"

#define _CELL_STANDARD @"Cell"

@implementation YTSetSoundFirstBellViewController

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
    self.title = NSLocalizedString(@"Sound settings", @"Title of the sound settings view");
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [YTSoundTypes instance].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Sound of first bell", @"Section header of the sound settings view");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_CELL_STANDARD];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:_CELL_STANDARD] autorelease];
    }
    NSString *currentSoundId = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULTS_FIRSTBELL_SOUND_KEY];
    YTSound *sound = [[YTSoundTypes instance] soundForIndex:indexPath.row];
    cell.textLabel.text = sound.displayName;
    if ([sound.soundId isEqualToString:currentSoundId])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTSound *sound = [[YTSoundTypes instance] soundForIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:sound.soundId forKey:USERDEFAULTS_FIRSTBELL_SOUND_KEY];
    [tableView reloadData];
    
    // Unselect any selections
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

