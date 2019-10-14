//
//  WYDoorbellSettingJingleBellPairCell.m
//  Meari
//
//  Created by FMG on 2017/11/6.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorbellSettingJingleBellPairCell.h"
@interface WYDoorbellSettingJingleBellPairCell ()
@property (weak, nonatomic) IBOutlet UILabel *jingleBellTapLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jingleBellImgTopConstraint;

@end


@implementation WYDoorbellSettingJingleBellPairCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (WY_iPhone_4) {
        self.jingleBellImgTopConstraint.constant = 50;
    }
    self.jingleBellTapLabel.text = WYLocalString(@"des_jingleBellPairingSteps");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)cellHeight {
    NSString *jingleBellTap = WYLocalString(@"des_jingleBellPairingSteps");
    CGFloat height = [jingleBellTap wy_heightWithWidth:WY_ScreenWidth-80 font:WYFont_Text_S_Bold breakMode:NSLineBreakByWordWrapping];
    return height + 108 + 96 + 48 + 80;
}
@end
