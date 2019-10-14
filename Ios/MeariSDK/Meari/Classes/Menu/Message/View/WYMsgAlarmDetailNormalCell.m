//
//  WYMsgAlarmDetailNormalCell.m
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgAlarmDetailNormalCell.h"
#import "WYMsgAlarmDetailModel.h"

@interface WYMsgAlarmDetailNormalCell ()
@property (weak, nonatomic) IBOutlet UIView *topVerticalLine;
@property (weak, nonatomic) IBOutlet UIView *bottomVerticalLine;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *alarmImageView;
@property (weak, nonatomic) IBOutlet UILabel *alarmTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *maskBtn;

@end

@implementation WYMsgAlarmDetailNormalCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.actionBtn.layer.cornerRadius = self.actionBtn.height/2;
    self.actionBtn.layer.masksToBounds = YES;
    self.alarmImageView.layer.cornerRadius = 5;
    self.alarmImageView.layer.masksToBounds = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topVerticalLine.backgroundColor = WY_LineColor_LightGray;
    self.bottomVerticalLine.backgroundColor = WY_LineColor_LightGray;
    self.alarmTypeLabel.textColor = WY_FontColor_LightGray;
    self.alarmTypeLabel.font = WYFont_Text_S_Normal;
    self.alarmTimeLabel.textColor = WY_FontColor_Red;
    self.alarmTimeLabel.font = WYFont_Text_M_Normal;
    self.alarmDateLabel.textColor = WY_FontColor_Red;
    self.alarmDateLabel.font = WYFont_Text_M_Normal;
    [self.alarmImageView addTapGestureTarget:self action:@selector(tapAction:)];
}

- (void)passModel:(WYMsgAlarmDetailModel *)model edited:(BOOL)edited {
    
    BOOL isRead = [model.msg.isRead isEqualToString:@"Y"];
    BOOL isVistor   = model.customAlarmType == WYMsgAlarmTypeVisitor;
    BOOL isMotion   = model.customAlarmType == WYMsgAlarmTypeMotion;
    if (edited) {
        [self.actionBtn setImage:[UIImage select_middle_normal_image] forState:UIControlStateNormal];
        [self.actionBtn setImage:[UIImage select_middle_selected_image] forState:UIControlStateSelected];
        [self.actionBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.actionBtn.selected = model.selected;
    }else {
        
        [self.actionBtn setImage:nil forState:UIControlStateNormal];
        [self.actionBtn setImage:nil forState:UIControlStateSelected];
        NSString *btnImageName = isRead ? @"btn_msg_play_gray" :  isVistor ? @"btn_msg_play_yellow": @"btn_msg_play_red";

        [self.actionBtn setBackgroundImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
    }
    
    [self.alarmImageView wy_setAlarmImageWithURL:model.msg.alarmImageUrl deviceID:model.msg.deviceID.integerValue placeholderImage:[UIImage placeholder_alarmMsg_image]];
    self.alarmTypeLabel.text  = isMotion ? WYLocalString(@"Motion"): isVistor ? WYLocalString(@"Vistor") : WYLocalString(@"Pir") ;
    self.alarmDateLabel.text = model.msg.devLocalTime.wy_YMDString;
    self.alarmTimeLabel.text = model.msg.devLocalTime.wy_HMSString;
    self.alarmTimeLabel.textColor = isRead ? WY_FontColor_LightGray : isVistor ? WY_FontColor_DarkYellow : WY_FontColor_Red;
    self.alarmDateLabel.textColor = isRead ? WY_FontColor_LightGray : isVistor ? WY_FontColor_DarkYellow : WY_FontColor_Red;
}

- (IBAction)actionAction:(UIButton *)sender {
    return;
//    if ([self.delegate respondsToSelector:@selector(WYMsgAlarmDetailNormalCell:didTapActionBtn:)]) {
//        [self.delegate WYMsgAlarmDetailNormalCell:self didTapActionBtn:sender];
//    }
}
- (IBAction)maskAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMsgAlarmDetailNormalCell:didTapActionBtn:)]) {
        [self.delegate WYMsgAlarmDetailNormalCell:self didTapActionBtn:self.actionBtn];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMsgAlarmDetailNormalCell:didTapImageView:)]) {
        [self.delegate WYMsgAlarmDetailNormalCell:self didTapImageView:self.alarmImageView];
    }
}

+ (CGFloat)cellHeight {
    CGFloat lh = roundf([@"9999-99-99" sizeWithAttributes:@{NSFontAttributeName:WYFont_Text_M_Normal}].width+1);
    CGFloat h = (WY_ScreenWidth-80-16-20-lh)*9.0/16.0+27;
    return h;
}
- (void)setHideBottomLine:(BOOL)hideBottomLine {
    _hideBottomLine = hideBottomLine;
    self.bottomVerticalLine.hidden = _hideBottomLine;
}

@end
