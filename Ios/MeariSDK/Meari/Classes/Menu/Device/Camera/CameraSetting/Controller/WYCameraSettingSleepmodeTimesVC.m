//
//  WYCameraSettingSleepmodeVC.m
//  Meari
//
//  Created by 李兵 on 2017/1/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepmodeTimesVC.h"
#import "WYCameraSettingSleepmodeTimesModel.h"
#import "WYCameraSettingSleepmodeTimesCell.h"
@interface WYCameraSettingSleepmodeTimesVC ()<WYEditManagerDelegate, WYCameraSettingSleepmodeTimesCellDelegate>
{
    BOOL _edited;
    BOOL _needSetSleep;
}
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIButton *addBtn;
@property (nonatomic, strong)NSMutableArray *selectedSource;
@property (nonatomic, strong)NSMutableArray *originalSource;
@property (nonatomic, strong)MASConstraint *bottomHeight;
@property (nonatomic, strong)MeariDevice *camera;

@end

@implementation WYCameraSettingSleepmodeTimesVC
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *view = [UIView new];
        [view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(40)).priorityHigh();
            make.height.lessThanOrEqualTo(view);
            make.width.equalTo(view.mas_width).multipliedBy(0.6);
            make.center.equalTo(view);
        }];
        [self.view addSubview:view];
        _bottomView = view;
    }
    return _bottomView;
}
- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(addAction:)];
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 20;
        [_addBtn setTitle:WYLocalString(@"ADD TIME PERIOD") forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (NSMutableArray *)selectedSource {
    if (!_selectedSource) {
        _selectedSource = [NSMutableArray array];
    }
    return _selectedSource;
}
- (NSMutableArray *)originalSource {
    if (!_originalSource) {
        _originalSource = [NSMutableArray array];
    }
    return _originalSource;
}


#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"SLEEPMODE_TIME");
    
    self.setTableView = ^(UITableView *tableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView wy_registerClass:[WYCameraSettingSleepmodeTimesCell class] fromNib:YES];
    };
}
- (void)initLayout {
    WY_WeakSelf
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        weakSelf.bottomHeight = make.height.equalTo(@0);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
        make.centerX.equalTo(weakSelf.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.bottomView.mas_top);
    }];
}
- (void)initDataSource {
    for (MeariDeviceParamSleepTime *time in self.camera.param.sleep_time) {
        WYCameraSettingSleepmodeTimesModel *model = [WYCameraSettingSleepmodeTimesModel new];
        model.time = time;
        [self.dataSource addObject:model];
    }
    self.tableView.tableHeaderView = self.dataSource.count == 0 ? nil : [WYTableHeaderView header_cameraSleepmode];
    [self updateUI:YES];
}

#pragma mark -- Utilities
- (void)deleteSleepModeTimes {
    WY_WeakSelf
    [self setSleepModeTimesSuccess:^{
        WY_HUD_SHOW_SUCCESS_STATUS_VC(WYLocalString(@"success_set"), weakSelf)
        [weakSelf.dataSource removeObjectsInArray:weakSelf.selectedSource];
        [weakSelf.selectedSource removeAllObjects];
        if (weakSelf.dataSource.count == 0) {
            [weakSelf editCancel];
        }else {
            [weakSelf updateUI:YES];
        }
    } failure:^{
        WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_set"), weakSelf)
    }];
    
}
- (void)setSleepModeTimesSuccess:(WYBlock_Void)success failure:(WYBlock_Void)failure {
    NSMutableArray *tmpArr = self.dataSource.mutableCopy;
    if (self.selectedSource.count > 0) {
        [tmpArr removeObjectsInArray:self.selectedSource];
    }
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:tmpArr.count];
    for (WYCameraSettingSleepmodeTimesModel *model in tmpArr) {
        [times addObject:model.time];
    }
    BOOL open = (_needSetSleep ||
                 self.wy_pushFromVCType == WYVCTypeCameraVideoOne);
    [self.camera setSleepmodeTime:open times:times success:^{
        WYDo_Block_Safe(success)
    } failure:^(NSError *error) {
        WYDo_Block_Safe1(failure, error)
    }];
}
- (void)updateUI:(BOOL)success {
    self.tableView.tableHeaderView = self.dataSource.count == 0 ? nil : [WYTableHeaderView header_cameraSleepmode];
    [self.tableView reloadData];
    self.bottomHeight.equalTo(@(_edited ? 74 :
                                (self.dataSource.count >= 7 ? 0 :
                                 (success ? 74 : 0))));
}
- (NSArray <MeariDeviceParamSleepTime *>*)paramsHomeSleepTimes {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    for (WYCameraSettingSleepmodeTimesModel *model in self.dataSource) {
        MeariDeviceParamSleepTime *m = [model paramsHomeSleepTime];
        [arr addObject:m];
    }
    return arr.copy;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self initDataSource];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [WY_EditM setDelegate:self editStystle:WYEditStytleDeleteDelete];
    WY_EditM.edited = _edited;
    [self.tableView reloadData];
}

#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    self.camera.param.sleep_time = [self paramsHomeSleepTimes];
    [self wy_popToVC:WYVCTypeCameraSettingSleepmode sender:@(self.dataSource.count > 0)];
}
- (void)addAction:(UIButton *)sender {
    NSArray *arr = _needSetSleep ? @[self.camera, self.dataSource] : @[self.camera, self.dataSource];
    [self wy_pushToVC:WYVCTypeCameraSettingSleepmodeAdd sender:arr];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeCameraSettingSleepmode: {
            if (WY_IsKindOfClass(obj, MeariDevice)) {
                self.camera = obj;
            }else if (WY_IsKindOfClass(obj, NSArray)) {
                NSArray *arr = (NSArray *)obj;
                if (WY_IsKindOfClass(arr.firstObject, MeariDevice)) {
                    self.camera = arr.firstObject;
                }
                if (WY_IsKindOfClass(arr.lastObject, NSString)) {
                    _needSetSleep = YES;
                }
            }
            break;
        }
        case WYVCTypeCameraSettingSleepmodeAdd: {
            if (WY_IsKindOfClass(obj, WYCameraSettingSleepmodeTimesModel)) {
                if (![self.dataSource containsObject:obj]) {
                    [self.dataSource addObject:obj];
                }
                [self updateUI:YES];
            }
            break;
        }
        case WYVCTypeCameraVideoOne: {
            if (WY_IsKindOfClass(obj, MeariDevice)) {
                self.camera = obj;
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
    [self updateUI:YES];
}
- (void)editCancel {
    _edited = NO;
    WY_EditM.edited = NO;
    [self updateUI:YES];
}
- (void)editDelete {
    WY_WeakSelf
    if (self.selectedSource.count == 0) {
        [SVProgressHUD wy_showToast:WYLocalString(@"error_noChoice")];
    }else {
        [WYAlertView showWithTitle:WYLocalString(@"Delete")
                           message:WYLocalString(@"DeleteAllMessages")
                      cancelButton:WYLocal_Cancel
                       otherButton:WYLocalString(@"Delete")
                       alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                           if (buttonIndex == alertView.cancelButtonIndex) {
                               
                           }else {
                               [weakSelf deleteSleepModeTimes];
                           }
                       }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraSettingSleepmodeTimesCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYCameraSettingSleepmodeTimesCell) forIndexPath:indexPath];
    cell.delegate = self;
    WYCameraSettingSleepmodeTimesModel *model = self.dataSource[indexPath.row];
    [cell passModel:model edited:_edited];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 99;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_edited) {
        WYCameraSettingSleepmodeTimesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self WYCameraSettingSleepmodeTimesCell:cell selectBtn:cell.selectBtn];
        return;
    }
    
    WYCameraSettingSleepmodeTimesModel *model = self.dataSource[indexPath.row];
    NSArray *arr = _needSetSleep ? @[self.camera, model, self.dataSource] : @[self.camera, model, self.dataSource];
    [self wy_pushToVC:WYVCTypeCameraSettingSleepmodeAdd sender:arr];
}

#pragma mark -- WYCameraSettingSleepmodeTimesCellDelegate
- (void)WYCameraSettingSleepmodeTimesCell:(WYCameraSettingSleepmodeTimesCell *)cell switchTime:(BOOL)switched {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYCameraSettingSleepmodeTimesModel *model = self.dataSource[indexPath.row];
    model.enabled = switched;
    WY_WeakSelf
    [self setSleepModeTimesSuccess:^{
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"success_set"))
    }failure:^{
        WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"fail_set"))
        model.enabled = !model.enabled;
        [weakSelf.tableView reloadData];
    }];
}
- (void)WYCameraSettingSleepmodeTimesCell:(WYCameraSettingSleepmodeTimesCell *)cell selectBtn:(UIButton *)selectBtn {
    selectBtn.selected = !selectBtn.isSelected;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYCameraSettingSleepmodeTimesModel *model = self.dataSource[indexPath.row];
    model.selected = selectBtn.isSelected;
    if (model.selected) {
        [self.selectedSource addObject:model];
    }else {
        [self.selectedSource removeObject:model];
    }
}




@end
