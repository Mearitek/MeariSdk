//
//  WYFriendShareCell2.m
//  Meari
//
//  Created by 李兵 on 2017/9/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendShareCell2.h"
#import "WYFriendShareModel2.h"
@interface WYFriendShareCell2 ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation WYFriendShareCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.maskView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5];
    self.btn.wy_normalImage = [UIImage select_middle_normal_image];
    self.btn.wy_selectedImage = [UIImage select_middle_selected_image];
    self.btn.userInteractionEnabled = NO;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    self.label.font = WYFont_Text_S_Bold;
    self.label.textColor = WY_FontColor_Black;
}

#pragma mark - Public
- (void)setModel:(WYFriendShareModel2 *)model {
    _model = model;
    self.label.text = model.device.info.nickname;
    MeariDevice *camera = [MeariDevice new];
    self.imageView.image = [UIImage placeholder_camera_image];
    self.btn.selected = model.device.info.shared;
    self.maskView.hidden = self.btn.selected;
}

@end
