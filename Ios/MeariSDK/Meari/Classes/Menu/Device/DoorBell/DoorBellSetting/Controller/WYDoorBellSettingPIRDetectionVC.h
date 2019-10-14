//
//  WYDoorBellSettingPIRDetectionVC.h
//  Meari
//
//  Created by FMG on 2017/7/25.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseVC.h"

@interface WYDoorBellSettingPIRDetectionVC : WYBaseTVC
- (instancetype)initWithPIRLeavel:(NSString *)PIRLeavel camera:(MeariDevice *)camera doorBell:(MeariDeviceParamBell*)doorBell ;

@end
