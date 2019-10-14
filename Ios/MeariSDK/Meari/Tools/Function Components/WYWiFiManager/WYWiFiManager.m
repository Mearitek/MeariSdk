//
//  WYWiFiManager.m
//  Meari
//
//  Created by 李兵 on 16/1/16.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYWiFiManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation WYWiFiManager
WY_Singleton_Implementation(WiFiManager)


#pragma mark - Public
- (WYWifiInfo *)currentWifi {
    CFArrayRef myArray = CNCopySupportedInterfaces();
    CFDictionaryRef info = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    NSDictionary* myDict = (__bridge NSDictionary *)info;
    if (!myDict) {
        return nil;
    }
    WYWifiInfo *wifi = [WYWifiInfo new];
    wifi.ssid = myDict[(NSString*)kCNNetworkInfoKeySSID];
    wifi.bssid = myDict[(NSString *)kCNNetworkInfoKeyBSSID];
    return wifi;
}

- (NSString *)currentSSID {
    return self.currentWifi.ssid;
}


@end
