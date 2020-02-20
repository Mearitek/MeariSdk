//
//  WYDoorBellSettingHostMessageVC.m
//  Meari
//
//  Created by FMG on 2017/7/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingHostMessageVC.h"
#import "WYDoorBellSettingHostMessageCell.h"
#import "WYDoorBellSettingHostMessageAudioView.h"
#import "UIImageView+Extension.h"
#import "WYHostMessageModel.h"
@interface WYDoorBellSettingHostMessageVC () <UITableViewDelegate, UITableViewDataSource, WYDoorBellHostMessageAudioDelegate,WYDoorBellSettingHostMessageCellDelegate> {
    NSInteger _audioTime;
    BOOL _isPlay;
    
}
@property (nonatomic, strong) WYDoorBellSettingHostMessageAudioView *audioView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray <NSMutableArray *>*audioTimeArr;
@property (nonatomic, strong) NSTimer *audioTimeTimer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
//@property (nonatomic, strong) NSString *defaultFilePath;
@property (nonatomic, strong) NSIndexPath *lastPlayIndex;
@property (nonatomic, strong) NSString *tmpAudioFilePath;
@property (nonatomic, assign) float maxSecond;
@property (nonatomic, strong) NSString *filePath;
@end

@implementation WYDoorBellSettingHostMessageVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MeariUser sharedInstance] cancelAllRequest];
    [self.camera stopPlayRecordedAudio];
    //删除本地文件
    for (NSArray *arr in self.audioTimeArr) {
        for (WYHostMessageModel *model in arr) {
            [WY_FileManager removeItemAtPath:model.filePath error:nil];
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self getHostMessageList];
    [self initSubview];
    [self setLayout];
    
}
- (void)becomeActive {
    [self.myTableView reloadData];
}
- (void)setLayout {
    WY_WeakSelf
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@(400));
    }];
    [self.audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
        make.leading.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@300);
    }];
    if (self.camera.supportHostMessage == MeariDeviceSupportHostTypeOne) {
        self.audioView.hidden = self.camera.info.bellVoice.length > 0;
    }
}
- (void)initSubview {
    self.title = WYLocalString(@"device_setting_voicemail");
//    self.view.backgroundColor = WY_BGColor_LightGrayNew;
    [self.myTableView registerNib:[UINib nibWithNibName:@"WYDoorBellSettingHostMessageCell" bundle:nil] forCellReuseIdentifier:WY_ClassName(WYDoorBellSettingHostMessageCell)];
    self.myTableView.scrollEnabled = NO;
    self.myTableView.tableFooterView = [UIView new];
    _filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _tmpAudioFilePath = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp_audio.wav"]];
}
- (void)getHostMessageList {
    [self.audioTimeArr removeAllObjects];
    //    NSMutableArray *sysArr = [NSMutableArray array];
    NSMutableArray *cusArr = [NSMutableArray array];
    //    [self.audioTimeArr addObject:sysArr];
    [self.audioTimeArr addObject:cusArr];
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [self.camera getHostMessageListSuccess:^(NSArray *customArray) {
        WY_HUD_DISMISS
        //        for (WYHostMessageModel *msg in systemsArray) {
        //            WYHostMessageModel *model = [[WYHostMessageModel alloc]initWithDeviceHostMessage:msg];
        //            [sysArr addObject:model];
        //            [self getAudioWithModel:model complete:nil];
        //        }
        for (MeariDeviceHostMessage *msg in customArray) {
            WYHostMessageModel *model = [[WYHostMessageModel alloc]initWithDeviceHostMessage:msg];
            if (!model.voiceName) {
                NSString *dateStr = [model.voiceUrl substringWithRange:NSMakeRange(model.voiceUrl.length - 18, 14)];
                model.voiceName = WY_BundleCH ? [dateStr WY_dateStringZH] : [dateStr WY_dateStringEN];
            }
            [cusArr addObject:model];
            [weakSelf getAudioWithModel:model complete:nil];
        }
        self.myTableView.hidden = NO;
        if ([weakSelf.camera supportHostMessage] == MeariDeviceSupportHostTypeMultiple) {
            weakSelf.audioView.hidden = weakSelf.audioTimeArr[0].count >= 3;
        }else {
            weakSelf.audioView.hidden = weakSelf.audioTimeArr[0].count >= 1;
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        WY_HUD_SHOW_Failure
    }];
}
- (void)getAudioWithModel:(WYHostMessageModel *)model complete:(void(^)(BOOL success))complete {
    WY_WeakSelf
    if (model.voiceUrl.length) {
        model.downloadState = WYHostMsgDownloading;
        model.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_custom.wav",model.voiceName]];
        [[MeariUser sharedInstance] downloadVoice:model.voiceUrl filePath:model.filePath success:^{
            //            WYLog(@"下载留言数据到本地成功 ---- %@",model.filePath);
            model.downloadState = WYHostMsgDownloadSuccess;
            WYDo_Block_Safe1(complete, YES)
            if (model.preparePlaying) {
                model.playing = YES;
                [self.myTableView reloadData];
                WY_HUD_DISMISS
                [weakSelf playAudioWithAudioView:model];
            }
        } failure:^(NSError *error) {
            WYDo_Block_Safe1(complete, NO)
            model.downloadState = WYHostMsgDownloadFailure;
            model.playing = NO;
        }];
    }
}
//开始录音
- (void)startRecord {
    WY_WeakSelf
    [WYAuthorityManager checkAuthorityOfMicrophone:^(BOOL granted) {
        if (!granted) {
            [WYAlertView showNeedAuthorityOfMicrophone];
        } else {
            weakSelf.audioView.microphoneAuth = granted;
            [weakSelf.camera startRecordAudioToPath:_tmpAudioFilePath];
            [weakSelf audioTimeTimer];
            _audioTime = 0;
        }
    }];
}
//录音完成
- (void)stopRecord {
    WY_WeakSelf
    [weakSelf.audioTimeTimer invalidate];
    _audioTimeTimer = nil;
    [self.camera stopRecordAudioSuccess:^(NSString *filePath) {
        WY_HUD_DISMISS
        if (_audioTime <= 1) {
            WY_HUD_SHOW_TOAST(WYLocalString(@"alert_record_time_short"));
            return;
        }
        if (self.maxSecond - _audioTime <= 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showChangeNameAlert:filePath];
            });
        }else {
            [weakSelf showChangeNameAlert:filePath];
        }
    }];
}
- (void)showChangeNameAlert:(NSString *)filePath {
    WY_WeakSelf
//    [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"device_setting_voicemail_name") textFieldPlaceholoder:@" " cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alignment:(NSTextAlignmentLeft) stytle:(WYUIStytleDefault) dismissedOnClickBtn:NO dismissedOnClickBackground:NO alertAction:^(WYAlertView *alertView, NSInteger buttonIndex, NSString *text) {
//        if (buttonIndex == 1) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if ([text isEqualToString:@" "] || !text.length) {
//                    WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"toast_null_content"))
//                    return;
//                }else if ([text WY_replaceFirstSpace].length > 15) {
//                    WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"toast_hostmsg_title_long"))
//                    return;
//                }
//                //删除空格
//                [weakSelf updateRecord:[text WY_replaceFirstSpace]];
//            });
//        }else {
//            //移除临时存放的文件夹
//            [WYAlertView dismiss];
//            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//        }
//    }];
    [weakSelf updateRecord:@"test"];
}
- (void)stopPlayAudio {
    _isPlay = NO;
    [self.myTableView reloadData];
    [self.camera stopPlayRecordedAudio];
}
- (void)playAudioWithAudioView:(WYHostMessageModel *)model {
    [self.myTableView reloadData];
    WY_WeakSelf
    [self.camera enableLoudSpeaker:YES];
    [self.camera startPlayRecordedAudioWithFile:model.filePath finished:^{
        model.playing = NO;
        if (weakSelf.audioTimeArr.count) {
            [weakSelf.myTableView reloadData];
        }
    }];
}
- (void)updateRecord:(NSString *)videoName {
    WY_WeakSelf
    if (!_tmpAudioFilePath.length) return;
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] uploadVoice:self.camera.info.ID videoName:videoName voiceFile:_tmpAudioFilePath success:^(MeariDeviceHostMessage *msg) {
        [WYAlertView dismiss];
        WY_HUD_SHOW_SUCCESS
        //        WYLog(@"upload url ---- %@",msg.voiceUrl);
        NSString *filePath = [weakSelf.filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_custom.wav",videoName]];
        [NSFileManager renameFileOriginPath:weakSelf.tmpAudioFilePath newFilePath:filePath];
        WYHostMessageModel *custom = [[WYHostMessageModel alloc]initWithDeviceHostMessage:msg];
        custom.filePath = filePath;
        custom.voiceName = videoName;
        custom.downloadState = WYHostMsgDownloadSuccess;
        [self.audioTimeArr[0] addObject:custom];
        if ([self.camera supportHostMessage] == MeariDeviceSupportHostTypeOne) {
            weakSelf.audioView.hidden = YES;
        }else {
            if (self.audioTimeArr[0].count >= 3) {
                weakSelf.audioView.hidden = YES;
            }else {
                weakSelf.audioView.hidden = NO;
            }
        }
        [weakSelf.myTableView reloadData];
        //        [WY_NotificationCenter wy_post_App_RefreshCameraList];
    } failure:^(NSError *error) {
        [WYAlertView dismiss];
        WY_HUD_SHOW_ERROR(error)
    }];
}
- (void)requestForDeleteVoiceID:(NSString *)voiceID complete:(WYBlock_Void)success {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] deleteVoice:self.camera.info.ID voiceID:voiceID success:^{
        WY_HUD_DISMISS
        if (weakSelf.camera.supportHostMessage == MeariDeviceSupportHostTypeOne) {
            weakSelf.camera.info.bellVoice = nil;
        }
        success();
    } failure:^(NSError *error) {
        WY_HUD_SHOW_ERROR(error)
    }];
}
- (void)rememberAudioTime {
    _audioTime++;
}
#pragma mark -  WYDoorBellHostMessageAudioDelegate
//- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapPlayButton:(UIButton *)btn {
//    [self playAudioWithAudioView:audioView];
//}
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView startRecordButton:(UIButton *)btn {
    [self startRecord];
}
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView stopRecordButton:(UIButton *)btn {
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(( _audioTime / 30.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //    });
    //    WY_HUD_SHOW_WAITING
    NSInteger timeDelay = [self.camera supportHostMessage] != MeariDeviceSupportHostTypeOne ? 9 : 29;
    if (_audioTime <= timeDelay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecord];
        });
    }else {
        [self stopRecord];
    }
    
}
//- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapCheckButton:(UIButton *)btn {
//    [self updateRecord:<#(NSString *)#>];
//}
//- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapCancelButton:(UIButton *)btn {
//    if (_isPlay) {
//        [self stopPlayAudio];
//    }
//}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (section== 0 ) {
    //        return ((NSArray *)self.audioTimeArr[0]).count;
    //    }
    return self.audioTimeArr[section].count;
    //    return self.camera.info.bellVoice.length > 0 ? ((NSArray *)self.audioTimeArr[section]).count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYDoorBellSettingHostMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYDoorBellSettingHostMessageCell)];
    [cell addLineViewAtBottom];
    WYHostMessageModel *model = self.audioTimeArr[indexPath.section][indexPath.row];
    cell.deleteBtn.hidden = NO;
    cell.dateLabel.text = model.voiceName;
    cell.delegate = self;
    cell.play = model.playing;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WY_NormalRowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
//    view.backgroundColor = WY_BGColor_LightGrayNew;
    UILabel *label = [UILabel labelWithFrame:CGRectMake(25, 0, WY_ScreenWidth, 28) textColor:WY_FontColor_Black font:WYFontNormal(12) numberOfLines:1 lineBreakMode:(NSLineBreakByWordWrapping) lineAlignment:(NSTextAlignmentLeft)];
//    label.backgroundColor = WY_BGColor_LightGrayNew;
    label.text = WYLocalString(@"device_setting_my_voicemail");
    [view addSubview:label];
    return view;
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self stopPlayAudio];
//    [self requestForDeleteVoice:^{
//        [WY_NotificationCenter wy_post_App_RefreshCameraList];
//        [self.audioTimeArr removeAllObjects];
//        self.audioView.enableRecord = !self.audioTimeArr.count;
//        [self.myTableView reloadData];
//    }];
//}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return WYLocalString(@"com_delete");
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYHostMessageModel *model = self.audioTimeArr[indexPath.section][indexPath.row];
    if (self.lastPlayIndex && (self.lastPlayIndex.section != indexPath.section || self.lastPlayIndex.row != indexPath.row)) {
        WYHostMessageModel *model = self.audioTimeArr[self.lastPlayIndex.section][self.lastPlayIndex.row];
        if (model.playing) {
            model.playing = NO;
            model.preparePlaying = NO;
            [self stopPlayAudio];
        }
    }
    model.playing = !model.playing;
    model.preparePlaying = NO;
    if (model.playing) {
        if (model.downloadState == WYHostMsgDownloadFailure) {
            WY_HUD_SHOW_Loading(nil)
            model.preparePlaying = YES;
            model.playing = NO;
            [self getAudioWithModel:model complete:^(BOOL success){
                if (success) {
                    WY_HUD_DISMISS
                }else {
                    WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"toast_get_msg_fail"))
                }
            }];
        }else {
            if (model.downloadState == WYHostMsgDownloadSuccess) {
                [self playAudioWithAudioView:model];
            }else {
                model.preparePlaying = YES;
                model.playing = NO;
                WY_HUD_SHOW_Loading(nil)
            }
        }
        
    }else {
        [self stopPlayAudio];
    }
    self.lastPlayIndex = indexPath;
    
    [self.myTableView reloadData];
}

#pragma mark -- WYDoorBellSettingHostMessageCellDelegate
//- (void)hostMessageCell:(WYDoorBellSettingHostMessageCell *)cell play:(UIButton *)playBtn {
//    if (!_filePath.length) return;
//    if (!playBtn.selected) {
//        [self playAudioWithAudioView:nil];
//    }else {
//        [self stopPlayAudio];
//    }
//}

- (void)hostMessageCell:(WYDoorBellSettingHostMessageCell *)cell delete:(UIButton *)playBtn {
    WY_WeakSelf
    NSIndexPath *path =[weakSelf.myTableView indexPathForCell:cell];
    WYHostMessageModel *model = weakSelf.audioTimeArr[path.section][path.row];
    [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"device_setting_voicemail_delete") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            [weakSelf stopPlayAudio];
            [weakSelf requestForDeleteVoiceID:model.voiceId complete:^{
                [[NSFileManager defaultManager] removeItemAtPath:model.filePath error:nil];
                NSIndexPath *path = [weakSelf.myTableView indexPathForCell:cell];
                [weakSelf.audioTimeArr[path.section] removeObjectAtIndex:path.row];
                //                [WY_NotificationCenter wy_post_App_RefreshCameraList];
                weakSelf.audioView.hidden = NO;
                [weakSelf.myTableView reloadData];
            }];
        }
    }];
}


#pragma mark - lazyLoad
- (WYDoorBellSettingHostMessageAudioView *)audioView {
    if (!_audioView) {
        _audioView = [[WYDoorBellSettingHostMessageAudioView alloc] init];
        _audioView.delegate = self;
        _audioView.hidden = YES;
        
        self.maxSecond = [self.camera supportHostMessage] == MeariDeviceSupportHostTypeOne ? 30.0 : 10.0;
        [_audioView setRecordLimitTime:self.maxSecond];
        [self.view addSubview:_audioView];
    }
    return _audioView;
}
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [UITableView new];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
//        _myTableView.backgroundColor = WY_BGColor_LightGrayNew;
        _myTableView.hidden = YES;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}
- (NSMutableArray *)audioTimeArr {
    if (!_audioTimeArr) {
        _audioTimeArr = [NSMutableArray array];
    }
    return _audioTimeArr;
}
- (NSTimer *)audioTimeTimer {
    if (!_audioTimeTimer) {
        _audioTimeTimer = [NSTimer timerInLoopWithInterval:1.0f target:self selector:@selector(rememberAudioTime)];
    }
    return _audioTimeTimer;
}
@end
