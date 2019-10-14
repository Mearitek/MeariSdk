//
//  NSAttributedString+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/2/17.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)
- (CGFloat)wy_heightWithWidth:(CGFloat)width {
    CGRect r = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return CGRectIntegral(r).size.height;
}
+ (instancetype)attributedStringWithImage:(UIImage *)image{
    return [self attributedStringWithImage:image size:image.size];
}
+ (instancetype)attributedStringWithImage:(UIImage *)image size:(CGSize)size {
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = image;
    attch.bounds = CGRectMake(0, 0, size.width, size.height);
    NSMutableAttributedString *str = [NSAttributedString attributedStringWithAttachment:attch].mutableCopy;
    [str addAttribute:NSBaselineOffsetAttributeName value:@-4 range:NSMakeRange(0, str.length)];
    return str;
}
+ (instancetype)defaultAttributedStringWithString:(NSString *)string
                                        fontColor:(UIColor *)fontColor
                                             font:(UIFont *)font {
    return [self attributedStringWithString:string
                                  fontColor:fontColor
                                       font:font
                                lineSpacing:4
                                kernSpacing:0.3
                              lineBreakMode:NSLineBreakByWordWrapping
                                  alignment:NSTextAlignmentLeft];
}
+ (instancetype)defaultAttributedStringWithString:(NSString *)string
                                        fontColor:(UIColor *)fontColor
                                             font:(UIFont *)font
                                        alignment:(NSTextAlignment)alignment{
    return [self attributedStringWithString:string
                                  fontColor:fontColor
                                       font:font
                                lineSpacing:4
                                kernSpacing:0.3
                              lineBreakMode:NSLineBreakByWordWrapping
                                  alignment:alignment];
}
+ (instancetype)bigSpacedAttributedStringWithString:(NSString *)string
                                          fontColor:(UIColor *)fontColor
                                               font:(UIFont *)font {
    return [self attributedStringWithString:string
                                  fontColor:fontColor
                                       font:font
                                lineSpacing:10
                                kernSpacing:0.3
                              lineBreakMode:NSLineBreakByWordWrapping
                                  alignment:NSTextAlignmentLeft];
}
+ (instancetype)bigSpacedAttributedStringWithString:(NSString *)string
                                          fontColor:(UIColor *)fontColor
                                               font:(UIFont *)font
                                          alignment:(NSTextAlignment)alignment{
    return [self attributedStringWithString:string
                                  fontColor:fontColor
                                       font:font
                                lineSpacing:10
                                kernSpacing:0.3
                              lineBreakMode:NSLineBreakByWordWrapping
                                  alignment:alignment];
}
+ (instancetype)attributedStringWithString:(NSString *)string
                                 fontColor:(UIColor *)fontColor
                                      font:(UIFont *)font
                               lineSpacing:(CGFloat)lineSpacing
                               kernSpacing:(CGFloat)kernSpacing
                             lineBreakMode:(NSLineBreakMode)lineBreakMode
                                 alignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, str.length);
    if (fontColor) {
        [str addAttribute:NSForegroundColorAttributeName value:fontColor range:range];
    }
    if (font) {
        [str addAttribute:NSFontAttributeName value:font range:range];
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    style.lineSpacing = lineSpacing;
    style.alignment = alignment;
    [str addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [str addAttribute:NSKernAttributeName value:@(kernSpacing) range:range];
    return str;
}
@end

@implementation NSAttributedString (Const)

+ (instancetype)attributedNetworkSetting {
    UIFont *font = WYFont_Text_XS_Normal;
    NSMutableAttributedString *str1 = [NSAttributedString defaultAttributedStringWithString:WYLocalString(@"des_networkSetting1") fontColor:WY_FontColor_Gray font:font].mutableCopy;
    NSMutableAttributedString *str2 = [NSAttributedString defaultAttributedStringWithString:WYLocalString(@"des_networkSetting2") fontColor:WY_FontColor_Gray font:font].mutableCopy;
    NSMutableAttributedString *str3 = [NSAttributedString defaultAttributedStringWithString:WYLocalString(@"des_networkSetting3") fontColor:WY_FontColor_Gray font:font].mutableCopy;
    NSAttributedString *setting = [NSAttributedString attributedStringWithImage:[UIImage imageNamed:@"img_setting"]];
    NSAttributedString *wifi = [NSAttributedString attributedStringWithImage:[UIImage imageNamed:@"img_wifi"]];
    BOOL zh = [NSBundle wy_bundleLoadedChinese];
    [str1 appendAttributedString:zh ? setting : wifi];
    [str1 appendAttributedString:str2];
    [str1 appendAttributedString:zh ? wifi : setting];
    [str1 appendAttributedString:str3];
    return str1;
}
+ (instancetype)attributedNoDataNVRSettingCameraBinding {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    NSAttributedString *str1 =  [self bigSpacedAttributedStringWithString:WYLocalString(@"noData_nvrCameraBinding1") fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal alignment:NSTextAlignmentCenter];
    NSAttributedString *str2 =  [self bigSpacedAttributedStringWithString:@"\n" fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal alignment:NSTextAlignmentCenter];
    NSAttributedString *str3 =  [self bigSpacedAttributedStringWithString:WYLocalString(@"noData_nvrCameraBinding2") fontColor:WY_FontColor_Cyan font:WYFont_Text_XS_Normal alignment:NSTextAlignmentCenter];
    [str appendAttributedString:str1];
    [str appendAttributedString:str2];
    [str appendAttributedString:str3];
    return str;
}
+ (instancetype)attributedNoAPWIFI {
    UIColor *color = WY_FontColor_Gray;
    UIFont *font = WYFont_Text_XS_Normal;
    NSMutableAttributedString *str1 = [NSAttributedString bigSpacedAttributedStringWithString:WYLocalString(@"alert_noAPWIFI_m11")
                                                                                    fontColor:color
                                                                                         font:font].mutableCopy;
    NSAttributedString *str2 = [NSAttributedString bigSpacedAttributedStringWithString:WYLocalString(@"alert_noAPWIFI_m12")
                                                                             fontColor:color
                                                                                  font:font].mutableCopy;
    NSAttributedString *str3 = [NSAttributedString bigSpacedAttributedStringWithString:WYLocalString(@"alert_noAPWIFI_m2")
                                                                             fontColor:color
                                                                                  font:font].mutableCopy;
    NSAttributedString *str4 = [NSAttributedString bigSpacedAttributedStringWithString:WYLocalString(@"alert_noAPWIFI_m3")
                                                                             fontColor:color
                                                                                  font:font].mutableCopy;
    NSAttributedString *n = [NSAttributedString bigSpacedAttributedStringWithString:@"\n"
                                                                          fontColor:color
                                                                               font:font].mutableCopy;
    NSAttributedString *space = [NSAttributedString bigSpacedAttributedStringWithString:@" "
                                                                              fontColor:color
                                                                                   font:font].mutableCopy;
    NSAttributedString *setting = [NSAttributedString attributedStringWithImage:[UIImage imageNamed:@"img_setting"]];
    NSAttributedString *wifi = [NSAttributedString attributedStringWithImage:[UIImage imageNamed:@"img_wifi"]];
    NSAttributedString *apWIFI = [NSAttributedString attributedStringWithImage:[UIImage imageNamed:@"img_apWIFI"]];
    
    [str1 appendAttributedString:setting];
    [str1 appendAttributedString:space];
    [str1 appendAttributedString:str2];
    [str1 appendAttributedString:wifi];
    [str1 appendAttributedString:n];
    [str1 appendAttributedString:str3];
    [str1 appendAttributedString:n];
    [str1 appendAttributedString:apWIFI];
    [str1 appendAttributedString:n];
    [str1 appendAttributedString:str4];
    return str1;
}
+ (instancetype)attributedAPFailure {
    NSString *string = [NSString stringWithFormat:@"%@", WYLocalString(@"alert_apFail_checkWifi")];
    return [self defaultAttributedStringWithString:string fontColor:WY_FontColor_Gray font:WYFont_Text_S_Normal];
}
+ (instancetype)attributedSearchNull_nvr {
    NSString *string = [NSString stringWithFormat:@"%@", WYLocalString(@"alert_searchNull_deviceNoFound_nvr")];
    return [self defaultAttributedStringWithString:string fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
}
+ (instancetype)attributedSearchNull_qr {
    NSString *string = [NSString stringWithFormat:@"%@", WYLocalString(@"alert_searchNull_deviceNoFound_qrcode")];
    return [self defaultAttributedStringWithString:string fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
}
+ (instancetype)attributedSearchNull_ap {
    NSString *string = [NSString stringWithFormat:@"%@", WYLocalString(@"alert_searchNull_deviceNoFound_ap")];
    return [self defaultAttributedStringWithString:string fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
}
+ (instancetype)attributedHelp_Config {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *t1 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_1t")] fontColor:WY_FontColor_Cyan font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *m1 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_1m")] fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *t2 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_2t")] fontColor:WY_FontColor_Cyan font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *m2 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_2m")] fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *t3 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_3t")] fontColor:WY_FontColor_Cyan font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *m3 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_3m")] fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *t4 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_4t")] fontColor:WY_FontColor_Cyan font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *m4 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_4m")] fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *t5 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_5t")] fontColor:WY_FontColor_Cyan font:WYFont_Text_XS_Normal];
    NSMutableAttributedString *m5 = [self defaultAttributedStringWithString:[NSString stringWithFormat:@"%@\n", WYLocalString(@"help_config_5m")] fontColor:WY_FontColor_Gray font:WYFont_Text_XS_Normal];
    [string appendAttributedString:t1];
    [string appendAttributedString:m1];
    [string appendAttributedString:t2];
    [string appendAttributedString:m2];
    [string appendAttributedString:t3];
    [string appendAttributedString:m3];
    [string appendAttributedString:t4];
    [string appendAttributedString:m4];
    [string appendAttributedString:t5];
    [string appendAttributedString:m5];
    return string;
}

@end
