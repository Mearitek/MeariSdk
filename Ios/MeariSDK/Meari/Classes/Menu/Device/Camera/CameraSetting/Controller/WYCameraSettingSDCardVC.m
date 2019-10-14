//
//  SettingSDCardVC.m
//  Meari
//
//  Created by 李兵 on 16/5/5.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSDCardVC.h"
#import "WYCameraSettingSDCardModel.h"

@interface WYCameraSettingSDCardVC ()<UIAlertViewDelegate, WYProgressUpgradeViewDelegate>

@property (nonatomic, weak) WYProgressUpgradeView *progressV;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)CGFloat footerHeight;
@property (nonatomic, assign)BOOL hasSDCard;
@property (nonatomic, assign)BOOL isUpgrading;
@property (nonatomic, strong)NSTimer *updateTimer;
@property (nonatomic, strong)MeariDevice *device;

@end

@implementation WYCameraSettingSDCardVC

#pragma mark - Private
#pragma mark -- Getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSTimer *)updateTimer {
    if (!_updateTimer) {
        _updateTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToQueryPercent:)];
    }
    return _updateTimer;
}

#pragma mark -- Init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = self.device.info.type == MeariDeviceTypeNVR ? WYLocalString(@"HARD DISK") : WYLocalString(@"SD Card");
    self.tableView.scrollEnabled = NO;
    
    WYCameraSettingSDCardModel *model = [WYCameraSettingSDCardModel new];
    model.paramName = WYLocalString(@"Capacity");
    [self.dataSource addObject:model];
}
- (void)initConnect {
    if (self.device.sdkLogining) return;
    
    if (self.device.sdkLogined) {
        [self getSDCardInfo];
    }else {
        [self.device wy_startConnectSuccess:nil failure:nil];
    }
}
- (void)getSDCardInfo {
    WY_WeakSelf
    [self.device getStorageInfoSuccess:^(MeariDeviceParamStorage *storage) {
        if (storage.isFormatting) {
            weakSelf.isUpgrading =  storage.isFormatting;
            [weakSelf updateUIWithSuccess:YES space:storage.totalSpace];
        }else {
            weakSelf.isUpgrading = NO;
            [weakSelf updateUIWithSuccess:YES space:WYLocalString(@"No SDCard")];
        }
    } failure:^(NSError *error) {
        [weakSelf updateUIWithSuccess:NO space:weakSelf.device.info.type == MeariDeviceTypeNVR ? WYLocalString(@"fail_getHardDiskInfo") : WYLocalString(@"fail_getSDCardInfo")];
    }];
}


#pragma mark -- Life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self enableUpdateTimer:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initNotification];
    [self initConnect];
}
- (void)deallocAction {
    [self removeNotification];
    if (self.device.info.type == MeariDeviceTypeNVR) {
        [self.device stopConnectSuccess:nil failure:nil];
    }
}

#pragma mark -- Network
#pragma mark -- Notification
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(n_connectCompleted:) name:WYNotification_Device_ConnectCompleted object:nil];
}
- (void)removeNotification {
    [WY_NotificationCenter removeObserver:self];
}
- (void)n_connectCompleted:(NSNotification *)sender {
    if (!self.wy_isTop) return;
    WYObj_Device *device = sender.object;
    if (!device || device.deviceID != self.device.info.ID) return;
    if (device.connectSuccess) {
        [self getSDCardInfo];
    }else {
        [self updateUIWithSuccess:NO space:self.device.info.type == MeariDeviceTypeNVR ? WYLocalString(@"fail_getHardDiskInfo") : WYLocalString(@"fail_getSDCardInfo")];
    }
}
#pragma mark -- NSTimer
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
            WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_format"), strongSelf);
        }else {
            strongSelf.progressV.progress = percent/100.0f;
        }
    };
    [self.device getFormatPercentSuccess:^(NSInteger percent) {
        canDo = YES;
        failCount = 0;
        dealPercentFromSucCallback(YES, percent);
    } failure:^(NSError *error) {
        canDo = YES;
        failCount++;
        dealPercentFromSucCallback(NO, -666);
    }];
}

#pragma mark -- Utilitie
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
- (void)updateUIWithSuccess:(BOOL)success space:(NSString *)space {
    
    [self.dataSource removeAllObjects];
    WYCameraSettingSDCardModel *model = [WYCameraSettingSDCardModel new];
    model.paramName             = WYLocalString(@"Capacity");
    model.paramValue   = space;
    self.hasSDCard = success;
    [self.dataSource addObject:model];
    [self.tableView reloadData];
}

#pragma mark -- Action
#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        self.device = obj;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell addLineViewAtBottom];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WYCameraSettingSDCardModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.paramName;
    cell.detailTextLabel.text = model.paramValue;
    if (cell.detailTextLabel.text.length <= 0) {
        [cell showIndicatorView];
    }else {
        cell.accessoryView = nil;
    }
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.hasSDCard) return 0.1;
    
    CGFloat w = WY_ScreenWidth - 2*20;
    CGFloat h = [self.device.info.type == MeariDeviceTypeNVR ? WYLocalString(@"warn_formatHardDisk") : WYLocalString(@"warn_formatSDCard") wy_heightWithWidth:w font:WYFont_Text_XS_Normal breakMode:NSLineBreakByWordWrapping];
    return h + 60 + 2*20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.hasSDCard) return nil;
    
    UIView *view = [UIView new];
    UILabel *label = [UILabel labelWithFrame:CGRectZero
                                        text:self.device.info.type == MeariDeviceTypeNVR ? WYLocalString(@"warn_formatHardDisk") : WYLocalString(@"warn_formatSDCard")
                                   textColor:WY_FontColor_Gray
                                    textfont:WYFont_Text_XS_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByWordWrapping
                               lineAlignment:NSTextAlignmentCenter
                                   sizeToFit:NO];
    [view addSubview:label];
    
    WYProgressUpgradeView *upgradeV = [WYProgressUpgradeView upgradeViewWithBeginText:WYLocalString(@"Format")
                                                                          prepareText:WYLocalString(@"Prepare")
                                                                              endText:WYLocalString(@"Done")];
    upgradeV.delegate = self;
    [view addSubview:upgradeV];
    self.progressV = upgradeV;
    
    CGFloat w = WY_ScreenWidth - 2*20;
    CGFloat h = [label ajustedHeightWithWidth:w];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).with.offset(20);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    [upgradeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(view);
        make.top.equalTo(label.mas_bottom).with.offset(20);
        make.height.equalTo(@60);
    }];
    if (self.isUpgrading) {
        [self prepareToUpdate];
    }
    return view;
}

#pragma mark -- WYProgressUpgradeViewDelegate
- (void)WYProgressUpgradeViewWillUpgrade:(WYProgressUpgradeView *)upgradeView {
    [self prepareToUpdate];
}
- (void)WYProgressUpgradeViewBeginUpgrade:(WYProgressUpgradeView *)upgradeView {
    if (self.isUpgrading) {
        [self enableUpdateTimer:YES];
        return;
    }
    WY_WeakSelf
    [self.device formatSuccess:^{
        WY_StrongSelf
        [strongSelf enableUpdateTimer:YES];
    } failure:^(NSError *error) {
        WY_StrongSelf
        WY_HUD_SHOW_SUCCESS_STATUS_VC(WYLocalString(@"fail_format"), strongSelf)
    }];
}
- (void)WYProgressUpgradeViewUpdgradeSuccess:(WYProgressUpgradeView *)upgradeView {
    [self enableUpdateTimer:NO];
    
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
    [self.progressV prepareToUpdate];
}

@end
