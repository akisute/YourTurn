//
//  YTMainViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTMainViewController.h"
#import "YTQueueTableViewController.h"
#import "YTYourTurnViewController.h"
#import "YTSettingsViewController.h"
#import "YTAboutViewController.h"
#import "YTAttendee.h"
#import "YTQueue.h"

#define _SECTION_ATTENDEE 0
#define _SECTION_SETTINGS 1
#define _SECTION_START 2
#define _REUSE_IDENTIFIER_STANDARD @"Cell"
#define _REUSE_IDENTIFIER_START @"Start"


@implementation YTMainViewController

#pragma mark init, dealloc, memory management

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        manageAttendeesCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:_REUSE_IDENTIFIER_STANDARD];
        manageAttendeesCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        settingsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:_REUSE_IDENTIFIER_STANDARD];
        settingsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        settingsCell.textLabel.text = NSLocalizedString(@"Settings", @"Cell text of the main view");
        startCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:_REUSE_IDENTIFIER_START];
        startCell.textLabel.textAlignment = UITextAlignmentCenter;
        startCell.accessoryType = UITableViewCellAccessoryNone;
        startCell.textLabel.text = NSLocalizedString(@"Start session", @"Cell text of the main view");
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
    self.title = NSLocalizedString(@"YourTurn", @"Application name. DO NOT TRANSLATE");
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(openAboutView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}

- (void)dealloc
{
    [manageAttendeesCell release];
    [settingsCell release];
    [startCell release];
    [super dealloc];
}

#pragma mark ViewController methods

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_ATTENDEE:
            return 1;
        case _SECTION_SETTINGS:
            return 1;
        case _SECTION_START:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case _SECTION_ATTENDEE:
            manageAttendeesCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Manage attendees (%d)",
                                                                                              @"Cell text of the main view"),
                                                  [YTQueue instance].count];
            return manageAttendeesCell;
        case _SECTION_SETTINGS:
            return settingsCell;
        case _SECTION_START:
            if ([YTQueue instance].currentTurnAttendee)
            {
                startCell.textLabel.textColor = [UIColor blueColor];
                startCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            else
            {
                startCell.textLabel.textColor = [UIColor grayColor];
                startCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return startCell;
        default:
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_ATTENDEE:
            return NSLocalizedString(@"1. Setup attendees of the session",
                                     @"Section name of the main view");
        case _SECTION_SETTINGS:
            return NSLocalizedString(@"2. Configure the session",
                                     @"Section name of the main view");
        case _SECTION_START:
            return NSLocalizedString(@"3. Let's begin!",
                                     @"Section name of the main view");
        default:
            return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    NSString *str = nil;
    
    switch (section) {
        case _SECTION_ATTENDEE:
            break;
        case _SECTION_SETTINGS:
            break;
        case _SECTION_START:
            if ([YTQueue instance].currentTurnAttendee)
            {
                str = [NSString stringWithFormat:NSLocalizedString(@"Next person: %@",
                                                                   @"Footer message of the main view"),
                       [YTQueue instance].currentTurnAttendee.name];
            }
            else
            {
                str = NSLocalizedString(@"You must have at least 1 person to start the session.",
                                        @"Footer message of the main view");
            }
            label.text = str;
            break;
        default:
            break;
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_ATTENDEE:
            return 48.0;
        case _SECTION_SETTINGS:
            return 48.0;
        case _SECTION_START:
            return 48.0;
        default:
            return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_ATTENDEE:
            return 0.0;
        case _SECTION_SETTINGS:
            return 0.0;
        case _SECTION_START:
            return 64.0;
        default:
            return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    switch (indexPath.section) {
        case _SECTION_ATTENDEE:
            viewController = [[[YTQueueTableViewController alloc] initWithNibName:@"YTQueueTableView"
                                                                           bundle:nil] autorelease];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        case _SECTION_SETTINGS:
            viewController = [[[YTSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        case _SECTION_START:
            if ([YTQueue instance].currentTurnAttendee)
            {
                viewController = [[[YTYourTurnViewController alloc] initWithNibName:@"YTYourTurnView"
                                                                             bundle:nil] autorelease];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        default:
            break;
    }
}

#pragma mark IBAction

-(IBAction)openAboutView
{
    UIViewController *viewController = [[[YTAboutViewController alloc] initWithNibName:nil
                                                                                bundle:nil] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

