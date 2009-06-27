//
//  YTSettingsViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/26.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSettingsViewController.h"
#import "YTSelectionCell.h"

#define _REUSE_IDENTIFIER_SELECTION @"YTSelectionCell"
#define _CELL_SOUND_SETTINGS 0
#define _CELL_INTERMISSION_SETTINGS 1


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
    self.tableView.scrollEnabled = NO;
    self.title = @"Settings";
    soundSettingsCell = [[YTSelectionCell alloc] initWithFrame:CGRectZero
                                               reuseIdentifier:_REUSE_IDENTIFIER_SELECTION];
    intermissionSettingsCell = [[YTSelectionCell alloc] initWithFrame:CGRectZero
                                                      reuseIdentifier:_REUSE_IDENTIFIER_SELECTION];
}

- (void)dealloc
{
    [soundSettingsCell release];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case _CELL_INTERMISSION_SETTINGS:
            intermissionSettingsCell.label = @"Intermission";
            intermissionSettingsCell.selectionLabel = @"OFF";
            return intermissionSettingsCell;
        case _CELL_SOUND_SETTINGS:
            soundSettingsCell.label = @"Sound";
            soundSettingsCell.selectionLabel = @"bell";
            return soundSettingsCell;
        default:
            return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}

@end