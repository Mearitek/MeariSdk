//
//  WYMenuCell.m
//  Meari
//
//  Created by 李兵 on 2016/11/2.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMenuCell.h"
#import "WYMenuModel.h"

@interface WYMenuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *redDotView;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation WYMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"bt_green_menu"];
    self.label.textColor = WY_FontColor_Gray;
    self.label.highlightedTextColor = [UIColor whiteColor];
    self.label.font = WYFont_Text_M_Normal;
    self.redDotView.image = [UIImage imageWithColor:[UIColor redColor]];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.redDotView.layer.cornerRadius = self.redDotView.height/2;
    self.redDotView.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage bgGreenImage]];
}


- (void)setModel:(WYMenuModel *)model {
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.normalImage];
    self.iconImageView.highlightedImage = [UIImage imageNamed:model.highlightedImage];
    self.label.text = model.title;
    self.label.highlightedTextColor = [UIColor whiteColor];
    self.label.highlighted = model.isHighlighted;
    self.iconImageView.highlighted = model.isHighlighted;
    self.backgroundImageView.hidden = !model.isHighlighted;
    self.redDotView.hidden = YES;
}


@end
