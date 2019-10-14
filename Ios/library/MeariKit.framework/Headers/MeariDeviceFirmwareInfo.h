//
//  MeariDeviceFirmwareInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/14.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariDeviceFirmwareInfo : MeariBaseModel
@property (nonatomic, copy) NSString *upgradeUrl;           //url for update
@property (nonatomic, copy) NSString *latestVersion;        //latest version
@property (nonatomic, copy) NSString *upgradeDescription;   //latest version description
@property (nonatomic, assign) BOOL needUpgrade;             //whether need force upgrade or not
@property (nonatomic, assign) BOOL forceUpgrade;            //whether to force Upgrade
@end
