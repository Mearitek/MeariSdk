//
//  WYMsgAlarmCell.m
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgAlarmCell.h"
#import "WYMsgAlarmModel.h"


@interface WYMsgAlarmCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewTrailing;

@end

@implementation WYMsgAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.selectBtn setImage:[UIImage select_middle_normal_image] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage select_middle_selected_image] forState:UIControlStateSelected];
    self.deviceNameLabel.textColor = WY_FontColor_Black;
    self.deviceNameLabel.font = WYFont_Text_M_Bold;

}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbImageView.layer.cornerRadius = 5;
    self.thumbImageView.layer.masksToBounds = YES;
    self.deviceTypeImageView.layer.cornerRadius = 5;
    self.deviceTypeImageView.layer.masksToBounds = YES;
    
}

- (void)passModel:(WYMsgAlarmModel *)model edited:(BOOL)edited {
    if (edited) {
        self.selectBtnWidth.constant = 80;
        self.thumbImageViewLeading.constant = 0;
        self.thumbImageViewTrailing.constant = 25;
        self.selectBtn.selected = model.selected;
        self.deviceNameLabel.font = WYFont_Text_S_Bold;
    }else {
        self.selectBtnWidth.constant = 0;
        self.thumbImageViewLeading.constant = 12;
        self.thumbImageViewTrailing.constant = 12;
        self.deviceNameLabel.font = WYFont_Text_M_Bold;
    }
    self.thumbImageView.image = [UIImage placeholder_alarmMsg_image];
    [self.deviceTypeImageView wy_setImageWithURL:[NSURL URLWithString:model.info.deviceIconUrl] placeholderImage:[UIImage placeholder_device_image]];
    self.deviceNameLabel.text = model.info.deviceName;
    self.deviceNameLabel.textColor = model.info.hasMsg? WY_FontColor_Red : WY_FontColor_Black;
}
- (IBAction)selectAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMsgAlarmCell:selectButton:)]) {
        [self.delegate WYMsgAlarmCell:self selectButton:sender];
    }
}
+ (CGFloat)cellHeight {
    CGFloat h = (WY_ScreenWidth-24)*9.0/16.0+60;
    return h;
}
+ (CGFloat)editedCellHeight {
    CGFloat h = (WY_ScreenWidth-25-80)*9.0/16.0+50;
    return h;
}
@end
