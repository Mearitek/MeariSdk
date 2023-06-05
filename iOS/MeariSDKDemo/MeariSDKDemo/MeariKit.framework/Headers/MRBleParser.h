//
//  MRBleParser.h
//  Meari
//
//  Created by macbook on 2023/2/15.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRBleParseModel.h"
#import "MRBleAdvModel.h"
#include "mr_ble_app_protocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface MRBleParser : NSObject

+ (instancetype)shareInstance;

- (int)addSessionWithToken:(NSString *)token;

- (int)removeSessionWithContext:(int)context;

//解析广播数据
- (MRBleAdvModel *)parseAdvData:(NSData *)data;

//生成app包
- (NSData *)getAppDataWithContext:(int)context cmd:(MR_BLE_CMD_TYPE)commond data:(NSData *)data;
//解析app包
- (MRBleParseModel *)parseAppDataWithContext:(int)context data:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
