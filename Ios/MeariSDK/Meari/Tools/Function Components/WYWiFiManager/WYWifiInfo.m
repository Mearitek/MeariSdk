//
//  WYWifiInfo.m
//  Meari
//
//  Created by 李兵 on 2016/11/17.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYWifiInfo.h"

@implementation WYWifiInfo
WY_CoderAndCopy


- (NSString *)description {
    return @{@"ssid":WY_SafeStringValue(self.ssid),
             @"bssid":WY_SafeStringValue(self.bssid),
             @"password":WY_SafeStringValue(self.password)
             }.description;
}

@end
