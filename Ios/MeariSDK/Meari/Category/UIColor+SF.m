//
//  UIColor+SF.m
//  SVEye2
//
//  Created by 李兵 on 15/11/12.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "UIColor+SF.h"

static inline void getRGBA(u_long hex,NSUInteger *r, NSUInteger *g, NSUInteger *b, NSUInteger *a)
{
    *a = hex >> 24;
    *r   = (hex >> 16) & 0xff;
    *g = (hex >> 8) & 0xff;
    *b  = hex & 0xff;
}

@implementation UIColor (SF)

+ (UIColor*)wy_color32WithHex:(u_long)hex
{
    NSUInteger alpha,red,green,blue;
    
    getRGBA(hex, &red, &green, &blue, &alpha);
    
    return
        [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

+ (UIColor*)wy_color24WithHex:(u_long)hex
{
    return [UIColor wy_color32WithHex:hex | 0xff000000];
}

+ (UIColor*)wy_color32WithRed:(NSUInteger)r green:(NSUInteger)g blue:(NSUInteger)b alpha:(NSUInteger)a
{
    return [UIColor wy_color32WithHex:(a << 24) + (r << 16) + (g << 8) + b];
}

+ (UIColor*)wy_color24WithRed:(NSUInteger)r green:(NSUInteger)g blue:(NSUInteger)b
{
    return [UIColor wy_color32WithHex:0xff000000 + (r << 16) + (g << 8) + b];
}


@end
