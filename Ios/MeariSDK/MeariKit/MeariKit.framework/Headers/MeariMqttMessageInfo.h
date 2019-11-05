//
//  MeariMqttMessageInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/18.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeariDeviceInfo.h"
/**
 消息类型

 - MeariMqttCodeTypeDeviceOnline:                设备上线
 - MeariMqttCodeTypeDeviceOffline:               设备离线
 - MeariMqttCodeTypeCancelDeviceShare:           设备被取消分享
 - MeariMqttCodeTypeAcountTokenInvalid:          登录信息失效
 - MeariMqttCodeTypeVisitorCall:                 设备有访客
 - MeariMqttCodeTypeDeviceUnbundling:            设备解绑
 - MeariMqttCodeTypeDeviceAutobundleSuccess:     自动绑定成功
 - MeariMqttCodeTypeDeviceAutobundleFailure:     自动绑定失败
 - MeariMqttCodeTypeDeviceShare:                 收到别人的设备分享
 - MeariMqttCodeTypeDeviceUpgradeFormat:         固件升级进度
 - MeariMqttCodeTypeSDCardFormat:                sd卡格式化进度
 - MeariMqttCodeTypePropertyRefresh:             实时获取某个属性状态 一发一答形式
 */
typedef NS_ENUM(NSInteger, MeariMqttCodeType) {
    MeariMqttCodeTypeDeviceOnline            = 101,
    MeariMqttCodeTypeDeviceOffline           = 102,
    MeariMqttCodeTypeCancelDeviceShare       = 103,
    MeariMqttCodeTypeAcountTokenInvalid      = 104,
    MeariMqttCodeTypeVisitorCall             = 111,
    MeariMqttCodeTypeVoiceCall               = 134,
    MeariMqttCodeTypeDeviceUnbundling        = 140,
    MeariMqttCodeTypeDeviceAutobundleSuccess = 170,
    MeariMqttCodeTypeDeviceAutobundleFailure = 171,
    MeariMqttCodeTypeDeviceShare             = 180,
    MeariMqttCodeTypeDeviceUpgradeFormat     = 803,
    MeariMqttCodeTypeSDCardFormat            = 806,
    MeariMqttCodeTypePropertyRefresh         = 809,
};

@interface MeariMqttMessageInfoDevice : MeariBaseModel
@property (assign, nonatomic) BOOL online;   //设备在线状态
@property (assign, nonatomic) NSInteger deviceID;   //设备ID
@property (nonatomic, assign) MeariDeviceType devType;
@property (nonatomic, assign) MeariDeviceSubType devSubType;
@property (copy, nonatomic) NSString *deviceType;   //设备类型
@property (copy, nonatomic) NSString *deviceName;   //设备昵称
@property (copy, nonatomic) NSString *msgID;        //消息ID
@property (copy, nonatomic) NSString *hostKey;      //设备token
@property (copy, nonatomic) NSString *deviceUUID;   //设备uuid
@property (copy, nonatomic) NSString *imgUrl;       //设备图标
@property (copy, nonatomic) NSString *bellVoice;    //设备门铃
@property (copy, nonatomic) NSString *p2pInit;
@property (copy, nonatomic) NSString *deviceP2P;
@property (nonatomic, assign) MeariDeviceAddStatus  addStatus;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *grayIconUrl;
@property (nonatomic, strong) NSString *capabilityStr;
@property (nonatomic, strong) NSString *tp;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *version;
@end

@interface MeariEventInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger sdTotalPercent;           // 格式化百分比
@property (nonatomic, assign) NSInteger upgradeTotalPercent;      // 升级固件百分比
@property (nonatomic, assign) NSInteger upgradeDownloadPercent;   // 升级包下载百分比
@property (nonatomic, assign) NSInteger upgradeUploadPercent;     // 升级包上传百分比
@property (nonatomic, assign) NSInteger wifiStrength;             // Wi-Fi信号强度
@property (nonatomic, assign) NSInteger temperature;              // 温度
@property (nonatomic, assign) NSInteger humidity;                 // 湿度
@property (nonatomic, strong) MeariDeviceParamStorage *sdcard;    // sd卡
@property (nonatomic, assign) BOOL      floodCameraStatus;        // 灯具摄像机开关状态

// 扩展
@property (nonatomic, assign) BOOL hasWifiStrength;             // 是否存在Wi-Fi信号强度
@property (nonatomic, assign) BOOL hasTempAndHumidity;          // 是否存在温度
@property (nonatomic, assign) BOOL hasFloodCameraStatus;        // 是否存在灯具摄像机开关状态
@property (nonatomic, assign) BOOL hasChangeSd;                 // 是否sd卡状态改变


- (instancetype)initWithDic:(NSDictionary *)dic; // 初始化

@end

@interface MeariMqttMessageInfo : MeariBaseModel
@property (assign, nonatomic) double t;              //时间戳
@property (strong, nonatomic) MeariMqttMessageInfoDevice *data;
@property (assign, nonatomic) NSInteger msgid;          //消息ID
@property (nonatomic, assign) MeariMqttCodeType type;   //消息类型
@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, copy) MeariEventInfo *eventInfo; //服务事件上报

@end


