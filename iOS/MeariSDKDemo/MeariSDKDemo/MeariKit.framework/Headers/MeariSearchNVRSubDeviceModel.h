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
    MeariAddSubDeviceStatusSuccess = 1,
    MeariAddSubDeviceStatusFailure = 2,
};

@interface MeariSearchNVRSubDeviceModel : NSObject
@property(nonatomic, copy) NSString *sn;    //addType为Meari返回
@property(nonatomic, copy) NSString *ip;    //addType为Onvif返回

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *add_status;
@property(nonatomic, assign) MeariAddSubDeviceType addType;//其他-Meari 1-Onvif
@property(nonatomic, assign) MeariAddSubDeviceStatus addStatus;//0-未添加 1--添加成功 2-添加失败
@end

