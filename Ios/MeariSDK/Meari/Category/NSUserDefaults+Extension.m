//
//  NSUserDefaults+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/2/28.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "NSUserDefaults+Extension.h"

@implementation NSUserDefaults (Extension)

+ (NSString *)wy_appLanguage {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    if (WY_IsKindOfClass(dic, NSDictionary)) {
        NSArray *arr = [dic objectForKey:@"AppleLanguages"];
        if (WY_IsKindOfClass(arr, NSArray)) {
            NSString *lang = arr.firstObject;
            if (WY_IsKindOfClass(lang, NSString)) {
                return lang;
            }
        }
        
    }
    return WYStringLanguage_EN;
}

/**
 设置
 */
- (void)wy_setObject:(id)obj forkey:(NSString *)key {
    
    if (!key) return;
    
    if (!obj) {
        [self setValue:nil forKey:key];
    }else if (WY_IsKindOfClass(obj, NSString)) {
        [self setValue:obj forKey:key];
    }else {
        [self setObject:obj forKey:key];
    }
    [self synchronize];
}

/**
 获取
 */
- (id)wy_objectForKey:(NSString *)key {
    if (WY_IsKindOfClass(key, NSString)) {
        return [self objectForKey:key];
    }
    return nil;
}

/**
 移除
 */
- (void)wy_removeObjectforKey:(NSString *)key {
    if (WY_IsKindOfClass(key, NSString)) {
        [self removeObjectForKey:key];
        [self synchronize];
    }
}
@end
