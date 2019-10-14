//
//  WYNVRSettingCameraBindingCell.h
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYNVRSettingCameraBindingCell;
@protocol WYNVRSettingCameraBindingCellDelegate <NSObject>

- (void)WYNVRSettingCameraBindingCell:(WYNVRSettingCameraBindingCell *)cell didClickAddBtn:(UIButton *)addBtn;

@end


@class WYNVRSettingCameraListModel;
@interface WYNVRSettingCameraBindingCell : UITableViewCell

@property (nonatomic, weak)id<WYNVRSettingCameraBindingCellDelegate> delegate;
@property (nonatomic, strong)WYNVRSettingCameraListModel *model;
@end
