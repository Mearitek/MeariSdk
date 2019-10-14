//
//  WYNVRSettingCameraBindingVC.m
//  Meari
//
//  Created by 李兵 on 2017/1/11.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingCameraBindingVC.h"
#import "WYNVRSettingCameraBindingCell.h"
#import "WYNVRSettingCameraListModel.h"

@interface WYNVRSettingCameraBindingVC ()<WYNVRSettingCameraBindingCellDelegate>
{
    BOOL _needRefresh;
    
    NSArray *_bindedSource;
    NSArray *_unbindedSource;
}
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)NSMutableArray *tmpDataSource;
@property (nonatomic, strong)NSMutableArray<WYNVRSettingCameraListModel *> *freshBindedSource;
@property (nonatomic, strong)MeariDevice *nvr;

@end

@implementation WYNVRSettingCameraBindingVC
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [WYInstructionView nvrSetting_CameraBinding];
    }
    if (!_topView.superview) {
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (NSMutableArray *)tmpDataSource {
    if (!_tmpDataSource) {
        _tmpDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _tmpDataSource;
}
- (NSMutableArray<WYNVRSettingCameraListModel *> *)freshBindedSource {
    if (!_freshBindedSource) {
        _freshBindedSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _freshBindedSource;
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"BindCamera");
    
    self.hideTopBtn = YES;
    [self setBottomBtnTitle:WYLocalString(@"Done") filled:YES];
    [self.tableView registerNib:[UINib nibWithNibName:WY_ClassName(WYNVRSettingCameraBindingCell) bundle:nil] forCellReuseIdentifier:WY_ClassName(WYNVRSettingCameraBindingCell)];
    self.tableView.mj_header = nil;
}
- (void)initLayout {
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(weakSelf.view);
        make.height.equalTo(@(weakSelf.topView.height));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.topView.mas_bottom);
    }];
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startSearch];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopSearch];
}

#pragma mark - Network
- (void)networkRequestBindWithModel:(WYNVRSettingCameraListModel *)model {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] bindDevice:model.device.info.ID toNVR:self.nvr.info.ID success:^{
        WY_HUD_DISMISS
        WYNVRSettingCameraListModel *m = model;
        m.binded = YES;
        [weakSelf.freshBindedSource addObject:m];
        [weakSelf.tableView reloadData];
        [WY_NotificationCenter wy_post_Device_BindUnBindNVR:nil];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [self wy_popToVC:WYVCTypeNVRSettingSelectWIFI sender:self.freshBindedSource];
}

#pragma mark -- Utilities
- (void)foundDevice:(MeariDevice *)device {
    NSString *currentSSID = WY_WiFiM.currentSSID;
    if (self.nvr.wy_wifiSSID && ![self.nvr.wy_wifiSSID isEqualToString:currentSSID]) {
        return ;
    }
    for (MeariDevice *camera in self.dataSource) {
        if ([device.info.sn isEqualToString:camera.info.sn]) {
            return ;
        }
    }
    
    if ([device.info.sn isEqualToString:self.nvr.info.sn]) {
        self.nvr.wy_wifiSSID = currentSSID;
        for (WYNVRSettingCameraListModel *model in self.tmpDataSource) {
            if ([model.wifiSSID isEqualToString:self.nvr.wy_wifiSSID]) {
                [self insertObject:model inDataSourceAtIndex:0];
            }
        }
        [self.tmpDataSource removeAllObjects];
    }else {
        for (WYNVRSettingCameraListModel *model in _unbindedSource) {
            if ([device.info.sn isEqualToString:model.device.info.sn]) {
                if (self.nvr.wy_wifiSSID && [self.nvr.wy_wifiSSID isEqualToString:currentSSID]) {
                    [self insertObject:model inDataSourceAtIndex:0];
                }else {
                    model.wifiSSID = currentSSID;
                    [self.tmpDataSource addObject:model];
                }
                break;
            }
        }
    }
}


#pragma mark - Super
- (void)startSearch {
    [super startSearch];
    WY_WeakSelf
    [MeariDevice startSearch:^(MeariDevice *device) {
        [weakSelf foundDevice:device];
    } failure:nil];
}
- (void)stopSearch {
    [super stopSearch];
    [MeariDevice stopSearch];
    [self.tableView reloadData];
}
- (void)clickBottomBtn:(UIButton *)sender {
    [super clickBottomBtn:sender];
    [self wy_popToVC:WYVCTypeNVRSettingCameraList sender:self.freshBindedSource];
}


#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    switch (VCType) {
        case WYVCTypeNVRSettingSelectWIFI: {
            if (WY_IsKindOfClass(obj, NSDictionary)) {
                NSDictionary *dic = (NSDictionary *)obj;
                _unbindedSource = dic[@"unbindeddevices"];
                _bindedSource = dic[@"bindeddevices"];
                self.nvr = dic[@"nvr"];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYNVRSettingCameraBindingCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYNVRSettingCameraBindingCell) forIndexPath:indexPath];
    WYNVRSettingCameraListModel *model = self.dataSource[indexPath.row];
    cell.delegate = self;
    cell.model = model;
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark -- WYNVRSettingCameraBindingCellDelegate
- (void)WYNVRSettingCameraBindingCell:(WYNVRSettingCameraBindingCell *)cell didClickAddBtn:(UIButton *)addBtn {
    if (self.freshBindedSource.count + _bindedSource.count >= 8) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"status_nvrBindingTooMore"));
        return;
    }
    [self networkRequestBindWithModel:cell.model];
}

@end
