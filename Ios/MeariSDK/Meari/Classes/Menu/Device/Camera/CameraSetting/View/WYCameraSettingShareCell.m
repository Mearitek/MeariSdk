//
//  WYCameraSettingShareCell.m
//  Meari
//
//  Created by 李兵 on 16/8/15.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSettingShareCell.h"
#import "WYCameraSettingShareModel.h"

@interface WYCameraSettingShareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation WYCameraSettingShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accountLabel.font = WYFont_Text_XS_Normal;
    self.accountLabel.textColor = WY_FontColor_Gray;
    self.nickNameLabel.font = WYFont_Text_S_Normal;
    self.nickNameLabel.textColor = WY_FontColor_Black;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.shareBtn setImage:[UIImage imageNamed:@"btn_share_normal"] forState:UIControlStateNormal];
    [self.shareBtn setImage:[UIImage imageNamed:@"btn_share_highlighted"] forState:UIControlStateHighlighted];
    [self.shareBtn setImage:[UIImage imageNamed:@"btn_share_selected"] forState:UIControlStateSelected];
    
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.thumbImageView.layer.cornerRadius = self.thumbImageView.width/2;
    self.thumbImageView.layer.masksToBounds = YES;
}

- (void)setModel:(WYCameraSettingShareModel *)model {
    _model = model;
    [self.thumbImageView wy_setImageWithURL:[NSURL URLWithString:model.info.avatarUrl] placeholderImage:[UIImage placeholder_person_image]];
    self.nickNameLabel.text = model.info.nickName;
    self.accountLabel.text = model.info.userAccount;
    self.shareBtn.selected = model.info.deviceShared;
}


- (IBAction)shareAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraSettingShareCell:didTapedSelectedBtn:)]) {
        [self.delegate WYCameraSettingShareCell:self didTapedSelectedBtn:sender];
    }
}

@end
