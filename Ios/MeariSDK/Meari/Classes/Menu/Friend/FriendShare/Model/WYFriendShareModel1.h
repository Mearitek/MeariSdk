//
//  WYFriendShareModel1.h
//  Meari
//
//  Created by 李兵 on 2017/9/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseModel.h"

@interface WYFriendShareModel1 : WYBaseModel

@property (nonatomic, assign) BOOL editable;

+ (instancetype)friend_mark:(NSString *)mark;
+ (instancetype)friend_account:(NSString *)account;

@end
