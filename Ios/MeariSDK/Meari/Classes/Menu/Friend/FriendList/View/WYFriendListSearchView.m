//
//  WYFriendListSearchView.m
//  Meari
//
//  Created by 李兵 on 2017/9/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendListSearchView.h"

@interface WYFriendListSearchView ()<UITextFieldDelegate>
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *addButton;

@end

@implementation WYFriendListSearchView
#pragma mark -- Getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        [self addSubview:_containerView];
    }
    return _containerView;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.placeholder = [NSString wy_placeholder_friend_account];
        _textField.font = WYFont_Text_S_Normal;
//        [_textField setValue:WYFont_Text_S_Normal forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_textField];
    }
    return _textField;
}
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton wy_buttonWithStytle:WYButtonStytleFilledGreenAndWhiteTitle target:nil action:nil];
        _addButton.wy_normalTitle = WYLocalString(@"ADD");
        _addButton.wy_disabledTitleColor = [UIColor whiteColor];
        _addButton.wy_disabledBGImage = [UIImage bgGrayImage];
        [self addSubview:_addButton];
    }
    return _addButton;
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = self.containerView.height/2;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = self.addButton.height/2;
}

#pragma mark -- Init
- (void)initSet {
    self.backgroundColor = WY_BGColor_LightGray;
    self.containerView.layer.borderColor = WY_MainColor.CGColor;
    self.containerView.layer.borderWidth = 1;
    [self addLineViewAtBottom];
}
- (void)initLayout {
    WY_WeakSelf
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(15);
        make.trailing.equalTo(weakSelf).offset(-15);
        make.centerY.equalTo(weakSelf);
        make.height.equalTo(@44);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.containerView).offset(15);
        make.height.equalTo(weakSelf.containerView);
        make.centerY.equalTo(weakSelf.containerView);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.centerY.equalTo(weakSelf.containerView);
        make.trailing.equalTo(weakSelf.containerView).offset(-5);
        make.height.equalTo(weakSelf.containerView).offset(-10);
        make.leading.equalTo(weakSelf.textField.mas_trailing).offset(10);
    }];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    id target = self.addButton.allTargets.anyObject;
    if (target) {
        SEL selector =  NSSelectorFromString([self.addButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].firstObject);
        if (selector && [target respondsToSelector:selector]) {
            [target performSelector:selector withObject:self.addButton afterDelay:0];
        }
    }
    
    return YES;
}

#pragma mark - Public
- (NSString *)text {
    return self.textField.text;
}
- (void)setEnabled:(BOOL)enabled {
    if (enabled) {
        self.addButton.enabled = YES;
        self.textField.enabled = YES;
        self.containerView.layer.borderColor = WY_MainColor.CGColor;
    }else {
        self.addButton.enabled = NO;
        self.textField.enabled = NO;
        self.containerView.layer.borderColor = WY_BounderColor_Brown.CGColor;
    }
}
- (void)addTarget:(id)target action:(SEL)action {
    [self.addButton wy_addTarget:target actionUpInside:action];
}

@end
