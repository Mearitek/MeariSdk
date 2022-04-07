//
//  MRUserManager.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRUserManager.h"

@implementation MRUserManager

+ (instancetype)sharedMRUserManager {
    static id instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
