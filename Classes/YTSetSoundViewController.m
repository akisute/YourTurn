//
//  YTSetSoundViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/27.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSetSoundViewController.h"
#import "YTSound.h"
#import "YTSoundTypes.h"
#import "YTUserDefaults.h"

#define _CELL_STANDARD @"Cell"

@implementation YTSetSoundViewController

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
    self.tableView.scrollEnabled = NO;
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
    return NSLocalizedString(@"Sound when turn ends", @"Section header of the sound settings view");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_CELL_STANDARD];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:_CELL_STANDARD] autorelease];
    }
    NSString *currentSoundId = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULTS_SOUND_TURNEND_KEY];
    YTSound *sound = [[YTSoundTypes instance] soundForIndex:indexPath.row];
    cell.text = sound.displayName;
    if ([sound.fileId isEqualToString:currentSoundId])
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
    [[NSUserDefaults standardUserDefaults] setObject:sound.fileId forKey:USERDEFAULTS_SOUND_TURNEND_KEY];
    [tableView reloadData];
    
    // Unselect any selections
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

