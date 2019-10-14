//
//  NSNotificationCenter+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/6/24.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "NSNotificationCenter+Extension.h"

@implementation NSNotificationCenter (Extension)
#pragma mark - Private
- (void)_wy_postNotificationName:(NSString *)notificationName obj:(id)obj completion:(WYBlock_ID)completion {
    WYDo_Block_Safe1(completion, obj);
    [NSThread wy_doOnMainThread:^{
        [self postNotificationName:notificationName object:obj];
    }];
}

#pragma mark - Public
#pragma mark -- User
- (void)wy_post_User_LandInOtherPlace:(WYBlock_User)completion {
    [self _wy_postNotificationName:WYNotification_User_LandInOtherPlace obj:[WYObj_User new] completion:completion];
}
#pragma mark -- Device
- (void)wy_post_Device_Add:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_Add obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_Delete:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_Delete obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_ChangeNickname:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_ChangeNickname obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Devices_ChangeAlarmMsgReadFlag:(WYBlock_Devices)completion {
    [self _wy_postNotificationName:WYNotification_Devices_ChangeAlarmMsgReadFlag obj:[NSMutableArray array] completion:completion];
}
- (void)wy_post_Device_ChangeParam:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_ChangeParam obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_ConnectCompleted:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_ConnectCompleted obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_CancelShare:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_CancelShare obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_OnOffline:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_OnOffline obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_BindUnBindNVR:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_BindUnBindNVR obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_Snapshot:(WYBlock_Device)completion {
    [self _wy_postNotificationName:WYNotification_Device_Snapshot obj:[WYObj_Device new] completion:completion];
}
- (void)wy_post_Device_VisitorCallShow {
    [self _wy_postNotificationName:WYNotification_Device_VisitorCallShow obj:nil completion:nil];
}
- (void)wy_post_Device_VisitorCallDismiss {
    [self _wy_postNotificationName:WYNotification_Device_VisitorCallDismiss obj:nil completion:nil];
}
- (void)wy_post_App_RefreshCameraList {
    [self _wy_postNotificationName:WYNotification_App_RefreshCameraList obj:nil completion:nil];
}
@end

#pragma mark -  Notification Object
@implementation WYObj_Device
@end

@implementation WYObj_User
@end
