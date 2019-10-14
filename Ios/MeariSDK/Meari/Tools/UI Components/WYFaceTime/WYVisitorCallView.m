//
//  WYVisitorCallView.m
//  Meari
//
//  Created by FMG on 2017/8/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYVisitorCallView.h"

@interface WYVisitorCallView ()
@property (nonatomic, strong) UIImageView *visitorAvatar;
@property (nonatomic,   weak) UILabel *titleLabel;
@property (nonatomic,   weak) UIButton *refuseBtn;
@property (nonatomic,   weak) UIButton *receiveBtn;
@property (nonatomic,   weak) UILabel  *desLabel;
@property (nonatomic, assign) BOOL receiveActionFirst;

@end

@implementation WYVisitorCallView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setLayout];
    }
    return self;
}
- (void)setLayout {
    [self.visitorAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(WY_iPhone_4 ? 85 : 150));
        make.leading.equalTo(@(WY_iPhone_4 ? 60 : 90));
        make.size.mas_equalTo(CGSizeMake(WY_ScreenWidth - (WY_iPhone_4 ? 120 : 180), WY_ScreenWidth - (WY_iPhone_4 ? 120 : 180)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.visitorAvatar.mas_bottom).offset(WY_iPhone_4 ? 25 :49);
        make.centerX.equalTo(self);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    
    NSInteger space = (WY_ScreenWidth - 184) * 1.0/4;
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(space));
        make.top.equalTo(self.desLabel.mas_bottom).offset(WY_iPhone_4 ? 15 : 25);
        make.size.mas_equalTo(CGSizeMake(92, 92));
    }];
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-space));
        make.top.equalTo(self.refuseBtn);
        make.size.mas_equalTo(CGSizeMake(92, 92));
    }];

}

- (void)setCamera:(MeariDevice *)camera {
    _camera = camera;
    self.titleLabel.text = camera.info.nickname;
    self.receiveActionFirst = NO;
}
- (void)setVisitorImg:(NSString *)visitorImg {
    _visitorImg = visitorImg;
    [self.visitorAvatar sd_setImageWithURL:[NSURL URLWithString:visitorImg] placeholderImage:[UIImage imageNamed:@"img_doorbell_visitorCall_placeholder"]];
    self.visitorAvatar.contentMode = UIViewContentModeScaleAspectFill;
}
#pragma mark - Action
- (void)cancelBtnAction:(UIButton *)sender {
    if (self.receiveActionFirst) {
        return;
    }
    if (self.refuseCall) {
        self.refuseCall();
    }
}
- (void)receiveAction {
    self.receiveActionFirst = YES;
    [UIView animateWithDuration:.5 animations:^{
        int tx = self.visitorAvatar.transform.tx  - (WY_iPhone_4 ? 60 :  90);
        int ty = self.visitorAvatar.transform.ty + (WY_iPhone_4 ? 35 :  -47);;
        self.visitorAvatar.transform = CGAffineTransformMakeTranslation(tx, ty);
        self.visitorAvatar.size = CGSizeMake(WY_ScreenWidth, WY_ScreenWidth * 9/16.0);
    } completion:^(BOOL finished) {
        if (self.receiveCall) {
            self.receiveCall();
        }
    }];
}

#pragma mark - lazyLoad
- (UIImageView *)visitorAvatar {
    if (!_visitorAvatar) {
        _visitorAvatar = [[UIImageView alloc] init];
        _visitorAvatar.layer.cornerRadius = 10;
        _visitorAvatar.layer.masksToBounds = YES;
        [self addSubview:_visitorAvatar];
    }
    return _visitorAvatar;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *title = [UILabel new];
        self.titleLabel = title;
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:25];
        [self addSubview:title];
    }
    return _titleLabel;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        UILabel *title = [UILabel new];
        self.desLabel = title;
        title.text = WYLocalString(@"des_visitorCall");
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:22];
        [self addSubview:title];
    }
    return _desLabel;
}
- (UIButton *)refuseBtn {
    if (!_refuseBtn) {
        UIButton *btn = [[UIButton alloc] init];
        _refuseBtn = btn;
        [btn setExclusiveTouch:YES];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
        [btn setBackgroundImage:[UIImage imageNamed:@"img_btn_call_refuse"] forState:UIControlStateNormal];
        [btn setTitle:WYLocalString(@"Decline") forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return _refuseBtn;
}
- (UIButton *)receiveBtn {
    if (!_receiveBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setExclusiveTouch:YES];
        _receiveBtn = btn;
        [btn setBackgroundImage:[UIImage imageNamed:@"img_btn_call_receive"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:WYLocalString(@"Accept") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(receiveAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return _receiveBtn;
}


@end
