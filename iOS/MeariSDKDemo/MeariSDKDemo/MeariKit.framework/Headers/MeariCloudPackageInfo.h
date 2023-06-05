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

@interface MeariCloudPackageInfo : MeariBaseModel
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *storageTime;
@property (nonatomic, copy) NSString *mealType;
@property (nonatomic, copy) NSString *storageType;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) int bindDeviceNum;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *currencySymbol;
@property (nonatomic, assign) BOOL discountSale; //true使用折扣价格/false使用正常价格
@property (nonatomic, assign) NSInteger discountExpirationDate;  // 折扣过期时间
@property (nonatomic, copy) NSString *discountMoney; //折后价
@property (nonatomic, assign) int packageAiType; ////1是AI套餐1；2是AI套餐2
@property (nonatomic, assign) int payType;    //Alipay=1 paypal=2 google=3 apple=4

@property (nonatomic, assign) BOOL aiOrCloud; // true表示ai套餐，false表示云存储套餐
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *discountProductId;
@property (nonatomic, copy) NSString *groupFlag; // 订阅群组标识
@property (nonatomic, assign, readonly) BOOL isSubscription; //是否是订阅,YES：表示是订阅，NO表示非订阅
@property (nonatomic, assign) BOOL isSubscriptionOrdered; //是否已经订阅了
@property (nonatomic, strong) SKProduct *product;
@property (nonatomic, strong) SKProduct *discountProduct;

@end

NS_ASSUME_NONNULL_END
