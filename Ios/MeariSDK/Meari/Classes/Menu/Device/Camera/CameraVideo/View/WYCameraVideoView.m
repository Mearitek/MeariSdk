//
//  WYCameraVideoView.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraVideoView.h"
#import "WYCameraLoadingView.h"
#import "WYCameraToolBar.h"
#import "WYBabyMonitorMusicToolBar.h"

@interface WYCameraVideoControlView : WYBaseView
@property (nonatomic, weak)id delegate;
@end
@implementation WYCameraVideoControlView
- (void)initAction {
    [self addSwipeGesture:UISwipeGestureRecognizerDirectionUp target:self action:@selector(swipeAction:)];
    [self addSwipeGesture:UISwipeGestureRecognizerDirectionDown target:self action:@selector(swipeAction:)];
    [self addSwipeGesture:UISwipeGestureRecognizerDirectionLeft target:self action:@selector(swipeAction:)];
    [self addSwipeGesture:UISwipeGestureRecognizerDirectionRight target:self action:@selector(swipeAction:)];
}
- (void)swipeAction:(UISwipeGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraVideoView:swipe:)]) {
        [self.delegate WYCameraVideoView:(WYCameraVideoView *)self.superview.superview swipe:sender];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(WYCameraVideoViewSwipeDidEnded:)]) {
        [self.delegate WYCameraVideoViewSwipeDidEnded:(WYCameraVideoView *)self.superview.superview];
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self touchesEnded:touches withEvent:event];
}
@end

@interface WYCameraVideoView ()<UIScrollViewDelegate, WYCameraLoadingViewDelegate>
{
    BOOL _fadeIn;
    CGFloat _recordAlpha;
    BOOL _babyMonitor;
}
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)WYCameraVideoControlView *controlView;
@property (nonatomic, weak)WYCameraLoadingView *loadingView;
@property (nonatomic, weak)UIButton *fullScreenBtn;
@property (nonatomic, weak)UIButton *bitStreamBtn;
@property (nonatomic, weak)UIButton *backBtn;
@property (nonatomic, weak)UIImageView *recordImageView;
@property (nonatomic, weak)UILabel *recordLabel;

@property (nonatomic, weak)UIImageView *topShadowImageView;
@property (nonatomic, weak)UIImageView *bottomShadowImageView;

@property (nonatomic, assign, getter=isLandscaped)BOOL landscaped;

@property (nonatomic, strong)NSTimer *autoHideTimer;
@property (nonatomic, strong)NSTimer *recordTimer;

@end

@implementation WYCameraVideoView
#pragma mark -- Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *view = [UIScrollView new];
        view.showsHorizontalScrollIndicator = NO;
        view.showsVerticalScrollIndicator = NO;
        view.bounces = NO;
        view.maximumZoomScale = 5;
        view.minimumZoomScale = 1;
        view.delegate = self;
        [self addSubview:view];
        _scrollView = view;
    }
    return _scrollView;
}
- (MeariPlayView *)drawableView {
    if (!_drawableView) {
        MeariPlayView *view = [[MeariPlayView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, WY_ScreenWidth*9/16)];
        [self.scrollView addSubview:view];
        _drawableView = view;
    }
    return _drawableView;
}
- (WYCameraVideoControlView *)controlView {
    if (!_controlView) {
        WYCameraVideoControlView *v = [WYCameraVideoControlView new];
        [self.scrollView insertSubview:v aboveSubview:_drawableView];
        _controlView = v;
    }
    return _controlView;
}
- (WYCameraLoadingView *)loadingView {
    if (!_loadingView) {
        WYCameraLoadingView *view = [WYCameraLoadingView new];
        view.delegate = self;
        if (_babyMonitor) {
            view.loadingImage = [UIImage loadingOrangeImage];
        }
        [self addSubview:view];
        _loadingView = view;
    }
    return _loadingView;
}
- (WYCameraBitStreamView *)bitStreamView {
    if (!_bitStreamView) {
        WYCameraBitStreamView *view = [WYCameraBitStreamView instanceBitStreamView];
        view.hidden = YES;
        [self addSubview:view];
        _bitStreamView = view;
    }
    return _bitStreamView;
}
- (UIImageView *)topShadowImageView {
    if (!_topShadowImageView) {
        UIImageView *imgView = [UIImageView new];
        _topShadowImageView = imgView;
        imgView.userInteractionEnabled = YES;
        imgView.hidden = YES;
        imgView.image = [UIImage imageNamed:@"img_camera_shadow_top"];
        [self addSubview:imgView];
    }
    return _topShadowImageView;
}
- (UIImageView *)bottomShadowImageView {
    if (!_bottomShadowImageView) {
        UIImageView *imgView = [UIImageView new];
        imgView.userInteractionEnabled = YES;
        imgView.alpha = 0;
        _bottomShadowImageView = imgView;
        imgView.image = [UIImage imageNamed:@"img_camera_shadow_bottom"];
        [self addSubview:imgView];
    }
    return _bottomShadowImageView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        UIButton *btn = [UIButton wy_button];
        btn.wy_normalImage = [UIImage imageNamed:@"btn_back"];
        [btn wy_addTarget:self actionUpInside:@selector(backAction:)];
        [self.topShadowImageView addSubview:btn];
        _backBtn = btn;
    }
    return _backBtn;
}
- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        UIButton *btn = [UIButton wy_button];
        btn.wy_normalImage = [UIImage imageNamed:@"btn_fullscreen"];
        btn.wy_highlightedBGImage = [UIImage imageNamed:@"btn_fullscreen_bg"];
        [btn wy_addTarget:self actionUpInside:@selector(fullScreenAction:)];
        [self.bottomShadowImageView addSubview:btn];
        _fullScreenBtn = btn;
    }
    return _fullScreenBtn;
}
- (UIButton *)bitStreamBtn {
    if (!_bitStreamBtn) {
        UIButton *btn = [UIButton wy_button];
        btn.alpha = 0;
        [btn wy_addTarget:self actionUpInside:@selector(bitStreamAction:)];
        [self.bottomShadowImageView addSubview:btn];
        self.bitStreamBtn = btn;
    }
    return _bitStreamBtn;
}

- (UILabel *)recordLabel {
    if (!_recordLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:WYLocalString(@"REC")
                                       textColor:[UIColor whiteColor]
                                        textfont:WYFont_Text_M_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByTruncatingTail
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:YES];
        [self addSubview:label];
        _recordLabel = label;
    }
    return _recordLabel;
}
- (UIImageView *)recordImageView {
    if (!_recordImageView) {
        UIImageView *imageV = [UIImageView new];
        imageV.image = [UIImage imageNamed:@"img_camera_recordDot"];
        [self addSubview:imageV];
        _recordImageView = imageV;
    }
    return _recordImageView;
}

- (NSTimer *)autoHideTimer {
    if (!_autoHideTimer) {
        _autoHideTimer = [NSTimer timerInLoopWithInterval:2 target:self selector:@selector(timerToAutoHide:)];
    }
    return _autoHideTimer;
}

- (NSTimer *)recordTimer {
    if (!_recordTimer) {
        _recordTimer = [NSTimer timerInLoopWithInterval:0.015 target:self selector:@selector(timerToRecord:)];
    }
    return _recordTimer;
}

#pragma mark -- Setter
- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    if (_fullScreen) {
        [UIDevice wy_forceOrientationLandscapeLeft];
    }else {
        [UIDevice wy_forceOrientationPortrait];
    }
}

#pragma mark -- Init
- (void)initSet {
    _babyMonitor = WY_CameraM.babyMonitor;
    self.backgroundColor = [UIColor blackColor];
    self.recordLabel.hidden = YES;
    self.recordImageView.hidden = YES;
    self.backBtn.hidden = YES;
    self.landscaped = NO;
    [self.bottomShadowImageView addSubview:self.toolBar];
    [self tapVideoAction:nil];
}
- (void)initLayout {
    WY_WeakSelf
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.drawableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.scrollView);
        make.center.equalTo(weakSelf.scrollView);
        make.height.equalTo(weakSelf.drawableView.mas_width).multipliedBy(9.0/16);
    }];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.drawableView);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.recordLabel.size);
        make.trailing.equalTo(weakSelf).with.offset(-20);
        make.bottom.equalTo(weakSelf.drawableView).with.offset(-20);
    }];
    [self.recordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.trailing.equalTo(weakSelf.recordLabel.mas_leading).with.offset(-10);
        make.centerY.equalTo(weakSelf.recordLabel);
    }];
    [self.topShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.drawableView);
        make.height.equalTo(weakSelf.drawableView.mas_height).multipliedBy(1/2.5);
        
    }];
    [self.bottomShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(weakSelf.drawableView.mas_height).multipliedBy(1/2.5);
    }];
    [self.bitStreamView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(weakSelf);
    }];
    [self remakeConstraints];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.leading.equalTo(weakSelf).offset(10);
        make.top.equalTo(weakSelf).offset(10);
    }];
}

- (void)remakeConstraints {
    WY_WeakSelf
    [self.fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        if (weakSelf.landscaped) {
            make.trailing.equalTo(weakSelf).offset(-5);
            make.centerY.equalTo(weakSelf.toolBar.mas_centerY);
        } else {
            make.trailing.equalTo(weakSelf).offset(-5);
            make.bottom.equalTo(weakSelf).offset(-5);
        }
    }];
    [self.bitStreamBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.fullScreenBtn);
        make.centerY.equalTo(weakSelf.fullScreenBtn.mas_centerY);
        if (self.landscaped) {
            make.leading.equalTo(weakSelf.toolBar.mas_trailing);
        } else {
            make.trailing.equalTo(weakSelf.fullScreenBtn.mas_leading).offset(-5);
        }
    }];
}

- (void)initGestures {
    //tap
    [self addTapGestureTarget:self action:@selector(tapVideoAction:)];
}
- (void)removeGestures {
    for (UIGestureRecognizer *gest in self.gestureRecognizers) {
        [self removeGestureRecognizer:gest];
    }
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
    [self initGestures];
    [self initNotification];
    [self bringSubviewToFront:self.fullScreenBtn];
    [self bringSubviewToFront:self.backBtn];
}
- (void)deallocAction {
    [self removeNotification];
}

#pragma mark -- Notification
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(orientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
- (void)removeNotification {
    [WY_NotificationCenter removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
- (void)orientationDidChange:(NSNotification *)sender {
    switch (WY_Application.statusBarOrientation) {
            case UIInterfaceOrientationPortrait: {
                [self dealOrientationPortrait];
                break;
            }
            case UIInterfaceOrientationLandscapeLeft: {
                if (WY_ContainOption(self.viewController.supportedInterfaceOrientations, UIInterfaceOrientationMaskLandscapeLeft)) {
                    [self dealOrientationLandscape];
                }
                break;
            }
            case UIInterfaceOrientationLandscapeRight:{
                if (WY_ContainOption(self.viewController.supportedInterfaceOrientations, UIInterfaceOrientationMaskLandscapeRight)) {
                    [self dealOrientationLandscape];
                }
                break;
            }
            default: {
                break;
            }
    }
}
- (void)dealOrientationLandscape {
    if (self.isLandscaped) return;
    self.landscaped = YES;
    [self remakeConstraints];
    self.backBtn.hidden = NO;
    [self show];
}
- (void)dealOrientationPortrait {
    self.landscaped = NO;
    self.fullScreenBtn.hidden = NO;
    [self remakeConstraints];
    self.bitStreamBtn.hidden = NO;
    self.backBtn.hidden = YES;
    [self end];
}

#pragma mark -- Timer
- (void)enableAutoHideTimer:(BOOL)enabled {
    if (enabled) {
        if (!_autoHideTimer) {
            [self autoHideTimer];
        }
    }else {
        if (_autoHideTimer) {
            [_autoHideTimer invalidate];
            _autoHideTimer = nil;
        }
    }
}

- (void)enableRecordTimer:(BOOL)enabled {
    if (enabled) {
        if (!_recordTimer) {
            [self.recordTimer fire];
        }
    }else {
        if (_recordTimer) {
            [_recordTimer invalidate];
            _recordTimer = nil;
        }
    }
}

- (void)timerToAutoHide:(NSTimer *)sender {
    [self hide];
}
- (void)timerToRecord:(NSTimer *)sender {
    [self bringSubviewToFront:self.recordLabel];
    [self bringSubviewToFront:self.recordImageView];
    if (_fadeIn) {
        _recordAlpha -= 0.015;
        if (_recordAlpha <= 0) {
            _recordAlpha = 0;
            _fadeIn = NO;
        }
    }else {
        _recordAlpha += 0.015;
        if (_recordAlpha >= 1) {
            _recordAlpha = 1;
            _fadeIn = YES;
        }
    }
    self.recordLabel.alpha = self.recordImageView.alpha = _recordAlpha;
}

#pragma mark -- Utilites
- (void)show {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.landscaped) {
            self.toolBar.alpha = 1;
            self.topShadowImageView.alpha = 1;
        }
        if (!self.hidePreviewShadow) {
            self.bottomShadowImageView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        [self enableAutoHideTimer:YES];
    }];
    self.drawableView.userInteractionEnabled = YES;
}
- (void)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.landscaped) {
            self.toolBar.alpha = 0;
        }
        self.topShadowImageView.alpha = self.bottomShadowImageView.alpha = 0;
    } completion:^(BOOL finished) {
        if (!_bitStreamView.hidden) {
            [self bitStreamAction:nil];
        }
        [self enableAutoHideTimer:NO];
        if (UIInterfaceOrientationIsPortrait(WY_Application.statusBarOrientation)) {
            self.toolBar.hidden = NO;
        }
    }];
}
- (void)end {
    self.toolBar.hidden = NO;
    self.toolBar.alpha = 1;
    [self enableAutoHideTimer:NO];
    self.drawableView.userInteractionEnabled = NO;
}
- (void)autoShowHide {
    if (self.topShadowImageView.alpha < 1) {
        [self show];
    }else {
        [self hide];
    }
}

#pragma mark -- Action
- (void)tapVideoAction:(UITapGestureRecognizer *)sender {
    
    [self bringSubviewToFront:self.topShadowImageView];
    [self bringSubviewToFront:self.bottomShadowImageView];
    [self autoShowHide];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self touchesEnded:touches withEvent:event];
}

- (void)hdAction:(UIButton *)sender {
    
    self.hdFlag = NO;
    [self delayAutoHide];
    if ([self.delegate respondsToSelector:@selector(WYCameraVideoViewHD:)]) {
        [self.delegate WYCameraVideoViewHD:self];
    }
}
- (void)sdAction:(UIButton *)sender {
    
    self.hdFlag = YES;
    [self delayAutoHide];
    if ([self.delegate respondsToSelector:@selector(WYCameraVideoViewSD:)]) {
        [self.delegate WYCameraVideoViewSD:self];
    }
}
- (void)hdsdTouchAction {
    
    [self delayAutoHide];
}
- (void)fullScreenAction:(UIButton *)sender {
    [self setFullScreen:!self.landscaped];
    [self remakeConstraints];
}
- (void)bitStreamAction:(UIButton *)sender {
    self.bitStreamView.hidden = !self.bitStreamView.isHidden;
    if (!self.bitStreamView.isHidden) {
        [self bringSubviewToFront:self.bitStreamView];
        if (sender) {
            if ([self.delegate respondsToSelector:@selector(WYCameraVideoViewBitStreamView:)]) {
                [self.delegate WYCameraVideoViewBitStreamView:self];
            }
        }
    }
    if (self.bitStreamView.isHidden) {
        [self initGestures];
        [self hide];
        [self enableAutoHideTimer:NO];
    } else {
        self.bitStreamView.videoType = self.videoType;
        [self removeGestures];
    }
}
- (void)backAction:(UIButton *)sender {
    self.fullScreen = NO;
}
#pragma mark - Delegate
#pragma mark -- WYCameraLoadingViewDidLoading
- (void)WYCameraLoadingViewDidLoading:(WYCameraLoadingView *)loadingView {
    
    if ([self.delegate respondsToSelector:@selector(WYCameraVideoViewReplay:)]) {
        [self.delegate WYCameraVideoViewReplay:self];
    }
    if (self.landscaped) {
        [self autoShowHide];
    }
}

#pragma mark -- WYCameraBitStreamViewDelegate
- (void)setVideoType:(WYVideoType)videoType{
    _videoType = videoType;
    switch (videoType) {
        case WYVideoTypePreviewAT: {
            self.bitStreamBtn.alpha = 1;
            self.bitStreamBtn.wy_normalTitle = WYLocalString(@"AT");
            break;
        }
        case WYVideoTypePreviewSD: {
            self.bitStreamBtn.alpha = 1;
            self.bitStreamBtn.wy_normalTitle = WYLocalString(@"SD");
            break;
        }
        case WYVideoTypePreviewHD: {
            self.bitStreamBtn.alpha = 1;
            self.bitStreamBtn.wy_normalTitle = WYLocalString(@"HD");
            break;
        }
        case WYVideoTypePlaybackNVR:
        case WYVideoTypePlaybackSDCard: {
            if (!self.bitStreamView.isHidden) {
                [self bitStreamAction:self.bitStreamBtn];
            }
            self.bitStreamBtn.alpha = 0;
            break;
        }
        default:
            break;
    }
}
- (void)hideBitStreamView {
    if (!self.bitStreamView.hidden) {    
        [self bitStreamAction:self.bitStreamBtn];
    }
}

#pragma mark -- UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.drawableView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale < 1) {
        self.drawableView.center = CGPointMake(scrollView.width/2, scrollView.height/2);
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    view.origin = CGPointZero;
}

#pragma mark - Public
- (void)setDelegate:(id<WYCameraVideoViewDelegate>)delegate {
    _delegate = delegate;
    self.controlView.delegate = delegate;
}
- (void)setHdsdEnabled:(BOOL)hdsdEnabled {
    self.bitStreamBtn.enabled = hdsdEnabled;
}
- (void)showLoading {
    [self insertSubview:self.loadingView belowSubview:self.bitStreamBtn];
    [self.loadingView showLoading];
}
- (void)hideLoading {
    [self.loadingView showEmpty];
}
- (void)showLoadingFailed {
    [self insertSubview:self.loadingView belowSubview:self.bitStreamBtn];
    [self.loadingView showFailed];
}
- (void)showLoadingSleepmodeLensOff {
    [self hideLoading];
    [self.loadingView showSleepmodeLensOffWithStytle:_babyMonitor ? WYUIStytleOrange : WYUIStytleCyan];
}
- (void)showLoadingSleepmodeLensOffByTime {
    [self hideLoading];
    [self.loadingView showSleepmodeLensOffByTimeWithStytle:_babyMonitor ? WYUIStytleOrange : WYUIStytleCyan];
}
- (void)setHdFlag:(BOOL)hdFlag {
    _hdFlag = hdFlag;
}
//延迟
- (void)delayAutoHide {
    if (self.landscaped) {
        [self enableAutoHideTimer:NO];
        [self enableAutoHideTimer:YES];
    }
}

//录像
- (void)startRecordAnimation {
    self.recordImageView.hidden = self.recordLabel.hidden = NO;
    self.recordImageView.alpha = self.recordLabel.alpha = 1.0;
    [self enableRecordTimer:YES];
}
- (void)stopRecordAnimation {
    self.recordImageView.hidden = self.recordLabel.hidden = YES;
    self.recordImageView.alpha = self.recordLabel.alpha = 0.0;
    [self enableRecordTimer:NO];
}
- (BOOL)isEnlarged {
    return self.scrollView.zoomScale > 1.0f;
}
@end
