//
//  YTAddAttendeeViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/05.
//

#import "YTAddAttendeeViewController.h"
#import "YTQueue.h"
#import "YTAttendee.h"
#import "YTTextFieldCell.h"

#define _SECTION_INPUT_NAME 0

@interface YTAddAttendeeViewController (CellDefinition)
- (YTTextFieldCell *)textFieldCellWithLabel:(NSString *)label
                                      value:(NSString *)value
                                placeholder:(NSString *)placeholder;
- (UITableViewCell *)defaultCellOfTableView:(UITableView *)tableView;
@end


@implementation YTAddAttendeeViewController

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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(done:)] autorelease];
    self.title = @"Add attendee";
    nameCell = [[self textFieldCellWithLabel:@"Name"
                                       value:nil
                                 placeholder:@"Required"] retain];
    [nameCell focus:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [nameCell release];
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case _SECTION_INPUT_NAME:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case _SECTION_INPUT_NAME:
            return @"Attendee information";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create an appropriate cell object with section and row.
    UITableViewCell *cell;
    switch (indexPath.section) {
        case _SECTION_INPUT_NAME:
            switch (indexPath.row) {
                case 0:
                    cell = nameCell;
                    break;
                default: // Any other rows
                    cell = [self defaultCellOfTableView:tableView];
                    break;
            }
            break;
        default: // Any other sections
            cell = [self defaultCellOfTableView:tableView];
            break;
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No row selection allowed.
    return nil;
}

#pragma mark Cell definition

- (YTTextFieldCell *)textFieldCellWithLabel:(NSString *)label
                                      value:(NSString *)value
                                placeholder:(NSString *)placeholder
{
    YTTextFieldCell *cell = [[[YTTextFieldCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
    cell.label = label;
    cell.value = value;
    cell.placeholder = placeholder;
    return (YTTextFieldCell *)cell;
}

- (UITableViewCell *)defaultCellOfTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
    }    
    return cell;
}

#pragma mark IBAction

- (IBAction)done:(id)sender
{
    // TODO: Disable the button while all required inputs are not filled
    NSString *strName = nameCell.value;
    if ([[strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        // Temporary just ignoreing button action when validation is failed
        return;
    }
    // Create a new attendee object from inputted data and push it into the YTQueue
    YTAttendee *attendee = [[[YTAttendee alloc] init] autorelease];
    attendee.name = strName;
    [[YTQueue instance] addAttendee:attendee];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

