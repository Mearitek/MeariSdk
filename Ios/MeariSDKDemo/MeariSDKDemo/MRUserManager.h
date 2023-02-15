//
//  MRUserManager.h
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define MR_UserM [MRUserManager sharedMRUserManager]

@interface MRUserManager : NSObject

+ (instancetype)sharedMRUserManager;

@property (nonatomic, strong) NSString *configToken; // token 
@property (nonatomic, assign) NSInteger validTime; // token Effective time

@end

NS_ASSUME_NONNULL_END
