//
//  UILabel+Extension.m
//  Meari
//
//  Created by 李兵 on 15/12/1.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
+ (instancetype)wy_new {
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    return label;
}


- (CGFloat)ajustedHeightWithWidth:(CGFloat)width {
    if (self.attributedText.length > 0) {
        return CGRectIntegral([self.attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil]).size.height;
    }
    if (self.text.length > 0) {
        return [self.text wy_heightWithWidth:width font:self.font breakMode:self.lineBreakMode];
    }
    return 0;
}
- (CGFloat)labelHeighWithWidth:(CGFloat)width {
    CGRect introRect = [self.text boundingRectWithSize:CGSizeMake(WY_ScreenWidth -28, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    return introRect.size.height;
}

+ (UILabel *)labelWithFrame:(CGRect)frame
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font
              numberOfLines:(NSInteger)numberOfLines
              lineBreakMode:(NSLineBreakMode)mode
              lineAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (textColor) {
        label.textColor = textColor;
    }
    if (font) {
        label.font = font;
    }
    label.numberOfLines = numberOfLines;
    label.lineBreakMode = mode;
    label.textAlignment = alignment;
    return label;
}


+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                   textfont:(UIFont *)textFont
              numberOfLines:(NSInteger)numberOfLines
              lineBreakMode:(NSLineBreakMode)mode
              lineAlignment:(NSTextAlignment)alignment
                  sizeToFit:(BOOL)sizeToFit {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = textFont;
    label.numberOfLines = numberOfLines;
    label.lineBreakMode = mode;
    label.textAlignment = alignment;
    if (sizeToFit) {
        [label sizeToFit];
    }
    return label;
}

@end
