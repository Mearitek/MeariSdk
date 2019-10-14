//
//  WYCameraSearchVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSearchVC.h"
#import "WYCameraSearchCell.h"


@interface WYCameraSearchVC ()<WYCameraSearchCellDelegate>
{
    WYWifiInfo *_wifi;        //Wi-Fi信息
    BOOL _justSearch;       //Y-只搜索，N-搜索+配网
}
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*searchSource;
@property (nonatomic, assign)WYCameraSelectConfigMode mode;

@end

@implementation WYCameraSearchVC
#pragma mark - Private
#pragma mark -- Getter
WYGetter_MutableArray(searchSource)

#pragma mark -- Init
- (void)initSet {
    //navigationItem
    self.navigationItem.title = WYLocalString(@"ADD DEVICES");
    
    if (self.wy_pushFromVCType == WYVCTypeCameraQRCodeMaker) {
        self.hideTopBtn = YES;
//        [self setLabelText:WYLocalString(@"des_help_configFail")];
        [self setLabelEnabled:YES];
        [self setBottomBtnTitle:WYLocalString(@"RETURN LIST") filled:YES];
    }else {
//        if (self.wy_pushFromVCType == WYVCTypeCameraWifi) {
//            [self setLabelText:WYLocalString(@"camera_search_beforeScan_des")];
//            [self setTopBtnTitle:WYLocalString(@"CODE ADD")];
//        }else {
//            self.hideTopLabel = YES;
//            self.hideTopBtn = YES;
//        }
        self.hideTopBtn = YES;
        [self setLabelEnabled:YES];
        [self setBottomBtnTitle:WYLocalString(@"RETURN LIST") filled:YES];
    }
    [self setBottomBtnTitle:WYLocalString(@"RETURN LIST") filled:YES];
    [self.tableView registerNib:[UINib nibWithNibName:WY_ClassName(WYCameraSearchCell) bundle:nil] forCellReuseIdentifier:WY_ClassName(WYCameraSearchCell)];
    
    [(WYRefreshNormalHeader *)self.tableView.mj_header wy_setCameraTitle];
}

#pragma mark -- Life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.searchSource.count > 0 && self.wy_pushFromVCType == WYVCTypeCameraQRCodeMaker) {
        [self networkRequestStatusWithDevices:self.searchSource];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopSearch];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self.tableView.mj_header beginRefreshing];
    
    
    //monitor auto Add Device notifacation
    [WY_NotificationCenter addObserver:self selector:@selector(dealAutobindDevice:) name:MeariDeviceAutoAddNotification object:nil];
}

- (void)deallocAction {
    [super deallocAction];
}

- (void)dealAutobindDevice:(NSNotification *)notification {

    MeariMqttMessageInfo *info = notification.object;
    BOOL success = info.data.addStatus == MeariDeviceAddStatusSelf;
    NSLog(@"device sn ----- %@ device add status ---- %d",info.data.sn,success);
//     Use info.data.addStatus to determine whether the device is successfully added.
//    do other......
}

#pragma mark -- Network

- (void)networkRequestStatusWithDevices:(NSArray<MeariDevice *> *)deviceArray{
    WY_WeakSelf
    [[MeariUser sharedInstance] checkDeviceStatusWithDeviceType:MeariDeviceTypeIpc devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {
        [weakSelf dealNetworkData:devices];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)networkRequestAddDevice:(MeariDevice*)device {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] addDevice:device success:^(NSDictionary *dict){
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"success_addDevice"))
        [WY_NotificationCenter wy_post_Device_Add:nil];
        for (MeariDevice *model in weakSelf.dataSource) {
            if ([model.info.sn isEqualToString:device.info.sn]) {
                model.info.addStatus = MeariDeviceAddStatusSelf;
                model.info.ID = [dict[@"deviceID"] integerValue];
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestShareDevice:(MeariDevice *)device {
    WY_WeakSelf
    [[MeariUser sharedInstance] requestShareDeviceWithDeviceType:MeariDeviceTypeIpc sn:device.info.sn success:^{
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"status_waitForDealing"))
        device.info.addStatus = MeariDeviceAddStatusSharing;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
#pragma mark -- Network
- (void)networkRequestToken:(WYBlock_Str)success failure:(WYBlock_Error)failure {
    [[MeariDeviceActivator sharedInstance] getTokenSuccess:^(NSString *token, NSInteger validTime, NSInteger delaySmart) {
        if (token.length > 0) {
            WYDo_Block_Safe1(success, token);
        }else {
            WYDo_Block_Safe1(failure, nil)
        }
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealNetworkData:(NSArray *)data {
    for (MeariDevice *device in data) {
        __block MeariDevice *searchDevice;
        [self.searchSource enumerateObjectsUsingBlock:^(MeariDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([device.info.sn isEqualToString:obj.info.sn]) {
                searchDevice = obj;
                *stop = YES;
            }
        }];
        if (searchDevice && [self.searchSource containsObject:searchDevice]) {
            [self.searchSource removeObject:searchDevice];
        }
        
        __block MeariDevice *existDevice;
        [self.dataSource enumerateObjectsUsingBlock:^(MeariDevice *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([device.info.sn isEqualToString:obj.info.sn]) {
                existDevice = obj;
                *stop = YES;
            }
        }];
        
        if (existDevice) {
            NSInteger index = [self.dataSource indexOfObject:existDevice];
            [self.dataSource replaceObjectAtIndex:index withObject:device];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            WYCameraSearchCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.device = device;
            }
        }else {
            [self insertObject:device inDataSourceAtIndex:0];
        }
    }
}

#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [self wy_popToVC:WYVCTypeCameraInstall];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    _justSearch = YES;
    switch (self.wy_pushFromVCType) {
        case WYVCTypeCameraWifi: {
            _justSearch = NO;
            _wifi = WY_ParamTransfer.wifiInfo;
            _mode = WY_ParamTransfer.selectedKindModel.configMode;
            break;
        }
        case WYVCTypeCameraQRCodeMaker: {
            if (WY_IsKindOfClass(obj, NSNumber)) {
                BOOL scaned = [obj boolValue];
                if (scaned) {
//                    [self setLabelText:WYLocalString(@"camera_search_afterScan_des")];
                    [self startSearch];
                }else {
//                    [self setLabelText:WYLocalString(@"camera_search_beforeScan_des")];
                }
            }else if (WY_IsKindOfClass(obj, NSArray)) {
                NSArray *devices = (NSArray *)obj;
                if (devices.count <= 0) return;
                NSMutableArray *newDevices = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *oldDevices = [NSMutableArray arrayWithCapacity:0];
                for (MeariDevice *device in devices) {
                    MeariDevice *oldDevice;
                    for (MeariDevice *oldD in self.dataSource) {
                        if ([device.info.sn isEqualToString:oldD.info.sn]) {
                            oldDevice = oldD;
                            break;
                        }
                    }
                    if (oldDevice) {
                        [oldDevices addObject:oldDevice];
                    }else {
                        [newDevices addObject:device];
                    }
                }
                if (newDevices.count > 0) {
                    [self.searchSource addObjectsFromArray:newDevices];
                }
            }
            break;
        }
        default: {
            break;
        }
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
    WYCameraSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYCameraSearchCell) forIndexPath:indexPath];
    cell.delegate = self;
    cell.device = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}
#pragma mark -- WYCameraSearchCellDelegate
- (void)WYCameraSearchCell:(WYCameraSearchCell *)cell tapActionButtonToAdd:(UIButton *)btn {
    [self networkRequestAddDevice:cell.device];
}
- (void)WYCameraSearchCell:(WYCameraSearchCell *)cell tapActionButtonToShare:(UIButton *)btn {
    [self networkRequestShareDevice:cell.device];
}

#pragma mark - Public


#pragma mark - Super
- (void)startSearch {
    [super startSearch];
    
    
    if (WY_Network_NoReachable) {
        [self stopSearch];
        WY_HUD_SHOW_Failure
        return;
    }
    if (self.dataSource.count > 0) {
        [self networkRequestStatusWithDevices:self.dataSource];
    }
    
    WY_WeakSelf
    if (!_justSearch) {
        [self networkRequestToken:^(NSString *obj) {
            [MeariDevice startMonitorWifiSSID:_wifi.ssid wifiPwd:_wifi.password token:obj success:^{
                NSLog(@"----");
            } failure:^(NSError *error){
                NSLog(@"----");
            }];
        } failure:^(NSError *error) {
            if (weakSelf.wy_isTop) {
                WY_HUD_SHOW_ServerError
            }
        }];
    }
    MeariDeviceSearchMode mode = self.wy_pushToVCType == WYVCTypeCameraQRCodeMaker ? MeariSearchModeCloud : MeariSearchModeAll;
    //Choose this model with a higher success rate
    mode = MeariSearchModeAll;
    [MeariDevice startSearch:mode success:^(MeariDevice *device) {
        for (MeariDevice *d in weakSelf.dataSource) {
            if ([device.info.sn isEqualToString:d.info.sn]) {
                return;
            }
        }
        
        for (MeariDevice *d in weakSelf.searchSource) {
            if ([device.info.sn isEqualToString:d.info.sn]) {
                return;
            }
        }
        [weakSelf.searchSource addObject:device];
        [weakSelf networkRequestStatusWithDevices:weakSelf.searchSource];
    } failure:nil]; 
}
- (void)stopSearch {
    [super stopSearch];
    [MeariDevice stopSearch];
    [MeariDevice stopMonitor];
    [[MeariUser sharedInstance] cancelAllRequest];
    WY_WeakSelf
    if (self.dataSource.count <= 0 && self.isStopedByOvertime && self.wy_isTop && self.wy_pushFromVCType != WYVCTypeCameraQRCodeMaker) {
        [WYAlertView showSearchCameraNullWithCancelAction:^{
            [weakSelf startSearch];
        } qrAction:^{
            [weakSelf wy_pushToVC:WYVCTypeCameraQRCodeMaker sender:_wifi.copy];
        }];
    }
}
- (void)clickTopBtn:(UIButton *)sender {
    [super clickTopBtn:sender];
    [self wy_pushToVC:WYVCTypeCameraQRCodeMaker sender:_wifi.copy];
}
- (void)clickBottomBtn:(UIButton *)sender {
    [super clickBottomBtn:sender];
    [self wy_popToVC:WYVCTypeCameraList];
}
- (void)clickLabel {
    [super clickLabel];
    [self wy_pushToVC:WYVCTypeHelpLight];
}


#pragma mark ---- Auto Add Device Process
/*
 1.get config token.
  E.g :
    [[MeariDeviceActivator sharedInstance] getTokenSuccess:^(NSString *token, NSInteger validTime, NSInteger delaySmart) {
    // get token
    } failure:^(NSError *error) {
    //....
    }];
 2.Let the camera scan the QR code and Hear the sound of a cuckoo.(User manual)
 
 3.start config device
  E.g :
    [MeariDeviceActivator sharedInstance].delete = self;
    [[MeariDeviceActivator sharedInstance] startConfigWiFi:(MeariSearchModeAll) token:token type:(MeariDeviceTokenTypeQRCode) nvr:NO timeout:100];
 
 4.Obtain the equipment completed by the distribution network.
  E.g :
  - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error;

   // Use deviceModel.info.addStatus to determine whether the device is successfully added.
 
 */

@end
