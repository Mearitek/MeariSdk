//
//  WYCameraManager.h
//  Meari
//
//  Created by 李兵 on 2016/11/25.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WY_CameraM [WYCameraManager sharedCameraManager]
@interface WYCameraManager : NSObject

WY_Singleton_Interface(CameraManager)
@property (nonatomic, assign)BOOL babyMonitor;

@end
