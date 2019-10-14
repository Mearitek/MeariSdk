//
//  NSTimeZone+Extension.h
//  Meari
//
//  Created by 李兵 on 16/7/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimeZone (Extension)
- (NSString *)wy_region;
- (NSString *)wy_utcButDST;
@end


@interface NSTimeZone (WYSetting)
- (NSString *)timeString;
+ (BOOL)isDaylightSavingTimeWithDeviceTimezone:(NSString *)timezone;
@end


@interface NSString (WYTimeZone)
- (int)wy_secondsFromGMT;
- (NSTimeInterval)wy_timeIntervalSince1970OfAppReleaseDate;
- (NSString *)wy_timezoneByOffsetSeconds:(int)seconds;
- (NSString *)wy_timezoneWithSecondsFromGMT:(int)seconds;

@end


@interface NSDateComponents (WYTimeZone)
+ (instancetype)wy_dateComponetsOfUTC0WithTimestamp:(NSUInteger)timestamp;
+ (instancetype)wy_dateComponetsOfUTCLocalWithTimestamp:(NSUInteger)timestamp;
+ (instancetype)wy_dateComponetsOfWithTimestamp:(NSUInteger)timestamp deviceTimezone:(NSString *)deviceTimezone;
@end
