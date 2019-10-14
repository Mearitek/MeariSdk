//
//  WYNVRSettingVC.m
//  Meari
//
//  Created by 李兵 on 2017/1/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingVC.h"
#import "WYNVRSettingModel.h"

#import "WYSettingSearchView.h"
#import "WYCameraSettingVersionVC.h"
#import "WYCameraSettingSDCardVC.h"


@interface WYNVRSettingVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak  ) UIView     *topView;
@property (nonatomic, weak) UILabel *previewNameLabel;
@property (nonatomic, weak) WYNickTextField *nickTF;
@property (nonatomic, weak  ) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL hadRequestedVersion;

@property (nonatomic, strong) MeariDevice *nvr;
@end

@implementation WYNVRSettingVC
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
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        WYNVRSettingModel *previewNameModel = [WYNVRSettingModel previewNameModel];
        WYNVRSettingModel *ownerModel       = [WYNVRSettingModel ownerModel];
        WYNVRSettingModel *snModel          = [WYNVRSettingModel snModel];
        WYNVRSettingModel *cameraListModel  = [WYNVRSettingModel cameraListModel];
        WYNVRSettingModel *shareModel       = [WYNVRSettingModel shareModel];
        WYNVRSettingModel *versionModel     = [WYNVRSettingModel versionModel];
        WYNVRSettingModel *harddiskModel    = [WYNVRSettingModel harddiskModel];
        
        previewNameModel.detailedText = self.nvr.info.nickname;
        ownerModel.detailedText       = self.nvr.info.userAccount;
        snModel.detailedText          = self.nvr.info.sn;
        versionModel.detailedText     = self.nvr.info.version;
        if (versionModel.detailedText.length > 0) {
            versionModel.accesoryType = WYNVRSettingAccesoryTypeNormal;
        }
        
        
        _dataSource = @[ownerModel,
                        snModel,
                        cameraListModel,
                        shareModel,
                        versionModel,
                        harddiskModel
                        ].mutableCopy;
        if (self.nvr.info.shared) {
            [_dataSource insertObject:previewNameModel atIndex:0];
            [_dataSource removeObject:shareModel];
            [_dataSource removeObject:versionModel];
            [_dataSource removeObject:harddiskModel];
        }
    }
    return _dataSource;
}


#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"SETTINGS");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem deleteImageItemWithTarget:self action:@selector(deleteAction:)];
    self.showNavigationLine = self.nvr.info.shared;
    self.nickTF.textField.text = self.nvr.info.nickname;
}
- (void)initLayout {
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@(weakSelf.nvr.info.shared ? 0 : (WY_iPhone_4 ? 85 : 117)));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
    
    [weakSelf.nickTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(43)).priority(751);
        make.height.lessThanOrEqualTo(weakSelf.topView);
        make.leading.equalTo(weakSelf.topView).with.offset(35);
        make.trailing.equalTo(weakSelf.topView).with.offset(-35);
        make.centerX.equalTo(weakSelf.topView);
        make.centerY.equalTo(weakSelf.topView).with.offset(WY_iPhone_4 ? 8 : 0);
    }];
    
    [weakSelf.previewNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf.topView);
        make.bottom.equalTo(weakSelf.nickTF.mas_top);
    }];
}
- (void)initParams {
    if (self.nvr.info.shared) return;
    WY_WeakSelf
    WYBlock_Void getParams = ^{
        if (weakSelf.nvr.info.version.length <= 0) {
            [weakSelf.nvr getVersionSuccess:^(id obj) {
                weakSelf.nvr.info.version = obj;
                [weakSelf updateCellWithCellType:WYNVRSettingCellTypeVersion param:obj];
            } failure:^(NSError *error) {
                
                [weakSelf updateCellWithCellType:WYNVRSettingCellTypeVersion param:WYLocal_Timeout];
            }];
        }
    };
    if (self.nvr.sdkLogined) {
        getParams();
    }else {
        [self.nvr wy_startConnectSuccess:^{
            getParams();
        } failure:^(NSError *error) {
            if (weakSelf.nvr.info.version.length <= 0) {
                [weakSelf updateCellWithCellType:WYNVRSettingCellTypeVersion param:WYLocal_Timeout];
            }
        }];
    }
}

#pragma mark -- Utilities
- (UIButton *)overtimeBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setImage:[UIImage imageNamed:@"btn_refresh_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_refresh_highlighted"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)updateCellWithCellType:(WYNVRSettingCellType)type param:(NSString *)param{
    WYNVRSettingModel *model;
    for (WYNVRSettingModel *m in self.dataSource) {
        if (m.type == type) {
            model = m;
            break;
        }
    }
    if (!model) return;
    
    model.detailedText = param;
    if ([param isEqualToString:WYLocal_Timeout]) {
        model.detailedText = nil;
        model.accesoryType = WYNVRSettingAccesoryTypeOverTime;
    }else if ([param isEqualToString:@"logined"]) {
        model.detailedText = nil;
        model.accesoryType = WYNVRSettingAccesoryTypeNormal;
    }else if (param.length > 0) {
        model.accesoryType = WYNVRSettingAccesoryTypeNormal;
    }
    NSInteger index = [self.dataSource indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark -- Life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self initParams];
}
- (void)dealloc {
    
    [self removeNotification];
    [self.nvr stopConnectSuccess:nil failure:nil];
}

#pragma mark - Notification
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(settingNotification:) name:WYNotification_Device_ChangeParam object:nil];
}
- (void)removeNotification {
    [WY_NotificationCenter removeObserver:self];
}
- (void)keyboardShowNotification:(NSNotification *)sender {
    [self.tableView addTapGestureTarget:self action:@selector(tapAction:)];
}
- (void)settingNotification:(NSNotification *)sender {
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.nvr.info.ID) return;
    
    WYNVRSettingCellType type = device.paramType;
    WYNVRSettingModel *model;
    for (WYNVRSettingModel *m in self.dataSource) {
        if (m.type == type) {
            model = m;
            break;
        }
    }
    if (model) {
        model.detailedText = device.paramValue;
        if (model.type == WYNVRSettingCellTypeVersion) {
            self.nvr.info.version = model.detailedText;
            self.nvr.info.needForceUpdate = NO;
            self.nvr.info.needUpdate = NO;
        }
        [self.tableView reloadData];
    }
}

#pragma mark -- Action
- (void)saveAction:(UIButton *)sender {
    NSString *filteredName = self.nickTF.textField.text.wy_stringByTrimWhiteSpace;
    if (filteredName.length <= 0) { //空
        WY_HUD_SHOW_STATUS(WYLocalString(@"error_nicknameNotBeNull"));
        return;
    }
    [self.view endEditing:YES];
    if ([self.nvr.info.nickname isEqualToString:filteredName]) {//未更改
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
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self.tableView removeGestureRecognizer:sender];
}
- (void)refreshAction:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYNVRSettingModel *model = self.dataSource[indexPath.row];
    model.accesoryType = WYNVRSettingAccesoryTypeJuhua;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self initParams];
}


#pragma mark - Network
- (void)networkRequestChangeNickName:(NSString *)newNickName {
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] renameDeviceWithDeviceType:MeariDeviceTypeNVR deviceID:self.nvr.info.ID nickname:newNickName success:^{
        if (weakSelf.wy_isTop) {
            WY_HUD_SHOW_SUCCESS
        }
        [WY_NotificationCenter wy_post_Device_ChangeNickname:^(WYObj_Device *device) {
            device.deviceType = MeariDeviceTypeNVR;
            device.deviceID = weakSelf.nvr.info.ID;
            device.deviceName = newNickName;
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
            device.deviceType = MeariDeviceTypeNVR;
            device.deviceID = weakSelf.nvr.info.nvrID;
        }];
        [WY_NotificationCenter wy_post_Device_BindUnBindNVR:nil];
        [self wy_popToVC:WYVCTypeCameraList];
    };
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] deleteDeviceWithDeviceType:MeariDeviceTypeNVR deviceID:self.nvr.info.ID success:^{
        deleteTask();
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

#pragma mark - Delegate
#pragma mark -- WYTranstion
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        self.nvr = obj;
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
    cell.detailTextLabel.font = WYFont_Text_S_Normal;
    
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WY_iPhone_4 ? 50 : 70;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WYNVRSettingModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text       = model.text;
    cell.detailTextLabel.text = model.detailedText;
    cell.imageView.image      = model.imageName ? [UIImage imageNamed:model.imageName] : nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.accessoryView  = nil;
    [cell.textLabel viewWithTag:10000].hidden = YES;
    switch (model.type) {
        case WYNVRSettingCellTypeCameraList: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case WYNVRSettingCellTypeShare: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case WYNVRSettingCellTypeVersion: {
            [cell.textLabel viewWithTag:10000].hidden = !self.nvr.info.needUpdate;
            switch (model.accesoryType) {
                case WYNVRSettingAccesoryTypeNone: {
                    [cell showIndicatorView];
                    break;
                }
                case WYNVRSettingAccesoryTypeNormal: {
                    if (!self.nvr.info.shared) {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                    cell.detailTextLabel.text = model.detailedText.wy_shortVersion;
                    break;
                }
                case WYNVRSettingAccesoryTypeJuhua: {
                    [cell showIndicatorView];
                    break;
                }
                case WYNVRSettingAccesoryTypeOverTime: {
                    cell.accessoryView = self.overtimeBtn;
                    break;
                }
                default:break;
            }
            break;
        }
        case WYNVRSettingCellTypeHardDisk: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        default:break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYNVRSettingModel *model = self.dataSource[indexPath.row];
    switch (model.type) {
        case WYNVRSettingCellTypeCameraList: {
            [self wy_pushToVC:WYVCTypeNVRSettingCameraList sender:self.nvr];
            break;
        }
        case WYNVRSettingCellTypeShare: {
            [self wy_pushToVC:WYVCTypeNVRSettingShare sender:self.nvr];
            break;
        }
        case WYNVRSettingCellTypeVersion: {
            [self wy_pushToVC:WYVCTypeCameraSettingVersion sender:self.nvr];
            break;
        }
        case WYNVRSettingCellTypeHardDisk: {
            [self wy_pushToVC:WYVCTypeCameraSettingSDCard sender:self.nvr];
            break;
        }
        default:break;
    }
}



@end
