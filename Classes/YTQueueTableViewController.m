//
//  YTQueueTableViewManager.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import "YTQueueTableViewController.h"
#import "YTQueue.h"
#import "YTAttendee.h"
#import "YTAddAttendeeViewController.h"
#import "YTYourTurnViewController.h"


@implementation YTQueueTableViewController

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
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
    self.editing = NO;
    self.title = @"Attendees";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    return [YTQueue instance].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

    YTAttendee *attendee = [[YTQueue instance] attendeeAtIndex:indexPath.row];
    cell.text = [NSString stringWithFormat:@"%d, %@", indexPath.row+1, attendee.name];
    
    // No row selection allowed.
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No row selection allowed.
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [[YTQueue instance] removeAttendeeAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
        // change view to an editable view
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                target:self
                                                                                                action:@selector(addAttendee:)] autorelease];
    }
    else
    {
        // change view to an noneditable view
        // Do not show navigation button unless there's at least 1 person in the queue
        if ([YTQueue instance].count > 0)
        {
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                                    target:self
                                                                                                    action:@selector(openYourTurnView:)] autorelease];
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data whenever the controlled view will appear
    [self.tableView reloadData];
}

#pragma mark IBAction

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

