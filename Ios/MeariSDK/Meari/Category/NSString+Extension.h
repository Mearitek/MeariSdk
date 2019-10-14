//
//  NSString+Extension.h
//  Meari
//
//  Created by 李兵 on 15/11/26.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extension)

/**
 基础
 */
- (NSRange)wy_range;
- (NSURL *)wy_url;
- (instancetype)wy_urlString;
- (NSArray *)wy_jsonArray;
- (NSDictionary *)wy_jsonDictionary;
- (NSAttributedString *)wy_attributedString;
- (NSMutableAttributedString *)wy_mutableAttributedString;

/**
 字符拼接+删除
 */
- (instancetype)wy_stringByTrimWhiteSpace;
- (instancetype)wy_stringByAppendingQueryDic:(NSDictionary *)dic;

/**
 Emoji
 */
- (BOOL)wy_containsEmoji;
- (instancetype)wy_stringByFilerEmoji;

/**
 验证邮箱、手机号
 */
- (BOOL)wy_validateEmail;
- (BOOL)wy_validateTelPhone;
- (BOOL)wy_validateAccount;
- (BOOL)wy_validatePassword;


/**
 计算高度
 */
- (CGFloat)wy_heightWithWidth:(CGFloat)width font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode;

@end


@interface NSString (WYTool)

/**
 日期处理
 */
- (instancetype)wy_YMDString;
- (instancetype)wy_HMSString;
- (instancetype)wy_dateString;
- (int)wy_secondsInYMDHMSStringWithSprit;
- (int)wy_dayInYMDHMSStringWithSprit;

/**
 版本处理
 */
- (instancetype)wy_shortVersion;
- (instancetype)wy_shortVersionButDate;

@end


@interface NSString (WYConst)


/**
 Setting相关
 */
+ (instancetype)wy_setting_Privacy;
+ (instancetype)wy_setting_Wifi;
+ (instancetype)wy_setting_App;

/**
 占位符
 */
+ (instancetype)wy_placeholder_friend_account;
+ (instancetype)wy_placeholder_me_account;
+ (instancetype)wy_placeholder_me_account_email;
+ (instancetype)wy_placeholder_me_account_email_phone;

/**
 本地化文本
 */
+ (instancetype)wy_local_help_config_des;

@end

