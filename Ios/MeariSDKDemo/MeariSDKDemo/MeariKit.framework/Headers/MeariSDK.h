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
 The language that sdk pushes, the default is the same as the local language of the mobile phone. After setting, the push language will be set to one, if set to "zh", push Chinese
 sdk 推送的语言, 可不传,默认和手机本地语言一致,动态改变 . 设置之后,推送语言将设置为一种,如果设置为"zh", 则推送中文
 */
@property (nonatomic, copy) NSString *sdkPushLanguage;

/**
 Get the SDK version
 获取SDK版本
 */
- (NSString *)sdkVersion;

/* Notes: The following interfaces need to be configured when the app starts. */
/* Notes: 下列接口均需在app启动时，进行配置 */

/**
 Start SDK
 启动SDK

 @param appKey appKey
 @param secretKey secret
 */
- (void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;


/**
 Set debug print level
 设置调试打印级别

 @param logLevel level (打印级别)
 */
- (void)setLogLevel:(MeariLogLevel)logLevel;

/*  After switching the server environment or domain name, you need to log in again */
/* 切换服务器环境或域名后，需要重新登录 */
/**
 Configuring the server environment
 配置服务器环境

 @param environment MearEnvironmentPrerelease or MearEnvironmentRelease (预发或正式)
 */
- (void)configEnvironment:(MearEnvironment)environment;


/* 访问指定服务器域名 */
/**
 配置服务器环境

 @param url 服务器域名
 */
- (void)setPrivateCloudUrl:(NSString*)url success:(Success)success failure:(Failure)failure;

@end
