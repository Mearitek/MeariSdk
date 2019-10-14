//
//  WYAppDelegate+Extension.m
//  Meari
//
//  Created by 李兵 on 16/7/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYAppDelegate+Extension.h"
#import "WYUserManger.h"

#import "WYBaseNVC.h"
#import "WYMenuVC.h"
#import "WYMeLoginVC.h"
#import "WYMeMineVC.h"
#import "WYCameraListVC.h"
#import "WYMsgVC.h"
#import "WYMsgSystemVC.h"
#import "WYMsgAlarmVC.h"
#import "WYMsgAlarmDetailVC.h"
#import "WYFriendListVC.h"



@implementation WYAppDelegate (Extension)
#pragma mark - Private
#pragma mark -- Init
- (void)_initUI {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTintColor:WY_MainColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:WY_FontColor_Black, NSFontAttributeName:WYFont_Text_L_Normal}];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
}
- (void)_initMeariKit {
    //Please enter the provided APPkey and APPSecret
    [[MeariSDK sharedInstance] startWithAppKey:@"8a48b2105058489aba0c08b79325ef3f" secretKey:@"f6c33593133c44f98372f67213568411"];
    [[MeariSDK sharedInstance] configEnvironment:MearEnvironmentRelease];
    [[MeariSDK sharedInstance] setLogLevel:MeariLogLevelVerbose];
}
- (void)_initPushWithOption:(NSDictionary *)options {
    [WYPushManager registerPushWithOptions:options];

    [WYPushManager dealAlarmShown:^(WYPushModel *pushModel) {
        
    }];
    [WYPushManager dealAlarmClicked:^(WYPushModel *pushModel) {
        
    }];
    [WYPushManager dealSystemShown:^(WYPushModel *pushModel) {
        
    }];
    [WYPushManager dealSystemClicked:^(WYPushModel *pushModel) {
       
    }];
    [WYPushManager dealVoiceCallClicked:^(WYPushModel *pushModel) {
        [UIDevice wy_forceOrientationPortrait];
        [WY_FaceTime showWithType:WYFaceTimeType_jpush];
        WY_FaceTime.pushModel = pushModel;
    }];
    [WYPushManager dealVoiceCallShow:^(WYPushModel *pushModel) {
        if ([MeariUser sharedInstance].isConnected) return;
        if (WY_FaceTime.answering) return;
        [UIDevice wy_forceOrientationPortrait];
        [WY_FaceTime showWithType:WYFaceTimeType_jpush];
        WY_FaceTime.pushModel = pushModel;
    }];
    [WYPushManager dealVisitiorCallClicked:^(WYPushModel *pushModel) {
        [UIDevice wy_forceOrientationPortrait];
        [WY_FaceTime showWithType:WYFaceTimeType_jpush];
        WY_FaceTime.pushModel = pushModel;
    }];
    [WYPushManager dealVisitiorCallShow:^(WYPushModel *pushModel) {
        if ([MeariUser sharedInstance].isConnected) return;
        if (WY_FaceTime.answering) return;
        [UIDevice wy_forceOrientationPortrait];
        [WY_FaceTime showWithType:WYFaceTimeType_jpush];
        WY_FaceTime.pushModel = pushModel;
    }];
}


#pragma mark -- Load
- (SlideViewController *)wy_slideVC {
    SlideViewController *slideVC = nil;
    if ([self.window.rootViewController isKindOfClass:[SlideViewController class]]) {
        slideVC = (SlideViewController *)self.window.rootViewController;
    }else {
        slideVC = [[SlideViewController alloc] init];
        slideVC.leftViewShowWidth = WY_SideViewController_Width;
        slideVC.leftViewController = [[WYMenuVC alloc] init];
    }
    slideVC.view.backgroundColor = [UIColor whiteColor];
    return slideVC;
}
- (UIViewController *)wy_currentVC {
    if (![self.window.rootViewController isKindOfClass:[SlideViewController class]]) return nil;
    
    SlideViewController *slideVC = (SlideViewController *)self.window.rootViewController;
    WYBaseNVC *nav = (WYBaseNVC *)slideVC.rootViewController;
    return nav.topViewController;
}
- (void)wy_loadMenuVC:(WYMenuType)menuType {
    UIViewController *vc;
    switch (menuType) {
        case WYMenuTypeCamera: {
            vc = [[WYCameraListVC alloc] init];
            break;
        }
        case WYMenuTypeMsg: {
            vc = [[WYMsgVC alloc] init];
            break;
        }
        case WYMenuTypeFriend: {
            vc = [[WYFriendListVC alloc] init];
            break;
        }
        default:
            break;
    }
    SlideViewController *slideVC = [self wy_slideVC];
    ((WYMenuVC *)slideVC.leftViewController).menuType = menuType;
    slideVC.rootViewController = [[WYBaseNVC alloc] initWithRootViewController:vc];
    self.window.rootViewController = slideVC;
}


#pragma mark - Public
- (void)wy_initWithOption:(NSDictionary *)options {
    [self _initUI];
    [self _initMeariKit];
    [self _initPushWithOption:options];
}
- (void)wy_loadApp {
    self.window = [[UIWindow alloc] initWithFrame:WY_MainScreen.bounds];
    self.window.backgroundColor  = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (!WY_UserM.isLogined) {
        [self wy_loadLoginVC];
    }else {
        [self wy_loadCameraVC];
    }
}
- (void)wy_loadLoginVC  {
    WY_WeakSelf
    [self wy_removePresentedVCSuccess:^{
        weakSelf.window.rootViewController = [[WYBaseNVC alloc] initWithRootViewController:[[WYMeLoginVC alloc] init]];
    }];
}
- (void)wy_loadCameraVC  {
    [self wy_loadMenuVC:WYMenuTypeCamera];
}
- (void)wy_loadMsgVC  {
    [self wy_loadMenuVC:WYMenuTypeMsg];
}
- (void)wy_loadFriendVC  {
    [self wy_loadMenuVC:WYMenuTypeFriend];
}
- (void)wy_loadMineVC {
    WYMeMineVC *vc = [[WYMeMineVC alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    WYBaseNVC *nav = [[WYBaseNVC alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}
- (void)wy_removePresentedVCSuccess:(WYBlock_Void)success {
    UIViewController *vc;
    for (UIView *v in self.window.subviews) {
        if ([v isMemberOfClass:NSClassFromString(@"UITransitionView")]) {
            if ([v.subviews.firstObject.nextResponder isKindOfClass:[UIViewController class]]) {
                vc = (UIViewController *)v.subviews.firstObject.nextResponder;
            }
        }
    }
    if (vc) {
        [vc dismissViewControllerAnimated:NO  completion:^{
            if (success) {
                success();
            }
        }];
    }else {
        if (success) {
            success();
        }
    }
}


@end



