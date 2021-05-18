//
//  MeariMessageInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/14.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class MeariDevice;
typedef NS_ENUM(NSInteger, MeariSystemMessageType) {
    MeariSystemMessageTypeNone,
    MeariSystemMessageTypeFriendAdd,           // request add friend (请求添加好友)
    MeariSystemMessageTypeFriendAgree,         // agree add friend (同意添加好友)
    MeariSystemMessageTypeFriendRefuse,        // refuse add friend (拒绝添加好友)
    MeariSystemMessageTypeDeviceShare,         // request add device (请求分享设备)
    MeariSystemMessageTypeDeviceAgree,         // agree add device (同意分享设备)
    MeariSystemMessageTypeDeviceRefuse,        // refuse add device (拒绝分享设备)
    MeariSystemMessageTypeDeviceLowBattery,    // warning for bell's low power (门铃低电量提示)
    MeariSystemMessageTypeDeviceWeakSignal,    // warning for weak network signla (设备网络信号不好)
    MeariSystemMessageTypeDeviceAlarmFrequent,  // warning for alarm frequent (设备报警频繁)
    MeariSystemMessageTypeDeviceAlarmUseless,  // warning for alarm useless (设备报警误报)
};

typedef NS_ENUM(NSInteger, MeariAlarmMessageType) {
    MeariAlarmMessageTypeNone,
    MeariAlarmMessageTypeMotion = 1,               // motion alarm, alarm when device detect something has been moved (移动侦测报警)
    MeariAlarmMessageTypePir = 2,                  // pir alarm, alarm when device detect moved things in night mode (红外侦测报警)
    MeariAlarmMessageTypeVisitor = 3,              // visitor alarm, available on bell device, alarm when somebody tap the ring.(访客报警)
    MeariAlarmMessageTypeNoise = 6,                // Noise alarm (噪声报警 )
    MeariAlarmMessageTypeCry = 7,                   // Cry alarm (哭声报警)
    MeariAlarmMessageTypeFace = 8 ,                 // face alarm (人脸报警)
    MeariAlarmMessageTypeSomeoneCall = 9,           // visitor alarm, available on ipc device, alarm when somebody tap the ring.(有人来访)
    MeariAlarmMessageTypeTear = 10,                  //Tear device alarm (强行拆除报警)
    MeariAlarmMessageTypeHuman = 11                  //Person detected (人形过滤检测到人)
};

typedef NS_ENUM(NSInteger, MeariVisitorMessageType) {
    MeariVisitorMessageTypeNone,
    MeariVisitorMessageTypeReceiveCall ,       // Answering visitor messages (已接听的访客消息)
    MeariVisitorMessageTypeRejectCall ,        // Reject visitor messages (拒绝接听的访客消息)
    MeariVisitorMessageTypeUnreadMessage ,     // Unread visitor message (未读的访客消息)
    MeariVisitorMessageTypeHasReadMessage      // Has read visitor message (已读的访客消息)
};

typedef NS_ENUM(NSInteger, MeariShareMessageType) {
    MeariShareMessageTypeReject,  // Reject 拒绝
    MeariShareMessageTypeAcctpt,  // Acctpt 接受
    MeariShareMessageTypeRequestToYou, // Request message: xxx request to share his device: xxx to you (请求消息: xxx 请求分享他的设备：xxx 给你)
    MeariShareMessageTypeRequestToHim, // Request message: xxx Request to share your device: xxx to him (请求消息: xxx 请求分享你的设备：xxx 给他)
};

@interface MeariMessageInfo : MeariBaseModel
@end


@interface MeariMessageInfoSystem : MeariMessageInfo
@property (nonatomic, assign)MeariSystemMessageType msgType;  // message type (消息类型)
@property (nonatomic, assign)NSInteger msgID;          // message id (消息ID)
@property (nonatomic, assign)NSInteger deviceID;       // device id (设备ID)
@property (nonatomic, copy)NSString *deviceName;       // device name (设备名称)
@property (nonatomic, copy)NSString *deviceUUID;       // device uuid (设备UUID)
@property (nonatomic, assign)NSInteger friendID;       // friend id (好友ID)
@property (nonatomic, copy)NSString *friendAccount;    // friend account (好友账号)
@property (nonatomic, copy)NSString *friendNickname;   // friend nickname (好友昵称)
@property (nonatomic, copy)NSString *friendAvatarUrl;  // friend avatar (好友头像)
@end

@interface MeariMessageInfoAlarm : MeariMessageInfo
@property (nonatomic, assign) NSInteger deviceID;       // device id (设备ID)
@property (nonatomic, copy) NSString *deviceName;       // device name (设备名称)
@property (nonatomic, copy) NSString *deviceSn;         // device sn (设备sn号)
@property (nonatomic, copy) NSString *deviceUUID;       // device uuid (设备UUID)
@property (nonatomic, copy) NSString *deviceIconUrl;    // device icon (设备缩略图)
@property (nonatomic, assign) BOOL hasMsg;              // whether has alarm message or not (是否有消息)
@end

@interface MeariMessageInfoAlarmDevice : MeariMessageInfo
@property (nonatomic, assign)MeariAlarmMessageType msgType;  // message type (消息类型)
@property (nonatomic, assign) NSInteger deviceID;       // device id (设备ID)
@property (nonatomic, copy) NSString *alarmTime;        // device alarm time (设备报警时间)
@property (nonatomic, copy) NSString *alarmThumbImage;  // device alarm thumb image (缩略图)
@property (nonatomic, copy) NSArray <NSString*> *alarmImages; // device alarm images (设备报警图片)
@property (nonatomic, assign) BOOL isRead;              // message is whether readed or not (是否已读)
@property (nonatomic, assign)NSInteger msgID;           // message id (消息ID)
@property (nonatomic, assign) NSInteger decibel;        // Noise decibel (0-100) (噪声分贝(db))
@property (nonatomic, assign) NSInteger state;        // whether to use OSS (是否使用oss)
@property (nonatomic, copy) NSString *faceName;        // face name (设备报警时间)
@property (nonatomic, assign) NSInteger cloudType;     //cloud storage Type(AliOSS or AWSS3)
@property (nonatomic, assign) NSInteger iotType;        // iot Type(Ali iOT or AWS iOT)
@property (nonatomic, copy) NSString *day;      //alarm dat(报警日期，如:"20200804")

/**
 userID/ownerID：
 Description:
 When the device belongs to the current user, the ownerID is the id of the current user, and the userID is 0.
 When the device is shared, the ownerID is the id of the device owner, and the userID is the current user id.

 描述: 当设备属于当前用户时，ownerID是当前用户的id,userID为0. 当设备是被分享过来的时候，ownerID是设备主人的id,userID是当前用户id.
 */
@property (nonatomic, assign)NSInteger userID; //user id (用户ID)
@property (nonatomic, assign)NSInteger ownerID; // //owner id (设备所有人ID)

@end

@interface MeariMessageInfoVisitor : MeariMessageInfo
@property (nonatomic, copy) NSNumber *createDate;
@property (nonatomic, copy) NSNumber *voiceDuration;    // Guest message duration (客人留言时长)
@property (nonatomic, copy) NSString *voiceUrl;         // Guest address (客人留言地址)
@property (nonatomic, assign)MeariVisitorMessageType msgType;  // Message type (消息类型)
@property (nonatomic, assign)BOOL isRead;              // whether read (是否已读)
@property (nonatomic, assign)NSInteger msgID;           // Message ID (消息ID)
@property (nonatomic, assign)NSInteger userID;          // User ID (用户ID)
@property (nonatomic, assign)NSInteger deviceID;       // Device ID (设备ID)
@end

@interface MeariMessageInfoShare : MeariBaseModel
@property (nonatomic,   copy) NSString *shareAccount; // share account (账号)
@property (nonatomic,   copy) NSString *shareName;  // share name (用户昵称)
@property (nonatomic,   copy) NSString *deviceName;  // device name (设备昵称)
@property (nonatomic,   copy) NSString *date; // request time (请求的时间)
@property (nonatomic,   copy) NSString *msgID; // message ID (消息ID)
@property (nonatomic, assign) NSInteger deviceID;  // Device ID (设备ID)
@property (nonatomic, assign) MeariShareMessageType msgType;  // Message type (消息类型)

@end
