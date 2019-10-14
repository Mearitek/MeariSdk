//
//  WYVoiceHUD.m
//  test
//
//  Created by 李兵 on 2016/12/3.
//  Copyright © 2016年 李兵. All rights reserved.
//

#import "WYCameraVoiceHUD.h"

@interface WYCameraVoiceHUD ()
{
    BOOL _showing;
}
@property (nonatomic, weak)UIImageView *leftImageView;
@property (nonatomic, weak)UIImageView *voiceProgressImageView;
@property (nonatomic, weak)UILabel *textLabel;
@property (nonatomic, assign)CGFloat voiceProgress;

@end

@implementation WYCameraVoiceHUD
#pragma mark - Private
#pragma mark -- Getter
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        UIImageView *imageV = [UIImageView new];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.image = [UIImage imageNamed:@"img_camera_voice_speak"];
        [self addSubview:imageV];
        _leftImageView = imageV;
    }
    return _leftImageView;
}
- (UIImageView *)voiceProgressImageView {
    if (!_voiceProgressImageView) {
        UIImageView *imageV = [UIImageView new];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageV];
        _voiceProgressImageView = imageV;
    }
    return _voiceProgressImageView;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:WYLocalString(@"Sending Voice")
                                       textColor:[UIColor whiteColor]
                                        textfont:WYFont_Text_M_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByTruncatingTail
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:NO];
        [self addSubview:label];
        _textLabel = label;
    }
    return _textLabel;
}

#pragma mark -- Init
- (void)initSet {
    self.hidden = YES;
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.layer.cornerRadius = 5.0f;
}
- (void)initLayout {
    WY_WeakSelf
    CGFloat radio = CGImageGetWidth(self.leftImageView.image.CGImage)*1.0/CGImageGetHeight(self.leftImageView.image.CGImage);
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).with.offset(20);
        make.height.equalTo(weakSelf).multipliedBy(0.5);
        make.width.equalTo(weakSelf.leftImageView.mas_height).multipliedBy(radio);
        make.centerY.equalTo(weakSelf).multipliedBy(0.8);
    }];
    
    [self.voiceProgressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.leftImageView.mas_trailing);
        make.trailing.equalTo(weakSelf);
        make.height.equalTo(weakSelf.leftImageView);
        make.bottom.equalTo(weakSelf.leftImageView);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageView.mas_bottom);
        make.leading.trailing.and.bottom.equalTo(weakSelf);
    }];
    
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@180);
            make.height.equalTo(@220);
            make.center.equalTo(weakSelf.superview);
        }];
    }
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}

#pragma mark -- Utilities
- (void)show:(BOOL)animated {
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    _showing = YES;
    
    if (animated) {
        self.hidden = NO;
        self.alpha = 0;
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (_showing) {
                self.hidden = NO;
                self.alpha = 1.0f;
            }else {
                self.hidden = YES;
                self.alpha = 0;
            }
        }];
    }else {
        self.hidden = NO;
        self.alpha = 1.0f;
    }
}
- (void)hide:(BOOL)animated {
    _showing = NO;
    
    if (animated) {
        self.hidden = NO;
        self.alpha = 1.0f;
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (_showing) {
                self.hidden = NO;
                self.alpha = 1.0f;
            }else {
                self.hidden = YES;
                self.alpha = 0;
            }
        }];
    }else {
        self.alpha = 0;
        self.hidden = YES;
    }
}
- (BOOL)isShow {
    return _showing;
}
- (void)setVoiceProgress:(CGFloat)voiceProgress {
    _voiceProgress = voiceProgress;
    if (_voiceProgress < 0) {
        _voiceProgress = 0;
    }else if (_voiceProgress > 1) {
        _voiceProgress = 1;
    }
    if (_voiceProgress <= 0.05f) {
        [self.voiceProgressImageView setImage:[UIImage imageNamed:@"img_camera_voice_progress_1"]];
    } else if (_voiceProgress <= 0.1f) {
        [self.voiceProgressImageView setImage:[UIImage imageNamed:@"img_camera_voice_progress_2"]];
    } else if (_voiceProgress <= 0.15f) {
        [self.voiceProgressImageView setImage:[UIImage imageNamed:@"img_camera_voice_progress_3"]];
    } else if (_voiceProgress <= 0.3f) {
        [self.voiceProgressImageView setImage:[UIImage imageNamed:@"img_camera_voice_progress_4"]];
    } else {
        [self.voiceProgressImageView setImage:[UIImage imageNamed:@"img_camera_voice_progress_5"]];
    }
}

#pragma mark - Public
WY_Singleton_Implementation(VoiceHUD)
+ (BOOL)isShow {
    return [[WYCameraVoiceHUD sharedVoiceHUD] isShow];
}
+ (void)show:(BOOL)animated {
    [[self sharedVoiceHUD] setVoiceProgress:0];
    [[self sharedVoiceHUD] show:animated];
}
+ (void)hide:(BOOL)animated {
    [[self sharedVoiceHUD] hide:animated];
}
+ (void)setVoiceProgress:(CGFloat)progress {
    if ([[self sharedVoiceHUD] isShow]) {
        [[self sharedVoiceHUD] setVoiceProgress:progress];
    }
}


@end
