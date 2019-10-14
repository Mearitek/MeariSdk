//
//  WYQRCodeModel.m
//  Meari
//
//  Created by 李兵 on 2017/5/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYQRCodeModel.h"

@implementation WYQRCodeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uuid" : @"id"};
}

- (BOOL)qrLoginIsValid {
    return self.tmpID.length > 0 && self.clientID.length > 0;
}
- (BOOL)qrDeviceIsValid {
    return self.uuid.length > 0 && (self.sn.length > 0 || self.serialno.length > 0);
}

@end


