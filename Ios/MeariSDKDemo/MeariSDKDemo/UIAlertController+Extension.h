//
//  UIAlertController+Extension.h
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)

+ (instancetype)alertControllerMessage:(NSString *)message cancelBlock:(dispatch_block_t)cancelBlock sureBlock:(dispatch_block_t)sureBlock;

+ (instancetype)alertControllerMessage:(NSString *)message sureBlock:(dispatch_block_t)sureBlock;

+ (void)alertControllerMessage:(NSString *)message;

@end
