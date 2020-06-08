//
//  MeariFriendInfoForFriend.h
//  MeariKit
//
//  Created by Meari on 2017/12/19.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariFriendInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger userID;     // friend's id (好友ID)
@property (nonatomic, copy) NSString *userAccount;  // friend's account (好友账号)
@property (nonatomic, copy) NSString *nickName;     // friend's nickname (好友昵称)
@property (nonatomic, copy) NSString *avatarUrl;    // friend's avatar (好友头像)
@property (nonatomic, assign) BOOL deviceShared;    // whether device is shared (设备是否给好友分享)

@end
