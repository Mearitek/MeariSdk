//
//  MeariSearchNVRSubDeviceModel.h
//  MeariKit
//
//  Created by macbook on 2022/6/29.
//  Copyright © 2022 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MeariAddSubDeviceType){
    MeariAddSubDeviceTypeMeari = 0,
    MeariAddSubDeviceTypeOnvif = 1,
};
typedef NS_ENUM(NSInteger, MeariAddSubDeviceStatus){
    MeariAddSubDeviceStatusNone = 0,
    MeariAddSubDeviceStatusLoad = 1,
    MeariAddSubDeviceStatusSuccess = 2,
    MeariAddSubDeviceStatusFailure = 3,
};

@interface MeariSearchNVRSubDeviceModel : NSObject
@property(nonatomic, copy) NSString *sn;
@property(nonatomic, copy) NSString *ip;
@property(nonatomic, assign) NSInteger type;//0- Meari 1-onvif
@property(nonatomic, assign) NSInteger add_status;//0-未添加 1-添加中 2-添加成功 3-添加失败
@property(nonatomic, assign) MeariAddSubDeviceType addType;//0-未添加 1-添加中 2-添加成功 3-添加失败
@property(nonatomic, assign) MeariAddSubDeviceStatus addStatus;//0-未添加 1-添加中 2-添加成功 3-添加失败
@end

