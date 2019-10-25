//
//  MeariSDK.h
//  MeariKit
//
//  Created by Meari on 2017/12/12.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(NSString *success);
typedef void(^Failure)(NSString *failure);

@interface MeariSDK : NSObject

+ (instancetype)sharedInstance;

/**
 sdk 推送的语言, 可不传,默认和手机本地语言一致,动态改变 . 设置之后,推送语言将设置为一种,如果设置为"zh", 则推送中文
 */
@property (nonatomic, copy) NSString *sdkPushLanguage;

/**
 获取SDK版本
 
 */
- (NSString *)sdkVersion;

/* Notes: 下列接口均需在app启动时，进行配置 */

/**
 启动SDK

 @param appKey appKey
 @param secretKey secret
 */
- (void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;


/**
 设置调试打印级别

 @param logLevel 打印级别
 */
- (void)setLogLevel:(MeariLogLevel)logLevel;


/* 切换服务器环境或域名后，需要重新登录 */
/**
 配置服务器环境

 @param environment 预发或正式
 */
- (void)configEnvironment:(MearEnvironment)environment;



@end
