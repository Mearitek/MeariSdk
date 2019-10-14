//
//  WYCameraSettingSleepModeCell.m
//  Meari
//
//  Created by FMG on 17/3/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepModeCell.h"
#import "WYCameraSettingSleepModel.h"

@interface WYCameraSettingSleepModeCell ()
@property (weak, nonatomic) IBOutlet UILabel *sleepModeTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *subDescribeLabel;
   
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkImageViewWidth;


@end

@implementation WYCameraSettingSleepModeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.subDescribeLabel.textColor = WY_FontColor_Gray;
    self.accessoryType = UITableViewCellAccessoryNone;
    [self addLineViewAtBottom];
}
- (void)setModel:(WYCameraSettingSleepModel *)model {
    _model = model;
    self.sleepModeTypeLabel.text = model.text;
    self.subDescribeLabel.text = model.detailedText;
    self.checkImageViewWidth.constant = model.selected ? 28 : 0;
    self.sleepModeTypeLabel.textColor = model.selected ? WY_MainColor : WY_FontColor_Black;
}


@end
