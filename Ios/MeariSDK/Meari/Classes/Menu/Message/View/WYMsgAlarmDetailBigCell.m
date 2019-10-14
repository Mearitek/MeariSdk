//
//  WYMsgAlarmDetailBigCell.m
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgAlarmDetailBigCell.h"
#import "WYMsgAlarmDetailModel.h"

@interface WYMsgAlarmDetailBigCell ()
@property (weak, nonatomic) IBOutlet UIView *topVerticalLine;
@property (weak, nonatomic) IBOutlet UIView *bottowmVerticalLine;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *alarmImageView;
@property (weak, nonatomic) IBOutlet UILabel *alarmTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *maskBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;

@end

@implementation WYMsgAlarmDetailBigCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.topVerticalLine.hidden = YES;
    self.actionBtn.layer.cornerRadius = self.actionBtn.height/2;
    self.actionBtn.layer.masksToBounds = YES;
    self.alarmImageView.layer.cornerRadius = 5;
    self.alarmImageView.layer.masksToBounds = YES;
    [self.alarmImageView addTapGestureTarget:self action:@selector(tapAction:)];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topVerticalLine.backgroundColor = WY_LineColor_LightGray;
    self.bottowmVerticalLine.backgroundColor = WY_LineColor_LightGray;
    self.alarmTypeLabel.textColor = WY_FontColor_LightGray;
    self.alarmTypeLabel.font = WYFont_Text_M_Normal;
    self.alarmTimeLabel.textColor = WY_FontColor_Red;
    self.alarmTimeLabel.font = WYFont_Text_M_Normal;
}
- (void)passModel:(WYMsgAlarmDetailModel *)model edited:(BOOL)edited {
    BOOL isRead     = [model.msg.isRead isEqualToString:@"Y"];
    BOOL isVistor   = model.customAlarmType == WYMsgAlarmTypeVisitor;
    BOOL isMotion   = model.customAlarmType == WYMsgAlarmTypeMotion;
    if (edited) {
        self.imageTop.constant = 0;
        [self.actionBtn setImage:[UIImage select_middle_normal_image] forState:UIControlStateNormal];
        [self.actionBtn setImage:[UIImage select_middle_selected_image] forState:UIControlStateSelected];
        [self.actionBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.actionBtn.selected = model.selected;
    }else {
        self.imageTop.constant = 27;
        [self.actionBtn setImage:nil forState:UIControlStateNormal];
        [self.actionBtn setImage:nil forState:UIControlStateSelected];
        NSString *btnImageName = isRead ? @"btn_msg_play_gray" :isVistor? @"btn_msg_play_yellow" : @"btn_msg_play_red";
        [self.actionBtn setBackgroundImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
    }
    
    [self.alarmImageView wy_setAlarmImageWithURL:model.msg.alarmImageUrl deviceID:model.msg.deviceID.integerValue placeholderImage:[UIImage placeholder_alarmMsg_image]];
    self.alarmTypeLabel.text  = isMotion ? WYLocalString(@"Motion"): isVistor ? WYLocalString(@"Vistor"): WYLocalString(@"Pir") ;
    self.alarmTimeLabel.text = model.msg.devLocalTime.wy_dateString;
    self.alarmTimeLabel.textColor = isRead ? WY_FontColor_LightGray : isVistor ? WY_FontColor_DarkYellow : WY_FontColor_Red;
}
- (IBAction)actionAction:(UIButton *)sender {

}
- (IBAction)maskAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMsgAlarmDetailBigCell:didTapActionBtn:)]) {
        [self.delegate WYMsgAlarmDetailBigCell:self didTapActionBtn:self.actionBtn];
    }
}
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMsgAlarmDetailBigCell:didTapImageView:)]) {
        [self.delegate WYMsgAlarmDetailBigCell:self didTapImageView:self.alarmImageView];
    }
}
+ (CGFloat)cellHeight {
    return (WY_ScreenWidth - 115)*9/16+27+7+16+7+18+26;
}
+ (CGFloat)editedCellHeight {
    return (WY_ScreenWidth - 115)*9/16+0+7+16+7+18+26;
}
- (void)setHideBottomLine:(BOOL)hideBottomLine {
    _hideBottomLine = hideBottomLine;
    self.bottowmVerticalLine.hidden = _hideBottomLine;
}
@end
