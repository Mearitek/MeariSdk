//
//  WYMsgAlarmDetailNormalCell.h
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYMsgAlarmDetailModel;
@class WYMsgAlarmDetailNormalCell;
@protocol WYMsgAlarmDetailNormalCellDelegate <NSObject>

- (void)WYMsgAlarmDetailNormalCell:(WYMsgAlarmDetailNormalCell *)cell didTapActionBtn:(UIButton *)button;
- (void)WYMsgAlarmDetailNormalCell:(WYMsgAlarmDetailNormalCell *)cell didTapImageView:(UIImageView *)imageView;


@end

@interface WYMsgAlarmDetailNormalCell : UITableViewCell

@property (nonatomic, weak)id<WYMsgAlarmDetailNormalCellDelegate>delegate;
@property (nonatomic, assign)BOOL hideBottomLine;
- (void)passModel:(WYMsgAlarmDetailModel *)model edited:(BOOL)edited;

+ (CGFloat)cellHeight;

@end
