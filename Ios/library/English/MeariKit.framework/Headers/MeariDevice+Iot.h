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

 @param sn device sn
 @param success success
 @param failure failure
 */
- (void)getIotModelWithSn:(NSString *)sn success:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

/**
 Set Screen flip

 @param open true or false
 @param success success
 @param failure failure
 */
- (void)iotSetRotateOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- LED

/**
 Set the LED

 @param on true or false
 @param success success
 @param failure failure
 */
- (void)iotSetLEDOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Get LED Status

 @param success success
 @param failure failure
 */
- (void)iotGetLEDSuccess:(MeariDeviceSucess_LED)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Playback

/**
 Set playback level

 @param level  MeariDeviceLevelOff: open all-day-record
 MeariDeviceLevelLow: 1*60s
 MeariDeviceLevelMedium: 2*60s
 MeariDeviceLevelHigh: 3*60s
 @param success success
 @param failure failure
 */
- (void)iotSetPlaybackRecordVideoLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Get SDCard info

 @param success success
 @param failure failure
 */
- (void)iotGetStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Alarm

/**
 Set Alarm

 @param level alarm level
 @param success success
 @param failure failure
 */
- (void)iotSetAlarmLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

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
#pragma mark -- Noise Detection

/**
 Set DB Detection

 @param level alarm level
 @param success success
 @param failure failure
 */
- (void)iotSetDBDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- DayNight

/**
 Set DayNight mode

 @param type day , night ,auto
 @param success success
 @param failure failure
 */
- (void)iotSetDayNightMode:(MeariDeviceDayNightType)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Sleep Mode

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

#pragma mark --- Device firmware version

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

#pragma mark -- Open CloudStorage
/**
 Set CloudStorage

 @param open true or false
 @param success success
 @param failure failure
 */
- (void)setIotCloudStorageOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- H264-H265

/**
 Switch H264-H265

 @param isH265 true or false
 @param success success
 @param failure failure
 */
- (void)iotSwitchVideoEncoding:(BOOL)isH265 success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Device Service

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

@end

NS_ASSUME_NONNULL_END
