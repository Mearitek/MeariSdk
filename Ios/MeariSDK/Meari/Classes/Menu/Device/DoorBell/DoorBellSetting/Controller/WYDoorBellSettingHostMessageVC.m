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
@interface WYDoorBellSettingHostMessageVC () <UITableViewDelegate,UITableViewDataSource,WYDoorBellHostMessageAudioDelegate>
{
    
    NSString *_filePath;
    NSInteger _audioTime;
    BOOL _isPlay;
}
@property (nonatomic, strong) WYDoorBellSettingHostMessageAudioView *audioView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *audioTimeArr;
@property (nonatomic, strong) NSTimer *audioTimeTimer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) MeariDevice *camera;

@end

@implementation WYDoorBellSettingHostMessageVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopPlayAudio];
    [WY_FileManager removeItemAtPath:_filePath error:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.camera.info.bellVoice.length) {
        [self getAudioWithUrlStr:self.camera.info.bellVoice];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
    [self setLayout];
}
- (void)setLayout {
    WY_WeakSelf
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(@(100));
    }];
    [self.audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@300);
    }];
}
- (void)initSubview {
    self.title = WYLocalString(@"HOST MESSAGE");
    [self.myTableView registerNib:[UINib nibWithNibName:@"WYDoorBellSettingHostMessageCell" bundle:nil] forCellReuseIdentifier:WY_ClassName(WYDoorBellSettingHostMessageCell)];
    self.myTableView.scrollEnabled = NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _filePath = [strUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"audio.wav"]];
    self.audioView.enableRecord = !self.camera.info.bellVoice.length;
}
- (void)getAudioWithUrlStr:(NSString *)urlStr {
    
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] downloadVoice:urlStr success:^(NSData *data) {
        if ([data writeToFile:_filePath atomically:YES]) {
            NSString *dateStr = [urlStr substringWithRange:NSMakeRange(urlStr.length -18, 14)];
            NSString *year,*month,*day,*hour,*minute,*second;
            year   = [dateStr substringToIndex:4];
            month  = [dateStr substringWithRange:NSMakeRange(4, 2)];
            day    = [dateStr substringWithRange:NSMakeRange(6, 2)];
            hour   = [dateStr substringWithRange:NSMakeRange(8, 2)];
            minute = [dateStr substringWithRange:NSMakeRange(10, 2)];
            second = [dateStr substringWithRange:NSMakeRange(12, 2)];
            NSString *voiceTime;
            if ([[NSBundle wy_urlLanguage] isEqualToString:@"zh"]) {
                voiceTime = [NSString stringWithFormat:@"%@年%@月%@日 %@:%@:%@",year,month,day,hour,minute,second];
            } else {
                voiceTime = [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",day,month,year,hour,minute,second];
            }
            [weakSelf.audioTimeArr addObject:voiceTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.audioView.enableRecord = !weakSelf.audioTimeArr.count;
                [weakSelf.myTableView reloadData];
                WY_HUD_DISMISS
            });
        }
    } failure:^(NSError *error) {
        WY_HUD_SHOW_STATUS(@"status_downlondMessageFail");
    }];
}


//开始录音
- (void)startRecord {
    WY_WeakSelf
    [WYAuthorityManager checkAuthorityOfMicrophone:^(BOOL granted) {
        if (!granted) {
            [WYAlertView showNeedAuthorityOfMicrophone];
        } else {
            weakSelf.audioView.microphoneAuth = granted;
            [weakSelf.camera startRecordAudioToPath:_filePath];
            [weakSelf audioTimeTimer];
            _audioTime = 0;
        }
    }];
}
//录音完成
- (void)stopRecord {
    WY_WeakSelf
    [self.camera stopRecordAudioSuccess:^(NSString *filePath) {
        _filePath = filePath;
        [weakSelf.audioTimeTimer invalidate];
        _audioTimeTimer = nil;
        if (_audioTime < 1) {
            [WYAlertView showWithTitle:nil message:WYLocalString(@"alert_recordTimeShort") cancelButton:nil otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                [weakSelf.audioView cancelAudition];
            }];
        }
    }];
}

- (void)stopPlayAudio {
    [self.camera stopPlayRecordedAudio];
}
- (void)playAudioWithAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView {
    if (_isPlay) return;
    _isPlay = YES;
    WY_WeakSelf
    [self.camera startPlayRecordedAudioWithFile:_filePath finished:^{
        [audioView didFinishedPlay];
        if (weakSelf.audioTimeArr.count) {
            [weakSelf.myTableView reloadData];
        }
        _isPlay = NO;
    }];
}

- (void)updateRecord {
    [self.camera stopPlayRecordedAudio];
    if (!_filePath.length) return;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd HH:mm:ss";
    formatter.locale = [NSLocale currentLocale];
    NSString *currentTime = [formatter stringFromDate:date];
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] uploadVoice:self.camera.info.ID voiceFile:_filePath success:^(NSString *voiceUrl) {
        [weakSelf.audioView cancelAudition];
        WY_HUD_SHOW_SUCCESS
        [weakSelf.audioTimeArr addObject:currentTime];
        weakSelf.camera.info.bellVoice = voiceUrl;
        weakSelf.audioView.enableRecord = !self.audioTimeArr.count;
        [weakSelf.myTableView reloadData];
        [WY_NotificationCenter wy_post_App_RefreshCameraList];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];

}
- (void)requestForDeleteVoice:(WYBlock_Void)success {
    WY_WeakSelf
    [[MeariUser sharedInstance] deleteVoice:self.camera.info.ID success:^{
        weakSelf.camera.info.bellVoice = nil;
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];

}


- (void)rememberAudioTime {
    _audioTime++;
}
#pragma mark -  WYDoorBellHostMessageAudioDelegate
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapPlayButton:(UIButton *)btn {
    [self playAudioWithAudioView:audioView];
}
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView startRecordButton:(UIButton *)btn {
    [self startRecord];
}
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView stopRecordButton:(UIButton *)btn {
    [self stopRecord];
}
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapCheckButton:(UIButton *)btn {
    [self updateRecord];
}
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapCancelButton:(UIButton *)btn {
    [self stopPlayAudio];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioTimeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYDoorBellSettingHostMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYDoorBellSettingHostMessageCell)];
    [cell addLineViewAtBottom];
    NSArray *timerArr = [self.audioTimeArr[0] componentsSeparatedByString:@" "];
    cell.dateLabel.text = timerArr[0];
    cell.timeLabel.text = timerArr[1];
    if (!_isPlay) {
        cell.accessoryView = nil;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WY_NormalRowHeight;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopPlayAudio];
    [self requestForDeleteVoice:^{
        [WY_NotificationCenter wy_post_App_RefreshCameraList];
        [self.audioTimeArr removeAllObjects];
        self.audioView.enableRecord = !self.audioTimeArr.count;
        [self.myTableView reloadData];
    }];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WYLocalString(@"Delete");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_filePath.length) return;
    WYDoorBellSettingHostMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gif_auditionMessage" ofType:@"gif"];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    [imageV wy_setGIFImageWithURL:url];
    cell.accessoryView = imageV;
    [self playAudioWithAudioView:nil];
    [self.myTableView reloadData];
}

#pragma mark -- Action
#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        self.camera = obj;
    }
}


#pragma mark - lazyLoad
- (WYDoorBellSettingHostMessageAudioView *)audioView {
    if (!_audioView) {
        _audioView = [[WYDoorBellSettingHostMessageAudioView alloc] init];
        _audioView.delegate = self;
        [self.view addSubview:_audioView];
    }
    return _audioView;
}
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = ({
            UITableView *tab = [UITableView new];
            tab.delegate = self;
            tab.dataSource = self;
            [self.view addSubview:tab];
            tab;
        });
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
