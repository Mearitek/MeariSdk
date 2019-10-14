//
//  WYNVRSettingCameraListCell.h
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYNVRSettingCameraListModel.h"

@class WYNVRSettingCameraListCell;
@protocol WYNVRSettingCameraListCellDelegate <NSObject>

- (void)WYNVRSettingCameraListCell:(WYNVRSettingCameraListCell *)cell selectButton:(UIButton *)button;

@end

@interface WYNVRSettingCameraListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, weak)id<WYNVRSettingCameraListCellDelegate>delegate;
- (void)passModel:(WYNVRSettingCameraListModel *)model edited:(BOOL)edited;

@end
