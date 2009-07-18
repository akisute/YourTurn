//
//  YTSetFirstBellViewController.m
//  YourTurn
//
//  Created by Masashi Ono on 09/07/18.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YTSetFirstBellViewController.h"
#import "YTSwitchCell.h"
#import "YTTimePickerView.h"
#import "YTUserDefaults.h"

#define _SECTION_INPUT_ENABLE 0
#define _SECTION_INPUT_TIME 1

@implementation YTSetFirstBellViewController

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
    self.tableView.allowsSelection = YES;
    self.tableView.allowsSelectionDuringEditing = NO;
    // TODO: Selection will be broken up when scrollEnabled = NO due to the bug of the OS 3.0.
    self.tableView.scrollEnabled = NO;
    self.tableView.canCancelContentTouches = NO;
    self.tableView.delaysContentTouches = NO;
    self.title = NSLocalizedString(@"First bell settings", @"Title of the first bell settings view");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    enableCell = [[YTSwitchCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
    enableCell.label.text = NSLocalizedString(@"Enable first bell", @"Label of the cell in the first bell settings view");
    enableCell.switchCondition = [defaults boolForKey:USERDEFAULTS_FIRSTBELL_ENABLED_KEY];
    
    // Initialize time picker with a previously selected value
    timePicker = [[YTTimePickerView alloc] initWithFrame:CGRectZero];
    timePicker.time = [defaults integerForKey:USERDEFAULTS_FIRSTBELL_TIMER_BEFORETURNEND_KEY];
    timePicker.timePickerViewDelegate = self;
    [timePicker selectRowWithCurrentTime];
    self.tableView.tableFooterView = timePicker;
}

- (void)dealloc
{
    [enableCell release];
    [timePicker release];
    [super dealloc];
}

#pragma mark ViewController methods

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger time = (timePicker.time == 0) ? 1 : timePicker.time;
    [defaults setBool:enableCell.switchCondition forKey:USERDEFAULTS_FIRSTBELL_ENABLED_KEY];
    [defaults setInteger:time forKey:USERDEFAULTS_FIRSTBELL_TIMER_BEFORETURNEND_KEY];
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
        case _SECTION_INPUT_ENABLE:
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
        case _SECTION_INPUT_ENABLE:
            return NSLocalizedString(@"Ring first bell",
                                     @"Section header of the first bell settings view");
        case _SECTION_INPUT_TIME:
            return NSLocalizedString(@"Time before turn ends",
                                     @"Section header of the first bell settings view");
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return enableCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No row selection allowed.
    return nil;
}

@end

