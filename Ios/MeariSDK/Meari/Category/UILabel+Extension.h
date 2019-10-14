//
//  UILabel+Extension.h
//  Meari
//
//  Created by 李兵 on 15/12/1.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
+ (instancetype)wy_new;
- (CGFloat)ajustedHeightWithWidth:(CGFloat)width;
- (CGFloat)labelHeighWithWidth:(CGFloat)width;
+ (UILabel *)labelWithFrame:(CGRect)frame
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font
              numberOfLines:(NSInteger)numberOfLines
              lineBreakMode:(NSLineBreakMode)mode
              lineAlignment:(NSTextAlignment)alignment;



+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                   textfont:(UIFont *)textFont
              numberOfLines:(NSInteger)numberOfLines
              lineBreakMode:(NSLineBreakMode)mode
              lineAlignment:(NSTextAlignment)alignment
                  sizeToFit:(BOOL)sizeToFit;



@end
