//
//  NSUserDefaults+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/2/28.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSUserDefaults (Extension)

+ (NSString *)wy_appLanguage;


/**
 设置
 */
- (void)wy_setObject:(id)obj forkey:(NSString *)key;

/**
 获取
 */
- (id)wy_objectForKey:(NSString *)key;

/**
 移除
 */
- (void)wy_removeObjectforKey:(NSString *)key;

@end
