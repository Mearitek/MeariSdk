//
//  WYCameraToolPlaybackView.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraToolPlaybackView.h"

@interface WYCameraToolPlaybackView ()<WYCameraToolPlaybackTimeBarViewDelegate, WYCameraToolPlaybackAlarmMessageViewDelegate>
@property (nonatomic, assign) MeariDeviceSubType deviceType;
@property (nonatomic,   weak) UILabel *tipsLabel;

@end

@implementation WYCameraToolPlaybackView
#pragma mark - Private
#pragma mark -- Getter
- (WYCameraToolPlaybackTimeBarView *)timeBarView {
    if (!_timeBarView) {
        WYCameraToolPlaybackTimeBarView *view = [[WYCameraToolPlaybackTimeBarView alloc] init];
        view.backgroundColor = WY_BGColor_LightGray;
        view.delegate = self;
        [self addSubview:view];
        _timeBarView = view;
    }
    return _timeBarView;
}
- (WYCameraToolPlaybackPictureBarView *)pictureBarView {
    if (!_pictureBarView) {
        WYCameraToolPlaybackPictureBarView *view = [[WYCameraToolPlaybackPictureBarView alloc] init];
        view.backgroundColor = WY_BGColor_LightGray;
//        view.delegate = self;
        [self addSubview:view];
        _pictureBarView = view;
    }
    return _pictureBarView;
}
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *lab = [UILabel new];
        _tipsLabel = lab;
        lab.text = WYLocalString(@"报警消息");
        lab.font = WYFont_Text_S_Normal;
        lab.textColor = WY_FontColor_Gray;
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
    }
    return _tipsLabel;
}
- (WYCameraToolPlaybackAlarmMessageView *)alarmMsgView {
    if (!_alarmMsgView) {
        WYCameraToolPlaybackAlarmMessageView *view = [[WYCameraToolPlaybackAlarmMessageView alloc] init];
        view.delegate = self;
        [self addSubview:view];
        _alarmMsgView = view;
    }
    return _alarmMsgView;
}

#pragma mark -- Init
- (void)initLayout {
    WY_WeakSelf
    [self.timeBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf);
        make.height.equalTo(@(WY_iPhone_4 ? 82 : 92)).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.alarmMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeBarView.mas_bottom);
        make.leading.and.trailing.equalTo(weakSelf);
        make.height.equalTo(@(WY_iPhone_4 ? 45 : 75)).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
}
- (void)initPictureBarLayout {
    WY_WeakSelf
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf);
        make.height.equalTo(@30);
    }];
    [self.pictureBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tipsLabel.mas_bottom);
        make.leading.and.trailing.equalTo(weakSelf);
        make.height.equalTo(@(WY_iPhone_4 ? 82 : 130)).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
}

- (instancetype)initWithDeviceType:(MeariDeviceSubType)deviceType {
    if (self = [super init]) {
        self.deviceType = deviceType;
        [self setInit];
    }
    return self;
}

#pragma mark -- Life
- (void)setInit {
    if (self.deviceType == MeariDeviceSubTypeIpcBell) {
        [self initPictureBarLayout];
    } else {
        self.timeBarView.alarmView = self.alarmMsgView;
        [self initLayout];
    }
}

#pragma mark - Public
- (void)resetToNormal {
    [self.timeBarView resetToNormal];
    [self.alarmMsgView resetToNormal];
}

@end
