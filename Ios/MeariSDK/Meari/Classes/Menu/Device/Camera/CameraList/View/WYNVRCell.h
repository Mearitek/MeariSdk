//
//  WYNVRCell.h
//  Meari
//
//  Created by 李兵 on 2016/10/17.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WYNVRCell;
@protocol WYNVRCellDelegate <NSObject>

@optional
- (void)WYNVRCell:(WYNVRCell *)cell didSelectSettingBtn:(UIButton *)btn;
@end


@interface WYNVRCell : UITableViewCell
@property (nonatomic, weak)id<WYNVRCellDelegate> delegate;
@property (nonatomic, strong)MeariDevice *nvr;

@end

