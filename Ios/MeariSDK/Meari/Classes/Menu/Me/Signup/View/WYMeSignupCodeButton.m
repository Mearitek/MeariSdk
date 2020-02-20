//
//  WYMeSignupCodeButton.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeSignupCodeButton.h"

@interface WYMeSignupCodeButton ()
@property (nonatomic, strong)UIButton *btn;
@property (nonatomic, strong)UILabel *label;
@end

@implementation WYMeSignupCodeButton
#pragma mark -- Getter
- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledWhiteAndGreenTitle target:nil action:nil];
        _btn.wy_normalTitle = WYLocalString(@"me_getCode");
        _btn.wy_highlightedBGImage = [UIImage bgGreenImage];
        _btn.wy_highlightedTitleColor = [UIColor whiteColor];
        [self addSubview:_btn];
    }
    return _btn;
}
- (UITextField *)tf {
    if (!_tf) {
        _tf = [UITextField new];
        _tf.font = WYFont_Text_S_Normal;
//        [_tf setValue:WYFont_Text_S_Normal forKeyPath:@"_placeholderLabel.font"];
        _tf.clearButtonMode = UITextFieldViewModeNever;
        _tf.returnKeyType = UIReturnKeyNext;
        _tf.keyboardType = UIKeyboardTypeNumberPad;
        _tf.placeholder = WYLocalString(@"me_code_placeholder");
        [self addSubview:_tf];
    }
    return _tf;
}
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel labelWithFrame:CGRectZero
                                        text:@"300"
                                   textColor:[UIColor whiteColor]
                                    textfont:WYFont_Text_XS_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByWordWrapping
                               lineAlignment:NSTextAlignmentCenter
                                   sizeToFit:NO];
        _label.layer.masksToBounds = YES;
        _label.backgroundColor = WY_MainColor;
        [self addSubview:_label];
    }
    return _label;
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.height/2;
    self.label.layer.cornerRadius = self.label.height/2;
}

#pragma mark -- Init
- (void)initSet {
    self.tf.hidden = YES;
    self.label.hidden = YES;
    self.btn.hidden = NO;
    self.layer.borderColor = WY_MainColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}
- (void)initLayout {
    WY_WeakSelf
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf).offset(-10);
        make.width.equalTo(weakSelf.label.mas_height).multipliedBy(1.0f);
        make.trailing.equalTo(weakSelf).offset(-5);
        make.centerY.equalTo(weakSelf);
    }];
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(18);
        make.trailing.equalTo(weakSelf.label).offset(-10);
    }];
}

#pragma mark - Public
- (void)reset {
    self.tf.hidden = YES;
    self.label.hidden = YES;
    self.btn.hidden = NO;
    self.tf.text = nil;
}
- (void)setCountDown:(NSInteger)second {
    self.tf.hidden = NO;
    self.label.hidden = NO;
    self.btn.hidden = YES;
    self.label.text = @(second).stringValue;
}
- (void)addTarget:(id)target getCodeAction:(SEL)action {
    [self.btn wy_addTarget:target actionUpInside:action];
}

@end
