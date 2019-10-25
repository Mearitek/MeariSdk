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
};
typedef NS_ENUM(NSInteger, MeariDeviceSubType) {
    MeariDeviceSubTypeNVR = 0,
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,
    MeariDeviceSubTypeIpcVoiceBell = 5,
    MeariDeviceSubTypeIpcFloodlight = 6,
};

typedef NS_ENUM(NSInteger, MeariDeviceAddStatus) {
    MeariDeviceAddStatusSelf = 1,
    MeariDeviceAddStatusUnShare,
    MeariDeviceAddStatusNone,
    MeariDeviceAddStatusShared,
    MeariDeviceAddStatusSharing,
    MeariDeviceAddStatusFailure
};
typedef NS_ENUM(NSInteger, MeariDeviceLimitLevel) {
    MeariDeviceLimitLevelNone,
    MeariDeviceLimitLevelForbidden,
};
typedef NS_ENUM(NSInteger, MeariDeviceVoiceTalkType) {//设备语音对讲类型
    MeariDeviceVoiceTalkTypeNone         = 0,    //没有扬声器和麦克
    MeariDeviceVoiceTalkTypeSpeekerOnly  = 1,    //仅有扬声器
    MeariDeviceVoiceTalkTypeMicOnly      = 2,    //仅有麦克
    MeariDeviceVoiceTalkTypeHalfDuplex   = 3,    //半双工
    MeariDeviceVoiceTalkTypeFullDuplex   = 4,    //全双工
};
typedef NS_ENUM(NSInteger, MeariDeviceCapabilityVSTType) {
    MeariDeviceCapabilityVSTTypeNormal       = 0,    //h_264高清/标清
    MeariDeviceCapabilityVSTTypeOnlyHD       = 1     //h_264高清
};
typedef NS_ENUM (NSUInteger, MeariDeviceSupportBellType) {
    MeariDeviceSupportBellTypeWireless,       //默认支持无线铃铛
    MeariDeviceSupportBellTypeMachinery = 0b1,//机械铃铛
    MeariDeviceSupportBellTypeWirelessBell = 0b10,//无线铃铛
    MeariDeviceSupportBellTypeWirelessEnable = 0b10000000,//无线使能
};
typedef NS_ENUM (NSUInteger, MeariDeviceLocalServerType) {
    MeariDeviceLocalServerTypeChangePSW = 0b1,    //支持密码修改
    MeariDeviceLocalServerTypeOnvif     = 0b10,   //支持Onvif
};
typedef NS_OPTIONS(NSUInteger, MeariDevicePeopleDetect) {
    MeariDevicePeopleDetectEnable = 0b1, // 人形检测开关设置
    MeariDevicePeopleDetectBnddraw = 0b10, // 画框开关设置
};
typedef NS_ENUM (NSUInteger, MeariDeviceDayNightType) {
    MeariDeviceDayNightTypeAuto,
    MeariDeviceDayNightTypeDay,
    MeariDeviceDayNightTypeNight
};
typedef NS_ENUM(NSInteger, MeariDeviceTokenType) {
    MeariDeviceTokenTypeSmartWifi,
    MeariDeviceTokenTypeAP,
    MeariDeviceTokenTypeQRCode
};

typedef NS_ENUM (NSInteger, MeariDeviceCloudState) {
    MeariDeviceCloudStateCloseCanTry = 0,      //未开通可试用
    MeariDeviceCloudStateCloseNotTry,          //未开通不可试用
    MeariDeviceCloudStateOpenNotOverDue,       //已开通
    MeariDeviceCloudStateOpenOverDue           //已过期
};

typedef NS_ENUM (NSInteger, MeariDevicePirSensitivity) {
    MeariDevicePirSensitivityNone = 0, // 不支持
    MeariDevicePirSensitivityAll = 1, // 支持PIR使能开关+设置选项(高中低)
    MeariDevicePirSensitivityOnlySwitch = 2,//只支持PIR的使能开关
    MeariDevicePirSensitivitySwitchAndHighLow= 4,//支持PIR使能开关+设置选项(高低)
};

@interface MeariDeviceInfoCapabilityFunc : MeariBaseModel
/** 语音对讲类型 */
@property (nonatomic, assign) MeariDeviceVoiceTalkType vtk;
/** 人脸识别 */
@property (nonatomic, assign) NSInteger fcr;
/** 分贝报警 */
@property (nonatomic, assign) NSInteger dcb;
/** 移动侦测 */
@property (nonatomic, assign) NSInteger md;
/** 云台 */
@property (nonatomic, assign) NSInteger ptz;
/** 温度传感器 */
@property (nonatomic, assign) NSInteger tmpr;
/** 湿度传感器 */
@property (nonatomic, assign) NSInteger hmd;
/** 人体侦测 */
@property (nonatomic, assign) NSInteger pir;
/** 云存储 */
@property (nonatomic, assign) NSInteger cst;
/** 信号强度*/
@property (nonatomic, assign) NSInteger nst;
/** 回放录像设置*/
@property (nonatomic, assign) NSInteger evs;
/** 电池锁*/
@property (nonatomic, assign) NSInteger btl;
/** 云存储开关*/
@property (nonatomic, assign) NSInteger cse;
/** 白天黑夜模式*/
@property (nonatomic, assign) NSInteger dnm;
/** 二代云存储*/
@property (nonatomic, assign) NSInteger cs2;
/** 高标清*/
@property (nonatomic, assign) MeariDeviceCapabilityVSTType vst;
/** 多码率设置*/
@property (nonatomic, assign) NSInteger bps;
/** led灯*/
@property (nonatomic, assign) NSInteger led;
/** onvif功能*/
@property (nonatomic, assign) NSInteger svc;
/** 支持铃铛类型*/
@property (nonatomic, assign) NSInteger rng;
/** 灯具摄像头功能 */
@property (nonatomic, assign) NSInteger flt;
/** 功耗管理*/
@property (nonatomic, assign) NSInteger pwm;
/** sd卡*/
@property (nonatomic, assign) NSInteger sd;
/** 版本升级*/
@property (nonatomic, assign) NSInteger ota;
/** 主人留言*/
@property (nonatomic, assign) NSInteger hms;
/** 翻转*/
@property (nonatomic, assign) NSInteger flp;
/** 影子协议*/
@property (nonatomic, assign) NSInteger shd;
/** 门锁*/
@property (nonatomic, assign) NSInteger dlk;
/** 继电器*/
@property (nonatomic, assign) NSInteger rel;
/** 开门*/
@property (nonatomic, assign) NSInteger dor;
/** 开灯*/
@property (nonatomic, assign) NSInteger lgt;
/** 休眠模式*/
@property (nonatomic, assign) NSInteger slp;
/** 切换主码流*/
@property (nonatomic, assign) NSInteger vec;
/** 哭声检测*/
@property (nonatomic, assign) NSInteger bcd;
/** 人体跟踪*/
@property (nonatomic, assign) NSInteger ptr;
/** 人形检测*/
@property (nonatomic, assign) NSInteger pdt;
@end


@interface MeariDeviceInfoCapability: MeariBaseModel
/** 协议版本号 */
@property (nonatomic, assign) NSInteger ver;
/** 设备类型 */
@property (nonatomic, copy) NSString *cat;
/** 支持的功能 */
@property (nonatomic, strong) MeariDeviceInfoCapabilityFunc *caps;
@end

#import "MeariDeviceParam.h"
@interface MeariDeviceInfo : MeariBaseModel
/** 设备类型总类 */
@property (nonatomic, assign) MeariDeviceType type;
/** 设备类型子类 */
@property (nonatomic, assign) MeariDeviceSubType subType;
/** 设备添加状态 */
@property (nonatomic, assign) MeariDeviceAddStatus addStatus;
/** 设备自动绑定 */
@property (nonatomic, assign) BOOL autobind;

/** 设备被添加过 */
@property (nonatomic, assign) BOOL hasAdd;

@property (nonatomic, assign) MeariDeviceLimitLevel limitLevel;
@property (nonatomic, assign) MeariDeviceCloudState cloudState;
@property (nonatomic, strong) MeariDeviceInfoCapability *capability;
@property (nonatomic, assign) MeariDeviceSleepmode sleepmode;
/** 设备编号 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *tp;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *sn;
/**  p2p信息 */
@property (nonatomic, copy) NSString *p2p;
@property (nonatomic, copy) NSString *p2pInit;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *connectName;
/** 设备昵称 */
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *grayIconUrl;
/** 主人留言音频路径 */
@property (nonatomic, copy) NSString *bellVoice;
@property (nonatomic, copy) NSString *modelName;
/** 设备绑定的nvr设备信息 */
@property (nonatomic, assign) NSInteger nvrPort;
@property (nonatomic, assign) NSInteger nvrID;
@property (nonatomic, copy) NSString *nvrKey;
@property (nonatomic, copy) NSString *nvrUUID;
@property (nonatomic, copy) NSString *nvrSn;
/** 其他 */
@property (nonatomic, copy) NSString *capabilityStr;
@property (nonatomic, copy) NSString *userAccount;
@property (nonatomic, copy) NSString *produceAuth;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *wifiSsid;
@property (nonatomic, copy) NSString *wifiBssid;
@property (nonatomic, assign) NSInteger closePush;
@property (nonatomic, assign) NSInteger protocolVersion;
@property (nonatomic, assign) BOOL iotDevice;

/** 地区 */
@property (nonatomic, strong) NSString *region;


@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *radius;

/** 是否来自好友分享 */
@property (nonatomic, assign) BOOL shared;
/** 是否有报警消息 */
@property (nonatomic, assign) BOOL hasMsg;
/** 是否在线 */
@property (nonatomic, assign) BOOL online;
/** 是否需要升级 */
@property (nonatomic, assign) BOOL needUpdate;
/** 是否需要强制升级 */
@property (nonatomic, assign) BOOL needForceUpdate;

@end


