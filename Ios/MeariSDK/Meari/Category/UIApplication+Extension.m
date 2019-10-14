//
//  UIApplication+Extension.m
//  Meari
//
//  Created by 李兵 on 16/9/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UIApplication+Extension.h"
#import "NSString+Extension.h"
@implementation UIApplication (Extension)
#pragma mark - Private
- (BOOL)wy_openGeneralURL:(NSURL *)url {
    if (![self canOpenURL:url]) return NO;
    
    if (WY_Version_GreaterThanOrEqual_10) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
        [self openURL:url options:nil completionHandler:nil];
#pragma clang diagnostic pop
#endif
        return YES;
    }
    [self openURL:url];
    return YES;
}

#pragma mark - Public
- (BOOL)wy_jumpToWIFI {
    return [self wy_openGeneralURL:NSString.wy_setting_Wifi.wy_url];
}
- (void)wy_jumpToAPPSetting {
    [self wy_openGeneralURL:NSString.wy_setting_App.wy_url];
}
- (void)wy_jumpToAPPLocationServeSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //NSString.WY_setting_Location.WY_url
    [self wy_openGeneralURL:url];
}
@end
