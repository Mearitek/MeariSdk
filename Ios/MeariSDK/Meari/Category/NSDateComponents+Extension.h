//
//  NSDateComponents+Extension.h
//  Meari
//
//  Created by 李兵 on 16/7/8.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WY_UNIT_YMDHMS      NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond

NS_ASSUME_NONNULL_BEGIN
@interface NSDateComponents (Extension)


+ (instancetype)todayZero;              //今天0点
- (instancetype)correctDateComponents;  //正确的时间


/**
 天数
 */
- (NSInteger)wy_days;

/**
 *  秒数
 */
- (int)secondsInday;
- (void)setTimeWithSecond:(int)second;  //设置时分秒
+ (nullable NSDateComponents *)dateComponnentsWithSeconds:(int)seconds; //超过86400，则为nil

/**
 *  半小时时刻
 */
- (nullable NSDateComponents *)halfHourLaterIn24Hour;   //半小时后（超过24:00:00，则为nil）
- (NSDateComponents *)halfHourStartTime;                //半小时开始时间
- (NSDateComponents *)halfHourEndTime;                  //半小时结束时间

/**
 *  半小时时间段
 */
- (NSArray <NSDateComponents *> *)halfHourFragment;     //半小时段
- (NSArray <NSString *> *)halfHourFragmentString;       //半小时段：字符串

/**
 *  字符串
 */
- (NSString *)monthStringWithSprit;     //月：（2016/07）
- (NSString *)dayStringWithSprit;       //日：（2016/07/08）
- (NSString *)dayStringWithNoSprit;     //日：（20160708）
- (NSString *)timeStringWithSprit;      //时间：（2016/07/06/08/05/09）
- (NSString *)timeStringWithNoSprit;    //时间：（20160706080509）
- (NSString *)pureTimeStringWithNoSprit;    //纯时间:010102


+ (nullable NSDateComponents *)dateComponentsWithFormatedTimeStringNoSprit:(NSString *)timeStringNoSprit;
+ (nullable NSDateComponents *)startDateComponentsWithFormatedHourFragmentStringNoSprit:(NSString *)hourFragmentStringNoSprit;
+ (nullable NSDateComponents *)endDateComponentsWithFormatedHourFragmentStringNoSprit:(NSString *)hourFragmentStringNoSprit;
+ (nullable NSArray *)dateComponentsWithFormatedHourFragmentStringNoSprit:(NSString *)hourFragmentStringNoSprit;
+ (nullable instancetype)dateComponentsWithYMDHMSStringNoSprit:(NSString *)YMDHMSStringNoSprit;

//时间段： 20160708010315-20160708011119
+ (NSString *)halfHourFragmentStringWithStartTime:(NSDateComponents *)startTime endTime:(NSDateComponents *)endTime;

@end

NS_ASSUME_NONNULL_END
