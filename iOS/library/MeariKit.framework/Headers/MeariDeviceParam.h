//
//  MeariDeviceParam.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeariDeviceEnum.h"
@class MeariDevice;
@class MeariDevicePetFeedPlanModel;

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
@property (nonatomic, copy) NSString *manualTimeZone;
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

/*  多边形区域报警
 type : 1 defalut
 points: [X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,X7,Y7,X8,Y8]
         X1, Y1代表第一个点X坐标，Y坐标，值为占画面的比例，范围是0-100，左上顶点为(0,0),右下顶点为(100，100);
         坐标需按照原始框顺时针或者逆时针发送。
 */
@interface MeariDevicePolygonRoiArea : MeariBaseModel
@property (nonatomic, assign) NSInteger v_id;//video_id，0-单目，1-左目，2=右目，3=上目，4-下目，5=中目
@property (nonatomic, assign) NSInteger type; //默认为1
@property (nonatomic, strong) NSArray *points; //

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
@property (nonatomic, assign)NSInteger enableFire;
/**  是否开启 画框  */
@property (nonatomic, assign)NSInteger enableFrame;
@property (nonatomic, assign)MeariDeviceLevel level;//低-0；中-1；高-2

@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *stopTime;

@property (nonatomic, strong) NSArray <MeariDevicePolygonRoiArea *> *polygonRoi;

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
@property (nonatomic, strong)NSArray *repeat;
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
@property (nonatomic, copy)NSString  *status;
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
/** 829音量 */
@property (nonatomic, assign)NSInteger deviceVolume;
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
@property (nonatomic, assign) NSInteger threshold; //
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
/** 是否电池供电 */
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
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *> *scheduleArray;
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
/** Whether to turn off the ptz cruise time */
/** 是否开启 ptz巡航时间 */
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
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *> *dontDisturbTime; // 勿扰模式时间
@property (nonatomic, strong) NSDictionary *sdRecordDic;

@end

#pragma mark -- Nvr(iot)
@interface MeariDeviceParamChannelState : MeariBaseModel
@property (nonatomic, assign) NSInteger channel; //通道
@property (nonatomic, assign) NSInteger state; //状态
@property (nonatomic, assign) NSInteger type; // 0-normal 1-onvif
+ (NSArray *)initWithArray:(NSArray *)array;
@end
@interface MeariDeviceParamNvr : MeariBaseModel
@property (nonatomic, strong) NSArray *channels; //通道数
@property (nonatomic, strong) NSArray <MeariDeviceParamChannelState *> *channelState;; //通道状态
@property (nonatomic,   copy) NSString *network; //配网信息
@property (nonatomic, strong) NSArray <MeariDeviceParamStorage *> *storages; //硬盘信息
@property (nonatomic, assign) NSInteger channel; // 通道数
@property (nonatomic, assign) BOOL antiJamming; // wifi抗干扰开关
@property (nonatomic, assign) BOOL allDayRecord; // 全天录像
@property (nonatomic, assign) NSInteger promptVolume; //设备提示音量
@property (nonatomic,   copy) NSString *tp; // 通道数
@property (nonatomic,   copy) NSString *networkConfig; // 配网信息
@property (nonatomic,   copy) NSString *firVersion; // 固件版本号
@property (nonatomic,   copy) NSString *platformModel; // 型号
@property (nonatomic,   copy) NSString *platformCode; // 平台代号
@property (nonatomic, assign) NSInteger onlineTime; //在线时长
- (instancetype)initWithIotDic:(NSDictionary *)dic device:(MeariDevice *)device;
@end
@interface MeariDeviceParamSIMCard: MeariBaseModel
/** 4G Camera IEMI */
/** 4G摄像机 双卡正在使用卡序号 */
@property (nonatomic, assign) NSInteger cardNumber;
/** 4G Camera ICCID */
/** 4G摄像机 ICCID */
@property (nonatomic, copy) NSString *iccID;
/** 4G Camera IEMI */
/** 4G摄像机 IEMI */
@property (nonatomic, copy) NSString *imei;

+ (NSArray *)arrayWithDict:(NSDictionary *)dict;
@end

@interface MeariDeviceJingle : MeariBaseModel
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSArray <MeariDeviceParamSleepTime *> *sleepTime; // 勿扰模式时间
@end

@interface MeariDevicePtzPresetPoint : MeariBaseModel
@property (nonatomic, assign) NSInteger idx;    //预置点序号
@property (nonatomic, strong) NSDictionary *ptz;//云台坐标
@end

@interface MeariDeviceVitalSign: MeariBaseModel
/** -1：系统异常 1：处理中（需收集一段数据才有分析结果）2：已经产生有效结果*/
@property (nonatomic, assign) NSInteger st;
/**距离 单位毫米*/
@property (nonatomic, assign) NSInteger dst;
/** 呼吸 单位：次/分钟*/
@property (nonatomic, assign) NSInteger bh;
/** 呼吸波形数据，数组，供APP画波形图使用*/
@property (nonatomic, strong) NSArray *bhw;
/** 心跳 单位：次/分钟*/
@property (nonatomic, assign) NSInteger htb;
/** 心跳波形数据，数组，供APP画波形图使用*/
@property (nonatomic, assign) NSArray *htbw;
/** 身体状态值 0静止 1运动*/
@property (nonatomic, assign) NSInteger bsd;
/** 身体运动状态量 单位%*/
@property (nonatomic, strong) NSDictionary *bmdd;
@end
@interface MeariDeviceMrdaVitalSignRec: MeariBaseModel
/** -1：系统异常 1：处理中（需收集一段数据才有分析结果）2：已经产生有效结果*/
@property (nonatomic, assign) NSInteger s;
/** 距离 单位毫米*/
@property (nonatomic, assign) NSInteger d;
/** 呼吸 单位：次/分钟*/
@property (nonatomic, assign) NSInteger b;
/** 心跳 单位：次/分钟*/
@property (nonatomic, assign) NSInteger h;
/** 身体状态值 0静止 1运动*/
@property (nonatomic, assign) NSInteger bs;
/** 身体运动状态量 单位：%*/
@property (nonatomic, assign) NSInteger bms;
 
@end
@interface MeariDeviceMrdaVitalSign: MeariBaseModel
/** 记录下有生命体进入时的时间戳*/
@property (nonatomic, assign) long long t;
/**上报时间间隔*/
@property (nonatomic, assign) NSInteger inr;
/** 生命体征数据（数据累计持续到生命体离开）*/
@property (nonatomic, strong) NSArray <MeariDeviceMrdaVitalSignRec*>*rec;

@end

#pragma mark -- 设备参数
@interface MeariDeviceParam : MeariBaseModel
#pragma mark - Info
@property (nonatomic, copy) NSString *licenseID;
@property (nonatomic, copy) NSString *tp;
@property (nonatomic, copy) NSString *mac;
/** 4G Camera ICCID */
/** 4G摄像机 ICCID */
@property (nonatomic, copy) NSString *iccID;
/** 4G Camera IEMI */
/** 4G摄像机 IEMI */
@property (nonatomic, copy) NSString *imei;
/**Enter low power hibernation battery threshold */
/**进入低功耗休眠电量阈值 */
@property (nonatomic, assign) NSInteger sleepBatteryThreshold;
/**AOV Mode Frame Rate */
/** AOV码流单帧间隔 */
@property (nonatomic, assign) NSInteger aovModeFrameRate;
/**Video Frame Rate */
/** 主码流单帧间隔 */
@property (nonatomic, assign) NSInteger liveVideoFrameRate;
/**Dual card devices are currently using card */
/** 双卡设备当前使用卡 */
@property (nonatomic, assign) NSInteger currentCardNumber;
@property (nonatomic, strong) NSArray <MeariDeviceParamSIMCard *>* simCard;
/** Time zone of the device */
/** 设备时区 */
@property (nonatomic, copy) NSString *timezone;


/** current time */
/** 设备当前时间 */
@property (nonatomic, copy) NSString *time_now;
/** temperature */
/** 温度 */
@property (nonatomic, assign) CGFloat temperature_c;
/** humidity */
/** 湿度 */
@property (nonatomic, assign) CGFloat humidity;

/**全时低功耗的工作模式*/
@property (nonatomic, assign) NSInteger lowPowerWorkMode;
/** 事件录像延时（事件录像结束后，再多录一定时间的录像）*/
@property (nonatomic, assign) NSInteger eventRecordDelay;
/**补光距离配置*/
@property (nonatomic, assign) NSInteger fillLightDistance;
/**夜景模式配置*/
@property (nonatomic, assign) NSInteger nightSceneMode;

/**音乐限制时长*/
@property (nonatomic, assign) NSInteger musicLimitTime;
/**音乐模式*/
@property (nonatomic, assign) NSInteger musicPlayMode;

#pragma mark - Function
/** device flip */
/** 设备是否开启翻转 */
@property (nonatomic, assign) NSInteger video_mirror;

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
/** People Detection parameters */
/** 人形侦测参数 */
@property (nonatomic, strong) MeariDeviceParamPeopleDetect *people_detect;
@property (nonatomic, assign) NSInteger people_detectLevel;
/** Cry Detection parameters */
/** 哭声检测参数 */
@property (nonatomic, strong) MeariDeviceParamCryDetect *cry_detect;
/** People Track parameters */
/** 人形跟踪参数 */
@property (nonatomic, strong) MeariDeviceParamPeopleTrack *people_track;
/** Decibel Detection parameters */
/** 噪声监测参数 */
@property (nonatomic, strong) MeariDeviceParamDBDetection *decibel_alarm;
/** Intelligent Detection parameters */
/** 智能侦测参数 */
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
/**  current network mode */
/** 当前网络模式 */
@property (nonatomic, assign) MeariDeviceNetworkMode cur_network_mode;
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

/** 获取当前WIFI频段, 0对应2.4G, 1对应5G, 其他频段若需要继续扩展 */
@property (nonatomic, assign) NSInteger wifiFrequency;

//高低温报警值
/**
 温湿度范围：
 温度：0~60
 湿度：10%~99%
 默认范围：
 开关：默认关闭
 单位：默认华氏度
 温度：10~30（摄氏度温度）
 湿度：40~70
 */
/**  设备温湿度报警开关, 0 关，1开   dp 241*/
@property(nonatomic,assign)NSInteger humiture_Alarm_model;
/** 温度区间最高阈值设置，单位摄氏度，温度如果是25摄氏度，下发25000.  dp 242 */
@property(nonatomic,assign)NSInteger humiture_T_heightValue;
/** 温度区间最低阈值设置，单位摄氏度，温度如果是25摄氏度，下发25000.  dp 243 */
@property(nonatomic,assign)NSInteger humiture_T_lowValue;
/** 湿度区间最高阈值设置，湿度如果是40RH，下发40000； dp 244 */
@property(nonatomic,assign)NSInteger humiture_H_heightValue;
/** 湿度区间最低阈值设置，湿度如果是40RH，下发40000； dp 245 */
@property(nonatomic,assign)NSInteger humiture_H_lowValue;

//下列为狩猎相机
/** 狩猎相机工作模式参数 */
@property (nonatomic, assign) MeariDevicePowerOnCaptureType powerOnCaptureType;
/** 狩猎相机拍照分辨率参数 */
@property (nonatomic, assign) MeariDevicePhotoResolution photoResolvingType;
/** 狩猎相机拍照张数参数 */
@property (nonatomic, assign) NSInteger captureNums;
/** 狩猎相机设备语言参数 */
@property (nonatomic, assign) MeariDeviceLanguageType languageType;
/** 狩猎相机录像时长参数 */
@property (nonatomic, assign) NSInteger recordingDuration;
/** 狩猎相机录像分辨率参数 */
@property (nonatomic, assign) MeariDeviceRecordResolution recordResolutionType;
/** 狩猎相机OSD时间格式开关参数 */
@property (nonatomic, assign) BOOL timeOSDEnable;
/** 狩猎相机IRLED参数 */
@property (nonatomic, assign) MeariDeviceIRLEDType iRLEDType;
/** 狩猎相机定时拍照间隔参数 */
@property (nonatomic, assign) NSInteger timedTakePhotoSec;
/** 狩猎相机监控时段集合参数*/
@property (nonatomic, copy) NSString *monitoringPeriod;
/** 狩猎相机pir正面侧面参数*/
@property (nonatomic, assign) NSInteger twoPIR;
/** 狩猎相机pir正面侧面参数*/
@property (nonatomic, assign) NSInteger pirInterval;
/** 狩猎相机wifi设置参数*/
@property (nonatomic, copy) NSString *wifiSetting;
/** 狩猎相机按键声音开关参数*/
@property (nonatomic, assign) BOOL buttonSoundEnable;
/** 狩猎相机蓝牙开关使能参数*/
@property (nonatomic, assign) BOOL bluetoothEnable;
/** 狩猎相机恢复出厂设置使能参数*/
@property (nonatomic, assign) BOOL restoreFactoryEnable;
/** 狩猎相机定时拍照使能参数*/
@property (nonatomic, assign) BOOL timingShootingEnable;
/** 狩猎相机开机密码使能参数*/
@property (nonatomic, assign) BOOL powerOnPsdEnable;
/** 狩猎相机开机密码参数*/
@property (nonatomic, copy) NSString *powerOnPsd;
/** 狩猎相机pir正面参数*/
@property (nonatomic, assign) MeariDevicePrtpDoulePirLevel mainLevel;
/** 狩猎相机pir侧面参数*/
@property (nonatomic, assign) MeariDevicePrtpDoulePirLevel sideLevel;
/** 狩猎相机同步时间戳参数*/
@property (nonatomic, copy) NSString *syncTimestamp;
/** 狩猎相机监控时段列表参数*/
@property (nonatomic, copy) NSArray *timedRecordVideoSchedule;
/** 狩猎相机监控时段使能开关参数*/
@property (nonatomic, assign) BOOL timedRecordVideoEnable;
/** 狩猎相机狩猎相机扬声器使能开关参数*/
@property (nonatomic, assign) BOOL prtpSpeaker;
/** 狩猎相机扬声器音量参数*/
@property (nonatomic, assign) NSInteger prtpVolume;
/** 狩猎相机wifi自动关闭时间参数*/
@property (nonatomic, assign) NSInteger apWifiCloseMin;
/** 狩猎相机时间格式参数*/
@property (nonatomic, assign) NSInteger timeStyle;
/** 狩猎相机当前时间参数*/
@property (nonatomic, assign) NSInteger utcTime;
/** 拍照门铃远程唤醒参数*/
@property (nonatomic, assign) BOOL remoteWakeupEnable;
/** 狩猎相机SD拍照数量参数*/
@property (nonatomic, assign) NSInteger prtpSDPhotos;
/** 狩猎相机SD视频数量参数*/
@property (nonatomic, assign) NSInteger prtpSDVideos;
/** 狩猎相机版本参数*/
@property (nonatomic, copy)NSString *firmwareVersion;
/** 狩猎相机设备名称参数*/
@property (nonatomic, copy)NSString *prtpDeviceName; 
@property (nonatomic, assign) BOOL dogDarkDetection;
@property (nonatomic, assign) BOOL petDetection;
/** 获取生命体征数据*/
@property (nonatomic, strong) MeariDeviceVitalSign *vitalSign;
/** 雷达波生命体征数据上报服务器*/
@property (nonatomic, strong) MeariDeviceMrdaVitalSign *mrdaVitalSign;
- (instancetype)initWithIotDic:(NSDictionary *)dic device:(MeariDevice *)device;
 
@end
