//
//  WYCameraSearchCell.h
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYCameraSearchCell;
@protocol WYCameraSearchCellDelegate <NSObject>

@optional
- (void)WYCameraSearchCell:(WYCameraSearchCell *)cell tapActionButtonToAdd:(UIButton *)btn;
- (void)WYCameraSearchCell:(WYCameraSearchCell *)cell tapActionButtonToShare:(UIButton *)btn;


@end

@interface WYCameraSearchCell : UITableViewCell
@property (nonatomic, weak)id<WYCameraSearchCellDelegate> delegate;
@property (nonatomic, strong)MeariDevice *device;
@end
