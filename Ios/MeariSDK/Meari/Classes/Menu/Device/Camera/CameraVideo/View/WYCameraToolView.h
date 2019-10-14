//
//  WYCameraToolView.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCameraToolPreviewView.h"
#import "WYCameraToolPlaybackView.h"

@class WYCameraToolView;
@protocol WYCameraToolViewDelegate <NSObject>

@optional
- (void)WYCameraToolView:(WYCameraToolView *)toolView didScrolledType:(WYVideoType)videoType;
- (void)WYCameraToolView:(WYCameraToolView *)toolView didScrolledProgress:(CGFloat)progress;


@end

@interface WYCameraToolView : WYBaseView
@property (nonatomic, weak)id delegate;
@property (nonatomic, weak)WYCameraToolPreviewView *previewView;
@property (nonatomic, weak)WYCameraToolPlaybackView *playbackView;

@property (nonatomic, assign)WYVideoType videoType;
@property (nonatomic, assign)BOOL previewed;
- (instancetype)initWithVideoType:(WYVideoType)videoType deviceType:(MeariDeviceSubType)deviceType;
- (void)setSettingHidden:(BOOL)hidden;

@end
