//
//  MeariPanelHistoryInfo.h
//  MeariKit
//
//  Created by maj on 2021/12/13.
//  Copyright © 2021 Meari. All rights reserved.
//

//#import <MeariKit/MeariKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MeariPanelHistoryInfo : MeariBaseModel
@property (nonatomic, copy) NSString *msgID; // 消息ID (message's id)
@property (nonatomic, assign) NSInteger devLocalTime; // 时间戳 (time)
@property (nonatomic, assign) NSInteger deviceID; // 设备ID (device's id)
@property (nonatomic, assign) NSInteger userID; // 用户ID (user's id)
@property (nonatomic, assign) NSInteger msgType; // 消息类型

@end

NS_ASSUME_NONNULL_END
