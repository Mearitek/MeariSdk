//
//  WYRefreshNormalHeader.m
//  Meari
//
//  Created by 李兵 on 2017/3/1.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYRefreshNormalHeader.h"

@implementation WYRefreshNormalHeader
    
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey {
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    NSDate *lastUpdatedTime = [WY_UserDefaults objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar   = [NSCalendar currentCalendar];
        NSUInteger unitFlags   = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @" HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        if([cmp1 day] == [cmp2 day])
        {
            time = [NSString stringWithFormat:@"%@ %@", WYLocalString(@"Today"),time];
        }
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@ %@",
                                          WYLocalString(@"Latest"),
                                          time];
    } else {
        self.lastUpdatedTimeLabel.text = WYLocalString(@"Latest:No records");
    }
}
    
- (void)prepare {
    [super prepare];
    
    [self setTitle:WYLocalString(@"Pull-to-refresh")
          forState:MJRefreshStateIdle];
    [self setTitle:WYLocalString(@"Release-to-refresh")
          forState:MJRefreshStatePulling];
    [self setTitle:WYLocalString(@"Refreshing...")
          forState:MJRefreshStateRefreshing];
}
    
    
    
    
- (void)wy_setCameraTitle {
    [self setTitle:WYLocalString(@"Search Camera") forState:MJRefreshStateIdle];
    [self setTitle:WYLocalString(@"Release-To-SearchCamera") forState:MJRefreshStatePulling];
    [self setTitle:WYLocalString(@"SearchingCamera...") forState:MJRefreshStateRefreshing];
    [self setTitle:WYLocalString(@"Pull-To-SearchCamera") forState:MJRefreshStateWillRefresh];
    
}
    
- (void)wy_setNVRTitle {
    
    [self setTitle:WYLocalString(@"Search NVR") forState:MJRefreshStateIdle];
    [self setTitle:WYLocalString(@"Release-To-SearchNVR") forState:MJRefreshStatePulling];
    [self setTitle:WYLocalString(@"SeachingNVR...") forState:MJRefreshStateRefreshing];
    [self setTitle:WYLocalString(@"Pull-To-SearchNVR") forState:MJRefreshStateWillRefresh];
}

@end
