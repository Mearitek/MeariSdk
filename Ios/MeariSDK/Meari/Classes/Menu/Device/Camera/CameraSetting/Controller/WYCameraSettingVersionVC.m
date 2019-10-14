//
//  WYCameraSettingVersionVC.m
//  Meari
//
//  Created by 李兵 on 16/3/23.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSettingVersionVC.h"
#import "WYCameraSettingUpdateModel.h"
#import "WYCameraSettingModel.h"
#import "WYNVRSettingModel.h"



@interface WYCameraSettingVersionVC ()<WYProgressUpgradeViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) WYProgressUpgradeView *progressV;

@property (nonatomic, strong) NSMutableArray  *dataSource;
@property (nonatomic, strong) MeariDevice *camera;

@property (nonatomic, copy  ) NSString *currentVersion; // 当前版本
@property (nonatomic, copy  ) NSString *latestVersion;  // 最新版本
@property (nonatomic, copy  ) NSString *devUrl;         // 升级url
@property (nonatomic, copy  ) NSString *versionDesc;    // 升级内容
@property (nonatomic, assign) BOOL isUpgrade;           // 是否需要升级

@property (strong, nonatomic)NSTimer *updateTimer;

@end

@implementation WYCameraSettingVersionVC

#pragma mark - getter
- (NSTimer *)updateTimer {
    if (!_updateTimer) {
        _updateTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToQueryPercent:)];
    }
    return _updateTimer;
}


#pragma mark - life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.wy_pushFromVCType != WYVCTypeCameraList &&
        self.wy_pushFromVCType != WYVCTypeMsgAlarmDetail) {
        [self networkRequestLatestVersion];
        return;
    }
    
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    if (self.camera.sdkLogined) {
        [self networkRequestLatestVersion];
    }else {
        [self.camera wy_startConnectSuccess:^{
            [weakSelf.camera getVersionSuccess:^(id obj) {
                WY_HUD_DISMISS
                weakSelf.camera.info.version = obj;
                weakSelf.currentVersion = obj;
                WYCameraSettingUpdateModel *model = weakSelf.dataSource.firstObject;
                model.version = weakSelf.currentVersion.wy_shortVersion;
                [weakSelf networkRequestLatestVersion];
            } failure:^(NSError *error) {
                WY_HUD_SHOW_Failure
            }];
        } failure:^(NSError *error) {
            WY_HUD_SHOW_Failure
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self enableUpdateTimer:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSet];
}

#pragma mark -- init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"VERSION");
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    WYCameraSettingUpdateModel *model = [[WYCameraSettingUpdateModel alloc] init];
    model.title   = WYLocalString(@"Current version");
    model.version = self.currentVersion.wy_shortVersion;
    self.dataSource = [NSMutableArray arrayWithCapacity:2];
    [self.dataSource addObject:model];
    
}

#pragma mark -- network
- (void)networkRequestLatestVersion {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirmware:self.currentVersion success:^(MeariDeviceFirmwareInfo *info) {
        WY_HUD_DISMISS
        [weakSelf dealData:info];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealData:(MeariDeviceFirmwareInfo *)info {

    self.devUrl        = info.upgradeUrl;
    self.latestVersion = info.latestVersion;
    self.versionDesc   = info.upgradeDescription;
    self.isUpgrade     = info.needUpgrade;
    
    WYCameraSettingUpdateModel *model = [[WYCameraSettingUpdateModel alloc] init];
    model.title   = WYLocalString(@"Latest version");
    model.version = self.latestVersion.wy_shortVersion;
    
    if (self.dataSource.count == 1) {
        [self.dataSource addObject:model];
    }else if(self.dataSource.count > 2) {
        while (self.dataSource.count > 2) {
            [self.dataSource removeLastObject];
        }
    }
    [self.dataSource addObject:[WYCameraSettingUpdateModel new]];
    [self.tableView reloadData];
}


#pragma mark -- Utilities
- (void)doUpdate:(BOOL)lajibuding {
    WY_WeakSelf
    WYBlock_Void upgradeFailure = ^{
        WY_StrongSelf
        [strongSelf enableUpdateTimer:NO];
        [strongSelf.progressV reset];
        WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_update"), strongSelf)
    };
    WYBlock_Void  upgradeLimit = ^{
        WY_StrongSelf
        [strongSelf enableUpdateTimer:NO];
        [strongSelf.progressV reset];
        WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"设备电量低不能进行升级操作"), strongSelf)
    };
    WYBlock_Void upgradeSuccess = ^{
        WY_StrongSelf
        if (lajibuding) {
            WY_HUD_SHOW_SUCCESS_STATUS_VC(WYLocalString(@"device_update_sucess_lajibuding"), weakSelf)
            [weakSelf.progressV setDone];
        }else {
            [strongSelf enableUpdateTimer:YES];
        }
    };
    WYBlock_Void upgrade = ^{
        [weakSelf.camera upgradeWithUrl:weakSelf.devUrl currentVersion:weakSelf.currentVersion success:^{
            upgradeSuccess();
        } failure:^(NSError *error) {
            if (error.code == MeariDeviceCodeVersionIsUpgrading) {
                upgradeSuccess();
            }else if (error.code == MeariDeviceCodeVersionLowPower) {
                upgradeLimit();
            }else {
                upgradeFailure();
            }
        }];
    };
    
    if (weakSelf.camera.sdkLogined) {
        upgrade();
    }else {
        [weakSelf.camera wy_startConnectSuccess:^{
            upgrade();
        } failure:^(NSError *error) {
            upgradeFailure();
        }];
    }
}


#pragma mark - delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        self.camera = (MeariDevice *)obj;
        self.currentVersion = self.camera.info.version;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        if (indexPath.row < 2) {
            [cell addLineViewAtBottom];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = WYFont_Text_M_Normal;
    cell.textLabel.textColor = WY_FontColor_Black;
    cell.detailTextLabel.font = WYFont_Text_M_Normal;
    cell.detailTextLabel.textColor = WY_FontColor_Gray;
    
    WYCameraSettingUpdateModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text       = model.title;
    cell.detailTextLabel.text = model.version;
    if (indexPath.row == 2) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.attributedText = [NSAttributedString defaultAttributedStringWithString:self.versionDesc fontColor:WY_FontColor_Cyan font:WYFont_Text_S_Normal];
    }
    return cell;
}

#pragma mark -- Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        return 70;
    }
    if (!self.isUpgrade) return 0.1;
    
    NSAttributedString *versionDesc = [NSAttributedString defaultAttributedStringWithString:self.versionDesc fontColor:WY_FontColor_Cyan font:WYFont_Text_S_Normal];
    CGFloat w = WY_ScreenWidth - 30;
    CGFloat h = [versionDesc wy_heightWithWidth:w];
    return h + 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 91;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [view addLineViewAtBottom];
    UIImageView *imageV = [UIImageView new];
    if (self.camera.info.type == MeariDeviceTypeNVR) {
        imageV.image = [UIImage imageNamed:@"img_nvr_icon"];
    }else {
        [imageV wy_setImageWithURL:[NSURL URLWithString:self.camera.info.iconUrl] placeholderImage:[UIImage placeholder_device_image]];
    }
    [view addSubview:imageV];
    
    UILabel *label = [UILabel labelWithFrame:CGRectZero
                                        text:[NSString stringWithFormat:@"%@ (%@)", self.camera.info.nickname, self.camera.info.sn]
                                   textColor:WY_FontColor_Black
                                    textfont:WYFont_Text_M_Bold
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByWordWrapping
                               lineAlignment:NSTextAlignmentLeft
                                   sizeToFit:NO];
    [view addSubview:label];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@61);
        make.width.equalTo(imageV.mas_height);
        make.leading.equalTo(view).with.offset(15);
        make.centerY.equalTo(view);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(imageV.mas_trailing).with.offset(20);
        make.trailing.equalTo(view).with.offset(-20);
        make.height.equalTo(imageV);
        make.centerY.equalTo(view);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.isUpgrade) return 0.1;
    return 60 + 20*2;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.isUpgrade) return nil;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    WYProgressUpgradeView *upgradeV = [WYProgressUpgradeView upgradeViewWithBeginText:WYLocalString(@"UPDATE") prepareText:WYLocalString(@"Preparing") endText:WYLocalString(@"Done")];            
    upgradeV.delegate = self;
    [view addSubview:upgradeV];
    self.progressV = upgradeV;
    
    [upgradeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.leading.trailing.equalTo(view);
        make.height.equalTo(@60);
    }];
    return view;
}

#pragma mark -- WYProgressUpgradeViewDelegate
- (void)WYProgressUpgradeViewWillUpgrade:(WYProgressUpgradeView *)upgradeView {
    BOOL lajiBuding = [self.currentVersion.wy_shortVersionButDate isEqualToString:@"1.8.4"];
    if (lajiBuding) {
        [self doUpdate:YES];
    }else {
        [self prepareToUpdate];
    }
}
- (void)WYProgressUpgradeViewBeginUpgrade:(WYProgressUpgradeView *)upgradeView {
    [self doUpdate:NO];
}
- (void)WYProgressUpgradeViewUpdgradeSuccess:(WYProgressUpgradeView *)upgradeView {
    [self WYProgressUpgradeViewUpdgradeSuccess:upgradeView lajibuding:NO];
}
- (void)WYProgressUpgradeViewUpdgradeSuccess:(WYProgressUpgradeView *)upgradeView lajibuding:(BOOL)lajibuding {
    if (!lajibuding) {
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"success_update"))
    }
    [self enableUpdateTimer:NO];
    // 更新当前界面
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = self.latestVersion.wy_shortVersion;
    
    // 通知 Setting 界面更新版本号
    self.camera.info.needUpdate = NO;
    self.camera.info.needForceUpdate = NO;
    WY_WeakSelf
    [WY_NotificationCenter wy_post_Device_ChangeParam:^(WYObj_Device *device) {
        device.deviceID = weakSelf.camera.info.ID;
        device.paramType = weakSelf.camera.info.type == MeariDeviceTypeNVR ? WYNVRSettingCellTypeVersion : WYSettingCellTypeVersion;
        device.paramValue = weakSelf.latestVersion;
        device.updated = YES;
    }];

}
- (void)WYProgressUpgradeViewDidDoneUpgrade:(WYProgressUpgradeView *)upgradeView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self prepareToUpdate];
    }
}
- (void)prepareToUpdate {
    self.devUrl = self.devUrl.wy_stringByTrimWhiteSpace;
    if (self.devUrl.length <= 0) {
        WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"status_networkSystemError"))
        return;
    }
    [self.progressV prepareToUpdate];
    
}

#pragma mark - timer
- (void)enableUpdateTimer:(BOOL)enabled {
    if (enabled) {
        if (!_updateTimer) {
            [self.updateTimer fire];
        }
    }else {
        if (_updateTimer) {
            [_updateTimer invalidate];
            _updateTimer = nil;
        }
    }
}
- (void)timerToQueryPercent:(NSTimer *)sender {
    static BOOL canDo = YES;
    if (!canDo) return;
    canDo = NO;
    static int failCount = 0;
    WY_WeakSelf
    void(^dealPercentFromSucCallback)(BOOL, NSInteger) = ^(BOOL fromSucCallback, NSInteger percent){
        WY_StrongSelf
        BOOL isFailed = NO;
        if (failCount >= 3) {
            isFailed = YES;
        }else {
            if (percent >= 0) {
                isFailed = NO;
            }else {
                if (strongSelf.progressV.progress > 0) {
                    isFailed = NO;
                    percent = 100;
                }else {
                    if (fromSucCallback) {
                        isFailed = YES;
                    }else {
                        return;
                    }
                }
            }
        }
        if (isFailed) {
            [strongSelf enableUpdateTimer:NO];
            [strongSelf.progressV reset];
            WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_update"), strongSelf);
        }else {
            strongSelf.progressV.progress = percent/100.0f;
            strongSelf.camera.info.needUpdate = NO;
            strongSelf.camera.info.needForceUpdate = NO;
        }
    };
    [self.camera getUpgradePercentSuccess:^(NSInteger percent) {
        canDo = YES;
        failCount = 0;
        dealPercentFromSucCallback(YES, percent);
    } failure:^(NSError *error) {
        canDo = YES;
        failCount++;
        dealPercentFromSucCallback(NO, -666);
    }];
}




@end
