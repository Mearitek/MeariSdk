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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//- (IBAction)playClick:(UIButton *)sender {
//    if ([self.delegate respondsToSelector:@selector(hostMessageCell:play:)]) {
//        [self.delegate hostMessageCell: self play:sender];
//    }
//}
- (IBAction)deleteClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(hostMessageCell:delete:)]) {
        [self.delegate hostMessageCell: self delete:sender];
    }
}

- (void)setPlay:(BOOL)play {
    _play = play;
    if (play) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_auditionMessage" ofType:@"gif"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//        [self.playIcon  WY_setGIFImageWithURL:url];
    }else {
        [self.playIcon.layer removeAllAnimations];
        
        self.playIcon.image = [UIImage imageNamed:@"device_set_host_play"];
    }
}
@end
