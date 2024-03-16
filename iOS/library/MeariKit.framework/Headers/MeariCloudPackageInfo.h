//
//  MeariCloudPackageInfo.h
//  MeariKit
//
//  Created by chong liu on 2022/6/8.
//  Copyright © 2022 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, MeariPackageType) {
    MeariPackageTypeCloud2   = 0,  // 云存储2.0
    MeariPackageTypeAI       = 1,  // AI
    MeariPackageType4G       = 2,  // 4G
    MeariPackageTypeCloud1   = 3,  // 云存储1.0
};
typedef NS_ENUM (NSInteger, MeariPackagePayType) {
    MeariPackagePayTypeAliPay   = 1,  // Alipay
    MeariPackagePayTypePaypal   = 2,  // Paypal
    MeariPackagePayTypeGoogle   = 3,  // 谷歌支付
    MeariPackagePayTypeApple    = 4,  // 苹果支付
};
@interface MeariBasePackage : MeariBaseModel
@property (nonatomic, copy) NSString *packageId;    // 套餐ID
@property (nonatomic, copy) NSString *mealType;     //（M是月套餐，S是季套餐）
@property (nonatomic, copy) NSString *mealQuantity;   // 套餐时长数量
@property (nonatomic, assign) NSInteger mealCount;   // 套餐时长数量 int
@property (nonatomic, copy) NSString *money;         //套餐金额
@property (nonatomic, copy) NSString *moneyThreshold;  //Paypal套餐使用，为small时为小额支付
@property (nonatomic, copy) NSString *clientId;       // Paypal支付的收款账号
@property (nonatomic, copy) NSString *currencyCode;  //套餐金额符号
@property (nonatomic, copy) NSString *currencySymbol; //套餐金额单位

@property (nonatomic, assign) MeariPackageType packageType; // 0：云存储  1：AI  2: 4G

@property (nonatomic, assign) MeariPackagePayType payType;    //Alipay=1 paypal=2 google=3 apple=4

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, strong) SKProduct *product;

@property (nonatomic, copy) NSString *discountProductId;//废弃

@property (nonatomic, copy) NSString *discountProductIdNew;   // 优惠套餐的productId

@property (nonatomic, strong) SKProduct *discountProduct;

@property (nonatomic, copy) NSString *discountMoney; //折后价

@property (nonatomic, assign) BOOL discountSale; //true使用折扣价格/false使用正常价格

@property (nonatomic, assign) NSInteger discountExpirationDate;  // 折扣过期时间

@property (nonatomic, copy) NSString *discount; //打几折，如:0.7

@property (nonatomic, assign) NSInteger startTime;  // 折扣开始时间

@property (nonatomic, assign) NSInteger endTime;    // 折扣结束时间
@end

@interface MeariCloudPackageInfo : MeariBasePackage

@property (nonatomic, copy) NSString *storageTime;

@property (nonatomic, copy) NSString *storageType;

@property (nonatomic, assign) int bindDeviceNum;

@property (nonatomic, assign) int AiType;

@property (nonatomic, copy) NSString *groupFlag; // 订阅群组标识

@property (nonatomic, assign, readonly) BOOL isSubscription; //是否是订阅,YES：表示是订阅，NO表示非订阅
@property (nonatomic, assign) BOOL isSubscriptionOrdered; //是否已经订阅了

@end

@interface MeariDataPackage : MeariBasePackage

@property(nonatomic, assign) NSInteger type;            //（0是试用，1是付费）
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量

@property(nonatomic, assign) NSInteger quantity;        //套餐流量
@property(nonatomic, copy) NSString *trafficPackage;    //套餐流量单位

+(MeariDataPackage *)dataPackageWithDictionary:(NSDictionary *)obj;
@end

NS_ASSUME_NONNULL_END
