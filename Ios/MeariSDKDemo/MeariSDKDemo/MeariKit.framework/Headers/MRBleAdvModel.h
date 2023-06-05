//
//  MRBleAdvModel.h
//  Meari
//
//  Created by macbook on 2023/2/15.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "mr_ble_app_protocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface MRBleAdvModel : NSObject
@property(nonatomic, assign)int wifiId;//wifi标识
@property(nonatomic, assign)int version;//广播版本号
@property(nonatomic, assign)int netConfig;//开启配网标记 0x00 0x01
@property(nonatomic, assign)int hasOwner;//是否已经被用户绑定
@property(nonatomic, copy)NSString *sn;//sn
@property(nonatomic, assign)int hasScanWifi;//WIFI模块类型
@property(nonatomic, copy)NSString *reserved;//预留

+ (instancetype)modelWithMagic:(NSString *)magic version:(NSString *)version netConfig:(NSString *)net owner:(NSString *)own sn:(NSString *)sn wifi:(NSString *)wifi reserved:(NSString *)reserved;
@end

NS_ASSUME_NONNULL_END
