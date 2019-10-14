//
//  WYCameraListCell.h
//  Meari
//
//  Created by 李兵 on 16/1/14.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYCameraListCell;
@protocol WYCameraListCellDelegate <NSObject>

@optional
- (void)WYCameraListCell:(WYCameraListCell *)cell didSelectPlayBtn:(UIButton *)btn;
- (void)WYCameraListCell:(WYCameraListCell *)cell didSelectMsgBtn:(UIButton *)btn;
- (void)WYCameraListCell:(WYCameraListCell *)cell didLongPressedPlayBtn:(UIButton *)btn;
@end



@interface WYCameraListCell : UITableViewCell
@property (nonatomic, weak)id<WYCameraListCellDelegate> delegate;
@property (nonatomic, strong) MeariDevice *camera;

@end
