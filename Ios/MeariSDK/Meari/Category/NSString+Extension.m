//
//  NSString+Extension.m
//  Meari
//
//  Created by 李兵 on 15/11/26.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
/**
 基础
 */
- (NSRange)wy_range {
    return NSMakeRange(0, self.length);
}
- (NSURL *)wy_url {
    return [NSURL URLWithString:self];
}
- (instancetype)wy_urlString {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (NSArray *)wy_jsonArray {
    if (!self) return nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([arr isKindOfClass:[NSArray class]]) {
        return arr;
    }
    return nil;
}
- (NSDictionary *)wy_jsonDictionary {
    if (!self) return nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    return nil;
}
- (NSAttributedString *)wy_attributedString {
    return [[NSAttributedString alloc] initWithString:self];
}
- (NSMutableAttributedString *)wy_mutableAttributedString {
    return [[NSMutableAttributedString alloc] initWithString:self];
}

/**
 字符拼接+删除
 */
- (instancetype)wy_stringByTrimWhiteSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (instancetype)wy_stringByAppendingQueryDic:(NSDictionary *)dic {
    if (!WY_IsKindOfClass(dic, NSDictionary)) return self;
    
    __block NSString *copy = self.copy;
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        copy = [copy wy_stringByAppendingQueryKey:key value:obj];
    }];
    return copy;
}

/**
 Emoji
 */
- (BOOL)wy_containsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
    
}
- (instancetype)wy_stringByFilerEmoji {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex stringByReplacingMatchesInString:self options:0 range:self.wy_range withTemplate:@""];
}

/**
 验证邮箱、手机号
 */
- (BOOL)wy_validateEmail {
    NSString *str = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *r = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    BOOL validated = [r evaluateWithObject:self];
    return validated;
}
- (BOOL)wy_validateTelPhone{
    NSString *str = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    NSPredicate *r = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    BOOL validated = [r evaluateWithObject:self];
    return validated;
}
- (BOOL)wy_validateAccount {
    return [self wy_validateEmail] || [self wy_validateTelPhone];
}
- (BOOL)wy_validatePassword {
    NSString *str = @".{6,20}$";
    NSPredicate *r = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    BOOL validated = [r evaluateWithObject:self];
    return validated;
}

/**
 计算高度
 */
- (CGFloat)wy_heightWithWidth:(CGFloat)width font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    [style setLineBreakMode:breakMode];
    NSDictionary *attributes       = @{NSFontAttributeName : font,
                                       NSParagraphStyleAttributeName: style
                                       };
    
    CGRect rect = CGRectIntegral([self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options attributes:attributes context:nil]);
    return rect.size.height;
}

#pragma mark - Private
- (instancetype)wy_stringByAppendingQueryKey:(NSString *)key value:(NSString *)value {
    if (self.length <= 0 || !key || !value) return self;
    
    NSURL *url = [NSURL URLWithString:self];
    if (!url) return self;
    
    if ([url.query rangeOfString:key].length > 0) return self;
    
    NSString *copy = self.copy;
    if (!url.query) {
        copy = [copy stringByAppendingString:@"?"];
        url = [NSURL URLWithString:copy];
    }
    if (url.query.length > 0 && [url.query characterAtIndex:url.query.length - 1] != '&') {
        copy = [copy stringByAppendingString:@"&"];
    }
    copy = [copy stringByAppendingFormat:@"%@=%@", key, value];
    
    return copy;
}

@end



@implementation NSString (WYTool)

/**
 日期处理
 */
- (instancetype)wy_YMDString {
    if (self.length != 14) return nil;
    NSString *year = [self substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [self substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [self substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
}
- (instancetype)wy_HMSString {
    if (self.length != 14) return nil;
    NSString *hour = [self substringWithRange:NSMakeRange(8, 2)];
    NSString *min = [self substringWithRange:NSMakeRange(10, 2)];
    NSString *second = [self substringWithRange:NSMakeRange(12, 2)];
    return [NSString stringWithFormat:@"%@:%@:%@", hour, min, second];
}
- (instancetype)wy_dateString {
    //格式为：20151211120503 --> 2015-12-11 12:05:03
    if (self.length < 14) return nil;
    
    NSString *year   = [self substringWithRange:NSMakeRange(0, 4)];
    NSString *month  = [self substringWithRange:NSMakeRange(4, 2)];
    NSString *day    = [self substringWithRange:NSMakeRange(6, 2)];
    NSString *hour   = [self substringWithRange:NSMakeRange(8, 2)];
    NSString *minute = [self substringWithRange:NSMakeRange(10, 2)];
    NSString *second = [self substringWithRange:NSMakeRange(12, 2)];
    
    return [NSString stringWithFormat:@"%@-%@-%@  %@:%@:%@", year, month, day, hour, minute, second];
}
- (int)wy_secondsInYMDHMSStringWithSprit {
    //格式如：2016/08/09/20/20/20
    NSString *string = [self stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return [string wy_secondsInYMDHMSString];
}
- (int)wy_dayInYMDHMSStringWithSprit {
    //格式如：2016/08/09/20/20/20
    NSString *string = [self stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (string.length != 14) return 0;
    return [string substringWithRange:NSMakeRange(6, 2)].intValue;
}

/**
 版本处理
 */
- (instancetype)wy_shortVersion {
    NSMutableString *shortString = self.mutableCopy;
    NSRange range = [self rangeOfString:@"-" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        /** 截取最后一个"-"之后的字符串 **/
        [shortString deleteCharactersInRange:NSMakeRange(0, range.location+1)];
    }
    return shortString;
}
- (instancetype)wy_shortVersionButDate {
    NSMutableString *shortString = self.wy_shortVersion.mutableCopy;
    NSRange range = [shortString rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        /** 截取最后一个"."之前的字符串 **/
        [shortString deleteCharactersInRange:NSMakeRange(range.location, shortString.length-range.location)];
        return shortString;
    }
    return nil;
}

#pragma mark - Private
- (int)wy_secondsInYMDHMSString {
    //格式如：20160809202020
    if (self.length != 14) return 0;
    int h = [self substringWithRange:NSMakeRange(8, 2)].intValue;
    int m = [self substringWithRange:NSMakeRange(10, 2)].intValue;
    int s = [self substringWithRange:NSMakeRange(12, 2)].intValue;
    return h*3600 + m*60 + s;
}

@end


@implementation NSString (WYConst)

/**
 Setting相关
 */
+ (instancetype)wy_setting_Privacy {
    return [[self wy_setting_prefs] stringByAppendingString:WYSetting_Privacy];
}
+ (instancetype)wy_setting_Wifi {
    return [[self wy_setting_prefs] stringByAppendingString:WYSetting_Wifi];
}
+ (instancetype)wy_setting_App {
    return WY_Version_GreaterThanOrEqual_8 ? UIApplicationOpenSettingsURLString : [self wy_setting_Privacy];
}
#pragma mark - Private
+ (instancetype)wy_setting_prefs {
    return WY_Version_GreaterThanOrEqual_10 ? WYSetting_Prefs10 : WYSetting_Prefs8;
}


/**
 占位符
 */
+ (instancetype)wy_placeholder_friend_account {
    return WYLocalString(@"friend_placeholder");
}
+ (instancetype)wy_placeholder_me_account {
    return WYLocalString(@"me_accout_placeholder");
}
+ (instancetype)wy_placeholder_me_account_email {
    return WYLocalString(@"me_accout_placeholder_email");
}
+ (instancetype)wy_placeholder_me_account_email_phone {
    return WYLocalString(@"me_accout_placeholder_email_phone");
}


/**
 本地化文本
 */
+ (instancetype)wy_local_help_config_des {
    return WYLocalString(@"des_help_lightInOtherStatus_detail");
}
@end


