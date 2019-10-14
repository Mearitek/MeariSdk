//
//  WYConst.m
//  Meari
//
//  Created by 李兵 on 16/7/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYConst.h"

#pragma mark - Customization
const WYLanguageType WYAPP_Languages    = WYLanguageTypeCustomizationMeari;
NSString *const WYAPP_Album             = @"MeariSDK";
NSString *const WYAPP_AP_Prefix         = @"STRN";

#pragma mark - Common Const
#pragma mark -- Seconds
const float WYSecs_PerMin     =  60.0f;
const float WYSecs_PerHour    =  3600.0f;
const float WYSecs_PerDay     =  86400.0f;

#pragma mark - String Const
#pragma mark -- App
NSString *const WYPhoneDeviceToken      = @"WYPhoneDeviceToken";

#pragma mark -- System Setting
NSString *const WYSetting_Prefs10       = @"app-Prefs:";
NSString *const WYSetting_Prefs8        = @"prefs:";
NSString *const WYSetting_Privacy       = @"root=Privacy";
NSString *const WYSetting_Wifi          = @"root=WIFI";
#pragma mark -- Language
NSString *const WYStringLanguage_EN        = @"en";
NSString *const WYStringLanguage_ZH        = @"zh";
NSString *const WYStringLanguage_ZH_Hans   = @"zh-Hans";
#pragma mark -- DataBase
NSString *const WYEntity_DeviceAlertMsg    = @"DeviceAlertMsg";
#pragma mark -- Notifiaction
NSString *const WYNotification_User_LandInOtherPlace = @"WYNotification_User_LandInOtherPlace";
NSString *const WYNotification_User_MqttRedirect = @"WYNotification_User_MqttRedirect";
NSString *const WYNotification_User_ChangeNickname = @"WYNotification_User_ChangeNickname";
NSString *const WYNotification_Device_Add = @"WYNotification_Device_Add";
NSString *const WYNotification_Device_Delete = @"WYNotification_Device_Delete";
NSString *const WYNotification_Device_ChangeNickname = @"WYNotification_Device_ChangeNickname";
NSString *const WYNotification_Device_ChangeParam     = @"WYNotification_Device_ChangeParam";
NSString *const WYNotification_Devices_ChangeAlarmMsgReadFlag = @"WYNotification_Devices_ChangeAlarmMsgReadFlag";
NSString *const WYNotification_Device_ConnectCompleted = @"WYNotification_Device_ConnectCompleted";
NSString *const WYNotification_Device_CancelShare = @"WYNotification_Device_CancelShare";
NSString *const WYNotification_Device_OnOffline = @"WYNotification_Device_OnOffline";
NSString *const WYNotification_Device_BindUnBindNVR = @"WYNotification_Device_BindUnBindNVR";
NSString *const WYNotification_Device_Snapshot = @"WYNotification_Device_Snapshot";
NSString *const WYNotification_Device_VisitorCallShow = @"WYNotification_Device_VisitorCallShow";
NSString *const WYNotification_Device_VisitorCallDismiss = @"WYNotification_Device_VisitorCallDismiss";
NSString *const WYNotification_App_RefreshCameraList = @"WYNotification_App_RefreshCameraList";

#pragma mark -- UserDefaults--UserKey
NSString *const WYUserKeyPreviousAccount        = @"WYUserKeyPreviousAccount";

#pragma mark -- Device Command
NSString *const WYCom_Storage_Get               = @"WYCom_Storage_Get";
NSString *const WYCom_Motion_Get                = @"WYCom_Motion_Get";
NSString *const WYCom_Motion_Set                = @"WYCom_Motion_Set";
NSString *const WYCom_Sleepmode_Get             = @"WYCom_Sleepmode_Get";
NSString *const WYCom_Sleepmode_Set             = @"WYCom_Sleepmode_Set";
NSString *const WYCom_OutVolume_Get             = @"WYCom_OutVolume_Get";
NSString *const WYCom_OutVolume_Set             = @"WYCom_OutVolume_Set";
NSString *const WYCom_TRH_Get                   = @"WYCom_TRH_Get";
NSString *const WYCom_Version_Get               = @"WYCom_Version_Get";
NSString *const WYCom_Pir_Set                   = @"WYCom_Pir_Set";
