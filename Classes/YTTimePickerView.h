//
//  YTTimePickerView.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/05.
//

#import <UIKit/UIKit.h>


@interface YTTimePickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource> {
    id timePickerViewDelegate;
    int time;
}

@property (nonatomic, assign) id timePickerViewDelegate;
@property (nonatomic) NSInteger time;

- (void)selectRowWithCurrentTime;

@end

@interface NSObject (YTTimePickerViewDelegate)
- (void)pickerView:(YTTimePickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
