//
//  UIDevice+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/4/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extension)
@property (nonatomic, assign)UIDeviceOrientation lastOrientation;


+ (void)wy_forceOrientationPortrait;
+ (void)wy_forceOrientationPortraitUpsideDown;
+ (void)wy_forceOrientationLandscapeLeft;
+ (void)wy_forceOrientationLandscapeRight;
+ (void)wy_forceOriention:(UIDeviceOrientation)orientation;
@end
