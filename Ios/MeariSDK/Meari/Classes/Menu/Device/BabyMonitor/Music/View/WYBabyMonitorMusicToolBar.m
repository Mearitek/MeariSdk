//
//  WYBabyMonitorMusicToolBar.m
//  Meari
//
//  Created by 李兵 on 2017/3/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBabyMonitorMusicToolBar.h"
#import "WYBabyMonitorMusicModel.h"

@interface WYBabyMonitorMusicToolBar ()
{
    NSString *_musicID;
}
@property (nonatomic, strong)UILabel *songLabel;
@property (nonatomic, strong)UIButton *prevBtn;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, strong)UIButton *playBtn;
@property (nonatomic, strong)UIButton *pauseBtn;
@property (nonatomic, strong)WYProgressCircleView *downloadView;
@property (nonatomic, strong)UIImageView *animatingImageView;
@property (nonatomic, strong)UIButton *soundBtn;
@property (nonatomic, strong)UISlider *soundSlider;
@property (nonatomic, strong)UILabel *soundLabel;
@property (nonatomic, strong)UIButton *modeBtn;

@property (nonatomic, strong)NSTimer *playingTimer;
@property (nonatomic, assign)WYBabyMonitorMusicStatus status;

@end

@implementation WYBabyMonitorMusicToolBar
#pragma mark - Private
#pragma mark -- Getter
- (UILabel *)songLabel {
    if (!_songLabel) {
        _songLabel = [UILabel labelWithFrame:CGRectZero
                                        text:nil
                                   textColor:WY_FontColor_Black
                                    textfont:WYFont_Text_M_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByTruncatingTail
                               lineAlignment:NSTextAlignmentCenter
                                   sizeToFit:NO];
        [self addSubview:_songLabel];
    }
    return _songLabel;
}
- (UIButton *)prevBtn {
    if (!_prevBtn) {
        _prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_prevBtn setImage:[UIImage imageNamed:@"btn_baby_music_prev_normal"] forState:UIControlStateNormal];
        [_prevBtn setImage:[UIImage imageNamed:@"btn_baby_music_prev_highlighted"] forState:UIControlStateHighlighted];
        [_prevBtn setImage:[UIImage imageNamed:@"btn_baby_music_prev_disabled"] forState:UIControlStateDisabled];
        [_prevBtn addTarget:self action:@selector(prevAction:) forControlEvents:UIControlEventTouchUpInside];
        _prevBtn.wy_needIgnored = YES;
        [self addSubview:_prevBtn];
    }
    return _prevBtn;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageNamed:@"btn_baby_music_next_normal"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"btn_baby_music_next_highlighted"] forState:UIControlStateHighlighted];
        [_nextBtn setImage:[UIImage imageNamed:@"btn_baby_music_next_disabled"] forState:UIControlStateDisabled];
        [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBtn];
        _nextBtn.wy_needIgnored = YES;
    }
    return _nextBtn;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"btn_baby_music_play_normal"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"btn_baby_music_play_highlighted"] forState:UIControlStateHighlighted];
        [_playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.wy_needIgnored = YES;
        [self addSubview:_playBtn];
    }
    return _playBtn;
}
- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseBtn setImage:[UIImage imageNamed:@"btn_baby_music_pause_normal"] forState:UIControlStateNormal];
        [_pauseBtn setImage:[UIImage imageNamed:@"btn_baby_music_pause_highlighted"] forState:UIControlStateHighlighted];
        [_pauseBtn addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
        _pauseBtn.wy_needIgnored = YES;
        [self addSubview:_pauseBtn];
    }
    return _pauseBtn;
}
- (WYProgressCircleView *)downloadView {
    if (!_downloadView) {
        _downloadView = [WYProgressCircleView new];
        _downloadView.progress = 0;
        _downloadView.backgroundCircleColor = WY_FontColor_DarkOrange;
        _downloadView.progressCircleColor = WY_FontColor_LightOrange;
        _downloadView.textColor = WY_FontColor_LightOrange;
        _downloadView.showText = NO;
        _downloadView.userInteractionEnabled = NO;
        [self addSubview:_downloadView];
    }
    return _downloadView;
}
- (UIImageView *)animatingImageView {
    if (!_animatingImageView) {
        _animatingImageView = [UIImageView new];
        _animatingImageView.image = [UIImage imageNamed:@"img_baby_music_loading"];
        [self addSubview:_animatingImageView];
    }
    return _animatingImageView;
}
- (UIButton *)soundBtn {
    if (!_soundBtn) {
        _soundBtn = [UIButton buttonWithFrame:CGRectZero
                                  normalImage:[UIImage imageNamed:@"btn_baby_music_volumeOn_normal"]
                             highlightedImage:[UIImage imageNamed:@"btn_baby_music_volumeOn_normal"]
                                selectedImage:[UIImage imageNamed:@"btn_baby_music_volumeOff_normal"]
                                       target:self
                                       action:@selector(muteAction:)];
        _soundBtn.userInteractionEnabled = NO;
        [self addSubview:_soundBtn];
    }
    return _soundBtn;
}
- (UISlider *)soundSlider {
    if (!_soundSlider) {
        _soundSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _soundSlider.maximumTrackTintColor = WY_FontColor_LightOrange;
        _soundSlider.minimumTrackTintColor = WY_FontColor_DarkOrange;
        _soundSlider.minimumValue = 0;
        _soundSlider.maximumValue = 100;
        [_soundSlider setThumbImage:[UIImage imageNamed:@"btn_baby_music_slide_normal"] forState:UIControlStateNormal];
        [_soundSlider setThumbImage:[UIImage imageNamed:@"btn_baby_music_slide_highlighted"] forState:UIControlStateHighlighted];
        [_soundSlider addTarget:self action:@selector(slideAction:) forControlEvents:(UIControlEventTouchUpInside |
                                                                                      UIControlEventTouchUpOutside |
                                                                                      UIControlEventTouchCancel)];
        [_soundSlider addTarget:self action:@selector(slidingAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_soundSlider];
    }
    return _soundSlider;
}
- (UILabel *)soundLabel {
    if (!_soundLabel) {
        _soundLabel = [UILabel labelWithFrame:CGRectZero
                                          text:WYLocalString(@"100")
                                     textColor:WY_FontColor_DarkOrange
                                      textfont:WYFont_Text_S_Normal
                                 numberOfLines:1
                                 lineBreakMode:NSLineBreakByTruncatingTail
                                 lineAlignment:NSTextAlignmentCenter
                                     sizeToFit:YES];
        [self addSubview:_soundLabel];
    }
    return _soundLabel;
}
- (UIButton *)modeBtn {
    if (!_modeBtn) {
        _modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_repeatOne_normal"] forState:UIControlStateNormal];
        [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_repeatOne_highlighted"] forState:UIControlStateHighlighted];
        _modeBtn.wy_needIgnored = YES;
        [self addSubview:_modeBtn];
    }
    return _modeBtn;
}

- (NSTimer *)playingTimer {
    if (!_playingTimer) {
        _playingTimer = [NSTimer timerInLoopWithInterval:0.05 target:self selector:@selector(timerToAnimating:)];
    }
    return _playingTimer;
}

#pragma mark -- Init
- (void)initSet {
    self.backgroundColor = [UIColor whiteColor];
    self.status = WYBabyMonitorMusicStatusPaused;
    self.volume = 0;
    self.playMode = WYBabymonitorMusicPlayModeDefault;
}
- (void)initLayout {
    [self addLineViewAtBottom];
    WY_WeakSelf
    [self.songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(20);
        make.height.equalTo(@20);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.equalTo(@(64));
        make.width.equalTo(weakSelf.playBtn.mas_height).multipliedBy(1.0f);
    }];
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.playBtn);
        make.size.equalTo(weakSelf.playBtn);
    }];
    [self.downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.playBtn);
        make.size.equalTo(weakSelf.playBtn);
    }];
    [self.animatingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.playBtn);
        make.height.equalTo(weakSelf.playBtn).offset(8.0f);
        make.width.equalTo(weakSelf.animatingImageView.mas_height).multipliedBy(1.0f);
    }];
    [self.prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playBtn);
        make.centerX.equalTo(weakSelf.mas_trailing).multipliedBy(0.25);
        make.height.equalTo(@(60));
        make.width.equalTo(weakSelf.prevBtn.mas_height).multipliedBy(1.0f);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playBtn);
        make.centerX.equalTo(weakSelf.mas_trailing).multipliedBy(0.75);
        make.height.equalTo(@(60));
        make.width.equalTo(weakSelf.prevBtn.mas_height).multipliedBy(1.0f);
    }];
    [self.soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_leading).offset(35);
        make.centerY.equalTo(weakSelf.mas_bottom).offset(-25);
        make.height.equalTo(@40);
        make.width.equalTo(weakSelf.soundBtn.mas_height).multipliedBy(1.0f);
    }];
    [self.soundSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.soundBtn);
        make.height.equalTo(@30);
        make.leading.equalTo(weakSelf.soundBtn.mas_trailing).offset(10);
        make.trailing.equalTo(weakSelf.soundLabel.mas_leading).offset(-10);
    }];
    [self.soundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.modeBtn.mas_leading).offset(-5);
        make.centerY.equalTo(weakSelf.soundBtn);
        make.size.mas_equalTo(weakSelf.soundLabel.size);
    }];
    [self.modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_trailing).offset(-35);
        make.centerY.equalTo(weakSelf.soundBtn);
        make.height.equalTo(@40);
        make.width.equalTo(weakSelf.soundBtn.mas_height).multipliedBy(1.0f);
    }];
}

#pragma mark -- NSTimer
- (void)timerToAnimating:(NSTimer *)sender {
    self.animatingImageView.transform = CGAffineTransformRotate(self.animatingImageView.transform, M_PI / 10.0f);
}

#pragma mark -- Utilities
- (void)enablePlayingTimer:(BOOL)enabled {
    if (enabled) {
        if (!_playingTimer) {
            [self.playingTimer fire];
        }
    }else {
        if (_playingTimer) {
            [_playingTimer invalidate];
            _playingTimer = nil;
        }
    }
}
- (void)setStatus:(WYBabyMonitorMusicStatus)status {
    _status = status;
    switch (status) {
        case WYBabyMonitorMusicStatusPaused: {
            self.playBtn.hidden = NO;
            self.pauseBtn.hidden = YES;
            self.downloadView.hidden = YES;
            self.animatingImageView.hidden = YES;
            [self enablePlayingTimer:NO];
            break;
        }
        case WYBabyMonitorMusicStatusPlaying: {
            self.playBtn.hidden = YES;
            self.pauseBtn.hidden = NO;
            self.downloadView.hidden = YES;
            self.animatingImageView.hidden = NO;
            [self enablePlayingTimer:YES];
            break;
        }
        case WYBabyMonitorMusicStatusDownloading: {
            self.playBtn.hidden = YES;
            self.pauseBtn.hidden = NO;
            self.downloadView.hidden = NO;
            [self insertSubview:self.downloadView aboveSubview:self.pauseBtn];
            self.animatingImageView.hidden = YES;
            [self enablePlayingTimer:NO];
            break;
        }
        case WYBabyMonitorMusicStatusPlayingAndDownloading: {
            self.playBtn.hidden = YES;
            self.pauseBtn.hidden = NO;
            self.downloadView.hidden = NO;
            [self insertSubview:self.downloadView aboveSubview:self.pauseBtn];
            self.animatingImageView.hidden = NO;
            [self enablePlayingTimer:YES];
            break;
        }
        default:
            break;
    }
}
- (void)setVolumeForUI:(CGFloat)value {
    self.soundLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    self.soundBtn.selected = value <= 0;
}
- (WYBabymonitorMusicPlayMode)nextPlayMode {
    WYBabymonitorMusicPlayMode mode = WYBabymonitorMusicPlayModeDefault;
    mode = self.playMode == WYBabymonitorMusicPlayModeSingle ? WYBabymonitorMusicPlayModeRepeatAll : WYBabymonitorMusicPlayModeSingle;
    return mode;
}


#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}

#pragma mark -- Action
- (void)prevAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYBabyMonitorMusicToolBar_PlayPrevSong:)]) {
        [self.delegate WYBabyMonitorMusicToolBar_PlayPrevSong:self];
    }
}
- (void)nextAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYBabyMonitorMusicToolBar_PlayNextSong:)]) {
        [self.delegate WYBabyMonitorMusicToolBar_PlayNextSong:self];
    }
}
- (void)playAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYBabyMonitorMusicToolBar_Play:musicID:)]) {
        [self.delegate WYBabyMonitorMusicToolBar_Play:self musicID:self.model.currentModel.musicID ?: _musicID];
    }
}
- (void)pauseAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYBabyMonitorMusicToolBar_Pause:musicID:)]) {
        [self.delegate WYBabyMonitorMusicToolBar_Pause:self musicID:self.model.currentModel.musicID ?: _musicID];
    }
}
- (void)muteAction:(UIButton *)sender {
    self.soundSlider.value = sender.isSelected ? self.soundSlider.maximumValue : self.soundSlider.minimumValue;
    [self slidingAction:self.soundSlider];
    [self slideAction:self.soundSlider];
}
- (void)slideAction:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(WYBabyMonitorMusicToolBar_ChangeVolume:volume:)]) {
        [self.delegate WYBabyMonitorMusicToolBar_ChangeVolume:self volume:sender.value];
    }
}
- (void)slidingAction:(UISlider *)sender {
    [self setVolumeForUI:sender.value];
}

#pragma mark - Delegate

#pragma mark - Public
- (void)setPlaying:(BOOL)playing {
    [self enablePlayingTimer:NO];
}
/** 音乐状态 **/
- (void)setModel:(WYBabymonitorMusicStateModel *)model {
    _model = model;
    self.songLabel.text = model.currentModel.musicName;
    self.playMode = model.musicMode;
    WYBabyMonitorMusicOneModel *currentModel = model.currentModel;
    self.status = currentModel.status;
    WYBabyMonitorMusicOneModel *firstModel = model.play_list.firstObject;
    WYBabyMonitorMusicOneModel *lastModel = model.play_list.lastObject;
    self.prevBtn.enabled = ![firstModel.musicID isEqualToString:model.current_musicID];
    self.nextBtn.enabled = ![lastModel.musicID isEqualToString:model.current_musicID];
    
    switch (self.status) {
        case WYBabyMonitorMusicStatusDownloading:
        case WYBabyMonitorMusicStatusPlayingAndDownloading: {
            self.downloadView.progress = currentModel.download_percent/100.0f;
            break;
        }
        default:
            break;
    }
}
/** 音量 **/
- (void)setVolume:(CGFloat)volume {
    volume = WY_Limit(volume, 0, 100);
    _volume = volume;
    
    self.soundSlider.value = volume;
    [self setVolumeForUI:volume];
}
/** 音乐播放模式 **/
- (void)setPlayMode:(WYBabymonitorMusicPlayMode)playMode {
    if (!WY_ContainOption(WYBabymonitorMusicPlayModeRepeatAll, playMode)) {
        playMode = WYBabymonitorMusicPlayModeDefault;
    }
    _playMode = playMode;
    switch (playMode) {
        case WYBabymonitorMusicPlayModeRepeatOne: {
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_repeatOne_normal"] forState:UIControlStateNormal];
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_repeatOne_highlighted"] forState:UIControlStateHighlighted];
            break;
        }
        case WYBabymonitorMusicPlayModeRepeatAll: {
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_repeatAll_normal"] forState:UIControlStateNormal];
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_repeatAll_highlighted"] forState:UIControlStateHighlighted];
            break;
        }
        case WYBabymonitorMusicPlayModeRandom: {
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_random_normal"] forState:UIControlStateNormal];
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_random_highlighted"] forState:UIControlStateHighlighted];
            break;
        }
        case WYBabymonitorMusicPlayModeSingle: {
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_single_normal"] forState:UIControlStateNormal];
            [_modeBtn setImage:[UIImage imageNamed:@"btn_baby_music_single_highlighted"] forState:UIControlStateHighlighted];
            break;
        }
        default:
            break;
    }
}
/** 显示第一首歌 **/
- (void)setFirstMusicName:(NSString *)musicName musicID:(NSString *)musicID {
    _musicID = musicID.copy;
    if (!self.model && musicName && self.songLabel.text.length <= 0) {
        self.songLabel.text = musicName;
        self.playMode = WYBabymonitorMusicPlayModeDefault;
        self.status = WYBabyMonitorMusicStatusPaused;
        self.prevBtn.enabled = NO;
        self.nextBtn.enabled = YES;
    }
}

@end
