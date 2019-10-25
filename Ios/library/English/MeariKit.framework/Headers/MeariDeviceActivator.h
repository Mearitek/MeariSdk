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

UIKIT_EXTERN  NSString *const MeariDeviceSearchNotification; //search device
UIKIT_EXTERN  NSString *const MeariDeviceAddNotification; //Add device
@class MeariDeviceActivator,MeariDevice;

@protocol MeariDeviceActivatorDelegate<NSObject>

@required
/**
 Device Complete callback

 @param activator activator
 @param deviceModel return the device which config network completed
 @param error return error
 */
- (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error;

@end

@interface MeariDeviceActivator : NSObject
/**
 *  Single
 */
+ (instancetype)sharedInstance;

/**
 *  wifi ssid
 */
+ (NSString *)currentWifiSSID;

/**
 *  wifi bssid
 */
+ (NSString *)currentWifiBSSID;

@property (nonatomic, weak) id<MeariDeviceActivatorDelegate> delegate;

/**
 token for config device
 
 @param success return  config dictionary
        token: config token
        validTime: token invalid time
        delaySmart: user for smartwifi (Deprecated)

 @param failure return error
 */
- (void)getTokenSuccess:(MeariSuccess_Token2)success failure:(MeariFailure)failure;

/**
 Ap config

 @param ssid wifi name
 @param password wifi password
 @param token config token
 @param success
 @param failure return error
// */
- (void)configApModeWith:(NSString *)ssid password:(NSString *)password token:(NSString *)token success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 *  start config 
 *
 *  @param mode    search device mode
 *  @param token   config token
 *  @param timeout  Timeout time, the default is 100 seconds. If it is less than 0, the distribution network will not be closed. You need to manually call stopSearch.
 */
- (void)startConfigWiFi:(MeariDeviceSearchMode)mode
                  token:(NSString *)token
                   type:(MeariDeviceTokenType)type
                    nvr:(BOOL)isNvr
                timeout:(NSTimeInterval)timeout;
/**
 stop config
 */
- (void)stopConfigWiFi;

//(Not recommended for use)
//========================
/**
 start smartwifi config
 
 @param ssid wifi name
 @param password wifi password
 @param token   token
 @param success
 @param failure retunr error
 */
- (void)activatorSmartWifi:(NSString *)ssid wifiPwd:(NSString *)password token:(NSString *)token success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 stop smartwifi config
 */
- (void)stopSmartWifi;


/**
 search device

 @param mode search mode
 @param success return device it will  multiple calls.
 @param failure return error
 */
- (void)startSearchDevice:(MeariDeviceSearchMode)mode success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 Add Device Manual
 
 @param device Searched device
 @param isNvr  is NVR device
 @param success return Part of device information
 @param failure return error
 */
- (void)addDevice:(MeariDevice *)device nvr:(BOOL)isNvr success:(void(^)(MeariDevice *camera))success failure:(MeariFailure)failure;

@end

NS_ASSUME_NONNULL_END
