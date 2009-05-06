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
#define _CELL_DEFAULT @"_CELL_DEFAULT"
#define _CELL_TEXTFIELD @"_CELL_TEXTFIELD"

@interface YTAddAttendeeViewController (CellDefinition)
- (YTTextFieldCell *)textFieldCellWithTableView:(UITableView *)tableView
                                          label:(NSString *)label
                                          value:(NSString *)value
                                    placeholder:(NSString *)placeholder;
- (UITableViewCell *)defaultCellWithTableView:(UITableView *)tableView;
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
                    cell = [self textFieldCellWithTableView:tableView
                                                       label:@"Name"
                                                       value:nil
                                                 placeholder:@"Required"];
                    break;
                default: // Any other rows
                    break;
            }
            break;
        default: // Any other sections
            cell = [self defaultCellWithTableView:tableView];
            cell.text = [NSString stringWithFormat:@"Test. section:%d, row:%d", indexPath.section, indexPath.row];
            // No row selection allowed.
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (YTTextFieldCell *)textFieldCellWithTableView:(UITableView *)tableView
                                          label:(NSString *)label
                                          value:(NSString *)value
                                    placeholder:(NSString *)placeholder
{
    YTTextFieldCell *cell = (YTTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:_CELL_TEXTFIELD];
    if (cell == nil)
    {
        //TODO: fix this workaround
        [nameCell release];
        cell = [[[YTTextFieldCell alloc] initWithFrame:CGRectZero reuseIdentifier:_CELL_TEXTFIELD] autorelease];
        nameCell = cell;
        [nameCell retain];
    }
    cell.label = label;
    cell.value = value;
    cell.placeholder = placeholder;
    return (YTTextFieldCell *)cell;
}

- (UITableViewCell *)defaultCellWithTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_CELL_DEFAULT];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:_CELL_DEFAULT] autorelease];
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

