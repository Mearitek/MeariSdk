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

UIKIT_EXTERN  NSString *const MeariDeviceSearchNotification; // search device (发现设备)
UIKIT_EXTERN  NSString *const MeariDeviceAddNotification; // Add device (添加设备)
@class MeariDeviceActivator,MeariDevice;

@protocol MeariDeviceActivatorDelegate<NSObject>

@required

/**
 Device Complete callback
 配网状态更新的回调
 
 @param activator activator
 @param deviceModel return the device which config network completed
 @param error return error
 */
- (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error;

@end

@interface MeariDeviceActivator : NSObject
/**
 *  Single (单例)
 */
+ (instancetype)sharedInstance;

/**
   wifi ssid
 *  获取当前Wifi的SSID名称
 */
+ (NSString *)currentWifiSSID;

/**
    wifi bssid
 *  获取当前Wifi的BSSID名称
 */
+ (NSString *)currentWifiBSSID;

@property (nonatomic, weak) id<MeariDeviceActivatorDelegate> delegate;

/**
 token for config device
 获取配网的token
 
 @param success return  config dictionary
 token: config token
 validTime: token invalid time
 delaySmart: user for smartwifi (Deprecated)
 
 token: 用于配网
 validTime: token有效时长，超过时长需要重新获取新的token
 delaySmart: 延迟开启smartwifi指令，用于二维码和smart同时配网，delaySmart小于0则关闭双发
 
 @param failure 失败回调
 */
- (void)getTokenSuccess:(MeariSuccess_Token2)success failure:(MeariFailure)failure;

/**
 AP配网传递的参数

 @param ssid wifi name (wifi名称)
 @param password wifi password (wifi密码)
 @param token config token (获取的配网APtoken)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)configApModeWithSSID:(NSString *)ssid password:(NSString *)password token:(NSString *)token relay:(BOOL)relayDevice success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 有线配网传递的参数

 @param ip ip address  (设备ip地址)
 @param token config token (获取的配网token)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startConfigWireDevice:(NSString *)ip token:(NSString *)token success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
    start config
 *  开始配网
 *
 *  @param mode     search device mode (配网模式)
 *  @param token   config token ( 配网Token  二维码 AP smartwifi)
 *  @param timeout  超时时间, 默认为100秒 ,小于0则不关闭配网,需手动调用stopSearch
                    Timeout time, the default is 100 seconds. If it is less than 0, the distribution network will not be closed. You need to manually call stopSearch.
 */
- (void)startConfigWiFi:(MeariDeviceSearchMode)mode
                  token:(NSString *)token
                   type:(MeariDeviceTokenType)type
                    nvr:(BOOL)isNvr
                timeout:(NSTimeInterval)timeout;
/**
 stop config
 停止配网
 */
- (void)stopConfigWiFi;
// Not recommended for use
//不建议使用

/**
 start smartwifi config
 开始 smartwifi 配网
 
 @param ssid wifi name wifi名称
 @param password  password wifi password (wifi密码)
 @param token   token
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)activatorSmartWifiWithSSID:(NSString *)ssid wifiPwd:(NSString *)password token:(NSString *)token success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure __deprecated_msg("Not recommended for use");



/**
 stop smartwifi config
 停止 smartwifi 配网
 */
- (void)stopSmartWifi;


/**
 search device
 搜索设备

 @param mode search mode 搜索模式
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startSearchDevice:(MeariDeviceSearchMode)mode success:(MeariDeviceSuccess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 stop search
 停止搜索
 */
- (void)stopSearchDevice;

/**
 check device status
 向服务器查阅设备的状态

 @param devices device array 设备数组
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)checkDeviceStatus:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;
/**
 Add Device Manual
 添加设备
 
 @param device Searched device (搜索到的设备)
 @param isNvr  is NVR device (是否为NVR设备)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)addDevice:(MeariDevice *)device nvr:(BOOL)isNvr success:(void(^)(MeariDevice *camera))success failure:(MeariFailure)failure;
#pragma mark --- 中继添加
/**
 the token use to add chime
 获取中继添加的token
 @param type 类型 区分网关和网关子设备
 @param success 成功回调：
 token: 用于配网
 validTime: token有效时长，超过时长需要重新获取新的token
 @param failure 失败回调
 */
- (void)getConfigRelayDeviceTokenType:(MeariDeviceGatewayTokenType)type success:(MeariSuccess_Token)success failure:(MeariFailure)failure;

@end

NS_ASSUME_NONNULL_END
