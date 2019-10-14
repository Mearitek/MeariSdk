//
//  WYAuthorityManager+Add.m
//  Meari
//
//  Created by 李兵 on 2017/7/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYAuthorityManager+Add.h"

@implementation WYAuthorityManager (Add)
+ (void)checkAuthorityOfPhotoWithAlert:(WYBlock_Void)authorited {
    [self checkAuthorityOfPhoto:^(BOOL granted) {
        if (granted) {
            WYDo_Block_Safe_Main(authorited)
        }else {
            [WYAlertView showNeedAuthorityOfPhoto];
        }
    }];
}
+ (void)checkAuthorityOfCameraWithAlert:(WYBlock_Void)authorited {
    [self checkAuthorityOfCamera:^(BOOL granted) {
        if (granted) {
            WYDo_Block_Safe_Main(authorited)
        }else {
            [WYAlertView showNeedAuthorityOfCamera];
        }
    }];
}
+ (void)checkAuthorityOfMicrophoneWithAlert:(WYBlock_Void)authorited {
    [self checkAuthorityOfMicrophone:^(BOOL granted) {
        if (granted) {
            WYDo_Block_Safe_Main(authorited)
        }else {
            [WYAlertView showNeedAuthorityOfMicrophone];
        }
    }];
}
@end
