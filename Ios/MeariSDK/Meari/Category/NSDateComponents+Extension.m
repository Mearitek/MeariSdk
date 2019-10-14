//
//  NSDateComponents+Extension.m
//  Meari
//
//  Created by 李兵 on 16/7/8.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "NSDateComponents+Extension.h"

@implementation NSDateComponents (Extension)

+ (instancetype)todayZero {
    NSDateComponents *dateC = [WY_CurrentCalendar components:WY_UNIT_YMDHMS fromDate:[NSDate date]];
    dateC.hour   = 0;
    dateC.minute = 0;
    dateC.second = 0;
    return dateC;
}
- (instancetype)correctDateComponents {
    if (!self) return nil;
    NSDateComponents *d = self.copy;
    d.year = self.year;
    d.month = self.month;
    if (d.month > 12 || d.month < 1) {
        d = [WY_CurrentCalendar components:WY_UNIT_YMDHMS fromDate:[WY_CurrentCalendar dateFromComponents:d]];
    }
    return d;
}


/**
 天数
 */
- (NSInteger)wy_days {
    return self.year*365+self.month*30+self.day;
}

/**
 *  秒数
 */
- (int)secondsInday {
    return (int)self.hour*3600 + (int)self.minute*60 + (int)self.second;
}
- (void)setTimeWithSecond:(int)second {
    if (second >= 0 && second <= WYSecs_PerDay) {
        self.hour = second/3600;
        self.minute = second/60%60;
        self.second = second%60;
    }
}
+ (nullable NSDateComponents *)dateComponnentsWithSeconds:(int)seconds {
    if (seconds > 86400) return nil;
    
    NSDateComponents *dateC = [NSDateComponents new];
    dateC.hour = seconds/3600;
    dateC.minute = seconds/60%60;
    dateC.second = seconds%60;
    return dateC;
}


/**
 *  半小时时刻
 */
- (nullable NSDateComponents *)halfHourLaterIn24Hour {
    NSDateComponents *d = self.copy;
    d.minute += 30;
    if (d.secondsInday > 86400) return nil;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:d];
    NSDateComponents *dateC = [[NSCalendar currentCalendar] components:WY_Unit_Date_YMDHMS fromDate:date];
    return dateC;
}
- (NSDateComponents *)halfHourStartTime {
    NSDateComponents *d = [NSDateComponents new];
    d.year   = self.year;
    d.month  = self.month;
    d.day    = self.day;
    d.hour   = self.hour;
    d.second = 0;
    
    if (self.minute >= 0 && self.minute < 30) {
        d.minute = 0;
    }else {
        d.minute = 30;
    }
    if (self.secondsInday == 86400) {
        d.hour = 23;
        d.minute = 30;
    }
    
    return d;
}
- (NSDateComponents *)halfHourEndTime {
    NSDateComponents *d = [NSDateComponents new];
    d.year   = self.year;
    d.month  = self.month;
    d.day    = self.day;
    d.hour   = self.hour;
    d.second = 59;
    
    if (self.minute >= 0 && self.minute < 30) {
        d.minute = 29;
    }else if(self.minute >= 30 && self.minute < 60){
        d.minute = 59;
    }
    
    if (self.secondsInday == 86400) {
        d.hour = 23;
        d.minute = 59;
    }
    return d;
}

/**
 *  半小时时间段
 */
- (NSArray <NSDateComponents *> *)halfHourFragment {
    NSDateComponents *d1 = self.halfHourStartTime;
    NSDateComponents *d2 = self.halfHourEndTime;
    return @[d1,d2];
}
- (NSArray <NSString *> *)halfHourFragmentString {
    NSString *s1 = self.halfHourStartTime.timeStringWithNoSprit;
    NSString *s2 = self.halfHourEndTime.timeStringWithNoSprit;
    return @[s1, s2];
}

- (NSString *)monthStringWithSprit {
    return [NSString stringWithFormat:@"%04d/%02d",(int)self.year, (int)self.month];
}
- (NSString *)dayStringWithSprit {
    return [NSString stringWithFormat:@"%04d/%02d/%02d", (int)self.year, (int)self.month, (int)self.day];
}
- (NSString *)dayStringWithNoSprit {
    return [NSString stringWithFormat:@"%04d%02d%02d", (int)self.year, (int)self.month, (int)self.day];
}
- (NSString *)timeStringWithSprit {
    return [NSString stringWithFormat:@"%04d/%02d/%02d/%02d/%02d/%02d", (int)self.year, (int)self.month, (int)self.day, (int)self.hour, (int)self.minute, (int)self.second];
}
- (NSString *)timeStringWithNoSprit {
    return [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d", (int)self.year, (int)self.month, (int)self.day, (int)self.hour, (int)self.minute, (int)self.second];
}
- (NSString *)pureTimeStringWithNoSprit {
    return [NSString stringWithFormat:@"%02d%02d%02d" ,(int)self.hour, (int)self.minute, (int)self.second];
}

+ (nullable NSDateComponents *)dateComponentsWithFormatedTimeStringNoSprit:(NSString *)timeStringNoSprit {
    if (timeStringNoSprit.length < 6) return nil;
    
    NSDateComponents *dateC = [NSDateComponents new];
    dateC.hour = [timeStringNoSprit substringWithRange:NSMakeRange(0, 2)].integerValue;
    dateC.minute = [timeStringNoSprit substringWithRange:NSMakeRange(2, 2)].integerValue;
    dateC.second = [timeStringNoSprit substringWithRange:NSMakeRange(4, 2)].integerValue;
    
    return dateC;
}
+ (nullable NSDateComponents *)startDateComponentsWithFormatedHourFragmentStringNoSprit:(NSString *)hourFragmentStringNoSprit {
    if (hourFragmentStringNoSprit.length < 13) return nil;
    if ([hourFragmentStringNoSprit rangeOfString:@"-"].location == NSNotFound) return nil;
    NSRange range = [hourFragmentStringNoSprit rangeOfString:@"-"];
    NSString *startTime = [hourFragmentStringNoSprit substringToIndex:range.location];
    NSDateComponents *d = [NSDateComponents dateComponentsWithFormatedTimeStringNoSprit:startTime];
    return d;
}
+ (nullable NSDateComponents *)endDateComponentsWithFormatedHourFragmentStringNoSprit:(NSString *)hourFragmentStringNoSprit {
    if (hourFragmentStringNoSprit.length < 13) return nil;
    if ([hourFragmentStringNoSprit rangeOfString:@"-"].location == NSNotFound) return nil;
    NSRange range = [hourFragmentStringNoSprit rangeOfString:@"-"];
    NSString *endTime = [hourFragmentStringNoSprit substringFromIndex:range.location+range.length];
    NSDateComponents *d = [NSDateComponents dateComponentsWithFormatedTimeStringNoSprit:endTime];
    return d;
}
+ (nullable NSArray *)dateComponentsWithFormatedHourFragmentStringNoSprit:(NSString *)hourFragmentStringNoSprit {
    NSDateComponents *d1 = [NSDateComponents startDateComponentsWithFormatedHourFragmentStringNoSprit:hourFragmentStringNoSprit];
    NSDateComponents *d2  = [NSDateComponents endDateComponentsWithFormatedHourFragmentStringNoSprit:hourFragmentStringNoSprit];
    if (d1 && d2) {
        return @[d1,d2];
    }
    return nil;
}
+ (nullable instancetype)dateComponentsWithYMDHMSStringNoSprit:(NSString *)YMDHMSStringNoSprit {
    if (YMDHMSStringNoSprit.length == 14) {
        NSDateComponents *d = [NSDateComponents new];
        d.year = [YMDHMSStringNoSprit substringWithRange:NSMakeRange(0, 4)].integerValue;
        d.month = [YMDHMSStringNoSprit substringWithRange:NSMakeRange(4, 2)].integerValue;
        d.day = [YMDHMSStringNoSprit substringWithRange:NSMakeRange(6, 2)].integerValue;
        d.hour = [YMDHMSStringNoSprit substringWithRange:NSMakeRange(8, 2)].integerValue;
        d.minute = [YMDHMSStringNoSprit substringWithRange:NSMakeRange(10, 2)].integerValue;
        d.second = [YMDHMSStringNoSprit substringWithRange:NSMakeRange(12, 2)].integerValue;
        return d;
    }
    return nil;
}


+ (NSString *)halfHourFragmentStringWithStartTime:(NSDateComponents *)startTime endTime:(NSDateComponents *)endTime {
    return [NSString stringWithFormat:@"%@-%@", startTime.timeStringWithNoSprit, endTime.timeStringWithNoSprit];
}



@end


