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
#define _SECTION_GO 2
#define _REUSE_IDENTIFIER_STANDARD @"Cell"
#define _REUSE_IDENTIFIER_GO @"Go"


@implementation YTMainViewController

#pragma mark init, dealloc, memory management

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
    self.title = @"YourTurn";
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(openAboutView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}

- (void)dealloc
{
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case _SECTION_ATTENDEE:
            return 1;
        case _SECTION_SETTINGS:
            return 1;
        case _SECTION_GO:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case _SECTION_ATTENDEE:
        case _SECTION_SETTINGS:
            cell = [tableView dequeueReusableCellWithIdentifier:_REUSE_IDENTIFIER_STANDARD];
            if (cell == nil)
            {
                // FIXME: initWithFrame:reuseIdentifier is deprecated in OS 3.0. use initWithStyle instead.
                cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
                                               reuseIdentifier:_REUSE_IDENTIFIER_STANDARD] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case _SECTION_GO:
            cell = [tableView dequeueReusableCellWithIdentifier:_REUSE_IDENTIFIER_GO];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
                                               reuseIdentifier:_REUSE_IDENTIFIER_GO] autorelease];
                cell.textAlignment = UITextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            if ([YTQueue instance].currentTurnAttendee)
            {
                // FIXME: cell.textColor is deprecated in OS 3.0. Use textLabel instead
                cell.textColor = [UIColor blueColor];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            else
            {
                // FIXME: cell.textColor is deprecated in OS 3.0. Use textLabel instead
                cell.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
        default:
            break;
    }
    
    switch (indexPath.section) {
        case _SECTION_ATTENDEE:
            cell.text = [NSString stringWithFormat:@"Manage attendees (%d)", [YTQueue instance].count];
            break;
        case _SECTION_SETTINGS:
            cell.text = @"Settings";
            break;
        case _SECTION_GO:
            cell.text = @"Start session";
            break;
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.font = [UIFont boldSystemFontOfSize:15.0];
    label.textColor = [UIColor colorWithHue:0.136 saturation:0.68 brightness:0.42 alpha:1.0];
    label.shadowColor = [UIColor colorWithHue:0.125 saturation:0.85 brightness:0.90 alpha:0.5];
    label.shadowOffset = CGSizeMake(1.0, 1.0);
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case _SECTION_ATTENDEE:
            label.text = @"  1. Setup attendees of the session";
            break;
        case _SECTION_SETTINGS:
            label.text = @"  2. Configure the session";
            break;
        case _SECTION_GO:
            label.text = @"  3. Let's begin!";
            break;
        default:
            break;
    }
    return label;
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
        case _SECTION_GO:
            if ([YTQueue instance].currentTurnAttendee)
            {
                str = [NSString stringWithFormat:@"Next person: %@", [YTQueue instance].currentTurnAttendee.name];
            }
            else
            {
                str = @"You must have at least 1 person to start the session.";
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
        case _SECTION_GO:
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
        case _SECTION_GO:
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
        case _SECTION_GO:
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

