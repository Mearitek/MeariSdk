//
//  WYCameraSelectKindModel.m
//  Meari
//
//  Created by 李兵 on 2017/11/27.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSelectKindModel.h"

@implementation WYCameraSelectKindModel
+ (instancetype)cameraModel {
    WYCameraSelectKindModel *m = [WYCameraSelectKindModel CameraSelectKindCamera];
    m.configMode = WYCameraSelectConfigModeWifi;
    m.deviceType = MeariDeviceSubTypeIpcCommon;
    return m;
}
+ (instancetype)nvrModel {
    WYCameraSelectKindModel *m = [WYCameraSelectKindModel CameraSelectKindNVR];
    m.configMode = WYCameraSelectConfigModeWifi;
    m.deviceType = MeariDeviceTypeNVR;
    return m;
}
+ (instancetype)doorbellModel {
    WYCameraSelectKindModel *m = [WYCameraSelectKindModel CameraSelectKindDoorBell];
    m.configMode = WYCameraSelectConfigModeQrCode;
    m.deviceType = MeariDeviceSubTypeIpcBell;
    return m;
}

+ (instancetype)voiceDoorbellModel {
    WYCameraSelectKindModel *m = [WYCameraSelectKindModel CameraSelectKindVoiceDoorBell];
    m.configMode = WYCameraSelectConfigModeAP;
    m.deviceType = MeariDeviceSubTypeIpcVoiceBell;
    return m;
}
+ (instancetype)batteryCameraModel {
    WYCameraSelectKindModel *m = [WYCameraSelectKindModel CameraSelectKindBatteryCamera];
    m.configMode = WYCameraSelectConfigModeQrCode;
    m.deviceType = MeariDeviceSubTypeIpcBattery;
    return m;
}
@end
