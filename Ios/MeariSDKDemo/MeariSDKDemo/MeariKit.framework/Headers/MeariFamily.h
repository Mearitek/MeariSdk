//
//  MeariFamily.h
//  MeariKit
//
//  Created by maj on 2021/7/5.
//  Copyright © 2021 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MeariFamilyModel.h"
#import "MeariDevice.h"

@class MeariMemberModel;
typedef void(^MeariSuccess_MemberList)(NSArray <MeariMemberModel *> *memberList);
typedef void(^MeariSuccess_FamilyList)(NSArray <MeariFamilyModel *> *familyList);
typedef void(^MeariSuccess_FamilyMessageList)(NSArray <MeariMessageFamilyShare *> *familyMessageList);
typedef void(^MeariSuccess_Family)(MeariFamilyModel *familyModel);
typedef void(^MeariSuccess_Member)(MeariMemberModel *member);
typedef void(^MeariSuccess)(void);
typedef void(^MeariFailure)(NSError *error);

// family list need refresh (家庭更新)
UIKIT_EXTERN  NSString *const MeariFamilyFamilyRefreshNotification;
// Member Info Update (成员信息更新)
UIKIT_EXTERN  NSString *const MeariFamilyMemberUpdateNotification;
// someone would like invite you to his family(xxx邀请你加入他的房间)
UIKIT_EXTERN  NSString *const MeariFamilyInviteYouToHisFamilyNotification;
// invite other to you family success (邀请其他人加入你的的家庭成功)
UIKIT_EXTERN  NSString *const MeariFamilyInviteJoinFamilySuccessNotification;
// someone would like join your family (xxx 想要加入你的家庭)
UIKIT_EXTERN  NSString *const MeariFamilyJoinYourFamilyRequestNotification;
// you join other user family success (你加入别人的家庭成功)
UIKIT_EXTERN  NSString *const MeariFamilyJoinOtherFamilySuccessNotification;
// family info update (家庭信息更新)
UIKIT_EXTERN  NSString *const MeariFamilyFamilyInfoUpdateNotification;
// family delete (家庭删除)
UIKIT_EXTERN  NSString *const MeariFamilyFamilyDeleteNotification;
// family room delete (家庭房间删除)
UIKIT_EXTERN  NSString *const MeariFamilyRoomDeleteNotification;
// family info update (家庭设备删除)
UIKIT_EXTERN  NSString *const MeariFamilyFamilyDeviceDeleteNotification;

NS_ASSUME_NONNULL_BEGIN

@interface MeariFamily : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSMutableArray<MeariFamilyModel *> *familyArray; // 家庭数组
@property (nonatomic, strong) NSMutableArray<MeariDevice *> *allMyDevice; // 所有我的设备(包括单独分享的设备)
@property (nonatomic, strong) NSMutableArray<MeariDevice *> *allDevice; // 所有的设备
@property (nonatomic, copy, readonly) NSArray<NSString *> *homeIDArray; // 家庭ID数组
- (BOOL)isFamilyOwner:(NSString *)homeID;  // 判断这个家庭是否是自己的
- (BOOL)isOtherFamilyDevice:(NSInteger)deviceId; // 判断设备是否是其他家庭的 (自己家庭，单设备分享，未分配设备不在其中)
/**
  family list
  @param success Called when the task finishes successfully.
  @param failure  If error occurred while adding the task, this block will be called.
 */
- (void)getFamilyListSuccess:(MeariSuccess_FamilyList)success failure:(MeariFailure)failure;
/**
  home list
  @param success Called when the task finishes successfully.
  @param failure  If error occurred while adding the task, this block will be called.
 */
- (void)getFamilyHomeListSuccess:(MeariSuccess)success failure:(MeariFailure)failure;

/**
  home list
  @param homeID home's id
  @param success Called when the task finishes successfully.
  @param failure  If error occurred while adding the task, this block will be called.
 */
- (void)getFamilyListWithHomeID:(NSString *)homeID  success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
  update family / 家庭管理-家庭修改
  @param homeID home's Id
  @param homeName home's name
  @param homePosition home's position
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
 */
- (void)updateFamilyWithHomeID:(NSString *)homeID
                      homeName:(NSString *)homeName
                  homePosition:(NSString *)homePosition
                       success:(MeariSuccess)success
                       failure:(MeariFailure)failure;
/**
  delete family / 家庭管理-删除家庭
  @param homeID home's name
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
 */
- (void)removeFamilyWithHomeID:(NSString *)homeID
                       success:(MeariSuccess)success
                       failure:(MeariFailure)failure;
/**
  create family / 新建家庭
  @param homeName home's name
  @param homePosition home's position
  @param roomNameList roomNameList
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
 */
- (void)addFamilyWithHomeName:(nonnull NSString *)homeName
                 homePosition:(nullable NSString *)homePosition
                 roomNameList:(nullable NSArray<NSString *> *)roomNameList
                      success:(MeariSuccess)success
                      failure:(MeariFailure)failure;
/**
  家庭管理-加入家庭
  @param homeIDList home's id list
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
 */
- (void)joinFamilyWithHomeIDList:(NSArray<NSString *> *)homeIDList
                       success:(MeariSuccess)success
                       failure:(MeariFailure)failure;

/**
  家庭管理-离开家庭（非家庭主人）
  @param homeID home's id
  @param success Called when the task finishes successfully.
  @param failure  If error occurred while adding the task, this block will be called.
 */
- (void)leaveFamilyWithHomeID:(NSString *)homeID
                      success:(MeariSuccess)success
                      failure:(MeariFailure)failure;
/**
  家庭管理-家庭添加成员
  @param homeID home's id
  @param memberID member's id
  @param deviceAuthorityList [{"deviceID":1,"permission": 0}, {"deviceID":1,"permission": 0}]
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
 */
- (void)addMemberWithHomeID:(nonnull NSString *)homeID
                   memberID:(nonnull NSString *)memberID
        deviceAuthorityList:(NSArray *)deviceAuthorityList
                       success:(MeariSuccess)success
                       failure:(MeariFailure)failure;

/// 家庭删除成员
/// @param homeID home's id 
/// @param memberID member's id
/// @param success Called when the task finishes successfully.
/// @param failure  If error occurred while adding the task, this block will be called.
- (void)removeMemberWithHomeID:(nonnull NSString *)homeID
                      memberID:(nonnull NSString *)memberID
                          success:(MeariSuccess)success
                       failure:(MeariFailure)failure;

/// 家庭撤销邀请成员
/// @param msgID message's id
/// @param homeID home's id
/// @param success Called when the task finishes successfully.
/// @param failure  If error occurred while adding the task, this block will be called.
- (void)revokeFamilyInviteWithMsgID:(NSString *)msgID
                             homeID:(NSString *)homeID
                            success:(MeariSuccess)success
                            failure:(MeariFailure)failure;

/**
  家庭添加成员-根据账号搜索
  @param homeID home's id ,   According to the homeID to distinguish whether the account is an administrator or an ordinary member
  @param memberAccount memberAccount
  @param countryCode  country Code
  @param phoneCode  phone code
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
*/
- (void)searchUserWithHomeID:(nullable NSString *)homeID
               memberAccount:(nonnull NSString *)memberAccount
                 countryCode:(NSString *)countryCode
                   phoneCode:(nonnull NSString *)phoneCode
                     success:(MeariSuccess_Member)success
                     failure:(MeariFailure)failure;
/**
  家庭成员列表
  @param homeID home's id
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
*/
- (void)getMemberListWithHomeID:(NSString *)homeID
                       success:(MeariSuccess_MemberList)success
                        failure:(MeariFailure)failure;

/**
  家庭设备权限变更
  @param memberID member's id
  @param homeID homeID
  @param deviceAuthorityList user device authority   [{"deviceID":1,"permission": 0},{"deviceID":2,"permission": 0}]
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
 */
- (void)updateMemberPermissionMemberID:(nonnull NSString *)memberID
                                homeID:(NSString *)homeID
                   deviceAuthorityList:(NSArray *)deviceAuthorityList
                               success:(MeariSuccess)success
                               failure:(MeariFailure)failure;

/**
  房间管理-设备分配房间
  @param roomID room's id
  @param homeID home's id
  @param deviceIDList deviceIDList
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
*/
- (void)roomDeviceDistributioRoomID:(nonnull NSString *)roomID
                              homeID:(nonnull NSString *)homeID
                          deviceIDList:(nonnull NSArray<NSNumber *> *)deviceIDList
                               success:(MeariSuccess)success
                            failure:(MeariFailure)failure;

/**
  房间管理-新增房间
  @param roomName room's name
  @param homeID home's id
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
*/
- (void)addRoomWithRoomName:(NSString *)roomName
                     homeID:(NSString *)homeID
                    success:(MeariSuccess)success
                    failure:(MeariFailure)failure;

/// 房间管理-房间名称修改
/// @param roomName 房间名称
/// @param homeID 家庭ID
/// @param roomID 房间ID
/// @param success Called when the task finishes successfully.
/// @param failure If error occurred while adding the task, this block will be called.
- (void)updateRoomNameWithRoomName:(NSString *)roomName
                            homeID:(NSString *)homeID
                            roomID:(NSString *)roomID
                    success:(MeariSuccess)success
                           failure:(MeariFailure)failure;
/**
  房间管理-删除房间
  @param roomIDList room's id list
  @param homeID home's id
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
*/
- (void)removeRoomWithRoomIDList:(NSArray<NSString *> *)roomIDList
                      homeID:(NSString *)homeID
                     success:(MeariSuccess)success
                     failure:(MeariFailure)failure;

/**
  房间管理-移除该房间的设备
  @param roomID room's id
  @param homeID home's id
  @param deviceIDList deviceIDList
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
 */
- (void)removeDeviceWithRoomID:(NSString *)roomID
                      homeID:(NSString *)homeID
                deviceIDList:(nonnull NSArray<NSNumber *> *)deviceIDList
                     success:(MeariSuccess)success
                     failure:(MeariFailure)failure;

/**
  房间管理-家庭成员名称修改
  @param homeID home's id
  @param memberID member's id
  @param memberName memberName
  @param success Called when the task finishes successfully.
  @param failure If error occurred while adding the task, this block will be called.
*/
- (void)memberNameUpdateWithHomeID:(NSString *)homeID
                    memberID:(NSString *)memberID
                  memberName:(NSString *)memberName
                     success:(MeariSuccess)success
                     failure:(MeariFailure)failure;
/**
 删除家庭分享消息
 @param msgIDList msg id list
 @param success Called when the task finishes successfully.
 @param failure If error occurred while adding the task, this block will be called.
 */
- (void)removeFamilyInviteMessageWithMsgIDList:(NSArray<NSString *> *)msgIDList
                     success:(MeariSuccess)success
                                       failure:(MeariFailure)failure;

/**
 get shared List of Family
 获取家庭分享列表
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getFamilyShareListSuccess:(MeariSuccess_FamilyMessageList)success failure:(MeariFailure)failure;
/**
deal shared List of Family
 处理家庭分享列表
 @param msgIDList msg id list
 @param flag reject (0) or  accept (1)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)dealFamilyShareMessageWithMsgIDList:(NSArray<NSString *> *)msgIDList
                                       flag:(NSInteger)flag
                                    success:(MeariSuccess)success
                                    failure:(MeariFailure)failure;
@end

NS_ASSUME_NONNULL_END
