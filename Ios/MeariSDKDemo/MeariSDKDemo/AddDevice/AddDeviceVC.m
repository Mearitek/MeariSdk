//
//  AddDeviceVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "AddDeviceVC.h"

#import "MRAddDeviceQRcodeVC.h"
#import "MRAddDeviceApVC.h"

@interface AddDeviceVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    // Do any additional setup after loading the view.
}

#pragma mark --- Lazyload
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, WY_ScreenHeight - WY_TopBar_H)];
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
    [self.view addSubview:self.tableView];
}

#pragma mark --- Network

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:WY_ClassName([self class])];
    }
    if (indexPath.row == 0)  {
        cell.textLabel.text = @"QR Code configure";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"AP configure";
    }
    return cell;
}

#pragma mark -e-- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // get token first before configure network
    [[MeariDeviceActivator sharedInstance] getTokenSuccess:^(NSString *token, NSInteger validTime, NSInteger delaySmart) {
         MR_UserM.configToken = token;
         MR_UserM.validTime = validTime;
         if (indexPath.row == 0) {
             MRAddDeviceQRcodeVC *qrcodeVC = [[MRAddDeviceQRcodeVC alloc] init];
             [self.navigationController pushViewController:qrcodeVC animated:YES];
         } else {
             MRAddDeviceApVC *qrcodeVC = [[MRAddDeviceApVC alloc] init];
             [self.navigationController pushViewController:qrcodeVC animated:YES];
         }
    } failure:^(NSError *error) {
        [UIAlertController alertControllerMessage:error.domain];
    }];
}

@end
