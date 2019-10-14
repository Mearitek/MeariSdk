//
//  WYWiFiManager.h
//  Meari
//
//  Created by 李兵 on 16/1/16.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYWifiInfo.h"
#define WY_WiFiM [WYWiFiManager sharedWiFiManager]
@interface WYWiFiManager : NSObject
WY_Singleton_Interface(WiFiManager)

@property (nonatomic, strong) WYWifiInfo *currentWifi;
@property (nonatomic, strong) NSString *currentSSID;


@end
