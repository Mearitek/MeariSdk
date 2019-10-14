//
//  UIDevice+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/4/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "UIDevice+Extension.h"
#import <objc/runtime.h>

static char *kLastOrientation = "kLastOrientation";

@implementation UIDevice (Extension)
- (UIDeviceOrientation)lastOrientation {
    return [objc_getAssociatedObject(self, kLastOrientation) integerValue];
}
- (void)setLastOrientation:(UIDeviceOrientation)lastOrientation {
    objc_setAssociatedObject(self, kLastOrientation, @(lastOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)wy_forceOrientationPortrait {
    [self wy_forceOriention:UIDeviceOrientationPortrait];
}
+ (void)wy_forceOrientationPortraitUpsideDown {
    [self wy_forceOriention:UIDeviceOrientationPortraitUpsideDown];
}
+ (void)wy_forceOrientationLandscapeLeft {
    [self wy_forceOriention:UIDeviceOrientationLandscapeLeft];
}
+ (void)wy_forceOrientationLandscapeRight {
    [self wy_forceOriention:UIDeviceOrientationLandscapeRight];
}

+ (void)wy_forceOriention:(UIDeviceOrientation)orientation {
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

@end
