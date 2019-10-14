//
//  WYDoorBellSettingPIRDetection.h
//  Meari
//
//  Created by FMG on 2017/7/25.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYDoorBellSettingPIRDetection : NSObject
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *detailedText;
@property (nonatomic, assign)BOOL selected;

+ (instancetype)PIRDetectionLow;
+ (instancetype)PIRDetectionMiddle;
+ (instancetype)PIRDetectionHigh;

+ (NSArray <WYDoorBellSettingPIRDetection *> *)PIRDetectionModes;
@end
