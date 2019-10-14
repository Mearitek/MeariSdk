//
//  WYAuthorityManager.h
//  Meari
//
//  Created by 李兵 on 2017/7/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WYAuthorityBlock_BOOL) (BOOL granted);
@interface WYAuthorityManager : NSObject
WY_Singleton_Interface(WYAuthorityManager)
+ (void)checkAuthorityOfPhoto:(WYAuthorityBlock_BOOL)authorityResult;
+ (void)checkAuthorityOfMicrophone:(WYAuthorityBlock_BOOL)authorityResult;
+ (void)checkAuthorityOfCamera:(WYAuthorityBlock_BOOL)authorityResult;

+ (BOOL)authorityOfPhotoIsUndetermined;
+ (void)checkAuthorityOfLocation:(WYAuthorityBlock_BOOL)authorityResult;
@end
