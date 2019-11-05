//
//  MeariDeviceActivator.h
//  MeariKit
//
//  Created by MJ2009 on 2019/5/28.
//  Copyright © 2019 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MeariDeviceInfo.h"
#import "MeariUser.h"
#import "MeariDeviceControl.h"
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN  NSString *const MeariDeviceSearchNotification; //发现设备
UIKIT_EXTERN  NSString *const MeariDeviceAddNotification; //添加设备
@class MeariDeviceActivator,MeariDevice;

@protocol MeariDeviceActivatorDelegate<NSObject>

@required

/// 配网状态更新的回调
- (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error;

@end

@interface MeariDeviceActivator : NSObject
/**
 *  单例
 */
+ (instancetype)sharedInstance;

/**
 *  获取当前Wifi的SSID名称
 */
+ (NSString *)currentWifiSSID;

/**
 *  获取当前Wifi的BSSID名称
 */
+ (NSString *)currentWifiBSSID;

@property (nonatomic, weak) id<MeariDeviceActivatorDelegate> delegate;

/**
 获取配网的token
 
 @param success 成功回调：
 token: 用于配网
 validTime: token有效时长，超过时长需要重新获取新的token
 delaySmart: 延迟开启smartwifi指令，用于二维码和smart同时配网，delaySmart小于0则关闭双发
 @param failure 失败回调
 */
- (void)getTokenSuccess:(MeariSuccess_Token2)success failure:(MeariFailure)failure;

/**
 AP配网传递的参数

 @param ssid wifi名称
 @param password wifi密码
 @param token 获取的配网APtoken
 @param success 成功回调
 @param failure 失败回调
// */
- (void)configApModeWith:(NSString *)ssid password:(NSString *)password token:(NSString *)token success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 *  开始配网
 *
 *  @param mode     配网模式
 *  @param token    配网Token  二维码 AP smartwifi
 *  @param timeout  超时时间, 默认为100秒 ,小于0则不关闭配网,需手动调用stopSearch
 */
- (void)startConfigWiFi:(MeariDeviceSearchMode)mode
                  token:(NSString *)token
                   type:(MeariDeviceTokenType)type
                    nvr:(BOOL)isNvr
                timeout:(NSTimeInterval)timeout;
/**
 停止搜索
 */
- (void)stopConfigWiFi;

//不建议使用
/**
 开始 smartwifi 配网
 
 @param ssid wifi名称
 @param password wifi密码
 @param token   token
 @param success 成功回调
 @param failure 失败回调
 */
- (void)activatorSmartWifi:(NSString *)ssid wifiPwd:(NSString *)password token:(NSString *)token success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 停止 smartwifi 配网
 */
- (void)stopSmartWifi;


/**
 搜索设备

 @param mode 搜索模式
 @param success 成功回调
 @param failure 失败回调
 */
- (void)startSearchDevice:(MeariDeviceSearchMode)mode success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 添加设备
 
 @param device 搜索到的设备
 @param isNvr  是否为NVR设备
 @param success 成功回调部分设备信息
 @param failure 失败回调
 */
- (void)addDevice:(MeariDevice *)device nvr:(BOOL)isNvr success:(void(^)(MeariDevice *camera))success failure:(MeariFailure)failure;

@end

NS_ASSUME_NONNULL_END
