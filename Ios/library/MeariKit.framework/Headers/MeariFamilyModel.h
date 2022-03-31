//
//  MeariFamilyModel.h
//  MeariKit
//
//  Created by maj on 2021/7/5.
//  Copyright © 2021 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MeariDevice.h"

typedef NS_ENUM(NSInteger, MRFamilyJoinStatus) {
    MRFamilyJoinStatusCanJoin, // 可加入
    MRFamilyJoinStatusAlreadyJoin, // 已经加入
    MRFamilyJoinStatusDoJoin // 加入中
};
typedef NS_ENUM(NSInteger, MRFamilyInvitedStatus) {
    MRFamilyInvitedStatusNone,
    MRFamilyInvitedStatusHasInvite,
};

NS_ASSUME_NONNULL_BEGIN

// 家庭设备基础信息
@interface MeariFamilyDeviceModel : MeariBaseModel
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, assign) BOOL closePush;

@property (nonatomic, copy) NSDictionary *userControl; // 权限字典;
@property (nonatomic, assign) MeariDeviceAuthority permission;

@end

// 家庭房间
@interface MeariRoomModel : MeariBaseModel
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, assign) NSInteger roomTarget; // 如果存在roomTarget，roomName初始化为空。上层分配名称
@property (nonatomic, copy) NSArray<MeariFamilyDeviceModel *> *devices;
@property (nonatomic, copy) NSArray<MeariDevice *> *roomDeviceList; // 房间的设备列表

+ (instancetype)roomWithRoomId:(NSString *)roomId;

@end

// 家庭
@interface MeariFamilyModel : MeariBaseModel
@property (nonatomic, assign) BOOL isDefault; // 是否默认家庭
@property (nonatomic, assign) BOOL owner; // 是否所有者

@property (nonatomic, copy) NSString *homeID; // 家庭ID
@property (nonatomic, copy) NSString *homeName; // 家庭名称
@property (nonatomic, copy) NSString *position; // 家庭位置
@property (nonatomic, copy) NSString *userName; // 用户昵称，当homeName不存在时才有值
@property (nonatomic, assign) MRFamilyJoinStatus joinStatus; // 家庭对别人的加入状态

@property (nonatomic, copy) NSArray<MeariRoomModel *> *roomList; // 家庭列表
@property (nonatomic, copy) NSArray<MeariDevice *> *relaySubDeviceList; // relay所有子设备列表
@property (nonatomic, copy) NSArray<MeariDevice *> *allDeviceList; // 我的所有设备列表
@property (nonatomic, copy) NSArray<MeariDevice *> *sharedDeviceList; // 分享的设备列表
@property (nonatomic, copy) NSArray<MeariDevice *> *unDistributionDeviceList;  // 未分配的设备列表

// 根据ID 获取家庭
+ (instancetype)familyWithFamilyId:(NSString *)homeID;

@end

// 家庭成员
@interface MeariMemberModel : MeariBaseModel
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *userAccount; // 用户账号
@property (nonatomic, copy) NSString *nickName; // 昵称
@property (nonatomic, copy) NSString *userName; // 成员名称
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *msgID; // 当加入状态为2时， 可以使用msgid 撤销加入家庭
@property (nonatomic, assign) MRFamilyJoinStatus joinStatus;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, copy) NSString *hasInvited; //
@property (nonatomic, assign) MRFamilyInvitedStatus invitedStatus;
// 管理员
@property (nonatomic, copy) NSString *homeID;
@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSArray<MeariFamilyDeviceModel *> *devices;
// 普通成员
@property (nonatomic, copy) NSArray<MeariFamilyModel *> *homes;

@end

// 家庭分享信息
@interface MeariMessageFamilyShare : MeariBaseModel
@property (nonatomic, copy) NSString *msgID;
@property (nonatomic, assign) NSInteger msgType;
@property (nonatomic, assign) NSInteger dealFlag;
@property (nonatomic, copy) NSString *homeName; // 家庭名称
@property (nonatomic, copy) NSString *date; // 时间
@property (nonatomic, copy) NSString *inviter;
@property (nonatomic, copy) NSString *inviterName; //邀请人
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *receiverName; //接受人
@property (nonatomic, copy) NSString *receiverImage; //接受图

@end
NS_ASSUME_NONNULL_END
