//
//  YTAddAttendeeViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTAddAttendeeViewController.h"
#import "YTQueue.h"
#import "YTAttendee.h"
#import "YTUserDefaults.h"
#import "YTTextFieldCell.h"
#import "YTTimePickerView.h"

#define _SECTION_INPUT_NAME 0
#define _SECTION_INPUT_TIME 1


@implementation YTAddAttendeeViewController

#pragma mark init, dealloc, memory management

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
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
    NSInteger initialValue = [[NSUserDefaults standardUserDefaults] integerForKey:USERDEFAULTS_TIMEPICKER_INITIALVALUE_KEY];
    timePicker.time = (initialValue == 0) ? 300 : initialValue;
    timePicker.timePickerViewDelegate = self;
    [timePicker selectRowWithCurrentTime];
    self.tableView.tableFooterView = timePicker;
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
    switch (section)
    {
        case _SECTION_INPUT_NAME:
            return 1;
        case _SECTION_INPUT_TIME:
            return 0;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case _SECTION_INPUT_NAME:
            return @"Attendee information";
        case _SECTION_INPUT_TIME:
            return @"Allotted time";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case _SECTION_INPUT_NAME:
            switch (indexPath.row) {
                case 0:
                    return nameCell;
                default:
                    return nil;
            }
        case _SECTION_INPUT_TIME:
            return nil;
        default: 
            return nil;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No row selection allowed.
    return nil;
}

#pragma mark YTTextFieldCell and YTTimePickerView delegate

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
    [[NSUserDefaults standardUserDefaults] setInteger:timePicker.time forKey:USERDEFAULTS_TIMEPICKER_INITIALVALUE_KEY];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

