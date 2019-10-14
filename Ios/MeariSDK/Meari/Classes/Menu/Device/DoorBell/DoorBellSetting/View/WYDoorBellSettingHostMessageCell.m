//
//  WYDoorBellSettingHostMessageCell.m
//  Meari
//
//  Created by FMG on 2017/7/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingHostMessageCell.h"
@interface WYDoorBellSettingHostMessageCell ()


@end

@implementation WYDoorBellSettingHostMessageCell

+ (instancetype)instanceHostMessageCell {
    return [[WY_MainBundle loadNibNamed:@"WYDoorBellSettingHostMessageCell" owner:nil options:nil] objectAtIndex:0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
