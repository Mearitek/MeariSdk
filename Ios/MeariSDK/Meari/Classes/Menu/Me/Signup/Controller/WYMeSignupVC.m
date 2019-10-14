//
//  WYMeSignupVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeSignupVC.h"
@interface WYMeSignupVC ()
@end

@implementation WYMeSignupVC

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
    self.signupType = WYSignupTypeSignup;
    [super initSet];
    self.navigationItem.title = WYLocalString(@"me_signup_title");
}
- (void)updateUserInfo:(MeariUserInfo *)userInfo {
    [super updateUserInfo:userInfo];
    [WY_UserM signIn:userInfo];
    [WY_Appdelegate wy_loadCameraVC];
}


@end
