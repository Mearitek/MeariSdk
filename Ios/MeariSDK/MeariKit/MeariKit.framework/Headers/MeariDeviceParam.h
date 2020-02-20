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
    MeariDeviceSleepmodeLensOn, // on (开启镜头)
    MeariDeviceSleepmodeLensOff, // off (关闭镜头)
    MeariDeviceSleepmodeLensOffByTime,  // Timed sleep (按时间休眠)
    MeariDeviceSleepmodeLensOffByGeographic, // Geographic sleep (地理围栏休眠）
};
typedef NS_ENUM(NSInteger, MeariDeviceLevel) {
    MeariDeviceLevelNone = -1,
    MeariDeviceLevelOff, // off (关闭)
    MeariDeviceLevelLow, // low (低)
    MeariDeviceLevelMedium, // medium (中)
    MeariDeviceLevelHigh // high (高)
};
typedef NS_ENUM(NSInteger, MeariDeviceRecordDuration) {
    MeariDeviceRecordDurationNone = -1,
    MeariDeviceRecordDurationOff ,
    MeariDeviceRecordDurationOneMin,
    MeariDeviceRecordDurationTwoMin,
    MeariDeviceRecordDurationThreeMin,
    MeariDeviceRecordDuration20Seconds,
    MeariDeviceRecordDuration40Seconds,
   
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
/** Total storage space */
/** 总存储空间 */
@property (nonatomic, copy)NSString *totalSpace;
/** Remaining storage space */
/** 剩余存储空间 */
@property (nonatomic, copy)NSString *freeSpace;
/** Is formatting ? */
/** 是否正在格式化 */
@property (nonatomic, assign)BOOL isFormatting;
/** Is there an SD card ? */
/** 没有SD卡 */
@property (nonatomic, assign)BOOL hasSDCard;
/** Is the SD card not supported ? */
/** 不支持的SD卡 */
@property (nonatomic, assign)BOOL unSupported;
/** ID card is being recognized */
/** 正在识别SD卡 */
@property (nonatomic, assign)BOOL isReading;
/** 未知状态 */
@property (nonatomic, assign)BOOL unKnown;
@end

#pragma mark -- 移动侦测

@interface MeariDeviceParamMotion : MeariBaseModel
/** 是否开启motion移动侦测 */
/** Whether to open motion detection */
@property (nonatomic, assign)NSInteger enable;
@property (nonatomic, assign)NSInteger alarmtype;
/** 灵敏度 */
/** motion detection sensitivity */
@property (nonatomic, assign)NSInteger sensitivity;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@end

#pragma mark -- 人形侦测
@interface MeariDeviceParamPeopleDetect : MeariBaseModel
/** Whether to open people detect */
/** 是否开启 人形侦测 */
@property (nonatomic, assign)NSInteger enable;
/** Whether to open people bnddraw border */
/**  是否开启 人形画框  */
@property (nonatomic, assign)NSInteger bnddraw;
@end

#pragma mark -- 哭声检测
@interface MeariDeviceParamCryDetect : MeariBaseModel
/** Whether to open cry detect */
/** 是否开启 哭声侦测 */
@property (nonatomic, assign)NSInteger enable;
@end

#pragma mark -- 人形跟踪
@interface MeariDeviceParamPeopleTrack : MeariBaseModel
/** Whether to open people track */
/** 是否开启 人形跟踪 */
@property (nonatomic, assign)NSInteger enable;
@end

#pragma mark -- 休眠模式:按时间休眠
@interface MeariDeviceParamSleepTime : MeariBaseModel
/** Whether to turn off the timed sleep */
/** 是否开启 该时间断的休眠 */
@property (nonatomic, assign)BOOL enable;
/**  Start sleep time */
/** 开始时间 */
@property (nonatomic, copy)NSString *start_time;
/** Stop sleep time */
/** 结束时间 */
@property (nonatomic, copy)NSString *stop_time;
/** whether repeat */
/** 是否重复 */
@property (nonatomic, copy)NSArray *repeat;
@end
#pragma mark -- 休眠模式:按地理位置休眠
@interface MeariDeviceParamSleepGeographic : NSObject
/** set latitude for Geographic */
/** 设置经度 */
@property (nonatomic, copy) NSString *latitude;
/** set longitude for Geographic */
/** 设置纬度 */
@property (nonatomic, copy) NSString *longitude;
/** 半径 */
/** sleep radius */
@property (nonatomic, copy) NSString *radius;
@end
#pragma mark -- 人体侦测
@interface MeariDeviceParamPIR : MeariBaseModel
/** Whether to open PIR */
/** 是否开启pir */
@property (nonatomic, assign)NSInteger enable;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level; // pir sensitivity level
@end
#pragma mark -- 设备电池信息
@interface MeariDeviceParamBellBattery : MeariBaseModel
/** Battery percentage */
/** 电池剩余百分比 */
@property (nonatomic, assign)NSInteger percent;
/** Battery remaining time available */
/** 可用电池剩余时间 */
@property (nonatomic, assign)NSInteger remain;
/** Battery current status */
/** 当前电池状态 */
@property (nonatomic,   copy)NSString  *status;
@end
#pragma mark -- 无线铃铛设置
@interface MeariDeviceParamBellSound : MeariBaseModel
/** Whether to open Wireless bell */
/** 是否开启无限铃铛 */
@property (nonatomic, assign)NSInteger enable;
/** song list of device */
/** 当前歌曲列表 */
@property (nonatomic, strong)NSArray *song;
/** repeat times */
/** 重复次数 */
@property (nonatomic, assign)NSInteger repetition;
/** 音量 */
@property (nonatomic, assign)NSInteger volume;
/** current select song */
/** 当前选中歌曲 */
@property (nonatomic,   copy)NSString *selected;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@end

#pragma mark -- 噪声检测
@interface MeariDeviceParamDBDetection : NSObject
/** Whether to open noise detection */
/** 是否开启噪声检测 */
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
@property (nonatomic, assign) MeariDeviceRecordDuration level;
@end
#pragma mark -- 门铃参数
@interface MeariDeviceParamBell : MeariBaseModel
@property (nonatomic, strong)MeariDeviceParamPIR *pir;
@property (nonatomic, strong)MeariDeviceParamBellBattery *battery;
@property (nonatomic, strong)MeariDeviceParamBellSound *charm;
/** bell volume */
/** 门铃音量 */
@property (nonatomic, assign) NSInteger volume;
/** Whether battery is lock */
/** 是否电池锁了 */
@property (nonatomic, assign) NSInteger batterylock;
/** whether to open low power consumption mode */
/** 是否开启低功耗模式 */
@property (nonatomic, assign) NSInteger pwm;
/** Power supply */
/** 是否电影供电 */
@property (nonatomic,   copy) NSString  *power;
/** use mechanical Bell:  0: use  1 not use */
/** 默认:0 使用机械铃铛:2 不使用机械铃铛:1 */
@property (nonatomic, assign)NSInteger mechanicalBell;
@end
#pragma mark -- 上报录像至云端
@interface MeariDeviceCloudStorage : NSObject
@property (nonatomic, assign) NSInteger enable;
@end
#pragma mark -- 灯具摄像头开灯计划
@interface MeariDeviceFlightSchedule : NSObject
/** whether the flood schedule is open */
/** 灯具摄像头开灯计划开启 */
@property (nonatomic, assign) NSInteger enable;
/** begin time */
/** 开始时间 */
@property (nonatomic, strong) NSString *from;
/** end time */
/** 结束时间 */
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
@property (nonatomic, assign) NSInteger lightPercent;
@property (nonatomic, assign) MeariDeviceLevel level;
@property (nonatomic, strong) MeariDeviceFlightSchedule *schedule;
@end

@class MeariDeviceLEDAll;
@interface MeariDeviceLED : NSObject
@property (nonatomic, strong) MeariDeviceLEDAll *all;

@end
@interface MeariDeviceLEDAll : NSObject
@property (nonatomic, assign) NSInteger enable;

@end
#pragma mark -- voicebell (语音门铃)
@interface MeariDeviceParamVoiceBell : MeariBaseModel
// Doorbell sleep timeout
// 门铃休眠超时时间
// The main purpose is to allow the doorbell to continue working for a period of time after the user hangs up to ensure that new requests can be quickly received. (To discuss whether it is directly defaulted by the device, the default can be 5 seconds)
@property (nonatomic, assign) NSInteger sleepOverTime;
/** Message limit */
/** 留言限制时间 */
// The unit is second. The default value is 60s. It is used for: the length of the guest's message after the doorbell owner does not answer.
@property (nonatomic, assign) NSInteger msgLimitTime;
/** Prevent removal alarm  1 or 0 */
/** 防止拆卸警报 */
@property (nonatomic, assign) NSInteger tamperAlarm;
/** 留言等待时间 */
/** Message waiting time */
// The unit is second. The default value is 20s. It is used to: after the doorbell button is pressed, when the host does not answer, it will enter the message state after this time
@property (nonatomic, assign) NSInteger callWaitTime;
// 语音门铃对讲音量
// speak volume
@property (nonatomic, assign) NSInteger volume;

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
//iOT
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *>*alarm_time;
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
