//
//  WYCameraToolView.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraToolView.h"

@interface WYCameraToolView ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, assign) MeariDeviceSubType deviceType;


@end

@implementation WYCameraToolView

#pragma mark - Private
#pragma mark -- Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectZero];
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.pagingEnabled = YES;
        view.bounces = NO;
        view.clipsToBounds = NO;
        view.delegate = self;
        [self addSubview:view];
        _scrollView = view;
    }
    return _scrollView;
}
- (WYCameraToolPreviewView *)previewView {
    if (!_previewView) {
        WYCameraToolPreviewView *view = [[WYCameraToolPreviewView alloc] initWithDeviceType:self.deviceType];
        [self.scrollView addSubview:view];
        _previewView = view;
    }
    return _previewView;
}
- (WYCameraToolPlaybackView *)playbackView {
    if (!_playbackView) {
        WYCameraToolPlaybackView *view = [[WYCameraToolPlaybackView alloc] initWithDeviceType:self.deviceType];
        [self.scrollView addSubview:view];
        _playbackView = view;
    }
    return _playbackView;
}


#pragma mark -- Init
- (void)initLayout {
    WY_WeakSelf
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.leading.equalTo(weakSelf.scrollView);
        make.width.height.equalTo(weakSelf.scrollView);
    }];
    [self.playbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.trailing.equalTo(weakSelf.scrollView);
        make.width.height.equalTo(weakSelf.scrollView);
        make.leading.equalTo(weakSelf.previewView.mas_trailing);
    }];
}

#pragma mark -- Utilities
#pragma mark -- Life
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.scrollView setContentOffsetX:self.previewed ? 0 : self.scrollView.width animated:YES];
}

#pragma mark -- Action

#pragma mark - Delegate
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffsetX == scrollView.width) {
        _videoType = WYVideoTypePlaybackSDCard;
    }else {
        _videoType = WYVideoTypePreviewHD;
    }
    if ([self.delegate respondsToSelector:@selector(WYCameraToolView:didScrolledType:)]) {
        [self.delegate WYCameraToolView:self didScrolledType:_videoType];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat progress = scrollView.contentOffsetX/scrollView.width;
    if ([self.delegate respondsToSelector:@selector(WYCameraToolView:didScrolledProgress:)]) {
        [self.delegate WYCameraToolView:self didScrolledProgress:progress];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.previewView.hidden = NO;
}

#pragma mark - Public
- (instancetype)initWithVideoType:(WYVideoType)videoType deviceType:(MeariDeviceSubType)deviceType {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.deviceType = deviceType;
        [self initLayout];
        self.videoType = videoType;
    }
    return self;
}
- (void)setVideoType:(WYVideoType)videoType {
    if (_videoType == videoType) return;
    _videoType = videoType;
    switch (_videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD: {
            [self.scrollView setContentOffsetX:0 animated:YES];
            break;
        }
        case WYVideoTypePlaybackNVR:
        case WYVideoTypePlaybackSDCard:{
            [self.scrollView setContentOffsetX:self.scrollView.width animated:YES];
            break;
        }
        default:
            break;
    }
}
- (BOOL)previewed {
    return self.videoType == WYVideoTypePreviewSD || self.videoType == WYVideoTypePreviewHD;
}
- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.previewView.delegate = delegate;
}
- (void)setSettingHidden:(BOOL)hidden {
    [self.previewView setSettingHidden:hidden];
}


@end
