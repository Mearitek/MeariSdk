//
//  WYFriendListCell.h
//  Meari
//
//  Created by 李兵 on 2017/9/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYFriendListModel;
@interface WYFriendListCell : UITableViewCell

- (void)passModel:(WYFriendListModel *)model edited:(BOOL)edited;

@end
