//
//  WYCameraSettingSleepmodeTimesModel.h
//  Meari
//
//  Created by 李兵 on 2017/1/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSInteger, WYCameraSettingSleepmodeWeekdays) {
    WYCameraSettingSleepmodeMonday      = 1 << 0,
    WYCameraSettingSleepmodeTuesday     = 1 << 1,
    WYCameraSettingSleepmodeWednesday   = 1 << 2,
    WYCameraSettingSleepmodeThursday    = 1 << 3,
    WYCameraSettingSleepmodeFriday      = 1 << 4,
    WYCameraSettingSleepmodeSaturday    = 1 << 5,
    WYCameraSettingSleepmodeSunday      = 1 << 6
};

@interface WYCameraSettingSleepmodeTimesModel : NSObject<NSCopying>
//原始数据
@property (nonatomic, copy)MeariDeviceParamSleepTime *time;
@property (nonatomic, copy)NSString *timeDuration;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *stopTime;
@property (nonatomic, assign)BOOL enabled;
@property (nonatomic, assign)WYCameraSettingSleepmodeWeekdays weekdays;

//扩展
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, strong)NSArray *weekdaysNumArr;
@property (nonatomic, strong)NSArray *weekdaysStrArr;
@property (nonatomic, copy)NSString *weekdaysString;

- (instancetype)initWithParamsHomeSleepTime:(MeariDeviceParamSleepTime *)model;
- (MeariDeviceParamSleepTime *)paramsHomeSleepTime;


@end
