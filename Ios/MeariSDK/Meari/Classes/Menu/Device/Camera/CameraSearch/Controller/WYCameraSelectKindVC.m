//
//  WYCameraSelectKindVC.m
//  Meari
//
//  Created by 李兵 on 2017/7/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSelectKindVC.h"

@interface WYCameraSelectKindVC ()

@end

@implementation WYCameraSelectKindVC
#pragma mark - Private

#pragma mark -- Life
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

#pragma mark -- Init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = WYLocalString(@"Choose Device Type");
    
    self.setTableView = ^(UITableView *tableView) {
        tableView.rowHeight = 70;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tableView wy_registerClass:[UITableViewCell class] fromNib:NO];
    };

    WYBaseModel *cameraModel = [WYCameraSelectKindModel cameraModel];
    WYBaseModel *batteryModel = [WYCameraSelectKindModel batteryCameraModel];
    WYBaseModel *nvrModel = [WYCameraSelectKindModel nvrModel];
    WYBaseModel *doorbellModel = [WYCameraSelectKindModel doorbellModel];
    WYBaseModel *voiceBellModel = [WYCameraSelectKindModel voiceDoorbellModel];
    self.dataSource = @[cameraModel,
                        batteryModel,
                        doorbellModel,
                        voiceBellModel,
                        nvrModel,
                        ].mutableCopy;
}
- (void)initLayout {
    WY_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}


#pragma mark - Delegate
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    WYBaseModel *model = self.dataSource[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    cell.textLabel.text = model.text;
    return cell;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraSelectKindModel *model = self.dataSource[indexPath.row];
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3: {
            WY_ParamTransfer.selectedKindModel = model;
            [self wy_pushToVC:WYVCTypeCameraInstall];
            break;
        }
        case 4: {
            WY_ParamTransfer.selectedKindModel = model;
            [self wy_pushToVC:WYVCTypeNVRInstall];
            break;
        }
        default:
            WY_ParamTransfer.selectedKindModel = model;
             [self wy_pushToVC:WYVCTypeCameraInstall];
            break;
    }
}

@end
