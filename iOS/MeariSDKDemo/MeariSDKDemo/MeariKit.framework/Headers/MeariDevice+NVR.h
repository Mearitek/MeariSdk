//
//  MeariDevice+NVR.h
//  MeariKit
//
//  Created by macbook on 2022/4/22.
//  Copyright © 2022 Meari. All rights reserved.
//

#import "MeariDevice.h"
#import "MeariSearchNVRSubDeviceModel.h"

typedef NS_ENUM(NSInteger,MeariDeviceChannelState) {
    MeariDeviceChannelStateUnbind  = 0,
    MeariDeviceChannelStateOnline  = 1,
    MeariDeviceChannelStateOffline = 2,
    MeariDeviceChannelStateSleep   = 3,
};

@interface MeariDevice (NVR)

/** device channel*/
/** nvr 子设备设备通道*/
@property (nonatomic, assign) NSInteger channel;
/** device channel state*/
/** nvr 设备通道状态*/
@property (nonatomic, assign) MeariDeviceChannelState channelState;

/** NVR network storage*/
/** 是否是网络存储器（NVR）*/
@property (nonatomic, assign, readonly, getter = isNvr) BOOL nvr;

/** Base network storage*/
/** 是否是网络存储器（Neutral）*/
@property (nonatomic, assign, readonly, getter = isNeutralNVR) BOOL neutralNVR;
/** Base network storage*/
/** 是否是网络存储器（Base）*/
@property (nonatomic, assign, readonly, getter = isBaseNVR) BOOL baseNVR;
/** Whether the device is bound to the NVR*/
/** 是否是网络存储器子设备*/
@property (nonatomic, assign, readonly, getter = isNvrSubDevice) BOOL nvrSubDevice;

/** device onvif*/
/** nvr 子设备是否onvif接入*/
@property (nonatomic, assign) BOOL isOnvif;

/** 是否支持智能检测*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetection;
/** 是否支持智能检测人形*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionPerson;
/** 是否支持智能检测宠物*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionPet;
/** 是否支持智能检测车辆*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionCar;
/** 是否支持智能检测包裹*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionPackage;
/** 是否支持智能检测烟火*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionFire;
/** 是否支持智能检测画框*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionFrame;
/** 是否支持智能检测布防时间*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionTime;
/** 是否支持智能检测区域*/
@property (nonatomic, assign, readonly) BOOL supportIntelligentDetectionArea;

/** 是否NVR支持删除子设备*/
@property (nonatomic, assign, readonly) BOOL supportDeleteIpc;
/** 是否支持无线抗干扰*/
@property (nonatomic, assign, readonly) BOOL supportAntijamming;

///** Base是否支持切换wifi连接*/
//@property (nonatomic, assign, readonly) BOOL supportSitchWifi;
/** Base是否支持提示音量设置*/
@property (nonatomic, assign, readonly) BOOL supportPromptVolume;

/** 是否支持生成Camera连接NVR的二维码(NVR设置页）*/
@property (nonatomic, assign, readonly) BOOL supportSetNVRQRcode;
/** 是否支持生成Camera连接NVR的二维码(NVR展示页面)*/
@property (nonatomic, assign, readonly) BOOL supportAddNVRQRcode;
/** 是否支持camera连接路由器的二维码(NVR展示页面)*/
@property (nonatomic, assign, readonly) BOOL supportAddRouterQRcode;


- (NSMutableArray *)nvrSubDevicesWithUnBind:(BOOL)hasUnBind;

/**
获取设备允许被发现状态：Get Sub Device Found Permission
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getSubDeviceFoundPermissionWithSuccess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
 设置设备允许被发现状态：Set Sub Device Found Permission
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceFoundPermission:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 获取设备允许被发现剩余时长：Get Sub Device Found Permission Time
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getSubDeviceFoundRemainTimeWithSuccess:(MeariSuccess_String)success failure:(MeariFailure)failure;

#pragma mark - Add Sub Device
/**
开始搜索：Start Search Nvr Sub Device
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)startSearchNvrSubDeviceWithSuccess:(MeariSuccess)success failure:(MeariFailure)failure;
/**
获取搜索结果：Get Nvr Sub Device Result
@param success Successful callback (成功回调)：返回搜索到的设备
@param failure failure callback (失败回调)
*/
- (void)getSearchedNvrSubDeviceWithSuccess:(void(^)(BOOL finish, NSArray<MeariSearchNVRSubDeviceModel *>* searchArray))success failure:(MeariFailure)failure;
/**
 Add child device through Nvr (in-app binding)
 Nvr添加子设备(app内绑定)
 
 @param ip 子设备ip
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)bindNvrSubDeviceWithIp:(NSString *)ip success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
 Add child device through Nvr (onvif binding)
 Nvr添加子设备(onvif 协议设备)
 
 @param ip 子设备ip
 @param user onvif 用户
 @param password onvif密码
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)bindNvrSubDeviceWithIp:(NSString *)ip user:(NSString *)user password:(NSString *)password success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
 Get  Nvr Net Config Key
 获取Nvr添加子设备扫码所需key
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getNVRNetConfigKeyWithSucess:(MeariSuccess_String)success failure:(MeariFailure)failure;

/*
 搜索路由器流程添加子设备至的准备操作
@param success Successful callback (成功回调)：返回搜索到的设备
@param failure failure callback (失败回调)
*/
- (void)readyForSearchRouterNvrSubDeviceWithSuccess:(MeariSuccess)success failure:(MeariFailure)failure;
/**
获取搜索结果：Get Nvr Sub Device Result (添加子设备至路由器流程)
@param success Successful callback (成功回调)：返回搜索到的设备
@param failure failure callback (失败回调)
*/
- (void)searchRouterNvrSubDeviceWithSuccess:(void(^)(NSArray<MeariSearchNVRSubDeviceModel *>* searchArray))success failure:(MeariFailure)failure;
/**
设置NVR设备全天录像：Set Nvr All Day Record
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setNVRAllDayRecord:(BOOL)enable WithSuccess:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 设置设备智能侦测开关：Set device smart detection switch
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetection:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测灵敏度：Set device smart detection level
@param level  0-低 1-中 2-高
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionLevel:(NSInteger)level success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测人形：Set device smart detection person
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionPerson:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测宠物：Set device smart detection pet
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionPet:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测车辆：Set device smart detection car
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionCar:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测包裹：Set device smart detection package
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionPackage:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测烟火：Set device smart detection Fire
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionFire:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测画框：Set device smart detection frame
@param enable  0-不允许 1-允许
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionFrame:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测开关：Set device smart detection switch
@param start  开始时间（00:00）
@param end  结束时间（00:00）
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionStartTime:(NSString *)start endTime:(NSString *)end success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备智能侦测区域：Set device smart detection area
@param areas (X1,Y1,X2,Y2,X3,Y3,X4,Y4) 数组
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSubDeviceIntelligentDetectionArea:(NSArray <MeariDevicePolygonRoiArea *> *)areas success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 设置设备提示音量：Set device prompt volume
@param volume  1-100
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDevicePromptVolume:(NSInteger)volume success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 设置设备wifi连接名字和密码：Set device wifi name & password
@param wifi  名字
@param password  密码
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDeviceWifiName:(NSString *)wifi password:(NSString *)password success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 获取设备wifi列表：get device wifi list
 
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getBaseDeviceWifiListWithSuccess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
@end
