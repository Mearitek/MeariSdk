//
//  MeariDeviceParam.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MeariDevice;

/** Sleep mode status */
/** 休眠模式状态 */
typedef NS_ENUM(NSInteger, MeariDeviceSleepMode) {
    MeariDeviceSleepModeUnknown,
    MeariDeviceSleepModeLensOn, // on (开启镜头)
    MeariDeviceSleepModeLensOff, // off (关闭镜头)
    MeariDeviceSleepModeLensOffByTime,  // Timed sleep (按时间休眠)
    MeariDeviceSleepModeLensOffByGeographic, // Geographic sleep (地理围栏休眠）
};
/** Universal level */
/** 通用level */
typedef NS_ENUM(NSInteger, MeariDeviceLevel) {
    MeariDeviceLevelNone = -1,
    MeariDeviceLevelOff, // off (关闭)
    MeariDeviceLevelLow, // low (低)
    MeariDeviceLevelMedium, // medium (中)
    MeariDeviceLevelHigh // high (高)
};
typedef NS_ENUM(NSInteger, MeariDeviceDoublePirStatus) {
    MeariDeviceDoublePirStatusClose, // close all
    MeariDeviceDoublePirStatusOpenLeft, // open left pir
    MeariDeviceDoublePirStatusOpenRight, // open left pir
    MeariDeviceDoublePirStatusOpenAll, // open all
};

/** sdcard record duration*/
/** 设备录像时长 */
typedef NS_ENUM(NSInteger, MeariDeviceRecordDuration) {
    MeariDeviceRecordDurationNone = -1, // //Does not support recording duration setting (不支持录像时长设置)
    MeariDeviceRecordDurationHalfMin = 0b1, //0-30s 秒
    MeariDeviceRecordDurationOneMin = 0b10, //1min  一分钟
    MeariDeviceRecordDurationTwoMin = 0b100, // 2min  两分钟
    MeariDeviceRecordDurationThreeMin = 0b1000, //3min 三分钟
    MeariDeviceRecordDuration20Seconds = 0b10000, //20s
    MeariDeviceRecordDuration40Seconds = 0b100000, //40s
    MeariDeviceRecordDuration10Seconds = 0b1000000, //10s
    MeariDeviceRecordDurationOff = 0b10000000, // record is close 关闭录像
    MeariDeviceRecordDurationOn = 0b100000000, // record is open(If you only want to open the record and use the previous value, this action will only open the record)  只开启录像
    MeariDeviceRecordDuration24Hours = 0b1000000000, // 全天录像
};
/** alarm frequency interval*/
/** 设备报警频率间隔时长 */
typedef NS_ENUM (NSUInteger, MeariDeviceCapabilityAFQ) {
    MeariDeviceCapabilityAFQOff = 0b1,       //关闭报警间隔
    MeariDeviceCapabilityAFQOneMin = 0b10,//1min  一分钟
    MeariDeviceCapabilityAFQTwoMin = 0b100,//2min  两分钟
    MeariDeviceCapabilityAFQThreeMin = 0b1000,//3min 三分钟
    MeariDeviceCapabilityAFQFiveMin  = 0b10000,//5min 五分钟
    MeariDeviceCapabilityAFQTenMin   = 0b100000,//10min 十分钟
};

/** 4G mode switching */
/**  4G模式切换 */
typedef NS_ENUM (NSUInteger, MeariDeviceNetMode) {
    MeariDeviceNetModeAuto, // auto switch (自动切换)
    MeariDeviceNetModeWifi, // wifi switch (Wi-Fi切换)
    MeariDeviceNetMode4G // 4g switch (4g切换)
};
/** Wifi encryption */
/** Wifi 加密 */
typedef NS_ENUM (NSUInteger, MRWiFiEncryption) {
    MRWiFiEncryptionNone,
    MRWiFiEncryptionWep,
    MRWiFiEncryptionWpaPsk,
    MRWiFiEncryptionWpaEnterprise,
    MRWiFiEncryptionWpa2Psk
};

typedef NS_ENUM (NSInteger, MRBabyMusicPlayMode) {
    MRBabyMusicPlayModeRepeatOne = 1 << 0, // play Single cycle (单曲循环)
    MRBabyMusicPlayModeRepeatAll = 1 << 1, // play all music cycle (全部循环)
    MRBabyMusicPlayModeRandom    = 1 << 2, // Shuffle Play (随机播放)
    MRBabyMusicPlayModeSingle    = 1 << 3, // play single music (播放一首一次)
    MRBabyMusicPlayModeDefault   = MRBabyMusicPlayModeSingle,
    MRBabyMusicPlayModeSupport   = MRBabyMusicPlayModeRepeatAll | MRBabyMusicPlayModeSingle,
    MRBabyMusicPlayModeAll       = MRBabyMusicPlayModeRepeatOne | MRBabyMusicPlayModeRepeatAll | MRBabyMusicPlayModeRandom | MRBabyMusicPlayModeSingle,
};

typedef NS_ENUM(NSInteger, MeariDeviceOtaUpgradeMode) {
    MeariDeviceOtaUpgradeModeNormal,  // status normal (正常)
    MeariDeviceOtaUpgradeModeUpgrading, // status upgrading (升级中)
    MeariDeviceOtaUpgradeModeWaitReboot // status upgraded and wait reboot (升级完成等待重启)
};
// 响铃时间间隔
typedef NS_ENUM(NSInteger, MeariDeviceSnoozeTime) {
    MeariDeviceSnoozeTimeZero = 0,
    MeariDeviceSnoozeTimeHalfHours,
    MeariDeviceSnoozeTimeOneHours,
    MeariDeviceSnoozeTimeTwoHours,
    MeariDeviceSnoozeTimeThreeHours,
    MeariDeviceSnoozeTimeFourHours,
};

typedef NS_ENUM (NSInteger, MeariDeviceVoiceLightType) {
    MeariDeviceVoiceLightTypeVoice = 0, // voice  (报警触发声音)
    MeariDeviceVoiceLightTypeLight = 1, // Support light (报警触发亮灯)
    MeariDeviceVoiceLightTypeAll = 2,  //Support all (报警触发声音和亮灯)
};

#pragma mark -- 防拆报警
@interface MeariDeviceParamTamperAlarm : MeariBaseModel
@property (nonatomic, assign) NSInteger enable;
@end

#pragma mark -- 时间设置
@interface MeariDeviceParamTimeShow : MeariBaseModel
@property (nonatomic, assign) NSInteger timeShowFormat;
@end

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
@property (nonatomic,   copy) NSString *sig;
@property (nonatomic, assign) NSInteger cfg;
@property (nonatomic, assign) MRWiFiEncryption mgmt;
@property (nonatomic, assign) NSInteger ch;
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
@property (nonatomic, assign)NSInteger enableDay;
@property (nonatomic, assign)NSInteger enableNight;
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

@interface MeariDeviceParamVoiceLightAlarm : NSObject
/** Whether to turn off the voice light alarm */
/** 是否开启 声光报警设置 */
@property (nonatomic, assign)BOOL enable;
// 触发报警 动作类型
@property (nonatomic, assign) MeariDeviceVoiceLightType videoLightType;

@end

#pragma mark -- 人体侦测
@interface MeariDeviceParamPIR : MeariBaseModel
/** Whether to open PIR */
/** 是否开启pir */
@property (nonatomic, assign)NSInteger enable;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) NSInteger level; // pir sensitivity level
/** double pir exist , doublePirStatus replace enable key  */
@property (nonatomic, assign) MeariDeviceDoublePirStatus doublePirStatus; // 双pir的状态

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
@property (nonatomic, assign) NSInteger patrolEnable;
@end

#pragma mark -- 回放录像设置
@interface MeariDeviceParamPlaybackVideoRecord : NSObject
/** enable 0:all day record 1:event record */
/** enable: 1为事件录像 0为全天录像 2不录像*/
@property (nonatomic, assign) NSInteger enable;
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

/**
 level:
 当enable 为1时，设备只在有报警事件发生时，才会录像到本地SD卡，level等级对应报警时刻发生后的录像时长
 MeariDeviceLevelLow = 1*60s |
 MeariDeviceLevelMedium = 2*60s |
 MeariDeviceLevelHigh = 3*60s
 */

@property (nonatomic, assign) MeariDeviceRecordDuration eventLevel;

@property (nonatomic, assign) MeariDeviceRecordDuration currentLevel;

@end

#pragma mark -- 门铃参数
@interface MeariDeviceParamBell : MeariBaseModel
// if supportPirSensitivity > 0 。 use this pir
@property (nonatomic, strong)MeariDeviceParamPIR *pir;
@property (nonatomic, strong)MeariDeviceParamBellBattery *battery;
@property (nonatomic, strong)MeariDeviceParamBellSound *charm;
@property (nonatomic, assign) BOOL relayEnable;
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
/** whether the cloud storage is open */
/** 开启云存储 */
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
/** whether repeat */
/** 是否重复 */
@property (nonatomic, copy)NSArray *repeat;

@end

#pragma mark -- 灯具摄像头
@interface MeariDeviceFlight : NSObject
/** whether to always on */
/** 是否总是开启 */
@property (nonatomic, assign) NSInteger alwaysOn;
/** Detection interval */
/** 检测间隔 */
@property (nonatomic, assign) NSInteger pirDuration;
/** whether to open pir */
/** 是否开启pir */
@property (nonatomic, assign) NSInteger pirEnable;
/** Whether the alarm is on */
/** 警报是否开启 */
@property (nonatomic, assign) NSInteger siren;
/** Whether the state is on or off */
/** 状态是开灯还是关灯 */
@property (nonatomic, assign) NSInteger lightState;
/** 警报倒计时 */
/** Alarm countdown */
@property (nonatomic, assign) NSInteger sirenTimeout;
// 报警器联动开关，报警时触发报警器
@property (nonatomic, assign) NSInteger sirenEnable;
// 0, // 手动开灯时长，0-默认，10-60s（step：10s），5min-30min（step：5min
@property (nonatomic, assign) NSInteger alwaysOnDuration;
/** Light brightness percentage */
/** 灯光亮度百分比 */
@property (nonatomic, assign) NSInteger lightPercent;

@property (nonatomic, assign) MeariDeviceLevel level;
/** Alarm time*/
/** 报警时间 */
@property (nonatomic, strong) MeariDeviceFlightSchedule *schedule;
/** Alarm time period */
/** 报警时间段 */
@property (nonatomic, copy) NSArray <MeariDeviceParamSleepTime *> *scheduleArray;
@end

@class MeariDeviceLEDAll;
@interface MeariDeviceLED : NSObject
@property (nonatomic, strong) MeariDeviceLEDAll *all;

@end
@interface MeariDeviceLEDAll : NSObject
@property (nonatomic, assign) NSInteger enable;

@end
@interface MeariDeviceRoi : NSObject
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString  *bitmap;
@property (nonatomic, strong) NSArray  *maps;
@end

#pragma mark -- 语音门铃
@interface MeariDeviceParamVoiceBell : MeariBaseModel
/** how long time the bell go sleep normal*/
/** 睡眠超时时间 */
@property (nonatomic, assign) NSInteger sleepOverTime;
@property (nonatomic, assign, readonly) MeariDeviceLevel sleepOverTimeLevel;

/** Message limit */
/** 留言限制时间 */
@property (nonatomic, assign) NSInteger msgLimitTime;
@property (nonatomic, assign, readonly) MeariDeviceLevel msgLimitTimeLevel;
///** 是否设备在线 */
///** Whether the device is online */
//@property (nonatomic, assign, readonly) NSInteger online;
/** Prevent removal alarm */
/** 防止拆卸警报 */
@property (nonatomic, assign) NSInteger tamperAlarm;
/** 留言等待时间 */
/** Message waiting time */
@property (nonatomic, assign) NSInteger callWaitTime;
@property (nonatomic, assign, readonly) MeariDeviceLevel callWaitTimeLevel;

@end

#pragma mark -- 中继铃铛(iot)
@interface MeariDeviceParamChime : MeariBaseModel
@property (nonatomic,   copy) NSString *currentRingUri; //当前选中铃声
@property (nonatomic,   copy) NSString *motionUri; // 移动侦测报警声音
@property (nonatomic, assign) NSInteger ringVolume; // 铃声大小
@property (nonatomic, assign) NSInteger motionVolume; // 移动侦测报警声音
@property (nonatomic, assign) NSInteger ringType; // 云端响应类型
@property (nonatomic, assign) MeariDeviceSnoozeTime ringSnooze; // 中继motion响铃间隔
@property (nonatomic,   copy) NSArray <MeariDeviceParamSleepTime *> *dontDisturbTime; // 勿扰模式时间
@property (nonatomic,   copy) NSDictionary *sdRecordDic;

@end

#pragma mark -- 设备参数
@interface MeariDeviceParam : MeariBaseModel
/** Time zone of the device */
/** 设备时区 */
@property (nonatomic,   copy) NSString *timezone;
/** current time */
/** 设备当前时间 */
@property (nonatomic,   copy) NSString *time_now;
/** device flip */
/** 设备是否开启翻转 */
@property (nonatomic, assign) NSInteger video_mirror;
/** temperature */
/** 温度 */
@property (nonatomic, assign) CGFloat temperature_c;
/** humidity */
/** 湿度 */
@property (nonatomic, assign) CGFloat humidity;
/** The string corresponding to the sleepMode */
/** 休眠模式字符串 */
@property (nonatomic,   copy) NSString *sleep;
/** 门铃参数 */
/** Doorbell parameters */
@property (nonatomic, strong) MeariDeviceParamBell *bell;
/** 设备版本信息 */
/** device version info */
@property (nonatomic, strong) MeariDeviceParamFirmInfo *firmInfo;
/** net info array */
/** 网络情况数组 */
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *>*network;
/** sdcard parameters */
/** sd卡参数 */
@property (nonatomic, strong) MeariDeviceParamStorage *sdcard;
/** Motion Detection parameters */
/** 移动侦测参数 */
@property (nonatomic, strong) MeariDeviceParamMotion *motion_detect;

@property (nonatomic, strong) MeariDeviceParamPeopleDetect *people_detect;
@property (nonatomic, strong) MeariDeviceParamCryDetect *cry_detect;
@property (nonatomic, strong) MeariDeviceParamPeopleTrack *people_track;
@property (nonatomic, strong) MeariDeviceParamSleepGeographic *home_geographic;
/**  sleep mode time */
/** 休眠模式时间段 */
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *>*sleep_time;
//iOT
/** motion alert time array */
/** 移动侦测报警时间段 */
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *>*alarm_time;

@property (nonatomic, strong) MeariDeviceParamVoiceBell *voiceBell;
@property (nonatomic, strong) MeariDeviceParamDBDetection *decibel_alarm;
@property (nonatomic, strong) MeariDeviceParamVoiceLightAlarm *voiceLightAlarm; // 声光报警
@property (nonatomic, strong) MeariDeviceParamNetwork *wlan;
@property (nonatomic, strong) MeariDeviceParamNetwork *eth;
@property (nonatomic, strong) MeariDeviceParamNetwork *net_4G;
@property (nonatomic, strong) MeariDeviceParamPlaybackVideoRecord *playbackVideoRecord;
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *> *wifi_config;
@property (nonatomic, strong) NSArray <MeariDeviceParamNetwork *> *wifi_list;
/** current status of Day night mode */
/** 日夜模式的当前状态 */
@property (nonatomic, assign) NSInteger day_night_mode;
@property (nonatomic, strong) MeariDeviceCloudStorage *cloud_storage;
@property (nonatomic, strong) MeariDeviceFlight *flight;
@property (nonatomic, assign) NSInteger net_4G_mode;
/**  current network mode */
/** 当前网络模式 */
@property (nonatomic, assign) NSInteger cur_network_mode;
/**  whether to support 4g network */
/** 是否支持4G网络 */
@property (nonatomic, assign) NSInteger network_supported;
/** whether to support onvif */
/** 是否支持onvif */
@property (nonatomic, assign) NSInteger onvif_enable;
/** the password of device */
/** 设备密码 */
@property (nonatomic,   copy) NSString *device_password;
/** sleep mode enum */
/** 休眠模式枚举 */
@property (nonatomic, assign) MeariDeviceSleepMode sleepMode;
/** Video encoding type */
/** 视频编码类型 */
@property (nonatomic, assign) NSInteger videoEnc;
@property (nonatomic, strong) MeariDeviceLED *led;
@property (nonatomic, strong) MeariDeviceParamChime *chime;
@property (nonatomic, assign) NSInteger alarmFeq;
@property (nonatomic, assign) MeariDeviceCapabilityAFQ alarmFeqLevel;
@property (nonatomic, strong) MeariDeviceRoi *roi;

@property (nonatomic,   copy) NSString *onvifAddress;
@property (nonatomic,   copy) NSString *mac;
@property (nonatomic, assign) NSTimeInterval lastCheckTime; // 最后检查时间
@property (nonatomic, assign) MeariDeviceOtaUpgradeMode otaUpgradeMode;
@property (nonatomic, assign) BOOL faceRecognitionEnable;
/** 时间格式 */
@property (nonatomic, strong) MeariDeviceParamTimeShow *timeShow;
/** 防拆报警 */
@property (nonatomic, strong) MeariDeviceParamTamperAlarm *tamperAlarm;
@property (nonatomic, assign) BOOL recordEnable;

- (instancetype)initWithIotDic:(NSDictionary *)dic device:(MeariDevice *)device;
 
@end
