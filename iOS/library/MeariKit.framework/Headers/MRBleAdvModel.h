//
//  MRBleAdvModel.h
//  Meari
//
//  Created by macbook on 2023/2/15.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "mr_ble_app_protocol.h"
typedef NS_ENUM(NSUInteger, MRBleWifiMode){
    MRBleWifiModeDuplex = 0,//双工模式
    MRBleWifiModeSimplex = 1,//单工模式
    MRBleWifiModeHalfDuplex = 2,//半双工模式
};
NS_ASSUME_NONNULL_BEGIN

@interface MRBleAdvModel : NSObject
@property(nonatomic, assign)int wifiId;//wifi标识
@property(nonatomic, assign)int version;//广播版本号
@property(nonatomic, assign)int netConfig;//开启配网标记 0x00 0x01
@property(nonatomic, assign)int hasOwner;//是否已经被用户绑定
@property(nonatomic, copy)NSString *sn;//sn
@property(nonatomic, assign)MRBleWifiMode wifiMode;//WIFI模块类型
@property(nonatomic, copy)NSString *reserved;//预留
@property(nonatomic, assign)char lastByte;//最后一个字节
@property(nonatomic, assign)BOOL addByBase;//是否添加到Base
@property(nonatomic, assign)BOOL addByNVR;//是否添加到NVR
@property(nonatomic, assign)BOOL configStaticIP;//是否支持配置静态IP

+ (instancetype)modelWithMagic:(NSString *)magic version:(int)version netConfig:(int)net owner:(int)own sn:(NSString *)sn wifiMode:(int)wifiMode reserved:(NSString *)reserved lastByte:(char)byte;
@end

NS_ASSUME_NONNULL_END
