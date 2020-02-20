//
//  WYCameraSettingModel.h
//  Meari
//
//  Created by 李兵 on 16/7/21.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, WYSettingCellType) {
    WYSettingCellTypePreviewName,
    WYSettingCellTypeOwner,
    WYSettingCellTypeSN,
    WYSettingCellTypeMirror,
    WYSettingCellTypeMotion,
    WYSettingCellTypeVersion,
    WYSettingCellTypeSdcard,
    WYSettingCellTypeShare,
    WYSettingCellTypeNVR,
    WYSettingCellTypeSleepMode,
    
    WYSettingCellTypePIRDetection,
    WYSettingCellTypeBatteryLock,
    WYSettingCellTypeClearRecords,
    WYSettingCellTypeHostMessage,
    WYSettingCellTypeMessageBoard,
    WYSettingCellTypeSleepOverTime,
    WYSettingCellTypeBellVolume,
    WYSettingCellTypeJingleBell,
    WYSettingCellTypePowerManagement
};
@interface WYCameraSettingModel : NSObject

@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *detailedText;
@property (nonatomic, assign)WYSettingCellType type;
@property (nonatomic, assign)WYSettingAccesoryType accesoryType;
@property (nonatomic, strong)UIColor *textColor;


//普通
+ (instancetype)previewNameModel;
+ (instancetype)ownerModel;
+ (instancetype)snModel;
+ (instancetype)shareModel;
+ (instancetype)nvrModel;
+ (instancetype)mirrorModel;
+ (instancetype)motionModel;
+ (instancetype)versionModel;
+ (instancetype)sdcardModel;
+ (instancetype)sleepmodeModel;

//分享
+ (instancetype)sharedNVRModel;
+ (instancetype)sharedMirrorModel;
+ (instancetype)sharedMotionModel;
+ (instancetype)sharedVersionModel;
//门铃
+ (instancetype)PIRDetectionModel;
+ (instancetype)BatteryLockModel;
+ (instancetype)HostMessageModel;
+ (instancetype)PowerManagementModel;
+ (instancetype)BellVolumeModel;
+ (instancetype)JingleBellModel;

// 语音门铃
+ (instancetype)clearAllVistorMsgModel;
+ (instancetype)sleepOverTimeModel;
+ (instancetype)messageBoardModel;

//-分享
+ (instancetype)sharedPIRDetectionModel;

@end
