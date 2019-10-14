//
//  WYCameraSettingSleepmodeTimesModel.m
//  Meari
//
//  Created by 李兵 on 2017/1/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepmodeTimesModel.h"

@implementation WYCameraSettingSleepmodeTimesModel

#pragma mark - Public
- (NSArray *)weekdaysNumArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:7];
    if (self.weekdays & WYCameraSettingSleepmodeMonday) {
        [arr addObject:@1];
    }
    if (self.weekdays & WYCameraSettingSleepmodeTuesday) {
        [arr addObject:@2];
    }
    if (self.weekdays & WYCameraSettingSleepmodeWednesday) {
        [arr addObject:@3];
    }
    if (self.weekdays & WYCameraSettingSleepmodeThursday) {
        [arr addObject:@4];
    }
    if (self.weekdays & WYCameraSettingSleepmodeFriday) {
        [arr addObject:@5];
    }
    if (self.weekdays & WYCameraSettingSleepmodeSaturday) {
        [arr addObject:@6];
    }
    if (self.weekdays & WYCameraSettingSleepmodeSunday) {
        [arr addObject:@7];
    }
    _weekdaysNumArr = arr.copy;
    return _weekdaysNumArr;
}
- (NSArray *)weekdaysStrArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:7];
    if (self.weekdays & WYCameraSettingSleepmodeMonday) {
        [arr addObject:WYLocalString(@"week_Monday")];
    }
    if (self.weekdays & WYCameraSettingSleepmodeTuesday) {
        [arr addObject:WYLocalString(@"week_Tuesday")];
    }
    if (self.weekdays & WYCameraSettingSleepmodeWednesday) {
        [arr addObject:WYLocalString(@"week_Wednesday")];
    }
    if (self.weekdays & WYCameraSettingSleepmodeThursday) {
        [arr addObject:WYLocalString(@"week_Thursday")];
    }
    if (self.weekdays & WYCameraSettingSleepmodeFriday) {
        [arr addObject:WYLocalString(@"week_Friday")];
    }
    if (self.weekdays & WYCameraSettingSleepmodeSaturday) {
        [arr addObject:WYLocalString(@"week_Saturday")];
    }
    if (self.weekdays & WYCameraSettingSleepmodeSunday) {
        [arr addObject:WYLocalString(@"week_Sunday")];
    }
    _weekdaysStrArr = arr.copy;
    return _weekdaysStrArr;
}
- (NSString *)weekdaysString {
    return [self.weekdaysStrArr componentsJoinedByString:@","];
}
- (instancetype)initWithParamsHomeSleepTime:(MeariDeviceParamSleepTime *)model {
    self = [super init];
    if (self) {
        self.enabled = model.enable;
        self.startTime = model.start_time;
        self.stopTime = model.stop_time;
        NSArray *repeat = model.repeat;
        for (NSNumber *num in repeat) {
            switch (num.integerValue) {
                case 1: {
                    self.weekdays |= WYCameraSettingSleepmodeMonday;
                    break;
                }
                case 2: {
                    self.weekdays |= WYCameraSettingSleepmodeTuesday;
                    break;
                }
                case 3: {
                    self.weekdays |= WYCameraSettingSleepmodeWednesday;
                    break;
                }
                case 4: {
                    self.weekdays |= WYCameraSettingSleepmodeThursday;
                    break;
                }
                case 5: {
                    self.weekdays |= WYCameraSettingSleepmodeFriday;
                    break;
                }
                case 6: {
                    self.weekdays |= WYCameraSettingSleepmodeSaturday;
                    break;
                }
                case 7: {
                    self.weekdays |= WYCameraSettingSleepmodeSunday;
                    break;
                }
                default:
                    break;
            }
        }
    }
    return self;
}
- (MeariDeviceParamSleepTime *)paramsHomeSleepTime {
    MeariDeviceParamSleepTime *time = [MeariDeviceParamSleepTime new];
    time.enable = self.enabled;
    time.start_time = self.startTime;
    time.stop_time = self.stopTime;
    time.repeat = self.weekdaysNumArr;
    return time;
}
- (id)copyWithZone:(NSZone *)zone {
    WYCameraSettingSleepmodeTimesModel *model = [WYCameraSettingSleepmodeTimesModel new];
    model.startTime = self.startTime;
    model.stopTime = self.stopTime;
    model.weekdays = self.weekdays;
    model.enabled = self.enabled;
    model.selected = self.selected;
    return model;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"startTime":self.startTime,
                                               @"stopTime":self.stopTime,
                                               @"enabled":@(self.enabled),
                                               @"weekdays":@(self.weekdays)
                                               }];
}

@end
