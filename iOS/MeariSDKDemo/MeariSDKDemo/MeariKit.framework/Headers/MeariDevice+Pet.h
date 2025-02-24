//
//  MeariDevice+Pet.h
//  MeariKit
//
//  Created by duan on 2024/5/10.
//  Copyright © 2024 Meari. All rights reserved.
//

#import <MeariKit/MeariKit.h>
#import <MeariKit/MeariPetInfo.h>

@interface MeariDevice (Pet)
//获取宠物信息
- (void)getPetInfoSuccess:(void(^)(MeariPetInfo* info))success failure:(MeariFailure)failure;
//上传宠物头像
- (void)uploadPetAvatarWithImage:(UIImage *)image success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
//更新宠物信息
- (void)updatePetInfo:(MeariPetInfo *)info success:(MeariSuccess)success failure:(MeariFailure)failure;
//获取宠物最新定位信息
- (void)getPetLatestLocationInfoSuccess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

//获取宠物历史轨迹
- (void)getPetHistoryInfoWithDay:(NSString *)yearMonthDay startTimne:(NSString *)start endTime:(NSString *)end success:(void(^)(NSArray <MeariPetHistoryTrack*>* track))success failure:(MeariFailure)failure;
//获取宠物健康信息
- (void)getPetHealthInfoWithDate:(NSString *)yearMonth success:(void(^)(NSArray <MeariPetHealthInfo*>* info))success failure:(MeariFailure)failure;
//获取宠物虚拟围栏列表
- (void)getPetVirtualFenceListSuccess:(void(^)(NSArray <MeariPetFence *>* fenceList))success failure:(MeariFailure)failure;
//更新宠物虚拟围栏列表
- (void)updatePetVirtualFenceList:(NSArray <MeariPetFence *>*)fenceList success:(MeariSuccess)success failure:(MeariFailure)failure;
//获取宠物Wifi围栏列表
- (void)getPetWifiFenceListSuccess:(void(^)(BOOL powerSaveMode, NSArray <MeariPetWifiFence *>* fenceList))success failure:(MeariFailure)failure;
//更新宠物Wifi围栏列表
- (void)updatePetWifiFenceList:(NSArray <MeariPetWifiFence *>*)fenceList powerSaveMode:(BOOL)on success:(MeariSuccess)success failure:(MeariFailure)failure;

//获取宠物警示开关状态
- (void)getPetWarningStatus:(void(^)(MeariPetWarnStatus* status))success failure:(MeariFailure)failure;
//更新宠物警示开关状态
- (void)updatePetWarningStatus:(MeariPetWarnStatus *)status success:(MeariSuccess)success failure:(MeariFailure)failure;
@end

