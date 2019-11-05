//
//  MeariDevice+Iot.h
//  MeariKit
//
//  Created by maj on 2019/5/31.
//  Copyright © 2019 Meari. All rights reserved.
//

#import <MeariKit/MeariKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariDevice (Iot)

#pragma mark --- Network

/**
 获取iot属性列表

 @param sn 设备sn
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getIotModelWithSn:(NSString *)sn success:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 画面翻转

/**
 画面翻转

 @param open 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetRotateOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- LED

/**
 设置LED

 @param on 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetLEDOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 获取LED

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotGetLEDSuccess:(MeariDeviceSucess_LED)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 回放设置

/**
 回放设置

 @param level sd卡存储等级
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetPlaybackRecordVideoLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 sd卡信息

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotGetStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 报警

/**
 报警

 @param level 报警级别
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetAlarmLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
 人体检测

 @param enable 是否开启
 @param bnddrawEnable 画框是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetPeopleDetectEnable:(BOOL)enable bnddrawEnable:(BOOL)bnddrawEnable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 哭声检测

 @param enable 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetCryDetectEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 人形追踪

 @param enable 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetPeopleTrackEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 噪声监测

/**
 噪声监测

 @param level 等级
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDBDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 日夜模式

/**
 日夜模式

 @param type 日夜模式类型
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDayNightMode:(MeariDeviceDayNightType)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 休眠模式

/**
 休眠模式

 @param type 休眠模式类型
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetSleepmodeType:(MeariDeviceSleepmode)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 休眠时间设置

 @param open 是否开启
 @param times 时间数组 (NSArray<MeariDeviceParamSleepTime *> *)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetSleepmodeTime:(BOOL)open times:(NSArray<MeariDeviceParamSleepTime *> *)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 固件版本

/**
 固件版本

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotGetVersionSuccess:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;

/**
 固件升级状态

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotGetOtaUpgradeStatus:(MeariDeviceSucess_UpgradeMode)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Onvif
/**
 Onvif

 @param enable 是否开启
 @param pwd 密码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetOnvifEnable:(BOOL)enable password:(NSString *)pwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 云存储开通
/**
 云存储开通

 @param open 是否开通
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setIotCloudStorageOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 码流H264-H265

/**
 码流H264-H265切换

 @param isH265 是不是H265码流
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSwitchVideoEncoding:(BOOL)isH265 success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 服务

/**
 重启设备

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotResetDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 复位设备

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotRebootDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 同步时间

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSyncTimeDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 ota升级

 @param url 地址
 @param currentVersion 版本
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotOtaUpgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 获取WIFI列表

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotGetWiFiListDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 切换WIFI

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotChangeWifi:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 SD卡格式化

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotFormatSDCard:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 PTZ控制

 @param direction 方向
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotStartMoveToDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 PTZ停止

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotStopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 实时获取Wi-Fi信号强度(mqtt获取)

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotRefreshWifiStrengthSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 刷新sd卡状态(mqtt获取)

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotRefreshSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

@end

NS_ASSUME_NONNULL_END
