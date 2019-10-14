//
//  WYMeLoginVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeLoginVC.h"
#import "WYMeLoginView.h"
#import "WYCountryView.h"
#import "WYCountryVC.h"
//#import <MeariKit/MeariKit.h>

@interface WYMeLoginVC ()<WYMeLoginViewDelegate>
{
    BOOL _first;
}
@property (nonatomic, strong) WYMeLoginView *loginView;
@property (nonatomic, strong) LBCountryModel *country;

@end

@implementation WYMeLoginVC
#pragma mark -- Getter
- (WYMeLoginView *)loginView {
    if (!_loginView) {
        _loginView = [WYMeLoginView new];
        _loginView.delegate = self;
    }
    return _loginView;
}
- (LBCountryModel *)country {
    if(!_country) {
        _country = [LBCountryModel wy_localCountry];
    }
    return _country;
}

#pragma mark -- Life
- (void)loadView {
    self.view = self.loginView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self.loginView showWithMask:_first];
    _first = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark -- Init
- (void)initSet {
    _first = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.loginView.account = WY_UserM.previousUserAccount;
    
#ifndef WYRelease
    UIView *v = [UIView new];
    [self.view addSubview:v];
    WY_WeakSelf
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.centerX.equalTo(weakSelf.view);
        make.height.equalTo(@100);
    }];
    [v addDoubleTapGestureTarget:self action:@selector(doubleAction:)];
#endif
}
- (void)initLayout {
    
}

#pragma mark -- Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)doubleAction:(UITapGestureRecognizer *)sender {
    [self wy_pushToVC:WYVCTypeConfig];
}

#pragma mark -- Network
- (void)networkRequestLogin {
    if(self.loginView.isUidLogined) {
        //uid登录
        WY_HUD_SHOW_WAITING
        [[MeariUser sharedInstance] loginWithUid:self.loginView.account countryCode:self.country.countryCode phoneCode:self.country.phoneCode success:^{
            WY_HUD_DISMISS
            [WY_UserM signIn:[MeariUser sharedInstance].userInfo];
            [WY_Appdelegate wy_loadCameraVC];
        } failure:^(NSError *error) {
            [WY_UserM dealMeariUserError:error];
        }];
        
    }else {
        //账号登录
        WY_HUD_SHOW_WAITING
        [[MeariUser sharedInstance] loginAccount:self.loginView.account password:self.loginView.password countryCode:self.country.countryCode phoneCode:self.country.phoneCode success:^{
            WY_HUD_DISMISS
            [WY_UserM signIn:[MeariUser sharedInstance].userInfo];
            [WY_Appdelegate wy_loadCameraVC];
        } failure:^(NSError *error) {
            [WY_UserM dealMeariUserError:error];
        }];
    }
}


#pragma mark -- Action
- (void)loginAction {
    if (self.loginView.account.length <= 0) {
        WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"me_fail_noAccount"))
        return;
    }
    if (!self.loginView.isUidLogined) {
        if (self.loginView.password.length <= 0) {
            WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"me_fail_noPassord"))
            return;
        }
        if (![self.loginView.account wy_validateAccount]) {
            WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"me_fail_accountIsInvalid"))
            return;
        }
    }
    [self networkRequestLogin];
}
- (void)signupAction {
    [self.view endEditing:YES];
    [self wy_pushToVC:WYVCTypeMeSignup sender:self.loginView.account];
}
- (void)forgotAction {
    [self.view endEditing:YES];
    [self wy_pushToVC:WYVCTypeMeForgotPassword sender:self.loginView.account];
}

#pragma mark - Delegate
#pragma mark -- WYMeLoginViewDelegate
- (NSArray<NSString *> *)WYMeLoginViewRecordedUsers:(WYMeLoginView *)loginView {
    return nil;
}
- (void)WYMeLoginView:(WYMeLoginView *)loginView deleteUser:(NSString *)userAccount {
    
}
- (void)WYMeLoginView:(WYMeLoginView *)loginView chooseUser:(NSString *)userAccount {
    
}
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapLoginBtn:(UIButton *)btn {
    [self loginAction];
}
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapForgotBtn:(UIButton *)btn {
    [self forgotAction];
}
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapSignupBtn:(UIButton *)btn {
    [self signupAction];
}
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapDropdownBtn:(UIButton *)btn {
    
}
- (void)WYMeLoginView:(WYMeLoginView *)loginView didTapCountry:(WYCountryView *)countryView  {
    WY_WeakSelf
    WYCountryVC *vc = [WYCountryVC wy_vcWithSelectCountry:^(LBCountryModel *country) {
        if (country) {
            if (![weakSelf.country isEqual:country]) {
                [[MeariUser sharedInstance] resetRedirect];
            }
            weakSelf.country = country;
            countryView.country = country;
            [loginView setAccountPlaceholder:weakSelf.country.isChinaMainland ? [NSString wy_placeholder_me_account_email_phone] : [NSString wy_placeholder_me_account_email]];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
