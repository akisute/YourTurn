//
//  YTTimePickerView.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/05.
//

#import "YTTimePickerView.h"

#define _COMPONENT_HOUR_01 0
#define _COMPONENT_HOUR_LABEL 1
#define _COMPONENT_MINUTE_10 2
#define _COMPONENT_MINUTE_01 3
#define _COMPONENT_MINUTE_LABEL 4
#define _COMPONENT_SECOND_10 5
#define _COMPONENT_SECOND_01 6
#define _COMPONENT_SECOND_LABEL 7


@implementation YTTimePickerView

@synthesize timePickerViewDelegate;
@synthesize time;

#pragma mark initialization and dellocation

- (id)initWithFrame:(CGRect)aRect
{
    if ([super initWithFrame:aRect] != nil)
    {
        self.delegate = self;
        self.dataSource = self;
        self.showsSelectionIndicator = YES;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark UIPickerView delegate method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 8;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case _COMPONENT_HOUR_01:
            return 10;
        case _COMPONENT_HOUR_LABEL:
            return 1;
        case _COMPONENT_MINUTE_10:
            return 6;
        case _COMPONENT_MINUTE_01:
            return 10;
        case _COMPONENT_MINUTE_LABEL:
            return 1;
        case _COMPONENT_SECOND_10:
            return 6;
        case _COMPONENT_SECOND_01:
            return 10;
        case _COMPONENT_SECOND_LABEL:
            return 1;
        default:
            return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)picker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label)
    {
        label = [[[UILabel alloc] init] autorelease];
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 20.0, 23.0);
        label.backgroundColor = [UIColor clearColor];
        switch (component) {
            case _COMPONENT_HOUR_01:
                label.font = [UIFont boldSystemFontOfSize:20.0];
                label.textAlignment = UITextAlignmentCenter;
                break;
            case _COMPONENT_HOUR_LABEL:
                label.font = [UIFont boldSystemFontOfSize:14.0];
                label.textColor = [UIColor redColor];
                break;
            case _COMPONENT_MINUTE_10:
                label.font = [UIFont boldSystemFontOfSize:20.0];
                label.textAlignment = UITextAlignmentCenter;
                break;
            case _COMPONENT_MINUTE_01:
                label.font = [UIFont boldSystemFontOfSize:20.0];
                label.textAlignment = UITextAlignmentCenter;
                break;
            case _COMPONENT_MINUTE_LABEL:
                label.font = [UIFont boldSystemFontOfSize:14.0];
                label.textColor = [UIColor redColor];
                break;
            case _COMPONENT_SECOND_10:
                label.font = [UIFont boldSystemFontOfSize:20.0];
                label.textAlignment = UITextAlignmentCenter;
                break;
            case _COMPONENT_SECOND_01:
                label.font = [UIFont boldSystemFontOfSize:20.0];
                label.textAlignment = UITextAlignmentCenter;
                break;
            case _COMPONENT_SECOND_LABEL:
                label.font = [UIFont boldSystemFontOfSize:14.0];
                label.textColor = [UIColor redColor];
                break;
            default:
                break;
        }
    }
    
    switch (component) {
        case _COMPONENT_HOUR_01:
            label.text = [[NSNumber numberWithInteger:row] stringValue];
            break;
        case _COMPONENT_HOUR_LABEL:
            label.text = @"h";
            break;
        case _COMPONENT_MINUTE_10:
            label.text =  [[NSNumber numberWithInteger:row] stringValue];
            break;
        case _COMPONENT_MINUTE_01:
            label.text =  [[NSNumber numberWithInteger:row] stringValue];
            break;
        case _COMPONENT_MINUTE_LABEL:
            label.text = @"m";
            break;
        case _COMPONENT_SECOND_10:
            label.text =  [[NSNumber numberWithInteger:row] stringValue];
            break;
        case _COMPONENT_SECOND_01:
            label.text =  [[NSNumber numberWithInteger:row] stringValue];
            break;
        case _COMPONENT_SECOND_LABEL:
            label.text = @"s";
            break;
        default:
            label.text =  @"";
            break;
    }
    
    return label;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 24.0;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 40.0;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // set time with current selection
    time = [self selectedRowInComponent:_COMPONENT_HOUR_01] * 3600;
    time += [self selectedRowInComponent:_COMPONENT_MINUTE_10] * 600;
    time += [self selectedRowInComponent:_COMPONENT_MINUTE_01] * 60;
    time += [self selectedRowInComponent:_COMPONENT_SECOND_10] * 10;
    time += [self selectedRowInComponent:_COMPONENT_SECOND_01] * 1;
//    LOG(@"YTTimePickerView.time = %d", time);
    
    // run delegate method
    if ([timePickerViewDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
    {
        [timePickerViewDelegate pickerView:(YTTimePickerView *)pickerView 
                              didSelectRow:(NSInteger)row 
                               inComponent:(NSInteger)component];
    }
}

#pragma mark other method

- (void)selectRowWithCurrentTime
{
    NSInteger hour = (NSInteger)(time / 3600);
    NSInteger minute = (NSInteger)(time % 3600 / 60);
    NSInteger second = (time % 3600 % 60);
//    LOG(@"YTTimePickerView = %d:%2d:%2d", hour, minute, second);
    
    [self selectRow:hour inComponent:_COMPONENT_HOUR_01 animated:NO];
    [self selectRow:(NSInteger)(minute / 10) inComponent:_COMPONENT_MINUTE_10 animated:NO];
    [self selectRow:(minute % 10) inComponent:_COMPONENT_MINUTE_01 animated:NO];
    [self selectRow:(NSInteger)(second / 10) inComponent:_COMPONENT_SECOND_10 animated:NO];
    [self selectRow:(second % 10) inComponent:_COMPONENT_SECOND_01 animated:NO];
    [self reloadAllComponents];
}

@end
