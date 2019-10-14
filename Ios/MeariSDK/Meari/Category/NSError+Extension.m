//
//  NSError+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/6/29.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "NSError+Extension.h"

@implementation NSError (Extension)
+ (instancetype)wy_errorWithDomain:(NSString *)domain {
    return [NSError errorWithDomain:domain code:0 userInfo:nil];
}

@end


@implementation NSError (WYConst)
+ (instancetype)wy_noNetwork {
    return [NSError errorWithDomain:WYLocalString(@"status_networkError") code:WYErrorCodeNoNetwork userInfo:nil];
}
+ (instancetype)wy_networkOvertime {
    return [NSError errorWithDomain:WYLocalString(@"status_networkOvertime") code:WYErrorCodeNetworkOvertime userInfo:nil];
}
+ (instancetype)wy_networkError {
    return [NSError errorWithDomain:WYLocalString(@"status_networkError") code:WYErrorCodeNetworkError userInfo:nil];
}
+ (instancetype)wy_serverDataError {
    return [NSError errorWithDomain:WYLocalString(@"status_serverAbnormal") code:WYErrorCodeServerError userInfo:nil];
}
+ (instancetype)wy_serverError {
    return [NSError errorWithDomain:WYLocalString(@"status_serverDataAbnormal") code:WYErrorCodeServerError userInfo:nil];
}
+ (instancetype)wy_loginInvalid {
    return [NSError errorWithDomain:WYLocalString(@"status_loginInvalid") code:WYErrorCodeLoginInvalid userInfo:nil];
}
@end
