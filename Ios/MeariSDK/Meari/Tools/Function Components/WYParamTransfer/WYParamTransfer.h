//
//  WYParamTransfer.h
//  Meari
//
//  Created by FMG on 2018/6/9.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WY_ParamTransfer [WYParamTransfer sharedParamTransfer]
typedef NS_ENUM(NSInteger, WYParamTransferType) {
    WYParamTransferType_add,
};

@class WYCameraSelectKindModel,WYWifiInfo,WYCamera;
@interface WYParamTransfer : NSObject
WY_Singleton_Interface(ParamTransfer)
/**
 *@brief add camera for selected kind
 */
@property (nonatomic, strong) WYCameraSelectKindModel *selectedKindModel;

/**
 *@brief add camera for current wifi 
 */
@property (nonatomic, strong) WYWifiInfo *wifiInfo;

/**
 *@brief add camera for auto default
 */
@property (nonatomic, assign) BOOL autoAdd;

/**
 *@brief current selected camera
 */
@property (nonatomic, strong) MeariDevice *camera;

/**
 *@brief reset para for type
 */
- (void)resetParamsType:(WYParamTransferType)type;

@end
