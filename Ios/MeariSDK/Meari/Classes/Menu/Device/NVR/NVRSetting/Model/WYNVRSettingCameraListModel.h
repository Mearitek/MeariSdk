//
//  WYNVRSettingCameraListModel.h
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYNVRSettingCameraListModel : NSObject

@property (nonatomic, copy) MeariDevice *device;

@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)BOOL binded;
@property (nonatomic, copy)NSString *wifiSSID;

@end
