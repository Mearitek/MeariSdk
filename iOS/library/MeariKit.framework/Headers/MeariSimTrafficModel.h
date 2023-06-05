//
//  MeariSimTrafficModel.h
//  MeariKit
//
//  Created by macbook on 2022/8/5.
//  Copyright © 2022 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeariSimTrafficModel : NSObject
@property(nonatomic, copy) NSString *qtavalue;      //总流量（M）
@property(nonatomic, copy) NSString *qtabalance;    //剩余流量（M）
@property(nonatomic, copy) NSString *qtaconsumption;//已使用流量（M）
@property(nonatomic, copy) NSString *activeTime;    //激活时间
@property(nonatomic, copy) NSString *mealType;     //套餐类型
@property(nonatomic, copy) NSString *expireTime;    //过期时间
@property(nonatomic, copy) NSString *money;    //套餐金额
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量
@end

@interface MeariSimTrafficUnuseModel : NSObject
@property(nonatomic, copy) NSString *trafficPackage;    //激活时间
@property(nonatomic, copy) NSString *mealType;     //套餐类型
@property(nonatomic, copy) NSString *quantity;      //套餐流量
@property(nonatomic, copy) NSString *money;    //套餐金额
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量
    
@end

@interface MeariSimTrafficHistoryModel : NSObject
@property(nonatomic, copy) NSString *time;              //流量使用时间
@property(nonatomic, copy) NSString *qtaconsumption;    //套餐流量
@end

@interface MeariSimTrafficPlanModel : NSObject

@property(nonatomic, copy) NSString *planId;        //（套餐id，对应packageId）
@property(nonatomic, copy) NSString *mealType;      //（M是月套餐，S是季套餐）
@property(nonatomic, copy) NSString *money;         //套餐金额
@property(nonatomic, assign) NSInteger type;            //（0是试用，1是付费）
@property(nonatomic, assign) NSInteger quantity;        //套餐流量
@property(nonatomic, copy) NSString *trafficPackage;    //套餐流量单位
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, copy) NSString *currencySymbol;    //套餐金额单位
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量
@end

@interface MeariSimTrafficOrderModel : NSObject
@property(nonatomic, copy) NSString *orderNum;  //订单号
@property(nonatomic, copy) NSString *mealType;  //(月、季还是年 例 : @"M" @"S" @"Y" )
@property(nonatomic, copy) NSString *payMoney;  //订单金额
@property(nonatomic, copy) NSString *payDate;   //订单时间
@property(nonatomic, assign) NSInteger quantity;
@property(nonatomic, copy) NSString *trafficPackage;    //订单流量单位
@property(nonatomic, copy) NSString *trafficQuantity;   //订单流量数目
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, copy) NSString *currencySymbol;    //订单金额单位
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量
@end
