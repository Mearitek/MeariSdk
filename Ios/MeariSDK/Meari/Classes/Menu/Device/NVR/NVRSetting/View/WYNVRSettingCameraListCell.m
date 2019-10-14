//
//  WYNVRSettingCameraListCell.m
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingCameraListCell.h"

@interface WYNVRSettingCameraListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableLeading;


@end

@implementation WYNVRSettingCameraListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.line.backgroundColor = WY_LineColor_LightGray;
    self.nickNameLabel.font = WYFont_Text_L_Normal;
    self.nickNameLabel.textColor = WY_FontColor_Black;
    self.accountLabel.font = WYFont_Text_S_Normal;
    self.accountLabel.textColor = WY_FontColor_Gray;
    [self.selectBtn setImage:[UIImage select_middle_normal_image] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage select_middle_selected_image] forState:UIControlStateSelected];
    self.selectBtn.userInteractionEnabled = NO;
}


- (void)passModel:(WYNVRSettingCameraListModel *)model edited:(BOOL)edited {
    if (edited) {
        self.selectBtnWidth.constant = 80;
        self.iconImageViewWidth.constant = 0;
        self.iconImageViewLeading.constant = 0;
        self.lableLeading.constant = 0;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }else {
        self.selectBtnWidth.constant = 0;
        self.iconImageViewWidth.constant = 50;
        self.iconImageViewLeading.constant = 15;
        self.lableLeading.constant = 13;
        [self.iconImageView wy_setImageWithURL:[NSURL URLWithString:model.device.info.iconUrl] placeholderImage:[UIImage placeholder_device_image]];
        self.selectionStyle = UITextAutocapitalizationTypeNone;
    }
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.device.info.nickname, model.device.info.sn];
    self.selectBtn.selected = model.selected;
    self.accountLabel.text = model.device.info.userAccount;
    if ([model.device.info.userAccount isEqualToString:WY_USER_ACCOUNT]) {
        self.accountLabel.text = WYLocalString(@"My Camera");
    }
}

- (IBAction)selectAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYNVRSettingCameraListCell:selectButton:)]) {
        [self.delegate WYNVRSettingCameraListCell:self selectButton:sender];
    }
}

@end
