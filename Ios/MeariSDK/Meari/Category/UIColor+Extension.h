//
//  UIColor+Extension.h
//  Meari
//
//  Created by 李兵 on 16/8/19.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (instancetype)colorWithIntRed:(int)red intGreen:(int)green intBlue:(int)blue alpha:(CGFloat)alpha;
+ (instancetype)randomColor;

@end
