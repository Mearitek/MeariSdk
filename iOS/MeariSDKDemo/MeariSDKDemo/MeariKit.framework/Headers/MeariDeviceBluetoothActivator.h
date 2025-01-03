//
//  MeariDeviceBluetoothActivator.h
//  MeariKit
//
//  Created by macbook on 2022/11/22.
//  Copyright © 2022 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MeariUser.h"
#import "MRBleAdvModel.h"
typedef void(^MeariSuccess_BluetoothPeripheral)(CBPeripheral * _Nullable peripheral, MRBleAdvModel * _Nullable model,NSString * _Nullable name);
API_AVAILABLE(ios(10.0))
typedef void(^MeariSearchFailure)(NSError * _Nullable error,CBManagerState state);
typedef NS_ENUM (NSInteger, MeariBluetoothErrorCode) {
    MeariBluetoothErrorCodeSuccesss = 10000,
    MeariBluetoothErrorCodeStateUnavailable = 10001,
    MeariBluetoothErrorCodeDisconnect = 10002,
    MeariBluetoothErrorCodeConnectFailure = 10003,
    MeariBluetoothErrorCodeNotifyFailure = 10004,
    MeariBluetoothErrorCodeWriteFailure = 10005,
    MeariBluetoothErrorCodeTokenFailure = 10006,
    MeariBluetoothErrorCodeAccess = 10007,
    MeariBluetoothErrorCodeNoWifi = 10008
    
};
NS_ASSUME_NONNULL_BEGIN
@class MeariDeviceBluetoothActivator;

@protocol MeariDeviceBluetoothActivatorDelegate<NSObject>
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error ;
@required

- (void)blueToothCentralManagerDidUpdateState:(nonnull CBCentralManager *)central;
- (void)blueToothCentralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;

@end

@interface MeariDeviceBluetoothActivator : NSObject

@property (nonatomic, weak) id<MeariDeviceBluetoothActivatorDelegate> delegate;

/**
 *  Single (单例)
 */
+ (instancetype)sharedInstance;

/**
 开启蓝牙搜索
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startSearchBluetoothDeviceWithSuccess:(MeariSuccess_BluetoothPeripheral)success failure:(MeariSearchFailure)failure API_AVAILABLE(ios(10.0));
/**
 停止蓝牙搜索
 */
- (void)stopSearchBluetoothDevice;

/**
 connect Bluetooth Device
 连接蓝牙设备
 
 @param peripheral Searched device (搜索到的设备)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)connectBluetoothDevice:(CBPeripheral *)peripheral success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 disconnect Bluetooth Device
 断开蓝牙设备
 
 @param peripheral Searched device (搜索到的设备)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)disconnectBluetoothDevice:(CBPeripheral *)peripheral success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 disconnect Bluetooth Device
 断开当前蓝牙设备
  
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)disconnectCurrentBluetoothDeviceWithsuccess:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Gets a list of Wi-Fi scanned by Bluetooth devices
 获取蓝牙设备扫描的wifi列表
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getDeviceWifiListWithSuccess:(MeariSuccess_String)success failure:(MeariFailure)failure;

/**
 add Bluetooth Device
 添加蓝牙设备
 
 @param wifi   wifi ssid(wifi 名)
 @param password   wifi password(wifi密码)
 @param token   user token(用户token)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)addBluetoothDeviceWithWifi:(NSString *)wifi password:(NSString *)password token:(NSString *)token success:(MeariSuccess_String)success failure:(MeariFailure)failure activeDeviceWifiBlock:(MeariSuccess_Dictionary)activeDeviceWifiBlock;
/**
 activate bluetooth device wifi
 激活蓝牙设备wifi
 */
@property(nonatomic, copy) MeariSuccess_Dictionary activeDeviceWifiBlock;

/**
 Activate Bluetooth device hotspot
 激活蓝牙设备热点
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)activeBluetoothDeviceWifiWithSuccess:(void(^)(NSString *wifiInfoString,NSString *deviceToken))success failure:(MeariFailure)failure;

/**
 get Bluetooth Device Token
 获取蓝牙设备token
 
 @param sn  device sn(设备sn)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getBluetoothTokenWithSn:(NSString *)sn success:(MeariSuccess_Token)success failure:(MeariFailure)failure;

/**
 Get 4G device SIM card information
 获取4G设备SIM卡信息
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getForthGDeviceSimInfoWithSuccess:(MeariSuccess_String)success failure:(MeariFailure)failure;

/**
 add 4G Device
 添加4G设备
 
 @param info   APN Info(APN 信息)
 @param token   user token(用户token)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)addForthGDeviceWithAPNInfo:(NSDictionary *)info token:(NSString *)token success:(MeariSuccess_String)success failure:(MeariFailure)failure ;

#pragma mark - Device Cap & Param
/**
 Get Bluetooth Device Capability
 获取蓝牙设备能力
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getDeviceCapabilityWithsuccess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
 Get Bluetooth Device Param
 获取蓝牙设备参数
 
 @param dp   DP Point
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getDeviceParamWithDP:(NSString *)dp success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Set Bluetooth Device Param
 设置蓝牙设备参数
 
 @param dp   DP Point
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setDeviceParamWithDP:(NSString *)dp jsonData:(NSString *)jsonData success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
@end

NS_ASSUME_NONNULL_END
