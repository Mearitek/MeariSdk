//
//  MeariDevicePetFeedPlanModel.h
//  MeariKit
//
//  Created by chong liu on 2023/2/11.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MeariDevicePetTeaseMode) {
    MeariDevicePetTeaseModeNone = 0, // 自动，手动控制云台
    MeariDevicePetTeaseModeCycle, // 循环模式
    MeariDevicePetTeaseModeHorizontal, // 水平模式
    MeariDevicePetTeaseModeVertical, // 垂直模式
    MeariDevicePetTeaseModeCustom, // 自定义模式
};

NS_ASSUME_NONNULL_BEGIN

@interface MeariDevicePetFeedPlanModel : MeariBaseModel
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *time; //如："10:00"
@property (nonatomic, assign) BOOL once;  //YES:单次，NO:多次
@property (nonatomic, strong) NSArray *repeat; //单次则此字段无意义， 如：[1]
@property (nonatomic, assign) NSInteger count; //投食次数, 1~5次
@property (nonatomic, assign) BOOL msg_enable;
@property (nonatomic, assign) MeariDevicePetTeaseMode mode;

@end

NS_ASSUME_NONNULL_END
