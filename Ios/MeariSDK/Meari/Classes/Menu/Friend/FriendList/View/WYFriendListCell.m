//
//  WYFriendListCell.m
//  Meari
//
//  Created by 李兵 on 2017/9/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendListCell.h"
#import "WYFriendListModel.h"
@interface WYFriendListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation WYFriendListCell

#pragma mark -- Life
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectBtn.wy_normalImage = [UIImage select_middle_normal_image];
    self.selectBtn.wy_selectedImage = [UIImage select_middle_selected_image];
    self.selectBtn.userInteractionEnabled = NO;
    self.nickNameLabel.textColor = WY_FontColor_Black;
    self.nickNameLabel.font = WYFont_Text_M_Normal;
    self.accountLabel.textColor = WY_FontColor_Gray;
    self.accountLabel.font = WYFont_Text_XS_Normal;
    [self addLineViewAtBottom];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.height/2;
    self.avatarImageView.layer.masksToBounds = YES;
}

#pragma mark - Public
- (void)passModel:(WYFriendListModel *)model edited:(BOOL)edited {
    if (edited) {
        self.selectBtn.hidden = NO;
        self.avatarImageView.hidden = YES;
        self.selectBtn.selected= model.selected;
        self.accessoryType = UITableViewCellAccessoryNone;
    }else {
        self.selectBtn.hidden = YES;
        self.avatarImageView.hidden = NO;
        self.selectBtn.selected= NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    self.nickNameLabel.text = model.info.nickName;
    self.accountLabel.text = model.info.userAccount;
    [self.avatarImageView wy_setImageWithURL:model.info.avatarUrl.wy_url placeholderImage:[UIImage placeholder_person_image]];
}

@end
