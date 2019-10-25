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
    MeariSystemMessageTypeFriendAdd,           //request add friend
    MeariSystemMessageTypeFriendAgree,         //agree add friend
    MeariSystemMessageTypeFriendRefuse,        //refuse add friend
    MeariSystemMessageTypeDeviceShare,         //request add device
    MeariSystemMessageTypeDeviceAgree,         //agree add device
    MeariSystemMessageTypeDeviceRefuse,        //refuse add device
    MeariSystemMessageTypeDeviceLowBattery     //warning for bell's low power
};

typedef NS_ENUM(NSInteger, MeariAlarmMessageType) {
    MeariAlarmMessageTypeNone,
    MeariAlarmMessageTypeMotion = 1,                //motion alarm, alarm when device detect something has been moved
    MeariAlarmMessageTypePir = 2,                   //pir alarm, alarm when device detect moved things in night mode
    MeariAlarmMessageTypeVisitor = 3,               //visitor alarm, available on bell device, alarm when somebody tap the ring.
    MeariAlarmMessageTypeNoise = 6,                 //Noise alarm
    MeariAlarmMessageTypeCry = 7                    //Cry alarm
};

typedef NS_ENUM(NSInteger, MeariVisitorMessageType) {
    MeariVisitorMessageTypeNone,               //
    MeariVisitorMessageTypeReceiveCall ,       // Answering visitor messages
    MeariVisitorMessageTypeRejectCall ,        // Reject visitor messages
    MeariVisitorMessageTypeUnreadMessage ,     // Unread visitor message
    MeariVisitorMessageTypeHasReadMessage      // Has read visitor message
};

@interface MeariMessageInfo : MeariBaseModel
@end


@interface MeariMessageInfoSystem : MeariMessageInfo
@property (nonatomic, assign)MeariSystemMessageType msgType;  //message type
@property (nonatomic, assign)NSInteger msgID;          //message id
@property (nonatomic, assign)NSInteger deviceID;       //device id
@property (nonatomic, copy)NSString *deviceName;       //device name
@property (nonatomic, copy)NSString *deviceUUID;       //device uuid
@property (nonatomic, assign)NSInteger friendID;       //friend id
@property (nonatomic, copy)NSString *friendAccount;    //friend account
@property (nonatomic, copy)NSString *friendNickname;   //friend nickname
@property (nonatomic, copy)NSString *friendAvatarUrl;  //friend avatar
@end

@interface MeariMessageInfoAlarm : MeariMessageInfo
@property (nonatomic, assign) NSInteger deviceID;       //device id
@property (nonatomic, copy) NSString *deviceName;       //device name
@property (nonatomic, copy) NSString *deviceSn;         //device sn
@property (nonatomic, copy) NSString *deviceUUID;       //device uuid
@property (nonatomic, copy) NSString *deviceIconUrl;    //device icon
@property (nonatomic, assign) BOOL hasMsg;              //whether has alarm message or not
@end

@interface MeariMessageInfoAlarmDevice : MeariMessageInfo
@property (nonatomic, assign)MeariAlarmMessageType msgType;  //message type
@property (nonatomic, assign) NSInteger deviceID;       //device id
@property (nonatomic, copy) NSString *alarmTime;        //device alarm time
@property (nonatomic, copy) NSString *alarmThumbImage;  //device alarm thumb image
@property (nonatomic, copy) NSArray <NSString*> *alarmImages; //device alarm images
@property (nonatomic, assign) BOOL isRead;              //message is whether readed or not
@property (nonatomic, assign)NSInteger msgID;           //message id
@property (nonatomic, assign) NSInteger decibel;        //Noise decibel (0-100)
@property (nonatomic, assign) NSInteger state;        // whether to use OSS

/**
 userID/ownerID：
 Description:
 When the device belongs to the current user, the ownerID is the id of the current user, and the userID is 0.
 When the device is shared, the ownerID is the id of the device owner, and the userID is the current user id.
 */
@property (nonatomic, assign)NSInteger userID;          //user id
@property (nonatomic, assign)NSInteger ownerID;         //owner id
@end

@interface MeariMessageInfoVisitor : MeariMessageInfo
@property (nonatomic, copy) NSNumber *createDate;
@property (nonatomic, copy) NSNumber *voiceDuration; // Guest message duration
@property (nonatomic, copy) NSString *voiceUrl; // Guest address
@property (nonatomic, assign)MeariVisitorMessageType msgType; //Message type
@property (nonatomic, assign)BOOL isRead; //whether read
@property (nonatomic, assign)NSInteger msgID; //Message ID
@property (nonatomic, assign)NSInteger userID; //User ID
@property (nonatomic, assign)NSInteger deviceID; //Device ID
@end

