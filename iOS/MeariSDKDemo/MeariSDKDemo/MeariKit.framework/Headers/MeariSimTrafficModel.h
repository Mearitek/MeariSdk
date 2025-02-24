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
@property(nonatomic, copy) NSString *mealQuantity;  //订单年份数量
@property(nonatomic, assign) NSInteger mealCount;  //订单年份数量
@property(nonatomic, copy) NSString *expireTime;    //过期时间
@property(nonatomic, copy) NSString *money;    //套餐金额
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量
@property(nonatomic, assign) NSInteger trialType;    //1 为试用套餐
@end

@interface MeariSimTrafficUnuseModel : NSObject
@property(nonatomic, copy) NSString *trafficPackage;    //单位
@property(nonatomic, copy) NSString *mealType;     //套餐类型
@property(nonatomic, copy) NSString *mealQuantity;  //订单年份数量
@property(nonatomic, assign) NSInteger mealCount;  //订单年份数量
@property(nonatomic, copy) NSString *quantity;      //套餐流量
@property(nonatomic, copy) NSString *money;    //套餐金额
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量
@property(nonatomic, assign) NSInteger trialType;    //1 为试用套餐
    
@end

@interface MeariSimTrafficHistoryModel : NSObject
@property(nonatomic, copy) NSString *time;              //流量使用时间
@property(nonatomic, copy) NSString *qtaconsumption;    //套餐流量
@end

@interface MeariSimTrafficPlanModel : NSObject

@property(nonatomic, copy) NSString *planId;    //（套餐id，对应packageId）
@property(nonatomic, copy) NSString *mealType;  //套餐类型（W-周 M-月 S-季 X-半年 Y-年）
@property(nonatomic, copy) NSString *money;         //套餐金额
@property(nonatomic, assign) NSInteger type;            //（0是试用，1是付费）
@property(nonatomic, assign) NSInteger quantity;        //套餐流量
@property(nonatomic, copy) NSString *trafficPackage;    //套餐流量单位
@property(nonatomic, copy) NSString *currencyCode;      //套餐国家代号
@property(nonatomic, copy) NSString *currencySymbol;    //套餐金额单位
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量套餐
@end

@interface MeariSimTrafficOrderModel : NSObject
@property(nonatomic, copy) NSString *orderNum;  //订单号
@property(nonatomic, copy) NSString *mealType;  //(月、季还是年 例 : @"M" @"S" @"Y" )
@property(nonatomic, copy) NSString *mealQuantity;  //订单年份数量
@property(nonatomic, assign) NSInteger mealCount;  //订单年份数量
@property(nonatomic, copy) NSString *payMoney;  //订单金额
@property(nonatomic, copy) NSString *payDate;   //订单时间
@property(nonatomic, assign) NSInteger quantity;    //套餐数量，暂时仅支持单个购买（未使用）
@property(nonatomic, copy) NSString *trafficPackage;    //订单流量单位
@property(nonatomic, copy) NSString *trafficQuantity;   //订单流量数目
@property(nonatomic, copy) NSString *currencyCode;      //套餐国家代号
@property(nonatomic, copy) NSString *currencySymbol;    //订单金额单位
@property(nonatomic, assign) NSInteger payType;    //支付类型
@property(nonatomic, assign) NSInteger unlimited;    //1 为不限量
@end

@interface MeariSimTrafficStatusModel : NSObject
@property(nonatomic, assign) NSInteger reminder;  //提醒
@property(nonatomic, assign) NSInteger status;    //提醒状态， 0-未到期 1-已到期 2-即将到期
@property(nonatomic, assign) NSInteger isForce;   //是否强制提醒 false:返回countDownSecond（倒计时）字段
@property(nonatomic, assign) NSInteger countDownSecond; //默认值为0, 表示轻提醒多少秒后自动关闭
@property(nonatomic, copy) NSString *serverEndTime; //4G服务到期时间
@property(nonatomic, assign) NSInteger serverEndTimeAdventPeriod;  //4G服务是否到期
@property(nonatomic, assign) NSInteger trialType; //是否是试用套餐
@property(nonatomic, assign) NSInteger packageTime;    //当前正在使用套餐时长 (毫秒值)，返回此字段表明已免费获得该时长的流量服务
@end

@interface MeariSimApnModel : NSObject
@property(nonatomic, copy) NSString *apn;  //apn
@property(nonatomic, copy) NSString *mnc;    //mnc
@property(nonatomic, copy) NSString *mcc;   //mcc
//@property(nonatomic, copy) NSString *mvno_type; //类型
//@property(nonatomic, copy) NSString *mvno_match_data; //匹配数据
@end
