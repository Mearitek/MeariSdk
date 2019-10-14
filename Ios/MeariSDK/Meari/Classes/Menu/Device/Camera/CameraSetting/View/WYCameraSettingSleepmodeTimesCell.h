//
//  WYCameraSettingSleepmodeTimesCell.h
//  Meari
//
//  Created by 李兵 on 2017/1/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYCameraSettingSleepmodeTimesCell;
@protocol WYCameraSettingSleepmodeTimesCellDelegate <NSObject>

- (void)WYCameraSettingSleepmodeTimesCell:(WYCameraSettingSleepmodeTimesCell *)cell switchTime:(BOOL)switched;
- (void)WYCameraSettingSleepmodeTimesCell:(WYCameraSettingSleepmodeTimesCell *)cell selectBtn:(UIButton *)selectBtn;


@end

@class WYCameraSettingSleepmodeTimesModel;
@interface WYCameraSettingSleepmodeTimesCell : UITableViewCell

@property (nonatomic, weak)id<WYCameraSettingSleepmodeTimesCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (void)passModel:(WYCameraSettingSleepmodeTimesModel *)model edited:(BOOL)edited;
@end
