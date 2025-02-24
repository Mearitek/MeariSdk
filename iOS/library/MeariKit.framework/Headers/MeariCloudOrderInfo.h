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
@class MeariServiceRefund;
typedef NS_ENUM(NSInteger, MeariServicePackageType) {
    MeariServicePackageTypeCloud2  = 0,   // 云存储2.0
    MeariServicePackageTypeAI      = 1,   // AI
    MeariServicePackageType4G      = 2,   // 4G
    MeariServicePackageTypeCloud1  = 3,   // 云存储1.0
};
typedef NS_ENUM(NSInteger, MeariServiceRefundStatus) {
    MeariServiceRefundStatusInitial      = 0,   // 初始状态
    MeariServiceRefundStatusReviewing    = 1,   // 正在审核
    MeariServiceRefundStatusRefunded     = 2,   // 成功退款
    MeariServiceRefundStatusRejected     = 3,   // 已拒绝退款
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
@property (nonatomic, strong) NSArray<MeariDeviceBindInfo *> *bindDeviceList; // 已绑定的设备列表
@property (nonatomic, strong) NSArray<MeariDeviceBindInfo *> *bindableDeviceList; //可绑定的设备列表
@property (nonatomic, assign) NSInteger AiType; // 1：云+AI套餐订单  0: 纯云套餐
@property (nonatomic, assign) NSInteger cloudType; // 1：4G+云存储套餐订单  0: 其他
@property (nonatomic, copy) NSString *simServerStartTime; //流量服务开始时间
@property (nonatomic, copy) NSString *simServerEndTime; //流量服务结束时间
@property (nonatomic, copy) NSString *cloudServerStartTime; //云存储服务开始时间
@property (nonatomic, copy) NSString *cloudServerEndTime; //云存储服务结束时间
@property (nonatomic, assign) NSInteger supportCancelSub; // 是否允许取消订阅，1:支持 2:已取消
@property (nonatomic, copy) NSString *subID;  // 取消的订阅ID
@property (nonatomic, strong) MeariServiceRefund *refund;
@end

@interface MeariDeviceBindInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceIcon;
@property (nonatomic, assign) NSInteger bindOrderStatus;  // 绑定订单状态  0：未绑定订单    1：绑定订单
@property (nonatomic, assign) NSInteger unbindStatus;     // 设备解绑状态      0：未解绑   1： 解绑
@property (nonatomic, assign) NSInteger ai;               // 1:设备支持ai   0:设备不支持ai
@property (nonatomic, assign) NSInteger bindAiStatus;     // 0：未绑定订单    1：绑定订单
@property (nonatomic, assign) NSInteger cst;
@property (nonatomic, assign) NSInteger evt;
@property (nonatomic, assign) NSInteger cloudServerStartTime;
@property (nonatomic, assign) NSInteger cloudServerEndTime;
@property (nonatomic, assign) NSInteger aiServerStartTime;
@property (nonatomic, assign) NSInteger aiServerEndTime;
@property (nonatomic, assign) NSInteger flow4gServerStartTime;
@property (nonatomic, assign) NSInteger flow4gServerEndTime;
@property (nonatomic, assign) BOOL canReleasable;        // 是否可以解绑
@end

@interface MeariServiceRefund : MeariBaseModel
//主键id 后续撤销退款需要该id
@property (nonatomic, copy) NSString *refundId;
//是否支持再次退款  true:支持  false：不支持
@property (nonatomic, assign) BOOL supportRefund;
//退款状态   0:初始状态  1:正在审核  2：成功退款  3：已拒绝退款
@property (nonatomic, assign) MeariServiceRefundStatus status;
//实际退款金额
@property (nonatomic, copy) NSString *actualRefundMoney;
@end
NS_ASSUME_NONNULL_END
