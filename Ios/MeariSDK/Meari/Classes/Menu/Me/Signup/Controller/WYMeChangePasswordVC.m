//
//  WYMeChangePasswordVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeChangePasswordVC.h"

@interface WYMeChangePasswordVC ()

@end

@implementation WYMeChangePasswordVC

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
    self.signupType = WYSignupTypeChangePassword;
    [super initSet];
    self.navigationItem.title = WYLocalString(@"me_changePwd_title");
    
}
- (void)updateUserInfo:(MeariUserInfo *)userInfo {
    [super updateUserInfo:userInfo];
    [self wy_pop];
    
}
@end
