//
//  WYPushManager.m
//  Meari
//
//  Created by 李兵 on 2017/5/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYPushManager.h"
#import "WYAppDelegate+Extension.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
@import UserNotifications;
#endif
@import AudioToolbox;

#define WY_PushM [WYPushManager sharedWYPushManager]

@interface WYPushManager()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong, readwrite)WYPushModel *pushModel;
@property (nonatomic, copy)WYPushBlock dealSystemClicked;
@property (nonatomic, copy)WYPushBlock dealAlarmClicked;
@property (nonatomic, copy)WYPushBlock dealVisitorCallClicked;
@property (nonatomic, copy)WYPushBlock dealVisitorCallShow;
@property (nonatomic, copy)WYPushBlock dealVoiceCallClicked;
@property (nonatomic, copy)WYPushBlock dealVoiceCallShow;
@property (nonatomic, copy)WYPushBlock dealSystemShown;
@property (nonatomic, copy)WYPushBlock dealAlarmShown;
@end


@implementation WYPushManager
#pragma mark - Private
#pragma mark -- Utilities
+ (void)setPushModelWithDictionary:(NSDictionary *)dic {
    if (!WY_IsKindOfClass(dic, NSDictionary) || dic.count <= 0) return;
    WYPushModel *model = [WYPushModel mj_objectWithKeyValues:dic];
    switch (model.msgType) {
        case 0: {
            model.pushType = WYPushTypeAlarm;
            break;
        }
        case 1: {
            model.pushType = WYPushTypeSystem;
            break;
        }
        case 2: {
            if (model.devTypeID == 6) {
                model.pushType = WYPushTypeVoiceCall;
            } else {
                model.pushType = WYPushTypeVisitorCall;
            }
        }
        default:
            model.msgType = WYPushTypeNone;
            break;
    }
    WY_PushM.pushModel = model;
    
}
- (void)dealPushAfterClicked {
    switch (self.pushModel.pushType) {
        case WYPushTypeAlarm: {
            WYDo_Block_Safe1(self.dealAlarmClicked, self.pushModel)
            break;
        }
        case WYPushTypeSystem: {
            WYDo_Block_Safe1(self.dealSystemClicked, self.pushModel)
            break;
        }
        case WYPushTypeVisitorCall: {
            WYDo_Block_Safe1(self.dealVisitorCallClicked, self.pushModel)
            break;
        }
        case WYPushTypeVoiceCall: {
            WYDo_Block_Safe1(self.dealVoiceCallClicked, self.pushModel)
            break;
        }
        default:break;
    }
}
- (void)dealPushAfterShown {
    switch (self.pushModel.pushType) {
        case WYPushTypeAlarm: {
            WYDo_Block_Safe1(self.dealAlarmShown, self.pushModel)
        }
        case WYPushTypeSystem: {
            WYDo_Block_Safe1(self.dealSystemShown, self.pushModel)
            break;
        }
        case WYPushTypeVisitorCall: {
            WYDo_Block_Safe1(self.dealVisitorCallShow, self.pushModel)
            break;
        }
        case WYPushTypeVoiceCall: {
            WYDo_Block_Safe1(self.dealVoiceCallShow, self.pushModel)
            break;
        }
        default:break;
    }
}

#pragma mark - Delegate
#pragma mark -- MeariPushDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    NSString *title = content.title;
    NSString *subtitle = content.subtitle;
    UNNotificationSound *sound = content.sound;
    
    [NSThread wy_doOnMainThread:^{
        [WY_Application setApplicationIconBadgeNumber:badge.integerValue];
        if (!WY_UserM.logined) return;
        if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSLog(@"远程推送，呈现:%@", userInfo);
            
            [WYPushManager dealPushInfo:userInfo userClicked:NO];
            WY_WeakSelf
            [WY_NotificationCenter wy_post_Devices_ChangeAlarmMsgReadFlag:^(NSMutableArray<WYObj_Device *> *devices) {
                WYObj_Device *device = [WYObj_Device new];
                device.deviceID = weakSelf.pushModel.deviceID;
                device.hasUnreadMsg = YES;
                [devices addObject:device];
            }];
        } else {
            NSLog(@"本地推送，呈现:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}", body, title, subtitle, badge, sound, userInfo);
        }
        if (WY_FaceTime.alpha && !WY_FaceTime.answering) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        }
        if ([WY_FaceTime.pushModel.hostKey isEqualToString:WY_PushM.pushModel.hostKey] &&
            [MeariUser sharedInstance].isConnected) {
            return;
        }
         UNNotificationPresentationOptions pushOptions = UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert;
        completionHandler(pushOptions);
    }];
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    UNNotificationRequest *request = response.notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    NSString *title = content.title;
    NSString *subtitle = content.subtitle;
    UNNotificationSound *sound = content.sound;
    
    
    [NSThread wy_doOnMainThread:^{
        [WY_Application setApplicationIconBadgeNumber:badge.integerValue];
        if (!WY_UserM.logined) return;
        if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSLog(@"远程推送，点击:%@", userInfo);
            
            [WYPushManager dealPushInfo:userInfo userClicked:YES];
        } else {
            NSLog(@"本地推送，点击:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}", body, title, subtitle, badge, sound, userInfo);
        }
        completionHandler();
    }];
}

#pragma mark - Public
/** 单俐 **/
WY_Singleton_Implementation(WYPushManager)

/** 初始化 **/
+ (void)registerPushWithOptions:(NSDictionary *)options {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = [WYPushManager sharedWYPushManager];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [self setPushModelWithDictionary:options[UIApplicationLaunchOptionsRemoteNotificationKey]];
}
+ (void)registerDeviceToken:(NSData *)deviceToken {
    [WY_UserM setUserObject:deviceToken forkey:WYPhoneDeviceToken];
    if (WY_UserM.isLogined) {
        [self signInMeariPush:deviceToken];
    }else {
        [self signOut];
    }
}
/** Meari Push **/
+ (void)signInMeariPush:(NSData *)deviceToken {
    if (!WY_UserM.logined) return;
    if (!deviceToken) {
        NSLog(@"--get device token fail--");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self signInMeariPush:deviceToken];
        });
        return;
    }
    [[MeariUser sharedInstance] registerPushWithDeviceToken:deviceToken success:^(NSDictionary *dict) {
        NSLog(@"--login push success--%@", dict);
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self signInMeariPush:deviceToken];
        });
    }];
}

/** 登入登出 **/
+ (void)signInWithIdentifier:(NSString *)identifier callback:(WYBlock_Str)callback {
//    [self _setAlias:identifier callBack:callback];
}
+ (void)signOut {
    [self resetBadgeNumber];
//    [self _deleteAlias:nil];
}

/** 内容 **/
+ (void)customHandleWithPushModel:(WYPushBlock)handle {
    WYDo_Block_Safe1(handle, WY_PushM.pushModel)
}

/** 处理角标 **/
+ (void)resetBadgeNumber {
    [WY_Application setApplicationIconBadgeNumber:0];
//    [JPUSHService resetBadge];
}
+ (void)decrementBadgeNumber {
    NSInteger num = WY_Application.applicationIconBadgeNumber - 1;
    num = num < 0 ? 0 : num;
    [WY_Application setApplicationIconBadgeNumber:num];
//    [JPUSHService setBadge:num];
}

/** 处理推送 **/
+ (void)dealAlarmShown:(WYPushBlock)block {
    WY_PushM.dealAlarmShown = block;
}
+ (void)dealAlarmClicked:(WYPushBlock)block {
    WY_PushM.dealAlarmClicked = block;
}
+ (void)dealVisitiorCallShow:(WYPushBlock)block {
    WY_PushM.dealVisitorCallShow = block;
}
+ (void)dealVisitiorCallClicked:(WYPushBlock)block {
    WY_PushM.dealVisitorCallClicked = block;
}
+ (void)dealVoiceCallShow:(WYPushBlock)block {
    WY_PushM.dealVoiceCallShow = block;
}
+ (void)dealVoiceCallClicked:(WYPushBlock)block {
    WY_PushM.dealVoiceCallClicked = block;
}
+ (void)dealSystemShown:(WYPushBlock)block {
    WY_PushM.dealSystemShown = block;
}
+ (void)dealSystemClicked:(WYPushBlock)block {
    WY_PushM.dealSystemClicked = block;
}
+ (void)dealPushInfo:(NSDictionary *)pushInfo userClicked:(BOOL)clicked {
    [self setPushModelWithDictionary:pushInfo];
    if (clicked) {
        [self decrementBadgeNumber];
        [WY_PushM dealPushAfterClicked];
    }else {
        if (WY_Application.applicationState == UIApplicationStateActive) {
            [self decrementBadgeNumber];
        }
        [WY_PushM dealPushAfterShown];
        if ([WY_FaceTime.pushModel.hostKey isEqualToString:WY_PushM.pushModel.hostKey] &&
            [MeariUser sharedInstance].isConnected) {
            return;
        }
        [self playSoundAndShake];
    }
}

/** 声音 **/
+ (void)playSound {
    AudioServicesPlaySystemSound(1007);
}
+ (void)playShake {
    SystemSoundID soundID = kSystemSoundID_Vibrate;
    AudioServicesPlaySystemSound(soundID);
}
+ (void)playSoundAndShake {
    [self playShake];
    [self playSound];
}

@end


@implementation WYPushModel
- (NSString *)connectName {
    return @"admin";
}
@end
