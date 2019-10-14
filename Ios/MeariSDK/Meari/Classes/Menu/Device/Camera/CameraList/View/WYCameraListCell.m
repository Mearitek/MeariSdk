//
//  WYCameraListCell.m
//  Meari
//
//  Created by 李兵 on 16/1/14.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraListCell.h"

@interface WYCameraListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@end

@implementation WYCameraListCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.thumbImageView.layer.masksToBounds = YES;
    self.thumbImageView.layer.cornerRadius = 10;
    self.playBtn.layer.masksToBounds = YES;
    self.playBtn.layer.cornerRadius = 10;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.height/2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.deviceNameLabel.font = WYFont_Text_M_Bold;
    [self.playBtn addLongPressGestureTarget:self action:@selector(longPressAction:)];
}

- (void)setCamera:(MeariDevice *)camera {
    _camera = camera;
    self.deviceNameLabel.text = camera.info.nickname;
    self.deviceNameLabel.textColor = camera.info.shared ? WY_FontColor_Cyan : WY_FontColor_Black;
    
    [self.headImageView wy_setImageWithURL:[NSURL URLWithString:camera.info.iconUrl]
                          placeholderImage:[UIImage placeholder_device_image]];
    self.thumbImageView.image = [UIImage imageNamed:@"img_camera_placeholder"];

    [self.playBtn setImage:[UIImage imageNamed:@"btn_camera_online_normal"]
                  forState:UIControlStateNormal];
    
    [self.messageBtn setImage:[UIImage imageNamed: camera.info.hasMsg ? @"btn_camera_message_normal" : @"btn_camera_messageNo_normal"]
                     forState:UIControlStateNormal];
}
#pragma mark - Action
- (IBAction)playAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraListCell:didSelectPlayBtn:)]) {
        [self.delegate WYCameraListCell:self didSelectPlayBtn:sender];
    }
}
- (IBAction)msgAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraListCell:didSelectMsgBtn:)]) {
        [self.delegate WYCameraListCell:self didSelectMsgBtn:sender];
    }
    
}
- (void)longPressAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(WYCameraListCell:didLongPressedPlayBtn:)]) {
            [self.delegate WYCameraListCell:self didLongPressedPlayBtn:self.playBtn];
        }
    }
}





@end
