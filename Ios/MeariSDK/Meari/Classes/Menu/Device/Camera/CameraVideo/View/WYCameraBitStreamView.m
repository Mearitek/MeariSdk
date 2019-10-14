//
//  WYCameraBitStreamView.m
//  Meari
//
//  Created by FMG on 2017/7/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraBitStreamView.h"
@interface WYCameraBitStreamView ()
@property (weak, nonatomic) IBOutlet UIButton *autoBtn;
@property (weak, nonatomic) IBOutlet UIButton *sdBtn;
@property (weak, nonatomic) IBOutlet UIButton *hdBtn;
@property (nonatomic, assign) WYVideoType streamType;

@end

@implementation WYCameraBitStreamView
+ (instancetype)instanceBitStreamView {
    return [[WY_MainBundle loadNibNamed:@"WYCameraBitStreamView" owner:nil options:nil] objectAtIndex:0];
}
- (IBAction)autoBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bitStreamView:didSelectedStreamType:)]) {
        [self.delegate bitStreamView:self didSelectedStreamType:WYVideoTypePreviewAT];
    }
}
- (IBAction)sdBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bitStreamView:didSelectedStreamType:)]) {
        [self.delegate bitStreamView:self didSelectedStreamType:WYVideoTypePreviewSD];
    }
}
- (IBAction)hdBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bitStreamView:didSelectedStreamType:)]) {
        [self.delegate bitStreamView:self didSelectedStreamType:WYVideoTypePreviewHD];
    }
}
- (void)setVideoType:(WYVideoType)videoType {
    _videoType = videoType;
    switch (videoType) {
        case WYVideoTypePreviewHD: {
            
            self.hdBtn.selected = YES;
            self.sdBtn.selected = NO;
            self.autoBtn.selected = NO;
            break;
        }
        case WYVideoTypePreviewSD: {
            
            self.hdBtn.selected = NO;
            self.sdBtn.selected = YES;
            self.autoBtn.selected = NO;
            break;
        }
        case WYVideoTypePreviewAT: {
            self.hdBtn.selected = NO;
            self.sdBtn.selected = NO;
            self.autoBtn.selected = YES;
            break;
        }
        default:
            break;
    }
    [self.autoBtn setTitleColor:self.autoBtn.selected ? WY_MainColor : WY_FontColor_White forState:UIControlStateNormal];
    [self.sdBtn setTitleColor:self.sdBtn.selected ? WY_MainColor : WY_FontColor_White forState:UIControlStateNormal];
    [self.hdBtn setTitleColor:self.hdBtn.selected ? WY_MainColor : WY_FontColor_White forState:UIControlStateNormal];

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSet];
}
- (void)initSet {
    [self.autoBtn setTitle:WYLocalString(@"AUTO") forState:UIControlStateNormal];
    [self.autoBtn setTitleColor:WY_FontColor_White forState:UIControlStateNormal];
    [self.sdBtn setTitle:WYLocalString(@"SD") forState:UIControlStateNormal];
    [self.sdBtn setTitleColor:WY_FontColor_White forState:UIControlStateNormal];
    [self.hdBtn setTitle:WYLocalString(@"HD") forState:UIControlStateNormal];
    [self.hdBtn setTitleColor:WY_FontColor_White forState:UIControlStateNormal];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_camera_bgColor.png"]];
}

@end

