//
//  WYParamTransfer.m
//  Meari
//
//  Created by FMG on 2018/6/9.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYParamTransfer.h"

@implementation WYParamTransfer
WY_Singleton_Implementation(ParamTransfer)
- (void)resetParamsType:(WYParamTransferType)type {
    if (type == WYParamTransferType_add) {
        self.autoAdd = YES;
        self.selectedKindModel = nil;
        self.wifiInfo = nil;
    }
}
@end
