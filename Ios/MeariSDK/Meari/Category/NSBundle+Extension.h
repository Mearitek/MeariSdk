//
//  NSBundle+Extension.h
//  Meari
//
//  Created by 李兵 on 16/9/20.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WY_BundleCH  [NSBundle wy_bundleLoadedChinese]

@interface NSBundle (Extension)
+ (NSString *)wy_bundledLanguage;
+ (instancetype)wy_bundle;

+ (BOOL)wy_bundleLoadedChinese;

+ (NSString *)wy_urlLanguage;


@end
