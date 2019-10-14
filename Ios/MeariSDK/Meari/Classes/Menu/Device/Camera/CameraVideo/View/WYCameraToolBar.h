//
//  WYCameraToolBar.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYBabyMonitorMusicToolBar.h"

typedef NS_ENUM(NSInteger, WYCameraToolBarVideoType) {
    WYCameraToolBarPreviewTypeP = 1,
    WYCameraToolBarPreviewTypeL,
    WYCameraToolBarPlaybackTypeP,
    WYCameraToolBarPlaybackTypeL
};

typedef NS_ENUM(NSInteger, WYCameraToolBarButtonType) {
    WYCameraToolBarButtonTypeVoice,
    WYCameraToolBarButtonTypeCalendar,
    WYCameraToolBarButtonTypeSnapshot,
    WYCameraToolBarButtonTypePlay,
    WYCameraToolBarButtonTypeMusic,
    WYCameraToolBarButtonTypeRecord,
    WYCameraToolBarButtonTypeMute,
};

@class WYCameraToolBar,WYCameraBitStreamView;
@protocol WYCameraToolBarDelegate <NSObject>
@optional
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedVoiceButton:(UIButton *)button;
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didLosedVoiceButton:(UIButton *)button;
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedCalendarButton:(UIButton *)button;
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedSnapshotButton:(UIButton *)button;
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedPlayButton:(UIButton *)button;
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedMusicButton:(UIButton *)button;
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedRecordButton:(UIButton *)button;
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedMuteButton:(UIButton *)button;

@end

@interface WYCameraToolBar: WYBaseView
@property (nonatomic, weak)id<WYCameraToolBarDelegate>delegate;
@property (nonatomic, assign)WYCameraToolBarVideoType screenType;

@property (nonatomic, assign)WYVideoType videoType;
@property (nonatomic, assign)BOOL previewed;
- (instancetype)initWithVideoType:(WYVideoType)videoType;
- (instancetype)initWithVideoType:(WYVideoType)videoType needMusic:(BOOL)needMusic fullDuplex:(BOOL)fullDuplex;
//设置按钮选中状态
- (void)setButton:(WYCameraToolBarButtonType)buttonType selected:(BOOL)selected;
- (void)setButton:(WYCameraToolBarButtonType)buttonType enabled:(BOOL)enabled;
//reset
- (void)reset;
- (void)hiddenButton:(WYCameraToolBarButtonType)buttonType hidden:(BOOL)hidden;
@end
