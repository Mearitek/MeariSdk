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
 Get the list of iot properties
 获取iot属性列表

 @param sn device sn(设备sn )
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getIotModelWithSn:(NSString *)sn success:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 画面翻转

/**
 Set Screen flip
 画面翻转

 @param open  true or false (是否开启)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetRotateOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- LED

/**
 Set the LED
 设置LED

 @param on true or false (是否开启)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetLEDOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Get LED Status
 获取LED

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotGetLEDSuccess:(MeariDeviceSucess_LED)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 回放设置

/**
Set playback level

@param level  MeariDeviceLevelOff: open all-day-record
MeariDeviceLevelLow: 1*60s
MeariDeviceLevelMedium: 2*60s
MeariDeviceLevelHigh: 3*60s
@param success success
@param failure failure
*/
- (void)iotSetPlaybackRecordVideoLevel:(MeariDeviceRecordDuration)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Get SDCard info

@param success success
@param failure failure
*/
- (void)iotGetStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 报警

/**
Set Alarm

@param level alarm level
@param success success
@param failure failure
*/
- (void)iotSetAlarmLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
 Alarm Time
 报警时间段
 
 @param times 时间数组 (NSArray<MeariDeviceParamSleepTime *> *)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetAlarmTime:(NSArray<MeariDeviceParamSleepTime *> *)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Set the PeopleDetect

@param enable true or false
@param bnddrawEnable true or false
@param success success
@param failure failure
*/
- (void)iotSetPeopleDetectEnable:(BOOL)enable bnddrawEnable:(BOOL)bnddrawEnable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set Cry Detect

 @param enable true or false
 @param success success
 @param failure failure
 */
- (void)iotSetCryDetectEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set People Track

 @param enable true or false
 @param success success
 @param failure failure
 */
- (void)iotSetPeopleTrackEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 噪声监测

/**
Set DB Detection

@param level alarm level
@param success success
@param failure failure
*/
- (void)iotSetDBDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 日夜模式

/**
Set DayNight mode

@param type day , night ,auto
@param success success
@param failure failure
*/
- (void)iotSetDayNightMode:(MeariDeviceDayNightType)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 休眠模式

/**
Set sleep mode

@param type mode type
@param success success
@param failure failure
*/
- (void)iotSetSleepmodeType:(MeariDeviceSleepmode)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Set sleep times

@param open true or false
@param times times Arrary (NSArray<MeariDeviceParamSleepTime *> *)
@param success success
@param failure failure
*/
- (void)iotSetSleepmodeTime:(BOOL)open times:(NSArray<MeariDeviceParamSleepTime *> *)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 固件版本

/**
 Get Version

 @param success success
 @param failure failure
 */
- (void)iotGetVersionSuccess:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;

/**
 Get upgrade status

 @param success success
 @param failure failure
 */
- (void)iotGetOtaUpgradeStatus:(MeariDeviceSucess_UpgradeMode)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Onvif
/**
Onvif

@param enable true or false
@param pwd password
@param success success
@param failure failure
*/
- (void)iotSetOnvifEnable:(BOOL)enable password:(NSString *)pwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 云存储开通
/**
Set CloudStorage

@param open true or false
@param success success
@param failure failure
*/
- (void)setIotCloudStorageOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 码流H264-H265

/**
Switch H264-H265

@param isH265 true or false
@param success success
@param failure failure
*/
- (void)iotSwitchVideoEncoding:(BOOL)isH265 success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 机械铃铛

/**
 Turn on the mechanical bell
 开启机械铃铛
 
 @param open true or false
 @param success success
 @param failure failure
 */
- (void)iotSetMachineryBellOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 门铃

/**
 Set Doorbell Output Volume (152)
  设置门铃输出音量(152)

 @param volume 音量
 @param success success
 @param failure failure
 */
- (void)iotSetDoorBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set Doorbell PIR (Human Detection) Alarm Type (150, 151)
 设置门铃PIR(人体侦测)报警类型(150, 151)
 
 @param level Alarm level(报警级别)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorBellPIRLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set doorbell enable
 设置门铃使能
 
 @param enable doorbell enable(铃铛使能)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorBellJingleBellVolumeEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set the doorbell configuration(设置门铃配置)
 
 @param volumeType bell sound level
  @param selectedSong selected ringtone
  @param repeatTimes repeat times
  @param success callback
  @param failure failure callback
 */
- (void)iotSetDoorBellJingleBellVolumeType:(MeariDeviceLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

#pragma mark --- voicebell  语音门铃

/// 设置睡眠超时时间
/// @param sleepOverTime 睡眠超时时间
/// @param success callback
/// @param failure failure callback
- (void)iotSetDoorBellSleepOverTime:(NSInteger)sleepOverTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 Set call waiting time
  
  @param callWaitTime call waiting time
  @param success callback
  @param failure failure callback
 */
- (void)iotSetDoorBellCallWaitTime:(NSInteger)callWaitTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set doorbell message limit time
  
  @param messageLimitTime Doorbell message limit time
  @param success callback
  @param failure failure callback
 */
- (void)iotSetDoorBellMessageLimitTime:(NSInteger)messageLimitTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set whether to enable the tamper alarm
  
  @param enable Whether to enable tamper alarm
  @param success callback
  @param failure failure callback
 */
- (void)iotSetDoorBellTamperAlarmEnable:(NSInteger)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 服务

/**
 Reboot device

 @param success success
 @param failure failure
 */
- (void)iotResetDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Reset device

 @param success success
 @param failure failure
 */
- (void)iotRebootDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Synchronised time

 @param success success
 @param failure failure
 */
- (void)iotSyncTimeDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Ota upgrade with url

 @param url upgrade url
 @param currentVersion version
 @param success success
 @param failure failure
 */
- (void)iotOtaUpgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Get a list of surrounding wifi

 @param success success
 @param failure failure
 */
- (void)iotGetWiFiListDevice:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Switch WIFI

 @param success success
 @param failure failure
 */
- (void)iotChangeWifi:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 SD card formatting

 @param success success
 @param failure failure
 */
- (void)iotFormatSDCard:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 PTZ Control (Control device rotation)

 @param direction ↑ ↓ ← →
 @param success success
 @param failure failure
 */
- (void)iotStartMoveToDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 PTZ Stop

 @param success success
 @param failure failure
 */
- (void)iotStopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Get Wi-Fi signal strength in real time(by mqtt)

 @param success success
 @param failure failure
 */
- (void)iotRefreshWifiStrengthSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Refresh sd card status (by mqtt)

 @param success success
 @param failure failure
 */
- (void)iotRefreshSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Refresh temperature and humidity
 刷新温湿度

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotRefreshTemperatureHumiditySuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Bell binding
 铃铛绑定

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorBellJingleBellPairingSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 unbinding the bell
 铃铛解绑

 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorebllJingleBellUnbindSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Battery lock
 电池锁

 @param open 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorBellBatteryLockOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set the door open
 设置开门
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorBellDoorOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set unlock
 设置开锁
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorBellLockOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set the light status
 设置灯状态
 
 @param on 灯开关使能
 @param success 成功回调
 @param failure 失败回调
 */
- (void)iotSetDoorBellLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

@end

NS_ASSUME_NONNULL_END
