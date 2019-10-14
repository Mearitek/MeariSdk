//
//  WYCameraSelectKindModel.h
//  Meari
//
//  Created by 李兵 on 2017/11/27.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseModel.h"

typedef NS_OPTIONS(NSInteger, WYCameraSelectConfigMode) {
    WYCameraSelectConfigModeNone,
    WYCameraSelectConfigModeQrCode = 1 << 0,
    WYCameraSelectConfigModeWifi = 1 << 1,
    WYCameraSelectConfigModeAP = 1 << 2,
    WYCameraSelectConfigModeAll = WYCameraSelectConfigModeQrCode|WYCameraSelectConfigModeWifi,
    WYCameraSelectConfigModeQRWifi = WYCameraSelectConfigModeQrCode|WYCameraSelectConfigModeWifi,
    WYCameraSelectConfigModeWifiAP = WYCameraSelectConfigModeAP|WYCameraSelectConfigModeWifi,
    WYCameraSelectConfigModeQRAP = WYCameraSelectConfigModeQrCode|WYCameraSelectConfigModeWifi
};

@interface WYCameraSelectKindModel : WYBaseModel
@property (nonatomic, assign) WYCameraSelectConfigMode configMode;
@property (nonatomic, assign) MeariDeviceSubType deviceType;
+ (instancetype)cameraModel;
+ (instancetype)doorbellModel;
+ (instancetype)batteryCameraModel;
+ (instancetype)voiceDoorbellModel;
+ (instancetype)nvrModel;
@end
