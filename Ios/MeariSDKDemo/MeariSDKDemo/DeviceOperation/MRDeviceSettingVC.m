//
//  MRDeviceSettingVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/5.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRDeviceSettingVC.h"

#import "MRDeviceSDFormatVC.h"
#import "MRDeviceUpgradeVC.h"
#import "MRCloudServerVC.h"
@interface MRDeviceSettingVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MRDeviceSettingVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
}

#pragma mark --- Lazyload
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, WY_ScreenHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, 0.1)];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark --- Init
- (void)initSet {
    self.title = @"setting";
    [self.view addSubview:self.tableView];
    [self.camera getDeviceParamsSuccess:^(MeariDeviceParam *param) {
        NSLog(@"get device param success");
    } failure:^(NSError *error) {
        NSLog(@"get device param failure");
    }];
}

#pragma mark --- Network

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:WY_ClassName([self class])];
    }
    if (indexPath.row == 0)  {
        cell.textLabel.text = @"sd card format";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"device upgrade";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"cloud service buy";
    }
    return cell;
}

#pragma mark --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MRDeviceSDFormatVC *sdformatVC = [[MRDeviceSDFormatVC alloc] init];
        sdformatVC.camera = self.camera;
        [self.navigationController pushViewController:sdformatVC animated:YES];
    } else if (indexPath.row == 1) {
        MRDeviceUpgradeVC *upgradeVC = [[MRDeviceUpgradeVC alloc] init];
        upgradeVC.camera = self.camera;
        [self.navigationController pushViewController:upgradeVC animated:YES];
    } else if (indexPath.row == 2) {
        MRCloudServerVC *cloudServerVC = [[MRCloudServerVC alloc] init];
        cloudServerVC.camera = self.camera;
        [self.navigationController pushViewController:cloudServerVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, WY_ScreenWidth, 40);
    label.text = @"For more settings, please check or framework";
    label.numberOfLines = 0;
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
@end
