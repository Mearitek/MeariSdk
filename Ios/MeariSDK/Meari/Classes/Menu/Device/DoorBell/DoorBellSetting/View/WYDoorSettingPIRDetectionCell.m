//
//  WYDoorSettingPIRDetectionCell.m
//  Meari
//
//  Created by FMG on 2017/7/25.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorSettingPIRDetectionCell.h"
#import "WYDoorBellSettingPIRDetection.h"
@interface WYDoorSettingPIRDetectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *PIRTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *PIRSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation WYDoorSettingPIRDetectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setPIRDetectionMode:(WYDoorBellSettingPIRDetection *)PIRDetectionMode {
    _PIRDetectionMode = PIRDetectionMode;
    self.PIRTitleLabel.text = PIRDetectionMode.text;
    self.PIRSubTitleLabel.text = PIRDetectionMode.detailedText;
    self.selectedImageView.hidden = !PIRDetectionMode.selected;
}

@end
