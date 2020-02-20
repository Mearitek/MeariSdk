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
    BOOL _wakeUpMemory;
    BOOL _sdkLogined;
    BOOL _sdkLoginFailed;
    BOOL _pauseInput;
}

@property (nonatomic,   weak) WYCameraVideoView *videoView;
@property (nonatomic,   weak) MeariPlayView *drawableView;
@property (nonatomic,   weak) WYVisitorCallView *visitorCallView;
@property (nonatomic,   weak) WYReceiveView *receiveView;
@property (nonatomic, strong) UIImageView *ringIV;
@property (nonatomic, strong) MeariDevice *camera;
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, assign) WYFaceTimeType faceTimeType;
@property (nonatomic, assign) SystemSoundID soundID;
@property (nonatomic,   copy) WYBlock_Void completion;
@property (nonatomic, strong) NSTimer *autoHideTimer;
@property (nonatomic, strong) NSTimer *shakeTimer; ;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic, strong) NSTimer *heartbeat;
@property (nonatomic, assign) BOOL  stopSpeak;
@property (nonatomic, assign) BOOL  muteEnable;

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
    if (self.pushModel.pushType == WYPushTypeVisitorCall) {
        //给悠响声学补漏
        [self.camera enableLoudSpeaker:YES];
    }
    if (_receiveView.showSpeakAnimation) {
        _receiveView.showSpeakAnimation = YES;
    }
    [self enabledBackgroundTimer:NO];
    
    if (_wakeUpMemory) {
        [self show];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
        _wakeUpMemory = NO;
    }
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
    self.videoView.hidden = self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell;
    [self.receiveView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self);
    }];
    
}

#pragma mark - 赋值
- (void)showWithType:(WYFaceTimeType)type {
    self.faceTimeType = type;
    [self initNotifaction];
    if (self.alpha) return;
    [WY_NotificationCenter wy_post_Device_VisitorCallShow];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    if (WY_Application.applicationState == UIApplicationStateInactive) {
        [WY_NotificationCenter addObserver:self selector:@selector(delayShowWindowAction) name:UIApplicationDidBecomeActiveNotification object:nil];
    } else if (WY_Application.applicationState == UIApplicationStateBackground) {
        _wakeUpMemory = YES;
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
            self->_disableOperation = NO;
        });
    }
}
- (void)setPushModel:(WYPushModel *)pushModel {
    if (self.faceTimeType == WYFaceTimeType_mqtt) {
        if (_disableOperation) return;
        if ((!_answering && !self.camera.info.key.length) || (!_answering && ![self.camera.info.key isEqualToString:pushModel.hostKey]) || (_answering && ![self.camera.info.key isEqualToString:pushModel.hostKey] && self.faceTimeType == WYFaceTimeType_jpush)) { //第一次播放
//            if (WY_IsMessageTimeout(pushModel.msgTime, 0.3) && pushModel.msgTime && !_answering) {
//                [self dealVisitorCall];
//                self.visitorCallView.visitorImg = pushModel.imgUrl;
//                [self showExpiredTip];
//                return;
//            }
            [self setCameraWithPushModel:pushModel];
            if (self.clickAPPLaunch) {
                _clickAPPLaunch = NO;
                return;
            }
            [self playDoorbellSound];
        } else {
            if (self.clickAPPLaunch) {
                _clickAPPLaunch = NO;
                return;
            }
            [self playDoorbellSound];
        }
    } else {
        if (!_answering || (_answering && ![self.camera.info.key isEqualToString:pushModel.hostKey])) {
            //            if (WY_IsMessageTimeout(pushModel.msgTime, 0.3) && pushModel.msgTime) return;
            [self setCameraWithPushModel:pushModel];
        }
    }
}
- (void)setCameraWithPushModel:(WYPushModel *)pushModel {
    if (_answering) {
        [self enabledHeartbeatTimer:NO];
        [self requestReleaseAnswerAuthorityWithCamera:self.camera success:nil failure:nil];
        if (self.pushModel.pushType == WYPushTypeVisitorCall) {
            [self.camera stopPreviewSuccess:nil failure:nil];
            [self.camera stopConnectSuccess:nil failure:nil];
        }
        self.camera = nil;
        [self dealVisitorCall];
    }
    self.camera = [[MeariDevice alloc] init];
    self.resetHideTime = YES;
    [self setAutoHideTimerOpen:YES];
    _pushModel = pushModel;
    MeariDeviceInfo *info = [[MeariDeviceInfo alloc]init];
    info.p2p = pushModel.deviceP2P;
    info.p2pInit = pushModel.p2pInit;
    info.key = pushModel.hostKey;
    info.bellVoice = pushModel.bellVoice;
    info.nickname = pushModel.deviceName;
    info.connectName = pushModel.connectName;
    info.ID = pushModel.deviceID;
    info.uuid = pushModel.deviceUUID;
    info.type = pushModel.type;
    info.subType = pushModel.subType;
    self.camera.info = info;
    self.visitorCallView.camera = self.camera;
    self.visitorCallView.visitorImg = pushModel.imgUrl;
    if (!self.camera.sdkLogined) {
        [self dealVisitorCall];
    } else {
        self.visitorCallView.camera = self.camera;
    }
    //重置状态位
    _sdkLogined = NO;
    _sdkLoginFailed = NO;
    self.videoView.hidden = self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell;
    [self.camera wy_startConnectSuccess:nil failure:nil];
    if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell) {
        [self networkRequestVoiceBellParams];
    }
}
- (void)networkRequestVoiceBellParams {
//    NSString *shadowUrl = WY_URLIotHub(WYURL_iotHub_shadow_get,self.camera);
//    [HttpTool HttpGET:shadowUrl shadowParams:[NSDictionary dictionary] success:^(NSDictionary * _Nonnull responseDic) {
//        WYLogM(@"%@",responseDic);
//        WYCameraIotHub *iothub = [WYCameraIotHub mj_objectWithKeyValues:responseDic[@"data"]];
//        self.camera.iothub = iothub;
//        self->_hideTime = iothub.iothub_waitMsgTime - (20-self->_hideTime);
//    } failure:^(NSError * _Nonnull error) {
//    }];
}


- (void)setVisitorImg:(NSString *)visitorImg {
    _visitorImg = visitorImg;
    if (!_answering) {
        self.visitorCallView.visitorImg = visitorImg;
    }
}
- (void)setAutoHideTimerOpen:(BOOL)open {
    if (open) {
        if(!_autoHideTimer) {
            [self autoHideTimer];
        }
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
- (void)enabledHeartbeatTimer:(BOOL)enabled {
    if (enabled) {
        if (!_heartbeat) {
            [self heartbeat];
        }
    }else {
        if (_heartbeat) {
            [_heartbeat invalidate];
            _heartbeat = nil;
        }
    }
}
- (void)setResetHideTime:(BOOL)resetHideTime {
    _resetHideTime = resetHideTime;
    if (resetHideTime&!self.camera.param.voiceBell) {
        _hideTime = 20;
    }
}
- (void)setClickAPPLaunch:(BOOL)clickAPPLaunch {
    _clickAPPLaunch = clickAPPLaunch;
    if (clickAPPLaunch) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->_clickAPPLaunch = NO;
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
}
- (void)delayShowWindowAction {
    [self show];
    self.alpha = 1;
//    if (WY_IsMessageTimeout(self.pushModel.msgTime, 0.3) && self.pushModel.msgTime && !_answering) {
//        [self showExpiredTip];
//    }
}
- (void)showExpiredTip {
    [self enableShakeTimerOpen:NO];
    [self setAutoHideTimerOpen:NO];
    [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"alert_visitorMessageExpired") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        [self dismiss];
    }];
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

#pragma mark -- Network Request Action
- (void)requestAnswerAuthorityWithCamera:(MeariDevice *)camera success:(WYBlock_Void)success failure:(WYBlock_Error)failure {
    [[MeariUser sharedInstance] requestAnswerAuthorityWithDeviceID:camera.info.ID messageID:[_pushModel.msgID intValue] success:^(NSInteger msgEffectTime,double severTime){
        //msgEffectTime
//        self.effectTime = msgEffectTime;
//        self.severTime = severTime;
        [self enabledHeartbeatTimer:YES];
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (error.code == MeariUserCodeNetworkUnavailable) {
            WY_HUD_SHOW_ERROR(error)
        } else {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    
}
- (void)requestReleaseAnswerAuthorityWithCamera:(MeariDevice *)camera success:(WYBlock_Void)success failure:(WYBlock_Int)failure {
    [[MeariUser sharedInstance] requestReleaseAnswerAuthorityWithID:camera.info.ID success:^{
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (error.code == MeariUserCodeNetworkUnavailable) {
            WY_HUD_SHOW_ERROR(error)
        }
        if (failure) {
            failure(error.code);
        }
    }];
}
- (void)sendHeartbeatWithCamera:(MeariDevice *)camera {
    [[MeariUser sharedInstance] sendHeartBeatWithID:camera.info.ID success:^{
    } failure:^(NSError *error) {
    }];
}

#pragma mark -- NSNotification Action
- (void)n_Device_ConnectCompleted:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    
    if (!device || device.deviceID != self.camera.info.ID || ![device.camerap isEqualToString:[NSString stringWithFormat:@"%p", self.camera]]) return;
    if (device.connectSuccess) {
        _sdkLogined = YES;
        if (self.pushModel.pushType == WYPushTypeVisitorCall) {
            [self startPreview];
        } else if (self.pushModel.pushType == WYPushTypeVoiceCall) {
            [self startVoiceBellSpeak];
        }
    } else if (_answering) {
        //        if (self.pushModel.pushType == WYPushTypeVisitorCall) {
        [self.videoView showLoadingFailed];
        //        }
    } else {
        _sdkLoginFailed = YES;
    }
}
#pragma mark -- Control Action
- (void)receiveCallAction {
    _answering = YES;
    [self stopDoorbellSound];
    [self setAutoHideTimerOpen:NO];
    [self enableShakeTimerOpen:NO];
    [WYPushManager decrementBadgeNumber];
    [_visitorCallView removeFromSuperview];
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
    if ([self.camera supportHostMessage]) {
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
    //    [self showExpiredTip];
}
- (void)shakeTimerAction:(NSTimer *)timer {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
}
- (void)timerToBackground:(id)sender {
    _backgroundCount++;
    if (_backgroundCount >= 20) {
        if (self.pushModel.pushType == WYPushTypeVisitorCall) {
            [self stopPreview];
        }
        [self enabledBackgroundTimer:NO];
    }
}
- (void)timerToHeartbeat:(id)sender {
    [self sendHeartbeatWithCamera:self.camera];
}
#pragma mark - 操作设备
- (void)startPreview {
    if (!_answering) return;
    if (_sdkLoginFailed) {
        _sdkLoginFailed = NO;
        [self.camera wy_startConnectSuccess:nil failure:nil];
    }
    [self.videoView showLoading];
    if (!self.camera.sdkLogined && !_sdkLogined) return;
    [self.camera startPreviewWithView:self.videoView.drawableView videoStream:MeariDeviceVideoStream_360 success:^{
        [self receiveView:nil didClickSpeakBtn:nil];
        //        [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];
//        [self.camera setMute:_muteEnable];
    } failure:^(NSError *error) {
        if (error.code == MeariDeviceCodePlaybackIsPlaying) {
            [self.videoView hideLoading];
        } else {
            [self.videoView showLoadingFailed];
        }
    } close:^(MeariDeviceSleepmode sleepmodeType) {
        [self.videoView showLoadingFailed];
    }];
}

- (void)stopPreview {
    _receiveView.showSpeakAnimation = NO;
    if (self.camera.sdkPlaying) {
        [self.camera stopPreviewSuccess:^{
            [self.camera stopConnectSuccess:nil failure:nil];
            self.camera = nil;
        } failure:^(NSError *error) {
            [self.camera stopConnectSuccess:nil failure:nil];
            self.camera = nil;
        }];
    } else {
        [self.camera stopConnectSuccess:nil failure:nil];
        self.camera = nil;
    }
}
- (void)stopVoiceTalkingWithButton:(UIButton *)btn {
    _receiveView.showSpeakAnimation = NO;
    WY_WeakSelf
    if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell) {
        _pauseInput = YES;
        [self.camera pauseVoicetalkSuccess:nil failure:nil];
    } else {
        [self.camera stopVoicetalkSuccess:^{
            if (weakSelf.camera.sdkLogined) {
                [weakSelf.videoView hideLoading];
            }
            [self.camera setVoiceTalkType:MeariVoiceTalkTypeOneWay];
        } failure:^(NSError *error) {
            if (weakSelf.camera.sdkLogined) {
                [weakSelf.videoView hideLoading];
            }
            btn.selected = NO;
        }];
    }
}
- (void)startVoiceBellSpeak {
    //接听后再处理
    if (_answering) {
        if (self.camera.sdkLogined) {
            WY_HUD_DISMISS
            [self receiveView: nil didClickSpeakBtn: nil];
            [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];
//            [self.camera setMute:_muteEnable];
        } else {
            [self.receiveView readyTalking];
        }
    }
}
- (void)dismiss {
    WY_HUD_DISMISS
    if (_answering) {
        [self stopVoiceTalkingWithButton:nil];
    }
    [self stopPreview];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self setAutoHideTimerOpen:NO];
        [self enableShakeTimerOpen:NO];
        [self enabledHeartbeatTimer:NO];
        [self stopDoorbellSound];
        self.alpha = 0;
        [WY_NotificationCenter wy_post_Device_VisitorCallDismiss];
        [self dealVisitorCall];
        [self resetProperty];
        for (UIView *view in self.subviews) {
            if (view.tag == 111111) {
                [view removeFromSuperview];
            }
        }
        [_overlayView removeFromSuperview];
        _overlayView = nil;
        [WY_FaceTime removeFromSuperview];
        [WY_NotificationCenter removeObserver:self];
    }];
}
- (void)resetProperty {
    _answering = NO;
    isPlaying = NO;
    _pauseInput = NO;
    _clickAPPLaunch = NO;
    _disableOperation = NO;
    self.resetHideTime = YES;
}
#pragma mark - Delegate
#pragma mark -- WYCameraVideoViewDelegate
- (void)WYCameraVideoViewReplay:(WYCameraVideoView *)videoView {
    if (self.camera.sdkLogined) {
        [self startPreview];
    } else {
        [self.camera wy_startConnectSuccess:nil failure:nil];
    }
}
#pragma mark -- WYReceiveViewDelegate
- (void)receiveView:(WYReceiveView *)receiveView didClickFullScreenBtn:(UIButton *)btn {
    [self setReceiveViewLayout];
}
- (void)receiveView:(WYReceiveView *)receiveView didClickHangUpBtn:(UIButton *)btn {
//    self.receiveView.isDurationTimerValid = NO;
    [self requestReleaseAnswerAuthorityWithCamera:self.camera success:nil failure:nil];
    [self dismiss];
}
- (void)receiveView:(WYReceiveView *)receiveView didClickMuteBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
//    self.muteEnable = btn.selected;
    [self.camera setMute:btn.selected];
}
- (void)receiveView:(WYReceiveView *)receiveView didClickSpeakBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if(btn) {
        self.stopSpeak = btn.selected;
    }
    WY_WeakSelf
    if (btn.selected || self.stopSpeak) {
        [self stopVoiceTalkingWithButton:btn];
    } else {
        [WYAuthorityManager checkAuthorityOfMicrophone:^(BOOL granted) {
            if (granted) {
                [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];
                //        [self.camera setLoudSpeakerOpen:YES];
                [self.camera enableLoudSpeaker:YES];
//                [weakSelf.receiveView readyTalking];
                if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell && _pauseInput) {
                    weakSelf.receiveView.showSpeakAnimation = YES;
                    weakSelf.receiveView.logined = YES;
                    [self.camera resumeVoicetalkSuccess:nil failure:nil];
                } else {
                    [self.camera startVoiceTalkSuccess:^{
                        weakSelf.receiveView.logined = YES;
                        if (weakSelf.camera.sdkLogined) {
                            [weakSelf.videoView hideLoading];
                        }
                        weakSelf.receiveView.showSpeakAnimation = YES;
                    } failure:^(NSError *error) {
                        if (weakSelf.camera.sdkLogined) {
                            weakSelf.receiveView.logined = YES;
                            [weakSelf.videoView hideLoading];
                        } else {
                            [weakSelf.videoView showLoadingFailed];
                        }
//                        weakSelf.receiveView.speakBtn.selected = YES;
                    }];
                }
            } else {
                [WYAlertView showNeedAuthorityOfMicrophone];
                if (weakSelf.camera.sdkLogined) {
                    weakSelf.receiveView.logined = YES;
                    [weakSelf.videoView hideLoading];
                } else {
                    [weakSelf.videoView showLoadingFailed];
                }
//                weakSelf.receiveView.speakBtn.selected = YES;
            }
        }];
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
        WY_WeakSelf
        __weak typeof(view)weakView = view;
        view.receiveCall = ^{
            WY_StrongSelf
            [self setAutoHideTimerOpen: NO];
            WY_HUD_SHOW_WAITING
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WY_HUD_DISMISS
                if (!strongSelf->_answering) {
                    [[MeariUser sharedInstance] cancelAllRequest];
                    
                }
            });
            [self requestAnswerAuthorityWithCamera:weakSelf.camera success:^{
                WY_HUD_DISMISS
//                [weakView receiveSuccess];
                [self receiveCallAction];
            } failure:^(NSError *error) {
                WY_HUD_DISMISS
                if (error.code == MeariUserCodeDoorbellAnswering) {
                    [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"alert_visitor_other_answering") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                        [weakSelf dismiss];
                    }];
                } else if (error.code == MeariUserCodeDeviceCancelShared) {
                    [WYAlertView showWithTitle:nil message:WYLocalString(@"toast_cancel_share") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                        [weakSelf dismiss];
                    }];
                } else {
                    WY_HUD_SHOW_ERROR(error)
                }
            }];
        };
        view.refuseCall = ^{
            WY_HUD_SHOW_WAITING
            [self requestReleaseAnswerAuthorityWithCamera: weakSelf.camera success:^{
                WY_HUD_DISMISS
                [self refuseCallAction];
            } failure:^(MeariUserCode codeType) {
                WY_HUD_DISMISS
                [weakSelf dismiss];
            }];
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
- (NSTimer *)heartbeat {
    if (!_heartbeat) {
        _heartbeat = [NSTimer timerInLoopWithInterval:10.f target:self selector:@selector(timerToHeartbeat:)];
    }
    return _heartbeat;
}

- (void)dealloc {
    [self enableShakeTimerOpen:NO];
    [self setAutoHideTimerOpen:NO];
}
@end
