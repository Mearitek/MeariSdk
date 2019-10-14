//
//  WYNVRSettingModel.h
//  Meari
//
//  Created by 李兵 on 2017/1/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, WYNVRSettingCellType) {
    WYNVRSettingCellTypePreviewName,
    WYNVRSettingCellTypeOwner,
    WYNVRSettingCellTypeSN,
    WYNVRSettingCellTypeCameraList,
    WYNVRSettingCellTypeShare,
    WYNVRSettingCellTypeVersion,
    WYNVRSettingCellTypeHardDisk,
    
};
typedef NS_ENUM(NSInteger, WYNVRSettingAccesoryType) {
    WYNVRSettingAccesoryTypeNone,
    WYNVRSettingAccesoryTypeNormal,
    WYNVRSettingAccesoryTypeOverTime,
    WYNVRSettingAccesoryTypeJuhua
};
@interface WYNVRSettingModel : NSObject
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *detailedText;
@property (nonatomic, assign)WYNVRSettingCellType type;
@property (nonatomic, assign)WYNVRSettingAccesoryType accesoryType;



//普通
+ (instancetype)previewNameModel;
+ (instancetype)ownerModel;
+ (instancetype)snModel;
+ (instancetype)cameraListModel;
+ (instancetype)shareModel;
+ (instancetype)versionModel;
+ (instancetype)harddiskModel;

@end
