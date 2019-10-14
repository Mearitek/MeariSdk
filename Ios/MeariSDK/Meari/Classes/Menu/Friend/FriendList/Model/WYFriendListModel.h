//
//  WYFriendListModel.h
//  Meari
//
//  Created by 李兵 on 2017/9/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseModel.h"

@interface WYFriendListModel : WYBaseModel

@property (nonatomic, copy)MeariFriendInfo *info;
@property (nonatomic, assign) BOOL selected;
@end
