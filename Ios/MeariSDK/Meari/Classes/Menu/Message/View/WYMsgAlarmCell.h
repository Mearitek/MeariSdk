//
//  WYMsgAlarmCell.h
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYMsgAlarmCell;
@protocol WYMsgAlarmCellDelegate <NSObject>

- (void)WYMsgAlarmCell:(WYMsgAlarmCell *)cell selectButton:(UIButton *)button;

@end

@class WYMsgAlarmModel;

@interface WYMsgAlarmCell : UITableViewCell
@property (nonatomic, weak)id<WYMsgAlarmCellDelegate>delegate;
- (void)passModel:(WYMsgAlarmModel *)model edited:(BOOL)edited;
+ (CGFloat)cellHeight;
+ (CGFloat)editedCellHeight;
@end
