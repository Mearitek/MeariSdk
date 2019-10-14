//
//  WYSystem.h
//  Meari
//
//  Created by 李兵 on 2017/2/28.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#ifndef WYSystem_h
#define WYSystem_h



/**
 APP支持的本地化语言
 */
typedef NS_OPTIONS(NSUInteger, WYLanguageType) {
    WYLanguageTypeEn  = 1 << 0,     //英文
    WYLanguageTypeZh  = 1 << 1,     //中文
    WYLanguageTypeCustomizationMeari     = WYLanguageTypeEn | WYLanguageTypeZh,
};


/**
 UI风格
 */
typedef NS_ENUM(NSInteger, WYUIStytle) {
    WYUIStytleCyan,
    WYUIStytleOrange,
    WYUIStytleDefault = WYUIStytleCyan
};


#endif /* WYSystem_h */
