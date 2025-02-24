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
    MeariPackagePayTypeRussianPay    = 6,  // 俄罗斯支付支付
};
@class MeariTrafficSubscriberQuota;
@interface MeariBasePackage : MeariBaseModel
@property (nonatomic, copy) NSString *packageId;    // 套餐ID（如果是打折套餐则是打折套餐）
@property (nonatomic, copy) NSString *originalPackageId;  // 原始套餐ID
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

@property (nonatomic, copy) NSString *couponOfferId; // 折扣标识符（用于苹果支付）

@property (nonatomic, copy) NSString *couponSign;  // 折扣签名（用于苹果支付）

@property (nonatomic, copy) NSString *couponNonce; // 生成签名的nonce（用于苹果支付）

@property (nonatomic, assign) NSInteger couponTimestamp; // 生成签名的时间戳（用于苹果支付）

@property (nonatomic, copy) NSString *groupFlag; // 订阅群组标识
@property (nonatomic, assign, readonly) BOOL isSubscription; //是否是订阅,YES：表示是订阅，NO表示非订阅
@property (nonatomic, assign) BOOL isSubscriptionOrdered; //是否已经订阅了

@property (nonatomic, assign) int bindDeviceNum;
@end

@interface MeariCloudPackageInfo : MeariBasePackage

@property (nonatomic, copy) NSString *storageTime;

@property (nonatomic, copy) NSString *storageType;

@property (nonatomic, assign) int AiType;
@end

@interface MeariDataPackage : MeariBasePackage

@property(nonatomic, assign) NSInteger type;            //（0是试用，1是付费）
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量

@property(nonatomic, assign) NSInteger quantity;        //套餐流量
@property(nonatomic, copy) NSString *trafficPackage;    //套餐流量单位

@property(nonatomic, assign) NSInteger cloudType;      // 为1代表支持云存储
@property(nonatomic, assign) NSInteger expireTime;

@property(nonatomic, strong ) MeariTrafficSubscriberQuota *subscriberQuota; // 不为空表示是当前正在使用的流量包

+(MeariDataPackage *)dataPackageWithDictionary:(NSDictionary *)obj;
@end

@interface MeariTrafficSubscriberQuota : MeariBaseModel
@property(nonatomic, copy) NSString *qtavalue;
@property(nonatomic, copy) NSString *qtabalance;
@property(nonatomic, copy) NSString *qtaconsumption;
@property(nonatomic, assign) NSInteger expireTime;
@property(nonatomic, assign) NSInteger unlimited;
@property(nonatomic, copy) NSString *packageId;
@property(nonatomic, copy) NSString *groupFlag;
@property(nonatomic, assign) NSInteger cloudType;
/** 是否是试用，1-试用，0-正常 */
@property(nonatomic, assign) NSInteger trialType;
@end

@interface MeariTrialPackage : MeariBaseModel
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, assign) MeariPackageType packageType;
@property (nonatomic, copy) NSString *storageType;
@property (nonatomic, copy) NSString *mealType;
@property(nonatomic, assign) NSInteger serverTime;
@property (nonatomic, assign) int aiType;
@property (nonatomic, assign) int cloudType;
@end

@interface MeariTrialOrder : MeariTrialPackage
@property(nonatomic, copy) NSString *orderNum;
@property (nonatomic, assign) NSInteger trialTime;

+(instancetype)trialOrderWithPackage:(MeariTrialPackage *)package;
@end

NS_ASSUME_NONNULL_END
