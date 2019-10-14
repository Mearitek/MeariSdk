//
//  WYMsgSystemCell.h
//  Meari
//
//  Created by 李兵 on 16/3/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYMsgSystemCell;
@protocol WYMsgSystemCellDelegate <NSObject>

- (void)WYMsgSystemCell:(WYMsgSystemCell *)cell selectButton:(UIButton *)button;

@end

@class WYMsgSystemModel;
@interface WYMsgSystemCell : UITableViewCell

@property (nonatomic, weak)id<WYMsgSystemCellDelegate>delegate;
- (void)passModel:(WYMsgSystemModel *)model edited:(BOOL)edited;

@end
