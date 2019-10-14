//
//  WYCameraListVC.m
//  Meari
//
//  Created by 李兵 on 15/12/23.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "WYCameraListVC.h"
#import "WYCameraListCell.h"
#import "WYNVRCell.h"

#import "WYCameraSettingVC.h"
#import "WYCameraVideoOneVC.h"

@interface WYCameraListVC () <WYCameraListCellDelegate, WYNVRCellDelegate>
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*ipcs;
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*doorbells;
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*voicebells;
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*batteryIpcs;
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*nvrs;
@property (nonatomic, strong)NSMutableDictionary *allDataSource;
@property (nonatomic, strong)NSArray *deviceKindsArr;
@end

@implementation WYCameraListVC
#pragma mark - Private
#pragma mark -- Getter
WYGetter_MutableArray(ipcs)
WYGetter_MutableArray(doorbells)
WYGetter_MutableArray(voicebells)
WYGetter_MutableArray(batteryIpcs)
WYGetter_MutableArray(nvrs)
- (NSArray *)deviceKindsArr {
    if (!_deviceKindsArr) {
        _deviceKindsArr = @[@"ipc",@"fourthGeneration",@"doorbell",@"voiceBell",@"batteryCamera",@"nvr"];
    }
    return _deviceKindsArr;
}
- (NSMutableDictionary *)allDataSource {
    if (!_allDataSource) {
        _allDataSource = @{@"ipc":[NSArray array],@"fourthGeneration":[NSArray array],@"doorbell":[NSArray array],@"voiceBell":[NSArray array],@"batteryCamera":[NSArray array],@"nvr":[NSArray array]}.mutableCopy;
    }
    return _allDataSource;
}
#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"MY DEVICE");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addImageItemWithTarget:self action:@selector(addAction:)];
    
    WY_WeakSelf
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView wy_registerClass:[WYCameraListCell class] fromNib:YES];
    [self.tableView wy_registerClass:[WYNVRCell class] fromNib:YES];
    self.tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf networkRequestList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(n_addDevice:) name:WYNotification_Device_Add object:nil];
    [WY_NotificationCenter addObserver:self selector:@selector(n_deleteDevice:) name:WYNotification_Device_Delete object:nil];
}
#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)deallocAction {
    [WY_NotificationCenter removeObserver:self];
}

#pragma mark -- Notification
- (void)n_addDevice:(NSNotification *)sender {
    [self.tableView.mj_header beginRefreshing];
}
- (void)n_deleteDevice:(NSNotification *)sender {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -- Network
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getDeviceList:^(MeariDeviceList *deviceList) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:deviceList];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealNetworkDataList:(MeariDeviceList *)deviceList {
    [self.allDataSource removeAllObjects];
    _allDataSource = nil;
    if (deviceList.ipcs.count > 0) {
        [self.allDataSource setObject:deviceList.ipcs forKey:@"ipc"];
    }
    if (deviceList.bells.count > 0) {
        [self.allDataSource setObject:deviceList.bells forKey:@"doorbell"];
    }
    if (deviceList.voicebells.count > 0) {
        [self.allDataSource setObject:deviceList.voicebells forKey:@"voiceBell"];
    }
    if (deviceList.batteryIpcs.count > 0) {
        [self.allDataSource setObject:deviceList.batteryIpcs forKey:@"batteryCamera"];
    }
    if (deviceList.nvrs.count > 0) {
        [self.allDataSource setObject:deviceList.nvrs forKey:@"nvr"];
    }
    [self.tableView reloadData];
}
- (void)networkRequestDeleteDeviceWithCell:(WYCameraListCell *)cell {
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] deleteDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:cell.camera.info.ID success:^{
        WY_HUD_DISMISS
        [weakSelf networkRequestList];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
#pragma mark -- Action
- (void)addAction:(UIButton *)sender {
    [self wy_pushToVC:WYVCTypeCameraSelectKind];
}

#pragma mark - Delegate

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allDataSource allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.allDataSource[self.deviceKindsArr[section]];
    return rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName([WYCameraListCell class]) forIndexPath:indexPath];
    NSString *keyType = self.deviceKindsArr[indexPath.section];
    if ([keyType isEqualToString:@"nvr"]) {
        WYNVRCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName([WYNVRCell class]) forIndexPath:indexPath];
        MeariDevice *model = self.allDataSource[keyType][indexPath.row];
        cell.nvr = model;
        cell.delegate = self;
        return cell;
    } else {
        MeariDevice *camera = self.allDataSource[keyType][indexPath.row];
        cell.camera = camera;
        cell.delegate = self;
        return cell;
    }
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyType = self.deviceKindsArr[indexPath.section];
    if ([keyType isEqualToString:@"nvr"]) {
        return 80;
    }
    return (WY_ScreenWidth - 2*12)/16*9 + 60;
}

#pragma mark -- WYCameraListCellDelegate
- (void)WYCameraListCell:(WYCameraListCell *)cell didSelectPlayBtn:(UIButton *)btn {
    __block MeariDevice *camera = cell.camera;
    if (camera.info.subType == MeariDeviceSubTypeIpcVoiceBell) {
        [self wy_pushToVC:WYVCTypeVoiceDoorbellAlarm sender:camera];
        return;
    }
    WYVideo *video = [WYVideo videoWithCamera:cell.camera videoType:WYVideoTypePreviewHD dateComponets :nil];
    [self wy_pushToVC:WYVCTypeCameraVideoOne sender:video];
}
- (void)WYCameraListCell:(WYCameraListCell *)cell didLongPressedPlayBtn:(UIButton *)btn {
    [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"warn_deleteDevice") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            [self networkRequestDeleteDeviceWithCell:cell];
        }
    }];
}
- (void)WYCameraListCell:(WYCameraListCell *)cell didSelectMsgBtn:(UIButton *)btn {
    [self wy_pushToVC:WYVCTypeMsgAlarmDetail sender:cell.camera];
}

#pragma mark -- WYNVRCellDelegate
- (void)WYNVRCell:(WYNVRCell *)cell didSelectSettingBtn:(UIButton *)btn {
    [self wy_pushToVC:WYVCTypeNVRSetting sender:cell.nvr];
}

@end
