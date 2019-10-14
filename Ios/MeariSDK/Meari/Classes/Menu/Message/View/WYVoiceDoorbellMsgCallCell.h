//
//  WYVoiceDoorbellMsgCallCell.h
//  Meari
//
//  Created by MJ2009 on 2018/7/5.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYVoiceMsgModel.h"

@interface WYVoiceDoorbellMsgCallCell : UITableViewCell
@property (nonatomic, strong) void(^deleteAction)(void);
@property (nonatomic, strong) WYVoiceMsgModel *model;
@end
