//
//  WYDoorBellSettingHostMessageAudioView.m
//  Meari
//
//  Created by FMG on 2017/7/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingHostMessageAudioView.h"

@interface WYDoorBellSettingHostMessageAudioView () {
    NSInteger recordTime;
    CGFloat _pressTime;
    CGFloat recordLimitTime;
    BOOL hasAudio;
    BOOL _isPlaying;
}
@property (nonatomic, strong) WYProgressCircleView *progressCircleView;
@property (nonatomic, strong) NSTimer *recordTimer;
@property (nonatomic, strong) NSTimer *pressTimer;
@property (nonatomic,   weak) UIButton *audioBtn;
@property (nonatomic,   weak) UIButton *cancelBtn;
@property (nonatomic,   weak) UIButton *checkBtn;
@property (nonatomic,   weak) UILabel *desLabel;
@property (nonatomic,   weak) UILabel *timeLabel;
@property (nonatomic,   assign) BOOL hasCallback;

@end

@implementation WYDoorBellSettingHostMessageAudioView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setInit];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioBtn.mas_bottom).equalTo(@10);
        make.leading.equalTo(self).offset(30);
        make.trailing.equalTo(self).offset(-30);
    }];
    //    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self);
    //        make.leading.equalTo(@(WY_ScreenWidth / 8.0));
    //        make.size.mas_equalTo(CGSizeMake(50, 50));
    //    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.audioBtn.mas_top).equalTo(@-20);
        make.centerX.equalTo(self);
    }];
    
    [self.progressCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.progressCircleView);
        make.size.mas_equalTo(CGSizeMake(85, 85));
    }];
    //    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.trailing.equalTo(self).with.offset(-WY_ScreenWidth / 8.0);
    //        make.centerY.equalTo(self);
    //        make.size.mas_equalTo(CGSizeMake(50, 50));
    //    }];
    [self.audioBtn.superview layoutIfNeeded];
    self.audioBtn.layer.cornerRadius =  self.audioBtn.height / 2;
}
- (void)setInit {
    recordLimitTime = 10.0;
}
- (void)setRecordLimitTime:(float)time{
    recordLimitTime = time;
}
- (void)setEnableRecord:(BOOL)enableRecord {
    _enableRecord = enableRecord;
    self.audioBtn.enabled = enableRecord;
}
- (void)startRecord {
    if (hasAudio) return;
    _hasCallback = NO;
    self.timeLabel.text = @"0:00";
    if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:startRecordButton:)]) {
        [self.delegate HostMessageAudioView:self startRecordButton:self.audioBtn];
    }
    if (!self.microphoneAuth) return;
    hasAudio = YES;
    self.timeLabel.hidden = NO;
    //    [self.audioBtn showZoomAnimation];
    self.progressCircleView.hidden = NO;
    [self recordTimer];
}
#pragma mark - TimerAction
- (void)timerToRecord:(id)sender {
    recordTime++;
    self.progressCircleView.progress = (recordTime/10.0)/recordLimitTime;
    
    self.timeLabel.text = [NSString stringWithFormat:@"0:%02ld", (long int)ceilf(recordTime / 10.0)];
    if (recordTime/10.0 >= recordLimitTime-1) {
        if (!_hasCallback) {
            [self stopRecordBeforeOneSecond];
        }
    }
    if (recordTime / 10.0 >= recordLimitTime) {
        [self stopRecordAfterOneSecond];
    }
}
- (void)timerToPress:(id)sender {
    _pressTime += 0.1;
    if (_pressTime >= 0.8) {
        [self startRecord];
    }
}
- (void)stopRecord {
    if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:stopRecordButton:)]) {
        if (!_hasCallback) {
            [self.delegate HostMessageAudioView:self stopRecordButton:self.audioBtn];
        }
    }
    self.timeLabel.hidden = YES;
    //    [self.audioBtn hideZoomAnimation];
    self.cancelBtn.hidden = self.checkBtn.hidden = NO;
    //    self.audioBtn.wy_normalImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_play"];
    recordTime = 0;
    self.progressCircleView.progress = 0;
    self.progressCircleView.hidden = YES;
    [self.recordTimer invalidate];
    _recordTimer = nil;
    hasAudio = NO;
}
//为了 限制录音文件大小绝对小于30秒
- (void)stopRecordBeforeOneSecond {
    [_pressTimer invalidate];
    _pressTimer = nil;
    if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:stopRecordButton:)]) {
        _hasCallback = YES;
        [self.delegate HostMessageAudioView:self stopRecordButton:self.audioBtn];
    }
}
- (void)stopRecordAfterOneSecond {
    self.timeLabel.hidden = YES;
    //    [self.audioBtn hideZoomAnimation];
    self.cancelBtn.hidden = self.checkBtn.hidden = NO;
    //    self.audioBtn.wy_normalImage = [UIImage imageNamed:@"btn_doorbell_hostMessage_play"];
    recordTime = 0;
    self.progressCircleView.progress = 0;
    self.progressCircleView.hidden = YES;
    [self.recordTimer invalidate];
    _recordTimer = nil;
    hasAudio = NO;
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
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startRecord];
    } else if (gesture.state == UIGestureRecognizerStateEnded && self.microphoneAuth) {
        [self stopRecord];
    }
}
- (void)offsetButtonTouchBegin:(id)sender {
    WY_WeakSelf
    BOOL exit = NO;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined ) {
        exit = YES;
    }
    [WYAuthorityManager checkAuthorityOfMicrophoneWithAlert:^{
        if (!hasAudio && !exit) {
            //            WYLog(@"开始计时");
            [weakSelf pressTimer];
        }
    }];
}
- (void)offsetButtonTouchEnd:(id)sender {
    if (_pressTime <= 0.5 && hasAudio) {
        //        if (self.progressCircleView.isHidden && hasAudio && !_isPlaying) {
        //            if ([self.delegate respondsToSelector:@selector(HostMessageAudioView:didTapPlayButton:)]) {
        //                _isPlaying = YES;
        //                [self.delegate HostMessageAudioView:self didTapPlayButton:sender];
        //            }
        //            [self.audioBtn showRippleAnimation];
        //        }
    } else if (_pressTime > 0.8) {
        [self stopRecord];
    }
    _pressTime = 0;
    [_pressTimer invalidate];
    _pressTimer = nil;
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
    _isPlaying = NO;
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
        //        [btn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(audioBtnAction:)]];
        //        [btn addTarget:self action:@selector(playAudioAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(offsetButtonTouchEnd:)forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(offsetButtonTouchBegin:)forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(offsetButtonTouchEnd:)forControlEvents:UIControlEventTouchUpOutside];
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
- (NSTimer *)pressTimer {
    if (!_pressTimer) {
        _pressTimer = [NSTimer timerInLoopWithInterval:.1f target:self selector:@selector(timerToPress:)];
    }
    return _pressTimer;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = WYFontNormal(16);
        [label ajustedHeightWithWidth:WY_ScreenWidth - 60];
        label.text = WYLocalString(@"des_hostMessage");
        label.textColor = WY_FontColor_Gray;
        _desLabel = label;
        [self addSubview:label];
    }
    return _desLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0:00";
        label.textColor = WY_FontColor_Black;
        label.font = WYFontNormal(15);
        _timeLabel = label;
        label.hidden = YES;
        [self addSubview:label];
    }
    return _timeLabel;
}


@end
