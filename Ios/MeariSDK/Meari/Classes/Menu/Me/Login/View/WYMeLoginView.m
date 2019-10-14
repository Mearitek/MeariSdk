//
//  WYMeLoginView.m
//  Meari
//
//  Created by 李兵 on 2017/9/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeLoginView.h"
#import "WYMeLoginLogoView.h"
#import "WYMeLoginTextField.h"
#import "WYMeLoginHistoryCell.h"
#import "WYCountryView.h"

const CGFloat WYLoginCellHeight = 40.0f;

@interface WYMeLoginView ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, WYLoginHistoryCellDelegate>
@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong)UIImageView *maskView;
@property (nonatomic, strong)WYMeLoginLogoView *logoView;
@property (nonatomic, strong)WYCountryView *countryView;
@property (nonatomic, strong)WYMeLoginTextField *accountTF;
@property (nonatomic, strong)WYMeLoginTextField *passwordTF;
@property (nonatomic, strong)UIButton *forgotBtn;
@property (nonatomic, strong)UIButton *uidBtn;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton *signupBtn;
@property (nonatomic, strong)UILabel *orLabel;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, assign, readwrite, getter=isUidLogined) BOOL uidLogined;
@end

@implementation WYMeLoginView
#pragma mark -- Getter
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@"bg_menu"];
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}
- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [UIImageView new];
        _maskView.image = [UIImage imageNamed:@"img_logo_pic"];
        _maskView.hidden = YES;
        [self addSubview:_maskView];
    }
    return _maskView;
}
- (WYMeLoginLogoView *)logoView {
    if (!_logoView) {
        _logoView = [WYMeLoginLogoView new];
        [self addSubview:_logoView];
    }
    return _logoView;
}
- (WYCountryView *)countryView {
    if (!_countryView) {
        _countryView = [WYCountryView viewWithTarget:self action:@selector(selectCountryAction:)];
        [self addSubview:_countryView];
    }
    return _countryView;
}
- (WYMeLoginTextField *)accountTF {
    if (!_accountTF) {
        _accountTF = [WYMeLoginTextField accountTextField];
        _accountTF.textField.delegate = self;
        [_accountTF.btn wy_addTarget:self actionUpInside:@selector(drowpDownAction:)];
        [self addSubview:_accountTF];
    }
    return _accountTF;
}
- (WYMeLoginTextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [WYMeLoginTextField passwordTextField];
        _passwordTF.textField.delegate = self;
        [_passwordTF.btn wy_addTarget:self actionUpInside:@selector(eyeAction:)];
        [self addSubview:_passwordTF];
    }
    return _passwordTF;
}
- (UIButton *)forgotBtn {
    if (!_forgotBtn) {
        _forgotBtn = [UIButton wy_button];
        _forgotBtn.wy_normalTitle = WYLocalString(@"me_forgot");
        _forgotBtn.wy_normalTitleColor = WY_FontColor_LightBlack;
        _forgotBtn.titleLabel.font = WYFont_Text_S_Normal;
        [_forgotBtn wy_addTarget:self actionUpInside:@selector(forgotAction:)];
        [self addSubview:_forgotBtn];
    }
    return _forgotBtn;
}
- (UIButton *)uidBtn {
    if (!_uidBtn) {
        _uidBtn = [UIButton wy_button];
        _uidBtn.wy_normalTitle = WYLocalString(@"me_uid");
        _uidBtn.wy_normalTitleColor = WY_FontColor_LightBlack;
        _uidBtn.titleLabel.font = WYFont_Text_S_Normal;
        [_uidBtn wy_addTarget:self actionUpInside:@selector(uidAction:)];
        [self addSubview:_uidBtn];
    }
    return _uidBtn;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledGreenAndWhiteTitle target:self action:@selector(loginAction:)];
        _loginBtn.wy_normalTitle = WYLocalString(@"me_login");
        [self addSubview:_loginBtn];
    }
    return _loginBtn;
}
- (UIButton *)signupBtn {
    if (!_signupBtn) {
        _signupBtn = [UIButton wy_button];
        _signupBtn.wy_normalTitle = WYLocalString(@"me_signup");
        _signupBtn.wy_normalTitleColor = WY_FontColor_Cyan;
        [_signupBtn wy_addTarget:self actionUpInside:@selector(signupAction:)];
        [self addSubview:_signupBtn];
    }
    return _signupBtn;
}
- (UILabel *)orLabel {
    if (!_orLabel) {
        _orLabel = [UILabel labelWithFrame:CGRectZero
                                      text:WYLocalString(@"me_or")
                                 textColor:WY_FontColor_LightBlack
                                  textfont:WYFont_Text_XS_Normal
                             numberOfLines:0
                             lineBreakMode:NSLineBreakByWordWrapping
                             lineAlignment:NSTextAlignmentCenter
                                 sizeToFit:YES];
        [self addSubview:_orLabel];
    }
    return _orLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView wy_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.borderColor = WY_BGColor_LightGray2.CGColor;
        _tableView.layer.borderWidth = 1;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.bounces = NO;
        _tableView.hidden = YES;
        [_tableView wy_setDelegate:self];
        [_tableView wy_registerClass:[WYMeLoginHistoryCell class] fromNib:YES];
        [self addSubview:_tableView];
    }
    return _tableView;
}
- (NSArray *)dataSource {
    if ([self.delegate respondsToSelector:@selector(WYMeLoginViewRecordedUsers:)]) {
        return [self.delegate WYMeLoginViewRecordedUsers:self];
    }
    return nil;
}

#pragma mark -- Life
- (void)initAction {
    [super initAction];
    
    [self initLayout];
    [self initNotification];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = self.loginBtn.height/2;
}
- (void)updateConstraints {
    CGFloat h = MIN(160, self.dataSource.count*WYLoginCellHeight);
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h));
    }];
    [super updateConstraints];
}
- (void)deallocAction {
    [WY_NotificationCenter removeObserver:self];
}


#pragma mark -- Init
- (void)initLayout {
    WY_WeakSelf
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.equalTo(weakSelf);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).multipliedBy(0.35);
    }];
    [self.countryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(30);
        make.trailing.equalTo(weakSelf).offset(-30);
        make.height.equalTo(@44);
        make.bottom.equalTo(weakSelf.accountTF.mas_centerY).offset(-50);
        
    }];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(30);
        make.trailing.equalTo(weakSelf).offset(-30);
        make.height.equalTo(@44);
        make.bottom.equalTo(weakSelf.mas_centerY).offset(-50);
    }];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.accountTF);
        make.centerX.equalTo(weakSelf.accountTF);
        make.top.equalTo(weakSelf.accountTF.mas_bottom).offset(25);
    }];
    [self.forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.passwordTF.mas_bottom).offset(0);
    }];
    [self.uidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.forgotBtn.mas_bottom).offset(0);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(weakSelf.accountTF);
        make.centerX.equalTo(weakSelf.accountTF);
        make.centerY.equalTo(weakSelf).multipliedBy(WY_iPhone_4 ? 1.5 : 1.4);
    }];
    [self.orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.orLabel.size);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.loginBtn.mas_bottom).offset(15);
    }];
    [self.signupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.orLabel.mas_bottom).offset(25);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.top.equalTo(weakSelf.accountTF.mas_bottom);
        make.centerX.equalTo(weakSelf.accountTF);
        make.width.equalTo(weakSelf.accountTF).offset(-40);
    }];
}
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark -- Notification
- (void)keyboardWillShow:(NSNotification *)sender {
    CGFloat h = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGPoint p = (CGPoint){0,self.height - h - 15};
    CGFloat idealY = p.y;
    CGFloat offsetY = self.y;
    CGFloat realY = self.loginBtn.maxY + offsetY;
    CGFloat top = WY_iPhone_X ? WY_SAFE_TOP : WY_StatusBar_H;
    if (realY > idealY) {
        CGFloat offset =  -(realY - idealY)+offsetY;
        if (self.accountTF.y + offset <= top) {
            offset = -(self.accountTF.y - top);
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.y = offset;
            if (self.logoView.y + offset < top) {
                self.logoView.alpha = 0;
            }
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)sender {
    if (self.y != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.y = 0;
            self.logoView.alpha = 1;
        }];
    }
}
- (void)appWillEnterForeground:(NSNotification *)sender {
    if (self.logoView.y > 20) {
        self.logoView.alpha = 1.0f;
    }
}

#pragma mark -- Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
    [self showTableView:NO];
}
- (void)drowpDownAction:(UIButton *)sender {
    if (self.dataSource.count <= 0) {
        return;
    }
    sender.selected = !sender.isSelected;
    [self showTableView:sender.isSelected];
}
- (void)eyeAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.passwordTF.textField.secureTextEntry = !sender.isSelected;
}
- (void)forgotAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMeLoginView:didTapForgotBtn:)]) {
        [self.delegate WYMeLoginView:self didTapForgotBtn:sender];
    }
}
- (void)uidAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.uidLogined = sender.selected;
}
- (void)loginAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMeLoginView:didTapLoginBtn:)]) {
        [self.delegate WYMeLoginView:self didTapLoginBtn:sender];
    }
}
- (void)signupAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMeLoginView:didTapSignupBtn:)]) {
        [self.delegate WYMeLoginView:self didTapSignupBtn:sender];
    }
}
- (void)selectCountryAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMeLoginView:didTapCountry:)]) {
        [self.delegate WYMeLoginView:self didTapCountry:self.countryView];
    }
}

#pragma mark -- Utilities
- (void)updateTableview {
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
        if (self.dataSource.count <= 0) {
            [self drowpDownAction:self.accountTF.btn];
        }
    }];
}
- (void)showTableView:(BOOL)show {
    if (show && self.tableView.alpha == 1) {
        return;
    }
    if (!show && self.tableView.alpha == 0) {
        return;
    }
    self.accountTF.btn.selected = show;
    self.tableView.hidden = NO;
    self.tableView.alpha = show ? 0 : 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.accountTF.btn.transform = CGAffineTransformRotate(self.accountTF.btn.transform, M_PI);
        self.tableView.alpha = show ? 1 : 0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(WYMeLoginView:didTapDropdownBtn:)]) {
            [self.delegate WYMeLoginView:self didTapDropdownBtn:self.accountTF.btn];
        }
    }];
}
- (void)setUidLogined:(BOOL)uidLogined {
    _uidLogined = uidLogined;
    self.orLabel.hidden = uidLogined;
    self.signupBtn.hidden = uidLogined;
    self.uidBtn.wy_normalTitle = WYLocalString(uidLogined ? @"账号登录" : @"uid登录");
    WY_WeakSelf
    [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(uidLogined) {
            make.height.equalTo(@0);
        }else {
            make.height.equalTo(weakSelf.accountTF);
        }
        make.width.equalTo(weakSelf.accountTF);
        make.centerX.equalTo(weakSelf.accountTF);
        make.top.equalTo(weakSelf.accountTF.mas_bottom).offset(25);
    }];
}

#pragma mark - Delegate
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.accountTF.textField == textField) {
        [self.passwordTF.textField becomeFirstResponder];
        return YES;
    }
    
    if (self.passwordTF.textField == textField) {
        [self loginAction:self.loginBtn];
        return YES;
    }
    return YES;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMeLoginHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYMeLoginHistoryCell) forIndexPath:indexPath];
    cell.delegate = self;
    cell.accountLabel.text = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMeLoginHistoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.accountTF.textField.text = cell.accountLabel.text;
    [self showTableView:NO];
}

#pragma mark -- WYLoginHistoryCellDelegate
- (void)WYMeLoginHistoryCell:(WYMeLoginHistoryCell *)cell deleteUser:(NSString *)userAccount {
    if ([self.delegate respondsToSelector:@selector(WYMeLoginView:deleteUser:)]) {
        [self.delegate WYMeLoginView:self deleteUser:userAccount];
        [self updateTableview];
    }
}

#pragma mark - Public
- (NSString *)account {
    return self.accountTF.textField.text;
}
- (void)setAccount:(NSString *)account {
    self.accountTF.textField.text = account;
}
- (NSString *)password {
    return self.passwordTF.textField.text;
}
- (void)showWithMask:(BOOL)mask {
    for (UIView *v in self.subviews) {
        v.hidden = NO;
        v.alpha = 0;
    }
    WYBlock_Void show = ^{
        self.logoView.alpha = 1;
        self.logoView.transform = CGAffineTransformTranslate(self.logoView.transform, 0, WY_ScreenHeight/2);
        [UIView animateWithDuration:0.5 animations:^{
            self.logoView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *v in self.subviews) {
                    if (v != self.tableView) {
                        v.alpha = 1.0f;
                    }
                }
            }];
        }];
    };
    
    if (mask) {
        self.maskView.alpha = 1.0f;
        [UIView animateWithDuration:0.5 animations:^{
            self.maskView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.maskView.hidden = YES;
            self.maskView.transform = CGAffineTransformIdentity;
            show();
        }];
    }else {
        self.maskView.hidden = YES;
        self.maskView.alpha = 0;
        show();
    }
    
}
- (void)setAccountPlaceholder:(NSString *)placeholder {
    self.accountTF.textField.placeholder = placeholder;
}


@end
