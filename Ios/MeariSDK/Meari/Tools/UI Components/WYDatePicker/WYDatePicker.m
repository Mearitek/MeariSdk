//
//  WYDatePicker.m
//  Meari
//
//  Created by 李兵 on 2017/1/17.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDatePicker.h"
#define WYMaxHour       25*400
#define WYMaxMinute     60*100
@interface WYDatePicker ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong)UIPickerView *datePicker;
@property (nonatomic, strong)UIControl *control;
@property (nonatomic, strong)UIView *toolBar;
@property (nonatomic, copy)WYDatePickerTask saveTask;

@end

@implementation WYDatePicker
#pragma mark - Private
#pragma mark -- Getter
- (UIPickerView *)datePicker {
    if (!_datePicker) {
        UIPickerView *dateP = [[UIPickerView alloc] init];
        dateP.frame = CGRectMake(0, 0, WY_ScreenWidth, 200);
        dateP.backgroundColor = [UIColor whiteColor];
        dateP.delegate = self;
        dateP.dataSource = self;
        [dateP selectRow:WYMaxHour/2 inComponent:0 animated:NO];
        [dateP selectRow:WYMaxMinute/2 inComponent:1 animated:NO];
        [self addSubview:dateP];
        _datePicker = dateP;
    }
    return _datePicker;
}
- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [UIView new];
        _toolBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:_toolBar];
        [_toolBar addLineViewAtTop];
        [_toolBar addLineViewAtBottom];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cancelBtn setTitle:WYLocal_Cancel forState:UIControlStateNormal];
        [cancelBtn setTitleColor:WY_FontColor_Black forState:UIControlStateNormal];
        [cancelBtn setTitleColor:WY_FontColor_Gray forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:cancelBtn];
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [okBtn setTitle:WYLocal_OK forState:UIControlStateNormal];
        [okBtn setTitleColor:WY_FontColor_Black forState:UIControlStateNormal];
        [okBtn setTitleColor:WY_FontColor_Gray forState:UIControlStateHighlighted];
        [okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:okBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_toolBar);
            make.leading.equalTo(_toolBar).with.offset(15);
            make.width.equalTo(@100);
        }];
        [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_toolBar);
            make.trailing.equalTo(_toolBar).with.offset(-15);
            make.width.equalTo(@100);
        }];
    }
    return _toolBar;
}
- (UIControl *)control {
    if (!_control) {
        _control = [UIControl new];
        [_control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_control];
    }
    return _control;
}

#pragma mark -- Init
- (void)initSet {
    self.hidden = YES;
}
- (void)initLayout {
    WY_WeakSelf
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(WY_iPhone_4 ? 140 : 200)).priorityHigh(751);
        make.height.lessThanOrEqualTo(weakSelf);
        make.leading.trailing.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(WY_iPhone_4 ? 35 : 44)).priorityHigh(751);
        make.height.lessThanOrEqualTo(weakSelf);
        make.leading.trailing.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.datePicker.mas_top);
    }];
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.toolBar.mas_top);
    }];
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}

#pragma mark -- Network
#pragma mark -- Notification
#pragma mark -- NSTimer
#pragma mark -- Utilities
#pragma mark -- Action
- (void)cancelAction:(UIButton *)sender {
    self.hidden = YES;
}
- (void)okAction:(UIButton *)sender {
    NSInteger hour = [self.datePicker selectedRowInComponent:0]%25;
    NSInteger minute = [self.datePicker selectedRowInComponent:1]%60;
    if (hour == 24 && minute > 0) return;
    self.hidden = YES;
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
    if (self.saveTask) {
        self.saveTask(time);
    }
}
- (void)controlAction:(UIControl *)sender {
    self.hidden = YES;
}

#pragma mark - Delegate
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return WYMaxHour;
    }
    return WYMaxMinute;
}
#pragma mark -- UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component  {
    return 60;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component  {
    return 30;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component  {
    if (component == 0) {
        return [NSString stringWithFormat:@"%02ld", row%25];
    }
    return [NSString stringWithFormat:@"%02ld", row%60];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    if (component == 0) {
        NSInteger hour = row%25;
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        NSInteger min = row1%60;
        if (hour == 24 && min > 0) {
            [pickerView selectRow:min<30 ? row1-min : (row1-min+60>WYMaxMinute-1 ? WYMaxMinute/2+min : row1-min+60) inComponent:1 animated:YES];
        }
    }else if(component == 1){
        NSInteger min = row%60;
        NSInteger row0 = [pickerView selectedRowInComponent:0];
        NSInteger hour = row0%25;
        if (hour == 24 && min > 0) {
            [pickerView selectRow:min<30 ? (row0+1>WYMaxHour-1 ? WYMaxHour/2-1 : row0+1) : row0-1 inComponent:0 animated:YES];
        }
    }
}

#pragma mark - Public
+ (instancetype)datePickerWithSaveTask:(WYDatePickerTask)saveTask {
    WYDatePicker *dateP = [[WYDatePicker alloc] init];
    dateP.saveTask = saveTask;
    return dateP;
};
- (void)showTime:(NSString *)time {
    self.hidden = NO;
    if (time.length == 5) {
        NSString *hour = [time substringWithRange:NSMakeRange(0, 2)];
        NSString *min = [time substringWithRange:NSMakeRange(3, 2)];
        [self.datePicker selectRow:WYMaxHour/2+hour.integerValue inComponent:0 animated:NO];
        [self.datePicker selectRow:WYMaxMinute/2+min.integerValue inComponent:1 animated:NO];
    }
}
- (BOOL)showing {
    return !self.hidden;
}


@end
