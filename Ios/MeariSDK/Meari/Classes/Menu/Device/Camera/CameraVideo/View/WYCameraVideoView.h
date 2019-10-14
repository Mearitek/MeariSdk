//
//  WYCameraVideoView.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCameraBitStreamView.h"

@class WYBabyMonitorMusicToolBar;
@class WYCameraVideoView;
@protocol WYCameraVideoViewDelegate <NSObject>
@optional
- (void)WYCameraVideoViewReplay:(WYCameraVideoView *)videoView;
- (void)WYCameraVideoViewHD:(WYCameraVideoView *)videoView;
- (void)WYCameraVideoViewSD:(WYCameraVideoView *)videoView;
- (void)WYCameraVideoViewBitStreamView:(WYCameraVideoView *)videoView;
- (void)WYCameraVideoView:(WYCameraVideoView *)videoView swipe:(UISwipeGestureRecognizer *)swipeGesture;
- (void)WYCameraVideoViewSwipeDidEnded:(WYCameraVideoView *)videoView;

@end

@class WYCameraToolBar;
@interface WYCameraVideoView : WYBaseView
@property (nonatomic, weak)id<WYCameraVideoViewDelegate>delegate;
@property (nonatomic, weak)id<WYCameraVideoViewDelegate>tapDelegate;

@property (nonatomic, weak)UIViewController *viewController;
@property (nonatomic, weak)MeariPlayView *drawableView;
@property (nonatomic, weak)WYCameraToolBar *toolBar;
@property (nonatomic, weak)WYCameraBitStreamView *bitStreamView;
@property (nonatomic, assign)WYVideoType videoType;
@property (nonatomic, assign)BOOL hdFlag;
@property (nonatomic, assign)BOOL hdsdEnabled;
@property (nonatomic, assign)BOOL fullScreen;
@property (nonatomic, assign)BOOL hidePreviewShadow;
@property (nonatomic, assign, getter=isEnlarged)BOOL enlarged;


//菊花
- (void)showLoading;
- (void)hideLoading;
- (void)showLoadingFailed;
- (void)showLoadingSleepmodeLensOff;
- (void)showLoadingSleepmodeLensOffByTime;
//延迟
- (void)delayAutoHide;
//录像
- (void)startRecordAnimation;
- (void)stopRecordAnimation;
//隐藏高标清模式切换控件
- (void)hideBitStreamView;
@end
