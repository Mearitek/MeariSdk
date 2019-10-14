//
//  UIColor+Extension.m
//  Meari
//
//  Created by 李兵 on 16/8/19.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (instancetype)colorWithIntRed:(int)red intGreen:(int)green intBlue:(int)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (instancetype)randomColor {
    return [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
}


@end
