//
//  MeariDeviceFirmwareInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/14.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariDeviceFirmwareInfo : MeariBaseModel
@property (nonatomic, copy) NSString *upgradeUrl;           //url for update (设备升级地址)
@property (nonatomic, copy) NSString *latestVersion;        //latest version (设备最新版本)
@property (nonatomic, copy) NSString *upgradeDescription;   //latest version description (设备升级描述)
@property (nonatomic, assign) BOOL needUpgrade;             //whether need force upgrade or not (是否需要升级)
@property (nonatomic, assign) BOOL forceUpgrade;            //whether to force Upgrade (是否需要强制升级)
@property (nonatomic,   copy) NSString *appProtocolVer;    // App minimum protocol minimum supported version (app最低协议最低支持版本)
@property (nonatomic,   copy) NSString *fourGModeUrl;       //4G device module upgrade address(4G设备模组升级地址)
@property (nonatomic,   copy) NSString *fourGModeVersion;   //4G device module upgrade version(4G设备模组升级版本)
@end
