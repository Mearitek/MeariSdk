//
//  NSBundle+Extension.m
//  Meari
//
//  Created by 李兵 on 16/9/20.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "NSBundle+Extension.h"
#import "NSUserDefaults+Extension.h"

#define WY_SupportLanguage(language)  WY_ContainOption(WYAPP_Languages, language)

@implementation NSBundle (Extension)
+ (NSString *)wy_bundledLanguage {
    NSString *appLang = [NSUserDefaults wy_appLanguage];
    if (WY_SupportLanguage(WYLanguageTypeEn) && [appLang hasPrefix:WYStringLanguage_EN]) {
        return WYStringLanguage_EN;
    }
    if (WY_SupportLanguage(WYLanguageTypeZh) && [appLang hasPrefix:WYStringLanguage_ZH]) {
        return WYStringLanguage_ZH_Hans;
    }
    return WYStringLanguage_EN;
}
+ (instancetype)wy_bundle {
    static NSBundle *bundle;
    if (!bundle) {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSBundle wy_bundledLanguage] ofType:@"lproj"]];
        if (!bundle) {
            bundle = [NSBundle mainBundle];
        }  
    }
    return bundle;
}

+ (BOOL)wy_bundleLoadedChinese {
    if ([[NSBundle wy_bundledLanguage] hasPrefix:WYStringLanguage_ZH]) {
        return YES;
    }
    return NO;
}

+ (NSString *)wy_urlLanguage {
    NSString *lang = [NSBundle wy_bundledLanguage];
    if ([lang isEqualToString:WYStringLanguage_ZH_Hans]) {
        return WYStringLanguage_ZH;
    }
    return lang;
}
@end
