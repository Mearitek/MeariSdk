//
//  MRBleParseModel.h
//  Meari
//
//  Created by macbook on 2023/2/15.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "mr_ble_app_protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRBleParseModel : NSObject
@property(nonatomic, assign) int type;

@property(nonatomic, copy) NSString *respStr;

@property(nonatomic, strong) NSDictionary *respDict;

+ (instancetype)modelWithCmdType:(int)type packet:(MR_BLE_APP_PACKET)packet;

+ (instancetype)modelWithCmdType:(int)type respString:(NSString *)resp;
@end

NS_ASSUME_NONNULL_END
