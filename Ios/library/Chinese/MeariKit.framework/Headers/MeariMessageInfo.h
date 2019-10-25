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
    MeariSystemMessageTypeFriendAdd,           //请求添加好友
    MeariSystemMessageTypeFriendAgree,         //同意添加好友
    MeariSystemMessageTypeFriendRefuse,        //拒绝添加好友
    MeariSystemMessageTypeDeviceShare,         //请求分享设备
    MeariSystemMessageTypeDeviceAgree,         //同意分享设备
    MeariSystemMessageTypeDeviceRefuse,        //拒绝分享设备
    MeariSystemMessageTypeDeviceLowBattery     //门铃低电量提示
};

typedef NS_ENUM(NSInteger, MeariAlarmMessageType) {
    MeariAlarmMessageTypeNone,
    MeariAlarmMessageTypeMotion = 1,               //移动侦测报警
    MeariAlarmMessageTypePir = 2,                  //红外侦测报警
    MeariAlarmMessageTypeVisitor = 3,              //访客报警
    MeariAlarmMessageTypeNoise = 6,                //噪声报警
    MeariAlarmMessageTypeCry = 7                   //哭声报警
};

typedef NS_ENUM(NSInteger, MeariVisitorMessageType) {
    MeariVisitorMessageTypeNone,
    MeariVisitorMessageTypeReceiveCall ,
    MeariVisitorMessageTypeRejectCall ,
    MeariVisitorMessageTypeUnreadMessage ,
    MeariVisitorMessageTypeHasReadMessage
};

@interface MeariMessageInfo : MeariBaseModel
@end


@interface MeariMessageInfoSystem : MeariMessageInfo
@property (nonatomic, assign)MeariSystemMessageType msgType;  //消息类型
@property (nonatomic, assign)NSInteger msgID;          //消息ID
@property (nonatomic, assign)NSInteger deviceID;       //设备ID
@property (nonatomic, copy)NSString *deviceName;       //设备名称
@property (nonatomic, copy)NSString *deviceUUID;       //设备UUID
@property (nonatomic, assign)NSInteger friendID;       //好友ID
@property (nonatomic, copy)NSString *friendAccount;    //好友账号
@property (nonatomic, copy)NSString *friendNickname;   //好友昵称
@property (nonatomic, copy)NSString *friendAvatarUrl;  //好友头像
@end

@interface MeariMessageInfoAlarm : MeariMessageInfo
@property (nonatomic, assign) NSInteger deviceID;       //设备ID
@property (nonatomic, copy) NSString *deviceName;       //设备名称
@property (nonatomic, copy) NSString *deviceSn;         //设备sn号
@property (nonatomic, copy) NSString *deviceUUID;       //设备UUID
@property (nonatomic, copy) NSString *deviceIconUrl;    //设备缩略图
@property (nonatomic, assign) BOOL hasMsg;              //是否有消息
@end

@interface MeariMessageInfoAlarmDevice : MeariMessageInfo
@property (nonatomic, assign)MeariAlarmMessageType msgType;  //消息类型
@property (nonatomic, assign) NSInteger deviceID;       //设备ID
@property (nonatomic, copy) NSString *alarmTime;        //设备报警时间
@property (nonatomic, copy) NSString *alarmThumbImage;  //缩略图
@property (nonatomic, copy) NSArray <NSString*> *alarmImages; //设备报警图片
@property (nonatomic, assign) BOOL isRead;              //是否已读
@property (nonatomic, assign)NSInteger msgID;           //消息ID
@property (nonatomic, assign) NSInteger decibel;        //噪声分贝(db)
@property (nonatomic, assign) NSInteger state;        //是否使用oss

/**
 userID/ownerID：
 描述: 当设备属于当前用户时，ownerID是当前用户的id,userID为0. 当设备是被分享过来的时候，ownerID是设备主人的id,userID是当前用户id.
 */
@property (nonatomic, assign)NSInteger userID;
@property (nonatomic, assign)NSInteger ownerID;

@end

@interface MeariMessageInfoVisitor : MeariMessageInfo
@property (nonatomic, copy) NSNumber *createDate;
@property (nonatomic, copy) NSNumber *voiceDuration;    //客人留言时长
@property (nonatomic, copy) NSString *voiceUrl;         //客人留言地址
@property (nonatomic, assign)MeariVisitorMessageType msgType;  //消息类型
@property (nonatomic, assign)BOOL isRead;              //是否已读
@property (nonatomic, assign)NSInteger msgID;           //消息ID
@property (nonatomic, assign)NSInteger userID;          //用户ID
@property (nonatomic, assign)NSInteger deviceID;       //设备ID
@end

