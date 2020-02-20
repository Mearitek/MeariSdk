//
//  WYVoiceCallView.m
//  Meari
//
//  Created by MJ2009 on 2018/7/9.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYVoiceCallView.h"

@interface WYVoiceCallView()
@property (nonatomic, strong) UIImageView *ringIV;
@property (nonatomic, strong) UILabel *deviceNameLB;
@property (nonatomic, strong) UILabel *statusLB;
@property (nonatomic, strong) UIButton *hangUpBtn;
@property (nonatomic, strong) UIButton *receiveBtn;

@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) YLImageView *animateIV;
@property (nonatomic, strong) UIButton *muteBtn;
@property (nonatomic, strong) UIButton *speakBtn;
@end

@implementation WYVoiceCallView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    [self addSubview:self.ringIV];
    [self.ringIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self).offset(-50);
        make.size.mas_equalTo(150);
    }];
    
    [self addSubview:self.deviceNameLB];
    [self.deviceNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.ringIV.mas_bottom).offset(60);
    }];
    self.deviceNameLB.text = self.camera.info.nickname;
    
    [self addSubview:self.statusLB];
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.deviceNameLB.mas_bottom).offset(8);
    }];
    self.statusLB.text = WYLocalString(@"message_voice_calling");
    
    [self addSubview:self.hangUpBtn];
    [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.bottom.mas_equalTo(-100);
        make.size.mas_equalTo(60);
    }];
    
    [self addSubview:self.receiveBtn];
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-70);
        make.centerY.mas_equalTo(self.hangUpBtn);
        make.size.mas_equalTo(self.hangUpBtn);
    }];
    
    //为接听界面做准备
    [self addSubview:self.timeLB];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.deviceNameLB.mas_bottom).offset(60);
    }];
    self.timeLB.text = @"";
    
    [self addSubview:self.animateIV];
    [self.animateIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.timeLB.mas_bottom).offset(5);
        make.size.mas_equalTo(0);
    }];
    
    [self addSubview:self.muteBtn];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_left);
        make.centerY.mas_equalTo(self.hangUpBtn);
        make.size.mas_equalTo(0);
    }];
    
    [self addSubview:self.speakBtn];
    [self.speakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.hangUpBtn);
        make.size.mas_equalTo(self.muteBtn);
    }];
}

- (void)layoutForReceive {
    [self.deviceNameLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ringIV.mas_bottom).offset(40);
    }];
    
    self.statusLB.hidden = YES;
    
    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.deviceNameLB.mas_bottom).offset(60);
    }];
    self.timeLB.text = @"0:03";
    
    [self.animateIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.timeLB.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    self.receiveBtn.hidden = YES;
    
    [self.hangUpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-100);
        make.size.mas_equalTo(60);
    }];
    
    [self.muteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.centerY.mas_equalTo(self.hangUpBtn);
        make.size.mas_equalTo(50);
    }];
    
    [self.speakBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-70);
        make.centerY.mas_equalTo(self.hangUpBtn);
        make.size.mas_equalTo(self.muteBtn);
    }];
    
}

#pragma mark - Action
- (void)hangUpBtnClicked:(UIButton *)btn {
    if (self.hangUp) {
        self.hangUp();
    }
}

- (void)receiveBtnClicked:(UIButton *)btn {
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutForReceive];
        [self layoutIfNeeded];
    }];
    if (self.receive) {
        self.receive();
    }
}

- (void)muteBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.mute) {
        self.mute(btn.selected);
    }
}

- (void)speakBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.speak) {
        self.speak(btn.selected);
    }
}

#pragma mark - Getter
- (UIImageView *)ringIV {
    if (!_ringIV) {
        _ringIV = [UIImageView new];
        _ringIV.image = [UIImage imageNamed:@"voiceCallRing"];
    }
    return _ringIV;
}

- (UILabel *)deviceNameLB {
    if (!_deviceNameLB) {
        _deviceNameLB = [UILabel new];
        _deviceNameLB.textColor = [UIColor whiteColor];
    }
    return _deviceNameLB;
}

- (UILabel *)statusLB {
    if (!_statusLB) {
        _statusLB = [UILabel new];
        _statusLB.textColor = [UIColor whiteColor];
    }
    return _statusLB;
}

- (UIButton *)hangUpBtn {
    if (!_hangUpBtn) {
        _hangUpBtn = [UIButton new];
        _hangUpBtn.wy_normalImage = [UIImage imageNamed:@"voiceCallHangUp"];
        [_hangUpBtn addTarget:self action:@selector(hangUpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hangUpBtn;
}

- (UIButton *)receiveBtn {
    if (!_receiveBtn) {
        _receiveBtn = [UIButton new];
        _receiveBtn.wy_normalImage = [UIImage imageNamed:@"voiceCallReceive"];
        [_receiveBtn addTarget:self action:@selector(receiveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [UILabel new];
        _timeLB.textColor = [UIColor whiteColor];
    }
    return _timeLB;
}

- (YLImageView *)animateIV {
    if (!_animateIV) {
        _animateIV = [YLImageView new];
        _animateIV.image = [YLGIFImage imageNamed:@"voiceCallAnimate.gif"];
    }
    return _animateIV;
}

- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = [UIButton new];
        _muteBtn.wy_normalImage = [UIImage imageNamed:@"voiceCallMute"];
        _muteBtn.wy_selectedImage = [UIImage imageNamed:@"voiceCallMuteDisable"];
        [_muteBtn addTarget:self action:@selector(muteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}

- (UIButton *)speakBtn {
    if (!_speakBtn) {
        _speakBtn = [UIButton new];
        _speakBtn.wy_normalImage = [UIImage imageNamed:@"voiceCallSpeak"];
        _speakBtn.wy_selectedImage = [UIImage imageNamed:@"voiceCallSpeakDisable"];
        [_speakBtn addTarget:self action:@selector(speakBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speakBtn;
}

@end
