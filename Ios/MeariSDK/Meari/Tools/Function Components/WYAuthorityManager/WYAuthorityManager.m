//
//  WYAuthorityManager.m
//  Meari
//
//  Created by 李兵 on 2017/7/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYAuthorityManager.h"
#import <CoreLocation/CoreLocation.h>
@import Photos;
@import AVFoundation;
@interface WYAuthorityManager()

@property (nonatomic, strong)  CLLocationManager *manager;

@end
@implementation WYAuthorityManager


WY_Singleton_Implementation(WYAuthorityManager)

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
    }
    return _manager;
}
+ (void)checkAuthorityOfPhoto:(WYAuthorityBlock_BOOL)authorityResult {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                WYDo_Block_Safe_Main1(authorityResult, status == PHAuthorizationStatusAuthorized)
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            WYDo_Block_Safe_Main1(authorityResult, YES)
            break;
        }
        default: {
            WYDo_Block_Safe_Main1(authorityResult, NO)
            break;
        }
    }
}
+ (void)checkAuthorityOfMicrophone:(WYAuthorityBlock_BOOL)authorityResult {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                WYDo_Block_Safe_Main1(authorityResult, granted)
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            WYDo_Block_Safe_Main1(authorityResult, YES)
            break;
        }
        default: {
            WYDo_Block_Safe_Main1(authorityResult, NO)
            break;
        }
    }
}
+ (void)checkAuthorityOfCamera:(WYAuthorityBlock_BOOL)authorityResult {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                WYDo_Block_Safe_Main1(authorityResult, granted)
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            WYDo_Block_Safe_Main1(authorityResult, YES)
            break;
        }
        default: {
            WYDo_Block_Safe_Main1(authorityResult, NO)
            break;
        }
    }
}


+ (BOOL)authorityOfPhotoIsUndetermined {
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined;
}

+ (void)checkAuthorityOfLocation:(WYAuthorityBlock_BOOL)authorityResult {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
        {
            //请求定位权限
            [[WYAuthorityManager sharedWYAuthorityManager].manager requestWhenInUseAuthorization];
            WYDo_Block_Safe_Main1(authorityResult, NO)
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            WYDo_Block_Safe_Main1(authorityResult, NO)
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            WYDo_Block_Safe_Main1(authorityResult, YES)
            
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            WYDo_Block_Safe_Main1(authorityResult, NO)
        }
            break;
    }
}

@end
