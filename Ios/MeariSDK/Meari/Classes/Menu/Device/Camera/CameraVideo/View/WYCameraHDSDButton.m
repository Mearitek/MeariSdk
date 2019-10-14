//
//  WYCameraHDSDButton.m
//  Meari
//
//  Created by 李兵 on 2016/12/1.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraHDSDButton.h"

@interface WYCameraHDSDButton ()
@property (nonatomic, weak)FXBlurView *blurView;
@property (nonatomic, weak)UIButton *hdBtn;
@property (nonatomic, weak)UIButton *sdBtn;
@property (nonatomic, weak)id target;
@property (nonatomic, copy)NSString *touchAction;
@end

@implementation WYCameraHDSDButton
- (FXBlurView *)blurView {
    if (!_blurView) {
        FXBlurView *view = [FXBlurView whiteBlurView];
//        [self addSubview:view];
        _blurView = view;
    }
    return _blurView;
}
- (UIButton *)hdBtn {
    if (!_hdBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:WYLocalString(@"HD") forState:UIControlStateNormal];
        [btn setTitleColor:WY_FontColor_Cyan forState:UIControlStateNormal];
        [btn setTitleColor:WY_FontColor_Cyan forState:UIControlStateHighlighted];
        btn.titleLabel.font = WYFont_Text_M_Normal;
        [self addSubview:btn];
        _hdBtn = btn;
    }
    return _hdBtn;
}
- (UIButton *)sdBtn {
    if (!_sdBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:WYLocalString(@"SD") forState:UIControlStateNormal];
        [btn setTitleColor:WY_FontColor_Cyan forState:UIControlStateNormal];
        [btn setTitleColor:WY_FontColor_Cyan forState:UIControlStateHighlighted];
        btn.titleLabel.font = WYFont_Text_M_Normal;
        [self addSubview:btn];
        _sdBtn = btn;
    }
    return _sdBtn;
}
- (void)initLayout {
    WY_WeakSelf
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.hdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.sdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}

- (instancetype)initWithTarget:(id)target hdAction:(SEL)hdaction sdAction:(SEL)sdAction {
    self = [super init];
    if (self) {
        self.backgroundColor = WY_BGColor_White_A;
        [self.hdBtn addTarget:target action:hdaction forControlEvents:UIControlEventTouchUpInside];
        [self.sdBtn addTarget:target action:sdAction forControlEvents:UIControlEventTouchUpInside];
        [self initLayout];
        self.hdFlag = YES;
    }
    return self;
}
- (instancetype)initWithTarget:(id)target hdAction:(SEL)hdaction sdAction:(SEL)sdAction touchAction:(SEL)touchAction {
    self = [super init];
    if (self) {
        self.backgroundColor = WY_BGColor_White_A;
        [self.hdBtn addTarget:target action:hdaction forControlEvents:UIControlEventTouchUpInside];
        [self.sdBtn addTarget:target action:sdAction forControlEvents:UIControlEventTouchUpInside];
        [self initLayout];
        self.hdFlag = YES;
        self.target = target;
        self.touchAction = NSStringFromSelector(touchAction);
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.touchAction && [self.target canPerformAction:NSSelectorFromString(self.touchAction) withSender:nil]) {
        [self.target performSelector:NSSelectorFromString(self.touchAction)];
    }
}
- (void)setHdFlag:(BOOL)hdFlag {
    _hdFlag = hdFlag;
    if (_hdFlag) {
        self.hdBtn.hidden = NO;
        self.sdBtn.hidden = YES;
    }else {
        self.hdBtn.hidden = YES;
        self.sdBtn.hidden = NO;
    }
}
- (void)setTitleColor:(UIColor *)color {
    [self.sdBtn setTitleColor:color forState:UIControlStateNormal];
    [self.sdBtn setTitleColor:color forState:UIControlStateHighlighted];
    [self.hdBtn setTitleColor:color forState:UIControlStateNormal];
    [self.hdBtn setTitleColor:color forState:UIControlStateHighlighted];
    
}
- (void)setHdsdEnabled:(BOOL)hdsdEnabled {
    self.hdBtn.enabled = hdsdEnabled;
}
@end
