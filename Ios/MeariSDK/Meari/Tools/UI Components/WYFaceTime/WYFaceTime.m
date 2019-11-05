//
//  WYFaceTime.m
//  Meari
//
//  Created by FMG on 2017/8/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFaceTime.h"
#import "WYCameraVideoView.h"
#import "WYVisitorCallView.h"
#import "WYReceiveView.h"
#import "WYPushManager.h"

@interface WYFaceTime ()<WYReceiveViewDelegate,UIAlertViewDelegate,WYCameraVideoViewDelegate>
{
    BOOL _fullScreen;
    NSInteger _hideTime;
    NSInteger _backgroundCount;
    BOOL _pauseInput;
}

@property (nonatomic,   weak) WYCameraVideoView *videoView;
@property (nonatomic,   weak) MeariPlayView *drawableView;
@property (nonatomic,   weak) WYVisitorCallView *visitorCallView;
@property (nonatomic,   weak) WYReceiveView *receiveView;
@property (nonatomic, strong) MeariDevice *camera;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, assign) WYFaceTimeType faceTimeType;
@property (nonatomic, assign) SystemSoundID soundID;
@property (nonatomic,   copy) WYBlock_Void completion;
@property (nonatomic, strong) NSTimer *autoHideTimer;
@property (nonatomic, strong) NSTimer *shakeTimer; ;
@property (nonatomic, strong) NSTimer *backgroundTimer;

@end

static int isPlaying = 0;

@implementation WYFaceTime

#pragma mark - soundCompleteCallback
void soundCompleteCallback(SystemSoundID soundID,void * clientData)
{
    if (WY_FaceTime.completion) {
        WY_FaceTime.completion();
    }
}

#pragma mark - initSet
+ (instancetype)shareFaceTime {
    static WYFaceTime *faceTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        faceTime = [[WYFaceTime alloc] initWithFrame:[UIScreen mainScreen].bounds];
        faceTime.alpha = 0;
    });
    return faceTime;
}

- (void)initNotifaction {
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_DidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_DidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_Device_ConnectCompleted:) name:WYNotification_Device_ConnectCompleted object:nil];
}
- (void)n_App_DidEnterBackground:(NSNotification *)sender {
    [self enabledBackgroundTimer:YES];
}
- (void)n_App_DidBecomeActive:(NSNotification *)sender {
    [self.camera enableLoudSpeaker:YES];
    if (_receiveView.showSpeakAnimation) {
        _receiveView.showSpeakAnimation = YES;
    }
    [self enabledBackgroundTimer:NO];
}
#pragma mark - Layout
- (void)dealVisitorCall {
    _answering = NO;
    [_videoView removeFromSuperview];
    [_receiveView removeFromSuperview];
    _videoView = nil;
    _receiveView = nil;
    [self setVisitorCallLayout];
    self.visitorCallView.camera = self.camera;
}
- (void)setVisitorCallLayout {
    [self.visitorCallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)setReceiveViewLayout {
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@115);
        make.leading.equalTo(self);
        make.width.equalTo(@(WY_ScreenWidth));
        make.height.equalTo(self.videoView.mas_width).multipliedBy(9.0/16);
    }];
    [self.receiveView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self);
    }];
}

#pragma mark - 赋值
- (void)showWithType:(WYFaceTimeType)type {
    self.faceTimeType = type;
    if (self.alpha) return;
    [WY_NotificationCenter wy_post_Device_VisitorCallShow];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    if (WY_Application.applicationState != UIApplicationStateActive) {
        [WY_NotificationCenter addObserver:self selector:@selector(delayShowWindowAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    } else {
        [self show];
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        }];
    }
}
- (void)setFaceTimeType:(WYFaceTimeType)faceTimeType {
    _faceTimeType = faceTimeType;
    if (!self.alpha && self.faceTimeType == WYFaceTimeType_jpush) {
        _disableOperation = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _disableOperation = NO;
        });
    }
}
- (void)setPushModel:(WYPushModel *)pushModel {
    if (self.faceTimeType == WYFaceTimeType_mqtt) {
        if (_disableOperation) return;
        if ((!_answering && !self.camera.info.key.length) ||(!_answering && ![self.camera.info.key isEqualToString:pushModel.hostKey])) { //第一次播放
            [self setCameraWithPushModel:pushModel];
            if (WY_IsMQTTTimeout(pushModel.msgTime, 0.3) && pushModel.msgTime) {
                [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"访客消息已过期") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                    [self dismiss];
                }];
                return;
            }
            [self.camera wy_startConnectSuccess:nil failure:nil];
            if (self.clickAPPLaunch) {
                _clickAPPLaunch = NO;
                return;
            }
            [self playDoorbellSound];
        }
        else {
            if (self.clickAPPLaunch) {
                _clickAPPLaunch = NO;
                return;
            }
            [self playDoorbellSound];
        }
    } else {
        if (!_answering ||(_answering && ![self.camera.info.key isEqualToString:pushModel.hostKey])) {
            [self setCameraWithPushModel:pushModel];
            [self.camera startConnectSuccess:nil failure:nil];
        }
    }
}
- (void)setCameraWithPushModel:(WYPushModel *)pushModel {
    if (self.camera.sdkLogined) {
        [self.camera stopConnectSuccess:nil failure:nil];
        self.camera = nil;
        [self dealVisitorCall];
    }
    self.camera = [[MeariDevice alloc] init];
    self.camera.info = [MeariDeviceInfo new];
    self.resetHideTime = YES;
    [self setAutoHideTimerOpen:YES];
    _pushModel = pushModel;
    self.camera.info.key = pushModel.hostKey;
    self.camera.info.bellVoice = pushModel.bellVoice;
    self.camera.info.nickname = pushModel.deviceName;
    self.camera.info.connectName = pushModel.connectName;
    self.camera.info.uuid = pushModel.deviceUUID;
//    self.camera.info.typeID = pushModel.devTypeID;
    self.camera.info.subType = pushModel.pushType == WYPushTypeVoiceCall ? MeariDeviceSubTypeIpcVoiceBell : MeariDeviceSubTypeIpcBell;
    self.camera.info.p2p = pushModel.deviceP2P;
    self.camera.info.p2pInit = pushModel.p2pInit;
    self.visitorCallView.camera = self.camera;
    self.visitorCallView.visitorImg = pushModel.imgUrl;
    [self dealVisitorCall];
}


- (void)setVisitorImg:(NSString *)visitorImg {
    _visitorImg = visitorImg;
    if (!_answering) {
        self.visitorCallView.visitorImg = visitorImg;
    }
}
- (void)setAutoHideTimerOpen:(BOOL)open {
    if (!_autoHideTimer && open) {
        [self autoHideTimer];
    } else {
        [self.autoHideTimer invalidate];
        _autoHideTimer = nil;
    }
}
- (void)enableShakeTimerOpen:(BOOL)open {
    if (open) {
        if (!_shakeTimer) {
            [self.shakeTimer fire];
        }
    } else {
        [_shakeTimer invalidate];
        _shakeTimer = nil;
    }
}
- (void)enabledBackgroundTimer:(BOOL)enabled {
    if (enabled) {
        if (!_backgroundTimer) {
            _backgroundCount = 0;
            [self backgroundTimer];
        }
    }else {
        if (_backgroundTimer) {
            _backgroundCount = 0;
            [_backgroundTimer invalidate];
            _backgroundTimer = nil;
        }
    }
}
- (void)setResetHideTime:(BOOL)resetHideTime {
    _resetHideTime = resetHideTime;
    if (resetHideTime) {
        _hideTime = 20;
    }
}
- (void)setClickAPPLaunch:(BOOL)clickAPPLaunch {
    _clickAPPLaunch = clickAPPLaunch;
    if (clickAPPLaunch) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _clickAPPLaunch = NO;
        });
    }
}

#pragma mark - Action
- (void)show {
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        UIScreen *mainScreen = UIScreen.mainScreen;
        
        for (UIWindow *window in frontToBackWindows)
            if (window.screen == mainScreen && window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    if(!self.superview) {
        self.frame = self.overlayView.bounds;
        [self.overlayView addSubview:self];
    }
    [self initNotifaction];
}
- (void)delayShowWindowAction {
    [self show];
    self.alpha = 1;
}
- (void)playDoorbellSound {
    self.resetHideTime = YES;
    if (!_answering && !isPlaying) {
        [self enableShakeTimerOpen:YES];
        isPlaying = 1;
        [self playSoundEffect:@"doorbell_dingdong.caf" completion:^{
            isPlaying = 0;
        }];
    }
}
//播放音效文件
-(void)playSoundEffect:(NSString *)name completion:(WYBlock_Void)completion{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    self.soundID = soundID;
    if (WY_Version_GreaterThanOrEqual_9) {
        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
            if (completion) {
                completion();
            }
        });
    } else {
        self.completion = completion;
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    }
}
- (void)stopDoorbellSound {
    AudioServicesDisposeSystemSoundID(self.soundID);
    AudioServicesRemoveSystemSoundCompletion(self.soundID);
}

#pragma mark -- NSNotification Action
- (void)n_Device_ConnectCompleted:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.camera.info.ID) return;
    if (device.connectSuccess) {
        if (self.pushModel.pushType == WYPushTypeVisitorCall) {
            [self startPreview];
        } else if (self.pushModel.pushType == WYPushTypeVoiceCall){
            [self startVoiceBellSpeak];
        }
    } else if(_answering) {
        [self.videoView showLoadingFailed];
    }
}
- (void)startVoiceBellSpeak {
    //接听后再处理
    if (_answering) {
        if (self.camera.sdkLogined) {
            [self receiveView:nil didClickSpeakBtn:nil];
            [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];
            [self.camera setMute:NO];
        } else {
//            [self.receiveView readyTalking];
        }
    }
}
#pragma mark -- Control Action
- (void)receiveCallAction {
    _answering = YES;
    [self stopDoorbellSound];
    [self setAutoHideTimerOpen:NO];
    [self enableShakeTimerOpen:NO];
    [WYPushManager decrementBadgeNumber];
    [self.visitorCallView removeFromSuperview];
    _visitorCallView = nil;
    [self setReceiveViewLayout];
    self.receiveView.camera = self.camera;
    if (self.pushModel.pushType == WYPushTypeVisitorCall) {
        [self startPreview];
    } else {
        [self startVoiceBellSpeak];
    }
}
- (void)refuseCallAction {
    if (_answering) return;
    WY_WeakSelf
    [self setAutoHideTimerOpen:NO];
    [self enableShakeTimerOpen:NO];
    if (self.camera.info.bellVoice.length) {
        [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"alert_playMessage") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
            _answering = NO;
            if (buttonIndex) {
                WY_HUD_SHOW_WAITING
                [weakSelf.camera playMessageSuccess:^{
                    WY_HUD_DISMISS
                    [WYPushManager decrementBadgeNumber];
                    [weakSelf dismiss];
                } failure:^(NSError *error) {
                    WY_HUD_DISMISS
                    [WYPushManager decrementBadgeNumber];
                    [weakSelf dismiss];
                }];
            } else {
                [WYPushManager decrementBadgeNumber];
                [weakSelf dismiss];
            }
        }];
    } else {
        [WYPushManager decrementBadgeNumber];
        [weakSelf dismiss];
    }
}
- (void)autoHideAction {
    _hideTime--;
    if(_hideTime >0) return;
    [self dismiss];
}
- (void)shakeTimerAction:(NSTimer *)timer {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
}
- (void)timerToBackground:(id)sender {
    _backgroundCount++;
    if (_backgroundCount >= 20) {
        [self stopPreview];
        [self enabledBackgroundTimer:NO];
    }
}
#pragma mark - 操作设备
- (void)startPreview {
    if(!_answering) return;
    [self.videoView showLoading];
    if(!self.camera.sdkLogined) return;
    WY_WeakSelf
    [self.camera startPreview2:MeariDeviceVideoStream_720 success:^{
        weakSelf.receiveView.showSpeakAnimation = YES;
        [weakSelf.videoView hideLoading];
        [weakSelf receiveView:nil didClickSpeakBtn:nil];
        [weakSelf.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];
        [weakSelf.camera setMute:NO];
    } receiveStreamData:^(u_int8_t *buffer,MeariDeviceStreamType type, MEARIDEV_MEDIA_HEADER_PTR header, int bufferSize) {
        
    } failure:^(NSError *error) {
        if (error.code == MeariDeviceCodePreviewIsPlaying) {
            [weakSelf.videoView hideLoading];
        }else {
            [weakSelf.videoView showLoadingFailed];
        }
    } close:^(MeariDeviceSleepmode sleepmodeType) {
        [weakSelf.videoView showLoadingFailed];
    }];
}
- (void)stopPreview {
    WY_WeakSelf
    [self.camera stopPreviewSuccess:^{
        [weakSelf.camera stopConnectSuccess:nil failure:nil];
        weakSelf.camera = nil;
        _receiveView.showSpeakAnimation = NO;
    } failure:^(NSError *error) {
        [weakSelf.camera stopConnectSuccess:nil failure:nil];
        weakSelf.camera = nil;
    }];
}
- (void)stopVoiceTalkingWithButton:(UIButton *)btn {
    self.receiveView.showSpeakAnimation = NO;
    WY_WeakSelf
    if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell) {
        _pauseInput = YES;
        [self.camera pauseVoicetalkSuccess:nil failure:nil];
    } else {
        [self.camera stopVoicetalkDefault:YES  success:^{
            if (weakSelf.camera.sdkLogined) {
                [weakSelf.videoView hideLoading];
            }
            [weakSelf.camera setVoiceTalkType:MeariVoiceTalkTypeOneWay];
        } failure:^(NSError *error) {
            WY_HUD_SHOW_STATUS(WYLocalString(@"set faild"));
            if (weakSelf.camera.sdkLogined) {
                [weakSelf.videoView hideLoading];
            }
            btn.selected = NO;
        }];
    }
}

- (void)dismiss {
    [self setAutoHideTimerOpen:NO];
    [self enableShakeTimerOpen:NO];
    [self stopDoorbellSound];
    if (_answering) {
        [self stopVoiceTalkingWithButton:nil];
    }
    [self stopPreview];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 0;
        [WY_NotificationCenter wy_post_Device_VisitorCallDismiss];
        [self dealVisitorCall];
        [self resetProperty];
        [_overlayView removeFromSuperview];
        _overlayView = nil;
        [self removeFromSuperview];
        [WY_NotificationCenter removeObserver:self];
    }];
}
- (void)resetProperty {
    _answering = NO;
    _clickAPPLaunch = NO;
    _disableOperation = NO;
    self.resetHideTime = YES;
}
#pragma mark - Delegate
#pragma mark -- WYCameraVideoViewDelegate
- (void)WYCameraVideoViewReplay:(WYCameraVideoView *)videoView {
    if(self.camera.sdkLogined) {
        [self startPreview];
    } else {
        WY_HUD_SHOW_STATUS(WYLocalString(@"门铃已休眠！"))
        [self.videoView showLoadingFailed];
    }
}
#pragma mark -- WYReceiveViewDelegate
- (void)receiveView:(WYReceiveView *)receiveView didClickFullScreenBtn:(UIButton *)btn {
    [self setReceiveViewLayout];
}
- (void)receiveView:(WYReceiveView *)receiveView didClickHangUpBtn:(UIButton *)btn {
    [self dismiss];
}
- (void)receiveView:(WYReceiveView *)receiveView didClickMuteBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    [self.camera setMute:btn.selected];
}
- (void)receiveView:(WYReceiveView *)receiveView didClickSpeakBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    [self.videoView showLoading];
    WY_WeakSelf
    if (btn.selected) {
        [self stopVoiceTalkingWithButton:btn];
    } else {
        [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];
        [self.camera enableLoudSpeaker:YES];
        if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell&&_pauseInput) {
            weakSelf.receiveView.showSpeakAnimation = YES;
            [self.camera resumeVoicetalkSuccess:nil failure:nil];
        } else {
            [self.camera startVoiceTalkDefault:YES success: ^{
                weakSelf.receiveView.logined = YES;
                if (weakSelf.camera.sdkLogined) {
                    [weakSelf.videoView hideLoading];
                }
                weakSelf.receiveView.showSpeakAnimation = YES;
            } failure:^(NSError *error) {
                if (weakSelf.camera.sdkLogined) {
                    [weakSelf.videoView hideLoading];
                } else {
                    [weakSelf.videoView showLoadingFailed];
                }
                btn.selected = YES;
            }];
        }
    }
}


#pragma mark - lazyLoad
- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}
- (WYVisitorCallView *)visitorCallView {
    if (!_visitorCallView) {
        WYVisitorCallView *view = [WYVisitorCallView new];
        self.visitorCallView = view;
        view.receiveCall = ^{
            [self receiveCallAction];
        };
        view.refuseCall = ^{
            [self refuseCallAction];
        };
        [self addSubview:view];
    }
    return _visitorCallView;
}
- (WYCameraVideoView *)videoView {
    if (!_videoView) {
        WYCameraVideoView *view = [WYCameraVideoView new];
        view.hidePreviewShadow = YES;
        view.backgroundColor = [UIColor blackColor];
        view.delegate = self;
        [self addSubview:view];
        _videoView = view;
    }
    return _videoView;
}
- (WYReceiveView *)receiveView {
    if (!_receiveView) {
        WYReceiveView *view = [WYReceiveView new];
        _receiveView = view;
        view.delegate = self;
        [self addSubview:_receiveView];
    }
    return _receiveView;
}
- (NSTimer *)autoHideTimer {
    if (!_autoHideTimer) {
        self.autoHideTimer = [NSTimer timerInLoopWithInterval:1.0f target:self selector:@selector(autoHideAction)];
    }
    return _autoHideTimer;
}
- (NSTimer *)shakeTimer {
    if (!_shakeTimer) {
        self.shakeTimer = [NSTimer timerInLoopWithInterval:1.0 target:self selector:@selector(shakeTimerAction:)];
    }
    return _shakeTimer;
}
- (NSTimer *)backgroundTimer {
    if (!_backgroundTimer) {
        _backgroundTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToBackground:)];
    }
    return _backgroundTimer;
}

- (void)dealloc {
    [self enableShakeTimerOpen:NO];
    [self setAutoHideTimerOpen:NO];
}
@end
