//
//  WYFriendShareModel1.m
//  Meari
//
//  Created by 李兵 on 2017/9/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendShareModel1.h"

@implementation WYFriendShareModel1
+ (instancetype)friend_mark:(NSString *)mark {
    WYFriendShareModel1 *m = [WYFriendShareModel1 modelWithImageName:nil text:WYLocalString(@"friendShare_mark") deatailedText:mark];
    m.editable = YES;
    return m;
}
+ (instancetype)friend_account:(NSString *)account {
    WYFriendShareModel1 *m = [WYFriendShareModel1 modelWithImageName:nil text:WYLocalString(@"friendShare_account") deatailedText:account];
    m.editable = NO;
    return m;
}
@end
