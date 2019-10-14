
//
//  WYNVRSettingCameraBindingCell.m
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingCameraBindingCell.h"
#import "WYNVRSettingCameraListModel.h"
@interface WYNVRSettingCameraBindingCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@end

@implementation WYNVRSettingCameraBindingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nickNameLabel.font = WYFont_Text_M_Normal;
    self.nickNameLabel.textColor = WY_FontColor_Black;
    self.accountLabel.font = WYFont_Text_S_Normal;
    self.accountLabel.textColor = WY_FontColor_Gray;
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.addBtn.layer.cornerRadius = self.addBtn.height/2;
    self.addBtn.layer.masksToBounds = YES;
}

- (void)setModel:(WYNVRSettingCameraListModel *)model {
    _model = model;
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@", model.device.info.nickname];
    self.accountLabel.text = model.device.info.sn;
    
    NSString *title, *bgImage, *iconImage;
    BOOL enabled = NO;
    title = WYLocalString((model.binded ? @"ADDED" : @"Not added"));
    bgImage = model.binded ? @"bg_gray" : @"bg_green";
    enabled = !model.binded;
    iconImage = model.binded ? model.device.info.grayIconUrl : model.device.info.iconUrl;
    
    self.addBtn.userInteractionEnabled = enabled;
    [self.addBtn setTitle:title forState:UIControlStateNormal];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    [self.iconImageView wy_setImageWithURL:[NSURL URLWithString:iconImage] placeholderImage:[UIImage placeholder_device_image]];
}
- (IBAction)addAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYNVRSettingCameraBindingCell:didClickAddBtn:)]) {
        [self.delegate WYNVRSettingCameraBindingCell:self didClickAddBtn:sender];
    }
}
@end
