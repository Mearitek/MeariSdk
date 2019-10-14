//
//  WYCameraSettingSleepmodeTimesCell.m
//  Meari
//
//  Created by 李兵 on 2017/1/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepmodeTimesCell.h"
#import "WYCameraSettingSleepmodeTimesModel.h"

@interface WYCameraSettingSleepmodeTimesCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDurationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeNameLabelLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeSwitchWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeSwitchTrailing;

@end

@implementation WYCameraSettingSleepmodeTimesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectBtn.userInteractionEnabled = NO;
    [self.selectBtn setImage:[UIImage select_middle_normal_image] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage select_middle_selected_image] forState:UIControlStateSelected];
    self.timeNameLabel.textColor = WY_FontColor_Black;
    self.timeNameLabel.font = WYFont_Text_M_Normal;
    self.timeDurationLabel.textColor = WY_FontColor_Gray;
    self.timeDurationLabel.font = WYFont_Text_M_Normal;
    self.week.textColor = WY_FontColor_Gray;
    self.week.font = WYFont_Text_S_Normal;
    self.bottomView.backgroundColor = WY_BGColor_LightGray;
    self.timeSwitch.onTintColor = WY_MainColor;
    self.line.backgroundColor = WY_LineColor_LightGray;
    
}
- (void)passModel:(WYCameraSettingSleepmodeTimesModel *)model edited:(BOOL)edited {
    if (edited) {
        self.selectBtnWidth.constant = 58;
        self.timeNameLabelLeading.constant = 15;
        self.timeSwitchWidth.constant = 0;
        self.timeSwitchTrailing.constant = 5;
        [UIView animateWithDuration:0.2 animations:^{
            self.timeSwitch.transform = CGAffineTransformMakeScale(0, 1);
            [self layoutIfNeeded];
        }];
    }else {
        self.selectBtnWidth.constant = 0;
        self.timeNameLabelLeading.constant = 15;
        self.timeSwitchWidth.constant = 50;
        self.timeSwitchTrailing.constant = 10;
        self.timeSwitch.transform = CGAffineTransformIdentity;
    }
    self.timeNameLabel.text = WYLocalString(@"Time Slot");
    self.timeDurationLabel.text = [NSString stringWithFormat:@"%@～%@",model.startTime, model.stopTime];
    self.week.text = model.weekdaysString;
    self.timeSwitch.on = model.enabled;
    self.selectBtn.selected = model.selected;
}
- (IBAction)selectAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(WYCameraSettingSleepmodeTimesCell:selectBtn:)]) {
        [self.delegate WYCameraSettingSleepmodeTimesCell:self selectBtn:sender];
    }
}
- (IBAction)switchAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraSettingSleepmodeTimesCell:switchTime:)]) {
        [self.delegate WYCameraSettingSleepmodeTimesCell:self switchTime:sender.isOn];
    }
}

@end
