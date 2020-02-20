//
//  WYReceiveView.m
//  Meari
//
//  Created by FMG on 2017/8/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYReceiveView.h"

@interface WYReceiveView ()
@property (nonatomic,   weak) UIButton *screenChangeBtn;
@property (nonatomic,   weak) UIButton *hangupBtn;
@property (nonatomic,   weak) UIButton *muteBtn;
@property (nonatomic,   weak) UILabel *titleLabel;
@property (nonatomic,   weak) UILabel *readyLabel;
@property (nonatomic,   weak) UIImageView *speakAnimationImgV;
@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, assign) NSInteger duration;
@end

@implementation WYReceiveView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setInit];
        [self setLayout];
    }
    return self;
}
- (void)setLayout {
    //    [self.screenChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self).offset(5);
    //        make.trailing.equalTo(self).offset(-5);
    //    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(WY_iPhone_4 ? 5 : 25));
    }];
    
    [self.speakAnimationImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.offset(-35);
        make.leading.equalTo(self.muteBtn.mas_leading).offset(0);
        make.trailing.equalTo(self.speakBtn.mas_trailing).offset(0);
        make.height.equalTo(self.speakAnimationImgV.mas_width).multipliedBy(33/200.0);
    }];
    
    [self.readyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(50);
    }];
    
    [self addSubview:self.timeLB];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.speakAnimationImgV.mas_bottom).offset(15);
    }];
    
    [self.hangupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(WY_SAFE_BOTTOM_LAYOUT - 50);
        make.size.mas_equalTo(60);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_greaterThanOrEqualTo(50);
        make.centerY.mas_equalTo(self.hangupBtn);
        make.size.mas_equalTo(50);
    }];
    [self.speakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_greaterThanOrEqualTo(-50);
        make.centerY.mas_equalTo(self.hangupBtn);
        make.size.mas_equalTo(self.muteBtn);
    }];
}
- (void)setCamera:(MeariDevice *)camera {
    _camera = camera;
    self.titleLabel.text = camera.info.nickname;
}
- (void)setInit {
    //    UIButton *screenChangeBtn = [UIButton new];
    //    [screenChangeBtn setImage:[UIImage imageNamed:@"btn_fullscreen"] forState:UIControlStateNormal];
    //    screenChangeBtn.hidden = YES;
    //    self.screenChangeBtn = screenChangeBtn;
    //    [screenChangeBtn addTarget:self action:@selector(screenChangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:screenChangeBtn];
    
    UILabel *title = [UILabel new];
    self.titleLabel = title;
    title.text = @"My House Doorbell";
    title.font = WYFontNormal(19);
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    
    UIImageView *speakAnimation = [UIImageView new];
    speakAnimation.hidden = YES;
    self.speakAnimationImgV = speakAnimation;
//    [speakAnimation WY_setGIFImageWithURL:self.voiceGifURL];
    [self addSubview:speakAnimation];
    
    UILabel *ready = [UILabel new];
    self.readyLabel = ready;
    ready.text = WYLocalString(@"com_preparing_intercom");
    ready.font = WYFontNormal(14);
    ready.textColor = [UIColor whiteColor];
    [self addSubview:ready];
    
    UIButton *muteBtn = [UIButton new];
    self.muteBtn = muteBtn;
    muteBtn.enabled = NO;
    _muteBtn.wy_normalImage = [UIImage imageNamed:@"voiceCallMute"];
    _muteBtn.wy_selectedImage = [UIImage imageNamed:@"voiceCallMuteDisable"];
    [muteBtn addTarget:self action:@selector(muteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:muteBtn];
    
    UIButton *hangupBtn = [UIButton new];
    self.hangupBtn = hangupBtn;
    hangupBtn.wy_normalImage = [UIImage imageNamed:@"voiceCallHangUp"];
    [hangupBtn addTarget:self action:@selector(hangupBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hangupBtn];
    
    UIButton *speakBtn = [UIButton new];
    self.speakBtn = speakBtn;
    speakBtn.enabled = NO;
    _speakBtn.wy_normalImage = [UIImage imageNamed:@"voiceCallSpeak"];
    _speakBtn.wy_selectedImage = [UIImage imageNamed:@"voiceCallSpeakDisable"];
    [speakBtn addTarget:self action:@selector(speakBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:speakBtn];
}
- (NSURL *)voiceGifURL {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_doorbell_sound" ofType:@"gif"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    return url;
}
#pragma mark - Action
- (void)screenChangeBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(receiveView:didClickFullScreenBtn:)]) {
        [self.delegate receiveView:self didClickFullScreenBtn:sender];
    }
}
- (void)muteBtnAction:(UIButton *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setMuteDelegateWithBtn:) object:sender];
    [self performSelector:@selector(setMuteDelegateWithBtn:) withObject:sender afterDelay:0.2];
}
- (void)speakBtnAction:(UIButton *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setSpeakDelegateWithBtn:) object:sender];
    [self performSelector:@selector(setSpeakDelegateWithBtn:) withObject:sender afterDelay:0.2];
}
- (void)setShowSpeakAnimation:(BOOL)showSpeakAnimation {
    _showSpeakAnimation = showSpeakAnimation;
    self.speakAnimationImgV.hidden = !showSpeakAnimation;
    if (showSpeakAnimation) {
        self.readyLabel.hidden = YES;
    }
    self.timeLB.hidden = self.speakAnimationImgV.hidden;
    self.isDurationTimerValid = showSpeakAnimation;
    [self.speakAnimationImgV wy_setGIFImageWithURL:self.voiceGifURL];
}
- (void)setIsDurationTimerValid:(BOOL)isDurationTimerValid {
    if (isDurationTimerValid) {
        if (!_durationTimer) {
            [self.durationTimer fire];
        }
    } else {
        [self.durationTimer invalidate];
        self.durationTimer = nil;
    }
}
- (void)readyTalking {
    self.speakAnimationImgV.hidden = YES;
    self.readyLabel.hidden = NO;
    self.isDurationTimerValid = YES;
}
- (void)setLogined:(BOOL)logined {
    self.muteBtn.enabled = logined;
    self.speakBtn.enabled = logined;
}
- (void)setSpeakDelegateWithBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(receiveView:didClickSpeakBtn:)]) {
        [self.delegate receiveView:self didClickSpeakBtn:sender];
    }
}
- (void)setMuteDelegateWithBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(receiveView:didClickMuteBtn:)]) {
        [self.delegate receiveView:self didClickMuteBtn:sender];
    }
}
- (void)hangupBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(receiveView:didClickHangUpBtn:)]) {
        [self.delegate receiveView:self didClickHangUpBtn:sender];
    }
}
#pragma mark - Getter
- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [UILabel new];
        _timeLB.textColor = [UIColor whiteColor];
    }
    return _timeLB;
}
- (NSTimer *)durationTimer {
    if (!_durationTimer) {
        _durationTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(countDuration:)];
        _duration = 0;
    }
    return _durationTimer;
}
- (void)countDuration:(NSTimer *)timer {
    self.duration++;
    
    NSInteger hour = _duration / 3600;
    NSInteger min = (_duration % 3600) / 60;
    NSInteger sec = _duration % 60;
    
    if (hour > 0) {
        self.timeLB.text = [NSString stringWithFormat:@"%.2ld : %.2ld : %.2ld", hour, min, sec];
    } else {
        NSString *title = [NSString stringWithFormat:@"%.2ld : %.2ld", min, sec];
        self.timeLB.text = title;
    }
}
@end
