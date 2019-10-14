//
//  SVProgressHUD+Add.m
//  Meari
//
//  Created by 李兵 on 2016/12/9.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "SVProgressHUD+Add.h"
#import <objc/runtime.h>


@implementation SVProgressHUD (Add)
+ (void)load {
    WY_ExchangeClassImp(@selector(wy_sharedView), NSSelectorFromString(@"sharedView"))
    WY_ExchangeClassImp(@selector(wy_showImage:status:), @selector(showImage:status:))
    WY_ExchangeClassImp(@selector(wy_showSuccessWithStatus:maskType:), @selector(showSuccessWithStatus:maskType:))
    WY_ExchangeClassImp(@selector(wy_showErrorWithStatus:maskType:), @selector(showErrorWithStatus:maskType:))
    WY_ExchangeClassImp(@selector(wy_showWithStatus:maskType:), @selector(showWithStatus:maskType:))
    WY_ExchangeInstanceImp(@selector(wy_dismiss), @selector(dismiss))
}

/**
 属性
 */
- (UIControl *)wy_assistOverlay {
    return objc_getAssociatedObject(self, @selector(wy_assistOverlay));
}
- (void)setWy_assistOverlay:(UIControl *)wy_assistOverlay {
    objc_setAssociatedObject(self, @selector(wy_assistOverlay), wy_assistOverlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)showSuccessString:(NSString *)successString toast:(BOOL)toast inVC:(UIViewController *)vc {
    if (vc.wy_isTop) {
        [SVProgressHUD resetOffsetFromCenter];
        if (toast) {
            [SVProgressHUD wy_showToast:successString];
        }else {
            [SVProgressHUD showSuccessWithStatus:successString maskType:SVProgressHUDMaskTypeNone];
        }
    }
}
+ (void)showFailureString:(NSString *)failureString toast:(BOOL)toast inVC:(UIViewController *)vc {
    if (vc.wy_isTop) {
        [SVProgressHUD resetOffsetFromCenter];
        if (toast) {
            [SVProgressHUD wy_showToast:failureString];
        }else {
            [SVProgressHUD showErrorWithStatus:failureString maskType:SVProgressHUDMaskTypeNone];
        }
    }
    
}



+ (void)wy_showToast:(NSString *)text {
    [self wy_sharedView].wy_assistOverlay.userInteractionEnabled = NO;
    [SVProgressHUD resetOffsetFromCenter];
    if (WY_ScreenHeight < WY_ScreenWidth) {
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, WY_ScreenHeight / 2.0f - 80.0f)];
    }else {
        [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, WY_ScreenHeight / 2.0f - 60.0f)];
    }
    [self showImage:nil status:text];
}
+ (void)wy_showStatus:(NSString *)text {
    [self wy_sharedView].wy_assistOverlay.userInteractionEnabled = NO;
    [SVProgressHUD resetOffsetFromCenter];
    [self showImage:nil status:text];
}
+ (void)wy_showSuccess:(NSString *)text {
    [self wy_sharedView].wy_assistOverlay.userInteractionEnabled = NO;
    [self showSuccessWithStatus:text maskType:SVProgressHUDMaskTypeNone];
}
+ (void)wy_showError:(NSString *)text {
    [self wy_sharedView].wy_assistOverlay.userInteractionEnabled = NO;
    [self showErrorWithStatus:text maskType:SVProgressHUDMaskTypeNone];
}
+ (void)wy_showLoading:(NSString *)text {
    [self wy_sharedView].wy_assistOverlay.userInteractionEnabled = YES;
    [self showWithStatus:text maskType:SVProgressHUDMaskTypeNone];
}
+ (void)wy_showErrorWithError:(NSError *)error {
    if (error.userInfo) {
        NSString *info = [error.userInfo objectForKey:@"error description"];
        WY_HUD_SHOW_ERROR_STATUS(info)
        return;
    }
    if (error.domain) {
        WY_HUD_SHOW_ERROR_STATUS(error.domain)
    }else {
        WY_HUD_DISMISS
    }
}


#pragma mark - Exchange
+ (SVProgressHUD *)wy_sharedView {
    SVProgressHUD *hud = [self wy_sharedView];
    if (!hud.wy_assistOverlay) {
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, WY_TopBar_H, WY_ScreenWidth, WY_ScreenHeight-WY_TopBar_H)];
        control.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        control.backgroundColor = [UIColor clearColor];
        hud.wy_assistOverlay = control;
    }
    return hud;
}
+ (void)wy_showImage:(UIImage *)image status:(NSString *)status {
    [self wy_setColor];
    [self wy_showImage:image status:status];
}
+ (void)wy_showSuccessWithStatus:(NSString *)string maskType:(SVProgressHUDMaskType)maskType {
    [self wy_setColor];
    [self resetOffsetFromCenter];
    [self wy_showSuccessWithStatus:string maskType:maskType];
    [self wy_insertAssistControl];
}
+ (void)wy_showErrorWithStatus:(NSString *)string maskType:(SVProgressHUDMaskType)maskType {
    [self wy_setColor];
    [self resetOffsetFromCenter];
    [self wy_showErrorWithStatus:string maskType:maskType];
    [self wy_insertAssistControl];
}
+ (void)wy_showWithStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType {
    [self wy_setColor];
    [self resetOffsetFromCenter];
    [self wy_showWithStatus:status maskType:maskType];
    [self wy_insertAssistControl];
}
- (void)wy_dismiss {
    [self wy_removeAssistControl];
    [self wy_dismiss];
}

#pragma mark -- Private
+ (void)wy_setColor {
    [self setBackgroundColor:WY_SVP_BGColor];
    [self setForegroundColor:[UIColor whiteColor]];
}
+ (void)wy_insertAssistControl{
    SVProgressHUD *hud = [self wy_sharedView];
    if (hud.wy_assistOverlay && hud.superview.superview) {
        [hud.superview.superview insertSubview:hud.wy_assistOverlay belowSubview:hud.superview];
    }
}
- (void)wy_removeAssistControl {
    [self.wy_assistOverlay removeFromSuperview];
}

@end
