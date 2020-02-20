//
//  MeariFriendInfoForFriend.h
//  MeariKit
//
//  Created by Meari on 2017/12/19.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeariFriendInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger userID;     //好友ID
@property (nonatomic, copy) NSString *userAccount;  //好友账号
@property (nonatomic, copy) NSString *nickName;     //好友昵称
@property (nonatomic, copy) NSString *avatarUrl;    //好友头像
@property (nonatomic, assign) BOOL deviceShared;    //设备是否给好友分享
@end
