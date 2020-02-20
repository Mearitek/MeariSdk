//
//  UIViewController+Extension.m
//  Meari
//
//  Created by 李兵 on 2016/11/11.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>

static char *kwy_observeredKeypaths = "kwy_observeredKeypaths";
@implementation UIViewController (Extension)
- (void)setCamera:(MeariDevice *)camera {
    objc_setAssociatedObject(self, @selector(camera), camera, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (MeariDevice *)camera {
    return objc_getAssociatedObject(self, @selector(camera));
}

/**
 KVO
 */
- (NSSet *)wy_observeredKeypaths {
    return objc_getAssociatedObject(self, kwy_observeredKeypaths);
}
- (void)setWy_observeredKeypaths:(NSSet *)wy_observeredKeypaths {
    objc_setAssociatedObject(self, kwy_observeredKeypaths, wy_observeredKeypaths, OBJC_ASSOCIATION_COPY);
}
- (void)wy_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if (keyPath) {
        NSMutableSet *keypaths = [NSMutableSet set];
        if (self.wy_observeredKeypaths.count > 0) {
            keypaths = self.wy_observeredKeypaths.mutableCopy;
        }
        [keypaths addObject:keyPath];
        self.wy_observeredKeypaths = keypaths;
    }
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
}
- (void)wy_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    __block NSString *keypathForRemove = nil;;
    NSMutableSet *keypaths = self.wy_observeredKeypaths.mutableCopy;
    [self.wy_observeredKeypaths enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([keyPath isEqualToString:obj]) {
            keypathForRemove = obj;
            *stop = YES;
        }
    }];
    if (keypathForRemove) {
        [keypaths removeObject:keypathForRemove];
        self.wy_observeredKeypaths = keypaths;
        if (context) {
            [self removeObserver:self forKeyPath:keyPath context:context];
        }else {
            [self removeObserver:self forKeyPath:keyPath];
        }
    }
}
- (void)wy_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    [self wy_removeObserver:observer forKeyPath:keyPath context:nil];
}


- (BOOL)wy_isTop {
    if (self.navigationController) {
        return self.navigationController.topViewController == self;
    }
    return NO;
}

@end



/** Camera Video **/
#import "WYCameraVideoOneVC.h"
/** Camera List**/
#import "WYCameraListVC.h"
/** Camera Search **/
#import "WYCameraInstallVC.h"
#import "WYCameraManuallyAddVC.h"
#import "WYCameraTryManuallyAddVC.h"
#import "WYCameraQRCodeMakerVC.h"
#import "WYCameraSearchVC.h"
#import "WYCameraWifiVC.h"
#import "WYCameraSelectKindVC.h"
#import "WYCameraSelectConfigVC.h"
/** Camera Setting **/
#import "WYCameraSettingMotionVC.h"
#import "WYCameraSettingSDCardVC.h"
#import "WYCameraSettingVersionVC.h"
#import "WYCameraSettingSleepmodeVC.h"
#import "WYCameraSettingSleepmodeTimesVC.h"
#import "WYCameraSettingSleepmodeTimesAddVC.h"
#import "WYCameraSettingShareVC.h"
#import "WYCameraSettingNVRVC.h"
#import "WYCameraSettingVC.h"
#import "WYCameraSettingSleepOverTimeVC.h"
#import "WYCameraSettingMessageBoardVC.h"
/** Bell **/
#import "WYDoorBellSettingBellVolumeVC.h"
#import "WYDoorBellSettingHostMessageVC.h"
#import "WYDoorBellSettingPowerManagementVC.h"
#import "WYDoorBellSettingBatteryLockVC.h"
#import "WYDoorBellSettingPIRDetectionVC.h"
#import "WYDoorBellInstallVC.h"
#import "WYDoorbellSettingJingleBellPairingVC.h"
#import "WYDoorBellSettingJingleBellVC.h"
/** NVR **/
#import "WYNVRInstallVC.h"
#import "WYNVRSearchVC.h"
#import "WYNVRSettingVC.h"
#import "WYNVRSettingCameraListVC.h"
#import "WYNVRSettingSelectWIFIVC.h"
#import "WYNVRSettingCameraBindingVC.h"
#import "WYNVRSettingShareVC.h"
/** BabyMonitor **/
#import "WYBabyMonitorMusicVC.h"
/** Friend **/
#import "WYFriendListVC.h"
#import "WYFriendShareVC.h"
/** Message **/
#import "WYMsgVC.h"
#import "WYMsgSystemVC.h"
#import "WYMsgAlarmVC.h"
#import "WYMsgAlarmDetailVC.h"
#import "WYVoiceDoorbellAlarmMsgDetailVC.h"
/** Me **/
#import "WYMeLoginVC.h"
#import "WYMeSignupVC.h"
#import "WYMeChangePasswordVC.h"
#import "WYMeForgotPasswordVC.h"
#import "WYMeMineVC.h"
#import "WYMeMineAvatarVC.h"
#import "WYMeMineNicknameVC.h"
/** Other **/
#import "WYHelpLightVC.h"
#import "WYHelpAPVC.h"

static NSDictionary *wy_vcs = nil;
@implementation UIViewController (WYTransition)
#pragma mark - Life
+ (void)load {
    wy_vcs = @{
       @(WYVCTypeCameraVideoOne)                 : WY_ClassName(WYCameraVideoOneVC),
       @(WYVCTypeCameraList)                     : WY_ClassName(WYCameraListVC),
       @(WYVCTypeCameraInstall)                  : WY_ClassName(WYCameraInstallVC),
       @(WYVCTypeCameraManuallyAdd)              : WY_ClassName(WYCameraManuallyAddVC),
       @(WYVCTypeCameraTryManuallyAdd)           : WY_ClassName(WYCameraTryManuallyAddVC),
       @(WYVCTypeCameraQRCodeMaker)              : WY_ClassName(WYCameraQRCodeMakerVC),
       @(WYVCTypeCameraSearch)                   : WY_ClassName(WYCameraSearchVC),
       @(WYVCTypeCameraWifi)                     : WY_ClassName(WYCameraWifiVC),
       @(WYVCTypeCameraSelectKind)               : WY_ClassName(WYCameraSelectKindVC),
       @(WYVCTypeCameraSelectConfig)             : WY_ClassName(WYCameraSelectConfigVC),
       @(WYVCTypeCameraSettingMotion)            : WY_ClassName(WYCameraSettingMotionVC),
       @(WYVCTypeCameraSettingSDCard)            : WY_ClassName(WYCameraSettingSDCardVC),
       @(WYVCTypeCameraSettingVersion)           : WY_ClassName(WYCameraSettingVersionVC),
       @(WYVCTypeCameraSettingSleepmode)         : WY_ClassName(WYCameraSettingSleepmodeVC),
       @(WYVCTypeCameraSettingSleepmodeTimes)    : WY_ClassName(WYCameraSettingSleepmodeTimesVC),
       @(WYVCTypeCameraSettingSleepmodeAdd)      : WY_ClassName(WYCameraSettingSleepmodeTimesAddVC),
       @(WYVCTypeCameraSettingShare)             : WY_ClassName(WYCameraSettingShareVC),
       @(WYVCTypeCameraSettingNVR)               : WY_ClassName(WYCameraSettingNVRVC),
       @(WYVCTypeCameraSetting)                  : WY_ClassName(WYCameraSettingVC),
       @(WYVCTypeCameraSettingSleepOverTime) : WY_ClassName(WYCameraSettingSleepOverTimeVC),
       @(WYVCTypeCameraSettingMessageBoard):WY_ClassName(WYCameraSettingMessageBoardVC),
       @(WYVCTypeNVRInstall)                     : WY_ClassName(WYNVRInstallVC),
       @(WYVCTypeNVRSearch)                      : WY_ClassName(WYNVRSearchVC),
       @(WYVCTypeNVRSetting)                     : WY_ClassName(WYNVRSettingVC),
       @(WYVCTypeNVRSettingCameraList)           : WY_ClassName(WYNVRSettingCameraListVC),
       @(WYVCTypeNVRSettingSelectWIFI)           : WY_ClassName(WYNVRSettingSelectWIFIVC),
       @(WYVCTypeNVRSettingCameraBinding)        : WY_ClassName(WYNVRSettingCameraBindingVC),
       @(WYVCTypeNVRSettingShare)                : WY_ClassName(WYNVRSettingShareVC),
       @(WYVCTypeBabyMonitorMusic)               : WY_ClassName(WYBabyMonitorMusicVC),
       @(WYVCTypeFriendList)                     : WY_ClassName(WYFriendListVC),
       @(WYVCTypeFriendShare)                    : WY_ClassName(WYFriendShareVC),
       @(WYVCTypeMsg)                            : WY_ClassName(WYMsgVC),
       @(WYVCTypeMsgSystem)                      : WY_ClassName(WYMsgSystemVC),
       @(WYVCTypeMsgAlarm)                       : WY_ClassName(WYMsgAlarmVC),
       @(WYVCTypeMsgAlarmDetail)                 : WY_ClassName(WYMsgAlarmDetailVC),
       @(WYVCTypeVoiceDoorbellAlarm)                 : WY_ClassName(WYVoiceDoorbellAlarmMsgDetailVC),
       @(WYVCTypeMeLogin)                        : WY_ClassName(WYMeLoginVC),
       @(WYVCTypeMeSignup)                       : WY_ClassName(WYMeSignupVC),
       @(WYVCTypeMeChangePassword)               : WY_ClassName(WYMeChangePasswordVC),
       @(WYVCTypeMeForgotPassword)               : WY_ClassName(WYMeForgotPasswordVC),
       @(WYVCTypeMeMine)                         : WY_ClassName(WYMeMineVC),
       @(WYVCTypeMeMineAvatar)                   : WY_ClassName(WYMeMineAvatarVC),
       @(WYVCTypeMeMineNickname)                 : WY_ClassName(WYMeMineNicknameVC),
       @(WYVCTypeHelpLight)                      : WY_ClassName(WYHelpLightVC),
       @(WYVCTypeHelpAP)                         : WY_ClassName(WYHelpAPVC),
       @(WYVCTypePIRDetection)                   : WY_ClassName(WYDoorBellSettingPIRDetectionVC),
       @(WYVCTypeHostMessage)                    : WY_ClassName(WYDoorBellSettingHostMessageVC),
       @(WYVCTypeBellVolume)                     : WY_ClassName(WYDoorBellSettingBellVolumeVC),
        @(WYVCTypeJingleBell)                     : WY_ClassName(WYDoorBellSettingJingleBellVC),
       @(WYVCTypeJingleBellPairing)              : WY_ClassName(WYDoorbellSettingJingleBellPairingVC),
       @(WYVCTypePowerManagement)                : WY_ClassName(WYDoorBellSettingPowerManagementVC),
       @(WYVCTypeBatteryLock)                    : WY_ClassName(WYDoorBellSettingBatteryLockVC),
       @(WYVCTypeDoorBellInstall)                : WY_ClassName(WYDoorBellInstallVC),
    };
}

- (WYVCType)wy_vcType {
    return [UIViewController wy_typeWithVCClass:self.class];
}
- (void)setWy_pushFromVCType:(WYVCType)wy_pushFromVCType {
    objc_setAssociatedObject(self, @selector(wy_pushFromVCType), @(wy_pushFromVCType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (WYVCType)wy_pushFromVCType {
    return [objc_getAssociatedObject(self, @selector(wy_pushFromVCType)) integerValue];
}
- (void)setWy_pushToVCType:(WYVCType)wy_pushToVCType {
    objc_setAssociatedObject(self, @selector(wy_pushToVCType), @(wy_pushToVCType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (WYVCType)wy_pushToVCType {
    return [objc_getAssociatedObject(self, @selector(wy_pushToVCType)) integerValue];
}


- (void)wy_pushToVC:(WYVCType)vcType {
    [self wy_pushToVC:vcType sender:nil];
}
- (void)wy_pushToVC:(WYVCType)vcType sender:(id)sender {
    Class vcCls = [UIViewController wy_vcClassWithType:vcType];
    if ([vcCls isSubclassOfClass:[UIViewController class]] || vcCls == [UIViewController class]) {
        UIViewController <WYTransition> *vc = [vcCls new];
        if (vc) {
            self.wy_pushToVCType = vcType;
            [vc transitionObject:sender fromPage:[UIViewController wy_typeWithVCClass:self.class]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)wy_popToVC:(WYVCType)vcType {
    [self wy_popToVC:vcType sender:nil];
}
- (void)wy_popToVC:(WYVCType)vcType sender:(id)sender {
    Class vcCls = [UIViewController wy_vcClassWithType:vcType];
    UIViewController <WYTransition> *vvc = nil;
    for (UIViewController <WYTransition>*vv in self.navigationController.viewControllers) {
        if (vcCls == vv.class) {
            vvc = vv;
            break;
        }
    }
    if (vvc) {
        [vvc transitionObject:sender fromPage:[UIViewController wy_typeWithVCClass:self.class]];
        [self.navigationController popToViewController:vvc animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)wy_popToRootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)wy_pop {
    if ([self isMemberOfClass: self.navigationController.topViewController.class]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSMutableArray *tmpArr = self.navigationController.viewControllers.mutableCopy;
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [tmpArr enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isMemberOfClass:obj.class]) {
            [indexSet addIndex:idx];
        }
    }];
    if (indexSet.count > 0) {
        [tmpArr removeObjectsAtIndexes:indexSet];
        self.navigationController.viewControllers = tmpArr.copy;
    }
}

- (instancetype)wy_pushFromVC {
    if ([self.navigationController.viewControllers containsObject:self] && [self.navigationController.viewControllers indexOfObject:self] > 0) {
        return self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self] - 1];
    }
    return nil;
}

- (void)wy_presentVC:(WYVCType)vcType sender:(nullable id)sender modalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle{
    UIViewController *vc = [[UIViewController wy_vcClassWithType:vcType] new];
    vc.modalTransitionStyle = modalTransitionStyle;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)wy_dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)wy_dropFromPage:(WYVCType)fromVC toPage:(WYVCType)toVC; {
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    __block NSInteger fromIndex = -1, toIndex = -1;
    [vcs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.wy_vcType == fromVC) {
            fromIndex = idx;
            *stop = YES;
        }
    }];
    [vcs enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.wy_vcType == toVC) {
            toIndex = idx;
            *stop = YES;
        }
    }];
    if (fromIndex == -1 || toIndex == -1 || fromIndex - toIndex <= 1) {
        return;
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(toIndex+1, fromIndex-toIndex-1)];
    [vcs removeObjectsAtIndexes:set];
    self.navigationController.viewControllers = vcs;
}


+ (Class)wy_vcClassWithType:(WYVCType)VCType {
    NSString *vcStr = wy_vcs[@(VCType)];
    if (vcStr) {
        return NSClassFromString(vcStr);
    }
    return nil;
}
+ (WYVCType)wy_typeWithVCClass:(Class)VCClass {
    __block WYVCType vctype = WYVCTypeUnkown;
    if (VCClass) {
        NSString *vcStr = WY_ClassName(VCClass);
        [wy_vcs enumerateKeysAndObjectsUsingBlock:^(NSNumber *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:vcStr]) {
                vctype = key.integerValue;
                *stop = YES;
            }
        }];
    }
    return vctype;
}

@end
