//
//  NSError+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/6/29.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WYErrorCode) {
    WYErrorCodeNone,
    WYErrorCodeNoNetwork,
    WYErrorCodeNetworkOvertime,
    WYErrorCodeNetworkError,
    WYErrorCodeServerError,
    WYErrorCodeLoginInvalid,
};


@interface NSError (Extension)
+ (instancetype)wy_errorWithDomain:(NSString *)domain;
@end

@interface NSError (WYConst)
+ (instancetype)wy_noNetwork;
+ (instancetype)wy_networkOvertime;
+ (instancetype)wy_networkError;
+ (instancetype)wy_serverDataError;
+ (instancetype)wy_serverError;
+ (instancetype)wy_loginInvalid;

@end
