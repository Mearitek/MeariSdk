//
//  WYCameraSettingModel.m
//  Meari
//
//  Created by 李兵 on 16/7/21.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSettingModel.h"

@implementation WYCameraSettingModel
+ (instancetype)modelWithImageName:(NSString *)imageName text:(NSString *)text detailedText:(NSString *)detailedText type:(WYSettingCellType)type textColor:(UIColor *)textColor {
    
    WYCameraSettingModel *model = [[WYCameraSettingModel alloc] init];
    model.imageName = imageName;
    model.text = text;
    model.detailedText = detailedText;
    model.type = type;
    model.textColor = textColor;
    return model;
}

+ (instancetype)previewNameModel {
    return [WYCameraSettingModel modelWithImageName:nil
                                               text:WYLocalString(@"Preview name")
                                       detailedText:nil
                                               type:WYSettingCellTypePreviewName
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)ownerModel {
    return [WYCameraSettingModel modelWithImageName:nil
                                               text:WYLocalString(@"Owner")
                                       detailedText:nil
                                               type:WYSettingCellTypeOwner
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)clearAllVistorMsgModel {
    return [WYCameraSettingModel modelWithImageName:@"nav_delete_highlighted"
                                               text:WYLocalString(@"setting_clear_record")
                                       detailedText:nil
                                               type:WYSettingCellTypeClearRecords
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)sleepOverTimeModel {
    return [WYCameraSettingModel modelWithImageName:@""
                                               text:WYLocalString(@"Sleep Over Time")
                                       detailedText:nil
                                               type:WYSettingCellTypeSleepOverTime
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)messageBoardModel {
    return [WYCameraSettingModel modelWithImageName:@"img_doorbell_host_message"
                                               text:WYLocalString(@"device_setting_message_board")
                                       detailedText:nil
                                               type:WYSettingCellTypeMessageBoard
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)snModel {
    return [WYCameraSettingModel modelWithImageName:nil
                                               text:WYLocalString(@"SN")
                                       detailedText:nil
                                               type:WYSettingCellTypeSN
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)shareModel {
    return [WYCameraSettingModel modelWithImageName:@"img_camera_setting_share"
                                               text:WYLocalString(@"Share")
                                       detailedText:nil
                                               type:WYSettingCellTypeShare
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)nvrModel {
    return [WYCameraSettingModel modelWithImageName:@"img_camera_setting_nvr"
                                               text:WYLocalString(@"NVR")
                                       detailedText:nil
                                               type:WYSettingCellTypeNVR
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)mirrorModel {
    return [WYCameraSettingModel modelWithImageName:@"img_camera_setting_mirror"
                                               text:WYLocalString(@"Video flip")
                                       detailedText:nil
                                               type:WYSettingCellTypeMirror
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)motionModel {
    return [WYCameraSettingModel modelWithImageName:@"img_camera_setting_motion"
                                               text:WYLocalString(@"Motion")
                                       detailedText:nil
                                               type:WYSettingCellTypeMotion
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)versionModel {
    return [WYCameraSettingModel modelWithImageName:@"img_camera_setting_version"
                                               text:WYLocalString(@"Version")
                                       detailedText:nil
                                               type:WYSettingCellTypeVersion
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)sdcardModel {
    return [WYCameraSettingModel modelWithImageName:@"img_camera_setting_sdcard"
                                               text:WYLocalString(@"SD card")
                                       detailedText:nil
                                               type:WYSettingCellTypeSdcard
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)sleepmodeModel {
    return [WYCameraSettingModel modelWithImageName:@"img_camera_setting_sleepmode"
                                               text:WYLocalString(@"SleepMode")
                                       detailedText:nil
                                               type:WYSettingCellTypeSleepMode
                                          textColor:WY_FontColor_Black];
}

+ (instancetype)sharedNVRModel {
    WYCameraSettingModel *model = [WYCameraSettingModel nvrModel];
    model.imageName = @"img_camera_setting_nvr_shared";
    model.textColor = WY_FontColor_Disabled;
    return model;
}
+ (instancetype)sharedMirrorModel {
    WYCameraSettingModel *model = [WYCameraSettingModel mirrorModel];
    model.imageName = @"img_camera_setting_mirror_shared";
    model.textColor = WY_FontColor_Disabled;
    return model;
}
+ (instancetype)sharedMotionModel {
    WYCameraSettingModel *model = [WYCameraSettingModel motionModel];
    model.imageName = @"img_camera_setting_motion_shared";
    model.textColor = WY_FontColor_Disabled;
    return model;
}
+ (instancetype)sharedVersionModel {
    WYCameraSettingModel *model = [WYCameraSettingModel versionModel];
    model.imageName = @"img_camera_setting_version_shared";
    model.textColor = WY_FontColor_Disabled;
    return model;
}

+ (instancetype)PIRDetectionModel {
    return [WYCameraSettingModel modelWithImageName:@"btn_doorbell_pir_highlighted"
                                               text:WYLocalString(@"Pir Detection")
                                       detailedText:nil
                                               type:WYSettingCellTypePIRDetection
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)BatteryLockModel {
    return [WYCameraSettingModel modelWithImageName:@"img_doorbell_battery_lock"
                                               text:WYLocalString(@"Battery Lock")
                                       detailedText:nil
                                               type:WYSettingCellTypeBatteryLock
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)HostMessageModel {
    return [WYCameraSettingModel modelWithImageName:@"img_doorbell_host_message"
                                               text:WYLocalString(@"Host Message")
                                       detailedText:nil
                                               type:WYSettingCellTypeHostMessage
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)PowerManagementModel {
    return [WYCameraSettingModel modelWithImageName:@"btn_doorbell_power_highlighted"
                                               text:WYLocalString(@"Power Management")
                                       detailedText:nil
                                               type:WYSettingCellTypePowerManagement
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)BellVolumeModel {
    return [WYCameraSettingModel modelWithImageName:@"img_doorbell_volume"
                                               text:WYLocalString(@"Talkback Volume")
                                       detailedText:nil
                                               type:WYSettingCellTypeBellVolume
                                          textColor:WY_FontColor_Black];
}
+ (instancetype)JingleBellModel {
    return [WYCameraSettingModel modelWithImageName:@"btn_doorbell_jinglebell_highlighted"
                                               text:WYLocalString(@"Jingle Bell Setting")
                                       detailedText:nil
                                               type:WYSettingCellTypeJingleBell
                                          textColor:WY_FontColor_Black];
}

+ (instancetype)sharedPIRDetectionModel {
    WYCameraSettingModel *model = [WYCameraSettingModel PIRDetectionModel];
    model.imageName = @"btn_doorbell_pir_disabled";
    model.textColor = WY_FontColor_Disabled;
    return model;
}
+ (instancetype)sharedBatteryLockModel {
    WYCameraSettingModel *model = [WYCameraSettingModel BatteryLockModel];
    model.imageName = @"img_doorbell_battery_lock";
    model.textColor = WY_FontColor_Disabled;
    return model;
}
+ (instancetype)sharedHostMessageModel {
    WYCameraSettingModel *model = [WYCameraSettingModel HostMessageModel];
    model.imageName = @"img_doorbell_host_message";
    model.textColor = WY_FontColor_Disabled;
    return model;
}
+ (instancetype)sharedPowerManagementModel {
    WYCameraSettingModel *model = [WYCameraSettingModel PowerManagementModel];
    model.imageName = @"btn_doorbell_power_disabled";
    model.textColor = WY_FontColor_Disabled;
    return model;
}
+ (instancetype)sharedBellVolumeModel {
    WYCameraSettingModel *model = [WYCameraSettingModel BellVolumeModel];
    model.imageName = @"img_doorbell_volume";
    model.textColor = WY_FontColor_Disabled;
    return model;
}

@end
