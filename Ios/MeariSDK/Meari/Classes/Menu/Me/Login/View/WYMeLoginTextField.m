//
//  WYMeLoginTextField.m
//  Meari
//
//  Created by 李兵 on 2017/9/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeLoginTextField.h"

@interface WYMeLoginTextField ()
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation WYMeLoginTextField

#pragma mark -- Getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.clearButtonMode = UITextFieldViewModeNever;
        _textField.font = WYFont_Text_S_Normal;
//        [_textField setValue:WYFont_Text_XS_Normal forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_textField];
    }
    return _textField;
}
- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton wy_button];
        [self addSubview:_btn];
    }
    return _btn;
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.height/2;
}

#pragma mark -- Init
- (void)initSet {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = WY_BounderColor_Brown.CGColor;
    self.layer.borderWidth = 1.0f;
}
- (void)initLayout {
    WY_WeakSelf
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(10);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf);
        make.width.equalTo(weakSelf.btn.mas_height).multipliedBy(1.0f);
        make.trailing.top.equalTo(weakSelf);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.imageView.mas_trailing).offset(3);
        make.trailing.equalTo(weakSelf.btn.mas_leading);
        make.top.bottom.equalTo(weakSelf);
    }];
}

#pragma mark -- Action


#pragma mark -- Public
+ (instancetype)accountTextField {
    WYMeLoginTextField *v = [self new];
    v.imageView.image = [UIImage imageNamed:@"img_me_account"];
    v.btn.wy_normalImage = nil;
    v.textField.returnKeyType = UIReturnKeyNext;
    v.textField.placeholder = [NSString wy_placeholder_me_account];
    return v;
}
+ (instancetype)passwordTextField {
    WYMeLoginTextField *v = [self new];
    v.imageView.image = [UIImage imageNamed:@"img_me_password"];
    v.btn.wy_normalImage = [UIImage imageNamed:@"btn_me_eye_normal"];
    v.btn.wy_selectedImage = [UIImage imageNamed:@"btn_me_eye_selected"];
    v.textField.returnKeyType = UIReturnKeyGo;
    v.textField.placeholder = WYLocalString(@"me_password_placeholder");
    v.textField.secureTextEntry = YES;
    return v;
}

@end
