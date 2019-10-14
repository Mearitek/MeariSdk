//
//  WYDoorBellSettingPIRDetectionVC.m
//  Meari
//
//  Created by FMG on 2017/7/25.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingPIRDetectionVC.h"
#import "WYDoorBellSettingPIRDetection.h"
#import "WYDoorSettingPIRDetectionCell.h"
#import "WYDoorBellSettingSwitchView.h"
#import "WYCameraSettingModel.h"

@interface WYDoorBellSettingPIRDetectionVC ()<UITableViewDelegate,WYDoorBellSettingSwitchViewDelegate>
{
    NSInteger _selectedIndex;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy)NSString *currentPIRLeavel;
@property (nonatomic, strong) WYDoorBellSettingSwitchView *headerView;
@property (nonatomic, strong) MeariDeviceParamBell *doorBell;
@property (nonatomic, assign) NSInteger headerHeight;

@property (nonatomic, strong) MeariDevice *camera;

@end

@implementation WYDoorBellSettingPIRDetectionVC
- (instancetype)initWithPIRLeavel:(NSString *)PIRLeavel camera:(MeariDevice *)camera doorBell:(MeariDeviceParamBell*)doorBell {
    self = [super init];
    if (self) {
        self.currentPIRLeavel = PIRLeavel;
        self.doorBell = doorBell;
        self.camera = camera;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInit];
}
- (void)setInit {
    self.title = WYLocalString(@"PIR DETECTION");
    self.dataSource = self.doorBell.pir.enable? [WYDoorBellSettingPIRDetection PIRDetectionModes].mutableCopy : nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView wy_registerClass:WYDoorSettingPIRDetectionCell.class fromNib:YES];
    _selectedIndex = self.doorBell.pir.level ? self.doorBell.pir.level -1 : 1;
    
}

#pragma mark - WYDoorBellSettingSwitchViewDelegate
- (void)doorBellSettingSwitchView:(WYDoorBellSettingSwitchView *)view switchOpen:(BOOL)open {
    WY_WeakSelf
    [self changePIRLevel:open?self.camera.param.bell.pir.level :MeariDeviceLevelOff success:^{
        weakSelf.dataSource = open ? [WYDoorBellSettingPIRDetection PIRDetectionModes].mutableCopy : nil;
        [weakSelf.tableView reloadData];
    } failure:^{
        weakSelf.dataSource = !open ? [WYDoorBellSettingPIRDetection PIRDetectionModes].mutableCopy : nil;
        [weakSelf.headerView setSwitchOpen:![weakSelf.headerView isOpen]];
        [weakSelf.tableView reloadData];
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYDoorSettingPIRDetectionCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYDoorSettingPIRDetectionCell)];
    [cell addLineViewAtTop];
    [cell addLineViewAtBottom];
    WYDoorBellSettingPIRDetection *model = self.dataSource[indexPath.row];
    model.selected = _selectedIndex == indexPath.row;
    cell.PIRDetectionMode = model;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WY_WeakSelf
    [self changePIRLevel:(MeariDeviceLevel)(indexPath.row + 1) success:^{
        _selectedIndex = indexPath.row;
        [self.tableView reloadData];
    } failure:^{
        [weakSelf.headerView setSwitchOpen:YES];
        [weakSelf.tableView reloadData];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WY_NormalRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.headerView viewHeight];
}

- (void)changePIRLevel:(MeariDeviceLevel)level success:(WYBlock_Void)success failure:(WYBlock_Void)failure {
    WY_WeakSelf
    [self.camera setDoorBellPIRLevel:level success:^{
        [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
        [WY_NotificationCenter wy_post_Device_ChangeParam:^(WYObj_Device *device) {
            device.deviceID = weakSelf.camera.info.ID;
            device.paramType = WYSettingCellTypePIRDetection;
            NSString *pir;
            if (level == MeariDeviceLevelLow) {
                pir = WYLocalString(@"motion_low").copy;
            }else if (level == MeariDeviceLevelMedium) {
                pir = WYLocalString(@"motion_medium").copy;
            }else if (level == MeariDeviceLevelHigh) {
                pir = WYLocalString(@"motion_high").copy;
            }else {
                pir = WYLocalString(@"pir_off").copy;
            }
            device.paramValue = pir;
        }];
        _selectedIndex = (NSInteger)level - 1;

        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
        [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
    }];
}


#pragma mark - lazyLoad
- (WYDoorBellSettingSwitchView *)headerView {
    if (!_headerView) {
        _headerView = [[WYDoorBellSettingSwitchView alloc] initWithSwTitle:WYLocalString(@"Pir Detection") description:WYLocalString(@"des_jingleBellPir")];
        [_headerView setSwitchOpen:self.doorBell.pir.enable];
        _headerView.delegate = self;
    }
    return _headerView;
}


@end
