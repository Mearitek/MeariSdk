//
//  MeariDeviceInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MeariDeviceType) {
    MeariDeviceTypeNVR = 0,
    MeariDeviceTypeIpc = 1,
    MeariDeviceTypeChime = 2,
};
typedef NS_ENUM(NSInteger, MeariDeviceSubType) {
    MeariDeviceSubTypeNVR = 0,
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,
    MeariDeviceSubTypeIpcVoiceBell = 5,
    MeariDeviceSubTypeIpcFloodlight = 6,
    MeariDeviceSubTypeChime = 7,
};

typedef NS_ENUM(NSInteger, MeariDeviceAddStatus) {
    MeariDeviceAddStatusSelf = 1, // Your device (你的设备)
    MeariDeviceAddStatusUnShare, //  Not shared (未分享)
    MeariDeviceAddStatusNone, // Not added (未添加)
    MeariDeviceAddStatusShared, // Already shared (已经添加)
    MeariDeviceAddStatusSharing, // Sharing (已经分享中)
    MeariDeviceAddStatusFailure, // device abnormal (设备不正常)
    MeariDeviceAddStatusOverLimit,// device count over limit (设备超出限制)
    MeariDeviceAddStatusByOther,  // device has been added by other 
};
typedef NS_ENUM(NSInteger, MeariDeviceLimitLevel) {
    MeariDeviceLimitLevelNone,
    MeariDeviceLimitLevelForbidden,
};
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
typedef NS_OPTIONS(NSUInteger, MeariDevicePeopleDetect) {
    MeariDevicePeopleDetectEnable = 0b1, // 人形检测开关设置
    MeariDevicePeopleDetectBnddraw = 0b10, // 画框开关设置
    MeariDevicePeopleDetectDay = 0b100, // 白天人形开关设置
    MeariDevicePeopleDetectNight = 0b1000, // 夜间人形开关设置
};
typedef NS_ENUM (NSUInteger, MeariDeviceDayNightType) {
    MeariDeviceDayNightTypeAuto, // auto mode (自动改变)
    MeariDeviceDayNightTypeDay, // day mode (白天)
    MeariDeviceDayNightTypeNight // night mode (黑夜)
};
typedef NS_ENUM(NSInteger, MeariDeviceTokenType) {
    MeariDeviceTokenTypeSmartWifi, // use SmartWifi Configure the network (SmartWifi 配网)
    MeariDeviceTokenTypeAP, // use ap Configure the network (AP配网)
    MeariDeviceTokenTypeQRCode // use QRCode  Configure the network (二维码配网)
};

typedef NS_ENUM(NSInteger, MeariDeviceGatewayTokenType) {
    MeariDeviceGatewayToken, // token use for geteway(网关)
    MeariDeviceGatewayTokenSubDevice, //token use for gateway subdevice (网关子设备)
};

typedef NS_ENUM (NSInteger, MeariDeviceCloudState) {
    MeariDeviceCloudStateCloseCanTry = 0,      //Not open but can trial (未开通可试用)
    MeariDeviceCloudStateCloseNotTry,          //Not open and cant trial (未开通不可试用)
    MeariDeviceCloudStateOpenNotOverDue,       //open (已开通)
    MeariDeviceCloudStateOpenOverDue           //expired (已过期)
};

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

typedef NS_ENUM (NSInteger, MeariDeviceVideoType) {
    // Wlh : width less height ， 宽大于高
    MeariDeviceVideoTypeNoSupportWlh = 0, // 默认 16 : 9 , default
    MeariDeviceVideoTypeSupportWlhSourceRight = 1, // // 9 : 16 , source also is 9 : 16
    MeariDeviceVideoTypeSupportWlhSourceError = 2, // // 9 : 16 , but source also is 16 : 9, The decoder needs to flip by itself
};

typedef NS_ENUM(NSInteger, MeariDeviceFloodCameraType) {
    MeariDeviceFloodCameraTypeNone, // not support FloodLight Camera
    MeariDeviceFloodCameraTypeNormal, // support FloodLight Camera
    MeariDeviceFloodCameraTypeLowPower,
    // LowPower FloodLight Camera
};

@interface MeariDeviceInfoCapabilityFunc : MeariBaseModel
// Voice intercom type
/** 语音对讲类型 */
@property (nonatomic, assign) MeariDeviceVoiceTalkType vtk;
// Face recognition
/** 人脸识别 */
@property (nonatomic, assign) NSInteger fcr;
//Decibel alarm
/** 分贝报警 */
@property (nonatomic, assign) NSInteger dcb;
//Motion Detection
/** 移动侦测 */
@property (nonatomic, assign) NSInteger md;
// PTZ
/** 云台 */
@property (nonatomic, assign) NSInteger ptz;
//Temperature Sensor
/** 温度传感器 */
@property (nonatomic, assign) NSInteger tmpr;
// Humidity Sensor
/** 湿度传感器 */
@property (nonatomic, assign) NSInteger hmd;
// Body detection
/** 人体侦测 */
@property (nonatomic, assign) NSInteger pir;
// Cloud storage
/** 云存储 */
@property (nonatomic, assign) NSInteger cst;
/** Signal strength*/
/** 信号强度*/
@property (nonatomic, assign) NSInteger nst;
/** Playback recording settings*/
/** 回放录像设置*/
@property (nonatomic, assign) NSInteger evs;
/** Battery lock*/
/** 电池锁*/
@property (nonatomic, assign) NSInteger btl;
/** Cloud Storage Switch*/
/** 云存储开关*/
@property (nonatomic, assign) NSInteger cse;
/** Day and night mode*/
/** 白天黑夜模式*/
@property (nonatomic, assign) NSInteger dnm;
/** Second generation cloud storage*/
/** 二代云存储*/
@property (nonatomic, assign) NSInteger cs2;
/** High standard definition*/
/** 高标清*/
@property (nonatomic, assign) MeariDeviceCapabilityVSTType vst;
/** Multi-rate setting*/
/** 多码率设置*/
@property (nonatomic, assign) NSInteger bps;
/** led light*/
/** led灯*/
@property (nonatomic, assign) NSInteger led;
/** onvif function*/
/** onvif功能*/
@property (nonatomic, assign) NSInteger svc;
/** onvif function*/
/** onvif新版本*/
@property (nonatomic, assign) NSInteger ovf;
/** Support bell type*/
/** 支持铃铛类型*/
@property (nonatomic, assign) NSInteger rng;
/** Lamp camera function */
/** 灯具摄像头功能 */
@property (nonatomic, assign) NSInteger flt;
/** Power Management*/
/** 功耗管理*/
@property (nonatomic, assign) NSInteger pwm;
/** sd card*/
/** sd卡*/
@property (nonatomic, assign) NSInteger sd;
/** version upgrade*/
/** 版本升级*/
@property (nonatomic, assign) NSInteger ota;
/** Host Message*/
/** 主人留言*/
@property (nonatomic, assign) NSInteger hms;
/** flip */
/** 翻转*/
@property (nonatomic, assign) NSInteger flp;
/** Shadow Agreement*/
/** 影子协议*/
@property (nonatomic, assign) NSInteger shd;
/** Door lock*/
/** 门锁*/
@property (nonatomic, assign) NSInteger dlk;
/** relay */
/** 继电器*/
@property (nonatomic, assign) NSInteger rel;
/** Open the door*/
/** 开门*/
@property (nonatomic, assign) NSInteger dor;
/** Turn on the light*/
/** 开灯*/
@property (nonatomic, assign) NSInteger lgt;
/** Sleep mode*/
/** 休眠模式*/
@property (nonatomic, assign) NSInteger slp;
/** Switch the main stream */
/** 切换主码流*/
@property (nonatomic, assign) NSInteger vec;
/** Cry Detect*/
/** 哭声检测*/
@property (nonatomic, assign) NSInteger bcd;
/** People Track*/
/** 人体跟踪*/
@property (nonatomic, assign) NSInteger ptr;
/** People Detect*/
/** 人形检测*/
@property (nonatomic, assign) NSInteger pdt;
/** Alarm plan*/
/** 报警计划*/
@property (nonatomic, assign) NSInteger alp;
/** Low power consumption*/
/** 低功耗 录像时长*/
@property (nonatomic, assign) NSInteger esd;
/** letter of agreement*/
/** 通信协议*/
@property (nonatomic, assign) NSInteger spp;
/** bright adjustment*/
/** 亮度调节*/
@property (nonatomic, assign) NSInteger ltl;
/** chromecast */
@property (nonatomic, assign) NSInteger cct;
/** echoshow*/
@property (nonatomic, assign) NSInteger ecs;
/** p2p version*/
/** p2p 版本*/
@property (nonatomic, assign) NSInteger p2p;
/** record enable */
/** 录像开关 */
@property (nonatomic, assign) NSInteger ren;
/** 音量调节*/
@property (nonatomic, assign) NSInteger ovc;
/** 区域报警*/
@property (nonatomic, assign) NSInteger roi;
/** 报警频率*/
@property (nonatomic, assign) NSInteger afq;
/** 人脸识别*/
@property (nonatomic, assign) NSInteger fcd;
// 16:9 还是 9:16
@property (nonatomic, assign) NSInteger crm;
/** 声光报警*/
@property (nonatomic, assign) NSInteger sla;
/** 时间风格设置*/
@property (nonatomic, assign) NSInteger ttp;
/** 音乐播放能力级*/
@property (nonatomic, assign) NSInteger mpc;
/** pir等级设置使能开关，，用于多级设置开关1-N档，0=不支持，10=支持10档（1-10）*/
@property (nonatomic, assign) NSInteger plv;
/** 视频能力级, 0=不支持， 1=支持 */
@property (nonatomic, assign) NSInteger vid;
/** 防拆报警*/
@property (nonatomic, assign) NSInteger fcb;
/** 新设备的分辨率 */
@property (nonatomic, strong) NSString *bps2;
/** 新增是否支持灯具摄像机的报警联动亮灯的能力级fld  0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger fld;
/** 噪声异常巡查  0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger dbc;
/** baby 上传用户预览信息  0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger uif;

@end


@interface MeariDeviceInfoCapability: MeariBaseModel
/** Protocol version number */
/** 协议版本号 */
@property (nonatomic, assign) NSInteger ver;
/** device type */
/** 设备类型 */
@property (nonatomic, copy) NSString *cat;
/** Supported features */
/** 支持的功能 */
@property (nonatomic, strong) MeariDeviceInfoCapabilityFunc *caps;
@end

#import "MeariDeviceParam.h"
@interface MeariDeviceInfo : MeariBaseModel
/** camera type */
/** 设备类型总类 */
@property (nonatomic, assign) MeariDeviceType type;
/** device sub type */
/** 设备类型子类 */
@property (nonatomic, assign) MeariDeviceSubType subType;
/** device add status */
/** 设备添加状态 */
@property (nonatomic, assign) MeariDeviceAddStatus addStatus;
/** Device auto-bind */
/** 设备自动绑定 */
@property (nonatomic, assign) BOOL autobind;
/** Wire device */
/** 是否为有线设备 */
@property (nonatomic, assign) BOOL wireDevice;
/** Wire device  ip*/
/** 有线设备配网IP */
@property (nonatomic, copy) NSString *wireConfigIp;
/** Device was added  */
/** 设备被添加过 */
@property (nonatomic, assign) BOOL hasAdd;

/**是否支持云存储 */
@property (nonatomic, assign) BOOL cloudSupport;

@property (nonatomic, assign) MeariDeviceLimitLevel limitLevel;
/** cloud storage State  */
/** 云存储状态  */
@property (nonatomic, assign) MeariDeviceCloudState cloudState;
/** device capability */
/** 设备能力级 */
@property (nonatomic, strong) MeariDeviceInfoCapability *capability;
/** device sleep mode */
/** 设备休眠模式 */
@property (nonatomic, assign) MeariDeviceSleepMode sleepMode;
/** 设备编号 */
/** device ID */
@property (nonatomic, assign) NSInteger ID;
/** 用户ID */
/** userID */
@property (nonatomic, assign) NSInteger userID;
/** tp */
@property (nonatomic, copy) NSString *tp;
/** device uuid */
@property (nonatomic, copy) NSString *uuid;
/** device sn */
@property (nonatomic, copy) NSString *sn;
/** p2p number */
/**  p2p信息 */
@property (nonatomic, copy) NSString *p2p;
/** p2pInit 字符串 */
/** p2pInit string */
@property (nonatomic, copy) NSString *p2pInit;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *connectName;
/** device nickname */
/** 设备昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 设备logo */
/** device logo */
@property (nonatomic, copy) NSString *iconUrl;
/** 灰色默认 */
/** gray icon */
@property (nonatomic, copy) NSString *grayIconUrl;
/** host message url */
/** 主人留言音频路径 */
@property (nonatomic, copy) NSString *bellVoice;
@property (nonatomic, copy) NSString *modelName;
/** nvr's key,user to connect nvr */
/** 设备绑定的nvr设备信息 */
@property (nonatomic, assign) NSInteger nvrPort;
/** nvr's ID */
@property (nonatomic, assign) NSInteger nvrID;
@property (nonatomic, assign) NSInteger devTypeID;
@property (nonatomic, copy) NSString *nvrKey;
@property (nonatomic, copy) NSString *nvrUUID;
@property (nonatomic, copy) NSString *nvrSn;

@property (nonatomic, copy) NSString *capabilityStr;
/** current device userAccount*/
/** 当前设备所属账号 */
@property (nonatomic, copy) NSString *userAccount;
@property (nonatomic, copy) NSString *produceAuth;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *wifiSsid;
@property (nonatomic, copy) NSString *wifiBssid;
/** 是否关闭推送 */
/** whether to close device push */
@property (nonatomic, assign) NSInteger closePush;
@property (nonatomic, assign) NSInteger protocolVersion;
//@property (nonatomic, assign) BOOL iotDevice;

/** chime's password add wifi name */
//中继设备的wifi名称和密码
@property (nonatomic, copy) NSString *wifiName;
@property (nonatomic, copy) NSString *wifiPwd;

@property (nonatomic, copy) NSString *relaySn;
/** whether is chime subdevice  */
/** 是否为relay的子设备 */
@property (nonatomic, assign) BOOL relaySubDevice;
 
@property (nonatomic, strong) NSString *region;


@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *radius;
/** AWS iot thingName */
@property (nonatomic, copy) NSString *awsThingName;
@property (nonatomic, assign) NSInteger iotType;
@property (nonatomic, assign) NSInteger cloudType;
@property (nonatomic, assign) NSInteger awsCloudCompat;

/** Whether device is shared by friends */
/** 是否来自好友分享 */
@property (nonatomic, assign) BOOL shared;
/** Whether friends has device set  authority */
/** 好友是否拥有分享设备设置权限 */
@property (nonatomic, assign) NSInteger shareAccessSign;
/** Whether there is a message from device  */
/** 是否有报警消息 */
@property (nonatomic, assign) BOOL hasMsg;
/** Whether device is online *//** tp */
/** 是否在线 */
@property (nonatomic, assign) BOOL online;
/** whether device need update */
/** 是否需要升级 */
@property (nonatomic, assign) BOOL needUpdate;
/** whether device need force Update */
/** 是否需要强制升级 */
@property (nonatomic, assign) BOOL needForceUpdate;

@end


