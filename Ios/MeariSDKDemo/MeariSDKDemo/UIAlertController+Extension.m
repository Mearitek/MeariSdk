//
//  UIAlertController+Extension.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

+ (instancetype)alertControllerMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle cancelBlock:(dispatch_block_t)cancelBlock sureBlock:(dispatch_block_t)sureBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:message preferredStyle:UIAlertControllerStyleAlert];

    if (cancelTitle.length) {
        UIAlertAction *alertAction0 = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alert addAction:alertAction0];
    }
    if (sureTitle.length) {
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureBlock) {
                sureBlock();
            }
            }];
        [alert addAction:alertAction1];
    }
    return alert;
}

+ (instancetype)alertControllerMessage:(NSString *)message cancelBlock:(dispatch_block_t)cancelBlock sureBlock:(dispatch_block_t)sureBlock {
    UIAlertController *alert = [UIAlertController alertControllerMessage:message cancelTitle:@"cancal" sureTitle:@"OK" cancelBlock:cancelBlock sureBlock:sureBlock];
    return alert;
}
+ (instancetype)alertControllerMessage:(NSString *)message sureBlock:(dispatch_block_t)sureBlock {
    UIAlertController *alert = [UIAlertController alertControllerMessage:message cancelTitle:nil sureTitle:@"OK" cancelBlock:nil sureBlock:sureBlock];
    return alert;
}

+ (void)alertControllerMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerMessage:message cancelTitle:nil sureTitle:@"OK" cancelBlock:nil sureBlock:nil];
    TabbarVC *tabbar = (TabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav.topViewController presentViewController:alert animated:YES completion:nil];
}

@end
