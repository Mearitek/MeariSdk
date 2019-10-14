//
//  UIColor+SF.h
//  SVEye2
//
//  Created by 李兵 on 15/11/12.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SF)
/**
 *  通过16进制来生成颜色，带透明通道
 *
 *  @param hex
 *
 *  @return
 */
+ (UIColor*)wy_color32WithHex:(u_long)hex;

/**
 *  通过16进制来生成颜色，不带透明通道
 *
 *  @param hex
 *
 *  @return
 */
+ (UIColor*)wy_color24WithHex:(u_long)hex;

/**
 *  通过0-255来设置颜色
 *
 *  @param r 红色通道
 *  @param g 绿色通道
 *  @param b 蓝色通道
 *  @param a 透明通道
 *
 *  @return
 */
+ (UIColor*)wy_color32WithRed:(NSUInteger)r green:(NSUInteger)g blue:(NSUInteger)b alpha:(NSUInteger)a;

/**
 *  通过0-255来设置颜色
 *
 *  @param r 红色通道
 *  @param g 绿色通道
 *  @param b 蓝色通道
 *
 *  @return 
 */
+ (UIColor*)wy_color24WithRed:(NSUInteger)r green:(NSUInteger)g blue:(NSUInteger)b;

@end
