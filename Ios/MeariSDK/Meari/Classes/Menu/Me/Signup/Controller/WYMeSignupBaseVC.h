//
//  WYMeSignupBaseVC.h
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseVC.h"
typedef NS_ENUM(NSInteger, WYSignupType) {
    WYSignupTypeSignup,
    WYSignupTypeChangePassword,
    WYSignupTypeForgotPassword,
};
@interface WYMeSignupBaseVC : WYBaseVC

@property (nonatomic, assign)WYSignupType signupType;
- (void)initSet NS_REQUIRES_SUPER;
- (void)updateUserInfo:(MeariUserInfo *)userInfo NS_REQUIRES_SUPER;

@end
