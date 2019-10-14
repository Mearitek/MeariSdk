//
//  WYMeForgotPasswordVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeForgotPasswordVC.h"

@interface WYMeForgotPasswordVC ()

@end

@implementation WYMeForgotPasswordVC

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- Super
- (void)initSet {
    self.signupType = WYSignupTypeForgotPassword;
    [super initSet];
    self.navigationItem.title = WYLocalString(@"me_forgotPwd_title");
}
- (void)updateUserInfo:(MeariUserInfo *)userInfo {
    [super updateUserInfo:userInfo];
    [WY_UserM signIn:userInfo];
    [WY_Appdelegate wy_loadCameraVC];
}
@end
