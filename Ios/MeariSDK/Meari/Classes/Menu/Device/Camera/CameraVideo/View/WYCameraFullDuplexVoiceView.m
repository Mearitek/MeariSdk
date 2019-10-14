//
//  WYCameraFullDuplexVoiceView.m
//  Meari
//
//  Created by FMG on 2017/11/24.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraFullDuplexVoiceView.h"
@interface WYCameraFullDuplexVoiceView ()
{
    NSInteger _hour;
    NSInteger _minute;
    NSInteger _second;
}
@property (nonatomic,   weak) UILabel *readyLabel;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic,   weak) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *voiceTimer;
@property (nonatomic,   weak) UIImageView *voiceAnimateView;
@end
static NSInteger voiceTimeNum = 0;
@implementation WYCameraFullDuplexVoiceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setLayout];
    }
    return self;
}
- (void)setLayout {
    NSInteger space = 12;
    NSInteger width = self.readyLabel.width + 25 + space;
    [self.readyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(@(-(WY_ScreenWidth - width)/2.0));
    }];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.readyLabel.mas_centerY);
        make.trailing.equalTo(self.readyLabel.mas_leading).with.offset(-space);
    }];
    [self.voiceAnimateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(WY_ScreenWidth, 32));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.voiceAnimateView.mas_top).offset(-15);
        make.centerX.equalTo(self);
    }];
}
#pragma mark - Public Action
- (void)prepareVoice {
    self.activityIndicator.hidden = NO;
    self.readyLabel.hidden = NO;
    [self.activityIndicator startAnimating];
}
- (void)startVoiceTalking {
    self.timeLabel.text = @"00:00";
    voiceTimeNum = 0;
    [self.activityIndicator stopAnimating];
    if (!_voiceTimer) {
        [self voiceTimer];
    }
    self.activityIndicator.hidden = YES;
    self.readyLabel.hidden = YES;
    self.timeLabel.hidden = NO;
    self.voiceAnimateView.hidden  = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_fullDuplex_voice" ofType:@"gif"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    [self.voiceAnimateView wy_setGIFImageWithURL:url];
}
- (void)stopVoiceTalking {
    self.activityIndicator.hidden = YES;
    self.readyLabel.hidden = YES;
    self.timeLabel.hidden = YES;
    self.voiceAnimateView.hidden  = YES;
    [self.voiceTimer invalidate];
    _voiceTimer = nil;
}

- (void)voiceTimerAction:(NSTimer *)timer {
    voiceTimeNum++;
    _hour = voiceTimeNum/(60*60);
    _minute = voiceTimeNum%(60*60)/60;
    _second = voiceTimeNum%(60*60)%60%60;
    if (_hour > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_hour,_minute,_second];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",_minute,_second];
    }
}


#pragma mark - lazyLoad
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.activityIndicator];
        self.activityIndicator.hidden = YES;
        self.activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}
- (UILabel *)readyLabel {
    if (!_readyLabel) {
        UILabel *lab = [UILabel new];
        lab.text = WYLocalString(@"Preparing");
        lab.textColor = WY_FontColor_Gray;
        [lab sizeToFit];
        lab.hidden = YES;
        self.readyLabel = lab;
        [self addSubview:lab];
    }
    return _readyLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *lab = [UILabel new];
        lab.hidden = YES;
        lab.textColor = WY_FontColor_Gray;
        self.timeLabel = lab;
        [self addSubview:lab];
    }
    return _timeLabel;
}
- (NSTimer *)voiceTimer {
    if (!_voiceTimer) {
        self.voiceTimer = [NSTimer timerInLoopWithInterval:1 target:self 
                                                  selector:@selector(voiceTimerAction:)];
    }
    return _voiceTimer;
}
- (UIImageView *)voiceAnimateView {
    if (!_voiceAnimateView) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_fullDuplex_voice" ofType:@"gif"];
        UIImageView *speakAnimation = [UIImageView new];
        speakAnimation.hidden = YES;
        self.voiceAnimateView = speakAnimation;
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        [speakAnimation wy_setGIFImageWithURL:url];
        [self addSubview:speakAnimation];
    }
    return _voiceAnimateView;
}

@end
