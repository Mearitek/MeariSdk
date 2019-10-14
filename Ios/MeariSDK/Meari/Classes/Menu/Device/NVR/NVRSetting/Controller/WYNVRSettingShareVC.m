//
//  WYNVRSettingShareVC.m
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingShareVC.h"
#import "WYNVRSettingShareModel.h"
#import "WYNVRSettingShareCell.h"

@interface WYNVRSettingShareVC ()<WYNVRSettingShareCellDelegate>
@property (nonatomic, assign)NSInteger deviceID;
@end

@implementation WYNVRSettingShareVC
#pragma mark - Private
#pragma mark -- Getter
#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"SHARE");
    
    WY_WeakSelf
    self.setTableView = ^(UITableView *tableView) {
        [tableView wy_registerClass:[WYNVRSettingShareCell class] fromNib:YES];
        tableView.tableHeaderView = [WYTableHeaderView header_nvrShare];
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf networkRequestList];
        }];
    };
}
- (void)initLayout {
    WY_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- Utilities
#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- Network
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getFriendListForDeviceWithDeviceType:MeariDeviceTypeNVR deviceID:self.deviceID success:^(NSArray<MeariFriendInfo *> *friends) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:friends];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
    
}
- (void)networkRequestShareWithShared:(BOOL)shared model:(WYNVRSettingShareModel *)model failure:(WYBlock_Void)failure{
    WY_HUD_SHOW_WAITING
    WYBlock_Void suc = ^{
        NSString *tips = shared ? WYLocalString(@"success_share") : WYLocalString(@"success_cancelShare");
        WY_HUD_SHOW_SUCCESS_STATUS(tips)
        model.info.deviceShared = shared;
    };
    WYBlock_Error fail = ^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
        if (failure) {
            failure();
        }
    };
    if (shared) {
#warning TODO: 分享NVR
//        [[MeariUser sharedInstance] shareDeviceWithDeviceType:MeariDeviceTypeNVR deviceID:self.deviceID toFriend:model.info.userID success:suc failure:fail];
    }else {
//        [[MeariUser sharedInstance] cancelShareDeviceWithDeviceType:MeariDeviceTypeNVR deviceID:self.deviceID toFriend:model.info.userID success:suc failure:fail];
    }
}
- (void)dealNetworkDataList:(NSArray *)data {
    [self.dataSource removeAllObjects];
    for (MeariFriendInfo *info in data) {
        WYNVRSettingShareModel *model = [WYNVRSettingShareModel new];
        model.info = info;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate
#pragma mark - WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeNVRSetting:
            if (WY_IsKindOfClass(obj, MeariDevice)) {
                MeariDevice *d = (MeariDevice *)obj;
                self.deviceID = d.info.ID;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYNVRSettingShareCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYNVRSettingShareCell) forIndexPath:indexPath];
    WYNVRSettingShareModel *model = self.dataSource[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - WYShareCellDelegate
- (void)WYNVRSettingShareCell:(WYNVRSettingShareCell *)cell didTapedSelectedBtn:(UIButton *)button {
    button.selected = !button.isSelected;
    [self networkRequestShareWithShared:button.isSelected model:cell.model failure:^{
        button.selected = !button.isSelected;
    }];
}


@end
