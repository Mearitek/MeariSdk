//
//  MeariPanelInfo.h
//  MeariKit
//
//  Created by maj on 2021/12/28.
//  Copyright © 2021 Meari. All rights reserved.
//

//#import <MeariKit/MeariKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariPanelInfo : MeariBaseModel

@end

@interface MeariPanelBindInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, assign) NSInteger bindDeviceID;

@end

NS_ASSUME_NONNULL_END
