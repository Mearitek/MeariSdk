//
//  WYCameraSettingMotionModel.h
//  Meari
//
//  Created by 李兵 on 2017/8/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYCameraSettingMotionModel : NSObject
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *detailedText;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)MeariDeviceLevel level;
@property (nonatomic, assign)WYSettingAccesoryType accesoryType;


+ (instancetype)motionSwitch;
+ (instancetype)motionLow;
+ (instancetype)motionMedium;
+ (instancetype)motionHigh;

@end
