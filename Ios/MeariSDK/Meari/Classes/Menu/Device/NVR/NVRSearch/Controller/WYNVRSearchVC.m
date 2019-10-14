//
//  WYNVRSearchVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYNVRSearchVC.h"
#import "WYCameraSearchCell.h"


@interface WYNVRSearchVC ()<WYCameraSearchCellDelegate>
{
    BOOL _needRefresh;      //刷新
}
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*searchSource;
@end

@implementation WYNVRSearchVC

#pragma mark -- Getter
WYGetter_MutableArray(searchSource)

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needRefresh && self.tableView.mj_header) {
        [self.tableView.mj_header beginRefreshing];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopSearch];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
}
#pragma mark init
- (void)initSet {
    //navigationItem
    self.navigationItem.title = WYLocalString(@"ADD NVR");

    [self setLabelText:WYLocalString(@"des_searchNVR")];
    [self setTopBtnTitle:WYLocalString(@"Back to home")];
    [self setBottomBtnTitle:WYLocalString(@"RETURN LIST") filled:NO];
    self.hideTopBtn = YES;
    [self.tableView registerNib:[UINib nibWithNibName:WY_ClassName(WYCameraSearchCell) bundle:nil] forCellReuseIdentifier:WY_ClassName(WYCameraSearchCell)];
    
    [(WYRefreshNormalHeader *)self.tableView.mj_header wy_setNVRTitle];
}


#pragma mark 网络请求
- (void)networkRequestAddDevice:(MeariDevice*)device {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] addDeviceWithDeviceType:MeariDeviceTypeNVR uuid:device.info.uuid sn:device.info.sn tp:device.info.tp key:device.info.key deviceName:device.info.nickname success:^{
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"success_addDevice"))
        [WY_NotificationCenter wy_post_Device_Add:^(WYObj_Device *device) {
            device.deviceType = MeariDeviceTypeNVR;
        }];
        for (MeariDevice *device in weakSelf.dataSource) {
            if ([device.info.sn isEqualToString:device.info.sn]) {
                device.info.addStatus = MeariDeviceAddStatusSelf;
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

- (void)networkRequestStatusWithDevices:(NSArray<MeariDevice *> *)deviceArray{
    WY_WeakSelf
    [[MeariUser sharedInstance]  checkDeviceStatusWithDeviceType:MeariDeviceTypeNVR devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {
        [weakSelf dealNetworkData:devices];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
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
        }else {
            [self insertObject:device inDataSourceAtIndex:0];
        }
    }
    [self.tableView reloadData];
}

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
    [MeariDevice startSearch:^(MeariDevice *device) {
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
    [[MeariUser sharedInstance] cancelAllRequest];
    WY_WeakSelf
    if (self.dataSource.count <= 0 && self.isStopedByOvertime && self.wy_isTop) {
        [WYAlertView showSearchNullWithCancelAction:nil otherAction:^{
            [weakSelf startSearch];
        }];
    }
}
- (void)clickTopBtn:(UIButton *)sender {
    [super clickTopBtn:sender];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [WY_Appdelegate wy_loadCameraVC];
}
- (void)clickBottomBtn:(UIButton *)sender {
    [super clickBottomBtn:sender];
    [self wy_popToRootVC];
}


#pragma mark WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeNVRInstall: {
            _needRefresh = YES;
            break;
        }
        default: {
            _needRefresh = NO;
            break;
        }
    }
}

#pragma mark UITableViewDataSource
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
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

#pragma mark WYCameraSearchCellDelegate
- (void)WYCameraSearchCell:(WYCameraSearchCell *)cell tapActionButtonToAdd:(UIButton *)btn {
    [self networkRequestAddDevice:cell.device];
}

@end
