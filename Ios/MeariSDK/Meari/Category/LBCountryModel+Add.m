//
//  LBCountryModel+Add.m
//  Meari
//
//  Created by 李兵 on 2017/12/26.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "LBCountryModel+Add.h"

@implementation LBCountryModel (Add)
+ (instancetype)wy_localCountry {
    NSDictionary *dic = [NSLocale componentsFromLocaleIdentifier:[NSLocale currentLocale].localeIdentifier];
    NSString *countryCode = dic[NSLocaleCountryCode];
    NSLocale *loc;
    if (countryCode) {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleLanguageCode:[NSBundle wy_bundledLanguage],
                                                                          NSLocaleCountryCode:countryCode
                                                                          }];
        loc = [NSLocale localeWithLocaleIdentifier:identifier];
    }
    if (!loc) {
        loc = [NSLocale currentLocale];
    }
    return [LBCountryModel countryWithLocale:loc];
}
@end
