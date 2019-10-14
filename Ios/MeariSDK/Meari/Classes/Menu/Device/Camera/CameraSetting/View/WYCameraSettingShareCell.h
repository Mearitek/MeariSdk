//
//  WYCameraSettingShareCell.h
//  Meari
//
//  Created by 李兵 on 16/8/15.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYCameraSettingShareCell;
@protocol WYShareCellDelegate <NSObject>

- (void)WYCameraSettingShareCell:(WYCameraSettingShareCell *)cell didTapedSelectedBtn:(UIButton *)button;
@end


@class WYCameraSettingShareModel;
@interface WYCameraSettingShareCell : UITableViewCell

@property (weak, nonatomic) id<WYShareCellDelegate>delegate;
@property (strong, nonatomic)WYCameraSettingShareModel *model;

@end
