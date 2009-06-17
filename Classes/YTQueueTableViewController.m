//
//  YTQueueTableViewManager.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import "YTQueueTableViewController.h"
#import "YTQueue.h"
#import "YTAttendee.h"
#import "YTQueueTableCell.h"
#import "YTQueueTableAddAttendeeCell.h"
#import "YTAddAttendeeViewController.h"
#import "YTYourTurnViewController.h"

#define _CELL_ATTENDEE @"YTQueueTableCell"
#define _CELL_ADD @"YTQueueTableAddAttendeeCell"


@implementation YTQueueTableViewController

#pragma mark init, dealloc, memory management

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
    self.editing = NO;
    self.title = @"Attendees";
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
    if (self.editing)
    {
        // attendees only
        return [YTQueue instance].count;
    }
    else
    {
        // all attendees + "add" cell
        return [YTQueue instance].count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTQueueTableCell *tableCell = nil;
    YTQueueTableAddAttendeeCell *addCell = nil;
    
    if (indexPath.row < [YTQueue instance].count)
    {
        tableCell = (YTQueueTableCell *)[tableView dequeueReusableCellWithIdentifier:_CELL_ATTENDEE];
        if (tableCell == nil)
        {
            tableCell = [[[YTQueueTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:_CELL_ATTENDEE] autorelease];
        }
        YTAttendee *attendee = [[YTQueue instance] attendeeAtIndex:indexPath.row];
        [tableCell setLabelsWithIndex:indexPath.row andAttendee:attendee];
        return tableCell;
    }
    else if (indexPath.row == [YTQueue instance].count)
    {
        addCell = (YTQueueTableAddAttendeeCell *)[tableView dequeueReusableCellWithIdentifier:_CELL_ADD];
        if (addCell == nil)
        {
            addCell = [[[YTQueueTableAddAttendeeCell alloc] initWithFrame:CGRectZero reuseIdentifier:_CELL_ADD] autorelease];
        }
        return addCell;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Open up an AddAttendeeView if "add atendee" cell is touched
    if (indexPath.row == [YTQueue instance].count)
    {
        [self addAttendee:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The "add" cell should not be edited. Others are allowed to edit.
    return indexPath.row != [YTQueue instance].count;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadData];
}
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [[YTQueue instance] removeAttendeeAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
//    return YES;
    return indexPath.row != [YTQueue instance].count;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    LOG(@"moveRowAtIndexPath:%d toIndexPath:%d", fromIndexPath.row, toIndexPath.row);
    [[YTQueue instance] moveAttendeeAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    // setEditing is called when user presses "Edit" button.
    [super setEditing:flag animated:animated];
    if (flag)
    {
        self.navigationItem.rightBarButtonItem = nil;        
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                                target:self
                                                                                                action:@selector(openYourTurnView:)] autorelease];
        self.navigationItem.rightBarButtonItem.enabled = [YTQueue instance].count > 0;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data whenever the table view will appear
    self.navigationItem.rightBarButtonItem.enabled = [YTQueue instance].count > 0;
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Unselect any selections
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}

#pragma mark IBAction

- (IBAction)segmentedControlClicked:(id)sender
{
    // Call appropriate action for clicked segment
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            // Add button
            [self addAttendee:sender];
            break;
        case 1:
            // YourTurn button
            [self openYourTurnView:sender];
            break;
        default:
            break;
    }
}

- (IBAction)addAttendee:(id)sender
{
    // Open up a new view to add a new attendee
    YTAddAttendeeViewController *addAttendeeViewController = [[[YTAddAttendeeViewController alloc] initWithNibName:@"YTAddAttendeeView"
                                                                                                            bundle:nil] autorelease];
    [self.navigationController pushViewController:addAttendeeViewController animated:YES];
}

- (IBAction)openYourTurnView:(id)sender
{
    // Open up the YourTurn view
    YTYourTurnViewController *yourTurnViewController = [[[YTYourTurnViewController alloc] initWithNibName:@"YTYourTurnView"
                                                                                                   bundle:nil] autorelease];
    [self.navigationController pushViewController:yourTurnViewController animated:YES];
}

@end

