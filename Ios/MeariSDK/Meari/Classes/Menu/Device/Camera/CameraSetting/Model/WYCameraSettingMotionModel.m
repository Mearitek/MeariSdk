//
//  WYCameraSettingMotionModel.m
//  Meari
//
//  Created by 李兵 on 2017/8/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingMotionModel.h"

@implementation WYCameraSettingMotionModel
+ (instancetype)modelWithText:(NSString *)text
                 detailedText:(NSString *)detailedText
                     selected:(BOOL)selected
                        level:(MeariDeviceLevel)level{
    WYCameraSettingMotionModel *model = [WYCameraSettingMotionModel new];
    model.text = text;
    model.detailedText = detailedText;
    model.selected = selected;
    model.level = level;
    return model;
}

+ (instancetype)motionSwitch {
    return [self modelWithText:WYLocalString(@"motion")
                  detailedText:nil
                      selected:NO
                         level:MeariDeviceLevelNone];
}
+ (instancetype)motionLow {
    return [self modelWithText:WYLocalString(@"motion_low")
                  detailedText:WYLocalString(@"motion_low_des")
                      selected:NO
                         level:MeariDeviceLevelLow];
}
+ (instancetype)motionMedium {
    return [self modelWithText:WYLocalString(@"motion_medium")
                  detailedText:WYLocalString(@"motion_medium_des")
                      selected:NO
                         level:MeariDeviceLevelMedium];
}
+ (instancetype)motionHigh {
    return [self modelWithText:WYLocalString(@"motion_high")
                  detailedText:WYLocalString(@"motion_high_des")
                      selected:NO
                         level:MeariDeviceLevelHigh];
}

@end
