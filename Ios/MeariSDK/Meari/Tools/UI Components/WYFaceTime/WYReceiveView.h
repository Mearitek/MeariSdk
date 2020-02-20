//
//  WYReceiveView.h
//  Meari
//
//  Created by FMG on 2017/8/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYReceiveView;
@protocol WYReceiveViewDelegate <NSObject>

@optional
- (void)receiveView:(WYReceiveView *)receiveView didClickFullScreenBtn:(UIButton *)btn;
- (void)receiveView:(WYReceiveView *)receiveView didClickMuteBtn:(UIButton *)btn;
- (void)receiveView:(WYReceiveView *)receiveView didClickHangUpBtn:(UIButton *)btn;
- (void)receiveView:(WYReceiveView *)receiveView didClickSpeakBtn:(UIButton *)btn;

@end
@interface WYReceiveView : UIView
@property (nonatomic,   weak) id<WYReceiveViewDelegate>delegate;
@property (nonatomic,   weak) UIButton *speakBtn;
@property (nonatomic, strong) MeariDevice *camera;
@property (nonatomic, assign) BOOL showSpeakAnimation;
@property (nonatomic, assign) BOOL isDurationTimerValid;
@property (nonatomic, assign) BOOL logined;
- (void)readyTalking;
@end
