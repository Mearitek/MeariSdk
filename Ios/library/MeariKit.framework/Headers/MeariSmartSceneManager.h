//
//  MeariSmartSceneManager.h
//  MeariKit
//
//  Created by test on 2021/5/24.
//  Copyright © 2021 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeariDeviceInfo.h"
#import "MeariDeviceParam.h"
#import "MeariDeviceControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeariSmartSceneManager : NSObject
/**
 *  Single (单例)
 */
+ (instancetype)sharedInstance;

/**
 查询场景列表
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getSceneListWithSuccess:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 查询支持场景的设备列表
 
 @param listType 区分是任务/动作的列表（condition/action）
 @param success   成功回调
 @param failure   失败回调
 */
- (void)getSceneDevicesWithListType:(NSString *)listType success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 查询设备下支持的dp点列表
 
 @param deviceID 设备id
 @param listType 区分是任务/动作的列表（condition/action）
 @param success   成功回调
 @param failure   失败回调
 */
- (void)getDeviceDPListWithDeviceID:(NSString *)deviceID listType:(NSString *)listType success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 触发一键执行场景
 
 @param sceneId 场景id
 @param success 成功回调
 @param failure 失败回调
 */
- (void)executeSceneWithSceneId:(NSString *)sceneId success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 场景排序
 
 @param sceneIdList 场景id列表
 @param success          成功回调
 @param failure          失败回调
 */
- (void)sortSceneWithSceneIdList:(NSArray *)sceneIdList success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 自动场景开启/失效
 
 @param sceneId 场景id
 @param enable   YES开启，NO失效
 @param success 成功回调
 @param failure 失败回调
 */
- (void)enableSceneWithSceneId:(NSString *)sceneId enable:(BOOL)enable success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 保存场景
 
 @param params           场景数据
 @param success         成功回调
 @param failure         失败回调
 */
-(void)addSceneWithParams:(NSDictionary *)params success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 删除场景
    
 @param sceneId 场景id
 @param success 成功回调
 @param failure 失败回调
 */
-(void)deleteSceneWithSceneId:(NSString *)sceneId success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 修改场景
 
 @param params           场景数据
 @param success         成功回调
 @param failure         失败回调
 */
-(void)updateSceneWithParams:(NSDictionary *)params success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

/**
 场景日志
 
 @param params           场景数据
 @param success         成功回调
 @param failure         失败回调
 */
-(void)getSceneLogWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize success:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;
@end

NS_ASSUME_NONNULL_END
