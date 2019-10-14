//
//  WYTransition.h
//  Meari
//
//  Created by 李兵 on 16/1/15.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#ifndef WYTransition_h
#define WYTransition_h


typedef NS_ENUM(NSInteger, WYVCType) {
    WYVCTypeUnkown,
    /** Camera Video **/
    WYVCTypeCameraVideoOne,
    /** Camera List**/
    WYVCTypeCameraList,
    /** Camera Search **/
    WYVCTypeCameraInstall,
    WYVCType4GCameraInstall,
    WYVCTypeCameraManuallyAdd,
    WYVCTypeCameraTryManuallyAdd,
    WYVCTypeCameraQRCodeMaker,
    WYVCTypeCameraSearch,
    WYVCTypeCameraWifi,
    WYVCTypeCameraSelectKind,
    WYVCTypeCameraSelectConfig,
    /** Camera Setting **/
    WYVCTypeCameraSettingMotion,
    WYVCTypeCameraSettingSDCard,
    WYVCTypeCameraSettingVersion,
    WYVCTypeCameraSettingSleepmode,
    WYVCTypeCameraSettingSleepmodeTimes,
    WYVCTypeCameraSettingSleepmodeAdd,
    WYVCTypeCameraSettingShare,
    WYVCTypeCameraSettingNVR,
    WYVCTypeCameraSetting,
    /** NVR **/
    WYVCTypeNVRInstall,
    WYVCTypeNVRSearch,
    WYVCTypeNVRSetting,
    WYVCTypeNVRSettingCameraList,
    WYVCTypeNVRSettingSelectWIFI,
    WYVCTypeNVRSettingCameraBinding,
    WYVCTypeNVRSettingShare,
    /** BabyMonitor **/
    WYVCTypeBabyMonitorMusic,
    /** Friend **/
    WYVCTypeFriendList,
    WYVCTypeFriendShare,
    /** Message **/
    WYVCTypeMsg,
    WYVCTypeMsgSystem,
    WYVCTypeMsgAlarm,
    WYVCTypeMsgAlarmDetail,
    WYVCTypeVoiceDoorbellAlarm,
    /** Me **/
    WYVCTypeMeLogin,
    WYVCTypeMeSignup,
    WYVCTypeMeChangePassword,
    WYVCTypeMeForgotPassword,
    WYVCTypeMeMine,
    WYVCTypeMeMineAvatar,
    WYVCTypeMeMineNickname,
    /** Other **/
    WYVCTypeQRCodeLogin,
    WYVCTypeHelpLight,
    WYVCTypeHelpAP,
    /** Bell */
    WYVCTypeDoorBellInstall,
    WYVCTypeDoorBellHelpLight,
    WYVCTypePIRDetection,
    WYVCTypeHostMessage,
    WYVCTypeBellVolume,
    WYVCTypeJingleBell,
    WYVCTypeJingleBellPairing,
    WYVCTypePowerManagement,
    WYVCTypeBatteryLock,
    WYVCTypeConfig,
};


@protocol WYTransition <NSObject>

@optional
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType;

@end

#endif /* WYTransition_h */
