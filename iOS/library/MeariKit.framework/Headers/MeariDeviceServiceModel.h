//
//  MeariDeviceServiceModel.h
//  MeariKit
//
//  Created by duan on 2024/9/26.
//  Copyright © 2024 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariActCodeActivityModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, assign) NSInteger type; // 代表类型，0：云存储，1：AI，2：4G
@property (nonatomic, assign) BOOL isDisplayAct; // 控制是否显示 "去激活" 按钮
@end

@interface MeariDeviceServiceModel : NSObject
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, assign) NSInteger devTypeID; //7是4G设备
@property (nonatomic, assign) NSInteger useFactorySimCard;//是否是内置卡
@property (nonatomic, assign) BOOL freeFlow; //是否免流
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *afterSaleMail;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) MeariActCodeActivityModel *actCodeActivity;
@property (nonatomic, assign) BOOL freeCloudSwitch;  //非标配卡是否显示免费6S云存储开关
@end

