//
//  MeariDevice.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MeariKit/MeariDeviceInfo.h>
#import <MeariKit/MeariDeviceParam.h>
#import <MeariKit/MeariDeviceControl.h>
#import <MeariKit/MeariDeviceEnum.h>
@interface MeariDevice : MeariBaseModel<MeariDeviceControl>
+ (instancetype)deviceWithDeviceId:(NSInteger)deviceId;
+ (instancetype)deviceWithDeviceSn:(NSString *)sn;

#pragma mark - 信息
/** device info*/
/** 自身的信息*/
@property (nonatomic, strong) MeariDeviceInfo *info;
/** device params*/
/** 控制功能的参数信息*/
@property (nonatomic, strong) MeariDeviceParam *param;


/** normal device*/
/** 是否是普通摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcCommon) BOOL ipcCommon;
/** music device*/
/** 是否是音乐摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcBaby) BOOL ipcBaby;
/** doorbell*/
/** 是否是门铃摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcBell) BOOL ipcBell;
/** chime*/
/** 中继铃铛 */
@property (nonatomic, assign, readonly, getter = isChime) BOOL chime;
/** voiceBell*/
/** 语言门铃 */
@property (nonatomic, assign, readonly, getter = isVoiceBell) BOOL voiceBell;
/** FloodCamera*/
/** 灯具摄像机*/
@property (nonatomic, assign, readonly, getter = isFloodCamera) BOOL FloodCamera;
/** ForthGeneration*/
/** 4G摄像机*/
@property (nonatomic, assign, readonly, getter = isForthGeneration) BOOL ForthGeneration;
/** jingle*/
/** 铃铛jingle*/
@property (nonatomic, assign, readonly, getter = isJing) BOOL jing;
/** photoBell*/
/** 拍照门铃 */
@property (nonatomic, assign, readonly, getter = isPhotoBell) BOOL photoBell;
/** hunting*/
/** 狩猎相机*/
@property (nonatomic, assign, readonly, getter = isHunting) BOOL hunting;
/** petfeeder*/
/** 宠物投食器*/
@property (nonatomic, assign, readonly, getter = isPetfeeder) BOOL petfeeder;

/** Whether the device is support iot*/
/** 是否iOT设备*/
@property (nonatomic, assign) BOOL iotDevice;

@property (nonatomic, assign, readonly) BOOL supportAwsIot;
@property (nonatomic, assign, readonly) BOOL supportMeariIot;

#pragma mark -- 状态
/** Whether the device has established a network connection*/
/** 是否已经建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogined;
/** Whether the MeariIot device has established a network connection*/
/** meariIot是否已经建立连接*/
@property (nonatomic, assign, readonly) BOOL meariIotLogined;
/** Whether the device is establishing a network connection*/
/** 是否正在建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogining;
/** Whether the device is being previewed*/
/** 是否正在准备预览*/
@property (nonatomic, assign, readonly) BOOL sdkPreparePlay;
/** Whether the device is playing*/
/** 是否正在预览*/
@property (nonatomic, assign, readonly) BOOL sdkPlaying;
/** Whether the device is speaking*/
/** 是否正在预览*/
@property (nonatomic, assign, readonly) BOOL sdkSpeaking;
/** Whether the device is being playbacked*/
/** 是否正在回放*/
@property (nonatomic, assign, readonly) BOOL sdkPlayRecord;
/** The time currently being played back*/
/** 当前回放时间*/
@property (nonatomic, strong) NSDateComponents *playbackTime;
/** nvr's camera*/
/** 用于nvr回放*/
- (instancetype)nvrCamera;

#pragma mark -- 支持的功能
/** videoStream 720/1080*/
/** 获取高清码流：720/1080*/
- (MeariDeviceVideoStream)videoStreamHD;
/** videoStream 240/360*/
/** 获取标清码流：240/360*/
- (MeariDeviceVideoStream)videoStreamSD;
/** Get the stream type of device*/
/** 获取支持的码流类型*/
- (NSArray *)supportVideoStreams;
/** 设备回放/云回放/报警图片视频比例 默认去bsp2的1字段*/
/** Get the stream type of device*/
- (CGFloat)defalutVideoRatio;
/** 获取支持的视频比例 supportNewVideoStream 为YES 才启用*/
- (CGFloat)videoRatioForVideoStream:(MeariDeviceVideoStream)stream;
/** Get Supported SDK record type */
/** 获取支持的SDK录像类型*/
- (NSArray *)supportSdRecordLevels;
/** Get Supported SDK alarm frequency interval*/
/** 获取支持的SDK报警间隔类型*/
- (NSArray *)supportAlarmFrequencyIntervalLevels;
/** Get Supported munal light duration */
/** 获取支持的SDK手动亮灯时长*/
- (NSArray <NSNumber *>*)supportLightDurationSeconds;

/**是否支持AOV模式下 回放速度的设定 */
- (NSInteger)supportAovPlaybackSpeed;


/** Whether to support local server */
/** 是否支持ONVIF */
@property (nonatomic, assign, readonly) BOOL supportOnvif;
/** Whether to support local server */
/** 是否支持新版本ONVIF */
@property (nonatomic, assign, readonly) BOOL supportNewOnvif;


/** Whether to support set body detection sensitivity */
/** 是否支持设置人体侦测等级 */
@property (nonatomic, assign, readonly) MeariDevicePirSensitivity supportPirSensitivity;
/** Whether to support setting sleep mode */
/** 是否支持设置休眠模式 */
@property (nonatomic, assign, readonly) BOOL supportSleepMode;
/** Is it a low power device */
/** 是否为低功耗设备 */
@property (nonatomic, assign, readonly) BOOL lowPowerDevice;
/** Whether to support switching the main stream */
/** 是否支持切换主码流 */
@property (nonatomic, assign, readonly) BOOL supportVideoEnc;


/** Whether to support the iot protocol*/
/** 是否支持iot协议 */
@property (nonatomic, assign, readonly) BOOL supportIotProtocol;


/** 是否支持音量调节 */
@property (nonatomic, assign, readonly) BOOL supportSpeakVolume;

/** 是否支持人脸识别 */
@property (nonatomic, assign, readonly) BOOL supportFaceRecognition;

/** 视频显示的类型 */
@property (nonatomic, assign, readonly) MeariDeviceVideoType displayVideoType;
/** 灯具摄像机类型 */
@property (nonatomic, assign, readonly) MeariDeviceFloodCameraType floodCameraType;
/** 是否支持时间风格设置 */
@property (nonatomic, assign, readonly) BOOL supportTimeShowSetting;


/** pir等级设置，用于多级设置开关1-N档 返回最大支持等级， 0不支持*/
@property (nonatomic, assign, readonly) NSInteger supportPirLevel;

/** 是否支持视频预览出图 (语音门铃使用) */
@property (nonatomic, assign, readonly) BOOL supportPreviewImage;

/** 支持的云台方向 */
@property (nonatomic, assign, readonly) MeariDevicePtzDirection ptzDirection;
/** 支持新版本的码率 */
@property (nonatomic, assign, readonly) BOOL supportNewVideoStream;

/** 是否支持鸣笛报警*/
@property (nonatomic, assign, readonly) BOOL supportSiren;
/** 是否支持最大警报时长 flight*/
@property (nonatomic, assign, readonly) BOOL supportMaxSirenTime;
/** 是否支持设备扬声器*/
@property (nonatomic, assign, readonly) BOOL supportDeviceSpeaker;
/** 是否支持麦克风*/
@property (nonatomic, assign, readonly) BOOL supportMicrophone;


/** 彩色日夜模式*/
@property (nonatomic, assign, readonly) MeariDeviceDayNightMode dayNightType;

/**
 dnm2
 彩色日夜模式
 supportdnm2 是否有 dnm2 能力级
 supportDayNightModeDefaultMode  支持非暖光灯的夜视模式
 supportDayNightModeFullColorMode 支持暖光灯的夜视模式
 supportDayNightModeDimlightMode  支持微光全彩模式
 */
@property (nonatomic, assign, readonly) BOOL supportdnm2;
@property (nonatomic, assign, readonly) BOOL supportDayNightModeDefaultMode;
@property (nonatomic, assign, readonly) BOOL supportDayNightModeFullColorMode;
@property (nonatomic, assign, readonly) BOOL supportDayNightModeDimlightMode;
/** 设备链接加密*/
@property (nonatomic, assign, readonly) BOOL supportConnectEncryption;


/** 是否支持时区设置*/
@property (nonatomic, assign, readonly) BOOL supportTimeZone;

/** 是否连接私有协议NVR,允许被发现功能*/
@property (nonatomic, assign, readonly) BOOL supportFoundPermission;
/** 设备报警方式是否支持视频上报 */
@property (nonatomic, assign, readonly) BOOL supportAlarmVideoReport;
/**  支持事件报警类型设置切换 / */
@property (nonatomic, assign, readonly) BOOL supportAlarmVideoEventSwitch;
/** 是否支持logo叠加 */
@property (nonatomic, assign, readonly) BOOL supportLogo;
/** 设备视频是否支持AI处理 */
@property (nonatomic, assign, readonly) BOOL supportAlarmAI;




/** 支持回放视频倍速*/
@property (nonatomic, assign, readonly) NSArray *supportPlayBackSpeed;
/** 支持自适应码率*/
@property (nonatomic, assign, readonly) BOOL supportAutoStream;
/** 是否为宠物投食机*/
@property (nonatomic, assign, readonly) BOOL isPetCamera;
/** 是否支持一键投食*/
@property (nonatomic, assign, readonly) BOOL supportPetFeed;
/** 是否支持投食计划*/
@property (nonatomic, assign, readonly) BOOL supportPetFeedPlan;
/** 是否支持设置播放抛投效果音(固件写死的提示音，非主人留言)*/
@property (nonatomic, assign, readonly) BOOL supportPetFeedVoice;
/** 是否支持主人投食留言语音设置*/
@property (nonatomic, assign, readonly) BOOL supportPetMasterMessageSetting;


/** 支持狩猎相机工作模式设置  */
@property (nonatomic, assign, readonly) BOOL supportVopSetting ;
/** 支持狩猎相机拍照管理设置  */
@property (nonatomic, assign, readonly) BOOL supportPhotoResolutionSetting ;
/** 支持狩猎相机拍照张数设置  */
@property (nonatomic, assign, readonly) BOOL supportSnapshotsSetting;
/** 支持狩猎相机录像管理设置  */
@property (nonatomic, assign, readonly) BOOL supportVideoResolutionSetting;
/** 支持狩猎相机录像时长设置  */
@property (nonatomic, assign, readonly) BOOL supportRecordDurationSetting;
/** 支持狩猎相机定时拍摄设置  */
@property (nonatomic, assign, readonly) BOOL supportPeriodIntervalTimeSetting;
/** 支持狩猎相机监控时段设置  */
@property (nonatomic, assign, readonly) BOOL supportMonitoringPeriodSetting;
/** 支持狩猎相机irled设置  */
@property (nonatomic, assign, readonly) BOOL supportIrLedSetting;
/** 支持狩猎相机恢复默认设置  */
@property (nonatomic, assign, readonly) BOOL supportRestoreFactorySetting;
/** 支持狩猎相机麦克风设置  */
@property (nonatomic, assign, readonly) BOOL supportMicrophoneSetting;
/** 支持狩猎相机语言设置  */
@property (nonatomic, assign, readonly) BOOL supportLanguageSetting;
/** 支持狩猎相机时间设置  */
@property (nonatomic, assign, readonly) BOOL supportTimeSetting;
/** 支持拍照门铃实时画面开关设置  */
@property (nonatomic, assign, readonly) BOOL supportPreviewSwitchSetting;
/** 支持继电器设置  */
@property (nonatomic, assign, readonly) BOOL supportRelay;
/** 支持狩猎相机pir设置  */
@property (nonatomic, assign, readonly) BOOL supportPrtpPirSetting;
/**门铃绑定相关，是否显示门铃关联 */
@property (nonatomic, assign, readonly) BOOL supportRelayFunction;
/** 是否支持切换WIFI */
@property (nonatomic, assign, readonly) BOOL supportSwitchWifi;
/** 是否支持设置安全访问密码*/
@property (nonatomic, assign, readonly) BOOL supportDevicePassword;
/** 是否支持犬吠检测 */
@property (nonatomic, assign, readonly) BOOL supportDogBarkDetection;

/** 是否支持宠物检测 */
@property (nonatomic, assign, readonly) BOOL supportPetDetection;

/** 支持双目 */
@property (nonatomic, assign, readonly) BOOL supportMultiCamera;

-(NSString *)multiCameraParams;
/**是否支持AOV模式 */
@property (nonatomic, assign, readonly) BOOL supportAovMode;

/**是否支持全时低功耗的工作模式设置*/
@property (nonatomic, assign, readonly) BOOL supportLowPowerWorkMode;
@property (nonatomic, assign, readonly) BOOL supportLowPowerSaveWorkMode;
@property (nonatomic, assign, readonly) BOOL supportLowPowerPerformanceWorkMode;
@property (nonatomic, assign, readonly) BOOL supportLowPowerCustomWorkMode;
/** 是否支持事件录像延时 （事件录像结束后，再多录一定时间的录像）*/
@property (nonatomic, assign, readonly) BOOL supportEventRecordDelay;
/**是否支持补光距离配置*/
@property (nonatomic, assign, readonly) BOOL supportFillLightDistance;
/**是否支持夜景模式配置*/
@property (nonatomic, assign, readonly) BOOL supportNightSceneMode;

/**是否支持双SIM卡 */
@property (nonatomic, assign, readonly) BOOL supportDualSIMCard;
/**是否支持限制4G设备流量 */
@property (nonatomic, assign, readonly) BOOL supportLimitTraffic;

/** 支持AOV视频帧率数组*/
- (NSArray <NSNumber *>*)supportAovModeFrameRateArray;
/** 支持实时视频帧率数组*/
- (NSArray <NSNumber *>*)supportLiveVideoFrameRateArray;

/** 支持音乐限制时间数组(0-不限时) */
- (NSArray <NSNumber *>*)supportMusicLimitTimeArray;
/** 是否支持毫米波雷达 bit0=1支持开关 bit1:呼吸使能 bit2:心跳使能 bit3:身体状态使能 bit4:身体运动状态量*/
- (BOOL)supportMrda; 
- (BOOL)supportMrdaBreatheEnable;
- (BOOL)supportMrdaHeartBeatEnable;
- (BOOL)supportMrdaConditionEnable;
- (BOOL)supportMrdaMotionStateQuantity; 
@end

@interface MeariDeviceList : MeariBaseModel
/** ipc */
/** 摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;
/** doorbell */
/** 智能门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** voicebell */
/** 语音门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** batteryipc */
/** 电池摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** floot camera */
/** 灯具摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** nvr */
/** 网络存储器 */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;
/** chime */
/** 中继 */
@property (nonatomic, strong) NSArray <MeariDevice *> *chimes;
/** forth */
/** 4G摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *forths;
/** 新版NVR */
/** neutral nvr */
@property (nonatomic, strong) NSArray <MeariDevice *> *neutralnvrs;
/** Base NVR */
/** base nvr */
@property (nonatomic, strong) NSArray <MeariDevice *> *basenvrs;
/** jingle */
/** 铃铛 */
@property (nonatomic, strong) NSArray <MeariDevice *> *jings;
/** photobell */
/** 拍照门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *photoBells;
/** huntings */
/** 狩猎相机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *huntings;
/** prtpDevice  */
/** prtp设备存本地*/
@property (nonatomic, strong) NSArray <MeariDevice *> *prtpDevices;

- (NSMutableArray<MeariDevice *> *)allDeviceList;
@end
