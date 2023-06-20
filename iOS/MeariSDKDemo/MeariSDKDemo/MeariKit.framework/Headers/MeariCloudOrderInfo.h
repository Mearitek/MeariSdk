//
//  MeariCloudOrderInfo.h
//  MeariKit
//
//  Created by chong liu on 2022/6/7.
//  Copyright © 2022 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariCloudOrderInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger deviceId;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceIcon;
@end

NS_ASSUME_NONNULL_END
