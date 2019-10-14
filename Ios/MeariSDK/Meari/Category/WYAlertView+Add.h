//
//  WYAlertView+Add.h
//  Meari
//
//  Created by 李兵 on 2017/1/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYAlertView.h"

@interface WYAlertView (Add)
//升级
+ (void)showAppNeedUpdateWithForced:(BOOL)forced content:(NSString *)content updateAction:(WYBlock_Void)updateAction;
+ (void)showDeviceNeedUpdateWithDescription:(NSString *)description stytle:(WYUIStytle)stytle cancelAction:(WYBlock_Void)cancelAction updateAction:(WYBlock_Void)updateAction;
+ (void)showSharedDeviceNeedUpdate:(WYBlock_Void)updateAction;

//删除
+ (void)showDeleteFriend:(WYBlock_Void)deleteAction;

//消息
+ (void)showMsg_DeleteWithOtherAction:(WYBlock_Void)otherAction;
+ (void)showMsg_AgreeRefuseWithDescription:(NSString *)description cancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction;
//Mine
+ (void)showLogout:(WYBlock_Void)logoutAction;

+ (void)showNeedAuthorityOfLocationServices ;

+ (void)showOKWithMessage:(NSString *)message;
+ (void)showOKWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showNoNetwork;
+ (void)showNoWifi;
+ (void)showNoWifiPasswordWithCancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction;;
+ (void)showAPWifiError;
+ (void)showAPFailureWithCancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction;
+ (void)showSearchNullWithCancelAction:(WYBlock_Void)cancelAction otherAction:(WYBlock_Void)otherAction;
+ (void)showSearchCameraNullWithCancelAction:(WYBlock_Void)cancelAction qrAction:(WYBlock_Void)qrAction;
+ (void)showSearchCameraNullWithCancelAction:(WYBlock_Void)cancelAction apAction:(WYBlock_Void)apAction;
+ (void)showDeviceLowVersionWithStytle:(WYUIStytle)stytle;
+ (void)showNoSDCardWithStytle:(WYUIStytle)stytle;


#pragma mark -- Need Authority
+ (void)showNeedAuthorityOfPhoto;
+ (void)showNeedAuthorityOfMicrophone;
+ (void)showNeedAuthorityOfCamera;

#pragma mark -- mqtt
+ (void)show_Device_CancelShare:(NSString *)deviceName;
+ (void)show_Device_Online;
+ (void)show_Device_Offline;
+ (void)show_User_LandInOtherPlaceWithOtherAction:(WYBlock_Void)otherAction;
+ (void)show_Device_OnlineTimeout:(WYBlock_Void)timeoutAction;
+ (void)show_User_LoginInvalidWithOtherAction:(WYBlock_Void)otherAction;


@end
