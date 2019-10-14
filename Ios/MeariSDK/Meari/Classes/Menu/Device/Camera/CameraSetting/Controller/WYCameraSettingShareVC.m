//
//  WYCameraSettingShareVC.m
//  WeEye
//
//  Created by 李兵 on 16/8/15.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSettingShareVC.h"
#import "WYCameraSettingShareModel.h"
#import "WYCameraSettingShareCell.h"

@interface WYCameraSettingShareVC ()<UITableViewDataSource, UITableViewDelegate,WYShareCellDelegate>
@property (nonatomic, assign)NSInteger deviceID;
@property (nonatomic, copy)NSString *deviceUUID;
@end

@implementation WYCameraSettingShareVC


#pragma mark - 视图控制器
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark - init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"SHARE");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem addImageItemWithTarget:self action:@selector(addAction:)];
    
    self.setTableView = ^(UITableView *tableView) {
        [tableView wy_registerClass:WYCameraSettingShareCell.class fromNib:YES];
    };
}
- (void)initLayout {
    WY_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];

    self.tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf networkRequestList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 网络请求
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getFriendListForDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID success:^(NSArray<MeariFriendInfo *> *friends) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:friends];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
    
}
- (void)networkRequestShareWithShared:(BOOL)shared model:(WYCameraSettingShareModel *)model failure:(WYBlock_Void)failure{
    WYBlock_Void suc = ^{
        NSString *tips = shared ? WYLocalString(@"success_share") : WYLocalString(@"success_cancelShare");
        WY_HUD_SHOW_SUCCESS_STATUS(tips)
    };
    
    WYBlock_Error fail = ^(NSError *error){
        [WY_UserM dealMeariUserError:error];
        WYDo_Block_Safe(failure)
    };
    if (shared) {
        [[MeariUser sharedInstance] shareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID deviceUUID:self.deviceUUID toFriend:model.info.userID success:suc failure:fail];
    }else {
        [[MeariUser sharedInstance] cancelShareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID deviceUUID:self.deviceUUID toFriend:model.info.userID success:suc failure:fail];
    }
}
- (void)dealNetworkDataList:(NSArray *)data {
    [self.dataSource removeAllObjects];
    
    for (MeariFriendInfo *info in data) {
        WYCameraSettingShareModel *model = [WYCameraSettingShareModel new];
        model.info = info;
        [self.dataSource addObject:model];
    }
    self.tableView.tableHeaderView = self.dataSource.count >0 ? [WYTableHeaderView header_cameraShare] : nil;
    [self.tableView reloadData];
}

#pragma mark - 按钮事件
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addAction:(UIButton *)sender {
    [self wy_pushToVC:WYVCTypeFriendList];
}

#pragma mark - WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if(WY_IsKindOfClass(obj, MeariDevice)) {
        self.deviceID = [(MeariDevice *)obj info].ID;
        self.deviceUUID = [(MeariDevice *)obj info].uuid;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraSettingShareCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYCameraSettingShareCell) forIndexPath:indexPath];
    WYCameraSettingShareModel *model = self.dataSource[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - WYShareCellDelegate
- (void)WYCameraSettingShareCell:(WYCameraSettingShareCell *)cell didTapedSelectedBtn:(UIButton *)button {
    button.selected = !button.isSelected;
    [self networkRequestShareWithShared:button.isSelected model:cell.model failure:^{
        button.selected = !button.isSelected;
    }];
}


@end
