//
//  WYAuthorityManager+Add.h
//  Meari
//
//  Created by 李兵 on 2017/7/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYAuthorityManager.h"

@interface WYAuthorityManager (Add)
+ (void)checkAuthorityOfPhotoWithAlert:(WYBlock_Void)authorited;
+ (void)checkAuthorityOfCameraWithAlert:(WYBlock_Void)authorited;
+ (void)checkAuthorityOfMicrophoneWithAlert:(WYBlock_Void)authorited;
@end
