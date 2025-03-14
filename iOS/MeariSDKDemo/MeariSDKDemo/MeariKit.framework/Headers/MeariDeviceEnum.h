//
//  MeariDeviceEnum.h
//  MeariKit
//
//  Created by duan on 2023/11/10.
//  Copyright © 2023 Meari. All rights reserved.
//

#ifndef MeariDeviceEnum_h
#define MeariDeviceEnum_h

#pragma mark - Add
//设备添加Token
typedef NS_ENUM(NSInteger, MeariDeviceTokenType) {
    MeariDeviceTokenTypeSmartWifi, // use SmartWifi Configure the network (SmartWifi 配网)
    MeariDeviceTokenTypeAP, // use ap Configure the network (AP配网)
    MeariDeviceTokenTypeQRCode // use QRCode  Configure the network (二维码配网)
};
typedef NS_ENUM(NSInteger, MeariDeviceGatewayTokenType) {
    MeariDeviceGatewayToken, // token use for geteway(网关)
    MeariDeviceGatewayTokenSubDevice, //token use for gateway subdevice (网关子设备)
};
//设备添加状态
typedef NS_ENUM(NSInteger, MeariDeviceAddStatus) {
    MeariDeviceAddStatusSelf = 1, // Your device (你的设备)
    MeariDeviceAddStatusUnShare, //  Not shared (未分享)
    MeariDeviceAddStatusNone, // Not added (未添加)
    MeariDeviceAddStatusShared, // Already shared (已经添加)
    MeariDeviceAddStatusSharing, // Sharing (已经分享中)
    MeariDeviceAddStatusFailure, // device abnormal (设备不正常)
    MeariDeviceAddStatusOverLimit,// device count over limit (设备超出限制)
    MeariDeviceAddStatusByOther,  // device has been added by other (设备已被他人添加)
    MeariDeviceAddStatusRegionMismatch,  // The device does not match the user's region (设备与添加用户地区不匹配)
};
typedef NS_ENUM(NSInteger, MeariDeviceLimitLevel) {
    MeariDeviceLimitLevelNone,
    MeariDeviceLimitLevelForbidden,
};
#pragma mark - Type
//设备大类
typedef NS_ENUM(NSInteger, MeariDeviceType) {
    MeariDeviceTypeNVR = 0,
    MeariDeviceTypeIpc = 1,
    MeariDeviceTypeChime = 2,
};
//设备大类之下分类
typedef NS_ENUM(NSInteger, MeariDeviceSubType) {
    MeariDeviceSubTypeNVR = 0,
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,
    MeariDeviceSubTypeIpcVoiceBell = 5,
    MeariDeviceSubTypeIpcFloodlight = 6,
    MeariDeviceSubTypeIpcForthGeneration = 7,
    MeariDeviceSubTypeChime = 8,
    MeariDeviceSubTypeJing = 9,
    MeariDeviceSubTypeHunting = 10,
    MeariDeviceSubTypePetfeeder = 11,
    MeariDeviceSubTypeIpcPhotoBell = 15,
    MeariDeviceSubTypeIpcHunting = 16,
    MeariDeviceSubTypeBase = 17,
    MeariDeviceSubTypePetLocator = 19,
};

#pragma mark - Preview
//云台支持转动方向（Supported rotation direction of PTZ）
typedef NS_ENUM(NSInteger, MeariDevicePtzDirection) {
    MeariDevicePtzDirectionNone = 0,      //not support
    MeariDevicePtzDirectionAll = 1,       //left/right/up/down
    MeariDevicePtzDirectionUpDown = 2,    //up/down
    MeariDevicePtzDirectionLeftRight = 3  //left/right
};

////语音对讲类型（Voice Intercom Type）
//typedef NS_ENUM(NSInteger, MeariDeviceVoiceTalkType) {
//    MeariDeviceVoiceTalkTypeOneWay,     //One-way voice intercom
//    MeariDeviceVoiceTalkTypeFullDuplex,
//};
//云台移动方向
typedef NS_ENUM(NSInteger, MeariDevicePtzMoveDirection) {
    MeariDevicePtzMoveDirectionUp,      //向上（up）
    MeariDevicePtzMoveDirectionDown,    //向下（up）
    MeariDevicePtzMoveDirectionLeft,    //向左（up）
    MeariDevicePtzMoveDirectionRight,   //向右（up）
};
//预览流清晰度
typedef NS_ENUM (NSInteger, MeariDeviceVideoStream) {
    MeariDeviceVideoStream_HD = 0,
    MeariDeviceVideoStream_360 = 1,
    MeariDeviceVideoStream_240 = 2,
    MeariDeviceVideoStream_480 = 3,
    MeariDeviceVideoStream_720 = 4,
    MeariDeviceVideoStream_1080 = 5,
    MeariDeviceVideoStream_1080_1_5 = 6,
    MeariDeviceVideoStream_1080_2_0 = 7,
    MeariDeviceVideoStream_3MP_1_2 = 8,
    MeariDeviceVideoStream_3MP_2_4 = 9,
    MeariDeviceVideoStream_NEW_SD = 100,
    MeariDeviceVideoStream_NEW_HD = 101,
    MeariDeviceVideoStream_NEW_FHD = 102,
    MeariDeviceVideoStream_NEW_UHD = 103,
    MeariDeviceVideoStream_NEW_4K  = 104,
    MeariDeviceVideoStream_NEW_AUTO = 105,
    MeariDeviceVideoStreamNone = 999,
};
//预览视频宽高比 (Preview video aspect ratio)
typedef NS_ENUM (NSInteger, MeariDeviceVideoRatio) {
    MeariDeviceVideoRatio16_9,  //16:9
    MeariDeviceVideoRatio4_3,   //4:3
    MeariDeviceVideoRatio1_1,   //1:1
};
//预览连接设备方式
typedef NS_ENUM (NSInteger, MeariDeviceConnectType) {
    MeariDeviceConnectTypeNone = -1,    //未知
    MeariDeviceConnectTypeP2p,          //P2P打洞
    MeariDeviceConnectTypeRelay,
    MeariDeviceConnectTypeLan,
};

//时间显示格式
typedef NS_ENUM(NSInteger, MeariDeviceTimeShowType) {
    MeariDeviceTimeShowType24 = 0,  //24小时制
    MeariDeviceTimeShowType12,      //12小时制
};
//实时预览模式
typedef NS_ENUM(NSInteger, MeariDeviceLiveMode) {
    MeariDeviceLiveModeNormal = 0,  //正常模式
    MeariDeviceLiveModeAOV,         //AOV模式
};

#pragma mark - Support Capability
//对讲支持类型
typedef NS_ENUM(NSInteger, MeariDeviceVoiceTalkType) {// Voice intercom type (设备语音对讲类型)
    MeariDeviceVoiceTalkTypeNone         = 0,    //No speakers and microphone (没有扬声器和麦克)
    MeariDeviceVoiceTalkTypeSpeekerOnly  = 1,    //Speaker only (仅有扬声器)
    MeariDeviceVoiceTalkTypeMicOnly      = 2,    //Only Mike (仅有麦克)
    MeariDeviceVoiceTalkTypeHalfDuplex   = 3,    //Half duplex (半双工)
    MeariDeviceVoiceTalkTypeFullDuplex   = 4,    //Full duplex (全双工)
};
typedef NS_ENUM(NSInteger, MeariDeviceCapabilityVSTType) {
    MeariDeviceCapabilityVSTTypeNormal       = 0,    // HD/SD ( h_264高清/标清)
    MeariDeviceCapabilityVSTTypeOnlyHD       = 1     // HD (h_264高清)
};
typedef NS_ENUM (NSUInteger, MeariDeviceSupportBellType) {
    MeariDeviceSupportBellTypeWireless,       //Wireless bell is supported by default (默认支持无线铃铛)
    MeariDeviceSupportBellTypeMachinery = 0b1,//mechanical bell (机械铃铛)
    MeariDeviceSupportBellTypeWirelessBell = 0b10,//Wireless Bell (无线铃铛)
    MeariDeviceSupportBellTypeWirelessBellEnable = 0b100,//Wireless Bell (无线铃铛使能)
    MeariDeviceSupportBellTypeWirelessBellPair = 0b1000,//Wireless Bell (无线铃铛配对)
    MeariDeviceSupportBellTypeWirelessBellVolume = 0b10000,//Wireless Bell (无线铃铛音量)
    MeariDeviceSupportBellTypeWirelessBellSongs = 0b100000,//Wireless Bell (无线铃铛铃声选择)
    MeariDeviceSupportBellTypeWirelessEnable = 0b10000000,//Wireless enable (无线使能)
};
typedef NS_ENUM (NSUInteger, MeariDeviceSupportLowPowerWorkMode) {
    MeariDeviceSupportLowPowerWorkModeSave = 0b1,       //support save power Work Mode (支持省电模式)
    MeariDeviceSupportLowPowerWorkModePerformance = 0b10,//support performance Work Mode(支持性能模式)
    MeariDeviceSupportLowPowerWorkModeCustom = 0b100,   //support custom Work Mode (支持自定义模式)
};

typedef NS_ENUM (NSUInteger, MeariDeviceSupportNewLowPowerWorkMode) {
    MeariDeviceSupportNewLowPowerWorkModeSave = 0b1,       //support save power Work Mode (支持省电模式)
    MeariDeviceSupportNewLowPowerWorkModePerformance = 0b10,//support performance Work Mode(支持性能模式)
    MeariDeviceSupportNewLowPowerWorkModeCustom = 0b100,   //support custom Work Mode (支持自定义模式)
    MeariDeviceSupportNewLowPowerWorkModeGeneral = 0b1000,   //support custom Work Mode (支持常电模式模式)
};
//事件录像延时
typedef NS_ENUM (NSUInteger, MeariDeviceSupportEventRecordDelay) {
    MeariDeviceSupportEventRecordDelayNone = 0,             //not support (不支持)
    MeariDeviceSupportEventRecordDelayThreeS = 0b1,         //3s
    MeariDeviceSupportEventRecordDelaySixS = 0b10,          //6s
    MeariDeviceSupportEventRecordDelayTenS = 0b100,      //10s
    MeariDeviceSupportEventRecordDelayTwentyS = 0b1000,     //20s
    MeariDeviceSupportEventRecordDelayThirtyS = 0b10000,     //30s
};
//补光灯距离
typedef NS_ENUM (NSUInteger, MeariDeviceSupportFillLightDistance) {
    MeariDeviceSupportFillLightDistanceNone = 0,            //not support (不支持)
    MeariDeviceSupportFillLightDistanceAuto = 0b1,          //自动
    MeariDeviceSupportFillLightDistanceTenM = 0b10,         //10m
    MeariDeviceSupportFillLightDistanceTwentyM = 0b100,     //20m
    MeariDeviceSupportFillLightDistanceThirtyM = 0b1000,    //30m
};
//夜景模式配置
typedef NS_ENUM (NSUInteger, MeariDeviceSupportNightSceneMode) {
    MeariDeviceSupportNightSceneModeNone = 0,            //not support (不支持)
    MeariDeviceSupportNightSceneModeNormal = 0b1,        //普通模式
    MeariDeviceSupportNightSceneModeEnhance = 0b10,
    //增强模式
};
//抗闪烁
typedef NS_ENUM (NSUInteger, MeariDeviceSupportFlickerType) {
    MeariDeviceSupportFlickerTypeNone = 0,          //not support (不支持)
    MeariDeviceSupportFlickerTypeFiftyHz = 0b1,     //50HZ
    MeariDeviceSupportFlickerTypeSixtyHz = 0b10,    //60HZ
    MeariDeviceSupportFlickerTypeAuto = 0b100,      //auto（自动）
    MeariDeviceSupportFlickerTypeClose = 0b1000,    //close（关闭）
};
//主人留言功能
typedef NS_ENUM(NSInteger, MeariDeviceSupportHostType) {
    MeariDeviceSupportHostTypeNone               = 0,    //Does not support messages (不支持留言)
    MeariDeviceSupportHostTypeOne                = 1,    //Support a message only (支持一段留言)
    MeariDeviceSupportHostTypeMultiple           = 2,    //Support 3 messages (支持3段留言)
};
typedef NS_ENUM(NSInteger, MeariDeviceSupportProtocolType) {
    MeariDeviceSupportProtocolP2p               = 0b1,    //p2p
    MeariDeviceSupportProtocolIot               = 0b10,    //iot
};
typedef NS_ENUM (NSUInteger, MeariDeviceLocalServerType) {
    MeariDeviceLocalServerTypeChangePSW = 0b1,    // Support password modification (支持密码修改)
    MeariDeviceLocalServerTypeOnvif     = 0b10,   // Support Onvif (支持Onvif)
};
//人形检测功能
typedef NS_OPTIONS(NSUInteger, MeariDevicePeopleDetect) {
    MeariDevicePeopleDetectEnable = 0b1, // 人形检测开关设置
    MeariDevicePeopleDetectBnddraw = 0b10, // 画框开关设置
    MeariDevicePeopleDetectDay = 0b100, // 白天人形开关设置
    MeariDevicePeopleDetectNight = 0b1000, // 夜间人形开关设置
};
//ptz高级功能
typedef NS_OPTIONS(NSUInteger, MeariDevicePtzAdvanceType) {
    MeariDevicePtzPoint = 0b1, // ptz高级功能 内置预置点（pre point）
    MeariDevicePtzCruise = 0b10, // ptz高级功能 多点巡航 (Cruise between multiple points)
    MeariDevicePtzPatrol = 0b100, // ptz高级功能 巡逻一周 （Patrol for a week）
};
// dnm 是否支持日夜切换开关(自动/日/夜)的能力级
typedef NS_ENUM(NSUInteger, MeariDeviceSupportDayNightMode) {
    MeariDeviceSupportDayNightModeNone, // 0=不支持
    MeariDeviceSupportDayNightModeNightVision, // 1=支持非照明灯的夜视模式(自动/日/夜)
    MeariDeviceSupportDayNightModeFullColor, // 2=支持照明灯的全彩模式（智能夜视/全彩夜视/黑白夜视）
    MeariDeviceSupportDayNightModeDimlight, //3=支持微光全彩模式（智能夜视/全彩夜视/黑白夜视/微光全彩）
};

// dnm2 是否支持日夜切换开关(自动/日/夜)的能力级
typedef NS_ENUM(NSUInteger, MeariDeviceSupportNewDayNightMode) {
    MeariDeviceSupportNewDayNightModeNone,              // 0=不支持
    MeariDeviceSupportNewDayNightModeNightVision = 0b1, // 支持非照明灯的夜视模式(自动/日/夜)
    MeariDeviceSupportNewDayNightModeFullColor = 0b10,  // 支持照明灯的全彩模式（智能夜视/全彩夜视/黑白夜视）
    MeariDeviceSupportNewDayNightModeDimlight  = 0b100, // 支持微光全彩模式（智能夜视/全彩夜视/黑白夜视/微光全彩）
    MeariDeviceSupportNewDayNightModeTiming  = 0b1000, // 支持定时模式
    MeariDeviceSupportNewDayNightModeBlackLight  = 0b10000, // 支持黑光AOV模式（全彩夜视/关闭白光灯）
};
//云存储状态
typedef NS_ENUM (NSInteger, MeariDeviceCloudState) {
    MeariDeviceCloudStateCloseCanTry = 0,      //Not open but can trial (未开通可试用)
    MeariDeviceCloudStateCloseNotTry,          //Not open and cant trial (未开通不可试用)
    MeariDeviceCloudStateOpenNotOverDue,       //open (已开通)
    MeariDeviceCloudStateOpenOverDue           //expired (已过期)
};
//pir报警支持灵敏度等级
typedef NS_ENUM (NSInteger, MeariDevicePirSensitivity) {
    MeariDevicePirSensitivityNone = 0, // not support (不支持)
    MeariDevicePirSensitivityAll = 1, // Support all (支持PIR使能开关+设置选项(高中低))
    MeariDevicePirSensitivityOnlySwitch = 2,//Support enable (只支持PIR的使能开关)
    MeariDevicePirSensitivitySwitchAndHighLow= 4,//Support enable And high,low level (支持PIR使能开关+设置选项(高低))
    MeariDevicePirSensitivityIpcDoublePir = 5, // Support dual PIR enable switch (left and right) + unified sensitivity setting options (high and low) (used in constant current equipment, such as Flight 4T) (支持双PIR的使能开关(左和右)+统一的灵敏度设置选项(高低)(用于常电设备，如Flight 4T))
    
    MeariDevicePirSensitivityLowPowerDoublePir = 6, // Support dual PIR enable switch (left and right) + unified sensitivity setting options (high and low) (for low power consumption devices, such as Flight 3T) 支持双PIR的使能开关(左和右)+统一的灵敏度设置选项(高低)(用于低功耗设备，如Flight 3T)
    MeariDevicePirSensitivityFlight5s7s = 7, // 支持pir使能开关+pir灵敏度档位设置（10档）(用于常电设备，如flight5s,flight7s)
    MeariDevicePirSensitivityFlight5s7sPic = 8, // 支持pir使能开关+pir灵敏度档位设置（10档）图形显示 (用于常电高级设备类型，如flight5s,flight7s)
};
//视频显示
typedef NS_ENUM (NSInteger, MeariDeviceVideoType) {
    // Wlh : width less height ， 宽大于高
    MeariDeviceVideoTypeNoSupportWlh = 0, // 默认 16 : 9 , default
    MeariDeviceVideoTypeSupportWlhSourceRight = 1, // // 9 : 16 , source also is 9 : 16
    MeariDeviceVideoTypeSupportWlhSourceError = 2, // // 9 : 16 , but source also is 16 : 9, The decoder needs to flip by itself
};
//灯具支持功能
typedef NS_ENUM(NSInteger, MeariDeviceFloodCameraType) {
    MeariDeviceFloodCameraTypeNone,     // not support FloodLight Camera
    MeariDeviceFloodCameraTypeNormal,   // support FloodLight Camera
    MeariDeviceFloodCameraTypeLowPower, // LowPower FloodLight Camera
};
typedef NS_ENUM (NSUInteger, MeariDeviceStatisticType) {
    MeariDeviceStatisticTypeRealTime = 0b1,    // Real-time information reporting (实时信息上报)
    MeariDeviceStatisticTypeInterval  = 0b10,   // Daily/Monthly Information Report (天/月信息上报)
    MeariDeviceStatisticTypeFalseAlarm  = 0b100,   // Number of false alarms (误报次数)
};
//设备/家庭设备分享使用权限
typedef NS_ENUM(NSUInteger, MeariDeviceAuthority) {
    MeariDeviceAuthorityOnlyView,   // 仅查看
    MeariDeviceAuthorityControl,    // 允许控制
    MeariDeviceAuthorityUnUseAble,  // 不可使用
};
//NVR设备支持添加子设备方式
typedef NS_ENUM(NSUInteger, MeariAddSubDeviceMode) {
    MeariAddSubDeviceModeSetNVRQRcode = 0b1, // 是否支持生成Camera连接NVR的二维码(NVR设置页）
    MeariAddSubDeviceModeSetRouterQRcode = 0b10, // 是否支持camera连接路由器的二维码(NVR设置页面)
    MeariAddSubDeviceModeAddNVRQRcode = 0b100, // 是否支持生成Camera连接NVR的二维码(NVR展示页面)
    MeariAddSubDeviceModeAddRouterQRcode = 0b1000, // 是否支持camera连接路由器的二维码(NVR展示页面)
};
//支持智能报警相关能力
typedef NS_ENUM(NSUInteger, MeariDeviceIntelligentDetectionType) {
    MeariDeviceIntelligentDetectionTypeTotal = 0b1, // 是否支持智能侦测总开关设置
    MeariDeviceIntelligentDetectionTypePerson = 0b10, // 是否支持人形检测开关设置
    MeariDeviceIntelligentDetectionTypePet = 0b100, // 是否支持宠物检测开关设置
    MeariDeviceIntelligentDetectionTypeCar = 0b1000, // 是否支持车辆检测开关设置
    MeariDeviceIntelligentDetectionTypePackage = 0b10000, // 是否支持包裹检测开关设置
    MeariDeviceIntelligentDetectionTypeFrame = 0b100000, // 是否支持智能检测画框开关设置
    MeariDeviceIntelligentDetectionTypeTime = 0b1000000, // 是否支持智能检测布防时间
    MeariDeviceIntelligentDetectionTypeArea = 0b10000000, // 是否支持智能检测区域
    MeariDeviceIntelligentDetectionTypeFire = 0b100000000, // 是否支持烟火检测开关设置
};

// 支持声光报警相关能力
typedef NS_ENUM(NSUInteger, MeariDeviceVoiceLightAlarmType) {
    MeariDeviceVoiceLightAlarmTypeTotal = 0b1, // 是否支持声光报警总开关
    MeariDeviceVoiceLightAlarmTypePlan = 0b10, // 是否支持声光报警时间段
    MeariDeviceVoiceLightAlarmTypeRing = 0b100, // 是否支持声光报警铃声
    MeariDeviceVoiceLightAlarmTypeVoice = 0b1000, // 是否支持声报警
    MeariDeviceVoiceLightAlarmTypeLight = 0b10000, // 是否支持光报警
};

// 支持回放快进速率
typedef NS_ENUM(NSUInteger, MeariDevicePlaybackSpeed) {
    MeariDevicePlaybackSpeedAllFrame = 0b1, // 支持 0.5、1、 2、 4 倍速度
    MeariDevicePlaybackSpeedSubFrame = 0b10, // 支持 8、 16 倍速度
};

// 支持AI生成相册类型
typedef NS_ENUM(NSUInteger, MeariDeviceSupportAlbumType) {
    MeariDeviceSupportAlbumTypeTime = 0b1, // 时光相册
};
#pragma mark - Param
//夜视功能
typedef NS_ENUM (NSUInteger, MeariDeviceNightVisionMode) {
    MeariDeviceNightVisionModeAuto = 0, // auto mode (自动改变)
    MeariDeviceNightVisionModeDay, // day mode (白天)
    MeariDeviceNightVisionModeNight, // night mode (黑夜)
    MeariDeviceNightVisionModeDimlight, //Low-light mode 微光模式（夜间默认不开灯，微光全彩）
    MeariDeviceNightVisionModeTiming, //time plan mode 定时模式
};
//全彩模式
typedef NS_ENUM (NSUInteger, MeariDeviceFullColorMode) {
    MeariDeviceFullColorModeAuto = 0, // auto mode 智能夜视（默认黑白夜视效果，检测到移动或人形时自动切换为全彩）
    MeariDeviceFullColorModeNormal, // full color 全彩夜视（暖光灯开启，彩色画面呈现，同时起到照明作用）
    MeariDeviceFullColorModeNightVision, // night mode 黑白夜视（红外灯开启，黑白画面呈现，暖光灯自动关闭）
    MeariDeviceFullColorModeDimlight, //Low-light mode 微光模式（夜间默认不开灯，微光全彩）
    MeariDeviceFullColorModeTiming, //time plan mode 定时模式
    MeariDeviceFullColorModeCloseLight //time plan mode 关闭白光灯
};
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
//双红外侦测
typedef NS_ENUM(NSInteger, MeariDeviceDoublePirStatus) {
    MeariDeviceDoublePirStatusClose, // close all
    MeariDeviceDoublePirStatusOpenLeft, // open left pir
    MeariDeviceDoublePirStatusOpenRight, // open right pir
    MeariDeviceDoublePirStatusOpenAll, // open all
};

/** Flicker Level*/
/** 设备抗闪烁等级 */
typedef NS_ENUM(NSInteger, MeariDeviceFlickerLevel) {
    MeariDeviceFlickerLevelClose   = 0, // close
    MeariDeviceFlickerLevelFiftyHz = 1, //  FiftyHz
    MeariDeviceFlickerLevelSixtyHz = 2, //  SixtyHz
    MeariDeviceFlickerLevelAuto    = 3, // Auto
};

/** Device image quality level*/
/** 设备图像质量等级 */
typedef NS_ENUM(NSInteger, MeariDeviceImageQualityLevel) {
    MeariDeviceImageQualityLevelOne     = 0, // 低
    MeariDeviceImageQualityLevelTwo     = 1,
    MeariDeviceImageQualityLevelThree   = 2,
    MeariDeviceImageQualityLevelFour    = 3,
    MeariDeviceImageQualityLevelFive    = 4, // 中等
    MeariDeviceImageQualityLevelSix     = 5,
    MeariDeviceImageQualityLevelSeven   = 6,
    MeariDeviceImageQualityLevelEight   = 7,
    MeariDeviceImageQualityLevelNine    = 8, // 高
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
    MeariDeviceRecordDurationAuto = 0b10000000, //自动
    MeariDeviceRecordDurationOff = 0b100000000, // record is close 关闭录像
    MeariDeviceRecordDurationOn = 0b1000000000, // record is open(If you only want to open the record and use the previous value, this action will only open the record)  只开启录像
    MeariDeviceRecordDuration24Hours = 0b10000000000, // 全天录像
};
/** alarm frequency interval*/
/** 设备报警频率间隔时长 */
typedef NS_ENUM (NSUInteger, MeariDeviceCapabilityAFQ) {
    MeariDeviceCapabilityAFQOff         = 0b1,       //关闭报警间隔
    MeariDeviceCapabilityAFQOneMin      = 0b10,//1min  一分钟
    MeariDeviceCapabilityAFQTwoMin      = 0b100,//2min  两分钟
    MeariDeviceCapabilityAFQThreeMin    = 0b1000,//3min 三分钟
    MeariDeviceCapabilityAFQFiveMin     = 0b10000,//5min 五分钟
    MeariDeviceCapabilityAFQTenMin      = 0b100000,//10min 十分钟
    MeariDeviceCapabilityAFQThirtySec   = 0b1000000,//30s 三十秒
};

/** NetWork mode */
/**  网络联网方式 */
typedef NS_ENUM (NSUInteger, MeariDeviceNetworkMode) {
    MeariDeviceNetworkModeNone = 0, //Unknow (未知)
    MeariDeviceNetworkModeWLAN = 1, // Wi-Fi network (无线联网)
    MeariDeviceNetworkMode4G = 2, // 4g network (4g联网)
    MeariDeviceNetworkModeWiredLAN = 3 // Wired LAN (有线联网)
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

typedef NS_ENUM (NSInteger, MeariMusicPlayMode) {
    MeariMusicPlayModeRepeatAll = 0, // play all music cycle (全部循环)
    MeariMusicPlayModeRepeatOne = 1, // play Single cycle (单曲循环)
    MeariMusicPlayModeRandom    = 2, // Shuffle Play (随机播放)
    MeariMusicPlayModeSingle    = 999, // play single music (播放一首一次)
};
//设备升级状态
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
//报警触发类型
typedef NS_ENUM (NSInteger, MeariDeviceVoiceLightType) {
    MeariDeviceVoiceLightTypeVoice = 0, // voice  (报警触发声音)
    MeariDeviceVoiceLightTypeLight = 1, // Support light (报警触发亮灯)
    MeariDeviceVoiceLightTypeAll = 2,  //Support all (报警触发声音和亮灯)
};
//声光报警铃声类型
typedef NS_ENUM (NSInteger, MeariDeviceVoiceLightRingType) {
    MeariDeviceVoiceLightRingTypeNone = 0, // 默认
    MeariDeviceVoiceLightRingTypeOne = 1, // 铃声一
    MeariDeviceVoiceLightRingTypeTwo = 2,  // 铃声二
    MeariDeviceVoiceLightRingTypeThree = 3, // 铃声三
};

typedef NS_ENUM (NSInteger, MeariDevicePhotoResolution) {
    MeariDevicePhotoResolution64MP = 0, // 64MP
    MeariDevicePhotoResolution33MP = 1, // 33MP
    MeariDevicePhotoResolution23MP = 2, // 23MP
    MeariDevicePhotoResolution15MP = 3,  // 15MP
    MeariDevicePhotoResolution8MP = 4, // 8MP
    MeariDevicePhotoResolution4MP = 5, // 4MP
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

//高低温类型
typedef NS_ENUM (NSInteger, MeariDeviceHumitureType) {
    MeariDeviceHumitureAlarm = 0, //设置温湿度报警类型
    MeariDeviceTemperatureHeight = 1, //设置最高温度值
    MeariDeviceTemperatureLow = 2, //设置最低温度值
    MeariDeviceHumidityHeight = 3, //设置最高湿度值
    MeariDeviceHumidityLow = 4, //设置最低湿度值
};
//是否支持毫米波雷达
typedef NS_ENUM (NSUInteger, MeariDeviceSupportMrdaType) {
    MeariDeviceSupportMrdaSwitch = 0b1,       //support save power Work Mode (支持开关)
    MeariDeviceSupportMrdaBreatheEnable = 0b10,//support performance Work Mode(呼吸使能)
    MeariDeviceSupportMrdaHeartBeatEnable = 0b100,   //support custom Work Mode (心跳使能)
    MeariDeviceSupportMrdaConditionEnable = 0b1000,   //support custom Work Mode (身体状态使能)
    MeariDeviceSupportMrdaMotionStateQuantity = 0b10000,   //support custom Work Mode (身体运动状态量)
};
typedef NS_ENUM (NSInteger, MeariMusicSupportPlayMode) {
    MeariMusicSupportPlayModeSingle    =  0, // play single music (播放一首一次)
    MeariMusicSupportPlayModeRepeatOne = 0b1, // play Single cycle (单曲循环)
    MeariMusicSupportPlayModeRepeatAll = 0b10, // play all music cycle (全部循环)
    MeariMusicSupportPlayModeRandom    = 0b100, // Shuffle Play (随机播放)
    
};
typedef NS_ENUM (NSInteger, MeariDevicePwdSetting) {
    MeariDevicePwdNotSupport    =  0, // 不支持用户密码
    MeariDevicePwdSupport = 0b1, // 支持用户密码
    MeariDeviceAIAnalysisPwdSupport = 0b10, // 支持AI分析使用用户密码
};
//AI识别类目
typedef NS_ENUM (NSInteger, MeariDeviceAIAnalysisType) {
    MeariDeviceAIAnalysisPerson = 1, //人
    MeariDeviceAIAnalysisCar = 2, //车
    MeariDeviceAIAnalysisPet = 3, //宠物
    MeariDeviceAIAnalysisPackage = 4, //包裹
    MeariDeviceAIAnalysisCry = 5, //哭声
    MeariDeviceAIAnalysisBark = 6, //犬吠
    MeariDeviceAIAnalysisWildlife = 7, //野生动物
    MeariDeviceAIAnalysisBirds = 8, //鸟类
    MeariDeviceAIAnalysisShot = 9, //枪声
    MeariDeviceAIAnalysisGlassBroken = 10, //玻璃碎裂
    MeariDeviceAIAnalysisBabyCoverFace = 11, //婴儿遮挡
    MeariDeviceAIAnalysisBabyLieDown = 12, //婴儿趴睡
};
//SIM卡选择
typedef NS_ENUM (NSUInteger, MeariDeviceUseSIMCardMode) {
    MeariDeviceUseSIMCardModeAuto = 0, // auto mode (自动改变)
    MeariDeviceUseSIMCardModeFirst, // First Card (卡1)
    MeariDeviceUseSIMCardModeSecond, // Second Card (卡2)
};

typedef NS_ENUM (NSInteger, MeariLocatorReportMode) {
    MeariLocatorReportModeBackground = 0, //后台上报模式，APP未查看
    MeariLocatorReportModeNormal = 1,  // 地图模式，按APP请求上报
    MeariLocatorReportModeRealTime = 2, //实时模式，按APP请求上报，上报间隔30s
    MeariLocatorReportModeTracking = 3 //追踪模式,按APP请求上报，上报间隔5s
};

typedef NS_ENUM (NSInteger, MeariLocatorSupportWorkMode) {
    MeariLocatorSupportAwayAloneWorkMode = 0b1, // Away alone mode (独自外出模式)
    MeariLocatorSupportAccompanyWorkMode = 0b10,  // Escort mode (陪同模式)
    MeariLocatorSupportHomeWorkMode    = 0b100,  // at home mode (在家模式)
};
typedef NS_ENUM (NSInteger, MeariLocatorWorkMode) {
    MeariLocatorWorkModeAwayAlone    =  0,     // Away alone mode (独自外出模式)
    MeariLocatorWorkModeAccompany = 1,         // Escort mode (陪同模式)
    MeariLocatorWorkModeHome = 2,              // at home mode (在家模式)
};
typedef NS_ENUM (NSInteger, MeariLocatorLocationSupportMode) {
    MeariLocatorLocationSupportGPS          = 0b1,     // 支持GPS定位
    MeariLocatorLocationSupportWifi         = 0b10,    // 支持WiFi定位
    MeariLocatorLocationSupportBaseStation  = 0b100,   // 支持基站定位
};
typedef NS_ENUM (NSInteger, MeariDevicePetType) {
    MeariDevicePetTypeNormal = 1,  //Pet food dispenser
    MeariDevicePetTypeFeed   = 2,  //pet feeder
    MeariDevicePetTypeTease  = 3,  //Pet teasing camera
};

typedef NS_ENUM(NSInteger, MeariWarmLightFuncType) {
    MeariWarmLightFuncNotSupport           = 0,      //不支持
    MeariWarmLightFuncSupportLampSwitch    = 0b1,    //支持灯控开关
    MeariWarmLightFuncSupportScheduleTime  = 0b10,   //支持定时开启
    MeariWarmLightFuncSupportLightMode     = 0b100,  //支持亮灯模式
    MeariWarmLightFuncSupportBrightness    = 0b1000, //支持亮度
};
typedef NS_ENUM(NSInteger, MeariSmartCareItemType) {
    MeariSmartCareItemTypeDownSleep           = 1,      // 趴睡
    MeariSmartCareItemTypeCoverFace           = 2,      // 遮脸
    MeariSmartCareItemTypeCry                 = 3,      // 哭声
    MeariSmartCareItemTypeNightLight          = 4,      // 趴睡
    MeariSmartCareItemTypeMotion              = 5,      // 移动侦测
    MeariSmartCareItemTypeTrack               = 6,      // 移动追踪
    MeariSmartCareItemTypeNoise               = 7,      // 噪声
};
typedef NS_OPTIONS(NSUInteger, MeariDeviceLightMode) {
    MeariDeviceLightModeAll = 0, //
    MeariDeviceLightModeNone = 0b1, // 全部不支持
    MeariDeviceLightModeAlwaysLight = 0b10, // 常量
    MeariDeviceLightModeMarquee = 0b100, // 跑马灯
    MeariDeviceLightModeBreath = 0b1000, // 呼吸灯
};
typedef NS_OPTIONS(NSUInteger, MeariDevicePetBatteryMode) {
    MeariDevicePetBatteryModeNone = 0, // 不支持电量显示
    MeariDevicePetBatteryModeGrid = 1// 格子 显示电池
};

typedef NS_ENUM(NSInteger, MeariDeviceGMTOffsetTimeZone) {
    MeariDeviceGMTOffsetTimeZoneMinus12     = 0,      // GMT-12:00
    MeariDeviceGMTOffsetTimeZoneMinus11     = 1,      // GMT-11:00
    MeariDeviceGMTOffsetTimeZoneMinus10     = 2,      // GMT-10:00
    MeariDeviceGMTOffsetTimeZoneMinus9      = 3,      // GMT-09:00
    MeariDeviceGMTOffsetTimeZoneMinus8      = 4,      // GMT-08:00
    MeariDeviceGMTOffsetTimeZoneMinus7      = 5,      // GMT-07:00
    MeariDeviceGMTOffsetTimeZoneMinus6      = 6,      // GMT-06:00
    MeariDeviceGMTOffsetTimeZoneMinus5      = 7,      // GMT-05:00
    MeariDeviceGMTOffsetTimeZoneMinus430    = 8,      // GMT-04:30
    MeariDeviceGMTOffsetTimeZoneMinus4      = 9,      // GMT-04:00
    MeariDeviceGMTOffsetTimeZoneMinus330    = 10,      // GMT-03:30
    MeariDeviceGMTOffsetTimeZoneMinus3      = 11,      // GMT-03:00
    MeariDeviceGMTOffsetTimeZoneMinus2      = 12,      // GMT-02:00
    MeariDeviceGMTOffsetTimeZoneMinus1      = 13,      // GMT-01:00
    MeariDeviceGMTOffsetTimeZonePlus0       = 14,      // GMT+00:00
    MeariDeviceGMTOffsetTimeZonePlus1       = 15,      // GMT+01:00
    MeariDeviceGMTOffsetTimeZonePlus2       = 16,      // GMT+02:00
    MeariDeviceGMTOffsetTimeZonePlus3       = 17,      // GMT+03:00
    MeariDeviceGMTOffsetTimeZonePlus330     = 18,      // GMT+03:30
    MeariDeviceGMTOffsetTimeZonePlus4       = 19,      // GMT+04:00
    MeariDeviceGMTOffsetTimeZonePlus430     = 20,      // GMT+04:30
    MeariDeviceGMTOffsetTimeZonePlus500     = 21,      // GMT+05:00
    MeariDeviceGMTOffsetTimeZonePlus530     = 22,      // GMT+05:30
    MeariDeviceGMTOffsetTimeZonePlus545     = 23,      // GMT+05:45
    MeariDeviceGMTOffsetTimeZonePlus6       = 24,      // GMT+06:00
    MeariDeviceGMTOffsetTimeZonePlus630     = 25,      // GMT+06:30
    MeariDeviceGMTOffsetTimeZonePlus7       = 26,      // GMT+07:00
    MeariDeviceGMTOffsetTimeZonePlus8       = 27,      // GMT+08:00
    MeariDeviceGMTOffsetTimeZonePlus9       = 28,      // GMT+09:00
    MeariDeviceGMTOffsetTimeZonePlus930     = 29,      // GMT+09:30
    MeariDeviceGMTOffsetTimeZonePlus10      = 30,      // GMT+10:00
    MeariDeviceGMTOffsetTimeZonePlus11      = 31,      // GMT+11:00
    MeariDeviceGMTOffsetTimeZonePlus12      = 32,      // GMT+12:00
    MeariDeviceGMTOffsetTimeZonePlus13      = 33,      // GMT+13:00
};

#endif /* MeariDeviceEnum_h */
