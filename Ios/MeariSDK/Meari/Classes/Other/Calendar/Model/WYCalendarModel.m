//
//  WYCalendarModel.m
//  Meari
//
//  Created by 李兵 on 16/8/4.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCalendarModel.h"

@implementation WYCalendarModel
- (NSString *)description {
    return [NSString stringWithFormat:@"date:%@, hasVideo:%d, selected:%d", _date, _hasVideo, _selected];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.date = [NSDateComponents todayZero];
    }
    return self;
}

@end
