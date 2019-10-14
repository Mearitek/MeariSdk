//
//  WYVoiceDoorbellMsgVoiceCell.h
//  Meari
//
//  Created by MJ2009 on 2018/7/5.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYVoiceMsgModel.h"

@interface WYVoiceDoorbellMsgVoiceCell : UITableViewCell
@property (nonatomic, strong) void(^deleteAction)(void);
@property (nonatomic, strong) void(^playAction)(WYVoiceMsgModel *model);
@property (nonatomic, strong) void(^stopAction)(WYVoiceMsgModel *model);

@property (nonatomic, strong) WYVoiceMsgModel *model;
@property (nonatomic, assign) BOOL isPlaying;
- (void)showLoading;
- (void)hideLoading;
@end
