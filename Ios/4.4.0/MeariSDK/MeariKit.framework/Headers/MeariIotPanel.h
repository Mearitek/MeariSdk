//
//  MeariIotPanel.h
//  MeariKit
//
//  Created by maj on 2021/12/28.
//  Copyright © 2021 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MeariPanelHistoryInfo;
@class MeariPanelBindInfo;

typedef void(^MeariSuccess)(void);
typedef void(^MeariFailure)(NSError *error);
typedef void(^MeariSuccess_panelHistoryList)(NSArray <MeariPanelHistoryInfo *> *list);
typedef void(^MeariSuccess_panelHistory)(MeariPanelHistoryInfo *info);
typedef void(^MeariSuccess_panelBindInfo)(MeariPanelBindInfo *info);

NS_ASSUME_NONNULL_BEGIN

@interface MeariIotPanel : NSObject
+ (instancetype)sharedInstance;

#pragma mark --- iot panel device

/// get the history message of  iot device
/// 获取iot设备 历史记录
/// @param deviceID device id
/// @param day time
/// @param success Successful callback (成功回调)
/// @param failure failure callback (失败回调)
- (void)getPanelHistoryListWithDeviceID:(NSInteger)deviceID day:(NSString *)day success:(MeariSuccess_panelHistoryList)success failure:(MeariFailure)failure;

/// get the lastest message of iot device
/// @param deviceID device id
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)getPanelLatestHistoryMessageWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_panelHistory)success failure:(MeariFailure)failure;

/// get bind device info
/// @param deviceID jingle id
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)getPanelBindInfoWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_panelBindInfo)success failure:(MeariFailure)failure;

/// bind device
/// @param deviceID jingle id
/// @param bindDeviceID bind device's id
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)bindDeviceWithDeviceId:(NSInteger)deviceID bindDeviceID:(NSInteger)bindDeviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/// unbind device
/// @param deviceID jingle id
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)unBindDeviceWithDeviceId:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

@end

NS_ASSUME_NONNULL_END
