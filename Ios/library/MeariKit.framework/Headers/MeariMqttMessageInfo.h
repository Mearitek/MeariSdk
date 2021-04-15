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
 Message Type
 消息类型
 
 - MeariMqttCodeTypeDeviceOnline:                The device is online (设备上线)
 - MeariMqttCodeTypeDeviceOffline:               Device offline (设备离线)
 - MeariMqttCodeTypeCancelDeviceShare:           Device cancel share (设备被取消分享)
 - MeariMqttCodeTypeAcountTokenInvalid:          User token invalid (登录信息失效)
 - MeariMqttCodeTypeVisitorCall:                 Visitor call (设备有访客)
 - MeariMqttCodeTypeHasBeenAnswerCall: answer has been (电话已经被接听)
 - MeariMqttCodeTypeDeviceUnbundling:            Device unbind (设备解绑)
 - MeariMqttCodeTypeDeviceAutobundleSuccess:     Automatic binding succeeded (自动绑定成功)
 - MeariMqttCodeTypeDeviceAutobundleFailure:     Automatic binding failed (自动绑定失败)
 - MeariMqttCodeTypeDeviceAutobundleByOtherFailure: device has been added by other(设备已经被绑定， 强绑定模式下)
 - MeariMqttCodeTypeDeviceShare:                 Receive the device share (收到别人的设备分享)
 - MeariMqttCodeTypeDeviceUpgradeFormat:         Firmware upgrade progress (固件升级进度)
 - MeariMqttCodeTypeNotice:                            app reveive a notice message
 - MeariMqttCodeTypeSDCardFormat:                Sd card formatting progress (sd卡格式化进度)
 - MeariMqttCodeTypePropertyRefresh:             Get a property status in real time (实时获取某个属性状态 一发一答形式)
 */
typedef NS_ENUM(NSInteger, MeariMqttCodeType) {
    MeariMqttCodeTypeDeviceOnline               = 101,
    MeariMqttCodeTypeDeviceOffline              = 102,
    MeariMqttCodeTypeCancelDeviceShare          = 103,
    MeariMqttCodeTypeAcountTokenInvalid         = 104,
    MeariMqttCodeTypeVisitorCall                = 111,
    MeariMqttCodeTypeVoiceCall                  = 134,
    MeariMqttCodeTypeDeviceUnbundling           = 140,
    MeariMqttCodeTypeDeviceAutobundleSuccess    = 170,
    MeariMqttCodeTypeDeviceAutobundleFailure    = 171,
    MeariMqttCodeTypeDeviceAutobundleByOtherFailure = 172,
    MeariMqttCodeTypeDeviceAutobundleOverLimit  = 173,
    MeariMqttCodeTypeDeviceShare                = 180,
    MeariMqttCodeTypeNewDeviceShareToMeRequest  = 181,
    MeariMqttCodeTypeNewDeviceShareToHimRequest = 182,
    MeariMqttCodeTypeHasBeenAnswerCall          = 188,
    MeariMqttCodeTypeNotice                     = 200,
    MeariMqttCodeTypeSomebodyCall               = 201,
    MeariMqttCodeTypeDeviceUpgradeFormat        = 803,
    MeariMqttCodeTypeSDCardFormat               = 806,
    MeariMqttCodeTypePropertyRefresh            = 809,
};

@interface MeariMqttMessageInfoDevice : MeariBaseModel
@property (assign, nonatomic) BOOL online;   // Whether the device is online (设备在线状态)
@property (assign, nonatomic) NSInteger deviceID;   // device ID (设备ID)
@property (nonatomic, assign) MeariDeviceType devType; // Large type (总类）
@property (nonatomic, assign) MeariDeviceSubType devSubType; // Subtype (子类)
@property (copy, nonatomic) NSString *deviceType;   // Device type (设备类型)
@property (copy, nonatomic) NSString *deviceName;   // Device nickname (设备昵称)
@property (copy, nonatomic) NSString *msgID;        // Message ID (消息ID)
@property (assign, nonatomic) NSInteger devTypeID;  //设备类型ID
@property (copy, nonatomic) NSString *hostKey;      // device token (设备token)
@property (copy, nonatomic) NSString *deviceUUID;   // device uuid (设备uuid)
@property (copy, nonatomic) NSString *imgUrl;       // Device icon (设备图标)
@property (copy, nonatomic) NSString *bellVoice;    // Device doorbell (设备门铃)
@property (copy, nonatomic) NSString *p2pInit;
@property (copy, nonatomic) NSString *deviceP2P;
@property (nonatomic, assign) MeariDeviceAddStatus  addStatus;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *grayIconUrl;
@property (nonatomic, strong) NSString *capabilityStr;
@property (nonatomic, strong) MeariDeviceInfoCapability *capability;
@property (nonatomic, strong) NSString *tp;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, assign) NSInteger protocolVersion;
@property (nonatomic, assign) BOOL iotDevice;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) BOOL relaySubDevice;
@property (nonatomic, assign) BOOL relayDevice;
@property (nonatomic, strong) NSString *relayLicenseID;
@property (nonatomic, strong) NSString *faceName;
@property (nonatomic, copy) NSString *content; // notice content (公告内容)
@property (nonatomic, assign) NSInteger startTime; // notice begin time(公告开始时间)
@property (nonatomic, assign) NSInteger endTime; // notice end time(公告结束时间)
@property (nonatomic, assign) NSInteger noticeID; // notice end time(公告结束时间)
@end

@interface MeariEventInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger sdTotalPercent;           // Format percentage (格式化百分比)
@property (nonatomic, assign) NSInteger upgradeTotalPercent;      // Upgrade firmware percentage (升级固件百分比)
@property (nonatomic, assign) NSInteger upgradeDownloadPercent;   // Upgrade package download percentage (升级包下载百分比)
@property (nonatomic, assign) NSInteger upgradeUploadPercent;     // Upgrade package upload percentage (升级包上传百分比)
@property (nonatomic, assign) NSInteger wifiStrength;             // Wi-Fi signal strength (Wi-Fi信号强度)
@property (nonatomic, assign) NSInteger temperature;              // 温度
@property (nonatomic, assign) NSInteger humidity;                 // 湿度
@property (nonatomic, strong) MeariDeviceParamStorage *sdcard;    // sd卡
@property (nonatomic, assign) BOOL      floodCameraStatus;        // 灯具摄像机开关状态
@property (nonatomic, assign) NSInteger sirenTimeout;             // 警报倒计时
@property (nonatomic, assign) NSDictionary *musicStateDic;        // 音乐下载进度
@property (nonatomic,   copy) NSString  *lisenceID;               // 

// 扩展
@property (nonatomic, assign, readonly) BOOL hasWifiStrength;             // 是否存在Wi-Fi信号强度
@property (nonatomic, assign, readonly) BOOL hasTempAndHumidity;          // 是否存在温度
@property (nonatomic, assign, readonly) BOOL hasFloodCameraStatus;        // 是否存在灯具摄像机开关状态
@property (nonatomic, assign, readonly) BOOL hasChangeSd;                 // 是否sd卡状态改变
@property (nonatomic, assign, readonly) BOOL hasFloodCameraSirenTimeout;  // 是否灯具警报倒计时
@property (nonatomic, assign, readonly) BOOL isBindToChime;               // 是否绑定上了中继设备
@property (nonatomic, assign, readonly) BOOL hasMusicStatus;               // 是否音乐播放回调了数据


- (instancetype)initWithDic:(NSDictionary *)dic; // 初始化

@end

@interface MeariMqttMessageInfo : MeariBaseModel
@property (assign, nonatomic) double t;              // timestamp (时间戳)
@property (strong, nonatomic) MeariMqttMessageInfoDevice *data;
@property (assign, nonatomic) NSInteger msgid;          // Message ID (消息ID)
@property (nonatomic, assign) MeariMqttCodeType type;   // Message type (消息类型)
@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, assign) NSInteger iotType;
@property (nonatomic, copy) MeariEventInfo *eventInfo; //Service incident reporting (服务事件上报)

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) double answerTime;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, copy) NSString *shareMsgID;
@property (nonatomic, copy) NSString *shareName;

@end


