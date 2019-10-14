//
//  NSDate+Extension.h
//  Meari
//
//  Created by 李兵 on 16/8/4.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
- (NSInteger)daysOfMonth;

- (NSDate *)ADayPrior;
- (NSDate *)ADayLater;

- (NSDate *)AMonthPrior;
- (NSDate *)AMonthLater;

- (NSInteger)weekDay;


- (NSString *)wy_localeString;

- (NSString *)WY_timeString;

@end
