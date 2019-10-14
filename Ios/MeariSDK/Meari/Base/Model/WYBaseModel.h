//
//  WYBaseModel.h
//  Meari
//
//  Created by 李兵 on 2017/4/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WYSettingAccesoryType) {
    WYSettingAccesoryTypeNone,
    WYSettingAccesoryTypeNormal,
    WYSettingAccesoryTypeOverTime,
    WYSettingAccesoryTypeJuhua
};
@interface WYBaseModel : NSObject

@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *detailedText;
+ (instancetype)modelWithImageName:(NSString *)imageName text:(NSString *)text deatailedText:(NSString *)detailedText;
- (void)initAction;
- (void)deallocAction;

@end




@interface WYBaseModel (WYConst)
#pragma mark -- CameraSelectKind
+ (instancetype)CameraSelectKindCamera;
+ (instancetype)CameraSelectKindBatteryCamera;
+ (instancetype)CameraSelectKindNVR;
+ (instancetype)CameraSelectKindDoorBell;
+ (instancetype)CameraSelectKindVoiceDoorBell;

@end
