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
@property (nonatomic, strong) NSString * avatarUrl;     //user's avatar
@property (nonatomic, strong) NSString * nickName;      //user's nickname
@property (nonatomic, strong) NSString * userAccount;   //user's account
@property (nonatomic, strong) NSString * userID;        //user's id
@property (nonatomic, strong) NSString * loginTime;     //user's login timestamp
@property (nonatomic, strong) NSString * pushAlias;     //user's push alias for jpush
@property (nonatomic, strong) NSString * token;         //user's token
@property (nonatomic, strong) NSString * secrect;       //user's secrect
@property (nonatomic, strong) NSString * userKey;       //user's key
@property (nonatomic, strong) NSString * userName;      //user's name
@property (nonatomic, strong) NSString * countryCode;   //Registered country code
@property (nonatomic, strong) NSString * phoneCode;     //Registered country phone code
@property (nonatomic, assign) NSInteger loginType;      //Login type
@property (nonatomic, assign) BOOL notificationSound;   //Whether the message is pushed or not
@property (nonatomic, assign, readonly) MeariThirdLoginType thirdLoginType; // Login type
@end

