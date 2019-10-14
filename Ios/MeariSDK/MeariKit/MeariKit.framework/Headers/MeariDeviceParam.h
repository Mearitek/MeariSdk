//
//  MeariDeviceParam.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MeariDeviceSleepmode) {
    MeariDeviceSleepmodeUnknown,
    MeariDeviceSleepmodeLensOn, // on
    MeariDeviceSleepmodeLensOff, // off
    MeariDeviceSleepmodeLensOffByTime,  // Timed sleep
    MeariDeviceSleepmodeLensOffByGeographic, // Geographic sleep
};
typedef NS_ENUM(NSInteger, MeariDeviceLevel) {
    MeariDeviceLevelNone = -1,
    MeariDeviceLevelOff, // off
    MeariDeviceLevelLow, // low
    MeariDeviceLevelMedium, // medium
    MeariDeviceLevelHigh // high
};
/**
 switch 4G mode
 */
typedef NS_ENUM (NSUInteger, MeariDeviceNetMode) {
    MeariDeviceNetModeAuto, // auto switch
    MeariDeviceNetModeWifi, // wifi switch
    MeariDeviceNetMode4G // 4g switch
};
/**
 Wifi encryption
 */
typedef NS_ENUM (NSUInteger, MRWiFiEncryption) {
    MRWiFiEncryptionNone,
    MRWiFiEncryptionWep,
    MRWiFiEncryptionWpaPsk,
    MRWiFiEncryptionWpaEnterprise,
    MRWiFiEncryptionWpa2Psk
};

typedef NS_ENUM (NSInteger, MRBabyMusicPlayMode) {
    MRBabyMusicPlayModeRepeatOne = 1 << 0, // play Single cycle
    MRBabyMusicPlayModeRepeatAll = 1 << 1, // play all music cycle
    MRBabyMusicPlayModeRandom    = 1 << 2, // Shuffle Play
    MRBabyMusicPlayModeSingle    = 1 << 3, // play single music
    MRBabyMusicPlayModeDefault   = MRBabyMusicPlayModeSingle,
    MRBabyMusicPlayModeSupport   = MRBabyMusicPlayModeRepeatAll | MRBabyMusicPlayModeSingle,
    MRBabyMusicPlayModeAll       = MRBabyMusicPlayModeRepeatOne | MRBabyMusicPlayModeRepeatAll | MRBabyMusicPlayModeRandom | MRBabyMusicPlayModeSingle,
};

typedef NS_ENUM(NSInteger, MROtaUpgradeMode) {
    MROtaUpgradeModeNormal,  // status normal
    MROtaUpgradeModeUpgrading, // status upgrading
    MROtaUpgradeModeWaitReboot // status upgraded and wait reboot
};
#pragma mark -- Device information
@interface MeariDeviceParamFirmInfo : MeariBaseModel
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *longname;
@property (nonatomic, copy)NSString *model;
@property (nonatomic, copy)NSString *serialno;
@property (nonatomic, copy)NSString *tp;
@property (nonatomic, copy)NSString *hardware_ver;
@property (nonatomic, copy)NSString *software_ver;
@property (nonatomic, copy)NSString *firmware_version;
@property (nonatomic, copy)NSString *factory;
@end
#pragma mark -- device network information
@interface MeariDeviceParamNetwork : MeariBaseModel
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *mac; // Mac address
@property (nonatomic, copy)NSString *ipaddr;
@property (nonatomic, copy)NSString *gateway; // gateway
@property (nonatomic, copy)NSString *ssid; // wifi ssid
//v1.2.0
@property (nonatomic, copy) NSString *ip; // ip address
@property (nonatomic, copy) NSString *mask; // Subnet mask
@property (nonatomic, copy) NSString *bssid; // bssid
@property (nonatomic, copy) NSString *signal; // signal
@property (nonatomic, strong) NSArray *dns; // dns
@property (nonatomic,   copy) NSString *sig; // siggal
@property (nonatomic, assign) NSInteger cfg;
@property (nonatomic, assign) MRWiFiEncryption mgmt; // Encryption
@property (nonatomic, assign) NSInteger ch;  // Wifi channel
@property (nonatomic, assign) NSInteger netOperator;
@property (nonatomic, assign) NSInteger sim_card_existed;
@property (nonatomic, assign) NSInteger bytes_for_cur_month;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) NSInteger cur_network_mode;
@end


#pragma mark -- SD card information
@interface MeariDeviceParamCloudStorage : NSObject
@property (nonatomic, assign) NSInteger enable;
@end

@interface MeariDeviceParamStorage : MeariBaseModel
@property (nonatomic, copy)NSString *company;
/** Total storage space */
@property (nonatomic, copy)NSString *totalSpace;
/** Remaining storage space */
@property (nonatomic, copy)NSString *freeSpace;
/** Is formatting ? */
@property (nonatomic, assign)BOOL isFormatting;
/** Is there an SD card ? */
@property (nonatomic, assign)BOOL hasSDCard;
/** Is the SD card not supported ? */
@property (nonatomic, assign)BOOL unSupported;
/** ID card is being recognized */
@property (nonatomic, assign)BOOL isReading;
@end

#pragma mark -- motion detection

@interface MeariDeviceParamMotion : MeariBaseModel
@property (nonatomic, assign)NSInteger enable; // Whether to open motion detection
@property (nonatomic, assign)NSInteger alarmtype;
@property (nonatomic, assign)NSInteger sensitivity; // motion detection sensitivity
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@end

#pragma mark -- 人形侦测
@interface MeariDeviceParamPeopleDetect : MeariBaseModel
@property (nonatomic, assign)NSInteger enable;
@property (nonatomic, assign)NSInteger bnddraw;
@end

#pragma mark -- 哭声检测
@interface MeariDeviceParamCryDetect : MeariBaseModel
@property (nonatomic, assign)NSInteger enable;
@end

#pragma mark --PeopleTrack
@interface MeariDeviceParamPeopleTrack : MeariBaseModel
@property (nonatomic, assign)NSInteger enable;
@end

#pragma mark -- SleepMode:by Times
@interface MeariDeviceParamSleepTime : MeariBaseModel
@property (nonatomic, assign)BOOL enable; // Whether to open Sleep Time
@property (nonatomic, copy)NSString *start_time; // Start sleep time
@property (nonatomic, copy)NSString *stop_time; // Stop sleep time
@property (nonatomic, copy)NSArray *repeat;  // whether repeat
@end
#pragma mark -- Sleep mode : by geographic
@interface MeariDeviceParamSleepGeographic : NSObject
@property (nonatomic, copy) NSString *latitude; // set latitude for Geographic
@property (nonatomic, copy) NSString *longitude; // set longitude for Geographic
@property (nonatomic, copy) NSString *radius; // sleep radius
@end
#pragma mark -- Human detection(pir)
@interface MeariDeviceParamPIR : MeariBaseModel
@property (nonatomic, assign)NSInteger enable; // Whether to open PIR
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level; // pir sensitivity level
@end
#pragma mark -- device battery info
@interface MeariDeviceParamBellBattery : MeariBaseModel
@property (nonatomic, assign)NSInteger percent; // Battery percentage
@property (nonatomic, assign)NSInteger remain; // Battery remaining time available
@property (nonatomic,   copy)NSString  *status; // Battery current status
@end
#pragma mark -- Wireless bell setting
@interface MeariDeviceParamBellSound : MeariBaseModel
@property (nonatomic, assign)NSInteger enable; // Whether to open Wireless bell
@property (nonatomic, strong)NSArray *song; //  song list of device
@property (nonatomic, assign)NSInteger repetition; // repeat times
@property (nonatomic, assign)NSInteger volume;  // volume
@property (nonatomic,   copy)NSString *selected; // current select song
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level; // level
@end
#pragma mark -- Noise detection
@interface MeariDeviceParamDBDetection : NSObject
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSInteger threshold;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@end
#pragma mark -- set playback video fragment
@interface MeariDeviceParamPlaybackVideoRecord : NSObject
@property (nonatomic, assign) BOOL enable; // enable 0:all day record 1:event record
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger continuity;
/**
 level:
 When enable is 1, the device will only record to the local SD card when an alarm event occurs
 , and the level level corresponds to the recording duration after the alarm time occurs.
 MeariDeviceLevelLow = 1*60s |
 MeariDeviceLevelMedium = 2*60s |
 MeariDeviceLevelHigh = 3*60s
 */
@property (nonatomic, assign) MeariDeviceLevel level;
@end
#pragma mark -- doorbell param
@interface MeariDeviceParamBell : MeariBaseModel
@property (nonatomic, strong)MeariDeviceParamPIR *pir;
@property (nonatomic, strong)MeariDeviceParamBellBattery *battery;
@property (nonatomic, strong)MeariDeviceParamBellSound *charm;
@property (nonatomic, assign) NSInteger volume; // bell volume
@property (nonatomic, assign) NSInteger batterylock; // Whether battery is lock
@property (nonatomic, assign) NSInteger pwm; // whether to open low power consumption mode
@property (nonatomic,   copy) NSString  *power; // Power supply

@property (nonatomic, assign)NSInteger mechanicalBell; // use mechanical Bell:  0: use  1 not use
@end
#pragma mark -- Upload video to the cloud
@interface MeariDeviceCloudStorage : NSObject
@property (nonatomic, assign) NSInteger enable;
@end
#pragma mark -- open light schedule of Flight camera
@interface MeariDeviceFlightSchedule : NSObject
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@end
#pragma mark -- floodcamera
@interface MeariDeviceFlight : NSObject
@property (nonatomic, assign) NSInteger alwaysOn; // whether to always on
@property (nonatomic, assign) NSInteger pirDuration; // Detection interval
@property (nonatomic, assign) NSInteger pirEnable; // whether to open pir
@property (nonatomic, assign) NSInteger siren;
@property (nonatomic, assign) NSInteger lightState; // light state : 1 or 0
@property (nonatomic, assign) NSInteger sirenTimeout;  // Alarm countdown
@property (nonatomic, strong) MeariDeviceFlightSchedule *schedule;
@property (nonatomic, assign) MeariDeviceLevel level;
@end

@interface MeariDeviceParamBaseI : NSObject
@property (nonatomic, copy) NSString *jingle_volume;  // Bell volume
@property (nonatomic, assign) NSInteger jingle0_song; //
@property (nonatomic, assign) NSInteger jingle0_song_len;
@property (nonatomic, assign) NSInteger msg_time_limit; // Message limit
@property (nonatomic, assign) NSInteger ring_mic_volume; // Mike sound
@property (nonatomic, assign) NSInteger ring_speaker_volume;  // Horn sound
@property (nonatomic, assign) NSInteger wait_time; //  Message waiting time
@property (nonatomic, copy) NSString *steal_proof_enable; // Prevent removal alarm
@property (nonatomic, copy) NSString *upgrade_status;  //device upgrade ststus
@property (nonatomic, copy) NSString *online;  // Whether the device is online
@property (nonatomic, copy) NSString *version; //device version
@property (nonatomic, copy) NSString *upgrade_plan; // device upgrade plan

@end
@interface MeariDeviceParamIState : NSObject
@property (nonatomic, strong) MeariDeviceParamBaseI *desired;
@property (nonatomic, strong) MeariDeviceParamBaseI *reported;
@end

@class MeariDeviceLEDAll;
@interface MeariDeviceLED : NSObject
@property (nonatomic, strong) MeariDeviceLEDAll *all;

@end
@interface MeariDeviceLEDAll : NSObject
@property (nonatomic, assign) NSInteger enable;

@end
#pragma mark -- voice doorbell
@interface MeariDeviceParamVoiceBell : MeariBaseModel
@property (nonatomic,   copy) NSString *deviceName; // device name
@property (nonatomic,   copy) NSString *productKey; // key
@property (nonatomic, strong) MeariDeviceParamIState *state;
@property (nonatomic, assign) NSInteger version; // device version
@property (nonatomic, assign) long timestamp;

@property (nonatomic, assign, readonly) NSInteger jingleVolume; // bell sound
@property (nonatomic, assign, readonly) NSInteger jingleRing; // bell ringtone
@property (nonatomic, assign, readonly) NSInteger jingleDuration; //bell sound duration
@property (nonatomic, assign, readonly) NSInteger ringSpeakerVolume; //doorbell speaker volume
@property (nonatomic, assign, readonly) NSInteger msgLimitTime; //Message limit time
@property (nonatomic, assign, readonly) NSInteger online; //whether the device is online
@property (nonatomic, assign, readonly) NSInteger tamperAlarm; // tamper alarm
@property (nonatomic, assign, readonly) NSInteger upgradeStatus; //Update status
@property (nonatomic, assign, readonly) NSInteger waitMsgTime; //Message waiting time
@property (nonatomic, copy, readonly) NSString *deviceVersion; //Device version
@property (nonatomic, copy, readonly) NSString *updatePlan; //Device upgrade plan
@property (nonatomic, strong) NSDictionary *updateParam;
@end
#pragma mark -- device parameters
@interface MeariDeviceParam : MeariBaseModel

@property (nonatomic, copy) NSString *timezone; // Time zone of the device
@property (nonatomic, copy) NSString *time_now; // current time
@property (nonatomic, assign) NSInteger video_mirror; // device flip
@property (nonatomic, assign) CGFloat temperature_c; // temperature
@property (nonatomic, assign) CGFloat humidity; // humidity
@property (nonatomic, copy) NSString *sleep; // The string corresponding to the sleepmode
@property (nonatomic, strong) MeariDeviceParamBell *bell; // Doorbell parameters
@property (nonatomic, strong) MeariDeviceParamFirmInfo *firmInfo; // device info
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *>*network; // net info array
@property (nonatomic, strong) MeariDeviceParamStorage *sdcard; // sdcard parameters
@property (nonatomic, strong) MeariDeviceParamMotion *motion_detect; // Motion Detection parameters

@property (nonatomic, strong) MeariDeviceParamPeopleDetect *people_detect;
@property (nonatomic, strong) MeariDeviceParamCryDetect *cry_detect;
@property (nonatomic, strong) MeariDeviceParamPeopleTrack *people_track;

@property (nonatomic, strong) MeariDeviceParamSleepGeographic *home_geographic; // geographic sleep mode
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *>*sleep_time;// time sllep mode
@property (nonatomic, strong) MeariDeviceParamVoiceBell *voiceBell; // voice bell parameters
@property (nonatomic, strong) MeariDeviceParamDBDetection *decibel_alarm; // Decibel alarm parameters
@property (nonatomic, strong) MeariDeviceParamNetwork *wlan;
@property (nonatomic, strong) MeariDeviceParamNetwork *eth;
@property (nonatomic, strong) MeariDeviceParamNetwork *net_4G;
@property (nonatomic, strong) MeariDeviceParamPlaybackVideoRecord *playbackVideoRecord;
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *> *wifi_config;
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *> *wifi_list; // wifi array
@property (nonatomic, assign) NSInteger day_night_mode;  // current status of Day night mode
@property (nonatomic, strong) MeariDeviceCloudStorage *cloud_storage; // cloud storage parameters
@property (nonatomic, strong) MeariDeviceFlight *flight;
@property (nonatomic, assign) NSInteger net_4G_mode;
@property (nonatomic, assign) NSInteger cur_network_mode; // current network mode
@property (nonatomic, assign) NSInteger network_supported; // whether to support 4g network
@property (nonatomic, assign) NSInteger onvif_enable; // whether to support onvif
@property (nonatomic,   copy) NSString *device_password; // the password of device
@property (nonatomic, assign) MeariDeviceSleepmode sleepmode; // sleep mode
@property (nonatomic, assign) NSInteger videoEnc; // Video encoding type
@property (nonatomic, strong) MeariDeviceLED *led;

@property (nonatomic,   copy) NSString * onvifAddress;
@property (nonatomic, assign) MROtaUpgradeMode otaUpgradeMode;
- (instancetype)initWithIotDic:(NSDictionary *)dic;

@end
