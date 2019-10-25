//
//  MeariFriendInfoForFriend.h
//  MeariKit
//
//  Created by Meari on 2017/12/19.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariFriendInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger userID;     //friend's id
@property (nonatomic, copy) NSString *userAccount;  //friend's account
@property (nonatomic, copy) NSString *nickName;     //friend's nickname
@property (nonatomic, copy) NSString *avatarUrl;    //friend's avatar
@property (nonatomic, assign) BOOL deviceShared;    //whether device is shared
@end
