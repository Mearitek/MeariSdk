//
//  WYUserManger.h
//  Meari
//
//  Created by Strong on 15/11/26.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WY_UserM [WYUserManger sharedWYUserManger]

@interface WYUserManger : NSObject
@property (nonatomic, assign, readonly, getter=isLogined)BOOL logined;
@property (nonatomic, assign, readonly, getter=isUidLogined)BOOL uidLogined;
@property (nonatomic, copy, readonly) NSString *account;
@property (nonatomic, copy, readonly) NSString *avatar;
@property (nonatomic, copy, readonly) NSString *nickname;

@property (nonatomic, copy) NSString *configToken;
@property (nonatomic, copy)NSString *previousUserAccount;
@property (nonatomic, copy)NSString *pushAlias;

/**
 初始化
 */
WY_Singleton_Interface(WYUserManger)
- (instancetype)init NS_UNAVAILABLE;


/**
 基本操作
 */
- (void)setUserObject:(id)obj forkey:(NSString *)key;
- (id)getUserObjectForKey:(NSString *)key;
- (void)removeUserObjectforKey:(NSString *)key;

/**
 登入登出
 */
- (void)signIn:(MeariUserInfo *)userInfo;
- (void)signOut;

- (void)dealMeariUserError:(NSError *)error;
@end

