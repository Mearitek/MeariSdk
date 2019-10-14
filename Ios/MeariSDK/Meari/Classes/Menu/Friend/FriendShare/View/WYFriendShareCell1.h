//
//  WYFriendShareCell1.h
//  Meari
//
//  Created by 李兵 on 2017/9/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYFriendShareCell1;
@protocol WYFriendShareCell1Delegate <NSObject>
@optional
- (void)WYFriendShareCell1:(WYFriendShareCell1 *)cell didTapedSaveBtn:(UIButton *)sender;

@end

@class WYFriendShareModel1;
@interface WYFriendShareCell1 : UITableViewCell
@property (nonatomic, weak)id<WYFriendShareCell1Delegate>delegate;
@property (nonatomic, strong)WYFriendShareModel1 *model;
@end
