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
    MeariThirdLoginTypeWeChat
};

@interface MeariUserInfo : MeariBaseModel
@property (nonatomic, strong) NSString * avatarUrl;     //用户头像
@property (nonatomic, strong) NSString * nickName;      //用户昵称
@property (nonatomic, strong) NSString * userAccount;   //用户账号
@property (nonatomic, strong) NSString * userID;        //用户ID
@property (nonatomic, strong) NSString * loginTime;     //用户登录时间
@property (nonatomic, strong) NSString * pushAlias;     //用户推送别名
@property (nonatomic, strong) NSString * token;         //用户有效标识
@property (nonatomic, strong) NSString * secrect;       //用户有效标识
@property (nonatomic, strong) NSString * userKey;       //用户key
@property (nonatomic, strong) NSString * userName;      //用户名称
@property (nonatomic, strong) NSString * countryCode;   //注册国家代号
@property (nonatomic, strong) NSString * phoneCode;     //注册国家手机代号
@property (nonatomic, assign) NSInteger loginType;      //登录类型

@property (nonatomic, assign) BOOL notificationSound;   //消息推送是否有声音
@property (nonatomic, assign, readonly) MeariThirdLoginType thirdLoginType; // 登录类型
@end

