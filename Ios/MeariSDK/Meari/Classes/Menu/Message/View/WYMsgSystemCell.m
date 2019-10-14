//
//  WYMsgSystemCell.m
//  Meari
//
//  Created by 李兵 on 16/3/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgSystemCell.h"
#import "WYMsgSystemModel.h"

@interface WYMsgSystemCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendDescLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnCenterX;


@end

@implementation WYMsgSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.selectBtn setImage:[UIImage select_middle_normal_image] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage select_middle_selected_image] forState:UIControlStateSelected];
    self.friendAccountLabel.textColor = WY_FontColor_Black;
    self.friendAccountLabel.font = WYFont_Text_S_Normal;
    self.friendDescLabel.textColor = WY_FontColor_Gray;
    self.friendDescLabel.font = WYFont_Text_XS_Normal;
    self.line.backgroundColor = WY_LineColor_LightGray;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.friendImageView.layer.cornerRadius = 49/2.0;
    self.friendImageView.layer.masksToBounds = YES;
}


- (void)passModel:(WYMsgSystemModel *)model edited:(BOOL)edited {
    if (edited) {
        self.selectBtnWidth.constant = 40;
        self.selectBtnCenterX.constant = 40;
        self.friendImageViewWidth.constant = 0;
        self.selectBtn.selected = model.selected;
    }else {
        self.selectBtnWidth.constant = 0;
        self.selectBtnCenterX.constant = 0;
        self.friendImageViewWidth.constant = 49;
    }
    
    BOOL needArrow = model.info.msgType == MeariSystemMessageTypeDeviceShare || model.info.msgType == MeariSystemMessageTypeFriendAdd;
    self.accessoryType = needArrow ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    [self.friendImageView wy_setImageWithURL:[NSURL URLWithString:model.info.friendAvatarUrl] placeholderImage:[UIImage placeholder_person_image]];
    self.friendAccountLabel.text = model.accountWhole;
    self.friendDescLabel.text = model.descWhole;
}
- (IBAction)selectAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYMsgSystemCell:selectButton:)]) {
        [self.delegate WYMsgSystemCell:self selectButton:sender];
    }
}

- (void)setModel:(WYMsgSystemModel *)model {
    
    
}

@end


