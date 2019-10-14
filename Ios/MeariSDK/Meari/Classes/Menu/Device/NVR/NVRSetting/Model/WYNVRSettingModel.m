//
//  WYNVRSettingModel.m
//  Meari
//
//  Created by 李兵 on 2017/1/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingModel.h"

@implementation WYNVRSettingModel
+ (instancetype)modelWithImageName:(NSString *)imageName text:(NSString *)text detailedText:(NSString *)detailedText type:(WYNVRSettingCellType)type {
    
    WYNVRSettingModel *model = [[WYNVRSettingModel alloc] init];
    model.imageName = imageName;
    model.text = text;
    model.detailedText = detailedText;
    model.type = type;
    return model;
}

//普通
+ (instancetype)previewNameModel {
    return [self modelWithImageName:nil
                               text:WYLocalString(@"Preview name")
                       detailedText:nil
                               type:WYNVRSettingCellTypePreviewName];
}
+ (instancetype)ownerModel {
    return [self modelWithImageName:nil
                               text:WYLocalString(@"Owner")
                       detailedText:nil
                               type:WYNVRSettingCellTypeOwner];
}
+ (instancetype)snModel {
    return [self modelWithImageName:nil
                               text:WYLocalString(@"SN")
                       detailedText:nil
                               type:WYNVRSettingCellTypeSN];
}
+ (instancetype)cameraListModel {
    return [self modelWithImageName:@"img_nvr_cameralist"
                               text:WYLocalString(@"Camera management")
                       detailedText:nil
                               type:WYNVRSettingCellTypeCameraList];
}
+ (instancetype)shareModel {
    return [self modelWithImageName:@"img_nvr_share"
                               text:WYLocalString(@"Share")
                       detailedText:nil
                               type:WYNVRSettingCellTypeShare];
}
+ (instancetype)versionModel {
    return [self modelWithImageName:@"img_nvr_version"
                               text:WYLocalString(@"Version")
                       detailedText:nil
                               type:WYNVRSettingCellTypeVersion];
}
+ (instancetype)harddiskModel {
    return [self modelWithImageName:@"img_nvr_harddisk"
                               text:WYLocalString(@"Hard disk")
                       detailedText:nil
                               type:WYNVRSettingCellTypeHardDisk];
}

@end
