//
//  DeviceSettingCellOne.m
//  Meari
//
//  Created by 李兵 on 16/1/4.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYSettingSearchView.h"


@implementation WYSettingSearchView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCustomSubViews];
    }
    return self;
}

- (void)addCustomSubViews {
    // 创建cell标题
    UILabel *label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    // 创建输入框
    UITextField *textF = [[UITextField alloc] init];
    textF.returnKeyType = UIReturnKeyDone;
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF.borderStyle = UITextBorderStyleRoundedRect;
    textF.delegate = self;
    [self.contentView addSubview:textF];
    self.textField = textF;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(DeviceSettingCellOne:changeName:)]) {
        [self.delegate DeviceSettingCellOne:self changeName:textField.text];
    }
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.centerY = self.centerY;
    self.titleLabel.x = 15;
    
    CGFloat labelMaxX = CGRectGetMaxX(self.titleLabel.frame);
    self.textField.frame = CGRectMake(labelMaxX + 10, 0, WY_ScreenWidth - labelMaxX - 20, 36);
    self.textField.centerY = self.centerY;
    
}
@end
