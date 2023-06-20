//
//  MeariDevicePetFeedPlanModel.h
//  MeariKit
//
//  Created by chong liu on 2023/2/11.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariDevicePetFeedPlanModel : MeariBaseModel
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *time; //如："10:00"
@property (nonatomic, assign) BOOL once;  //YES:单次，NO:多次
@property (nonatomic, strong) NSArray *repeat; //单次则此字段无意义， 如：[1]
@property (nonatomic, assign) NSInteger count; //投食次数, 1~5次
@property (nonatomic, assign) BOOL msg_enable;
@end

NS_ASSUME_NONNULL_END
