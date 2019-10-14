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
@property (nonatomic,   weak) UIButton *muteBtn;
@property (nonatomic,   weak) UIButton *hangupBtn;
@property (nonatomic,   weak) UIButton *speakBtn;
@property (nonatomic,   weak) UILabel *titleLabel;
@property (nonatomic,   weak) UIImageView *speakAnimationImgV;

@end

@implementation WYReceiveView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setInit];
        [self setLayout];
        
    }
    return self;
}
- (void)setLayout {
    [self.screenChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.trailing.equalTo(self).offset(-5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(WY_iPhone_4 ? 5 : 35));
    }];
   
    [self.speakAnimationImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(WY_iPhone_4 ? 10 : 70);
        make.size.mas_equalTo(CGSizeMake(35, 25));
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(WY_iPhone_4 ? 60 : 121);
        make.leading.equalTo(@0);
        make.width.equalTo(@((WY_ScreenWidth - 77)/2.0));
        make.height.equalTo(@70);
    }];
    [self.hangupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn);
        make.leading.equalTo(self.muteBtn.mas_trailing);
        make.width.equalTo(@77);
        make.height.equalTo(@77);
    }];
    [self.speakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn);
        make.trailing.equalTo(@0);
        make.width.equalTo(self.muteBtn.mas_width);
        make.height.equalTo(@70);
    }];
    
}

- (void)setCamera:(MeariDevice *)camera {
    _camera = camera;
    self.titleLabel.text = camera.info.nickname;
}

- (void)setInit {
    UIButton *screenChangeBtn = [UIButton new];
    [screenChangeBtn setImage:[UIImage imageNamed:@"btn_fullscreen"] forState:UIControlStateNormal];
    screenChangeBtn.hidden = YES;
    self.screenChangeBtn = screenChangeBtn;
    [screenChangeBtn addTarget:self action:@selector(screenChangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:screenChangeBtn];
    
    UILabel *title = [UILabel new];
    self.titleLabel = title;
    title.text = @"My House Doorbell";
    title.font = [UIFont systemFontOfSize:19];
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    
    UIImageView *speakAnimation = [UIImageView new];
    speakAnimation.hidden = YES;
    self.speakAnimationImgV = speakAnimation;
    [speakAnimation wy_setGIFImageWithURL:self.voiceGifURL];
    [self addSubview:speakAnimation];
    
    UIButton *muteBtn = [UIButton new];
    self.muteBtn = muteBtn;
    muteBtn.enabled = NO;
    [muteBtn setImage:[UIImage imageNamed:@"img_doorbell_visitor_mute_disabled"] forState:UIControlStateNormal];
    [muteBtn setImage:[UIImage imageNamed:@"img_doorbell_visitor_mute_normal"] forState:UIControlStateSelected];
    [muteBtn addTarget:self action:@selector(muteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:muteBtn];
    
    UIButton *hangupBtn = [UIButton new];
    self.hangupBtn = hangupBtn;
    [hangupBtn setImage:[UIImage imageNamed:@"img_doorbell_visitor_hangup"] forState:UIControlStateNormal];
    [hangupBtn addTarget:self action:@selector(hangupBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hangupBtn];
    
    UIButton *speakBtn = [UIButton new];
    self.speakBtn = speakBtn;
    speakBtn.enabled = NO;
    [speakBtn addTarget:self action:@selector(speakBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [speakBtn setImage:[UIImage imageNamed:@"img_doorbell_visitor_speak_normal"] forState:UIControlStateNormal];
    [speakBtn setImage:[UIImage imageNamed:@"img_doorbell_visitor_speak_disabled"] forState:UIControlStateSelected];
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
    [self.speakAnimationImgV wy_setGIFImageWithURL:self.voiceGifURL];
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

@end
