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


@property (nonatomic, strong) UIButton  *button;
@end

@implementation MRDeviceSettingVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(50, 400, 60, 60)];
    self.button.backgroundColor = [UIColor redColor];
    [self.button addTarget:self action:@selector(changePlayback:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.button];
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
        self.button.selected = self.camera.param.recordEnable;
        BOOL recordEnable = self.camera.param.recordEnable;
        BOOL playbackEnable = self.camera.param.playbackVideoRecord.enable;
        NSLog(@"xxxxx recordEnable ---- %d playbackEnable --- %d",recordEnable,playbackEnable);
    } failure:^(NSError *error) {
        
    }];
}

- (void)changePlayback:(UIButton *)sender {
    sender.selected = !sender.selected;
    MeariDeviceRecordDuration level = sender.selected ? MeariDeviceRecordDurationOn : MeariDeviceRecordDurationOff;
    WY_WeakSelf
    [self.camera setPlaybackRecordVideoLevel:level success:^{
        BOOL recordEnable = weakSelf.camera.param.recordEnable;
        BOOL playbackEnable = weakSelf.camera.param.playbackVideoRecord.enable;
        
        NSLog(@"xxxxx after setPlaybackRecordVideoLevel recordEnable ---- %d playbackEnable --- %d",recordEnable,playbackEnable);
        
        [weakSelf.camera getDeviceParamsSuccess:^(MeariDeviceParam *param) {
            BOOL recordEnable = weakSelf.camera.param.recordEnable;
            BOOL playbackEnable = weakSelf.camera.param.playbackVideoRecord.enable;
            NSLog(@"xxxxx after getDeviceParamsSuccess recordEnable ---- %d playbackEnable --- %d",recordEnable,playbackEnable);
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
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
