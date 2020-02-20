//
//  WYUserManger.m
//  Meari
//
//  Created by Strong on 15/11/26.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "WYUserManger.h"
#import "User+CoreDataProperties.h"


@interface WYUserManger ()

@end

@implementation WYUserManger
#pragma mark - Private
#pragma mark -- Init
- (void)_initSet {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginInvalidNotification:) name:MeariUserLoginInvalidNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceHasVisitorNotification:) name:MeariDeviceHasVisitorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceHasVoiceBellVisitorNotification:) name:MeariDeviceVoiceBellHasVisitorNotification object:nil];
}

#pragma mark -- Notification
- (void)userLoginInvalidNotification:(NSNotification *)notification {
    //需要跳转登录界面，重新登录
    NSLog(@"meari login invalid");
    [self forceSignout];
}
- (void)deviceHasVisitorNotification:(NSNotification *)sender {
    if (!WY_IsKindOfClass(sender.object, MeariMqttMessageInfo)) {
        return;
    }
    MeariMqttMessageInfo *msg = sender.object;
    WYPushModel *pushModel = WY_FaceTime.pushModel;
    if ([pushModel.msgID isEqualToString:msg.data.msgID] &&
        !msg.data.hostKey.length) {
        WY_FaceTime.visitorImg = pushModel.imgUrl;
        return;
    }
    [UIDevice wy_forceOrientationPortrait];
    WYPushModel *model = [[WYPushModel alloc] init];
    model.hostKey = msg.data.hostKey;
    model.deviceUUID = msg.data.deviceUUID;
    model.deviceName = msg.data.deviceName;
    model.msgID = msg.data.msgID;
    model.bellVoice = msg.data.bellVoice;
    model.imgUrl = msg.data.imgUrl;
    model.msgTime = msg.t;
    model.deviceP2P = msg.data.deviceP2P;
    model.p2pInit = msg.data.p2pInit;
    [WY_FaceTime showWithType:WYFaceTimeType_mqtt];
    WY_FaceTime.pushModel = model;
    WY_FaceTime.MQTTID = msg.msgid;
}
- (void)deviceHasVoiceBellVisitorNotification:(NSNotification *)sender {
    if (!WY_IsKindOfClass(sender.object, MeariMqttMessageInfo)) {
        return;
    }
    MeariMqttMessageInfo *msg = sender.object;
    WYPushModel *pushModel = WY_FaceTime.pushModel;
    if ([pushModel.msgID isEqualToString:msg.data.msgID] &&
        !msg.data.hostKey.length) {
        WY_FaceTime.visitorImg = pushModel.imgUrl;
        return;
    }
    [UIDevice wy_forceOrientationPortrait];
    WYPushModel *model = [[WYPushModel alloc] init];
    model.hostKey = msg.data.hostKey;
    model.deviceUUID = msg.data.deviceUUID;
    model.deviceName = msg.data.deviceName;
    model.type = msg.data.devType;
    model.msgID = msg.data.msgID;
    model.bellVoice = msg.data.bellVoice;
    model.msgTime = msg.t;
    model.deviceP2P = msg.data.deviceP2P;
    model.p2pInit = msg.data.p2pInit;
    model.deviceID = msg.data.deviceID;
    model.pushType = WYPushTypeVoiceCall;
    model.subType = msg.data.devSubType;
    [WY_FaceTime showWithType:WYFaceTimeType_mqtt];
    WY_FaceTime.pushModel = model;
    WY_FaceTime.MQTTID = msg.msgid;
}


#pragma mark -- Utilities
- (void)forceSignout {
    [self signOut];
    [WYAlertView show_User_LoginInvalidWithOtherAction:^{
        [WY_Appdelegate wy_loadLoginVC];
    }];
}

#pragma mark - Public
WY_Singleton_Implementation(WYUserManger)
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _initSet];
    }
    return self;
}

#pragma mark - Getter
- (BOOL)isLogined {
    return [MeariUser sharedInstance].isLogined;
}
- (BOOL)isUidLogined {
    return [MeariUser sharedInstance].accountType == MeariUserAccountTypeUid;
}
- (NSString *)account {
    return [MeariUser sharedInstance].userInfo.userAccount;
}
- (NSString *)avatar {
    return [MeariUser sharedInstance].userInfo.avatarUrl;
}
- (NSString *)nickname {
    return [MeariUser sharedInstance].userInfo.nickName;
}
- (NSString *)pushAlias {
    return [MeariUser sharedInstance].userInfo.pushAlias;
}

#pragma mark -- Utilities
- (void)_signIn_push {
    [WYPushManager signInMeariPush:[WY_UserM getUserObjectForKey:WYPhoneDeviceToken]];
}
- (void)_signOut_push {
    [WYPushManager signOut];
}

#pragma mark - Public

/**
 账号
 */
- (NSString *)previousUserAccount {
    return [self getUserObjectForKey:WYUserKeyPreviousAccount] ?: nil;
}
- (void)setPreviousUserAccount:(NSString *)previousUserAccount {
    [self setUserObject:previousUserAccount forkey:WYUserKeyPreviousAccount];
}

/**
 基本操作
 */
- (void)setUserObject:(id)obj forkey:(NSString *)key {
    [WY_UserDefaults wy_setObject:obj forkey:key];
}
- (id)getUserObjectForKey:(NSString *)key {
    return [WY_UserDefaults wy_objectForKey:key];
}
- (void)removeUserObjectforKey:(NSString *)key {
    [WY_UserDefaults wy_removeObjectforKey:key];
}


/**
 登入登出
 */
- (void)signIn:(MeariUserInfo *)userInfo {
    self.previousUserAccount = userInfo.userAccount;
    [self _signIn_push];
}
- (void)signOut {
    [self _signOut_push];
}


- (void)dealMeariUserError:(NSError *)error {
    MeariUserCode code = error.code;
    if (code == MeariUserCodeUserTokeyMissing) {
        [self forceSignout];
    }else {
        WY_HUD_SHOW_ERROR(error)
    }
}






@end








