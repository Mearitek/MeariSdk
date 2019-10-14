//
//  WYDoorBellSettingPIRDetection.m
//  Meari
//
//  Created by FMG on 2017/7/25.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingPIRDetection.h"

@implementation WYDoorBellSettingPIRDetection
+ (instancetype)modelWithText:(NSString *)text
                 detailedText:(NSString *)detailedText
                         type:(MeariDeviceSleepmode)type{
    WYDoorBellSettingPIRDetection *model = [WYDoorBellSettingPIRDetection new];
    model.text = text;
    model.detailedText = detailedText;
    model.selected = NO;
    return model;
}


+ (instancetype)PIRDetectionLow {
    return [self modelWithText:WYLocalString(@"motion_low")
                  detailedText:WYLocalString(@"Pir Level Low")
                          type:MeariDeviceSleepmodeLensOn];
}
+ (instancetype)PIRDetectionMiddle {
    return [self modelWithText:WYLocalString(@"motion_medium")
                  detailedText:WYLocalString(@"Pir Level Medium")
                          type:MeariDeviceSleepmodeLensOff];
}
+ (instancetype)PIRDetectionHigh {
    return [self modelWithText:WYLocalString(@"motion_high")
                  detailedText:WYLocalString(@"Pir Level High")
                          type:MeariDeviceSleepmodeLensOffByTime];
}

+ (NSArray <WYDoorBellSettingPIRDetection *> *)PIRDetectionModes {
    return @[
             [self PIRDetectionLow],
             [self PIRDetectionMiddle],
             [self PIRDetectionHigh],
             ];
}

@end
