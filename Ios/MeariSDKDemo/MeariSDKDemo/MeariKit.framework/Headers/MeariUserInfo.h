//
//  MeariUserInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/13.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MeariThirdLoginType) {
    MeariThirdLoginTypeAccount = 0,
    MeariThirdLoginTypeFacebook,
    MeariThirdLoginTypeTwitter,
    MeariThirdLoginTypeWeChat,
    MeariThirdLoginTypeApple
};

@interface MeariUserInfo : MeariBaseModel
@property (nonatomic, strong) NSString * avatarUrl;     // user's avatar (用户头像)
@property (nonatomic, strong) NSString * nickName;      // user's nickname (用户昵称)
@property (nonatomic, strong) NSString * userAccount;   // user's account (用户账号)
@property (nonatomic, strong) NSString * userID;        // user's id (用户ID)
@property (nonatomic, strong) NSString * loginTime;     // user's login timestamp (用户登录时间)
@property (nonatomic, strong) NSString * pushAlias;     // user's push alias for jpush (用户推送别名)
@property (nonatomic, strong) NSString * token;         // user's token (用户有效标识)
@property (nonatomic, strong) NSString * secrect;       // user's secrect (用户有效标识)
@property (nonatomic, strong) NSString * userKey;       // user's key (用户key)
@property (nonatomic, strong) NSString * userName;      // user's name (用户名称)
@property (nonatomic, strong) NSString * countryCode;   // Registered country code (注册国家代号)
@property (nonatomic, strong) NSString * phoneCode;     // Registered country phone code (注册国家手机代号)
@property (nonatomic, assign) NSInteger loginType;      // Login type (登录类型)
@property (nonatomic, strong) NSString * appleID;       // Login type (苹果apple id)

@property (nonatomic, assign) BOOL notificationSound;   // Whether the message is pushed or not (消息推送是否有声音)
@property (nonatomic, assign, readonly) MeariThirdLoginType thirdLoginType; // Login type (登录类型)
@end

@interface MeariUserFaceInfo : MeariBaseModel

@property (nonatomic, strong) NSString * faceUrl;     // user's avatar (用户头像)
@property (nonatomic, strong) NSString * userName;      // user's nickname (用户昵称)
@property (nonatomic, strong) NSString * faceID;      // user's nickname (用户人脸ID)

@end
