//
//  WYDoorBellSettingHostMessageViewCell.h
//  Meari
//
//  Created by FMG on 2017/7/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class WYDoorBellSettingHostMessageCell;
@protocol WYDoorBellSettingHostMessageCellDelegate <NSObject>

//- (void)hostMessageCell:(WYDoorBellSettingHostMessageCell *)cell play:(UIButton *)playBtn;

- (void)hostMessageCell:(WYDoorBellSettingHostMessageCell *)cell delete:(UIButton *)playBtn;
@end

@interface WYDoorBellSettingHostMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (nonatomic, assign) BOOL play;

@property (nonatomic, weak) id <WYDoorBellSettingHostMessageCellDelegate>delegate;

@end
