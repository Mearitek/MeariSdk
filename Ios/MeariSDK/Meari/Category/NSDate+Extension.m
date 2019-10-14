//
//  NSDate+Extension.m
//  Meari
//
//  Created by 李兵 on 16/8/4.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (NSInteger)daysOfMonth {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (NSDate *)ADayPrior {
    return [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970 - 86400];
}
- (NSDate *)ADayLater {
    return [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970 + 86400];
}

- (NSDate *)AMonthPrior {
    NSDateComponents *d = [[NSCalendar currentCalendar] components:WY_Unit_Date_YMDHMS fromDate:self];
    d.month-=1;
    return [[NSCalendar currentCalendar] dateFromComponents:d];
}
- (NSDate *)AMonthLater {
    NSDateComponents *d = [[NSCalendar currentCalendar] components:WY_Unit_Date_YMDHMS fromDate:self];
    d.month+=1;
    return [[NSCalendar currentCalendar] dateFromComponents:d];
}

- (NSInteger)weekDay {
    NSDateComponents *dateC = [[NSCalendar currentCalendar] components:WY_Unit_Date_YMDHMS | NSCalendarUnitWeekday fromDate:self];
    return dateC.weekday;
}

- (NSString *)wy_localeString {
    if (!self) return nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:[NSBundle wy_bundledLanguage]] ?: [NSLocale currentLocale];
    formatter.dateStyle = NSDateFormatterLongStyle;
    NSString *dateStr   = [formatter stringFromDate:self];
    return dateStr;
}
- (NSString *)WY_timeString {
    if (!self) return nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm";
    NSString *str = [formatter stringFromDate:self];
    
    if ([self isToday]) {
        formatter.dateFormat = @"HH:mm";
        str = [NSString stringWithFormat:@"%@ %@",WYLocalString(@"Today"), [formatter stringFromDate:self]];
    }
    return str;
}
- (BOOL)isToday {
    if (!self) return NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *str = [formatter stringFromDate:self];
    NSString *todayStr = [formatter stringFromDate:[NSDate date]];
    return [str isEqualToString:todayStr];
}
@end
