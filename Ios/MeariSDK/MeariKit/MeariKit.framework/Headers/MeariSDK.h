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
 */
@property (nonatomic, copy) NSString *sdkPushLanguage;

/**
Get the SDK version
 
 */
- (NSString *)sdkVersion;

/* Notes: The following interfaces need to be configured when the app starts. */

/**
 Start SDK

 @param appKey appKey
 @param secretKey secret
 */
- (void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;


/**
Set debug print level

 @param logLevel level
 */
- (void)setLogLevel:(MeariLogLevel)logLevel;


/*  After switching the server environment or domain name, you need to log in again */
/**
Configuring the server environment

 @param environment MearEnvironmentPrerelease or MearEnvironmentRelease
 */
- (void)configEnvironment:(MearEnvironment)environment;



@end
