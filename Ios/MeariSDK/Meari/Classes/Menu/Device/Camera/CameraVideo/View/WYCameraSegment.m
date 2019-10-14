//
//  WYCameraSegment.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSegment.h"

@interface WYCameraSegment ()

@property (nonatomic, weak)UIButton *previewBtn;
@property (nonatomic, weak)UIButton *playbackBtn;


@end

@implementation WYCameraSegment
#pragma mark - Private
#pragma mark -- Getter
- (UIButton *)previewBtn {
    if (!_previewBtn) {
        UIButton *btn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(previewAction:)];
        btn.titleLabel.font = WYFont_Text_M_Normal;
        [btn setTitle:WYLocalString(@"PREVIEW") forState:UIControlStateNormal];
        [self addSubview:btn];
        _previewBtn = btn;
    }
    return _previewBtn;
}
- (UIButton *)playbackBtn {
    if (!_playbackBtn) {
        UIButton *btn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(playbackAction:)];
        btn.titleLabel.font = WYFont_Text_M_Normal;
        [btn setTitle:WYLocalString(@"PLAYBACk") forState:UIControlStateNormal];
        [self addSubview:btn];
        _playbackBtn = btn;
    }
    return _playbackBtn;
}

#pragma mark -- Init
- (void)initLayout {
    WY_WeakSelf
    [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).with.offset(16);
        make.height.equalTo(@35).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
    [self.playbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.centerY.equalTo(weakSelf.previewBtn);
        make.leading.equalTo(weakSelf.previewBtn.mas_trailing).with.offset(20);
        make.trailing.equalTo(weakSelf).with.offset(-16);
    }];
}

#pragma mark -- Utilities
- (void)setButton:(UIButton *)btn selected:(BOOL)selected {
    [btn setBackgroundImage:selected ? (WY_CameraM.babyMonitor ?
                                        [UIImage bgOrangeImage] :
                                        [UIImage bgGreenImage]) : nil
                   forState:UIControlStateNormal];
    [btn setTitleColor:selected ? [UIColor whiteColor] : WY_FontColor_Gray2
              forState:UIControlStateNormal];
}

#pragma mark -- Life
- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewBtn.layer.cornerRadius = self.previewBtn.height/2;
    self.previewBtn.layer.masksToBounds = YES;
    self.playbackBtn.layer.cornerRadius = self.playbackBtn.height/2;
    self.playbackBtn.layer.masksToBounds = YES;
    
}

#pragma mark -- Action
- (void)previewAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraSegment:didSelectedIndex:)]) {
        [self.delegate WYCameraSegment:self didSelectedIndex:0];
    }
}
- (void)playbackAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraSegment:didSelectedIndex:)]) {
        [self.delegate WYCameraSegment:self didSelectedIndex:1];
    }
}

#pragma mark - Delegate


#pragma mark - Public
- (instancetype)initWithVideoType:(WYVideoType)videoType {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initLayout];
        self.videoType = videoType;
    }
    return self;
}
- (void)setVideoType:(WYVideoType)videoType {
    if (_videoType == videoType) return;
    _videoType = videoType;
    switch (_videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD: {
            [self setButton:self.previewBtn selected:YES];
            [self setButton:self.playbackBtn selected:NO];
            break;
        }
        case WYVideoTypePlaybackNVR:
        case WYVideoTypePlaybackSDCard: {
            [self setButton:self.previewBtn selected:NO];
            [self setButton:self.playbackBtn selected:YES];
            break;
        }
        default:
            break;
    }
}
- (BOOL)previewed {
    return self.videoType == WYVideoTypePreviewSD || self.videoType == WYVideoTypePreviewHD;
}

@end
