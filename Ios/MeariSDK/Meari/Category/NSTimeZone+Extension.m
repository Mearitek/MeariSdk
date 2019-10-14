//
//  NSTimeZone+Extension.m
//  Meari
//
//  Created by 李兵 on 16/7/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "NSTimeZone+Extension.h"

@implementation NSTimeZone (Extension)
- (NSString *)wy_region {
    return self.name;
}
- (NSString *)wy_utcButDST {
    NSString *time;
    int seconds = (int)self.secondsFromGMT;
    if (self.isDaylightSavingTime) {
        seconds -= (int)self.daylightSavingTimeOffset;
    }
    int h = seconds/3600;
    int m = abs(seconds/60%60);
    if (seconds < 0) {
        time = [NSString stringWithFormat:@"UTC%+03d:%02d", h, m];
    }else {
        time = [NSString stringWithFormat:@"UTC%02d:%02d", h, m];
    }
    return time;
}
@end


@implementation NSTimeZone (WYSetting)

- (NSString *)timeString {
    NSString *time;
    int seconds = (int)self.secondsFromGMT;
    int h = seconds/3600;
    int m = abs(seconds/60%60);
    if (seconds < 0) {
        time = [NSString stringWithFormat:@"UTC%+03d:%02d", h, m];
    }else {
        time = [NSString stringWithFormat:@"UTC%02d:%02d", h, m];
    }
    return time;
}
+ (BOOL)isDaylightSavingTimeWithDeviceTimezone:(NSString *)timezone {
    BOOL deviceDST = NO;
    BOOL phoneDST = [NSTimeZone localTimeZone].isDaylightSavingTime;
    NSInteger deviceOffset = timezone.wy_secondsFromGMT;
    NSInteger phoneOffset = [NSTimeZone localTimeZone].secondsFromGMT;
    deviceDST = phoneDST ? (deviceOffset == phoneOffset) : (deviceOffset > phoneOffset);
    return deviceDST;
}
@end


@implementation NSString (WYTimeZone)

- (int)wy_secondsFromGMT {
    int seconds = 0;
    NSString *timezone = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    timezone = [timezone stringByReplacingOccurrencesOfString:@"UTC" withString:@""];
    int a = 1;
    if ([timezone containsString:@"+"]) {
        a = 1;
        timezone = [timezone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    if ([timezone containsString:@"-"]) {
        a = -1;
        timezone = [timezone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSArray *arr = [timezone componentsSeparatedByString:@":"];
    if (arr.count == 1) {
        NSString *h = arr[0];
        seconds = a*(h.intValue*3600);
    }else if (arr.count == 2) {
        NSString *h = arr[0];
        NSString *m = arr[1];
        seconds = a*(h.intValue*3600 + m.intValue*60);
    }else if (arr.count >= 3) {
        NSString *h = arr[0];
        NSString *m = arr[1];
        NSString *s = arr[2];
        seconds = a*(h.intValue*3600 + m.intValue*60 + s.intValue);
    }
    return seconds;
}
- (NSTimeInterval)wy_timeIntervalSince1970OfAppReleaseDate {
    if (self.length <= 0) return 0;
    
    NSTimeInterval timeInterval = 0;
    __block NSRange yearR, monthR, dayR, hourR, minuteR, secondR;
    NSRange range = NSMakeRange(0, self.length);
    NSDateComponents *dateC = [NSDateComponents new];
    [self enumerateSubstringsInRange:range options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        static int count1 = 1;
        static int count2 = 1;
        if ([substring isEqualToString:@"-"]) {
            switch (count1) {
                case 1: {
                    yearR = NSMakeRange(0, substringRange.location);
                    count1++;
                    break;
                }
                case 2: {
                    monthR = NSMakeRange(substringRange.location-2, 2);
                    dayR = NSMakeRange(substringRange.location+1, 2);
                    break;
                }
                default:
                    break;
            }
        }else if ([substring isEqualToString:@":"]) {
            switch (count2) {
                case 1: {
                    hourR = NSMakeRange(substringRange.location-2, 2);
                    count2++;
                    break;
                }
                case 2: {
                    minuteR = NSMakeRange(substringRange.location-2, 2);
                    secondR = NSMakeRange(substringRange.location+1, 2);
                    break;
                }
                default:
                    break;
            }
        }
    }];
    NSString *year, *month, *day, *hour, *minute, *second;
    if (yearR.location+yearR.length <= range.length) {
        year = [self substringWithRange:yearR];
    }
    if (monthR.location+monthR.length <= range.length) {
        month = [self substringWithRange:monthR];
    }
    if (dayR.location+dayR.length <= range.length) {
        day = [self substringWithRange:dayR];
    }
    if (hourR.location+hourR.length <= range.length) {
        hour = [self substringWithRange:hourR];
    }
    if (minuteR.location+minuteR.length <= range.length) {
        minute = [self substringWithRange:minuteR];
    }
    if (secondR.location+secondR.length <= range.length) {
        second = [self substringWithRange:secondR];
    }
    dateC.year = ABS(year.integerValue) ?: 0;
    dateC.month = ABS(month.integerValue) ?: 0;
    dateC.day = ABS(day.integerValue) ?: 0;
    dateC.hour = ABS(hour.integerValue) ?: 0;
    dateC.minute = ABS(minute.integerValue) ?: 0;
    dateC.second = ABS(second.integerValue) ?: 0;
    timeInterval = [[NSCalendar currentCalendar] dateFromComponents:dateC].timeIntervalSince1970;
    return timeInterval;
}
- (NSString *)wy_timezoneByOffsetSeconds:(int)seconds {
    return [self wy_timezoneWithSecondsFromGMT:self.wy_secondsFromGMT+seconds];
}
- (NSString *)wy_timezoneWithSecondsFromGMT:(int)seconds {
    int h = seconds/3600;
    int m = abs(seconds/60%60);
    if (seconds < 0) {
        return [NSString stringWithFormat:@"UTC%+03d:%02d", h, m];
    }
    return [NSString stringWithFormat:@"UTC%02d:%02d", h, m];
}

@end

@implementation NSDateComponents (WYTimeZone)

+ (instancetype)wy_dateComponetsOfUTC0WithTimestamp:(NSUInteger)timestamp {
    return [self _wy_dateComponetsOfWithTimestamp:timestamp timeZoneForSecondsFromGMT:0];
}
+ (instancetype)wy_dateComponetsOfUTCLocalWithTimestamp:(NSUInteger)timestamp {
    return [self _wy_dateComponetsOfWithTimestamp:timestamp timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
}
+ (instancetype)wy_dateComponetsOfWithTimestamp:(NSUInteger)timestamp deviceTimezone:(NSString *)deviceTimezone {
    return [self _wy_dateComponetsOfWithTimestamp:timestamp timeZoneForSecondsFromGMT:deviceTimezone.wy_secondsFromGMT];
}
+ (instancetype)_wy_dateComponetsOfWithTimestamp:(NSUInteger)timestamp timeZoneForSecondsFromGMT:(NSInteger)timeZoneForSecondsFromGMT {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *dateC = [WY_CurrentCalendar componentsInTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timeZoneForSecondsFromGMT] fromDate:date];
    return dateC;
}

@end
