//
//  MeariDeviceParam.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MeariDevice;
@class MeariDevicePetFeedPlanModel;

/** Sleep mode status */
/** 休眠模式状态 */
typedef NS_ENUM(NSInteger, MeariDevicePreviewAbnormalType) {
    MeariDevicePreviewAbnormalPoorTransmisson,
};

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

/** Flicker Level*/
/** 设备抗闪烁等级 */
typedef NS_ENUM(NSInteger, MeariDeviceFlickerLevel) {
    MeariDeviceFlickerLevelClose   = 0, // close all
    MeariDeviceFlickerLevelFiftyHz = 1, // 50Hz
    MeariDeviceFlickerLevelSixtyHz = 2, // 60Hz
    MeariDeviceFlickerLevelAuto    = 3, // auto
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
    MeariDeviceOtaUpgradeModeNormal = 0,  // status normal (正常)
    MeariDeviceOtaUpgradeModeUpgrading, // status upgrading (升级中)
    MeariDeviceOtaUpgradeModeWaitReboot, // status upgraded and wait reboot (升级完成等待重启)
    MeariDeviceOtaUpgradeModeDownloadError, // status upgrade download error (升级失败因下载失败)
    MeariDeviceOtaUpgradeModeWriteError, // status upgrade write error (升级失败因写flash失败)
    MeariDeviceOtaUpgradeModeFormatError, // status upgrade format error (升级失败因包格式问题)
    MeariDeviceOtaUpgradeModeWaitLowPower // status upgrade low power (电量低无法升级)
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
typedef NS_ENUM (NSInteger, MeariDeviceVoiceLightRingType) {
    MeariDeviceVoiceLightRingTypeNone = 0, // 默认
    MeariDeviceVoiceLightRingTypeOne = 1, // 铃声一
    MeariDeviceVoiceLightRingTypeTwo = 2,  // 铃声二
    MeariDeviceVoiceLightRingTypeThree = 3, // 铃声三
};

typedef NS_ENUM (NSInteger, MeariDevicePhotoResolution) {
    MeariDevicePhotoResolution30MP = 0, // 30MP
    MeariDevicePhotoResolution24MP = 1, // 24MP
    MeariDevicePhotoResolution20MP = 2,  // 20MP
    MeariDevicePhotoResolution16MP = 3, // 16MP
    MeariDevicePhotoResolution12MP = 4, // 12MP
    MeariDevicePhotoResolution8MP = 5, //  8MP
    MeariDevicePhotoResolution5MP = 6, //  5MP
    MeariDevicePhotoResolution3MP = 7, //  3MP
    MeariDevicePhotoResolution1MP = 8, //  1MP
};

typedef NS_ENUM (NSInteger, MeariDeviceRecordResolution) {
    MeariDeviceRecordResolution4K = 0, // 4K
    MeariDeviceRecordResolution2K = 1, // 2K
    MeariDeviceRecordResolution1296 = 2,  // 1296p
    MeariDeviceRecordResolution1080 = 3, // 1080p
    MeariDeviceRecordResolution720 = 4, // 720p
    MeariDeviceRecordResolution480 = 5, //  480p
    MeariDeviceRecordResolution360 = 6, //  360p
};

typedef NS_ENUM (NSInteger, MeariDevicePrtpDoulePirLevel) {
    MeariDevicePrtpDoulePirLow = 0, // 高
    MeariDevicePrtpDoulePirMid = 1, // 中
    MeariDevicePrtpDoulePirHigh = 2,  // 低
    MeariDevicePrtpDoulePirOff = 3,  // 关
};

typedef NS_ENUM (NSInteger, MeariDeviceLanguageType) {
    MeariDeviceLanguageTypeZH = 0, // 中文
    MeariDeviceLanguageTypeEN = 1, // 英语
    MeariDeviceLanguageTypeFR = 2,  // 法语
    MeariDeviceLanguageTypeES = 3,  // 西班牙
    MeariDeviceLanguageTypePT = 4,  // 葡萄牙
    MeariDeviceLanguageTypeDE = 5,  // 德语
    MeariDeviceLanguageTypeIT = 6,  // 意大利
    MeariDeviceLanguageTypeJA = 7,  // 日本
    MeariDeviceLanguageTypeKO = 8  // 韩国
};

typedef NS_ENUM (NSInteger, MeariDevicePowerOnCaptureType) {
    MeariDevicePowerOnCaptureTypePhoto = 0, // 拍照
    MeariDevicePowerOnCaptureTypeVideo = 1, // 录像
    MeariDevicePowerOnCaptureTypePhotoVideo = 2,  // 拍照+录像
};

typedef NS_ENUM (NSInteger, MeariDeviceOSDTimeStyleType) {
    MeariDeviceOSDTimeStyleType24H = 0, //
    MeariDeviceOSDTimeStyleType12H = 1, //
};
typedef NS_ENUM (NSInteger, MeariDeviceIRLEDType) {
    MeariDeviceIRLEDTypeAuto = 0, //
    MeariDeviceIRLEDTypeSave = 1, //
    MeariDeviceIRLEDTypeClose = 2, //
};
#pragma mark -- 亮灯定时计划
@interface MeariDeviceParamNightLightSchedule : MeariBaseModel
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@end

#pragma mark -- 夜灯颜色值
@interface MeariDeviceParamNightLightColor : MeariBaseModel
@property (nonatomic, assign) NSInteger red;   // 0 ~ 255
@property (nonatomic, assign) NSInteger green; // 0 ~ 255
@property (nonatomic, assign) NSInteger blue; // 0 ~ 255
@end

#pragma mark -- 夜灯设置
@interface MeariDeviceParamNightLight : MeariBaseModel
@property (nonatomic, assign) BOOL on;
@property (nonatomic, strong) MeariDeviceParamNightLightSchedule *schedule;
@property (nonatomic, strong) MeariDeviceParamNightLightColor *color;
@property (nonatomic, assign) NSInteger mode;
@end
#pragma mark -- 补光灯设置
@interface MeariDeviceParamFillLight : MeariBaseModel
@property (nonatomic, assign) BOOL on;
//@property (nonatomic, strong) MeariDeviceParamNightLightSchedule *schedule;
//@property (nonatomic, strong) MeariDeviceParamNightLightColor *color;
//@property (nonatomic, assign) NSInteger mode;
@end

#pragma mark -- 自动更新
@interface MeariDeviceParamAutoUpdate : MeariBaseModel
@property (nonatomic, assign) BOOL on;
@end

#pragma mark -- 防拆报警
@interface MeariDeviceParamTamperAlarm : MeariBaseModel
@property (nonatomic, assign) NSInteger enable;
@end

#pragma mark -- 时间设置
@interface MeariDeviceParamTimeShow : MeariBaseModel
@property (nonatomic, assign) NSInteger timeShowFormat;
//Whether to set the time zone automatically (是否为自动设置时区)
@property (nonatomic, assign) BOOL autoTimeZone;
//Set the time zone manually (手动设置时区)
@property (nonatomic, strong) NSString *manualTimeZone;
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
@interface MeariDeviceParamCloudStorage : MeariBaseModel
@property (nonatomic, assign) NSInteger enable;
@end

@interface MeariDeviceParamStorage : MeariBaseModel
@property (nonatomic, copy)NSString *company;
/** Storage Name */
/** 存储名 */
@property (nonatomic, assign)NSInteger name;
/** Total storage space */
/** 总存储空间 */
@property (nonatomic, copy)NSString *totalSpace;
/** used storage space */
/** 已使用空间 */
@property (nonatomic, copy)NSString *usedSpace;
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
/** 空间不足 */
@property (nonatomic, assign)BOOL noSpace;

+ (NSArray *)initWithArray:(NSArray *)array;
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

@interface MeariDeviceParamIntelligentDetect : MeariBaseModel
/** Whether to open intelligent detect */
/** 是否开启 智能侦测 */
@property (nonatomic, assign)NSInteger enable;

@property (nonatomic, assign)NSInteger enablePerson;
@property (nonatomic, assign)NSInteger enablePet;
@property (nonatomic, assign)NSInteger enableCar;
@property (nonatomic, assign)NSInteger enablePackage;
/**  是否开启 画框  */
@property (nonatomic, assign)NSInteger enableFrame;
@property (nonatomic, assign)MeariDeviceLevel level;//低-0；中-1；高-2

@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *stopTime;

- (instancetype)initWithIotDic:(NSDictionary *)dic device:(MeariDevice *)device;
@end

#pragma mark -- 休眠模式:按时间休眠
@interface MeariDeviceParamSleepTime : MeariBaseModel
/** Whether to turn off the timed sleep */
/** 是否开启 该时间断的休眠 */
@property (nonatomic, assign)BOOL enable;
/**  Start sleep time formart "00:00" ,"10:10" */
/** 开始时间 */
@property (nonatomic, copy)NSString *start_time;
/** Stop sleep time formart "00:00" ,"10:10"  */
/** 结束时间 */
@property (nonatomic, copy)NSString *stop_time;
/** whether repeat  */
/** 1 : Monday 2:Tuesday 3:Wednesday  4:Thursday  5:Friday  6: Saturday 7: Sunday   e.g. @[@(1),@(2),@(3),@(4),@(5),@(6),@(7)]]*/
/** 是否重复 */
@property (nonatomic, copy)NSArray *repeat;
@end

#pragma mark -- 休眠模式:按地理位置休眠
@interface MeariDeviceParamSleepGeographic : MeariBaseModel
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

@interface MeariDeviceParamVoiceLightAlarm : MeariBaseModel
/** Whether to turn off the voice light alarm */
/** 是否开启 声光报警设置 */
@property (nonatomic, assign)BOOL enable;
// 触发报警 动作类型
@property (nonatomic, assign) MeariDeviceVoiceLightType videoLightType;

// 触发报警 铃声类型
@property (nonatomic, assign) MeariDeviceVoiceLightRingType ringType;
@property (nonatomic, strong) NSArray<MeariDeviceParamSleepTime *> *alarmPlan; //声光报警计划
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
@interface MeariDeviceParamDBDetection : MeariBaseModel
/** Whether to open noise detection */
/** 是否开启噪声检测 */
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSInteger threshold;
/** MeariDeviceLevelLow|MeariDeviceLevelMedium|MeariDeviceLevelHigh */
@property (nonatomic, assign) MeariDeviceLevel level;
@property (nonatomic, assign) NSInteger patrolEnable;
@end

#pragma mark -- 回放录像设置
@interface MeariDeviceParamPlaybackVideoRecord : MeariBaseModel
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
/** bell alarm work mode */
/** 0 :  Power saving mode (省电模式) 1: Performance mode（性能模式）  2;Custom mode （自定义模式） */
@property (nonatomic, assign)NSInteger workmode;
@end

#pragma mark -- 上报录像至云端
@interface MeariDeviceCloudStorage : MeariBaseModel
/** whether the cloud storage is open */
/** 开启云存储 */
@property (nonatomic, assign) NSInteger enable;
@end

#pragma mark -- 灯具摄像头开灯计划
@interface MeariDeviceFlightSchedule : MeariBaseModel
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
@interface MeariDeviceFlight : MeariBaseModel
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
/** Maximum alarm duration */
/** 最大警报时长 */
@property (nonatomic, assign) NSInteger maxSirenTime;

@end

@class MeariDeviceLEDAll;
@interface MeariDeviceLED : MeariBaseModel
@property (nonatomic, strong) MeariDeviceLEDAll *all;

@end
@interface MeariDeviceLEDAll : MeariBaseModel
@property (nonatomic, assign) NSInteger enable;

@end
@interface MeariDeviceRoi : MeariBaseModel
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString  *bitmap;
@property (nonatomic, strong) NSArray  *maps;
@end

@interface MeariDeviceParamPtzTime : MeariBaseModel
/** Whether to turn off the timed sleep */
/** 是否开启 该时间断的休眠 */
@property (nonatomic, assign)NSInteger enable;
/**  Start ptz time */
/** 开始时间  01:00 格式 24小时制 */
@property (nonatomic, copy)NSString *time;
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

#pragma mark -- Nvr(iot)
@interface MeariDeviceParamChannelState : MeariBaseModel
@property (nonatomic, assign) NSInteger channel; //通道
@property (nonatomic, assign) NSInteger state; //状态
@property (nonatomic, assign) BOOL type; // 0-normal 1-onvif
+ (NSArray *)initWithArray:(NSArray *)array;
@end
@interface MeariDeviceParamNvr : MeariBaseModel
@property (nonatomic, strong) NSArray *channels; //通道数
@property (nonatomic,   copy) NSArray <MeariDeviceParamChannelState *> *channelState;; //通道状态
@property (nonatomic,   copy) NSString *network; //配网信息
@property (nonatomic,   copy) NSArray <MeariDeviceParamStorage *> *storages; //磁盘信息
@property (nonatomic, assign) NSInteger channel; // 通道数
@property (nonatomic, assign) BOOL antiJamming; // wifi抗干扰开关
@property (nonatomic, assign) BOOL allDayRecord; // 全天录像
@property (nonatomic,   copy) NSString *tp; // 通道数
@property (nonatomic,   copy) NSString *networkConfig; // 配网信息
@property (nonatomic,   copy) NSString *firVersion; // 固件版本号
@property (nonatomic,   copy) NSString *platformModel; // 型号
@property (nonatomic,   copy) NSString *platformCode; // 平台代号
@property (nonatomic, assign) NSInteger onlineTime; //在线时长
- (instancetype)initWithIotDic:(NSDictionary *)dic device:(MeariDevice *)device;
@end

/*  多边形区域报警
 type : 1 defalut
 points: [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,X7,Y7,X8,Y8]
         X1, Y1代表第一个点X坐标，Y坐标，值为占画面的比例，范围是0-100，左上顶点为(0,0),右下顶点为(100，100);
         坐标需按照原始框顺时针或者逆时针发送。
 */
@interface MeariDevicePolygonRoiArea : MeariBaseModel
@property (nonatomic, assign) NSInteger type; //默认为1
@property (nonatomic,   copy) NSArray *points; //

@end

@interface MeariDeviceJingle : MeariBaseModel
@property (nonatomic, assign) BOOL enable;
@property (nonatomic,   copy) NSArray <MeariDeviceParamSleepTime *> *sleepTime; // 勿扰模式时间

@end

#pragma mark -- 设备参数
@interface MeariDeviceParam : MeariBaseModel

@property (nonatomic, copy) NSString *licenseID;
@property (nonatomic, copy) NSString *tp;
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

/** Alarm whole switch  */
/** 报警总开关 */
@property (nonatomic, assign) NSInteger alarmWhole;

/** Motion Detection parameters */
/** 移动侦测参数 */
@property (nonatomic, strong) MeariDeviceParamMotion *motion_detect;

@property (nonatomic, strong) MeariDeviceParamPeopleDetect *people_detect;
@property (nonatomic, assign) NSInteger people_detectLevel;
@property (nonatomic, strong) MeariDeviceParamCryDetect *cry_detect;
@property (nonatomic, strong) MeariDeviceParamPeopleTrack *people_track;

@property (nonatomic, strong) MeariDeviceParamIntelligentDetect *intelligent_detect;

@property (nonatomic, strong) MeariDeviceParamSleepGeographic *home_geographic;
/**  sleep mode time */
/** 休眠模式时间段 */
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *>*sleep_time;
//iOT
/** motion alert time array */
/** 移动侦测报警时间段 */
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *>*alarm_time;
/**  ptz patrol time */
/** ptz 巡航时间点 */
@property (nonatomic, strong) NSArray <MeariDeviceParamPtzTime *>*ptz_time;

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
@property (nonatomic, assign) MeariDeviceFlickerLevel antiflicker;
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
@property (nonatomic, strong) MeariDeviceParamNvr *nvr;
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
@property (nonatomic, strong) MeariDeviceParamNightLight *nightLight;
@property (nonatomic, strong) MeariDeviceParamAutoUpdate *autoUpdate;
//补光灯
@property (nonatomic, strong) MeariDeviceParamFillLight *fillLight;

// jingle device
@property (nonatomic, strong) MeariDeviceJingle *jingle;

@property (nonatomic, strong) NSArray <MeariDevicePolygonRoiArea *> *polygonRoi;

@property (nonatomic, assign) NSInteger ipcLowpowerMode;

//Minimum App Supported Version (最低App支持版本)
@property (nonatomic, assign) NSInteger appProtocolVer;
//Whether to support connection encryption (是否支持预览密码加密)
@property (nonatomic, assign) BOOL enableConnectPwd;

@property (nonatomic, assign) BOOL recordAudio; // 录像声音
@property (nonatomic, assign) BOOL speaker; // 扬声器
@property (nonatomic, assign) BOOL microphone; // 设备麦克风
/** homekit使能开关 */
@property (nonatomic, assign) BOOL homeKitEnable;
/** 灯具摄像机（RGB灯）的开关灯状态(只读)，最终状态以这个为准 */
@property (nonatomic, assign) BOOL nightLightOn;
@property (nonatomic, copy) NSString *iccID;
@property (nonatomic, copy) NSString *imei;
/** logo使能开关 */
@property (nonatomic, assign) BOOL logoEnable;

//云存储2.0 事件报警类型 : 上传报警图片-0；上传报警图片+视频-1
@property (nonatomic, assign) NSInteger alarmVideoEvent;

//投食机抛投的时候，是否附带抛投本地语音：1-播放投掷提示音，0-不播放
@property (nonatomic, assign) BOOL playPetThrowTone;
//投食呼唤语音设置,由于投食机涉及3首本地音频，如果选择的是本地的三个音频，则url下发
//{"url":"https://localhost/voice1.wav"} , default: '{"url":"https://localhost/voice1.wav"}'
@property (nonatomic, copy) NSString *petVoiceUrl;
//定时投食计划
@property (nonatomic, strong) NSArray<MeariDevicePetFeedPlanModel *> *petFeedPlans;


//狩猎相机

@property (nonatomic, assign) MeariDevicePowerOnCaptureType powerOnCaptureType;
@property (nonatomic, assign) MeariDevicePhotoResolution photoResolvingType;
@property (nonatomic, assign) NSInteger captureNums;
@property (nonatomic, assign) MeariDeviceLanguageType languageType;
@property (nonatomic, assign) NSInteger recordingDuration;
@property (nonatomic, assign) MeariDeviceRecordResolution recordResolutionType;
//@property (nonatomic, assign) BOOL videoVoiceEnable;
@property (nonatomic, assign) MeariDeviceOSDTimeStyleType timeStyleType;
@property (nonatomic, assign) BOOL timeOSDEnable;
@property (nonatomic, assign) MeariDeviceIRLEDType iRLEDType;
@property (nonatomic, assign) NSInteger timedTakePhotoSec;
@property (nonatomic, assign) BOOL monitoringPeriodEnable;
@property (nonatomic, copy) NSString *monitoringPeriod;
@property (nonatomic, assign) NSInteger twoPIR;
@property (nonatomic, assign) NSInteger pirInterval;
@property (nonatomic, copy) NSString *wifiSetting;
@property (nonatomic, assign) BOOL buttonSoundEnable;
@property (nonatomic, assign) BOOL bluetoothEnable;
@property (nonatomic, assign) BOOL restoreFactoryEnable;
@property (nonatomic, assign) BOOL timingShootingEnable;
@property (nonatomic, assign) BOOL powerOnPsdEnable;
@property (nonatomic, copy) NSString *powerOnPsd;
@property (nonatomic, assign) MeariDevicePrtpDoulePirLevel mainLevel;
@property (nonatomic, assign) MeariDevicePrtpDoulePirLevel sideLevel;
@property (nonatomic, copy) NSString *syncTimestamp;
@property (nonatomic, copy) NSArray *timedRecordVideoSchedule;
@property (nonatomic, assign) BOOL timedRecordVideoEnable;
@property (nonatomic, assign) NSInteger prtpVolume;

- (instancetype)initWithIotDic:(NSDictionary *)dic device:(MeariDevice *)device;
 
@end
