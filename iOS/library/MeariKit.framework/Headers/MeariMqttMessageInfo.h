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
 
 - MeariMqttCodeTypeFamilyRefresh:     family info update (家庭信息更新)
 - MeariMqttCodeTypeMemberAdd:  member add (家庭成员新增)
 - MeariMqttCodeTypeInviteYouToHisFamily:  someone would like invite you to his family(xxx邀请你加入他的房间)
 - MeariMqttCodeTypeInviteJoinFamilySuccess:  invite other to you family success (邀请其他人加入你的的家庭成功)
 - MeariMqttCodeTypeJoinYourFamilyRequest: someone would like join your family (xxx 想要加入你的家庭)
 - MeariMqttCodeTypeJoinOtherFamilySuccess: you join other user family success (你加入别人的家庭成功)
 - MeariMqttCodeTypeFamilyInfoUpdate: family info update (name posistion) (家庭信息更新)
 - MeariMqttCodeTypeFamilyRoomAddUpdate: family room add or update info (家庭房间新增或 更新名称)
 - MeariMqttCodeTypeFamilyMemberInfoUpdate: family member name update  (家庭成员名称修改)
 - MeariMqttCodeTypeFamilyDelete: family delete (家庭删除)
 - MeariMqttCodeTypeFamilyRoomDelete: family room delete (家庭房间删除)
 - MeariMqttCodeTypeFamilyRoomDeviceDelete:  family room device delete ( 家庭房间设备删除)
 - MeariMqttCodeTypeFamilyMemberDelete: you join other user family success (家庭成员删除)
 
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
    
    MeariMqttCodeTypeFamilyRefresh              = 210,
    MeariMqttCodeTypeMemberAdd                  = 211,
    MeariMqttCodeTypeInviteYouToHisFamily       = 212,
    MeariMqttCodeTypeInviteJoinFamilySuccess    = 213,
    MeariMqttCodeTypeJoinYourFamilyRequest      = 215,
    MeariMqttCodeTypeJoinOtherFamilySuccess     = 216,
    MeariMqttCodeTypeFamilyInfoUpdate           = 218,
    MeariMqttCodeTypeFamilyRoomAddUpdate        = 219,
    MeariMqttCodeTypeFamilyMemberInfoUpdate     = 220,
    MeariMqttCodeTypeFamilyDelete               = 221,
    MeariMqttCodeTypeFamilyRoomDelete           = 222,
    MeariMqttCodeTypeFamilyRoomDeviceDelete     = 223,
    MeariMqttCodeTypeFamilyMemberDelete         = 224,
    
    MeariMqttCodeTypeFeedBackMsgRemind          = 225,
    MeariMqttCodeTypeClientServerMsgRemind      = 226,
    
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
@property (nonatomic, copy) NSString *appProtocolVer; // notice end time(公告最低支持协议版本)
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
@property (assign, nonatomic) NSInteger msgid;          // mqtt Message ID (消息ID)
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

@property (nonatomic, copy) NSString *deviceTypeName; // device image 设备图片
@property (nonatomic, copy) NSString *homeID;
@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSString *homePosition;
@property (nonatomic, copy) NSString *homeNameList;
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *roomIDList;
@property (nonatomic, copy) NSString *deviceIDList;
@property (nonatomic, copy) NSString *memberID;
@property (nonatomic, copy) NSString *memberName;
@property (nonatomic, copy) NSString *msgIDList; // family share msgid list
@property (nonatomic, copy) NSString *msgID; // family share msgid

@property (nonatomic, assign) NSInteger iotSignID;
@property (nonatomic, copy) NSString *pfCompatID;

@property (nonatomic, copy) NSString *leaveTopic;
@property (nonatomic, copy) NSString *snNum;

@property (nonatomic, copy) NSString *workOrderNo;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, assign) NSInteger cloudType;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *tp;

@end


