//
//  MeariCloudOrderInfo.h
//  MeariKit
//
//  Created by chong liu on 2022/6/7.
//  Copyright © 2022 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MeariDeviceBindInfo;
typedef NS_ENUM(NSInteger, MeariServicePackageType) {
    MeariServicePackageTypeCloud2  = 0,   // 云存储2.0
    MeariServicePackageTypeAI      = 1,   // AI
    MeariServicePackageType4G      = 2,   // 4G
    MeariServicePackageTypeCloud1  = 3,   // 云存储1.0
};

@interface MeariCloudOrderInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger deviceId;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceIcon;
@end

@interface MeariCloudServiceInfo : MeariBaseModel
@property (nonatomic, assign) MeariServicePackageType packageType; // 0 ： 云存储, 1 ：AI, 2: 4G
@property (nonatomic, copy) NSString *trafficPackage; // (4G)流量单位:M/G
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, assign) NSInteger bindDeviceNum; // 套餐可绑定总数量
@property (nonatomic, assign) NSInteger bindedNum;  // 套餐当前已绑定数量
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *currencySymbol;
@property (nonatomic, assign) NSInteger storageType;
@property (nonatomic, assign) NSInteger unlimited; // 1(显示不限量)
@property (nonatomic, copy) NSString *mealType;   // 套餐时长: M ：月, S ：季, Y ：年
@property (nonatomic, copy) NSString *mealQuantity;   // 套餐时长数量
@property (nonatomic, assign) NSInteger mealCount;   // 套餐时长数量 int
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger quantity;    // 适用于4G
@property (nonatomic, assign) NSInteger serverTime;  // 适用于云存储
@property (nonatomic, assign) BOOL isSubPackage;  // 订单是否是订阅订单    0：其它    1：订阅
@property (nonatomic, assign) NSInteger trialDays; // 免费试用天数
@property (nonatomic, strong) NSArray<MeariDeviceBindInfo *> *bindDeviceList;
@property (nonatomic, assign) NSInteger AiType; // 1：云+AI套餐订单  0: 纯云套餐
@end

@interface MeariDeviceBindInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceIcon;
@property (nonatomic, assign) NSInteger bindOrderStatus;  // 绑定订单状态  0：未绑定订单    1：绑定订单
@property (nonatomic, assign) NSInteger unbindStatus;     // 设备解绑状态      0：未解绑   1： 解绑
@property (nonatomic, assign) NSInteger ai;               // 1:设备支持ai   0:设备不支持ai
@property (nonatomic, assign) NSInteger bindAiStatus;     // 0：未绑定订单    1：绑定订单
@end
NS_ASSUME_NONNULL_END
