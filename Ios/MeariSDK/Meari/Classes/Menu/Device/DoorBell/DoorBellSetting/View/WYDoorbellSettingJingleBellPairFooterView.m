//
//  WYDoorbellSettingJingleBellPairFooterView.m
//  Meari
//
//  Created by FMG on 2017/11/6.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorbellSettingJingleBellPairFooterView.h"

static const CGFloat PairingTimerTime = 10.0f;
@interface WYDoorbellSettingJingleBellPairFooterView ()
{
    NSInteger _currentTime;
}
@property (nonatomic,   weak) UIButton *pairingBtn;
@property (nonatomic,   weak) UIButton *unbindBtn;
@property (nonatomic,   weak) WYProgressCircleView *timerView;
@property (nonatomic, strong) NSTimer *pariringTimer;

@end

@implementation WYDoorbellSettingJingleBellPairFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setLayout];
    }
    return self;
}
- (void)setLayout {
    CGFloat btnHeight = 40;
    [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.pairingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@94);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.equalTo(@(btnHeight));
    }];
    [self.unbindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.pairingBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(self).multipliedBy(0.6);
        make.height.equalTo(@(btnHeight));
    }];
}
- (void)startPairing {
    [self setPairingTimerOpen:YES];
    self.timerView.hidden = NO;
    self.unbindBtn.hidden = YES;
    _currentTime = 0;
    self.timerView.progress = _currentTime/PairingTimerTime;
    self.timerView.text = [NSString stringWithFormat:@"%@s",@(PairingTimerTime-_currentTime).stringValue];
}
- (void)successdPairing {
    [self setPairingTimerOpen:NO];
    self.timerView.hidden = YES;
    [self.pairingBtn setTitle:WYLocalString(@"status_success_pairing") forState:UIControlStateNormal];
    [self.pairingBtn removeTarget:self action:@selector(startPairing:) forControlEvents:UIControlEventTouchUpInside];
    [self.pairingBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
}
- (void)failuredPairing {
    [self setPairingTimerOpen:NO];
    WY_HUD_SHOW_TOAST(WYLocalString(@"fail_pairing"));
    self.timerView.hidden = YES;
    [self.pairingBtn setTitle:WYLocalString(@"Retry") forState:UIControlStateNormal];
    [self.pairingBtn addTarget:self action:@selector(startPairing:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)reset {
    self.timerView.hidden = YES;
    self.unbindBtn.hidden = NO;
    self.unbindBtn.alpha = 0;
    self.pairingBtn.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        [self.pairingBtn setTitle:WYLocalString(@"Start pairing") forState:UIControlStateNormal];
        self.pairingBtn.alpha = 1;
        self.unbindBtn.alpha = 1;
    } completion:^(BOOL finished) {
        [self.pairingBtn removeTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [self.pairingBtn addTarget:self action:@selector(startPairing:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
}
- (void)setPairingTimerOpen:(BOOL)open {
    if (open) {
        if (!_pariringTimer) {
            [self pariringTimer];
        }
    } else {
        if (_pariringTimer) {
            [_pariringTimer invalidate];
            _pariringTimer = nil;
        }
    }
}
#pragma mark - Action
- (void)startPairing:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(doorbellSettingJingleBellPairFooterView:didClickPairButton:)]) {
        [self.delegate doorbellSettingJingleBellPairFooterView:self didClickPairButton:btn];
    }
}
- (void)timerToPairing {
    if (!_currentTime) {
        [self.pairingBtn setTitle:WYLocalString(@"status_pairing") forState:UIControlStateNormal];
        [self.pairingBtn removeTarget:self action:@selector(startPairing:) forControlEvents:UIControlEventTouchUpInside];
    }
    _currentTime++;
    self.timerView.progress = _currentTime/PairingTimerTime;
    self.timerView.text = [NSString stringWithFormat:@"%@s",@(PairingTimerTime-_currentTime).stringValue];
    if (_currentTime >= PairingTimerTime) {
        if (self.timeout) {
            self.timeout();
        }
        [self failuredPairing];
    }
}
- (void)unbindAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(doorbellSettingJingleBellPairFooterView:didClickUnbindButton:)]) {
        [self.delegate doorbellSettingJingleBellPairFooterView:self didClickUnbindButton:btn];
    }
}

#pragma mark - lazyLoad
- (UIButton *)pairingBtn {
    if (!_pairingBtn) {
        UIButton *btn = [UIButton defaultGreenBounderButtonWithTarget:self action:@selector(startPairing:)];
        _pairingBtn = btn;
        [btn setTitle:WYLocalString(@"Start pairing") forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage bgGreenImage] forState:UIControlStateNormal];
        [btn setBackgroundImage:nil forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [self addSubview:btn];
    }
   return  _pairingBtn;
}
- (UIButton *)unbindBtn {
    if (!_unbindBtn) {
        UIButton *btn = [UIButton defaultGreenBounderButtonWithTarget:self action:@selector(unbindAction:)];
        _unbindBtn = btn;
        [btn setTitle:WYLocalString(@"Unbind") forState:UIControlStateNormal];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [self addSubview:btn];
    }
    return  _unbindBtn;
}
- (WYProgressCircleView *)timerView {
    if (!_timerView) {
        WYProgressCircleView *view = [WYProgressCircleView new];
        view.hidden = YES;
        view.textFont = WYFont_Text_XS_Normal;
        view.textColor = WY_FontColor_Cyan;
        view.backgroundCircleColor = WY_FontColor_Cyan;
        view.progressCircleColor = WY_BGColor_LightGray3;
        _timerView = view;
        [self addSubview:view];
    }
    return _timerView;
}
- (NSTimer *)pariringTimer {
    if (!_pariringTimer) {
        _pariringTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToPairing)];
    }
    return _pariringTimer;
}

@end
