//
//  WYCameraVideoOneVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/26.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraVideoOneVC.h"
#import "WYCameraListVC.h"
#import "WYCameraSegment.h"
#import "WYCameraToolView.h"
#import "WYCameraToolBar.h"
#import "WYBabyMonitorMusicToolBar.h"
#import "WYBabyMonitorMusicVC.h"
#import "WYCameraVoiceHUD.h"
#import "WYBabyMonitorMusicModel.h"
#import "MeariDevice+WYAdd.h"

#define WYCameraReturnForNotInVideoType(arg1,arg2) if (arg1 != arg2) return;

#define WYCanPlay(arg) (weakSelf.videoType == arg && weakSelf.wy_isTop)
#define WYCanPlayHD         WYCanPlay(WYVideoTypePreviewHD)
#define WYCanPlaySD         WYCanPlay(WYVideoTypePreviewSD)
#define WYCanPlayPreview    (WYCanPlayHD || WYCanPlaySD)
#define WYCanPlaySDCard     WYCanPlay(WYVideoTypePlaybackSDCard)
#define WYCanPlayNVR        WYCanPlay(WYVideoTypePlaybackNVR)
#define WYCanPlayPlacback   (WYCanPlaySDCard || WYCanPlayNVR)
#define WYSeekDelayTime     5

@interface WYCameraVideoOneVC ()<WYCameraSegmentDelegate,
                                    WYCameraVideoViewDelegate,
                                    WYCameraToolViewDelegate,
                                    WYCameraToolPreviewViewDelegate,
                                    WYCameraToolPlaybackTimeBarViewDelegate,
                                    WYCameraToolPlaybackPictureBarViewDelegate,
                                    WYCameraToolPlaybackAlarmMessageViewDelegate,
                                    WYCameraToolBarDelegate,
                                    WYCalendarVCDelegate,
                                    WYBabyMonitorMusicToolBarDelegate,
                                    WYCameraBitStreamViewDelegate>
{
    WYVideoType _previewType;
    WYVideoType _placbackType;
    WYVideoType _transionType;
    WYVideoType _lastType;
    
    BOOL _fromShare;
    BOOL _landInOtherPlace;
    NSInteger _backgroundCount;
    NSInteger _connectTimeoutCount;
    
    BOOL _firstAppear;
    BOOL _backed;
    BOOL _gotosleepmode;
    BOOL _needHomeRefresh;
    BOOL _isPreviewing;
    BOOL _visitorCalling;
}
@property (nonatomic, strong)MeariDevice *camera;
@property (nonatomic, strong)MeariDevice *nvr;
@property (nonatomic, strong)NSDateComponents *currentComponents;

@property (nonatomic, strong)UIBarButtonItem *hdItem;
@property (nonatomic, strong)UIBarButtonItem *sdItem;
@property (nonatomic, strong)UIBarButtonItem *settingItem;
@property (nonatomic, strong)UIBarButtonItem *sdcardItem;
@property (nonatomic, strong)UIBarButtonItem *nvrItem;

@property (nonatomic, weak)WYCameraSegment *segmentView;
@property (nonatomic, weak)MeariPlayView *drawableView;
@property (nonatomic, weak)WYCameraToolView *toolView;
@property (nonatomic, weak)WYCameraToolPlaybackTimeBarView *timeBar;
@property (nonatomic, weak)WYCameraToolPlaybackPictureBarView *pictureBar;
@property (nonatomic, weak)WYCameraToolPlaybackAlarmMessageView *alarmBar;
@property (nonatomic, weak)WYCameraToolBar *toolBar;
@property (nonatomic, weak)WYBabyMonitorMusicVC *musicVC;

@property (nonatomic, assign)CGFloat segmentH;
@property (nonatomic, assign)CGFloat toolViewH;
@property (nonatomic, assign)CGFloat toolViewT;
@property (nonatomic, assign)CGFloat toolBarH;
@property (nonatomic, assign)CGFloat toolBarLR;
@property (nonatomic, assign)CGFloat toolBarB;

@property (nonatomic, assign, getter=isLandscaped)BOOL landscaped;
@property (nonatomic, assign, getter=isDraggingTimeBar)BOOL draggingTimeBar;
@property (nonatomic, assign, getter=isVoiceSpeaking)BOOL voiceSpeaking;
@property (nonatomic, assign, getter=isRecording)BOOL recording;
@property (nonatomic, assign, getter=isSwitched)BOOL switched;
@property (nonatomic, assign, getter=isPaused)BOOL paused;
@property (nonatomic, assign, getter=isMuted)BOOL muted;
@property (nonatomic, assign, getter=isVoiceDown)BOOL voiceDown;
@property (nonatomic, assign, getter=isHomeOn)BOOL homeOn;
@property (nonatomic, assign)MeariDeviceSleepmode sleepmodeType;

@property (nonatomic, assign) BOOL gotStorage;
@property (nonatomic, assign) BOOL gotMotion;
@property (nonatomic, assign) BOOL gotSleepmode;
@property (nonatomic, assign) BOOL gotVolume;
@property (nonatomic, assign) BOOL needRefreshTimebar;
@property (nonatomic, assign) BOOL reconnectDevice;
@property (nonatomic,   copy) NSString *recordVideoPath;
@property (nonatomic, assign) BOOL hasSDCard;;



@property (nonatomic, strong) NSTimer *bitrateTimer;
@property (nonatomic, strong) NSTimer *sdcardTimeTimer;
@property (nonatomic, strong) NSTimer *timeBarTimer;
@property (nonatomic, strong) NSTimer *volumeTimer;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic, strong) NSTimer *trhTimer;
@property (nonatomic, strong) NSTimer *musicStateTimer;
@property (nonatomic, strong) NSTimer *connectTimeoutTimer;

@end



@implementation WYCameraVideoOneVC

#pragma mark - getter
- (UIBarButtonItem *)hdItem {
    if (!_hdItem) {
        _hdItem = [UIBarButtonItem hdTextItemWithTarget:self action:@selector(hdAction:)];
        if (self.camera.isIpcBaby) {
            [_hdItem setTitleTextAttributes:@{NSForegroundColorAttributeName:WY_FontColor_DarkOrange} forState:UIControlStateNormal];
        }
    }
    return _hdItem;
}
- (UIBarButtonItem *)sdItem {
    if (!_sdItem) {
        _sdItem = [UIBarButtonItem sdTextItemWithTarget:self action:@selector(sdAction:)];
        if (self.camera.isIpcBaby) {
            [_sdItem setTitleTextAttributes:@{NSForegroundColorAttributeName:WY_FontColor_DarkOrange} forState:UIControlStateNormal];
        }
    }
    return _sdItem;
}
- (UIBarButtonItem *)settingItem {
    if (!_settingItem) {
        if (self.camera.info.needUpdate) {
            _settingItem = [UIBarButtonItem settingRedImageItemWithTarget:self action:@selector(settingAction:)];
        }else {
            _settingItem = [UIBarButtonItem settingImageItemWithTarget:self action:@selector(settingAction:)];
        }
    }
    return _settingItem;
}
- (UIBarButtonItem *)sdcardItem {
    if (!_sdcardItem) {
        _sdcardItem = [UIBarButtonItem sdCardImageItemWithTarget:self action:@selector(sdcardAction:)];
        if (self.camera.isIpcBaby) {
            _sdcardItem = [UIBarButtonItem sdCardImageBabyItemWithTarget:self action:@selector(sdcardAction:)];
        }
    }
    return _sdcardItem;
}
- (UIBarButtonItem *)nvrItem {
    if (!_nvrItem) {
        _nvrItem = [UIBarButtonItem nvrImageItemWithTarget:self action:@selector(nvrAction:)];
        if (self.camera.isIpcBaby) {
            _nvrItem = [UIBarButtonItem nvrImageBabyItemWithTarget:self action:@selector(nvrAction:)];
        }
    }
    return _nvrItem;
}
- (WYCameraVideoView *)videoView {
    if (!_videoView) {
        WYCameraVideoView *view = [WYCameraVideoView new];
        view.backgroundColor = [UIColor blackColor];
        view.viewController = self;
        view.bitStreamView.delegate = self;
        [self.view addSubview:view];
        _videoView = view;
    }
    return _videoView;
}

- (UIImageView *)deviceTypeImageView {
    return self.toolView.previewView.deviceTypeImageView;
}
- (WYCameraSegment *)segmentView {
    if (!_segmentView) {
        WYCameraSegment *view = [[WYCameraSegment alloc] initWithVideoType:_transionType];
        [self.view addSubview:view];
        _segmentView = view;
    }
    return _segmentView;
}
- (MeariPlayView *)drawableView {
    return self.videoView.drawableView;
}
- (WYCameraToolView *)toolView {
    if (!_toolView) {
        WYCameraToolView *view = [[WYCameraToolView alloc] initWithVideoType:_transionType deviceType:self.camera.info.subType];
        [self.view addSubview:view];
        _toolView = view;
    }
    return _toolView;
}
- (WYCameraToolBar *)toolBar {
    if (!_toolBar) {
        WYCameraToolBar *v = [[WYCameraToolBar alloc] initWithVideoType:_transionType needMusic:!self.camera.info.shared fullDuplex:self.camera.supportFullDuplex];
        [self.view addSubview:v];
        _toolBar = v;
        self.videoView.toolBar = _toolBar;
    }
    return _toolBar;
}

- (WYCameraToolPlaybackTimeBarView *)timeBar {
    return self.toolView.playbackView.timeBarView;
}
- (WYCameraToolPlaybackPictureBarView *)pictureBar {
    return self.toolView.playbackView.pictureBarView;
}
- (WYCameraToolPlaybackAlarmMessageView *)alarmBar {
    return self.toolView.playbackView.alarmMsgView;
}

- (NSTimer *)bitrateTimer {
    if (!_bitrateTimer) {
        _bitrateTimer = [NSTimer timerInLoopWithInterval:1.0f target:self selector:@selector(timerToSetBitrate:)];
    }
    return  _bitrateTimer;
}
- (NSTimer *)sdcardTimeTimer {
    if (!_sdcardTimeTimer) {
        _sdcardTimeTimer = [NSTimer timerInLoopWithInterval:2 target:self selector:@selector(timerToSDCardTime:)];
    }
    return _sdcardTimeTimer;
}
- (NSTimer *)timeBarTimer {
    if (!_timeBarTimer) {
        _timeBarTimer = [NSTimer timerInLoopWithInterval:60 target:self selector:@selector(timerToRefreshTimeBar:)];
    }
    return _timeBarTimer;
}
- (NSTimer *)volumeTimer {
    if (!_volumeTimer) {
        _volumeTimer = [NSTimer timerInLoopWithInterval:0.5 target:self selector:@selector(timerToRefreshVolume:)];
    }
    return _volumeTimer;
}
- (NSTimer *)backgroundTimer {
    if (!_backgroundTimer) {
        _backgroundTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToBackground:)];
    }
    return _backgroundTimer;
}
- (NSTimer *)trhTimer {
    if (!_trhTimer) {
        _trhTimer = [NSTimer timerInLoopWithInterval:10 target:self selector:@selector(timerToGetTRH:)];
    }
    return _trhTimer;
}
- (NSTimer *)musicStateTimer {
    if (!_musicStateTimer) {
        _musicStateTimer = [NSTimer timerInLoopWithInterval:2 target:self selector:@selector(timerToGetMusicState:)];
    }
    return _musicStateTimer;
}
- (NSTimer *)connectTimeoutTimer {
    if (!_connectTimeoutTimer) {
        _connectTimeoutTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToStopConnect:)];
    }
    return _connectTimeoutTimer;
}

#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_backed ||
        !self.wy_isTop) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate {
    if (_backed ||
        !self.wy_isTop ||
        _visitorCalling) {
        return NO;
    }
    return YES;
}
- (void)updateViewConstraints {
    WY_WeakSelf
    [self.segmentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(weakSelf.segmentH));
    }];
    [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.segmentView.mas_bottom);
        if (weakSelf.isLandscaped) {
            make.height.equalTo(weakSelf.view);
        }else {
            make.height.equalTo(weakSelf.videoView.mas_width).multipliedBy(9.0/16);
        }
    }];
    [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(weakSelf.toolViewH));
        make.top.equalTo(weakSelf.videoView.mas_bottom).with.offset(weakSelf.toolViewT);
    }];
    [self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(weakSelf.toolBarH));
        make.leading.equalTo(weakSelf.view).with.offset(weakSelf.toolBarLR);
        make.trailing.equalTo(weakSelf.view).with.offset(-1*weakSelf.toolBarLR);
        make.bottom.equalTo(weakSelf.view).with.offset(weakSelf.toolBarB);
    }];
    [super updateViewConstraints];
}

#pragma mark - Notification
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_DidChangeStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_DidChangeStatusBarOrientation:) name:@"Forced to switch the screen" object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_SystemVolumeDidChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_DidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_WillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_App_DidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_Device_ChangeNickname:) name:WYNotification_Device_ChangeNickname object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_Device_ConnectCompleted:) name:WYNotification_Device_ConnectCompleted object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_Device_CancelShare:) name:WYNotification_Device_CancelShare object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_Device_OnOffline:) name:WYNotification_Device_OnOffline object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_User_LandInOtherPlace:) name:WYNotification_User_LandInOtherPlace object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_Device_VisitorCallShow:) name:WYNotification_Device_VisitorCallShow object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_Device_VisitorCallDismiss:) name:WYNotification_Device_VisitorCallDismiss object:nil];
}
- (void)removeNotification {
    [WY_NotificationCenter removeObserver:self];
}
- (void)n_App_DidChangeStatusBarOrientation:(NSNotification *)sender {
    UIInterfaceOrientation oriention = [[UIApplication sharedApplication] statusBarOrientation];
    switch (oriention) {
        case UIInterfaceOrientationPortrait: {
            [self dealOrientationPortrait];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            [self dealOrientationLandscape];
            break;
        }
        case UIInterfaceOrientationLandscapeRight: {
            [self dealOrientationLandscape];
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            [self dealOrientationPortrait];
            break;
        }
        default:
            break;
    }
}
- (void)dealOrientationLandscape {
    if (self.isLandscaped) return;
    self.landscaped = YES;
    self.navigationController.navigationBarHidden = YES;
    [self initSetLandscape];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsLayout];
}
- (void)dealOrientationPortrait {
    self.landscaped = NO;
    self.navigationController.navigationBarHidden = NO;
    [self initSetPortraint];
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
}
- (void)n_App_SystemVolumeDidChange:(NSNotification *)sender {
    BOOL manChanged = [sender.userInfo[@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"];
    if (!manChanged) return;
    
    CGFloat volume = [sender.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (volume <= 0) {
        [self.toolBar setButton:WYCameraToolBarButtonTypeMute selected:NO];
    }else {
        if (!self.isMuted) {
            [self.toolBar setButton:WYCameraToolBarButtonTypeMute selected:YES];
        }
    }
}
- (void)n_App_DidEnterBackground:(NSNotification *)sender {
    [self stopPlaySuccess:nil];
    [self enabledBackgroundTimer:YES];
}
- (void)n_App_WillResignActive:(NSNotification *)sender {
    [self stopPlaySuccess:nil];
}
- (void)n_Device_VisitorCallShow:(NSNotification *)sender {
    _visitorCalling = YES;
    [self enabledConnectTimtoutStateTimer:NO];
    [self stopPlaySuccess:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoView showLoadingFailed];
    });
}
- (void)n_Device_VisitorCallDismiss:(NSNotification *)sender {
    _visitorCalling = NO;
    [self cameraReplayWithVideoview:self.videoView];
}
- (void)n_App_DidBecomeActive:(NSNotification *)sender {
    [self cameraReplayWithVideoview:self.videoView];
    [self enabledBackgroundTimer:NO];
}
- (void)n_Device_ChangeNickname:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.camera.info.ID) return;
    self.camera.info.nickname = device.nickname;
    self.navigationItem.title = device.nickname;
}
- (void)n_Device_ConnectCompleted:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!self.wy_isTop || ![device.camerap isEqualToString:[NSString stringWithFormat:@"%p",self.camera]]) return;
    if (!device || device.deviceID != self.camera.info.ID) return;
    MeariDeviceType deviceType = device.deviceType;
    if (device.connectSuccess) {
        [self enabledConnectTimtoutStateTimer:NO];
        switch (deviceType) {
            case MeariDeviceTypeIpc: {
                switch (self.videoType) {
                    case WYVideoTypePreviewHD: {
                        [self startPreviewHD];
                        break;
                    }
                    case WYVideoTypePreviewSD: {
                        [self startPreviewSD];
                        break;
                    }
                    case WYVideoTypePlaybackSDCard: {
                        [self startPlaybackSDCard];
                        break;
                    }
                    default:
                        break;
                }
                
                break;
            }
            case MeariDeviceTypeNVR: {
                switch (self.videoType) {
                    case WYVideoTypePlaybackNVR: {
                        [self startPlacbackNVR];
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
        
    }else {
        if (_reconnectDevice && !self.camera.sdkLogined) {
            [self.camera wy_startConnectSuccess:nil failure:nil];
            return;
        } else if(!_reconnectDevice){
            [self enabledConnectTimtoutStateTimer:NO];
        }
        WY_WeakSelf
        WYBlock_Void showFail = ^{
            [SVProgressHUD wy_showToast:device.connectDescription];
            [weakSelf.videoView showLoadingFailed];
            [[MeariUser sharedInstance] cancelAllRequest];
        };
        switch (deviceType) {
            case MeariDeviceTypeIpc: {
                [weakSelf enabledBitrateTimer:NO];
                switch (self.videoType) {
                    case WYVideoTypePreviewHD:
                    case WYVideoTypePreviewSD:
                    case WYVideoTypePlaybackSDCard: {
                        showFail();
                        break;
                    }
                    default:
                        break;
                }
                
                break;
            }
            case MeariDeviceTypeNVR: {
                [weakSelf enabledSDCardTimeTimer:NO];
                switch (self.videoType) {
                    case WYVideoTypePlaybackNVR: {
                        showFail();
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
}
- (void)n_Device_CancelShare:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.camera.info.ID) return;
    
    if (self.wy_isTop) {
        [WYAlertView show_Device_CancelShare:self.camera.info.nickname];
        [self wy_popToRootVC];
    }
}
- (void)n_Device_OnOffline:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.camera.info.ID) return;
    
    [self stopPlaySuccess:nil];
    [self.videoView showLoadingFailed];
}
- (void)n_User_LandInOtherPlace:(NSNotification *)sender {
    _landInOtherPlace = YES;
    [self stopPlaySuccess:nil];
    [self.camera stopConnectSuccess:nil failure:nil];
    [self.nvr stopConnectSuccess:nil failure:nil];
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initAdvancedSet];
    [self initLayout];
    [self initNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WY_WeakSelf
    WY_CameraM.babyMonitor = self.camera.isIpcBaby;
    if (_firstAppear) {
        [self preparePlay];
        _firstAppear = NO;
    }else {
        if (_gotosleepmode) {
            _gotosleepmode = NO;
            
            [self.camera stopConnectSuccess:^{
                [weakSelf startPlay];
            } failure:^(NSError *error) {
                [weakSelf startPlay];
            }];
        }else {
            if (!_landInOtherPlace) {
                [self startPlay];

            }
        }
    }
    [self enabledMusicStateTimer:NO];
}
- (void)preparePlay {
    WY_WeakSelf
    if (self.camera.isIpcBell) {
        [self.videoView showLoading];
        [self resetNavigationItemWithVideoType:_transionType];
        [self remoteWakeDoorbellSuccess:^{
            weakSelf.videoType = _transionType;
        } failure:^{
            [weakSelf.videoView showLoadingFailed];
        }];
    } else {
        self.videoType = _transionType;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    WY_CameraM.babyMonitor = NO;
    
    if (_backed) {
        _backed = NO;
        [self removeAllTimers];
        [[MeariUser sharedInstance] cancelAllRequest];
        [self stopPlaySuccess:nil];
        [self.camera stopConnectSuccess:nil failure:nil];
        [self.nvr stopConnectSuccess:nil failure:nil];
        [self.camera reset];
        [self.nvr reset];
        self.camera = nil;
        self.nvr = nil;
    }else {
        [self stopPlaySuccess:nil];
    }
    if (WY_IsKindOfClass(self.navigationController.topViewController, WYBabyMonitorMusicVC)) {
        [self enabledMusicStateTimer:YES];
        self.musicVC = (WYBabyMonitorMusicVC *)self.navigationController.topViewController;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)deallocAction {
    [self removeNotification];
}

#pragma mark - Init
- (void)initSet {
    WY_CameraM.babyMonitor = self.camera.isIpcBaby;
    self.navigationItem.title = self.camera.info.nickname;
    _previewType = WYVideoTypePreviewHD;
    _placbackType = (self.nvr ? WYVideoTypePlaybackNVR : WYVideoTypePlaybackSDCard);
    _firstAppear = YES;
    self.voiceDown = NO;
    self.switched = NO;
    self.segmentView.delegate = self;
    self.videoView.delegate = self;
    self.toolView.delegate = self;
    self.toolBar.delegate = self;
    if (self.camera.isIpcBell) {
        self.pictureBar.delegate = self;
    } else {
        self.timeBar.delegate = self;
    }
    self.alarmBar.delegate = self;
    [self.toolView setSettingHidden:self.camera.info.shared];
    [self.deviceTypeImageView wy_setImageWithURL:[NSURL URLWithString:self.camera.info.iconUrl] placeholderImage:[UIImage placeholder_device_image]];
    [self initSetPortraint];
}
- (void)initSetPortraint {
    self.segmentH = 51;
    self.toolBarH = 60;
    self.toolBarLR = 0;
    self.toolBarB = WY_SAFE_BOTTOM_LAYOUT;
    self.toolViewH = WY_ScreenHeight-self.segmentH-self.toolBarH-WY_ScreenWidth*9/16-WY_TopBar_H;
    self.toolViewT = 0;
    WYVideoType tmp = !_videoType ? _transionType : _videoType;
    self.toolBar.screenType = (!tmp || tmp == WYVideoTypePreviewHD || tmp == WYVideoTypePreviewSD || tmp == WYVideoTypePreviewAT) ? WYCameraToolBarPreviewTypeP : WYCameraToolBarPlaybackTypeP ;
    self.deviceTypeImageView.hidden = NO;
    self.toolView.previewView.hidden = NO;
    if (self.camera.isIpcBaby && !self.camera.info.shared) {
        [self.toolBar hiddenButton:WYCameraToolBarButtonTypeMusic hidden:NO];
    }
    if (self.needRefreshTimebar) {
        self.timeBar.videoTimes = self.timeBar.videoTimes;
    }
}
- (void)initSetLandscape {
    self.segmentH = 0;
    self.toolViewH = 0;
    self.toolViewT = 100;
    self.toolBarH = 49;
    self.toolBarLR = WY_ScreenWidth*0.2;
    self.toolBarB = WY_iPhone_4 ? -10 : -20;
    self.toolBar.screenType = (!_videoType || _videoType == WYVideoTypePreviewHD || _videoType == WYVideoTypePreviewSD || _videoType == WYVideoTypePreviewAT) ? WYCameraToolBarPreviewTypeL : WYCameraToolBarPlaybackTypeL ;
    self.deviceTypeImageView.hidden = YES;
    self.toolView.previewView.hidden = YES;
    if (self.camera.isIpcBaby) {
        [self.toolBar hiddenButton:WYCameraToolBarButtonTypeMusic hidden:YES];
    }
}
- (void)initAdvancedSet {
    if (_transionType == WYVideoTypePlaybackNVR ||
        _transionType == WYVideoTypePlaybackSDCard) {
        self.toolView.previewView.hidden = YES;
    }
}
- (void)initLayout {
    WY_WeakSelf
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@(weakSelf.segmentH));
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.videoView.mas_width).multipliedBy(9.0/16);
        make.top.equalTo(weakSelf.segmentView.mas_bottom);
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.videoView.mas_bottom).with.offset(weakSelf.toolViewT);
        make.height.equalTo(@(weakSelf.toolViewH));
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(weakSelf.toolBarH));
        make.leading.equalTo(weakSelf.view).with.offset(weakSelf.toolBarLR);
        make.trailing.equalTo(weakSelf.view).with.offset(-1*weakSelf.toolBarLR);
        make.bottom.equalTo(weakSelf.view).with.offset(weakSelf.toolBarB);
    }];
}



#pragma mark - Action
- (void)backAction:(UIButton *)sender {
    
    _backed = YES;
    
    [WY_Calendar resetAll];
    self.toolView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self wy_pop];
    });
}
- (void)previewAction:(UIButton *)sender {
    
    self.videoType = _previewType;
}
- (void)playbackAction:(UIButton *)sender {
    
    self.videoType = _placbackType;
}
- (void)hdAction:(UIButton *)sender {
    
    if (self.isHomeOn) return;
    
    self.switched = YES;
    self.videoType = WYVideoTypePreviewSD;
    self.switched = NO;
}
- (void)sdAction:(UIButton *)sender {
    
    if (self.isHomeOn) return;
    
    self.switched = YES;
    self.currentComponents = [NSDateComponents todayZero];
    self.videoType = WYVideoTypePreviewHD;
    self.switched = NO;
}
- (void)settingAction:(UIButton *)sender {
    [self wy_pushToVC:WYVCTypeCameraSetting sender:self.camera];
}
- (void)sdcardAction:(UIButton *)sender {
 
}
- (void)nvrAction:(UIButton *)sender {

}

#pragma mark - Timer
- (void)enabledBitrateTimer:(BOOL)enabled {
    if (enabled) {
        if (!_bitrateTimer) {
            
            [self.bitrateTimer fire];
        }
    }else {
        if (_bitrateTimer) {
            
            [_bitrateTimer invalidate];
            _bitrateTimer = nil;
        }
    }
}
- (void)enabledSDCardTimeTimer:(BOOL)enabled {
    if (enabled) {
        if (!_sdcardTimeTimer) {
            
            [self sdcardTimeTimer];
        }
    }else {
        if (_sdcardTimeTimer) {
            
            [_sdcardTimeTimer invalidate];
            _sdcardTimeTimer = nil;
        }
    }
}
- (void)enabledTimeBarTimer:(BOOL)enabled {
    if (enabled) {
        if (!_timeBarTimer) {
            
            [self timeBarTimer];
        }
    }else {
        if (_timeBarTimer) {
            
            [_timeBarTimer invalidate];
            _timeBarTimer = nil;
        }
    }
}
- (void)enabledVolumeTimer:(BOOL)enabled {
    if (enabled) {
        if (!_volumeTimer) {
//
            [self.volumeTimer fire];
        }
    }else {
        if (_volumeTimer) {
//
            [_volumeTimer invalidate];
            _volumeTimer = nil;
        }
    }
}
- (void)enabledBackgroundTimer:(BOOL)enabled {
    if (enabled) {
        if (!_backgroundTimer) {
            
            _backgroundCount = 0;
            [self.backgroundTimer fire];
        }
    }else {
        if (_backgroundTimer) {
            
            _backgroundCount = 0;
            [_backgroundTimer invalidate];
            _backgroundTimer = nil;
        }
    }
}
- (void)enabledRTHTimer:(BOOL)enabled {
    if (enabled) {
        if (!_trhTimer) {
            
            [self.trhTimer fire];
        }
    }else {
        if (_trhTimer) {
            
            [_trhTimer invalidate];
            _trhTimer = nil;
        }
    }
}
- (void)enabledMusicStateTimer:(BOOL)enabled {
    if (enabled) {
        if (!_musicStateTimer) {
            
            [self.musicStateTimer fire];
        }
    }else {
        if (_musicStateTimer) {
            
            [_musicStateTimer invalidate];
            _musicStateTimer = nil;
        }
    }
}
- (void)enabledConnectTimtoutStateTimer:(BOOL)enabled {
    if (enabled) {
        if (!_connectTimeoutTimer) {
            
            self.reconnectDevice = YES;
            _connectTimeoutCount = 0;
            [self.connectTimeoutTimer fire];
        }
    }else {
        if (_connectTimeoutTimer) {
            _connectTimeoutCount = 0;
            self.reconnectDevice = NO;
            
            [_connectTimeoutTimer invalidate];
            _connectTimeoutTimer = nil;
        }
    }
}

- (void)timerToSetBitrate:(id)sender {
    [self.toolView.previewView setBitrate:[self.camera getBitrates]];
}
- (void)timerToSDCardTime:(id)sender {
    if (self.isDraggingTimeBar) return;
    
    MeariDevice *camera = self.nvr ? self.nvr : self.camera;
    BOOL sdcard = camera == self.camera;
    NSDateComponents *d = camera.playbackTime;
    
    if (d.year == 1970 || d.wy_days < self.currentComponents.wy_days) return;
    if (d && d.day > self.currentComponents.day) {
        [self refreshTimeBarWithDateComponent:d];
        return;
    }
    
    int second = d.secondsInday;
    self.currentComponents.hour   = second/3600;
    self.currentComponents.minute = second/60%60;
    self.currentComponents.second = second%60;
    if (self.camera.isIpcBell) {
//        [self.pictureBar highlightAlarmMsgAtSecond:second];
    } else {
        self.timeBar.progress = second/WYSecs_PerDay;
        [self.alarmBar highlightAlarmMsgAtSecond:second];
    }
    
}
- (void)timerToRefreshTimeBar:(id)sender {
    NSDateComponents *today = [NSDateComponents todayZero];
    if (self.currentComponents.day != today.day || self.currentComponents.month != today.month) {
        [self enabledTimeBarTimer:NO];
        return;
    }
    switch (self.videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD: {
            [self enabledTimeBarTimer:NO];
            break;
        }
        case WYVideoTypePlaybackSDCard:
        case WYVideoTypePlaybackNVR: {
            MeariDevice *camera = self.nvr ? self.nvr : self.camera;
            BOOL nvr = camera == self.nvr;
            BOOL sdcard = camera == self.camera;
            WY_WeakSelf
            [camera wy_getPlaybackVideoTimesWithYear:self.currentComponents.year month:self.currentComponents.month day:self.currentComponents.day success:^(NSArray *times) {
                if (!weakSelf) return;
                if (nvr && weakSelf.videoType != WYVideoTypePlaybackNVR) return ;
                if (sdcard && weakSelf.videoType != WYVideoTypePlaybackSDCard) return;
                weakSelf.timeBar.videoTimes = times;
                weakSelf.needRefreshTimebar = UIInterfaceOrientationIsLandscape(WY_Application.statusBarOrientation);
            } failure:^(NSError *error) {
            
            }];
            break;
        }
        default:
            break;
    }

}
- (void)timerToRefreshVolume:(id)sender {
    CGFloat progress = [self.camera getVoicetalkVolume];
    [WYCameraVoiceHUD setVoiceProgress:progress];
}
- (void)timerToBackground:(id)sender {
    _backgroundCount++;
    if (_backgroundCount >= 20) {
        [self.camera stopConnectSuccess:nil failure:nil];
        if (self.nvr) {
            [self.nvr stopConnectSuccess:nil failure:nil];
        }
        [self enabledBackgroundTimer:NO];
    }
}
- (void)timerToGetTRH:(id)sender {
    WY_WeakSelf
    [weakSelf.toolView.previewView showTRHLoading];
    [WYTaskManager obj:self.camera want:WYCom_TRH_Get doTaskSyn:^(WYTask *task) {
        [weakSelf.camera getTemperatureHumiditySuccess:^(CGFloat temperature, CGFloat humidty) {
            [task doSucees];
            [weakSelf.toolView.previewView showT:temperature rh:humidty];
        } failure:^(NSError *error) {
            [task doFinish];
            if (error.code == MeariDeviceCodeNoTemperatureAndHumiditySensor) {
                [weakSelf.toolView.previewView showTNone];
                [weakSelf.toolView.previewView showRHNone];
                [weakSelf enabledRTHTimer:NO];
            }else {
                [weakSelf.toolView.previewView showTFail];
                [weakSelf.toolView.previewView showRHFail];
            }
        }];
    }];
    
}
- (void)timerToGetMusicState:(id)sender {
    if (!self.camera.sdkLogined) return;
    
    static int tmp = 0;
    if (tmp >= 5) {
        tmp = 0;
    }
    if (tmp != 0) {
        tmp++;
        return;
    }
    
    WY_WeakSelf
    [self.camera wy_getMusicStateSuccess:^(WYBabymonitorMusicStateModel *musicState) {
        tmp = 0;
        weakSelf.musicVC.model = musicState;
    } failure:^(NSError *error) {
        tmp = 0;
    }];
}
- (void)timerToStopConnect:(id)sender {
    _connectTimeoutCount++;
    if ((_connectTimeoutCount == 12) || _connectTimeoutCount == 22) {
        if (self.camera.sdkLogined) return;
        [self.camera stopConnectSuccess:nil failure:nil];
        [self remoteWakeDoorbellSuccess:nil failure:nil];
        WY_HUD_SHOW_TOAST(WYLocalString(@"正在尝试重新连接。。。"))
    } else if (_connectTimeoutCount >= 30) {
        [self enabledConnectTimtoutStateTimer:NO];
        if (self.camera.sdkLogined) return;
        [self.camera stopConnectSuccess:nil failure:nil];
    }
}
- (void)fireTimers {
    [self removeTimers];
    switch (self.videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD: {
            [self enabledBitrateTimer:YES];
            if (self.camera.isIpcBaby) {
                [self enabledRTHTimer:YES];
            }
            break;
        }
        case WYVideoTypePlaybackSDCard:
        case WYVideoTypePlaybackNVR: {
            [self enabledSDCardTimeTimer:YES];
            [self enabledTimeBarTimer:YES];
            break;
        }
            
        default:
            break;
    }
}
- (void)removeTimers {
    [self enabledBitrateTimer:NO];
    [self enabledSDCardTimeTimer:NO];
    [self enabledTimeBarTimer:NO];
    [self enabledVolumeTimer:NO];
    [self enabledBackgroundTimer:NO];
    [self enabledRTHTimer:NO];
    [self enabledMusicStateTimer:NO];
}
- (void)removeAllTimers {
    [self removeTimers];
    [self enabledConnectTimtoutStateTimer:NO];
}

#pragma mark -- Utilities
- (void)refreshTimeBarWithDateComponent:(NSDateComponents *)dateC {
    WY_Calendar.currentDate = WY_Calendar.selectedDate = dateC;
    self.currentComponents.year   = dateC.year;
    self.currentComponents.month  = dateC.month;
    self.currentComponents.day    = dateC.day;
    self.currentComponents.hour   = 0;
    self.currentComponents.minute = 0;
    self.currentComponents.second = 0;
    self.timeBar.progress = 0.0f;
    [self.toolView.playbackView resetToNormal];
    BOOL nvr = self.videoType == WYVideoTypePlaybackNVR;
    MeariDevice *camera = nvr ? self.nvr : self.camera;
    WY_WeakSelf
    [camera wy_getPlaybackVideoTimesWithYear:self.currentComponents.year month:self.currentComponents.month day:self.currentComponents.day success:^(NSArray *times) {
        
        if (nvr) {
            if (!WYCanPlayNVR) return;
        }else {
            if (!WYCanPlaySDCard) return;
        }
        if (times.count <= 0) {
            WY_HUD_SHOW_Toast_VC(WYLocalString(@"status_noRecords"), weakSelf)
            if (weakSelf.camera.isIpcBell) {
                [weakSelf.pictureBar showStatus:WYCameraPlayBackPictureBarStatus_noData];
            }
        }else {
            if (weakSelf.camera.isIpcBell) {
                weakSelf.pictureBar.videoTimes = times;
            } else {
                weakSelf.timeBar.videoTimes = times;
                weakSelf.needRefreshTimebar = UIInterfaceOrientationIsLandscape(WY_Application.statusBarOrientation);
            }
            [weakSelf timerToSDCardTime:nil];
        }
    } failure:^(NSError *error) {
        WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_getPlaybackTimes"), weakSelf)
    }];
}
- (void)doIfCanOperate:(WYBlock_Void)operate {
    if (!self.camera.sdkLogined) return;
    WYDo_Block_Safe(operate)
}
- (void)doIfCanPlayMusic:(WYBlock_Void)operate {
    [self doIfCanOperate:^{
        if (!self.hasSDCard) {
            [WYAlertView showNoSDCardWithStytle:self.camera.wy_uiStytle];
            [self enabledMusicStateTimer:NO];
            return;
        }
        WYDo_Block_Safe(operate)
    }];
}

#pragma mark - 反向唤醒
- (void)remoteWakeDoorbellSuccess:(WYBlock_Void)success failure:(WYBlock_Void)failure {
    WY_WeakSelf
    [[MeariUser sharedInstance] remoteWakeUp:self.camera.info.ID success:^{
//        [weakSelf enabledConnectTimtoutStateTimer:YES];
        WYDo_Block_Safe_Main(success)
    } failure:^(NSError *error) {
        WYDo_Block_Safe_Main(failure)
    }];
}

#pragma mark - 切换模式
- (void)setVideoType:(WYVideoType)videoType {
    if (_videoType == videoType) return;
    
    if (!_firstAppear) {
        [self stopPlaySuccess:nil];
    }
    
    _videoType = videoType;
    switch (_videoType) {
        case WYVideoTypePreviewHD: {
            
            _previewType = _videoType;
            _isPreviewing = YES;
            break;
        }
        case WYVideoTypePreviewSD: {
            
            _previewType = _videoType;
            _isPreviewing = YES;
            break;
        }
        case WYVideoTypePlaybackSDCard: {
            
            _placbackType = _videoType;
            _isPreviewing = NO;
            break;
        }
        case WYVideoTypePlaybackNVR: {
            
            _placbackType = _videoType;
            _isPreviewing = NO;
            break;
        }
        default:
            break;
    }
    [self reset];
    [self startPlay];
}
- (void)reset {
//
    _paused = NO;
    _recording = NO;
    _voiceSpeaking = NO;
    _voiceDown = NO;
    _draggingTimeBar = NO;
    
    [WY_Calendar resetToToday];
    self.segmentView.videoType = self.toolView.videoType = self.toolBar.videoType = self.videoType;
    [self.toolBar reset];
    self.muted = YES;
    self.sleepmodeType = MeariDeviceSleepmodeLensOn;
    [self.toolView.previewView resetToNormal];
    [self.toolView.playbackView resetToNormal];
    [self resetNavigationItemWithVideoType:self.videoType];
    
}
- (void)resetNavigationItemWithVideoType:(WYVideoType)videoType {
    switch (videoType) {
        case WYVideoTypePreviewHD: {
            self.navigationItem.rightBarButtonItem =  self.settingItem;
            break;
        }
        case WYVideoTypePreviewSD: {
            self.navigationItem.rightBarButtonItem = self.settingItem;
            break;
        }
        case WYVideoTypePlaybackSDCard: {
            self.navigationItem.rightBarButtonItem = self.sdcardItem;
            break;
        }
        case WYVideoTypePlaybackNVR: {
            self.navigationItem.rightBarButtonItem = self.nvrItem;
            break;
        }
        default:
            break;
    }
}
- (void)setSDKParams {
    
    WY_WeakSelf
    //bitrate
    if (_isPreviewing) {
        [self enabledBitrateTimer:YES];
    }
    
    if (self.camera.isIpcBell) {
        [WYTaskManager obj:self.camera want:WYCom_Storage_Get doTaskSynOnce:^(WYTask *task) {
            [weakSelf.camera getParamsSuccess:^(MeariDeviceParam *params) {
                [task doSucees];
                [weakSelf.toolView.previewView setPIROpen:params.bell.pir.enable enabled:YES];
                [weakSelf.toolView.previewView setJingleBellOpen:params.bell.charm.enable enabled:YES];
                [self.toolView.previewView setShareEnabled:!weakSelf.camera.info.shared];
                [weakSelf.toolView.previewView setEnergy:[NSString stringWithFormat:@"%ld%%",params.bell.battery.percent]];
            } failure:^(NSError *error) {
                [task doFinish];
            }];
        }];
    } else {
        //sd卡
        [WYTaskManager obj:self.camera want:WYCom_Storage_Get doTaskSynOnce:^(WYTask *task) {
            [self.camera getStorageInfoSuccess:^(MeariDeviceParamStorage *storage) {
                [task doSucees];
                if (storage) {
                    weakSelf.hasSDCard = YES;
                }
            } failure:^(NSError *error) {
                [task doFinish];
            }];
        }];
        //alarm
        [WYTaskManager obj:self.camera want:WYCom_Motion_Get doTaskSynOnce:^(WYTask *task) {
            [self.toolView.previewView setAlarmLevel:MeariDeviceLevelNone enabled:!self.camera.info.shared];
            [self.camera getAlarmSuccess:^(MeariDeviceParamMotion *motion) {
                [task doSucees];
                [weakSelf.toolView.previewView setAlarmLevel:motion.level enabled:!weakSelf.camera.info.shared];
            } failure:^(NSError *error) {
                [task doFinish];
            }];
        }];
        //sleepmode
        [WYTaskManager obj:self.camera want:WYCom_Sleepmode_Get doTaskSynOnce:^(WYTask *task) {
            [self.toolView.previewView setSleepmode:MeariDeviceSleepmodeUnknown enabled:!weakSelf.camera.info.shared reset:YES];
            [self.camera getParamsSuccess:^(MeariDeviceParam *param) {
                [task doSucees];
                [weakSelf.toolView.previewView setSleepmodeParam:param enabled:!weakSelf.camera.info.shared reset:NO];
            } failure:^(NSError *error) {
                [task doFinish];
            }];
        }];
        if (self.camera.param.sleep) {
            [self.toolView.previewView setSleepmodeParam:self.camera.param enabled:!weakSelf.camera.info.shared reset:NO];
        }
        //share
        [self.toolView.previewView setShareEnabled:!self.camera.info.shared];
        if (self.camera.isIpcBaby) {
            //温湿度
            [self enabledRTHTimer:_isPreviewing];
            //音量
            [WYTaskManager obj:self.camera want:WYCom_OutVolume_Get doTaskSynOnce:^(WYTask *task) {
                [self.camera getOutputVolumeSuccess:^(CGFloat volume) {
                    [task doSucees];
                    weakSelf.musicVC.volume = volume;
                } failure:^(NSError *error) {
                    [task doFinish];
                    weakSelf.musicVC.volume = weakSelf.musicVC.volume;
                }];
            }];
        }
    }
    
}

#pragma mark - Play
#pragma mark -- StartPlay
- (void)startPlay {
    [self.videoView showLoading];
    switch (self.videoType) {
        case WYVideoTypePreviewHD: {
            
            if (self.isSwitched) {
                [self switchPreviewHD:YES];
            }else {
                [self.camera wy_startConnectSuccess:nil failure:nil];
            }
            break;
        }
        case WYVideoTypePreviewSD: {
            
            if (self.isSwitched) {
                [self switchPreviewHD:NO];
            }else {
                [self.camera wy_startConnectSuccess:nil failure:nil];
            }
            break;
        }
        case WYVideoTypePlaybackSDCard: {
            
            self.timeBar.progress = self.currentComponents.secondsInday/WYSecs_PerDay;
            WY_Calendar.selectedDate = self.currentComponents;
            [self.camera wy_startConnectSuccess:nil failure:nil];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            
            self.timeBar.progress = self.currentComponents.secondsInday/WYSecs_PerDay;
            WY_Calendar.selectedDate = self.currentComponents;
            [self.nvr wy_startConnectSuccess:nil failure:nil];
            break;
        }
        default:
            break;
    }
}
- (void)startPreviewHD {
    WY_WeakSelf
    if (WYCanPlayHD) {
        NSLog(@"Drawing on %p",self.drawableView);
        NSArray *arr = self.camera.supportVideoStreams;
        NSLog(@"support video stream %@",arr);
        [self.camera startPreview2:MeariDeviceVideoStream_720 success:^{
            [weakSelf setSDKParams];
            if (WYCanPlayHD && !_visitorCalling) {
                weakSelf.videoView.videoType = WYVideoTypePreviewHD;
                weakSelf.sleepmodeType = MeariDeviceSleepmodeLensOn;
            }else {
                [weakSelf stopPreviewHDSuccess:nil];
            }
        } receiveStreamData:^(u_int8_t *buffer,MeariDeviceStreamType type, MEARIDEV_MEDIA_HEADER_PTR header, int bufferSize) {
            NSLog(@"receiveStreamData type:%d width:%d height:%d bufferSize:%d",type,header->video.width << 3,header->video.height << 3,bufferSize);
        } failure:^(NSError *error) {
            if (WYCanPlayHD) {
                if (error.code == MeariDeviceCodePreviewIsPlaying) {
                    [weakSelf.videoView hideLoading];
                }else {
                    [weakSelf removeTimers];
                    [weakSelf.videoView showLoadingFailed];
                }
            }
        } close:^(MeariDeviceSleepmode sleepmodeType) {
            [weakSelf setSDKParams];
            if (WYCanPlayHD) {
                weakSelf.sleepmodeType = sleepmodeType;
            }
        }];
    }
}
- (void)startPreviewSD {
    WY_WeakSelf
    
    if (WYCanPlaySD) {
        NSArray *arr = self.camera.supportVideoStreams;
        NSLog(@"support video stream %@",arr);
        [self.camera startPreview2:MeariDeviceVideoStream_360 success:^{
            [weakSelf setSDKParams];
            if (WYCanPlaySD && !_visitorCalling) {
                weakSelf.videoView.videoType = WYVideoTypePreviewSD;
                weakSelf.sleepmodeType = MeariDeviceSleepmodeLensOn;
            }else {
                [weakSelf stopPreviewSDSuccess:nil];
            }
        } receiveStreamData:^(u_int8_t *buffer,MeariDeviceStreamType type, MEARIDEV_MEDIA_HEADER_PTR header, int bufferSize) {
            NSLog(@"receiveStreamData %d %@ %d",type,header,bufferSize);
        } failure:^(NSError *error) {
            if (WYCanPlaySD) {
                if (error.code == MeariDeviceCodePreviewIsPlaying) {
                    [weakSelf.videoView hideLoading];
                }else {
                    [weakSelf removeTimers];
                    [weakSelf.videoView showLoadingFailed];
                }
            }
        } close:^(MeariDeviceSleepmode sleepmodeType) {
            [weakSelf setSDKParams];
            if (WYCanPlaySD) {
                weakSelf.sleepmodeType = sleepmodeType;
            }
        }];
    }
}
- (void)startPlaybackSDCard {
    self.timeBar.progress = self.currentComponents.secondsInday/WYSecs_PerDay;
    WY_WeakSelf
    if (WYCanPlaySDCard) {
        [self.camera wy_getPlaybackVideoTimesWithYear:self.currentComponents.year month:self.currentComponents.month day:self.currentComponents.day success:^(NSArray *times) {
            
            if (!weakSelf) return ;
            
            if (times.count <= 0) {
                if (WYCanPlaySDCard) {
                    [weakSelf.videoView hideLoading];
                    WY_HUD_SHOW_Toast_VC(WYLocalString(@"status_noRecords"), weakSelf)
                    if (weakSelf.camera.isIpcBell) {
                        [weakSelf.pictureBar showStatus:WYCameraPlayBackPictureBarStatus_noData];
                    }
                }
                return;
            }
            if (WYCanPlaySDCard && times.count > 0) {
                if (self.camera.isIpcBell) {
                    weakSelf.pictureBar.videoTimes = times;
                    weakSelf.currentComponents = [weakSelf.pictureBar latestVideoTimeNearTime:weakSelf.currentComponents];
                } else {
                    weakSelf.timeBar.videoTimes = times;
                    weakSelf.needRefreshTimebar = UIInterfaceOrientationIsLandscape(WY_Application.statusBarOrientation);
                    weakSelf.currentComponents = [weakSelf.timeBar latestVideoTimeNearTime:weakSelf.currentComponents];
                    if ([weakSelf.timeBar hasVideoAtSecond:weakSelf.currentComponents.secondsInday-5]) {
                        weakSelf.currentComponents.second = weakSelf.currentComponents.second-5 > 0 ? weakSelf.currentComponents.second - 5 : 0;
                    }
                    weakSelf.timeBar.progress = weakSelf.currentComponents.secondsInday/WYSecs_PerDay;
                }
                [[MeariUser sharedInstance] getAlarmMessageTimes:weakSelf.camera.info.ID onDate:weakSelf.currentComponents.dayStringWithNoSprit success:^(NSArray<NSString *> *ipcTimes, NSArray<NSString *> *bellTimes, NSArray<NSString *> *cryTimes) {
                    if (weakSelf.camera.info.subType == MeariDeviceSubTypeIpcBell ||weakSelf.camera.info.subType == MeariDeviceSubTypeIpcBattery) {
                        if (ipcTimes.count) {
                            NSMutableArray *alarmArr = [NSMutableArray arrayWithCapacity:ipcTimes.count];
                            for (NSString *str in ipcTimes) {
                                WYCameraTime *time = [WYCameraTime timeWithAlarmTimeString:str];
                                [alarmArr addObject:time];
                            }
                            weakSelf.pictureBar.alarmTimes = alarmArr;
                        } else {
                            weakSelf.pictureBar.alarmTimes = ipcTimes;
                        }
                        if (bellTimes.count) {
                            NSMutableArray *alarmArr = [NSMutableArray arrayWithCapacity:bellTimes.count];
                            for (NSString *str in bellTimes) {
                                WYCameraTime *time = [WYCameraTime timeWithAlarmTimeString:str];
                                [alarmArr addObject:time];
                            }
                            weakSelf.pictureBar.visitorTimes = alarmArr;
                        } else {
                            weakSelf.pictureBar.visitorTimes = bellTimes;
                        }
                    } else {
                        if (ipcTimes.count > weakSelf.timeBar.alarmTimes.count) {
                            NSMutableArray *alarmArr = [NSMutableArray arrayWithCapacity:ipcTimes.count];
                            for (NSString *str in ipcTimes) {
                                WYCameraTime *time = [WYCameraTime timeWithAlarmTimeString:str];
                                [alarmArr addObject:time];
                            }
                            weakSelf.timeBar.alarmTimes = alarmArr;
                        }
                    }
                } failure:^(NSError *error) {
                    
                }];
                [weakSelf.camera startPlayback:weakSelf.currentComponents.timeStringWithNoSprit success:^{
                    [weakSelf setSDKParams];
                    if (WYCanPlaySDCard) {
                        [weakSelf.videoView hideLoading];
                        [weakSelf fireTimers];
                        [weakSelf.toolBar setButton:WYCameraToolBarButtonTypePlay selected:YES];
                    }else {
                        [weakSelf stopPlaybackSDCardSuccess:nil];
                    }
                    
                } receiveStreamData:^(u_int8_t *buffer,MeariDeviceStreamType type, MEARIDEV_MEDIA_HEADER_PTR header, int bufferSize) {
                    NSLog(@"receiveStreamData %d  %d",type,bufferSize);
                } failure:^(NSError *error) {
                    if (WYCanPlaySDCard) {
                        if (error.code == MeariDeviceCodePlaybackIsPlaying) {
                            [weakSelf.videoView hideLoading];
                        }else if (error.code == MeariDeviceCodePlaybackIsPlayingByOthers) {
                            [weakSelf.videoView showLoadingFailed];
                            WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_openVideo_otherPlaying"), weakSelf)
                        }else {
                            [weakSelf.videoView showLoadingFailed];
                            WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_openVideo"), weakSelf)
                        }
                    }
                }];
            }
        } failure:^(NSError *error) {
            [weakSelf removeTimers];
            if (WYCanPlaySDCard) {
                [weakSelf.videoView showLoadingFailed];
                WY_HUD_SHOW_Toast_VC(WYLocalString(@"status_noRecords"), weakSelf)
                if (weakSelf.camera.isIpcBell) {
                    [weakSelf.pictureBar showStatus:WYCameraPlayBackPictureBarStatus_failure];
                }
            }
        }];
    }
}
- (void)startPlacbackNVR {
    self.timeBar.progress = self.currentComponents.secondsInday/WYSecs_PerDay;
    WY_WeakSelf
    if (WYCanPlayNVR) {
        [self.nvr wy_getPlaybackVideoTimesWithYear:self.currentComponents.year month:self.currentComponents.month day:self.currentComponents.day success:^(NSArray *times) {
            if (times.count <= 0) {
                if (WYCanPlayNVR) {
                    [weakSelf.videoView hideLoading];
                    WY_HUD_SHOW_Toast_VC(WYLocalString(@"status_noRecords"), weakSelf)
                }
                return ;
            }
            if (WYCanPlayNVR && times.count > 0) {
                weakSelf.timeBar.videoTimes = times;
                weakSelf.needRefreshTimebar = UIInterfaceOrientationIsLandscape(WY_Application.statusBarOrientation);
                weakSelf.currentComponents = [weakSelf.timeBar latestVideoTimeNearTime:weakSelf.currentComponents];
                if ([weakSelf.timeBar hasVideoAtSecond:weakSelf.currentComponents.secondsInday-5]) {
                    weakSelf.currentComponents.second = weakSelf.currentComponents.second-5 > 0 ? weakSelf.currentComponents.second - 5 : 0;
                }
                weakSelf.timeBar.progress = weakSelf.currentComponents.secondsInday/WYSecs_PerDay;
                
                [weakSelf.nvr startPlayback:weakSelf.currentComponents.timeStringWithNoSprit success:^{
                    [weakSelf setSDKParams];
                    if (WYCanPlayNVR) {
                        [weakSelf.videoView hideLoading];
                        [weakSelf fireTimers];
                        [weakSelf.toolBar setButton:WYCameraToolBarButtonTypePlay selected:YES];
                    }else {
                        [weakSelf stopPlaybackNVRSuccess:nil];
                    }
                    
                } receiveStreamData:^(u_int8_t *buffer,MeariDeviceStreamType type, MEARIDEV_MEDIA_HEADER_PTR header, int bufferSize) {
                    NSLog(@"receiveStreamData %d %d",type,bufferSize);
                } failure:^(NSError *error) {
                    if (WYCanPlayNVR) {
                        if (error.code == MeariDeviceCodePlaybackIsPlaying) {
                            [weakSelf.videoView hideLoading];
                        }else if (error.code == MeariDeviceCodePlaybackIsPlayingByOthers) {
                            [weakSelf.videoView showLoadingFailed];
                            WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_openVideo_otherPlaying"), weakSelf)
                        }else {
                            if (![_sdcardTimeTimer isValid]) {
                                [weakSelf.videoView showLoadingFailed];
                                WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_openVideo"), weakSelf)
                            }
                        }
                    }
                }];
            }
        } failure:^(NSError *error) {
            if (WYCanPlayNVR) {
                if (![_sdcardTimeTimer isValid]) {
                    [weakSelf.videoView showLoadingFailed];
                    WY_HUD_SHOW_Toast_VC(WYLocalString(@"status_noRecords"), weakSelf)
                }
            }
        }];
    }
}
- (void)switchPreviewHD:(BOOL)HD {
    WY_WeakSelf
    MeariDeviceVideoStream videoStream = HD ? MeariDeviceVideoStream_HD : MeariDeviceVideoStream_360;
    if (self.camera.sdkLogined) {
        [self.camera switchPreview:videoStream success:^{
            if (HD ? WYCanPlayHD : WYCanPlaySD) {
                weakSelf.videoView.videoType = HD? WYVideoTypePreviewHD:WYVideoTypePreviewSD;
                [weakSelf fireTimers];
                [weakSelf.videoView hideLoading];
            }
        } receiveStreamData:^(u_int8_t *buffer,MeariDeviceStreamType type, MEARIDEV_MEDIA_HEADER_PTR header, int bufferSize) {
            NSLog(@"receiveStreamData %d %d",type,bufferSize);
        } failure:^(NSError *error) {
            if (HD ? WYCanPlayHD : WYCanPlaySD) {
                [weakSelf.videoView showLoadingFailed];
            }
        }];
    }else {
        [self.camera wy_startConnectSuccess:nil failure:nil];
    }
    
}

#pragma mark -- Seek
- (void)startSeekSecond:(int)second {
    [self removeTimers];
    self.currentComponents.hour   = second/3600;
    self.currentComponents.minute = second/60%60;
    self.currentComponents.second = second%60;
    self.recording = NO;
    [self.videoView showLoading];
    switch (self.videoType) {
        case WYVideoTypePlaybackSDCard: {
            [self seekPlaybackSDCard];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            [self seekPlaybackNVR];
            break;
        }
        default:
            break;
    }
}
- (void)seekPlaybackSDCard {
    WY_WeakSelf
    if ([self.camera sdkPlayRecord]) {
        [self.camera seekPlaybackSDCardToTime:self.currentComponents.timeStringWithNoSprit success:^{
            if (WYCanPlaySDCard) {
                _paused = NO;
                [weakSelf.videoView hideLoading];
                [weakSelf.toolBar setButton:WYCameraToolBarButtonTypePlay selected:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(WYSeekDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (WYCanPlaySDCard) {
                        [weakSelf fireTimers];
                    }
                });
            }
        } failure:^(NSError *error) {
            if (WYCanPlaySDCard) {
                [weakSelf.videoView hideLoading];
            }
        }];
    }else {
        [self startPlay];
    }
}
- (void)seekPlaybackNVR {
    WY_WeakSelf
    if ([self.nvr sdkPlayRecord]) {
        [self.nvr seekPlaybackSDCardToTime:self.currentComponents.timeStringWithNoSprit success:^{
            if (WYCanPlayNVR) {
                _paused = NO;
                [weakSelf.videoView hideLoading];
                [weakSelf.toolBar setButton:WYCameraToolBarButtonTypePlay selected:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(WYSeekDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (WYCanPlayNVR) {
                        [weakSelf fireTimers];
                    }
                });
            }
        } failure:^(NSError *error) {
            if (WYCanPlayNVR) {
                [weakSelf.videoView hideLoading];
            }
        }];
    }else {
        [self startPlay];
    }
}

#pragma mark -- StopPlay
- (void)stopPlaySuccess:(WYBlock_Void)success  {
    self.voiceSpeaking = NO;
    self.recording = NO;
    [self removeTimers];
    [[MeariUser sharedInstance] cancelAllRequest];
    
    switch (self.videoType) {
        case WYVideoTypePreviewHD: {
            if (!self.isSwitched) {
                
                [self stopPreviewHDSuccess:success];
            }
            break;
        }
        case WYVideoTypePreviewSD: {
            if (!self.isSwitched) {
                
                [self stopPreviewSDSuccess:success];
            }
            break;
        }
        case WYVideoTypePlaybackSDCard: {
            
            [self stopPlaybackSDCardSuccess:success];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            
            [self stopPlaybackNVRSuccess:success];
            break;
        }
        default:
            break;
    }
}
- (void)stopPreviewHDSuccess:(WYBlock_Void)success {
    [self.camera stopPreviewSuccess:^{
        WYDo_Block_Safe_Main(success)
    } failure:^(NSError *error) {
        WYDo_Block_Safe_Main(success)
    }];
}
- (void)stopPreviewSDSuccess:(WYBlock_Void)success {
    [self stopPreviewHDSuccess:success];
}
- (void)stopPlaybackSDCardSuccess:(WYBlock_Void)success {
    MeariDevice *camera = self.nvr ? self.nvr : self.camera;
    [camera stopPlackbackSDCardSuccess:^{
        WYDo_Block_Safe_Main(success)
    } failure:^(NSError *error) {
        WYDo_Block_Safe_Main(success)
    }];
}
- (void)stopPlaybackNVRSuccess:(WYBlock_Void)success {
    [self stopPlaybackSDCardSuccess:success];
}

#pragma mark -- Operation
#pragma mark ----  playing
- (BOOL)isPlaying {
    switch (self.videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD: {
            return [self.camera sdkPlaying];
        }
        case WYVideoTypePlaybackSDCard: {
            return [self.camera sdkPlayRecord];
        }
        case WYVideoTypePlaybackNVR: {
            return [self.nvr sdkPlayRecord];
        }
        default:
            return NO;
    }
}
#pragma mark ----  voice
- (void)setVoiceSpeaking:(BOOL)voiceSpeaking {
    if (voiceSpeaking) {
        [self startVoiceSpeaking];
    }else {
        [self stopVoiceSpeaking];
    }
}
- (void)startVoiceSpeaking {
    if (!self.voiceDown) {
        return;
    }
    if (self.camera.supportFullDuplex) {
        [self.toolView.previewView.fullDuplexVoiceView prepareVoice];
    } else {
        [self showVoiceSpeaking:YES];
    }
    WY_WeakSelf
    [self.camera startVoiceTalkDefault:YES success:^{
        if (weakSelf.voiceDown) {
            if (weakSelf.camera.supportFullDuplex) {
                [weakSelf.toolView.previewView.fullDuplexVoiceView startVoiceTalking];
                [weakSelf.toolBar setButton:WYCameraToolBarButtonTypeVoice selected:YES];
            }
        }else {
            [weakSelf stopVoiceSpeaking];
        }
    } failure:^(NSError *error) {
        if (weakSelf.camera.supportFullDuplex) {
            [weakSelf.toolView.previewView.fullDuplexVoiceView stopVoiceTalking];
        } else {
            [self showVoiceSpeaking:NO];
        }
        if (WYCanPlayPreview) {
            WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_voiceSpeak"), weakSelf)
        }
    }];
}
- (void)stopVoiceSpeaking {
    if (self.camera.supportFullDuplex) {
        [self.toolView.previewView.fullDuplexVoiceView stopVoiceTalking];
        [self.toolBar setButton:WYCameraToolBarButtonTypeVoice selected:NO];
    } else {
        [self showVoiceSpeaking:NO];
    }
    [self.camera stopVoicetalkDefault:YES success:nil failure:nil];
}
- (void)showVoiceSpeaking:(BOOL)show {
    show ? [WYCameraVoiceHUD show:YES] : [WYCameraVoiceHUD hide:NO];
    [self enabledVolumeTimer:show];
}
#pragma mark ----  record
- (void)setRecording:(BOOL)recording {
    if(_recording == recording) return;
    _recording = recording;
    _recording ? [self startRecording] : [self stopRecording];
}
- (void)startRecording {
    
    WY_WeakSelf
    WYBlock_Void updateUI = ^{
        [weakSelf.videoView startRecordAnimation];
        [weakSelf.toolBar setButton:WYCameraToolBarButtonTypeRecord selected:YES];
    };
    
    NSString *path = [NSFileManager wy_videoFileWithSN:self.camera.info.sn];
    self.recordVideoPath = path;
    switch (self.videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD:
        case WYVideoTypePlaybackSDCard: {
            
            [self.camera startRecordMP4ToPath:path isPreviewing:_isPreviewing success:^{
                 updateUI();
            } recordInterrputed:^{
                weakSelf.recording = NO;
                [weakSelf.videoView stopRecordAnimation];
                [weakSelf.toolBar setButton:WYCameraToolBarButtonTypeRecord selected:NO];
            } failure:^(NSError *error) {
                 WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_startRecord"), weakSelf)
            }];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            [self.camera startRecordMP4ToPath:path isPreviewing:_isPreviewing success:^{
                updateUI();
            } recordInterrputed:^{
                weakSelf.recording = NO;
                [weakSelf.videoView stopRecordAnimation];
                [weakSelf.toolBar setButton:WYCameraToolBarButtonTypeRecord selected:NO];
            } failure:^(NSError *error) {
                WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_startRecord"), weakSelf)
            }];
            break;
        }
        default:
            break;
    }
}
- (void)stopRecording {
    
    WY_WeakSelf
    [weakSelf.videoView stopRecordAnimation];
    [weakSelf.toolBar setButton:WYCameraToolBarButtonTypeRecord selected:NO];
    switch (self.videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD:
        case WYVideoTypePlaybackSDCard: {
            [self.camera stopRecordMP4IsPreviewing:_isPreviewing success:^{
                [WY_PhotoM saveVideoAtPath:weakSelf.recordVideoPath success:^{
                    [WY_FileManager removeItemAtPath:weakSelf.recordVideoPath error:nil];
                    WY_HUD_SHOW_TOAST(WYLocalString(@"status_videoSaved"))
                } failure:^(NSError *error) {
                    WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_saveRecord"), weakSelf)
                }];
            } failure:^(NSError *error) {
                WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_saveRecord"), weakSelf)
            }];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            [self.nvr stopRecordMP4IsPreviewing:_isPreviewing success:^{
                WY_HUD_SHOW_TOAST(WYLocalString(@"status_videoSaved"))
            } failure:^(NSError *error) {
                WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_saveRecord"), weakSelf)
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark ----  pause
- (void)setPaused:(BOOL)paused {
    if (_paused == paused) return;
    _paused = paused;
    _paused ? [self startPause] : [self stopPause];
}
- (void)startPause {
    
    self.recording = NO;
    WY_WeakSelf
    WYBlock_Void updateUI = ^{
        [weakSelf removeTimers];
        [weakSelf.toolBar setButton:WYCameraToolBarButtonTypePlay selected:NO];
    };
    switch (self.videoType) {
        case WYVideoTypePlaybackSDCard: {
            [self.camera pausePlackbackSDCardSuccess:^{
                updateUI();
            } failure:^(NSError *error) {
                
            }];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            [self.nvr pausePlackbackSDCardSuccess:^{
                updateUI();
            } failure:nil];
            break;
        }
        default:
            break;
    }
}
- (void)stopPause {
    
    WY_WeakSelf
    WYBlock_Void updateUI = ^{
        [weakSelf.toolBar setButton:WYCameraToolBarButtonTypePlay selected:YES];
    };
    switch (self.videoType) {
        case WYVideoTypePlaybackSDCard: {
            [self.camera resumePlackbackSDCardSuccess:^{
                updateUI();
                [weakSelf enabledSDCardTimeTimer:YES];
                [weakSelf enabledTimeBarTimer:YES];
            } failure:nil];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            [self.nvr resumePlackbackSDCardSuccess:^{
                updateUI();
                [weakSelf enabledSDCardTimeTimer:YES];
                [weakSelf enabledTimeBarTimer:YES];
            } failure:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark ----  mute
- (void)setMuted:(BOOL)muted {
    
    [self.toolBar setButton:WYCameraToolBarButtonTypeMute selected:!muted];
    switch (self.videoType) {
        case WYVideoTypePreviewHD:
        case WYVideoTypePreviewSD:
        case WYVideoTypePlaybackSDCard: {
            [self.camera setMute:muted];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            [self.nvr setMute:muted];
            break;
        }
        default:
            break;
    }
}

#pragma mark ----  homeon
- (void)setSleepmodeType:(MeariDeviceSleepmode)sleepmodeType {
    
    _sleepmodeType = sleepmodeType;
    switch (sleepmodeType) {
        case MeariDeviceSleepmodeLensOff: {
            _homeOn = YES;
            [self.videoView showLoadingSleepmodeLensOff];
            break;
        }
        case MeariDeviceSleepmodeLensOffByTime: {
            _homeOn = YES;
            [self.videoView showLoadingSleepmodeLensOffByTime];
            break;
        }
        default: {
            _homeOn = NO;
            [self.videoView hideLoading];
            break;
        }
    }
    if (_homeOn) {
        [self removeTimers];
        self.recording = NO;
    }else {
        if (self.camera.sdkPlaying) {
            [self fireTimers];
        }
    }
    self.hdItem.enabled = !_homeOn;
    self.videoView.hdsdEnabled = self.hdItem.enabled;
    [self.toolBar setButton:WYCameraToolBarButtonTypeVoice enabled:!_homeOn];
    [self.toolBar setButton:WYCameraToolBarButtonTypeSnapshot enabled:!_homeOn];
    [self.toolBar setButton:WYCameraToolBarButtonTypeMusic enabled:!_homeOn];
    [self.toolBar setButton:WYCameraToolBarButtonTypeRecord enabled:!_homeOn];
    [self.toolBar setButton:WYCameraToolBarButtonTypeMute enabled:!_homeOn];
}

#pragma mark - Delegate
#pragma mark -- WYTransition 
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeMsgAlarmDetail:
        case WYVCTypeCameraList: {
            if (WY_IsKindOfClass(obj, WYVideo)) {
                WYVideo *video = (WYVideo *)obj;
                self.camera = video.camera.copy;
                self.nvr = self.camera.hasBindedNvr ? self.camera.nvrCamera : nil;
                [self.camera reset];
                [self.nvr reset];
                self.currentComponents = video.dateComponets ? video.dateComponets : [NSDateComponents todayZero];
                _transionType = video.videoType;
                WY_CameraM.babyMonitor = self.camera.isIpcBaby;
            }
            break;
        }
        case WYVCTypeCameraSettingShare: {
            _fromShare = YES;
            break;
        }
        default:
            break;
    }
}
#pragma mark -- WYCameraBitStreamViewDelegate
- (void)bitStreamView:(WYCameraBitStreamView *)view didSelectedStreamType:(WYVideoType)streamType {
    if (self.voiceDown) {
        self.voiceSpeaking = NO;
    }
    [self.videoView hideBitStreamView];
    if (_videoType == streamType) return;
    if (streamType == WYVideoTypePreviewHD) {
        [self sdAction:nil];
    } else if(streamType == WYVideoTypePreviewSD) {
        [self hdAction:nil];
    }
}

#pragma mark -- WYCameraSegmentDelegate
- (void)WYCameraSegment:(WYCameraSegment *)segment didSelectedIndex:(int)index {
    self.videoType = index == 0 ? _previewType : _placbackType;
    self.videoView.videoType = self.videoType;
}
#pragma mark -- WYCameraToolViewDelegate
- (void)WYCameraToolView:(WYCameraToolView *)toolView didScrolledType:(WYVideoType)type {
    self.videoType = toolView.previewed ? _previewType : _placbackType;
    self.videoView.videoType = self.videoType;
}

#pragma mark -- WYCameraVideoViewDelegate
- (void)WYCameraVideoViewReplay:(WYCameraVideoView *)videoView {
    
    [self cameraReplayWithVideoview:videoView];
}
- (void)cameraReplayWithVideoview:(WYCameraVideoView *)videoView {
    if (self.camera.isIpcBell && !self.camera.sdkLogined) {
        WY_WeakSelf
        [videoView showLoading];
        [self remoteWakeDoorbellSuccess:^{
            [weakSelf startPlay];
        } failure:^{
            [weakSelf.videoView showLoadingFailed];
        }];
    } else {
        [self startPlay];
    }
}
- (void)WYCameraVideoViewHD:(WYCameraVideoView *)videoView {
    
    [self hdAction:nil];
}
- (void)WYCameraVideoViewSD:(WYCameraVideoView *)videoView {
    
    [self sdAction:nil];
}
- (void)WYCameraVideoViewBitStreamView:(WYCameraVideoView *)videoView {
    if (self.voiceDown) {
        self.voiceSpeaking = NO;
    }
}
//云台
- (void)WYCameraVideoView:(WYCameraVideoView *)videoView swipe:(UISwipeGestureRecognizer *)swipeGesture {
    if (videoView.isEnlarged) return;
    if (self.isHomeOn) return;
    
    if (self.videoType == _previewType) {
        if ([self.camera sdkPlaying]) {
            switch (swipeGesture.direction) {
                case UISwipeGestureRecognizerDirectionUp: {
                    [self.camera startMoveToDirection:MeariMoveDirectionUp success:nil failure:nil];
                    break;
                }
                case UISwipeGestureRecognizerDirectionDown: {
                    [self.camera startMoveToDirection:MeariMoveDirectionDown success:nil failure:nil];
                    break;
                }
                case UISwipeGestureRecognizerDirectionLeft: {
                    [self.camera startMoveToDirection:MeariMoveDirectionLeft success:nil failure:nil];
                    break;
                }
                case UISwipeGestureRecognizerDirectionRight: {
                    [self.camera startMoveToDirection:MeariMoveDirectionRight success:nil failure:nil];
                    break;
                }
                default:
                    break;
            }
        }
    }
}
- (void)WYCameraVideoViewSwipeDidEnded:(WYCameraVideoView *)videoView {
    if (videoView.isEnlarged) return;
    if (self.isHomeOn) return;
    
    if (self.videoType == _previewType) {
        if ([self.camera sdkPlaying]) {
            [self.camera stopMoveSuccess:nil failure:nil];
        }
    }
}

#pragma mark -- WYCameraToolPreviewViewDelegate
- (BOOL)WYCameraToolPreviewViewAllowSetSleepmode {
    return YES;
}
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedAlarmButton:(UIButton *)button {
    
    if (![self.camera sdkLogined])return;
    
    WY_WeakSelf
    [WYTaskManager obj:self.camera want:WYCom_Motion_Set doTaskSyn:^(WYTask *task) {
        MeariDeviceLevel level = button.isSelected ? MeariDeviceLevelOff : weakSelf.camera.param.motion_detect.level;;
        [self.camera setAlarmLevel:level success:^(id obj) {
            [task doSucees];
            [weakSelf.toolView.previewView setAlarmLevel:level enabled:YES];
        } failure:^(NSError *error) {
            [task doFinish];
            if (WYCanPlayPreview) {
                WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_set"), weakSelf)
            }
        }];
    }];
}
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedSleepmodeButton:(UIButton *)button model:(WYCameraToolPreviewSleepmodeModel *)sleepmode originalType:(MeariDeviceSleepmode)originalType {
    WY_WeakSelf
    if (![self.camera sdkLogined])return;
    
    previewView.showMenu = NO;
    [self.camera setSleepmodeType:sleepmode.type success:^{
        [previewView setSleepmode:sleepmode.type enabled:YES reset:NO];
        if (WYCanPlayPreview) {
            WY_HUD_SHOW_Toast_VC(WYLocalString(@"success_set"), weakSelf)
        }
    } failure:^(NSError *error) {
        [previewView setSleepmode:originalType enabled:YES reset:NO];
        if (WYCanPlayPreview) {
            WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_set"), weakSelf)
        }
    }];
}
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedShareButton:(UIButton *)button {
    [self wy_pushToVC:WYVCTypeCameraSettingShare sender:self.camera];
}
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedPIRButton:(UIButton *)button {
    WY_WeakSelf
    MeariDeviceLevel level = button.selected ? MeariDeviceLevelOff : self.camera.param.bell.pir.level;
    [WYTaskManager obj:self.camera want:WYCom_Pir_Set doTaskSyn:^(WYTask *task) {
        [weakSelf.camera setDoorBellPIRLevel:level success:^{

            [task doSucees];
             WY_HUD_SHOW_Toast_VC(WYLocalString(@"success_set"), weakSelf)
            [previewView setPIROpen:!button.selected enabled:YES];
        } failure:^(NSError *error) {
            [task doFinish];
            [previewView setPIROpen:button.selected enabled:YES];
            WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_set"), weakSelf)
        }];
    }];
}
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedJingleBellButton:(UIButton *)button {
}
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedPowerManagementButton:(UIButton *)button {
    WY_WeakSelf
    [self.camera setDoorBellLowPowerOpen:!button.selected success:^{
        WY_HUD_SHOW_Toast_VC(WYLocalString(@"success_set"), weakSelf)
        [previewView setLowPowerOpen:!button.selected enabled:YES];
    } failure:^(NSError *error) {
        [previewView setLowPowerOpen:button.selected enabled:YES];
        WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_set"), weakSelf)
    }];
    
}

#pragma mark -- WYCameraToolPlaybackTimeBarViewDelegate
- (void)beginToDragTimeBar:(WYCameraToolPlaybackTimeBarView *)timeBar {
    
    self.draggingTimeBar = YES;
}
- (void)endDraggingTimeBar:(WYCameraToolPlaybackTimeBarView *)timeBar toSecond:(int)second canPlay:(BOOL)canPlay {
    
    self.draggingTimeBar = NO;
    WY_WeakSelf
    if (!canPlay && WYCanPlayPlacback) {
        WY_HUD_SHOW_Toast_VC(WYLocalString(@"status_noVideoThisTime"), weakSelf)
        return;
    }
    [self fireTimers];
    [self startSeekSecond:second];
}

#pragma mark -- WYCameraToolPlaybackAlarmMessageViewDelegate
- (void)WYCameraToolPlaybackAlarmMessageView:(WYCameraToolPlaybackAlarmMessageView *)alarmMessageView didSelectedSecond:(int)second {
    [self.timeBar autoShowAndDismissTimeLabelWithSecond:second];
    self.timeBar.progress = second/WYSecs_PerDay;
    if ([self.timeBar hasVideoAtSecond:second-5]) {
        second-=5;
    }
    
    [self startSeekSecond:second];
}
#pragma mark -- WYCameraToolPlaybackPictureBarViewDelegate
- (void)cameraToolPlaybackPictureBarView:(WYCameraToolPlaybackPictureBarView *)pictureBarView didSelectedSecond:(int)second{
    
    [self startSeekSecond:second];
}

#pragma mark -- WYCameraToolBarDelegate
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedVoiceButton:(UIButton *)button {
    
    self.voiceDown = !button.isSelected;
    MeariVoiceTalkType type = self.camera.supportFullDuplex&&!button.isSelected ? MeariVoiceTalkTypeFullDuplex : MeariVoiceTalkTypeOneWay;
    [self.camera setVoiceTalkType:type];
    [self.videoView hideBitStreamView];
    if (![self isPlaying]) return;
    WY_WeakSelf
    [WYAuthorityManager checkAuthorityOfMicrophoneWithAlert:^{
        if ([weakSelf isPlaying]) {
            weakSelf.voiceSpeaking = !button.isSelected;
        }
    }];
}
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didLosedVoiceButton:(UIButton *)button {
    
    self.voiceDown = NO;
    [self.videoView delayAutoHide];
    if (![self isPlaying]) return;
    self.voiceSpeaking = NO;
}
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedSnapshotButton:(UIButton *)button {
    
    [self.videoView delayAutoHide];
   
    if (![self isPlaying] || (self.videoType == _placbackType && self.paused)) return;
    NSString *snapShotPath = [NSFileManager wy_photoFileWithSN:self.camera.info.sn];
    WY_WeakSelf
    WYBlock_Void suc = ^{
        [WY_PhotoM savePhotoAtPath:snapShotPath];
        WY_HUD_SHOW_Toast_VC(WYLocalString(@"status_photoSaved"), weakSelf)
    };
    WYBlock_Void fail = ^{
        WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_snapshot"), weakSelf)
    };
    
    BOOL undetermined = [WYAuthorityManager authorityOfPhotoIsUndetermined];
    [WYAuthorityManager checkAuthorityOfPhotoWithAlert:^{
        if (undetermined) return ;
        switch (self.videoType) {
            case WYVideoTypePreviewHD:
            case WYVideoTypePreviewSD:
            case WYVideoTypePlaybackSDCard:{
                [self.camera snapshotToPath:snapShotPath isPreviewing:_isPreviewing success:^{
                    suc();
                } failure:^(NSError *error) {
                    fail();
                }];
                break;
            }
            case WYVideoTypePlaybackNVR: {
                [self.nvr snapshotToPath:snapShotPath isPreviewing:_isPreviewing success:^{
                    suc();
                } failure:^(NSError *error) {
                    fail();
                }];
                break;
            }
            default:
                break;
        }
    }];
}
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedPlayButton:(UIButton *)button {
    
    [self.videoView delayAutoHide];
    
    if (!self.paused && ![self isPlaying]) return;
    
    self.paused = button.isSelected;
}
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedMusicButton:(UIButton *)button {
    
    [self.videoView delayAutoHide];
    if (!self.camera.sdkLogined) return;
    self.toolView.previewView.showMenu = NO;
    [self wy_pushToVC:WYVCTypeBabyMonitorMusic sender:@{@"delegate":self,
                                                        @"volume":@(0),
                                                        }];
}
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedRecordButton:(UIButton *)button {
    
    [self.videoView delayAutoHide];
    
    BOOL undetermined = [WYAuthorityManager authorityOfPhotoIsUndetermined];
    [WYAuthorityManager checkAuthorityOfPhotoWithAlert:^{
        if (undetermined) return ;
        if (button.isSelected) {
            self.recording = NO;
        }else {
            if (![self isPlaying] || (self.videoType == _placbackType && self.paused)) return;
            self.recording = YES;
        }
    }];
}
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedMuteButton:(UIButton *)button {
    
    [self.videoView delayAutoHide];
    
    if (![self isPlaying]) return;

    self.muted = button.isSelected;
}
- (void)WYCameraToolBar:(WYCameraToolBar *)toolBar didTapedCalendarButton:(UIButton *)button {
    
    [self.videoView delayAutoHide];
    
    WY_Calendar.delegate = self;
    [WY_Calendar showWithStytle:self.camera.wy_uiStytle];
}

#pragma mark -- WYCalendarVCDelegate
- (void)WYCalendarVC:(WYCalendarVC *)vc didSelectedHasVideoDay:(NSInteger)day ofMonth:(NSInteger)month ofYear:(NSInteger)year {
    
    BOOL newDay = day != self.currentComponents.day;
    if (!newDay) return;
    
    [self removeTimers];
    self.currentComponents.year   = year;
    self.currentComponents.month  = month;
    self.currentComponents.day    = day;
    self.currentComponents.hour   = 0;
    self.currentComponents.minute = 0;
    self.currentComponents.second = 0;
    self.timeBar.progress = 0.0f;
    
    [self.toolView.playbackView resetToNormal];
    WY_WeakSelf
    switch (self.videoType) {
        case WYVideoTypePlaybackSDCard: {
            [self stopPlaybackSDCardSuccess:^{
                [weakSelf startPlay];
            }];
            break;
        }
        case WYVideoTypePlaybackNVR: {
            [self stopPlaybackNVRSuccess:^{
                [weakSelf startPlay];
            }];
            break;
        }
        default:break;
    }

}
- (void)WYCalendarVC:(WYCalendarVC *)vc willShowMonth:(NSInteger)month ofYear:(NSInteger)year needRefresh:(BOOL)needRresh{
    if (!needRresh) return;
    
    switch (self.videoType) {
        case WYVideoTypePlaybackSDCard:
        case WYVideoTypePlaybackNVR:{
            MeariDevice *camera = self.nvr ? self.nvr : self.camera;
            if (![camera sdkLogined]) return;
            
            [camera wy_getPlaybackVideoDaysWithYear:year month:month success:^(NSArray *days) {
                if (days.count > 0) {
                    [vc addSDCardVideoDays:days];
                    if (vc.currentDate.year == year && vc.currentDate.month == month) {
                        [vc updateSDCardAtMonth:month ofYear:year];
                    }
                }
            } failure:^(NSError *error) { 
            }];
            break;
        }
        default:break;
    }
    
}


#pragma mark -- WYBabyMonitorMusicToolBarDelegate
- (void)WYBabyMonitorMusicToolBar_Play:(WYBabyMonitorMusicToolBar *)toolbar musicID:(NSString *)musicID {
    if (!musicID) return;
    
    WY_WeakSelf
    [self doIfCanPlayMusic:^{
        [weakSelf.camera playMusic:musicID success:^{
            [weakSelf.musicVC playMusic:musicID];
        } failure:^(NSError *error) {
            
        }];
    }];
}
- (void)WYBabyMonitorMusicToolBar_Resume:(WYBabyMonitorMusicToolBar *)toolbar musicID:(NSString *)musicID{
    WY_WeakSelf
    [self doIfCanPlayMusic:^{
        [weakSelf.camera resumeMusicSuccess:^{
            [weakSelf.musicVC resumeMusic:musicID];
        } failure:^(NSError *error) {
            
        }];
    }];
}
- (void)WYBabyMonitorMusicToolBar_Pause:(WYBabyMonitorMusicToolBar *)toolbar musicID:(NSString *)musicID{
    WY_WeakSelf
    [self doIfCanPlayMusic:^{
        [weakSelf.camera pauseMusicSuccess:^{
            [weakSelf.musicVC pauseMusic:musicID];
        } failure:^(NSError *error) {
            
        }];
    }];
}
- (void)WYBabyMonitorMusicToolBar_PlayPrevSong:(WYBabyMonitorMusicToolBar *)toolbar {
    WY_WeakSelf
    [self doIfCanPlayMusic:^{
        [weakSelf.camera playPreviousMusicSuccess:^{
            [weakSelf.musicVC playPrevious];
        } failure:^(NSError *error) {
            
        }];
    }];
}
- (void)WYBabyMonitorMusicToolBar_PlayNextSong:(WYBabyMonitorMusicToolBar *)toolbar {
    WY_WeakSelf
    [self doIfCanPlayMusic:^{
        [weakSelf.camera playNextMusicSuccess:^{
            [weakSelf.musicVC playNext];
        } failure:^(NSError *error) {
            
        }];
    }];
}
- (void)WYBabyMonitorMusicToolBar_ChangeVolume:(WYBabyMonitorMusicToolBar *)toolbar volume:(NSInteger)volume {
    WY_WeakSelf
    [self doIfCanOperate:^{
        [weakSelf.camera setOutputVolume:volume success:^{
            
        } failure:^(NSError *error) {
            weakSelf.musicVC.volume = weakSelf.musicVC.volume;
        }];
    }];
}


@end
