//
//  WYMeSignupBaseVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeSignupBaseVC.h"
#import "WYMeSignupModel.h"
#import "WYMeSignupCell.h"
#import "WYMeSignupCodeButton.h"
#import "WYCountryVC.h"
#import "WYCountryView.h"

@interface WYMeSignupBaseVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    CGFloat _originalY;
}
@property (nonatomic, strong)UITapGestureRecognizer *tapG;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *doneBtn;
@property (nonatomic, strong)UILabel *orLabel;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)WYMeSignupCodeButton *codeBtn;
@property (nonatomic, strong)WYCountryView *countryView;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger dataSourceTotalCount;
@property (nonatomic, strong)WYMeSignupModel *accountModel;
@property (nonatomic, copy)NSString *account;
@property (nonatomic, strong)LBCountryModel *country;

@property (nonatomic, strong)NSArray *tfs;
@property (nonatomic, strong)UITextField *accountTF;
@property (nonatomic, strong)UITextField *nicknameTF;
@property (nonatomic, strong)UITextField *passwordTF;
@property (nonatomic, strong)UITextField *password2TF;

@property (nonatomic, strong)NSTimer *countDownTimer;
@property (nonatomic, assign)NSInteger time;

@end

@implementation WYMeSignupBaseVC
#pragma mark -- Getter
WYGetter_MutableArray(dataSource)
- (UITapGestureRecognizer *)tapG {
    if (!_tapG) {
        _tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapG;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView wy_tableViewWithDelegate:self cellClass:[WYMeSignupCell class] fromNib:YES];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledGreenAndWhiteTitle target:self action:@selector(doneAction:)];
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 22;
        _doneBtn.wy_normalTitle = WYLocalString(@"me_finish");
        [self.view addSubview:_doneBtn];
    }
    return _doneBtn;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton wy_button];
        _loginBtn.wy_normalTitle = WYLocalString(@"me_login");
        _loginBtn.wy_normalTitleColor = WY_FontColor_Cyan;
        [_loginBtn wy_addTarget:self actionUpInside:@selector(loginAction:)];
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
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
        [self.view addSubview:_orLabel];
    }
    return _orLabel;
}
- (WYMeSignupCodeButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [WYMeSignupCodeButton new];
        [_codeBtn addTarget:self getCodeAction:@selector(codeAction:)];
    }
    return _codeBtn;
}
- (NSInteger)dataSourceTotalCount {
    _dataSourceTotalCount = 0;
    [self.dataSource enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _dataSourceTotalCount += obj.count;
    }];
    return _dataSourceTotalCount;
}
- (NSArray *)tfs {
    if (!_tfs) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        [self.dataSource enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
                NSIndexPath *indxPath = [NSIndexPath indexPathForRow:idx2 inSection:idx];
                WYMeSignupCell *cell = [self.tableView cellForRowAtIndexPath:indxPath];
                if (cell) {
                    [arr addObject:cell.tf];
                }
            }];
        }];
        _tfs = arr.copy;
    }
    return _tfs;
}
- (UITextField *)accountTF {
    return self.tfs.firstObject;
}
- (UITextField *)nicknameTF {
    if (self.tfs.count == 4) {
        return self.tfs[1];
    }
    return nil;
}
- (UITextField *)passwordTF {
    if (self.tfs.count == 4) {
        return self.tfs[2];
    }else if (self.tfs.count == 3) {
        return self.tfs[1];
    }
    return nil;
}
- (UITextField *)password2TF {
    if (self.tfs.count == 4) {
        return self.tfs[3];
    }else if (self.tfs.count == 3) {
        return self.tfs[2];
    }
    return nil;
}
- (WYCountryView *)countryView {
    if (!_countryView) {
        _countryView = [WYCountryView viewWithTarget:self action:@selector(selectCountryAction:)];
        [self.view addSubview:_countryView];
    }
    return _countryView;
}


- (NSTimer *)countDownTimer {
    if (!_countDownTimer) {
        _countDownTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToCountDown:)];
    }
    return _countDownTimer;
}
- (LBCountryModel *)country {
    if(!_country) {
        _country = [LBCountryModel wy_localCountry];
    }
    return _country;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
    [self initNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.signupType == WYSignupTypeChangePassword) {
        self.accountTF.enabled = NO;
    }
    _originalY = self.view.y;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)deallocAction {
    [WY_NotificationCenter removeObserver:self];
}

#pragma mark -- Init
- (void)initSet {
    self.showNavigationLine = YES;
    if(self.signupType == WYSignupTypeSignup ||
       self.signupType == WYSignupTypeForgotPassword) {
        self.countryView.country = self.country;        
    }
}
- (void)initLayout {
    CGFloat h = self.dataSourceTotalCount*[self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]+[self tableView:self.tableView heightForHeaderInSection:1];
    WY_WeakSelf
    if(self.signupType == WYSignupTypeSignup ||
       self.signupType == WYSignupTypeForgotPassword) {
        [self.countryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            make.top.equalTo(weakSelf.view).offset(30);
            make.leading.equalTo(weakSelf.view).offset(30);
            make.trailing.equalTo(weakSelf.view).offset(-30);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.countryView.mas_bottom).offset(15);
            make.leading.trailing.equalTo(weakSelf.view);
            make.height.equalTo(@(h));
        }];
    }else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(15);
            make.leading.trailing.equalTo(weakSelf.view);
            make.height.equalTo(@(h));
        }];
    }
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view).offset(30);
        make.trailing.equalTo(weakSelf.view).offset(-30);
        make.height.equalTo(@44);
        make.centerY.equalTo(weakSelf.view).multipliedBy(1.4).priority(751);
        make.top.greaterThanOrEqualTo(weakSelf.tableView.mas_bottom).offset(20);
    }];
    [self.orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.orLabel.size);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.doneBtn.mas_bottom).offset(15);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.orLabel.mas_bottom).offset(25);
    }];
}
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- Notification
- (void)keyboardWillShow:(NSNotification *)sender {
    [self.tableView addGestureRecognizer:self.tapG];
    UITextField *tf;
    if ([self.codeBtn.tf isFirstResponder]) {
        tf = self.codeBtn.tf;
    }
    for (UITextField *t in self.tfs) {
        if ([t isFirstResponder]) {
            tf = t;
            break;
        }
    }
    if (!tf) {
        return;
    }
    UIView *v = tf.superview.superview;
    CGFloat h = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGPoint p = (CGPoint){0,self.view.height - h - 15};
    CGFloat idealY = p.y;
    CGFloat offsetY = self.view.y;
    CGFloat realY;
    if (tf == self.password2TF) {
        realY = self.doneBtn.maxY + offsetY;
    }else {
        realY = v.maxY + offsetY;
    }
    if (realY > idealY) {
        CGFloat offset = -(realY - idealY) + offsetY;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.y = _originalY + offset;
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)sender {
    [self.tableView removeGestureRecognizer:self.tapG];
    if (self.view.y != _originalY) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.y = _originalY;
        }];
    }
}

#pragma mark -- Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)backAction:(UIButton *)sender {
    [self wy_popToVC:WYVCTypeMeLogin sender:self.accountModel.text];
}
- (void)doneAction:(UIButton *)skender {
    if (self.accountTF.text.length <= 0) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_noAccount"))
        return;
    }
    switch (self.signupType) {
        case WYSignupTypeSignup:
        case WYSignupTypeForgotPassword: {
            if (self.country.isChinaMainland){
                if (![self.accountTF.text wy_validateAccount]) {
                    WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_accountIsInvalid"))
                    return;
                }
            }else {
                if (![self.accountTF.text wy_validateEmail]) {
                    WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_accountIsInvalid"))
                    return;
                }
            }
            break;
        }
        case WYSignupTypeChangePassword: {
            break;
        }
        default:
        break;
    }
    if (self.signupType == WYSignupTypeSignup) {
        if (self.nicknameTF.text.length <= 0) {
            WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_noNickname"))
            return;
        }        
    }
    if (self.codeBtn.tf.text.length <= 0) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_noCode"))
        return;
    }
    if (self.passwordTF.text.length <= 0 ||
        self.password2TF.text.length <= 0) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_noPassord"))
        return;
    }
    if (![self.passwordTF.text wy_validatePassword] ||
        ![self.password2TF.text wy_validatePassword]) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_passwordLength"))
        return;
    }
    if (![self.passwordTF.text isEqualToString:self.password2TF.text]) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_passwordNotMatch"))
        return;
    }
    switch (self.signupType) {
        case WYSignupTypeSignup: {
            [self networkRequestSignup];
            break;
        }
        case WYSignupTypeChangePassword: {
            [self networkRequestChangePassword];
            break;
        }
        case WYSignupTypeForgotPassword: {
            [self networkRequestFindPassword];
            break;
        }
        default:
            break;
    }
}
- (void)loginAction:(UIButton *)sender {
    [self wy_pop];
}
- (void)codeAction:(UIButton *)sender {
    if (self.accountTF.text.length <= 0) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_noAccount"))
        return;
    }
    switch (self.signupType) {
        case WYSignupTypeSignup:
        case WYSignupTypeForgotPassword: {
            if (self.country.isChinaMainland){
                if (![self.accountTF.text wy_validateAccount]) {
                    WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_accountIsInvalid"))
                    return;
                }
            }else {
                if (![self.accountTF.text wy_validateEmail]) {
                    WY_HUD_SHOW_STATUS(WYLocalString(@"me_fail_accountIsInvalid"))
                    return;
                }
            }
            break;
        }
        case WYSignupTypeChangePassword: {
            break;
        }
        default:
            break;
    }
    [self networkRequestCode];
}
- (void)tapAction:(UIGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self.tableView removeGestureRecognizer:sender];
}
- (void)selectCountryAction:(UIButton *)sender {
    WY_WeakSelf
    WYCountryVC *vc = [WYCountryVC wy_vcWithSelectCountry:^(LBCountryModel *country) {
        if (country) {
            if (![weakSelf.country isEqual:country]) {
                [[MeariUser sharedInstance] resetRedirect];
            }
            weakSelf.country = country;
            weakSelf.countryView.country = country;
            weakSelf.accountModel.placeholder = weakSelf.country.isChinaMainland ? [NSString wy_placeholder_me_account_email_phone] : [NSString wy_placeholder_me_account_email];
            [weakSelf.tableView reloadData];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- Network
- (void)networkRequestCode {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] getValidateCodeWithAccount:self.accountTF.text countryCode:self.country.countryCode phoneCode:self.country.phoneCode success:^(NSInteger seconds) {
        WY_HUD_DISMISS
        weakSelf.time = seconds;
        [weakSelf enableCountDownTimer:YES];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestSignup {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] registerAccount:self.accountTF.text password:self.passwordTF.text countryCode:self.country.countryCode phoneCode:self.country.phoneCode verificationCode:self.codeBtn.tf.text nickname:self.nicknameTF.text success:^{
        WY_HUD_DISMISS
        [weakSelf updateUserInfo:[MeariUser sharedInstance].userInfo];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestChangePassword {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] changePasswordWithAccount:self.accountTF.text password:self.passwordTF.text verificationCode:self.codeBtn.tf.text success:^{
        WY_HUD_DISMISS
        [weakSelf updateUserInfo:[MeariUser sharedInstance].userInfo];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestFindPassword {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] findPasswordWithAccount:self.accountTF.text password:self.passwordTF.text countryCode:@"CN" phoneCode:@"86" verificationCode:self.codeBtn.tf.text success:^{
        WY_HUD_DISMISS
        [weakSelf updateUserInfo:[MeariUser sharedInstance].userInfo];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}


#pragma mark -- Timer
- (void)timerToCountDown:(NSTimer *)sender {
    if (self.time <= 0) {
        self.time = 0;
        [self enableCountDownTimer:NO];
        [self.codeBtn reset];
        return;
    }
    [self.codeBtn setCountDown:self.time];
    self.time--;
    if (self.time <= 0) {
        self.time = 0;
        [self enableCountDownTimer:NO];
        [self.codeBtn reset];
        return;
    }
}


#pragma mark -- Utilities
- (void)enableCountDownTimer:(BOOL)enable {
    if (enable) {
        if (!_countDownTimer) {
            [self.countDownTimer fire];
        }
    }else {
        if (_countDownTimer) {
            [_countDownTimer invalidate];
            _countDownTimer = nil;
        }
    }
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, NSString)) {
        self.account = obj;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMeSignupCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYMeSignupCell) forIndexPath:indexPath];
    cell.tf.delegate = self;
    NSArray *arr = self.dataSource[indexPath.section];
    WYMeSignupModel *model = arr[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WY_iPhone_4 ? 50 : 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return WY_iPhone_4 ? 50 : 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *v = [UIView new];
    [v addSubview:self.codeBtn];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(v).offset(55);
        make.trailing.equalTo(v).offset(-30);
        make.centerY.equalTo(v);
        make.height.equalTo(@44);
    }];
    return v;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nicknameTF && !self.codeBtn.tf.hidden) {
        [self.codeBtn.tf becomeFirstResponder];
        return YES;
    }
    NSInteger index = [self.tfs indexOfObject:textField];
    if (index < self.tfs.count - 1) {
        UITextField *tf = self.tfs[index+1];
        [tf becomeFirstResponder];
    }else if (index == self.tfs.count-1) {
        [self doneAction:self.doneBtn];
    }
    return YES;
}

#pragma mark - Public
- (void)setSignupType:(WYSignupType)signupType {
    _signupType = signupType;
    WYMeSignupModel *account = [WYMeSignupModel accountModel];
    WYMeSignupModel *nickname = [WYMeSignupModel nicknameModel];
    WYMeSignupModel *password = [WYMeSignupModel passwordModel];
    WYMeSignupModel *password2 = [WYMeSignupModel password2Model];
    account.text = self.account;
    switch (_signupType) {
        case WYSignupTypeSignup: {
            self.dataSource = @[@[account, nickname],@[password, password2]].mutableCopy;
            break;
        }
        case WYSignupTypeChangePassword: {
            self.dataSource = @[@[account],@[password, password2]].mutableCopy;
            self.orLabel.hidden = YES;
            self.loginBtn.hidden = YES;
            break;
        }
        case WYSignupTypeForgotPassword: {
            self.dataSource = @[@[account],@[password, password2]].mutableCopy;
            break;
        }
        default:
            break;
    }
}
- (void)updateUserInfo:(MeariUserInfo *)userInfo {
    
}

@end
