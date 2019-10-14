//
//  WYNVRCell.m
//  Meari
//
//  Created by 李兵 on 2016/10/17.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYNVRCell.h"

@interface WYNVRCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;


@end

@implementation WYNVRCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self addLineViewAtTop];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.font = WYFont_Text_M_Bold;
    self.accountLabel.font = WYFont_Text_S_Normal;
    self.iconImageView.image = [UIImage imageNamed:@"img_nvr_kind"];
    self.settingBtn.wy_normalImage = [UIImage imageNamed:@"btn_camera_setting_normal"];
    [self addLineViewAtBottom];
}

- (void)setNvr:(MeariDevice *)nvr {
    _nvr = nvr;
    self.nameLabel.text = nvr.info.nickname;
    self.accountLabel.text = nvr.info.shared ? nvr.info.userAccount : WYLocalString(@"My NVR");
    self.nameLabel.textColor = nvr.info.shared ? WY_FontColor_Cyan : WY_FontColor_Black;
    
    if (nvr.info.needUpdate) {
        self.settingBtn.wy_normalImage = [UIImage imageNamed:@"btn_camera_settingRed_normal"];
        self.settingBtn.wy_highlightedImage = [UIImage imageNamed:@"btn_camera_settingRed_hignlighted"];
    }else {
        self.settingBtn.wy_normalImage = [UIImage imageNamed:@"btn_camera_setting_normal"];
        self.settingBtn.wy_highlightedImage = [UIImage imageNamed:@"btn_camera_setting_hignlighted"];
    }
    
}

#pragma mark -- Action
- (IBAction)setAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYNVRCell:didSelectSettingBtn:)]) {
        [self.delegate WYNVRCell:self didSelectSettingBtn:sender];
    }
    
}
@end

