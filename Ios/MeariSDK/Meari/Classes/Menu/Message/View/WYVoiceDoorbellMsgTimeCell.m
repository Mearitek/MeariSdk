//
//  WYVoiceDoorbellMsgTimeCell.m
//  Meari
//
//  Created by MJ2009 on 2018/7/5.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYVoiceDoorbellMsgTimeCell.h"

@interface WYVoiceDoorbellMsgTimeCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@end

@implementation WYVoiceDoorbellMsgTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.timeLB.font = WYFont_Text_XS_Normal;
    self.timeLB.textColor = WY_FontColor_Gray;
}

- (void)setModel:(WYVoiceMsgModel *)model {
    _model = model;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createDateInterval/1000];
    self.timeLB.text = [date WY_timeString];
}

@end
