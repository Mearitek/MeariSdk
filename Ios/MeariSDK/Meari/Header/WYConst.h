//
//  WYConst.h
//  Meari
//
//  Created by 李兵 on 16/7/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYSystem.h"

#pragma mark - Customization
UIKIT_EXTERN const WYLanguageType WYAPP_Languages;  //APP 支持的本地话语言
UIKIT_EXTERN NSString *const WYAPP_Album;           //APP 本地相册
UIKIT_EXTERN NSString *const WYAPP_AP_Prefix;       //APP 热点前缀

#pragma mark - Common Const
#pragma mark -- Seconds
UIKIT_EXTERN const float WYSecs_PerMin;
UIKIT_EXTERN const float WYSecs_PerHour;
UIKIT_EXTERN const float WYSecs_PerDay;


#pragma mark - String Const
#pragma mark -- App
UIKIT_EXTERN NSString *const WYPhoneDeviceToken;      //APP: deviceToken
#pragma mark -- System Setting
UIKIT_EXTERN NSString *const WYSetting_Prefs10;       //设置：前缀10以后
UIKIT_EXTERN NSString *const WYSetting_Prefs8;        //设置：前缀8以后
UIKIT_EXTERN NSString *const WYSetting_Privacy;       //设置：隐私
UIKIT_EXTERN NSString *const WYSetting_Wifi;          //设置：wifi
#pragma mark -- Language
UIKIT_EXTERN NSString *const WYStringLanguage_EN;     //英文
UIKIT_EXTERN NSString *const WYStringLanguage_ZH;     //中文
UIKIT_EXTERN NSString *const WYStringLanguage_ZH_Hans;//简体中文
#pragma mark -- DataBase
UIKIT_EXTERN NSString *const WYEntity_DeviceAlertMsg; //数据库：报警
#pragma mark -- Notifiaction
UIKIT_EXTERN NSString *const WYNotification_User_LandInOtherPlace;
UIKIT_EXTERN NSString *const WYNotification_User_MqttRedirect;
UIKIT_EXTERN NSString *const WYNotification_User_ChangeNickname;
UIKIT_EXTERN NSString *const WYNotification_Device_Add;
UIKIT_EXTERN NSString *const WYNotification_Device_Delete;
UIKIT_EXTERN NSString *const WYNotification_Device_ChangeNickname;
UIKIT_EXTERN NSString *const WYNotification_Devices_ChangeAlarmMsgReadFlag;
UIKIT_EXTERN NSString *const WYNotification_Device_ChangeParam;
UIKIT_EXTERN NSString *const WYNotification_Device_ConnectCompleted;
UIKIT_EXTERN NSString *const WYNotification_Device_CancelShare;
UIKIT_EXTERN NSString *const WYNotification_Device_OnOffline;
UIKIT_EXTERN NSString *const WYNotification_Device_BindUnBindNVR;
UIKIT_EXTERN NSString *const WYNotification_Device_Snapshot;
UIKIT_EXTERN NSString *const WYNotification_Device_VisitorCallShow;
UIKIT_EXTERN NSString *const WYNotification_Device_VisitorCallDismiss;
UIKIT_EXTERN NSString *const WYNotification_App_RefreshCameraList;

#pragma mark -- UserDefaults--UserKey
UIKIT_EXTERN NSString *const WYUserKeyPreviousAccount;  //账号:上一个

#pragma mark -- Device Command
UIKIT_EXTERN NSString *const WYCom_Storage_Get;       //存储：获取
UIKIT_EXTERN NSString *const WYCom_Motion_Get;        //报警：获取
UIKIT_EXTERN NSString *const WYCom_Motion_Set;        //     设置
UIKIT_EXTERN NSString *const WYCom_Sleepmode_Get;     //休眠：获取
UIKIT_EXTERN NSString *const WYCom_Sleepmode_Set;     //     设置
UIKIT_EXTERN NSString *const WYCom_OutVolume_Get;     //音量：获取
UIKIT_EXTERN NSString *const WYCom_OutVolume_Set;     //     设置
UIKIT_EXTERN NSString *const WYCom_TRH_Get;           //温湿度
UIKIT_EXTERN NSString *const WYCom_Version_Get;       //版本：获取
UIKIT_EXTERN NSString *const WYCom_Pir_Set;           //Pir：设置
