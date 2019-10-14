//
//  WYCameraToolBar.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraToolBar.h"

const NSTimeInterval WY_voiceIgnoredInterval = 0.12;

@interface WYCameraToolBar ()
{
    CFAbsoluteTime _voiceDownTime;
    CFAbsoluteTime _voiceUpTime;
}
@property (nonatomic, strong)NSArray *buttons;
@property (nonatomic, weak)UIButton *voiceBtn;
@property (nonatomic, weak)UIButton *snapshotBtn;
@property (nonatomic, weak)UIButton *playBtn;
@property (nonatomic, weak)UIButton *recordBtn;
@property (nonatomic, weak)UIButton *muteBtn;
@property (nonatomic, weak)UIButton *bitStreamBtn;
@property (nonatomic, weak)UIView *line;

@property (nonatomic, weak)FXBlurView *blurView;

@property (nonatomic, assign)BOOL previewMuted;
@property (nonatomic, assign)BOOL sdcardMuted;
@property (nonatomic, assign)BOOL needMusic;
@property (nonatomic, assign)BOOL fullDuplex;
@property (nonatomic, assign)BOOL isPortrait;

@property (nonatomic, strong) NSMutableArray *normalImageArr;
@property (nonatomic, strong) NSMutableArray *normalLandscapeImageArr;

@end

@implementation WYCameraToolBar
#pragma mark - Private
#pragma mark -- Getter
- (NSArray *)buttons {
    NSArray *selectedImageArr;
    if (!_buttons) {
        if (WY_CameraM.babyMonitor) {
            selectedImageArr = @[[UIImage record_baby_slected_image],
                                 [UIImage snapshot_baby_slected_image],
                                 [UIImage play_baby_slected_image],
                                 [UIImage voice_baby_slected_image],
                                 [UIImage mute_baby_slected_image]
                                 ];
        }else {
            selectedImageArr = @[[UIImage record_slected_image],
                                 [UIImage snapshot_slected_image],
                                 [UIImage play_slected_image],
                                 [UIImage voice_slected_image],
                                 [UIImage mute_slected_image]
                                 ];
        }
        self.normalImageArr = @[[UIImage record_normal_image],
                                [UIImage snapshot_normal_image],
                                [UIImage play_normal_image],
                                [UIImage voice_normal_image],
                                [UIImage mute_normal_image]].mutableCopy;
        self.normalLandscapeImageArr = @[[UIImage record_normal_image_landscape],
                                         [UIImage snapshot_normal_image_landscape],
                                         [UIImage play_normal_image_landscape],
                                         [UIImage voice_normal_image_landscape],
                                         [UIImage mute_normal_image_landscape]].mutableCopy;

        NSArray *disabledImageArr = @[[UIImage record_disabled_image],
                                      [UIImage snapshot_disabled_image],
                                      [UIImage play_disabled_image],
                                      [UIImage voice_disabled_image],
                                      [UIImage mute_disabled_image]
                                      ];
        NSArray *selArr = @[NSStringFromSelector(@selector(recordAction:)),
                            NSStringFromSelector(@selector(snapshotAction:)),
                            NSStringFromSelector(@selector(playAction:)),
                            NSStringFromSelector(@selector(voiceDownAction:)),
                            NSStringFromSelector(@selector(muteAction:)),
                            ];
        if (self.fullDuplex) {
            [self.normalImageArr replaceObjectAtIndex:3 withObject:[UIImage voice_normal_fullDuplex_image]];
            [self.normalLandscapeImageArr replaceObjectAtIndex:3 withObject:[UIImage voice_normal_image_fullDuplex_landscape]];
        }
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.normalImageArr.count];
        for (int i = 0; i < self.normalImageArr.count; i++) {
            UIButton *btn = [UIButton buttonWithFrame:CGRectZero
                                          normalImage:self.normalImageArr[i]
                                     highlightedImage:selectedImageArr[i]
                                        selectedImage:selectedImageArr[i]
                                               target:self
                                               action:NSSelectorFromString(selArr[i])];
            [btn setImage:disabledImageArr[i] forState:UIControlStateDisabled];
            [self addSubview:btn];
            [arr addObject:btn];
        }
        UIButton *btn = [UIButton buttonWithFrame:CGRectZero normalTitle:WYLocalString(@"") normalColor:WY_FontColor_White higlightedTitle:WYLocalString(@"") higlightedColor:WY_MainColor selectedTitle:nil selectedColor:nil target:self action:NSSelectorFromString(selArr.lastObject)];
//        [self addSubview:btn];
        [arr addObject:btn];
        _buttons = arr.copy;
    }
    return _buttons;
}
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = self.buttons[3];
    }
    return _voiceBtn;
}
- (UIButton *)snapshotBtn {
    if (!_snapshotBtn) {
        _snapshotBtn = self.buttons[1];
        _snapshotBtn.wy_needIgnored = YES;
    }
    return _snapshotBtn;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = self.buttons[2];
        _playBtn.wy_needIgnored = YES;
    }
    return _playBtn;
}
- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = self.buttons[0];
        _recordBtn.wy_needIgnored = YES;
        _recordBtn.wy_delayTime = 0.5f;
    }
    return _recordBtn;
}
- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = self.buttons[4];
        _muteBtn.wy_needIgnored = YES;
    }
    return _muteBtn;
}
- (UIButton *)bitStreamBtn {
    if (!_bitStreamBtn) {
        _bitStreamBtn = self.buttons[5];
        _bitStreamBtn.wy_needIgnored = YES;
    }
    return _bitStreamBtn;
}
- (UIView *)line {
    if (!_line) {
        UIView *view = [UIView new];
        view.backgroundColor = WY_LineColor_LightGray;
        [self addSubview:view];
        _line = view;
    }
    return _line;
}

#pragma mark -- Init
- (void)initSet {
    _voiceUpTime = _voiceDownTime = CFAbsoluteTimeGetCurrent();
    self.previewMuted = YES;
    self.sdcardMuted = YES;
}
- (void)initLayout {
    WY_WeakSelf
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf);
        make.height.equalTo(@(WY_1_PIXEL));
    }];
}

#pragma mark -- Utilities
#pragma mark -- Life
- (void)updateConstraints {
    MASAttachKeys(self.recordBtn, self.snapshotBtn, self.playBtn, self.voiceBtn, self.muteBtn);
    WY_WeakSelf
    [self.recordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf);
    }];
    [self.snapshotBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.recordBtn.mas_trailing);
        make.width.equalTo(weakSelf.recordBtn);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.snapshotBtn.mas_trailing);
        if (weakSelf.previewed) {
            if (WY_CameraM.babyMonitor && weakSelf.needMusic && UIInterfaceOrientationIsPortrait(WY_Application.statusBarOrientation)) {
                make.width.equalTo(weakSelf.recordBtn);
                make.height.equalTo(weakSelf);
            }else {
                make.width.equalTo(@0);
                make.height.equalTo(@0);
            }
        }else {
            make.width.equalTo(weakSelf.recordBtn);
            make.height.equalTo(weakSelf);
        }
    }];
    [self.voiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(weakSelf);
        make.width.equalTo(weakSelf.recordBtn);
        make.leading.equalTo(weakSelf.playBtn.mas_trailing);
    }];
    [self.muteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.voiceBtn.mas_trailing);
        make.width.equalTo(weakSelf.recordBtn);
        make.trailing.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark -- Action
- (void)voiceDownAction:(UIButton *)sender {
    if (WY_CameraM.babyMonitor) {
        self.voiceBtn.wy_normalImage = [UIImage voice_baby_slected_image];
    }else if(self.fullDuplex) {
        self.voiceBtn.wy_normalImage = _isPortrait ? [UIImage voice_normal_image_fullDuplex_landscape] : [UIImage voice_normal_fullDuplex_image];
    } else {
        self.voiceBtn.wy_normalImage = [UIImage voice_slected_image];
    }
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didTapedVoiceButton:)]) {
        [self.delegate WYCameraToolBar:self didTapedVoiceButton:sender];
    }
}
- (void)voiceUpAction:(UIButton *)sender {
    self.voiceBtn.wy_normalImage = [UIImage voice_normal_image];
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didLosedVoiceButton:)]) {
        [self.delegate WYCameraToolBar:self didLosedVoiceButton:sender];
    }
}
- (void)calendarAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didTapedCalendarButton:)]) {
        [self.delegate WYCameraToolBar:self didTapedCalendarButton:sender];
    }
}
- (void)snapshotAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didTapedSnapshotButton:)]) {
        [self.delegate WYCameraToolBar:self didTapedSnapshotButton:sender];
    }
}
- (void)playAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didTapedPlayButton:)]) {
        [self.delegate WYCameraToolBar:self didTapedPlayButton:sender];
    }
}
- (void)musicAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didTapedMusicButton:)]) {
        [self.delegate WYCameraToolBar:self didTapedMusicButton:sender];
    }
}
- (void)recordAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didTapedRecordButton:)]) {
        [self.delegate WYCameraToolBar:self didTapedRecordButton:sender];
    }
}
- (void)muteAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolBar:didTapedMuteButton:)]) {
        [self.delegate WYCameraToolBar:self didTapedMuteButton:sender];
    }
}
#pragma mark - Delegate
#pragma mark - Public
- (instancetype)initWithVideoType:(WYVideoType)videoType {
    return [self initWithVideoType:videoType needMusic:YES fullDuplex:NO];
}
- (instancetype)initWithVideoType:(WYVideoType)videoType needMusic:(BOOL)needMusic fullDuplex:(BOOL)fullDuplex {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.fullDuplex = fullDuplex;
        self.needMusic = needMusic;
        self.videoType = videoType;
        [self initSet];
        [self initLayout];
    }
    return self;
}
- (void)setVideoType:(WYVideoType)videoType {
    if (_videoType == videoType) return;
    _videoType = videoType;
    self.voiceBtn.selected = NO;
    switch (_videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD: {
            if (WY_CameraM.babyMonitor && self.needMusic) {
                [self.voiceBtn setImage:[UIImage voice_normal_image] forState:UIControlStateNormal];
                [self.voiceBtn setImage:[UIImage voice_baby_slected_image] forState:UIControlStateHighlighted];
                [self.voiceBtn setImage:[UIImage voice_baby_slected_image] forState:UIControlStateSelected];
                
                [self.playBtn setImage:[UIImage music_slected_image] forState:UIControlStateNormal];
                [self.playBtn setImage:[UIImage music_highlighted_image] forState:UIControlStateHighlighted];
                [self.playBtn setImage:[UIImage music_slected_image] forState:UIControlStateSelected];
                [self.playBtn setImage:[UIImage music_disabled_image] forState:UIControlStateDisabled];
                
            }else {
                if (self.fullDuplex) {
                    [self.voiceBtn setImage:[UIImage voice_normal_fullDuplex_image] forState:UIControlStateNormal];
                } else {
                    [self.voiceBtn setImage:[UIImage voice_normal_image] forState:UIControlStateNormal];
                }
                [self.voiceBtn setImage:[UIImage voice_slected_image] forState:UIControlStateHighlighted];
                [self.voiceBtn setImage:[UIImage voice_slected_image] forState:UIControlStateSelected];
                
                [self.playBtn setImage:[UIImage play_normal_image] forState:UIControlStateNormal];
                [self.playBtn setImage:[UIImage play_slected_image] forState:UIControlStateHighlighted];
                [self.playBtn setImage:[UIImage play_slected_image] forState:UIControlStateSelected];
                [self.playBtn setImage:[UIImage play_disabled_image] forState:UIControlStateDisabled];
                
            }
            //voice事件
            [self.voiceBtn removeTarget:self action:@selector(calendarAction:) forControlEvents:UIControlEventTouchUpInside];
            if (self.fullDuplex) {
                [self.voiceBtn addTarget:self action:@selector(voiceDownAction:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.voiceBtn addTarget:self action:@selector(voiceDownAction:) forControlEvents:UIControlEventTouchDown];
                [self.voiceBtn addTarget:self action:@selector(voiceUpAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.voiceBtn addTarget:self action:@selector(voiceUpAction:) forControlEvents:UIControlEventTouchUpOutside];
                [self.voiceBtn addTarget:self action:@selector(voiceUpAction:) forControlEvents:UIControlEventTouchCancel];
            }
            //play事件
            [self.playBtn removeTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.playBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case WYVideoTypePlaybackNVR:
        case WYVideoTypePlaybackSDCard:{
            if (WY_CameraM.babyMonitor) {
                [self.voiceBtn setImage:[UIImage calendar_normal_image] forState:UIControlStateNormal];
                [self.voiceBtn setImage:[UIImage calendar_baby_slected_image] forState:UIControlStateHighlighted];
                [self.voiceBtn setImage:[UIImage calendar_baby_slected_image] forState:UIControlStateSelected];
                
                [self.playBtn setImage:[UIImage play_normal_image] forState:UIControlStateNormal];
                [self.playBtn setImage:[UIImage play_baby_slected_image] forState:UIControlStateHighlighted];
                [self.playBtn setImage:[UIImage play_baby_slected_image] forState:UIControlStateSelected];
                [self.playBtn setImage:[UIImage play_disabled_image] forState:UIControlStateDisabled];
                
            }else {
                [self.voiceBtn setImage:[UIImage calendar_normal_image] forState:UIControlStateNormal];
                [self.voiceBtn setImage:[UIImage calendar_slected_image] forState:UIControlStateHighlighted];
                [self.voiceBtn setImage:[UIImage calendar_slected_image] forState:UIControlStateSelected];
                
                [self.playBtn setImage:[UIImage play_normal_image] forState:UIControlStateNormal];
                [self.playBtn setImage:[UIImage play_slected_image] forState:UIControlStateHighlighted];
                [self.playBtn setImage:[UIImage play_slected_image] forState:UIControlStateSelected];
                [self.playBtn setImage:[UIImage play_disabled_image] forState:UIControlStateDisabled];
            }
            //voice事件
            if (self.fullDuplex) {
                [self.voiceBtn removeTarget:self action:@selector(voiceDownAction:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.voiceBtn removeTarget:self action:@selector(voiceDownAction:) forControlEvents:UIControlEventTouchDown];
                [self.voiceBtn removeTarget:self action:@selector(voiceUpAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.voiceBtn removeTarget:self action:@selector(voiceUpAction:) forControlEvents:UIControlEventTouchUpOutside];
                [self.voiceBtn removeTarget:self action:@selector(voiceUpAction:) forControlEvents:UIControlEventTouchCancel];
            }
            [self.voiceBtn addTarget:self action:@selector(calendarAction:) forControlEvents:UIControlEventTouchUpInside];
            //play事件
            [self.playBtn removeTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        default:
            break;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)setScreenType:(WYCameraToolBarVideoType)screenType {
    if (_screenType == screenType) return;
    if (screenType == WYCameraToolBarPreviewTypeP || screenType == WYCameraToolBarPlaybackTypeP) {
        self.line.hidden = NO;
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }else {
        self.line.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    if (_screenType) {
        _screenType = screenType;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    } else {
        _screenType = screenType;
    }
    [self resetNormalImage];
    
}
- (BOOL)isPortrait {
    return self.screenType == WYCameraToolBarPreviewTypeP || self.screenType == WYCameraToolBarPlaybackTypeP;
}
- (void)resetNormalImage {
    NSArray *images  = [NSArray array];
    switch (_screenType) {
        case WYCameraToolBarPreviewTypeP: {
            [self.normalImageArr replaceObjectAtIndex:3 withObject:_fullDuplex ? [UIImage voice_normal_fullDuplex_image] :  [UIImage voice_normal_image]];
            [self.normalImageArr replaceObjectAtIndex:2 withObject:self.needMusic ? [UIImage music_slected_image] :  [UIImage play_normal_image]];
            images = self.normalImageArr;
            break;
        }
        case WYCameraToolBarPlaybackTypeP: {
            [self.normalImageArr replaceObjectAtIndex:3 withObject:[UIImage calendar_normal_image]];
            [self.normalImageArr replaceObjectAtIndex:2 withObject:[UIImage play_normal_image]];
            images = self.normalImageArr;
            break;
        }
        case WYCameraToolBarPreviewTypeL: {
            [self.normalLandscapeImageArr replaceObjectAtIndex:3 withObject:_fullDuplex ? [UIImage voice_normal_image_fullDuplex_landscape] : [UIImage voice_normal_image_landscape]];
            images = self.normalLandscapeImageArr;
            break;
        }
        case WYCameraToolBarPlaybackTypeL: {
            [self.normalLandscapeImageArr replaceObjectAtIndex:3 withObject:[UIImage calendar_normal_image_landscape]];
            images = self.normalLandscapeImageArr;
            break;
        }
        default:
            images = self.normalImageArr;
            break;
    }
    [self.recordBtn     setWy_normalImage:images[0]];
    [self.snapshotBtn   setWy_normalImage:images[1]];
    [self.playBtn       setWy_normalImage:images[2]];
    [self.voiceBtn      setWy_normalImage:images[3]];
    [self.muteBtn       setWy_normalImage:images[4]];
}
- (BOOL)previewed {
    return self.videoType == WYVideoTypePreviewSD || self.videoType == WYVideoTypePreviewHD || self.videoType == WYVideoTypePreviewAT;
}
- (void)setButton:(WYCameraToolBarButtonType)buttonType selected:(BOOL)selected {
    switch (buttonType) {
        case WYCameraToolBarButtonTypeVoice: {
            if (self.previewed) {
                self.voiceBtn.selected = selected;
                if (!selected) {
                    self.voiceBtn.wy_normalImage = self.isPortrait ? (_fullDuplex? [UIImage voice_normal_fullDuplex_image]:[UIImage voice_normal_image]) : (_fullDuplex? [UIImage voice_normal_image_fullDuplex_landscape]:[UIImage voice_normal_image_landscape]);
                }
            }
            break;
        }
        case WYCameraToolBarButtonTypeCalendar: {
            self.voiceBtn.selected = selected;
            break;
        }
        case WYCameraToolBarButtonTypeSnapshot: {
            self.snapshotBtn.selected = selected;
            break;
        }
        case WYCameraToolBarButtonTypePlay: {
            self.playBtn.selected = selected;
            break;
        }
        case WYCameraToolBarButtonTypeMusic: {
            if (self.previewed) {
                self.playBtn.selected = selected;
            }
            break;
        }
        case WYCameraToolBarButtonTypeRecord: {
            self.recordBtn.selected = selected;
            break;
        }
        case WYCameraToolBarButtonTypeMute: {
            if (selected) {
//                [self.muteBtn setImage:[UIImage volumeOn_normal_image] forState:UIControlStateNormal];
//                [self.muteBtn setImage:[UIImage volumeOn_disabled_image] forState:UIControlStateDisabled];
                if (WY_CameraM.babyMonitor) {
                    [self.muteBtn setImage:[UIImage volumeOn_baby_slected_image] forState:UIControlStateHighlighted];
                    [self.muteBtn setImage:[UIImage volumeOn_baby_slected_image] forState:UIControlStateSelected];
                    
                }else {
                    [self.muteBtn setImage:[UIImage volumeOn_slected_image] forState:UIControlStateHighlighted];
                    [self.muteBtn setImage:[UIImage volumeOn_slected_image] forState:UIControlStateSelected];
                    
                }
            }else {
                [self.muteBtn setImage:self.isPortrait ?[UIImage mute_normal_image]:[UIImage mute_normal_image_landscape] forState:UIControlStateNormal];
//                [self.muteBtn setImage:[UIImage mute_disabled_image] forState:UIControlStateDisabled];
                if (WY_CameraM.babyMonitor) {
                    [self.muteBtn setImage:[UIImage mute_baby_slected_image] forState:UIControlStateHighlighted];
                    [self.muteBtn setImage:[UIImage mute_baby_slected_image] forState:UIControlStateSelected];
                    
                }else {
                    [self.muteBtn setImage:[UIImage mute_slected_image] forState:UIControlStateHighlighted];
                    [self.muteBtn setImage:[UIImage mute_slected_image] forState:UIControlStateSelected];
                    
                }
            }
            self.muteBtn.selected = selected;
            break;
        }
        default:
            break;
    }
}
- (void)setButton:(WYCameraToolBarButtonType)buttonType enabled:(BOOL)enabled {
    switch (buttonType) {
        case WYCameraToolBarButtonTypeVoice: {
            self.voiceBtn.enabled = enabled;
            break;
        }
        case WYCameraToolBarButtonTypeCalendar: {
            self.voiceBtn.enabled = enabled;
            break;
        }
        case WYCameraToolBarButtonTypeSnapshot: {
            self.snapshotBtn.enabled = enabled;
            break;
        }
        case WYCameraToolBarButtonTypePlay: {
            self.playBtn.enabled = enabled;
            break;
        }
        case WYCameraToolBarButtonTypeMusic: {
            self.playBtn.enabled = enabled;
            break;
        }
        case WYCameraToolBarButtonTypeRecord: {
            self.recordBtn.enabled = enabled;
            break;
        }
        case WYCameraToolBarButtonTypeMute: {
            self.muteBtn.enabled = enabled;
            switch (self.videoType) {
                case WYVideoTypePreviewHD:
                case WYVideoTypePreviewSD: {
                    if (enabled) {
                        if (self.muteBtn.selected) {
//                            [self.muteBtn setImage:[UIImage volumeOn_normal_image] forState:UIControlStateNormal];
//                            [self.muteBtn setImage:[UIImage volumeOn_disabled_image] forState:UIControlStateDisabled];
                            if (WY_CameraM.babyMonitor) {
                                [self.muteBtn setImage:[UIImage volumeOn_baby_slected_image] forState:UIControlStateHighlighted];
                                [self.muteBtn setImage:[UIImage volumeOn_baby_slected_image] forState:UIControlStateSelected];
                                
                            }else {
                                [self.muteBtn setImage:[UIImage volumeOn_slected_image] forState:UIControlStateHighlighted];
                                [self.muteBtn setImage:[UIImage volumeOn_slected_image] forState:UIControlStateSelected];
                                
                            }
                        }else {
//                            [self.muteBtn setImage:[UIImage mute_normal_image] forState:UIControlStateNormal];
//                            [self.muteBtn setImage:[UIImage mute_disabled_image] forState:UIControlStateDisabled];
                            if (WY_CameraM.babyMonitor) {
                                [self.muteBtn setImage:[UIImage mute_baby_slected_image] forState:UIControlStateHighlighted];
                                [self.muteBtn setImage:[UIImage mute_baby_slected_image] forState:UIControlStateSelected];

                            }else {
                                [self.muteBtn setImage:[UIImage mute_slected_image] forState:UIControlStateHighlighted];
                                [self.muteBtn setImage:[UIImage mute_slected_image] forState:UIControlStateSelected];
                                
                            }
                        }
                    }else {
                        if (self.muteBtn.isSelected) {
                            [self.muteBtn setImage:[UIImage volumeOn_disabled_image] forState:UIControlStateNormal];
                        }else {
                            [self.muteBtn setImage:[UIImage mute_disabled_image] forState:UIControlStateNormal];
                        }
                    }
                    break;
                }
                case WYVideoTypePlaybackNVR:
                case WYVideoTypePlaybackSDCard: {
                    if (self.muteBtn.selected) {
//                        [self.muteBtn setImage:[UIImage volumeOn_normal_image] forState:UIControlStateNormal];
//                        [self.muteBtn setImage:[UIImage volumeOn_disabled_image] forState:UIControlStateDisabled];
                        if (WY_CameraM.babyMonitor) {
                            [self.muteBtn setImage:[UIImage volumeOn_baby_slected_image] forState:UIControlStateHighlighted];
                            [self.muteBtn setImage:[UIImage volumeOn_baby_slected_image] forState:UIControlStateSelected];
                            
                        }else {
                            [self.muteBtn setImage:[UIImage volumeOn_slected_image] forState:UIControlStateHighlighted];
                            [self.muteBtn setImage:[UIImage volumeOn_slected_image] forState:UIControlStateSelected];
                            
                        }
                    }else {
//                        [self.muteBtn setImage:[UIImage mute_normal_image] forState:UIControlStateNormal];
//                        [self.muteBtn setImage:[UIImage mute_disabled_image] forState:UIControlStateDisabled];
                        if (WY_CameraM.babyMonitor) {
                            [self.muteBtn setImage:[UIImage mute_baby_slected_image] forState:UIControlStateHighlighted];
                            [self.muteBtn setImage:[UIImage mute_baby_slected_image] forState:UIControlStateSelected];
                            
                        }else {
                            [self.muteBtn setImage:[UIImage mute_slected_image] forState:UIControlStateHighlighted];
                            [self.muteBtn setImage:[UIImage mute_slected_image] forState:UIControlStateSelected];
                            
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
- (void)reset {
    [self setButton:WYCameraToolBarButtonTypeVoice selected:NO];
    [self setButton:WYCameraToolBarButtonTypeCalendar selected:NO];
    [self setButton:WYCameraToolBarButtonTypeSnapshot selected:NO];
    [self setButton:WYCameraToolBarButtonTypePlay selected:NO];
    [self setButton:WYCameraToolBarButtonTypeMusic selected:NO];
    [self setButton:WYCameraToolBarButtonTypeRecord selected:NO];
    [self setButton:WYCameraToolBarButtonTypeMute selected:NO];
}
- (void)hiddenButton:(WYCameraToolBarButtonType)buttonType hidden:(BOOL)hidden {
    UIButton *btn;
    switch (buttonType) {
        case WYCameraToolBarButtonTypeVoice: {
            if (self.previewed) {
                btn = self.voiceBtn;
            }
            break;
        }
        case WYCameraToolBarButtonTypeCalendar: {
            if (!self.previewed) {
                btn = self.voiceBtn;
            }
            break;
        }
        case WYCameraToolBarButtonTypeSnapshot: {
            btn = self.snapshotBtn;
            break;
        }
        case WYCameraToolBarButtonTypeMusic: {
            if (self.previewed) {
                btn = self.playBtn;
            }
            break;
        }
        case WYCameraToolBarButtonTypePlay: {
            if (!self.previewed) {
                btn = self.playBtn;
            }
            break;
        }
        case WYCameraToolBarButtonTypeMute: {
            if (self.previewed) {
                btn = self.muteBtn;
            }
            break;
        }
        case WYCameraToolBarButtonTypeRecord: {
            if (!self.previewed) {
                btn = self.recordBtn;
            }
            break;
        }
        default:
            break;
    }
    WY_WeakSelf
    NSInteger index = [self.buttons indexOfObject:btn];
    UIView *prevV, *nextV;
    if (index == 0) {
        prevV = weakSelf;
        nextV = self.buttons[1];
    }else if (index > 0 && index < self.buttons.count-1) {
        prevV = self.buttons[index - 1];
        nextV = self.buttons[index + 1];
    }else if (index == self.buttons.count - 1) {
        prevV = self.buttons[index - 1];
        nextV = weakSelf;
    }
    [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(prevV == weakSelf ? weakSelf : prevV.mas_trailing);
        make.trailing.equalTo(nextV == weakSelf ? weakSelf : nextV.mas_leading);
        if (hidden) {
            make.height.equalTo(@0);
            make.width.equalTo(@0);
        }else {
            make.width.equalTo(prevV == weakSelf ? nextV : prevV);
            make.height.equalTo(weakSelf);
        }
    }];
}

@end
