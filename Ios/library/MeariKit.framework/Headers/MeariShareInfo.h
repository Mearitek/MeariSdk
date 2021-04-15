//
//  MeariShareInfo.h
//  MeariKit
//
//  Created by maj on 2019/8/20.
//  Copyright © 2019 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// Sharing status (分享状态)
typedef NS_ENUM(NSInteger, MeariShareInfoType) {
    MeariShareInfoTypeNone = 0, // Not shared (未分享)
    MeariShareInfoTypeAccept, // Shared (已经分享)
    MeariShareInfoTypeRequest, // Request sharing (请求分享中)
};

// Share information (分享信息)
@interface MeariShareInfo : MeariBaseModel
@property (nonatomic,   copy) NSString *shareAccount;  // Shared account (被分享者账号)
@property (nonatomic,   copy) NSString *shareName;     // Shared name (被分享者昵称)
@property (nonatomic,   copy) NSString *shareImageUrl; // Shared person avatar (被分享者头像)
@property (nonatomic, assign) MeariShareInfoType shareType; // Device sharing status (设备分享状态)
@property (nonatomic, assign) NSInteger shareUserID;   // Shared UserID (被分享者ID)
@property (nonatomic, assign) NSInteger shareAccessSign; //Shared Access Sign （分享权限标识）
@end

//  Shared information for all devices (所有设备的分享信息)
@interface MeariShareCameraInfo : MeariBaseModel
@property (nonatomic,   copy) NSString *iconUrl;        // device icon (设备图片)
@property (nonatomic,   copy) NSArray *userAccountList;  // Sharer list (分享者列表)
@property (nonatomic, assign) NSInteger deviceID;       // Device ID (设备ID)
@property (nonatomic,   copy) NSString *deviceName;     // Device name (设备名称)

@end

NS_ASSUME_NONNULL_END
