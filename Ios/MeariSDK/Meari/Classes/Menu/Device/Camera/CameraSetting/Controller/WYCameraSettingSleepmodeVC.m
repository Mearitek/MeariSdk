//
//  WYCameraSettingSleepmodeVC1.m
//  Meari
//
//  Created by FMG on 17/3/13.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepmodeVC.h"
#import "WYCameraSettingSleepModel.h"
#import "WYCameraSettingSleepModeCell.h"


@interface WYCameraSettingSleepmodeVC ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) MeariDevice *camera;
@property (assign, nonatomic) BOOL edited;

@end

@implementation WYCameraSettingSleepmodeVC

#pragma mark - Private
#pragma mark -- Getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [WYInstructionView cameraSetting_Sleepmode];
        [self.view addSubview:_topView];
    }
    return _topView;
}

#pragma mark -- Setter
- (void)setEdited:(BOOL)edited {
    
    _edited = edited;
    self.navigationItem.rightBarButtonItem.title = _edited ? WYLocalString(@"Done") : WYLocalString(@"Edit");
    [self.tableView reloadData];
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"SLEEMODE");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem editTextItemWithTarget:self action:@selector(editAction:)];
    
    self.dataSource = [WYCameraSettingSleepModel sleepModes].mutableCopy;
    self.setTableView = ^(UITableView *tableView) {
        tableView.rowHeight = 69;
        [tableView wy_registerClass:WYCameraSettingSleepModeCell.class fromNib:YES];
    };
}
- (void)initLayout {
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.topView.size);
        make.top.centerX.equalTo(weakSelf.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
    [self getSleepmodeInfo];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- Network
#pragma mark -- Notification
#pragma mark -- NSTimer
#pragma mark -- Utilities
- (void)getSleepmodeInfo {
    __block int i = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (i == 0) {
            WY_HUD_SHOW_WAITING
        }
    });
    WY_WeakSelf
    [self.camera getParamsSuccess:^(id obj) {
        i = 1;
        WY_HUD_DISMISS
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        i = 1;
        WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"fail_getSleepmodeInfo"))
    }];
}
- (void)setSleepmodeWithModel:(WYCameraSettingSleepModel *)model {
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [self.camera setSleepmodeType:model.type success:^{
        if (!weakSelf) return ;
        WY_HUD_DISMISS
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        WY_HUD_SHOW_Toast_VC(WYLocalString(@"fail_set"), weakSelf)
    }];
}
- (void)jumpToSleepModeTimesVC:(BOOL)needSetSleep {
    [self wy_pushToVC:WYVCTypeCameraSettingSleepmodeTimes sender:self.camera];
}

#pragma mark -- Action
- (void)editAction:(UIButton *)sender {
    self.edited = !_edited;
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeCameraSetting: {
            if (WY_IsKindOfClass(obj, MeariDevice)) {
                self.camera = obj;
            }
            break;
        }
        case WYVCTypeCameraSettingSleepmodeTimes: {
            self.edited = NO;
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
    WYCameraSettingSleepModeCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYCameraSettingSleepModeCell)];
    WYCameraSettingSleepModel *model = self.dataSource[indexPath.row];
    model.selected = self.edited ? NO : self.camera.param.sleepmode == model.type;
    cell.model = model;
    switch (indexPath.row) {
        case 0:
        case 1: {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = self.edited ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
            break;
        }
        case 2:
        case 3: {
            cell.accessoryType = self.edited ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        }
            
        default:
            break;
    }
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.edited) {
        switch (indexPath.row) {
            case 2: {
                [self jumpToSleepModeTimesVC:NO];
                break;
            }
            default:
                break;
        }
    }else {
        WYCameraSettingSleepModel *model = self.dataSource[indexPath.row];
        if (model.selected) return;
        
        [self setSleepmodeWithModel:model];
    }
}


@end
