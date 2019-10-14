//
//  WYNVRSettingCameraListVC.m
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingCameraListVC.h"
#import "WYNVRSettingCameraListCell.h"

@interface WYNVRSettingCameraListVC ()<WYEditManagerDelegate, WYNVRSettingCameraListCellDelegate>
{
    BOOL _edited;
}
@property (nonatomic, strong)WYSelectAllView *selectAllView;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)NSMutableArray *unbindingSource;
@property (nonatomic, strong)NSMutableArray *selectedSource;
@property (nonatomic, strong)MeariDevice *nvr;
@end

@implementation WYNVRSettingCameraListVC
#pragma mark - Private
#pragma mark -- Getter
- (NSMutableArray *)unbindingSource {
    if (!_unbindingSource) {
        _unbindingSource = [NSMutableArray array];
    }
    return _unbindingSource;
}
- (NSMutableArray *)selectedSource {
    if (!_selectedSource) {
        _selectedSource = [NSMutableArray array];
    }
    return _selectedSource;
}
- (WYSelectAllView *)selectAllView {
    if (!_selectAllView) {
        WY_WeakSelf
        _selectAllView = [WYSelectAllView selectAllViewWithSelectTask:^(BOOL selected) {
            for (WYNVRSettingCameraListModel *model in weakSelf.dataSource) {
                model.selected = selected;
            }
            [weakSelf.tableView reloadData];
            selected ? weakSelf.selectedSource = weakSelf.dataSource.mutableCopy : [weakSelf.selectedSource removeAllObjects];
        }];
    }
    return _selectAllView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [WYInstructionView nvrSetting_CameraManagement];
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *v = [UIView new];
        v.frame = CGRectMake(0, 0, WY_ScreenWidth, 70);
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 0, 45, 45);
        addBtn.center = v.center;
        [addBtn setImage:[UIImage imageNamed:@"btn_nvr_bind"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:addBtn];
        _bottomView = v;
    }
    return _bottomView;
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"CAMERA MANAGEMENT");
    
    WY_WeakSelf
    self.setTableView = ^(UITableView *tableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView wy_registerClass:[WYNVRSettingCameraListCell class] fromNib:YES];
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf networkRequestList];
        }];
    };
}
- (void)initLayout {
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(weakSelf.view);
        make.height.equalTo(@(weakSelf.topView.height));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- Utilities
- (void)updateTableView {
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark -- Life
- (void)updateViewConstraints {
    [super updateViewConstraints];
    WY_WeakSelf
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset(_edited ? -60 : 0);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WY_EditM setDelegate:self editStystle:WYEditStytleDeleteDelete];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Action
- (void)addAction:(UIButton *)sender {
    if (self.nvr && self.unbindingSource && self.dataSource) {
        NSDictionary *dic = @{@"nvr":self.nvr,
                              @"unbindeddevices":self.unbindingSource,
                              @"bindeddevices":self.dataSource
                              };
        [self wy_pushToVC:WYVCTypeNVRSettingSelectWIFI sender:dic];
    }
}

#pragma mark - Network
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getBindDeviceList:self.nvr.info.ID success:^(NSArray<MeariDevice *> *bindedDevices, NSArray<MeariDevice *> *unbindedDevices) {
        WY_HUD_DISMISS
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:bindedDevices unbindedData:unbindedDevices];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestDelete {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.selectedSource.count];
    for (WYNVRSettingCameraListModel *model in self.selectedSource) {
        [arr addObject:@(model.device.info.ID).stringValue];
    }
    [[MeariUser sharedInstance] unbindDevices:arr toNVR:self.nvr.info.ID success:^{
        [WY_NotificationCenter wy_post_Device_BindUnBindNVR:nil];
        [weakSelf.selectedSource removeAllObjects];
        [weakSelf networkRequestList];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealNetworkDataList:(NSArray *)bindedData unbindedData:(NSArray *)unbindedData {
    [self.dataSource removeAllObjects];
    [self.unbindingSource removeAllObjects];
    for (MeariDevice *device in bindedData) {
        WYNVRSettingCameraListModel *model = [WYNVRSettingCameraListModel new];
        model.device = device;
        [self.dataSource addObject:model];
    }
    for (MeariDevice *device in unbindedData) {
        WYNVRSettingCameraListModel *model = [WYNVRSettingCameraListModel new];
        model.device = device;
        [self.unbindingSource addObject:model];
    }
    
    if (self.dataSource.count == 0) {
        if (_edited) {
            [self editCancel];
        }
        self.tableView.tableFooterView = nil;
    }else {
        if (_edited) {
            self.tableView.tableFooterView = nil;
        }else {
            if (self.dataSource.count < 8) {
                self.tableView.tableFooterView = self.bottomView;
            }else {
                self.tableView.tableFooterView = nil;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    switch (VCType) {
        case WYVCTypeNVRSetting: {
            if(WY_IsKindOfClass(obj, MeariDevice)) {
                self.nvr = obj;
            }
            break;
        }
        case WYVCTypeNVRSettingCameraBinding:
        case WYVCTypeNVRSettingSelectWIFI:{
            if(WY_IsKindOfClass(obj, NSArray)) {
                NSArray *bindedArr = obj;
                if (bindedArr.count > 0) {
                    [self.unbindingSource removeObjectsInArray:bindedArr];
                    [self.dataSource addObjectsFromArray:bindedArr];
                    self.tableView.tableFooterView = self.dataSource.count < 8 ? self.bottomView : nil;
                    [self.tableView reloadData];
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -- WYEditManagerDelegate
- (BOOL)canEdit {
    return self.dataSource.count > 0;
}
- (void)editEdit {
    _edited = YES;
    self.selectAllView.selected = NO;
    self.tableView.mj_header.hidden = YES;
    self.tableView.tableFooterView = nil;
    [self.tableView reloadData];
    [self updateTableView];
}
- (void)editCancel {
    _edited = NO;
    WY_EditM.edited = NO;
    self.selectAllView.selected = NO;
    self.tableView.mj_header.hidden = NO;
    self.tableView.tableFooterView = self.dataSource.count < 8 ? self.bottomView : nil;
    for (WYNVRSettingCameraListModel *model in self.dataSource) {
        model.selected = NO;
    }
    [self.selectedSource removeAllObjects];
    [self.tableView reloadData];
    [self updateTableView];
}
- (void)editDelete {
    if (self.selectedSource.count == 0) {
        [SVProgressHUD wy_showToast:WYLocalString(@"error_noChoice")];
    }else {
        [self networkRequestDelete];
    }
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYNVRSettingCameraListCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYNVRSettingCameraListCell) forIndexPath:indexPath];
    cell.delegate = self;
    WYNVRSettingCameraListModel *model = self.dataSource[indexPath.row];
    [cell passModel:model edited:_edited];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_edited) {
        return 50;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.selectAllView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_edited) return;
    
    WYNVRSettingCameraListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self WYNVRSettingCameraListCell:cell selectButton:cell.selectBtn];
}
#pragma mark -- WYNVRSettingCameraListCellDelegate
- (void)WYNVRSettingCameraListCell:(WYNVRSettingCameraListCell *)cell selectButton:(UIButton *)button {
    button.selected = !button.isSelected;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYNVRSettingCameraListModel *model = self.dataSource[indexPath.row];
    model.selected = button.isSelected;
    if (button.isSelected) {
        [self.selectedSource addObject:model];
    }else {
        [self.selectedSource removeObject:model];
    }
    self.selectAllView.selected = self.selectedSource.count == self.dataSource.count;
}

@end
