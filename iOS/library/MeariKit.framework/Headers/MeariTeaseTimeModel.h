//
//  MeariTeaseTimeModel.h
//  MeariKit
//
//  Created by maj on 2024/5/20.
//  Copyright © 2024 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariTeaseTimeModel : MeariBaseModel
// eg: {"max":10, "min":1, "in":1, "dur":3} max:最大值 min:最小值 in(interval):间隔 dur(duration):默认时长

@property (nonatomic, assign) NSInteger max; // 最大值
@property (nonatomic, assign) NSInteger min; // 最小值
@property (nonatomic, assign) NSInteger interval; // 间隔
@property (nonatomic, assign) NSInteger dur; // 默认时长

@end

NS_ASSUME_NONNULL_END
