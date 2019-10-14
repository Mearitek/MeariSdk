//
//  WYWifiInfo.h
//  Meari
//
//  Created by 李兵 on 2016/11/17.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYWifiInfo : NSObject<NSCoding, NSCopying>
@property (nonatomic, copy)NSString *ssid;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *bssid;

@end
