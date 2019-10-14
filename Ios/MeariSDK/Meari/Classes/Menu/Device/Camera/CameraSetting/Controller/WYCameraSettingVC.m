//
//  SetInfoViewController.m
//  HYRtspSDK
//
//  Created by Strong on 15/8/3.
//  Copyright (c) 2015年 PPStrong. All rights reserved.
//

#import "WYCameraSettingVC.h"

#import "WYCameraSettingModel.h"
#import "WYSettingSearchView.h"
#import "WYCameraSettingVersionVC.h"
#import "WYCameraSettingMotionVC.h"
#import "WYCameraSettingSDCardVC.h"
#import "WYDoorBellSettingPIRDetectionVC.h"

@interface WYCameraSettingVC ()<UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, weak  ) UIView     *topView;
@property (nonatomic, weak) UILabel *previewNameLabel;
@property (nonatomic, weak) WYNickTextField *nickTF;
@property (nonatomic, weak  ) UITableView *tableView;

@property (nonatomic, strong) UISwitch        *mirrorSW;
@property (nonatomic, strong) UIButton        *overtimeBtn;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL hadRequestedVersion;
@property (nonatomic, strong) MeariDeviceParamBell *doorBell;

@property (nonatomic, strong)MeariDevice *camera;

@end

@implementation WYCameraSettingVC
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)topView {
    if (!_topView) {
        UIView *view = [UIView new];
        view.backgroundColor = WY_BGColor_LightGray;
        [self.view addSubview:view];
        _topView = view;
    }
    return _topView;
}
- (UILabel *)previewNameLabel {
    if (!_previewNameLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:WYLocalString(@"Preview name")
                                       textColor:WY_FontColor_Gray
                                        textfont:WYFont_Text_S_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByCharWrapping
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:NO];
        [self.topView addSubview:label];
        _previewNameLabel = label;
    }
    return _previewNameLabel;
}
- (WYNickTextField *)nickTF {
    if (!_nickTF) {
        WYNickTextField *tf = [WYNickTextField roundTextFieldWithFrame:CGRectZero
                                                                target:self
                                                            saveAction:@selector(saveAction:)];
        tf.layer.cornerRadius = 43/2.0;
        tf.layer.masksToBounds = YES;
        [self.topView addSubview:tf];
        _nickTF = tf;
    }
    return _nickTF;
}
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableV = [UITableView wy_tableViewWithDelegate:self];
        tableV.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableV];
        _tableView = tableV;
    }
    return _tableView;
}
- (UISwitch *)mirrorSW {
    if (!_mirrorSW) {
        _mirrorSW = [UISwitch defaultSwitchWithTarget:self action:@selector(mirrorAction:)];
        _mirrorSW.enabled = !self.camera.info.shared;
    }
    return _mirrorSW;
}
- (UIButton *)overtimeBtn {
    return [UIButton wy_refreshBtnWithTarget:self action:@selector(refreshAction:)];
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        
        WYCameraSettingModel *previewNameModel   = [WYCameraSettingModel previewNameModel];
        WYCameraSettingModel *ownerModel         = [WYCameraSettingModel ownerModel];
        WYCameraSettingModel *snModel            = [WYCameraSettingModel snModel];
        WYCameraSettingModel *shareModel         = [WYCameraSettingModel shareModel];
        WYCameraSettingModel *nvrModel           = [WYCameraSettingModel nvrModel];
        WYCameraSettingModel *mirrorModel        = [WYCameraSettingModel mirrorModel];
        WYCameraSettingModel *motionModel        = [WYCameraSettingModel motionModel];
        WYCameraSettingModel *versionModel       = [WYCameraSettingModel versionModel];
        WYCameraSettingModel *sdcardModel        = [WYCameraSettingModel sdcardModel];
        WYCameraSettingModel *sleepmodeModel     = [WYCameraSettingModel sleepmodeModel];
        
        //门铃
        WYCameraSettingModel *batteryLockModel      = [WYCameraSettingModel BatteryLockModel];
        WYCameraSettingModel *HostMessageModel      = [WYCameraSettingModel HostMessageModel];
        WYCameraSettingModel *bellVolumeModel       = [WYCameraSettingModel BellVolumeModel];
        WYCameraSettingModel *powerManagementModel  = [WYCameraSettingModel PowerManagementModel];
        WYCameraSettingModel *PIRDetectionModel     = [WYCameraSettingModel PIRDetectionModel];
        
        WYCameraSettingModel *sharedNVRModel     = [WYCameraSettingModel sharedNVRModel];
        WYCameraSettingModel *sharedMirrorModel  = [WYCameraSettingModel sharedMirrorModel];
        WYCameraSettingModel *sharedMotionModel  = [WYCameraSettingModel sharedMotionModel];
        WYCameraSettingModel *sharedVersionModel = [WYCameraSettingModel sharedVersionModel];
        
        WYCameraSettingModel *sharedPIRDetectionModel    = [WYCameraSettingModel sharedPIRDetectionModel];
        
        WYCameraSettingModel *jingleBellModel    = [WYCameraSettingModel JingleBellModel];
        
        
        
        previewNameModel.detailedText = self.camera.info.nickname;
        ownerModel.detailedText = self.camera.info.userAccount;
        snModel.detailedText = self.camera.info.sn;
        
        if (self.camera.info.subType == MeariDeviceSubTypeIpcBell) {
            if (self.camera.info.shared) {
                _dataSource = @[ownerModel, snModel, sharedPIRDetectionModel,sharedVersionModel].mutableCopy;
                
            }else {
                _dataSource = @[ownerModel, snModel, shareModel, sdcardModel,jingleBellModel, PIRDetectionModel,HostMessageModel,bellVolumeModel,powerManagementModel,batteryLockModel,versionModel].mutableCopy;
            }
        } else {
            if (self.camera.info.shared) {
                _dataSource = @[previewNameModel, ownerModel, snModel, sharedNVRModel,sharedMirrorModel,  sharedMotionModel, sharedVersionModel].mutableCopy;
                
            }else {
                _dataSource = @[ownerModel, snModel, shareModel, sdcardModel, nvrModel, sleepmodeModel, mirrorModel, motionModel, versionModel].mutableCopy;
            }
        }
        if (!self.camera.hasBindedNvr) {
            [_dataSource removeObject:nvrModel];
            [_dataSource removeObject:sharedNVRModel];
        }
    }
    return _dataSource;
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"SETTINGS");
    //    self.navigationItem.rightBarButtonItem = [UIBarButtonItem deleteImageItemWithTarget:self action:@selector(deleteAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem deleteDeviceTextItemWithTarget:self action:@selector(deleteAction:)];
    self.showNavigationLine = self.camera.info.shared;
    self.nickTF.textField.text = self.camera.info.nickname;
}
- (void)initLayout {
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@(weakSelf.camera.info.shared ? 0 : (WY_iPhone_4 ? 85 : 117)));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
    
    [self.nickTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(43)).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf.topView);
        make.leading.equalTo(weakSelf.topView).with.offset(35);
        make.trailing.equalTo(weakSelf.topView).with.offset(-35);
        make.centerX.equalTo(weakSelf.topView);
        make.centerY.equalTo(weakSelf.topView).with.offset(WY_iPhone_4 ? 8 : 0);
    }];
    
    [self.previewNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(weakSelf.topView);
        make.bottom.equalTo(weakSelf.nickTF.mas_top).offset(-5);
        make.height.lessThanOrEqualTo(weakSelf.previewNameLabel.superview);
    }];
}

- (void)getParamsVoiceBell {
    WY_WeakSelf
    [self.camera getParamsSuccess:^(MeariDeviceParam *param) {
        NSLog(@"语音门铃----%@",param);
    } failure:^(NSError *error) {
        
    }];
}


- (void)initConnect {
    if (self.camera.sdkLogining) {
        return;
    }
    if (self.camera.sdkLogined) {
        [self getParams];
    }else {
        [self.camera wy_startConnectSuccess:nil failure:nil];
    }
}

#pragma mark -- Life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell) {
        [self getParamsVoiceBell];
    } else {
        [self initConnect];
    }
    
    
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self initNotification];
}
- (void)deallocAction {
    [self removeNotification];
    if (self.camera.info.type == MeariDeviceTypeNVR) {
        [self.camera stopConnectSuccess:nil failure:nil];
    }
}

#pragma mark -- Network
- (void)networkRequestChangeNickName:(NSString *)newNickName {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] renameDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.camera.info.ID nickname:newNickName success:^{
        
        if (weakSelf.wy_isTop) {
            WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"success_changeNickname"))
        }
        weakSelf.camera.info.nickname = newNickName;
        for (WYCameraSettingModel *model in weakSelf.dataSource) {
            if (model.type == WYSettingCellTypePreviewName) {
                model.detailedText = newNickName;
            }
        }
        [WY_NotificationCenter wy_post_Device_ChangeNickname:^(WYObj_Device *device) {
            device.deviceID = weakSelf.camera.info.ID;
            device.nickname = newNickName;
        }];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestDeleteDevice {
    WY_WeakSelf
    WYBlock_Void deleteTask = ^{
        WY_HUD_DISMISS
        [WY_NotificationCenter wy_post_Device_Delete:^(WYObj_Device *device) {
            device.deviceID = weakSelf.camera.info.ID;
        }];
        NSString *thumbPath = [NSFileManager thumbFile:weakSelf.camera.info.sn];
        [WY_FileManager removeItemAtPath:thumbPath error:nil];
        [weakSelf wy_popToVC:WYVCTypeCameraList];
    };
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] deleteDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.camera.info.ID success:^{
        deleteTask();
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

#pragma mark -- Notification
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(n_keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_connectCompleted:) name:WYNotification_Device_ConnectCompleted object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_changeParam:) name:WYNotification_Device_ChangeParam object:nil];
}
- (void)removeNotification {
    [WY_NotificationCenter removeObserver:self];
}
- (void)n_keyboardShow:(NSNotification *)sender {
    [self.tableView addTapGestureTarget:self action:@selector(tapAction:)];
}
- (void)n_connectCompleted:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.camera.info.ID) return;
    
    if (device.connectSuccess) {
        [self getParams];
    }else {
        [self updateCellWithCellType:WYSettingCellTypeMirror param:WYLocal_Timeout];
        [self updateCellWithCellType:WYSettingCellTypeMotion param:WYLocal_Timeout];
        [self updateCellWithCellType:WYSettingCellTypeVersion param:WYLocal_Timeout];
        [self updateCellWithCellType:WYSettingCellTypeSleepMode param:WYLocal_Timeout];
        [self updateCellWithCellType:WYSettingCellTypePIRDetection param:WYLocal_Timeout];
        [self updateCellWithCellType:WYSettingCellTypeJingleBell param:WYLocal_Timeout];
    }
}
- (void)n_changeParam:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.camera.info.ID) return;
    
    WYSettingCellType type = device.paramType;
    WYCameraSettingModel *model;
    for (WYCameraSettingModel *m in self.dataSource) {
        if (m.type == type) {
            model = m;
            break;
        }
    }
    model.detailedText = device.paramValue;
    if (model.type == WYSettingCellTypeVersion) {
        self.camera.info.needUpdate = NO;
        self.camera.info.needForceUpdate = NO;
    } else if(model.type == WYSettingCellTypePIRDetection) {
        
    }
    [self.tableView reloadData];
}


#pragma mark -- NSTimer
#pragma mark -- Utilities
- (void)getParams {
    WY_WeakSelf
    [self updateCellWithCellType:WYSettingCellTypeSleepMode param:@"logined"];
    [self.camera getMirrorSuccess:^(BOOL mirror) {
        [weakSelf updateCellWithCellType:WYSettingCellTypeMirror param:@(mirror).stringValue];
    } failure:^(NSError *error) {
        [weakSelf updateCellWithCellType:WYSettingCellTypeMirror param:WYLocal_Timeout];
    }];
    [self.camera getAlarmSuccess:^(MeariDeviceParamMotion *motion) {
        NSString *motionLevel;
        switch (motion.level) {
            case MeariDeviceLevelOff: motionLevel = WYLocalString(@"motion_off"); break;
            case MeariDeviceLevelLow: motionLevel = WYLocalString(@"motion_low"); break;
            case MeariDeviceLevelMedium: motionLevel = WYLocalString(@"motion_medium"); break;
            case MeariDeviceLevelHigh: motionLevel = WYLocalString(@"motion_high"); break;
            default: break;
        }
        [weakSelf updateCellWithCellType:WYSettingCellTypeMotion param:motionLevel];
    } failure:^(NSError *error) {
        [weakSelf updateCellWithCellType:WYSettingCellTypeMotion param:WYLocal_Timeout];
    }];
    [self.camera getVersionSuccess:^(id obj) {
        [weakSelf updateCellWithCellType:WYSettingCellTypeVersion param:obj];
    } failure:^(NSError *error) {
        [weakSelf updateCellWithCellType:WYSettingCellTypeVersion param:WYLocal_Timeout];
    }];
    if (self.camera.info.subType == MeariDeviceSubTypeIpcBell) {
        [weakSelf.camera getParamsSuccess:^(MeariDeviceParam *params) {
            NSString *levelStr;
            if (params.bell.pir.enable) {
                switch (params.bell.pir.level) {
                    case MeariDeviceLevelLow: levelStr = WYLocalString(@"motion_low");break;
                    case MeariDeviceLevelMedium: levelStr = WYLocalString(@"motion_medium");break;
                    case MeariDeviceLevelHigh: levelStr = WYLocalString(@"motion_high");break;
                    case MeariDeviceLevelNone: levelStr = WYLocalString(@"motion_off");break;
                    default:break;
                }
            } else {
                levelStr = WYLocalString(@"motion_off");
            }
            [weakSelf updateCellWithCellType:WYSettingCellTypePIRDetection param:levelStr];
            self.doorBell = params.bell;
            //铃铛
            [weakSelf updateCellWithCellType:WYSettingCellTypeJingleBell param:@"logined"];
        } failure:^(NSError *error) {
            [weakSelf updateCellWithCellType:WYSettingCellTypePIRDetection param:WYLocal_Timeout];
        }];
    }
}
- (void)updateCellWithCellType:(WYSettingCellType)type param:(NSString *)param{
    
    WYCameraSettingModel *model;
    for (WYCameraSettingModel *m in self.dataSource) {
        if (m.type == type) {
            model = m;
            break;
        }
    }
    if (!model) return;
    
    model.detailedText = param;
    if ([param isEqualToString:WYLocal_Timeout]) {
        model.detailedText = nil;
        model.accesoryType = WYSettingAccesoryTypeOverTime;
    }else if ([param isEqualToString:@"logined"]) {
        model.detailedText = nil;
        model.accesoryType = WYSettingAccesoryTypeNormal;
    }else if (param.length > 0) {
        model.accesoryType = WYSettingAccesoryTypeNormal;
    }
    [self.tableView reloadData];
}

#pragma mark -- Action
- (void)saveAction:(UIButton *)sender {
    NSString *filteredName = self.nickTF.textField.text.wy_stringByTrimWhiteSpace;
    if (filteredName.length <= 0) { //空
        WY_HUD_SHOW_STATUS(WYLocalString(@"error_nicknameNotBeNull"));
        return;
    }
    [self.view endEditing:YES];
    if ([self.camera.info.nickname isEqualToString:filteredName]) {//未更改
        return;
    }
    
    [self networkRequestChangeNickName:filteredName];
    
}
- (void)deleteAction:(UIButton *)sender {
    WY_WeakSelf
    [WYAlertView showWithTitle:WYLocalString(@"Delete")
                       message:WYLocalString(@"warn_deleteDevice")
                  cancelButton:WYLocal_Cancel
                   otherButton:WYLocalString(@"Delete")
                   alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                       if (buttonIndex == alertView.cancelButtonIndex) {
                           
                       }else {
                           [weakSelf networkRequestDeleteDevice];
                       }
                   }];
}
- (void)mirrorAction:(UISwitch *)sender {
    WY_WeakSelf
    [self.camera setMirrorOpen:sender.isOn success:^{
        for (WYCameraSettingModel *m in weakSelf.dataSource) {
            if (m.type == WYSettingCellTypeMirror) {
                m.detailedText = sender.isOn ? WYLocalString(@"180"): WYLocalString(@"Normal");
                break;
            }
        }
        if (weakSelf.wy_isTop) {
            [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
        }
    } failure:^(NSError *error) {
        if (weakSelf.wy_isTop) {
            [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
            [sender setOn:!sender.isOn animated:YES];
        }
    }];
}
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self.tableView removeGestureRecognizer:sender];
    self.nickTF.textField.text = self.camera.info.nickname;
}
- (void)backAction:(UIButton *)sender {
    [self wy_pop];
}
- (void)refreshAction:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath || indexPath.row >= self.dataSource.count) return;
    
    WYCameraSettingModel *model = self.dataSource[indexPath.row];
    model.accesoryType = WYSettingAccesoryTypeJuhua;
    [self.tableView reloadData];
    
    if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell) {
        [self getParamsVoiceBell];
    } else {
        [self initConnect];
    }
    
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeCameraSettingNVR: {
            self.camera.hasBindedNvr = NO;
            for (WYCameraSettingModel *model in self.dataSource) {
                if (model.type == WYSettingCellTypeNVR) {
                    [self.dataSource removeObject:model];
                    break;
                }
            }
            [self.tableView reloadData];
            break;
        }
        case WYVCTypeCameraVideoOne:
        case WYVCTypeVoiceDoorbellAlarm:
        case WYVCTypeCameraList: {
            if (WY_IsKindOfClass(obj, MeariDevice)) {
                self.camera = obj;
            }
            break;
        }
        default:
            break;
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
        [cell addLineViewAtBottom];
        UIImageView *imageV = [UIImageView new];
        imageV.tag = 10000;
        imageV.backgroundColor = [UIColor redColor];
        imageV.layer.masksToBounds = YES;
        imageV.layer.cornerRadius = 4.0f;
        imageV.hidden = YES;
        [cell.textLabel addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.textLabel);
            make.leading.equalTo(cell.textLabel.mas_trailing).with.offset(3);
            make.height.equalTo(@8);
            make.width.equalTo(@8);
        }];
    }
    cell.textLabel.font = WYFont_Text_M_Normal;
    cell.detailTextLabel.font = WYFont_Text_M_Normal;
    
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WY_iPhone_4 ? 50 : 70;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraSettingModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text       = model.text;
    cell.textLabel.textColor  = model.textColor;
    cell.detailTextLabel.text = model.detailedText;
    cell.imageView.image      = model.imageName ? [UIImage imageNamed:model.imageName] : nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.accessoryView  = nil;
    [cell.textLabel viewWithTag:10000].hidden = YES;
    switch (model.type) {
        case WYSettingCellTypeShare: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case WYSettingCellTypeSdcard: {
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case WYSettingCellTypeNVR: {
            if (self.camera.info.shared) {
                cell.detailTextLabel.text = self.camera.info.nickname;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            break;
        }
        case WYSettingCellTypeSleepMode: {
            switch (model.accesoryType) {
                case WYSettingAccesoryTypeNone: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeNormal: {
                    cell.detailTextLabel.text = nil;
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    break;
                }
                case WYSettingAccesoryTypeJuhua: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeOverTime: {
                    cell.accessoryView = self.overtimeBtn;
                    break;
                }
                default:break;
            }
            break;
        }
        case WYSettingCellTypeMirror: {
            switch (model.accesoryType) {
                case WYSettingAccesoryTypeNone: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeNormal: {
                    cell.detailTextLabel.text = nil;
                    cell.accessoryView = self.mirrorSW;
                    self.mirrorSW.on = [model.detailedText boolValue] ;
                    break;
                }
                case WYSettingAccesoryTypeJuhua: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeOverTime: {
                    cell.accessoryView = self.overtimeBtn;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case WYSettingCellTypeMotion: {
            switch (model.accesoryType) {
                case WYSettingAccesoryTypeNone: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeNormal: {
                    if (!self.camera.info.shared) {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                    break;
                }
                case WYSettingAccesoryTypeJuhua: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeOverTime: {
                    cell.accessoryView = self.overtimeBtn;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case WYSettingCellTypeVersion: {
            [cell.textLabel viewWithTag:10000].hidden = !self.camera.info.needUpdate;
            switch (model.accesoryType) {
                case WYSettingAccesoryTypeNone: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeNormal: {
                    if (!self.camera.info.shared) {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                    cell.detailTextLabel.text = model.detailedText.wy_shortVersion;
                    break;
                }
                case WYSettingAccesoryTypeJuhua: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeOverTime: {
                    cell.accessoryView = self.overtimeBtn;
                    break;
                }
                default:break;
            }
            break;
        }
            
            //门铃
        case WYSettingCellTypeJingleBell:
        case WYSettingCellTypePIRDetection: {
            switch (model.accesoryType) {
                case WYSettingAccesoryTypeNone: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeNormal: {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    break;
                }
                case WYSettingAccesoryTypeJuhua: {
                    [cell showIndicatorView];
                    break;
                }
                case WYSettingAccesoryTypeOverTime: {
                    cell.accessoryView = self.overtimeBtn;
                    break;
                }
                default: break;
            }
            break;
        }
        case WYSettingCellTypeHostMessage: {
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case WYSettingCellTypeBellVolume: {
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case WYSettingCellTypePowerManagement: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case WYSettingCellTypeBatteryLock: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        default:break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.camera.info.shared) return;
    
    WYCameraSettingModel *model = self.dataSource[indexPath.row];
    
    switch (model.type) {
        case WYSettingCellTypeMotion: {
            if (model.accesoryType != WYSettingAccesoryTypeNormal) return;
            [self wy_pushToVC:WYVCTypeCameraSettingMotion sender:self.camera];
            break;
        }
        case WYSettingCellTypeVersion: {
            if (model.accesoryType != WYSettingAccesoryTypeNormal) return;
            self.camera.info.version = model.detailedText;
            [self wy_pushToVC:WYVCTypeCameraSettingVersion sender:self.camera];
            break;
        }
        case WYSettingCellTypeSdcard: {
            [self wy_pushToVC:WYVCTypeCameraSettingSDCard sender:self.camera];
            break;
        }
        case WYSettingCellTypeShare: {
            [self wy_pushToVC:WYVCTypeCameraSettingShare sender:self.camera];
            break;
        }
        case WYSettingCellTypeSleepMode: {
            if (model.accesoryType == WYSettingAccesoryTypeNormal) {
                [self wy_pushToVC:WYVCTypeCameraSettingSleepmode sender:self.camera];
            }
            break;
        }
        case WYSettingCellTypeNVR: {
            if (!self.camera.info.shared) {
                [self wy_pushToVC:WYVCTypeCameraSettingNVR sender:self.camera];
            }
            break;
        }
            
        case WYSettingCellTypePIRDetection: {
            WYDoorBellSettingPIRDetectionVC *vc = [[WYDoorBellSettingPIRDetectionVC alloc] initWithPIRLeavel:model.detailedText camera:self.camera doorBell:self.doorBell];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WYSettingCellTypeJingleBell: {
            if (model.accesoryType != WYSettingAccesoryTypeNormal) return;
            
            if (self.camera.info.subType == MeariDeviceSubTypeIpcVoiceBell) {
                
                //                [self wy_pushToVC:WYVCTypeJingleBellVoice sender:self.camera];
            } else {
                [self wy_pushToVC:WYVCTypeJingleBell sender:self.camera];
            }
            
            
            break;
        }
        case WYSettingCellTypeHostMessage: {
            [self wy_pushToVC:WYVCTypeHostMessage sender:self.camera];
            break;
        }
        case WYSettingCellTypeBellVolume: {
            [self wy_pushToVC:WYVCTypeBellVolume sender:@[WY_SafeValue(self.camera), WY_SafeValue(self.doorBell)]];
            break;
        }
        case WYSettingCellTypePowerManagement: {
            [self wy_pushToVC:WYVCTypePowerManagement sender:@[WY_SafeValue(self.camera), WY_SafeValue(self.doorBell)]];
            break;
        }
            
        case WYSettingCellTypeBatteryLock: {
            if (![self.doorBell.power isEqualToString:WYLocalString(@"battery")]) {
                WY_HUD_SHOW_TOAST(WYLocalString(@"当前没有电池"));
                return;
            }
            [self wy_pushToVC:WYVCTypeBatteryLock sender:@[WY_SafeValue(self.camera), WY_SafeValue(self.doorBell)]];
            break;
        }
            
        default:break;
    }
}

#pragma mark - Public


@end
