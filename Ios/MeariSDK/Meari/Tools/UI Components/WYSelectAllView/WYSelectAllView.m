//
//  WYSelectAllView.m
//  Meari
//
//  Created by 李兵 on 2016/11/24.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYSelectAllView.h"

@interface WYSelectAllView ()
@property (nonatomic, weak)UIButton *button;
@property (nonatomic, weak)UILabel *label;

@property (nonatomic, copy)void(^selectTask)(BOOL selected);

@end

@implementation WYSelectAllView
#pragma mark - Private
#pragma mark -- Getter
- (UIButton *)button {
    if (!_button) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage select_small_normal_image] forState:UIControlStateNormal];
        [btn setImage:[UIImage select_small_selected_image] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _button = btn;
    }
    return _button;
}
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        label.textColor = WY_FontColor_Gray;
        label.font = WYFont_Text_XS_Normal;
        label.text = WYLocalString(@"Select all");
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

#pragma mark -- Init
- (void)initSet {
    self.backgroundColor = [UIColor whiteColor];
}
- (void)initLayout {
    WY_WeakSelf
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_leading).with.offset(40);
        make.centerY.equalTo(weakSelf);
        make.width.equalTo(weakSelf.button.mas_height);
        make.height.equalTo(@40).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.button.mas_trailing).with.offset(20);
        make.centerY.equalTo(weakSelf);
        make.height.equalTo(@25).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}

#pragma mark -- Utilities
#pragma mark -- Action
- (void)selectAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.label.text = WYLocalString(sender.isSelected ? @"Select all" : @"Select all");
    if (self.selectTask) {
        self.selectTask(sender.isSelected);
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self selectAction:self.button];
}

#pragma mark - Public
+ (instancetype)selectAllViewWithSelectTask:(void(^)(BOOL selected))selectTask {
    WYSelectAllView *v = [[WYSelectAllView alloc] initWithFrame:CGRectZero];
    v.selectTask = selectTask;
    return v;
}
- (void)setSelected:(BOOL)selected {
    self.button.selected = selected;
    self.label.text = WYLocalString(selected ? @"Select all" : @"Select all");
}
- (BOOL)selected {
    return self.button.isSelected;
}
@end
