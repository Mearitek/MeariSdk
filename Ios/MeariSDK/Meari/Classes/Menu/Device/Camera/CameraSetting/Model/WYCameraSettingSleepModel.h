//
//  WYCameraSettingSleepModel.h
//  Meari
//
//  Created by FMG on 17/3/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYCameraSettingSleepModel : NSObject
@property (nonatomic, assign)MeariDeviceSleepmode type;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *detailedText;
@property (nonatomic, assign)BOOL selected;


+ (instancetype)sleepModeOn;
+ (instancetype)sleepModeOff;
+ (instancetype)sleepModeTimes;
+ (NSArray <WYCameraSettingSleepModel *> *)sleepModes;
@end
