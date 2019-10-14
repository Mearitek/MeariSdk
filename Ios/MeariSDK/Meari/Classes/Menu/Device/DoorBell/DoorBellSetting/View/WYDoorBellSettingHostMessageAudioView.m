//
//  WYDoorBellSettingHostMessageAudioView.m
//  Meari
//
//  Created by FMG on 2017/7/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingHostMessageAudioView.h"

@interface WYDoorBellSettingHostMessageAudioView ()
{
    NSInteger recordTime;
    CGFloat recordLimitTime;
    BOOL hasAudio;
    BOOL _isPlaying;
}
@property (nonatomic, strong) WYProgressCircleView *progressCircleView;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic,   weak) UIButton *audioBtn;
@property (nonatomic,   weak) UIButton *cancelBtn;
@property (nonatomic,   weak) UIButton *checkBtn;
@property (nonatomic,   weak) UILabel  *desLabel;

@end

@implementation WYDoorBellSettingHostMessageAudioView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setInit];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(30);
        make.trailing.equalTo(self).offset(-30);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(WY_ScreenWidth/8.0));
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.progressCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(135, 135));
    }];
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.progressCircleView);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).with.offset(-WY_ScreenWidth/8.0);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.audioBtn.superview layoutIfNeeded];
    self.audioBtn.layer.cornerRadius =  self.audioBtn.height/2;
}
- (void)setInit {
    recordLimitTime = 30.0;
}
- (void)setEnableRecord:(BOOL)enableRecord {
    _enableRecord = enableRecord;
    self.audioBtn.enabled = enableRecord;
}
- (void)startRecord {
    if (hasAudio) return;
    if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:startRecordButton:)]) {
        [self.delegate HostMessageAudioView:self startRecordButton:self.audioBtn];
    }
    if (!self.microphoneAuth) return;
    hasAudio = YES;
    [self.audioBtn showZoomAnimation];
    self.progressCircleView.hidden = NO;
    [self recordTimer];
}
- (void)timerToRecord:(id)sender {
    recordTime++;
    self.progressCircleView.progress = (recordTime/10.0)/recordLimitTime;
    if (recordTime/10.0 >= recordLimitTime) {
        [self stopRecord];
    }
}
- (void)stopRecord {
    if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:stopRecordButton:)]) {
        [self.delegate HostMessageAudioView:self stopRecordButton:self.audioBtn];
    }
    [self.audioBtn hideZoomAnimation];
    self.cancelBtn.hidden = self.checkBtn.hidden = NO;
    self.audioBtn.wy_normalImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_play"];
    recordTime = 0;
    self.progressCircleView.progress = 0;
    self.progressCircleView.hidden = YES;
    [self.recordTimer invalidate];
    _recordTimer = nil;
}
- (void)playAudioAction:(UIButton *)sender {
    if (self.progressCircleView.isHidden && hasAudio && !_isPlaying) {
        if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:didTapPlayButton:)]) {
            _isPlaying = YES;
            [self.delegate HostMessageAudioView:self didTapPlayButton:sender];
        }
        [self.audioBtn showRippleAnimation];
    }
}


#pragma mark - Action
- (void)audioBtnAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan ) {
        [self startRecord];
    } else if(gesture.state == UIGestureRecognizerStateEnded && self.microphoneAuth) {
        [self stopRecord];
    }
}
- (void)cancelAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:didTapCancelButton:)]) {
        [self.delegate HostMessageAudioView:self didTapCancelButton:sender];
    }
    [self cancelAudition];
}
- (void)checkAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:didTapCheckButton:)]) {
        [self.delegate HostMessageAudioView:self didTapCheckButton:sender];
    }
    hasAudio = NO;
}
- (void)didFinishedPlay {
    _isPlaying = NO;
    [self.audioBtn hideRippleAnimation];
}
//结束试听
- (void)cancelAudition {
    hasAudio = NO;
    [self.audioBtn hideRippleAnimation];
    self.audioBtn.wy_normalImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_input"];
    self.cancelBtn.hidden = self.checkBtn.hidden = YES;
}
#pragma mark - lazyLoad
- (UIButton *)audioBtn {
    if (!_audioBtn) {
        UIButton *btn = [UIButton new];
        _audioBtn = btn;
        btn.wy_normalImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_input"];
        btn.wy_disabledImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_input_disabled"];
        [btn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(audioBtnAction:)]];
        [btn addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return _audioBtn;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *btn = [UIButton new];
        _cancelBtn = btn;
        [btn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
        btn.wy_normalImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_cancel"];
        [self addSubview:btn];
    }
    return _cancelBtn;
}
- (UIButton *)checkBtn {
    if (!_checkBtn) {
        UIButton *btn = [UIButton new];
        btn.wy_normalImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_check"];
        _checkBtn = btn;
        [btn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
        [self addSubview:btn];
    }
    return _checkBtn;
}
- (WYProgressCircleView *)progressCircleView {
    if (!_progressCircleView) {
        WYProgressCircleView *view = [[WYProgressCircleView alloc] init];
        view.backgroundCircleColor = WY_FontColor_White;
        view.progressCircleColor = WY_FontColor_Cyan;
        view.progressWidth = 5;
        view.progress = 0;
        view.showText = NO;
        view.hidden = YES;
        _progressCircleView = view;
        [self addSubview:view];
    }
    return _progressCircleView;
}
- (NSTimer *)recordTimer {
    if (!_recordTimer) {
        _recordTimer = [NSTimer timerInLoopWithInterval:.1f target:self selector:@selector(timerToRecord:)];
    }
    return _recordTimer;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [label ajustedHeightWithWidth:WY_ScreenWidth - 60];
        label.text = WYLocalString(@"des_hostMessage");
        label.textColor = WY_FontColor_Gray;
        _desLabel = label;
        [self addSubview:label];
    }
    return _desLabel;
}
@end
