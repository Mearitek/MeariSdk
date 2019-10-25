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
    MeariDeviceSleepmodeLensOn,
    MeariDeviceSleepmodeLensOff,
    MeariDeviceSleepmodeLensOffByTime,
    MeariDeviceSleepmodeLensOffByGeographic,
};
typedef NS_ENUM(NSInteger, MeariDeviceLevel) {
    MeariDeviceLevelNone = -1,
    MeariDeviceLevelOff,
    MeariDeviceLevelLow,
    MeariDeviceLevelMedium,
    MeariDeviceLevelHigh
};
/**
 4G模式切换
 */
typedef NS_ENUM (NSUInteger, MeariDeviceNetMode) {
    MeariDeviceNetModeAuto,
    MeariDeviceNetModeWifi,
    MeariDeviceNetMode4G
};
/**
 Wifi 加密
 */
typedef NS_ENUM (NSUInteger, MRWiFiEncryption) {
    MRWiFiEncryptionNone,
    MRWiFiEncryptionWep,
    MRWiFiEncryptionWpaPsk,
    MRWiFiEncryptionWpaEnterprise,
    MRWiFiEncryptionWpa2Psk
};

typedef NS_ENUM (NSInteger, MRBabyMusicPlayMode) {
    MRBabyMusicPlayModeRepeatOne = 1 << 0,
    MRBabyMusicPlayModeRepeatAll = 1 << 1,
    MRBabyMusicPlayModeRandom    = 1 << 2,
    MRBabyMusicPlayModeSingle    = 1 << 3,
    MRBabyMusicPlayModeDefault   = MRBabyMusicPlayModeSingle,
    MRBabyMusicPlayModeSupport   = MRBabyMusicPlayModeRepeatAll | MRBabyMusicPlayModeSingle,
    MRBabyMusicPlayModeAll       = MRBabyMusicPlayModeRepeatOne | MRBabyMusicPlayModeRepeatAll | MRBabyMusicPlayModeRandom | MRBabyMusicPlayModeSingle,
};

typedef NS_ENUM(NSInteger, MROtaUpgradeMode) {
    MROtaUpgradeModeNormal,  // 正常
    MROtaUpgradeModeUpgrading, // 升级中
    MROtaUpgradeModeWaitReboot // 升级完成等待重启
};

#pragma mark -- 设备固件信息
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
#pragma mark -- 设备连接网络信息
@interface MeariDeviceParamNetwork : MeariBaseModel
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *mac;
@property (nonatomic, copy)NSString *ipaddr;
@property (nonatomic, copy)NSString *gateway;
@property (nonatomic, copy)NSString *ssid;
//v1.2.0
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *mask;
@property (nonatomic, copy) NSString *bssid;
@property (nonatomic, copy) NSString *signal;
@property (nonatomic, strong) NSArray *dns;
@property (nonatomic,   copy) NSString *sig;//信号
@property (nonatomic, assign) NSInteger cfg;//是否配置过
@property (nonatomic, assign) MRWiFiEncryption mgmt;//加密方式
@property (nonatomic, assign) NSInteger ch;//通道
@property (nonatomic, assign) NSInteger netOperator;
@property (nonatomic, assign) NSInteger sim_card_existed;
@property (nonatomic, assign) NSInteger bytes_for_cur_month;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) NSInteger cur_network_mode;
@end


#pragma mark -- SD卡信息
@interface MeariDeviceParamCloudStorage : NSObject
@property (nonatomic, assign) NSInteger enable;
@end

@interface MeariDeviceParamStorage : MeariBaseModel
@property (nonatomic, copy)NSString *company;
/** 总存储空间 */
@property (nonatomic, copy)NSString *totalSpace;
/** 剩余存储空间 */
@property (nonatomic, copy)NSString *freeSpace;
/** 是否正在格式化 */
@property (nonatomic, assign)BOOL isFormatting;
/** 没有SD卡 */
@property (nonatomic, assign)BOOL hasSDCard;
/** 不支持的SD卡 */
@property (nonatomic, assign)BOOL unSupported;
/** 正在识别SD卡 */
@property (nonatomic, assign)BOOL isReading;
@end

#pragma mark -- 移动侦测

@interface MeariDeviceParamMotion : MeariBaseModel
@property (nonatomic, assign)NSInteger enable;
@property (nonatomic, assign)NSInteger alarmtype;
@property (nonatomic, assign)NSInteger sensitivity;
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

#pragma mark -- 人形跟踪
@interface MeariDeviceParamPeopleTrack : MeariBaseModel
@property (nonatomic, assign)NSInteger enable;
@end

#pragma mark -- 休眠模式:按时间休眠
@interface MeariDeviceParamSleepTime : MeariBaseModel
@property (nonatomic, assign)BOOL enable;
@property (nonatomic, copy)NSString *start_time;
@property (nonatomic, copy)NSString *stop_time;
@property (nonatomic, copy)NSArray *repeat;
@end
#pragma mark -- 休眠模式:按地理位置休眠
@interface MeariDeviceParamSleepGeographic : NSObject
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *radius;
@end
#pragma mark -- 人体侦测
@interface MeariDeviceParamPIR : MeariBaseModel
@property (nonatomic, assign)NSInteger enable;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@end
#pragma mark -- 设备电池信息
@interface MeariDeviceParamBellBattery : MeariBaseModel
@property (nonatomic, assign)NSInteger percent;
@property (nonatomic, assign)NSInteger remain;
@property (nonatomic,   copy)NSString  *status;
@end
#pragma mark -- 无线铃铛设置
@interface MeariDeviceParamBellSound : MeariBaseModel
@property (nonatomic, assign)NSInteger enable;
@property (nonatomic, strong)NSArray *song;
@property (nonatomic, assign)NSInteger repetition;
@property (nonatomic, assign)NSInteger volume;
@property (nonatomic,   copy)NSString *selected;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@end

#pragma mark -- 噪声检测
@interface MeariDeviceParamDBDetection : NSObject
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSInteger threshold;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@end
#pragma mark -- 回放录像设置
@interface MeariDeviceParamPlaybackVideoRecord : NSObject
/** enable: 1为报警时录像 0为全天录像 */
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger continuity;
/**
 level:
 当enable 为1时，设备只在有报警事件发生时，才会录像到本地SD卡，level等级对应报警时刻发生后的录像时长
 MeariDeviceLevelLow = 1*60s |
 MeariDeviceLevelMedium = 2*60s |
 MeariDeviceLevelHigh = 3*60s
 */
@property (nonatomic, assign) MeariDeviceLevel level;
@end
#pragma mark -- 门铃参数
@interface MeariDeviceParamBell : MeariBaseModel
@property (nonatomic, strong)MeariDeviceParamPIR *pir;
@property (nonatomic, strong)MeariDeviceParamBellBattery *battery;
@property (nonatomic, strong)MeariDeviceParamBellSound *charm;
@property (nonatomic, assign) NSInteger volume;
@property (nonatomic, assign) NSInteger batterylock;
@property (nonatomic, assign) NSInteger pwm;
@property (nonatomic,   copy) NSString  *power;
/** 默认:0 使用机械铃铛:2 不使用机械铃铛:1 */
@property (nonatomic, assign)NSInteger mechanicalBell;
@end
#pragma mark -- 上报录像至云端
@interface MeariDeviceCloudStorage : NSObject
@property (nonatomic, assign) NSInteger enable;
@end
#pragma mark -- 灯具摄像头开灯计划
@interface MeariDeviceFlightSchedule : NSObject
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@end
#pragma mark -- 灯具摄像头
@interface MeariDeviceFlight : NSObject
@property (nonatomic, assign) NSInteger alwaysOn;
@property (nonatomic, assign) NSInteger pirDuration;
@property (nonatomic, assign) NSInteger pirEnable;
@property (nonatomic, assign) NSInteger siren;
@property (nonatomic, assign) NSInteger lightState;
@property (nonatomic, assign) NSInteger sirenTimeout;
@property (nonatomic, assign) MeariDeviceLevel level;
@property (nonatomic, strong) MeariDeviceFlightSchedule *schedule;
@end

@interface MeariDeviceParamBaseI : NSObject
@property (nonatomic,   copy) NSString *jingle_volume;
@property (nonatomic, assign) NSInteger jingle0_song;
@property (nonatomic, assign) NSInteger jingle0_song_len;
@property (nonatomic, assign) NSInteger msg_time_limit;
@property (nonatomic, assign) NSInteger ring_mic_volume;
@property (nonatomic, assign) NSInteger ring_speaker_volume;
@property (nonatomic, assign) NSInteger wait_time;
@property (nonatomic,   copy) NSString *steal_proof_enable;
@property (nonatomic,   copy) NSString *upgrade_status;
@property (nonatomic,   copy) NSString *online;
@property (nonatomic,   copy) NSString *version;
@property (nonatomic,   copy) NSString *upgrade_plan;
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
#pragma mark -- 语音门铃
@interface MeariDeviceParamVoiceBell : MeariBaseModel
@property (nonatomic,   copy) NSString *deviceName;
@property (nonatomic,   copy) NSString *productKey;
@property (nonatomic, strong) MeariDeviceParamIState *state;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, assign) long timestamp;

@property (nonatomic, assign, readonly) NSInteger jingleVolume;   //铃铛声音
@property (nonatomic, assign, readonly) NSInteger jingleRing;   //铃铛铃声
@property (nonatomic, assign, readonly) NSInteger jingleDuration;   //铃铛声音时长
@property (nonatomic, assign, readonly) NSInteger ringSpeakerVolume;   //门铃喇叭音量
@property (nonatomic, assign, readonly) NSInteger msgLimitTime;   //留言限制时间
@property (nonatomic, assign, readonly) NSInteger online;         //设备是否在线
@property (nonatomic, assign, readonly) NSInteger tamperAlarm;    //防拆报警
@property (nonatomic, assign, readonly) NSInteger upgradeStatus;  //更新状态
@property (nonatomic, assign, readonly) NSInteger waitMsgTime;    //留言等待时间
@property (nonatomic,   copy, readonly) NSString *deviceVersion; //设备版本
@property (nonatomic,   copy, readonly) NSString *updatePlan;    //设备升级计划
@property (nonatomic, strong) NSDictionary *updateParam;
@end
#pragma mark -- 设备参数
@interface MeariDeviceParam : MeariBaseModel

@property (nonatomic,   copy) NSString *timezone;
@property (nonatomic,   copy) NSString *time_now;
@property (nonatomic, assign) NSInteger video_mirror;
@property (nonatomic, assign) CGFloat temperature_c;
@property (nonatomic, assign) CGFloat humidity;
@property (nonatomic,   copy) NSString *sleep;
@property (nonatomic, strong) MeariDeviceParamBell *bell;
@property (nonatomic, strong) MeariDeviceParamFirmInfo *firmInfo;
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *>*network;
@property (nonatomic, strong) MeariDeviceParamStorage *sdcard;
@property (nonatomic, strong) MeariDeviceParamMotion *motion_detect;
@property (nonatomic, strong) MeariDeviceParamPeopleDetect *people_detect;
@property (nonatomic, strong) MeariDeviceParamCryDetect *cry_detect;
@property (nonatomic, strong) MeariDeviceParamPeopleTrack *people_track;
@property (nonatomic, strong) MeariDeviceParamSleepGeographic *home_geographic;
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *>*sleep_time;
@property (nonatomic, strong) MeariDeviceParamVoiceBell *voiceBell;
@property (nonatomic, strong) MeariDeviceParamDBDetection *decibel_alarm;
@property (nonatomic, strong) MeariDeviceParamNetwork *wlan;
@property (nonatomic, strong) MeariDeviceParamNetwork *eth;
@property (nonatomic, strong) MeariDeviceParamNetwork *net_4G;
@property (nonatomic, strong) MeariDeviceParamPlaybackVideoRecord *playbackVideoRecord;
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *> *wifi_config;
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *> *wifi_list;
@property (nonatomic, assign) NSInteger day_night_mode;
@property (nonatomic, strong) MeariDeviceCloudStorage *cloud_storage;
@property (nonatomic, strong) MeariDeviceFlight *flight;
@property (nonatomic, assign) NSInteger net_4G_mode;
@property (nonatomic, assign) NSInteger cur_network_mode;
@property (nonatomic, assign) NSInteger network_supported;
@property (nonatomic, assign) NSInteger onvif_enable;
@property (nonatomic,   copy) NSString *device_password;
@property (nonatomic, assign) MeariDeviceSleepmode sleepmode;
@property (nonatomic, assign) NSInteger videoEnc;
@property (nonatomic, strong) MeariDeviceLED *led;

@property (nonatomic,   copy) NSString * onvifAddress;
@property (nonatomic, assign) MROtaUpgradeMode otaUpgradeMode;
- (instancetype)initWithIotDic:(NSDictionary *)dic;

@end
