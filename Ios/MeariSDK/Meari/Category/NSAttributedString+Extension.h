//
//  NSAttributedString+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/2/17.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Extension)
- (CGFloat)wy_heightWithWidth:(CGFloat)width;
+ (instancetype)attributedStringWithImage:(UIImage *)image;
+ (instancetype)attributedStringWithImage:(UIImage *)image
                                     size:(CGSize)size;

+ (instancetype)defaultAttributedStringWithString:(NSString *)string
                                        fontColor:(UIColor *)fontColor
                                             font:(UIFont *)font;
+ (instancetype)defaultAttributedStringWithString:(NSString *)string
                                        fontColor:(UIColor *)fontColor
                                             font:(UIFont *)font
                                        alignment:(NSTextAlignment)alignment;
+ (instancetype)bigSpacedAttributedStringWithString:(NSString *)string
                                          fontColor:(UIColor *)fontColor
                                               font:(UIFont *)font;
+ (instancetype)attributedStringWithString:(NSString *)string
                                 fontColor:(UIColor *)fontColor
                                      font:(UIFont *)font
                               lineSpacing:(CGFloat)lineSpacing
                               kernSpacing:(CGFloat)kernSpacing
                             lineBreakMode:(NSLineBreakMode)lineBreakMode
                                 alignment:(NSTextAlignment)alignment;

@end


@interface NSAttributedString (Const)
+ (instancetype)attributedNetworkSetting;
+ (instancetype)attributedNoDataNVRSettingCameraBinding;
+ (instancetype)attributedNoAPWIFI;
+ (instancetype)attributedAPFailure;
+ (instancetype)attributedSearchNull_nvr;
+ (instancetype)attributedSearchNull_qr;
+ (instancetype)attributedSearchNull_ap;
+ (instancetype)attributedHelp_Config;

@end
