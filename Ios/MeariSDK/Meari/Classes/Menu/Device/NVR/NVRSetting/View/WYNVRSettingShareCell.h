//
//  WYNVRSettingShareCell.h
//  Meari
//
//  Created by 李兵 on 2017/1/12.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYNVRSettingShareModel.h"

@class WYNVRSettingShareCell;
@protocol WYNVRSettingShareCellDelegate <NSObject>

- (void)WYNVRSettingShareCell:(WYNVRSettingShareCell *)cell didTapedSelectedBtn:(UIButton *)button;
@end

@interface WYNVRSettingShareCell : UITableViewCell
@property (weak, nonatomic) id<WYNVRSettingShareCellDelegate>delegate;
@property (nonatomic, strong)WYNVRSettingShareModel *model;
@end
