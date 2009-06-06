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
#import "YTTimePickerView.h"

#define _SECTION_INPUT_NAME 0
#define _SECTION_INPUT_TIME 1
#define _USERDEFAULTS_TIMEPICKER_INITIALVALUE @"timePicker.initialValue"


@implementation YTAddAttendeeViewController

#pragma mark init, dealloc, memory management

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(done:)] autorelease];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = @"Add attendee";
    
    // Initialize name input cell
    nameCell = [[YTTextFieldCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
    nameCell.label = @"Name";
    nameCell.value = @"";
    nameCell.placeholder = @"Required";
    nameCell.delegate = self;
    [nameCell focus:self];
    
    // Initialize time picker with a previously selected value
    timePicker = [[YTTimePickerView alloc] initWithFrame:CGRectZero];
    NSInteger initialValue = [[NSUserDefaults standardUserDefaults] integerForKey:_USERDEFAULTS_TIMEPICKER_INITIALVALUE];
    timePicker.time = (initialValue == 0) ? 300 : initialValue;
    timePicker.timePickerViewDelegate = self;
    [timePicker selectRowWithCurrentTime];
    self.tableView.tableFooterView = timePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [timePicker release];
    [nameCell release];
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section)
    {
        case _SECTION_INPUT_NAME:
            num = 1;
            break;
        case _SECTION_INPUT_TIME:
            break;
        default:
            break;
    }
    return num;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = nil;
    switch (section)
    {
        case _SECTION_INPUT_NAME:
            string = @"Attendee information";
            break;
        case _SECTION_INPUT_TIME:
            string = @"Allotted time";
            break;
        default:
            break;
    }
    return string;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = nil;
//    UIDatePicker *datePicker = nil;
//    switch (section)
//    {
//        case _SECTION_INPUT_NAME:
//            break;
//        case _SECTION_INPUT_TIME:
//            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
//            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//            datePicker.enabled = YES;
//            view = datePicker;
//            break;
//        default:
//            break;
//    }
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    CGFloat height = 20.0;
//    switch (section)
//    {
//        case _SECTION_INPUT_NAME:
//            break;
//        case _SECTION_INPUT_TIME:
//            height = 300.0;
//            break;
//        default:
//            break;
//    }
//    return height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case _SECTION_INPUT_NAME:
            switch (indexPath.row) {
                case 0:
                    cell = nameCell;
                    break;
                default:
                    // Any other rows
                    break;
            }
            break;
        case _SECTION_INPUT_TIME:
            break;
        default: 
            // Any other sections
            break;
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No row selection allowed.
    return nil;
}

#pragma mark YTTextFieldCell and YTTimePickerView delegate

//- (void)textFieldCellWillBeginEditing:(YTTextFieldCell *)aTextFieldCell
//{
//    self.navigationItem.rightBarButtonItem.enabled =
//    [[nameCell.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0;
//    
//}

- (void)textFieldCellWillEndEditing:(YTTextFieldCell *)aTextFieldCell
{
    self.navigationItem.rightBarButtonItem.enabled =
    [[nameCell.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0;
    
}

- (void)textFieldCellWillChangeCharacters:(YTTextFieldCell *)aTextFieldCell
{
    self.navigationItem.rightBarButtonItem.enabled =
    [[nameCell.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0;
}

#pragma mark IBAction

- (IBAction)done:(id)sender
{
    // Create a new attendee object from inputted data and push it into the YTQueue
    YTAttendee *attendee = [[[YTAttendee alloc] init] autorelease];
    attendee.name = nameCell.value;
    attendee.allottedTime = timePicker.time;
    [[YTQueue instance] addAttendee:attendee];
    
    // Save current value of the time picker into user default
    [[NSUserDefaults standardUserDefaults] setInteger:timePicker.time forKey:_USERDEFAULTS_TIMEPICKER_INITIALVALUE];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

