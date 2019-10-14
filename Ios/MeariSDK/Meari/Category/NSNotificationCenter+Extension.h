//
//  NSNotificationCenter+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/6/24.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYObj_Device;
@class WYObj_User;
typedef void(^WYBlock_User) (WYObj_User *user);
typedef void(^WYBlock_Device) (WYObj_Device *device);
typedef void(^WYBlock_Devices) (NSMutableArray <WYObj_Device *>*devices);
@interface NSNotificationCenter (Extension)
#pragma mark -- User
- (void)wy_post_User_LandInOtherPlace:(WYBlock_User)completion;
#pragma mark -- Device
- (void)wy_post_Device_Add:(WYBlock_Device)completion;
- (void)wy_post_Device_Delete:(WYBlock_Device)completion;
- (void)wy_post_Device_ChangeNickname:(WYBlock_Device)completion;
- (void)wy_post_Devices_ChangeAlarmMsgReadFlag:(WYBlock_Devices)completion;
- (void)wy_post_Device_ChangeParam:(WYBlock_Device)completion;
- (void)wy_post_Device_ConnectCompleted:(WYBlock_Device)completion;
- (void)wy_post_Device_CancelShare:(WYBlock_Device)completion;
- (void)wy_post_Device_OnOffline:(WYBlock_Device)completion;
- (void)wy_post_Device_BindUnBindNVR:(WYBlock_Device)completion;
- (void)wy_post_Device_Snapshot:(WYBlock_Device)completion;
- (void)wy_post_Device_VisitorCallShow;
- (void)wy_post_Device_VisitorCallDismiss;
- (void)wy_post_App_RefreshCameraList;
@end





#pragma mark -  Notification Object
@interface WYObj_Device : NSObject
@property (nonatomic, assign)NSInteger deviceID;
@property (nonatomic, copy)NSString *deviceName;
@property (nonatomic, assign)NSInteger deviceType;
@property (nonatomic, copy) NSString *connectDescription;
@property (nonatomic, assign)BOOL connectSuccess;
@property (nonatomic, assign)BOOL online;
@property (nonatomic, assign)BOOL hasUnreadMsg;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, assign)NSInteger paramType;
@property (nonatomic, copy)id paramValue;
@property (nonatomic, assign)BOOL updated;
@property (nonatomic,   copy) NSString *camerap; //对应Camera的内存地址

//NVR绑定IPC
@property (nonatomic, assign)BOOL bindedNVR;
@property (nonatomic, assign)NSInteger nvrID;
@end

@interface WYObj_User : NSObject
@end
