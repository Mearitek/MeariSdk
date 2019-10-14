//
//  WYCameraSettingSleepModel.m
//  Meari
//
//  Created by FMG on 17/3/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepModel.h"

@implementation WYCameraSettingSleepModel
+ (instancetype)modelWithText:(NSString *)text
                 detailedText:(NSString *)detailedText
                         type:(MeariDeviceSleepmode)type{
    WYCameraSettingSleepModel *model = [WYCameraSettingSleepModel new];
    model.text = text;
    model.detailedText = detailedText;
    model.type = type;
    model.selected = NO;
    return model;
}


+ (instancetype)sleepModeOn {
    return [self modelWithText:WYLocalString(@"sleepmodeLensOn")
                  detailedText:nil
                          type:MeariDeviceSleepmodeLensOn];
}
+ (instancetype)sleepModeOff {
    return [self modelWithText:WYLocalString(@"sleepmodeLensOff")
                  detailedText:nil
                          type:MeariDeviceSleepmodeLensOff];
}
+ (instancetype)sleepModeTimes {
    return [self modelWithText:WYLocalString(@"sleepmodeLensOffByTime")
                  detailedText:WYLocalString(@"SleepMode_TimeDes")
                          type:MeariDeviceSleepmodeLensOffByTime];
}
+ (NSArray <WYCameraSettingSleepModel *> *)sleepModes {
    return @[
             [self sleepModeOn],
             [self sleepModeOff],
             [self sleepModeTimes],
             ];
}
@end
