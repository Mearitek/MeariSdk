//
//  WYMsgAlarmDetailBigCell.h
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WYMsgAlarmDetailModel;
@class WYMsgAlarmDetailBigCell;
@protocol WYMsgAlarmDetailBigCellDelegate <NSObject>

- (void)WYMsgAlarmDetailBigCell:(WYMsgAlarmDetailBigCell *)cell didTapActionBtn:(UIButton *)button;
- (void)WYMsgAlarmDetailBigCell:(WYMsgAlarmDetailBigCell *)cell didTapImageView:(UIImageView *)imageView;

@end

@interface WYMsgAlarmDetailBigCell : UITableViewCell

@property (nonatomic, weak)id<WYMsgAlarmDetailBigCellDelegate>delegate;
@property (nonatomic, assign)BOOL hideBottomLine;
- (void)passModel:(WYMsgAlarmDetailModel *)model edited:(BOOL)edited;

+ (CGFloat)cellHeight;
+ (CGFloat)editedCellHeight;

@end


