//
//  DeviceOperationVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "DeviceListVC.h"
#import <MeariKit/MeariKit.h>
#import "DeviceOperationVC.h"
@interface DeviceListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (nonatomic, strong) NSMutableArray <MeariDevice *>*deviceLists;

@end

@implementation DeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"Device List";
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guestMessage:) name:MeariDeviceHasVisitorNotification object:nil];
}
#pragma mark ---  Notification
- (void)guestMessage:(NSNotification *)sender {
    MeariMqttMessageInfo *msg = sender.object;
    
    MeariDevice *camera = [[MeariDevice alloc]init];
    MeariDeviceInfo *info = [[MeariDeviceInfo alloc]init];
    info.p2p = msg.data.deviceP2P;
    info.p2pInit = msg.data.p2pInit;
    info.key = msg.data.hostKey;
    info.bellVoice = msg.data.bellVoice;
    info.nickname = msg.data.deviceName;
//    info.ID = msg.data.deviceID;
    info.uuid = msg.data.deviceUUID;
    info.type = msg.data.devType;
//    info.subType = msg.data.devSubType;
    info.capability = msg.data.capability;
    info.protocolVersion = msg.data.protocolVersion;
    info.tp = msg.data.tp;
    info.version = msg.data.version;
    info.sn = msg.data.sn;
    camera.info = info;
    
    // deal your Business logic
//    [camera startConnectSuccess:^{
//
//    } abnormalDisconnect:^{
//
//    } failure:^(NSError *error) {
//
//    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getDeviceList];
}
- (void)getDeviceList {
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {
        [self.deviceLists removeAllObjects];
        if (deviceList.chimes.count > 0) {
            [self.deviceLists addObjectsFromArray:deviceList.chimes];
        }
        if (deviceList.ipcs.count > 0) {
            [self.deviceLists addObjectsFromArray:deviceList.ipcs];
        }
        if (deviceList.bells.count > 0) {
            [self.deviceLists addObjectsFromArray:deviceList.bells];
        }
        if (deviceList.voicebells.count > 0) {
            [self.deviceLists addObjectsFromArray:deviceList.voicebells];
        }
        if (deviceList.batteryIpcs.count > 0) {
            [self.deviceLists addObjectsFromArray:deviceList.batteryIpcs];
        }
        if (deviceList.nvrs.count > 0) {
            [self.deviceLists addObjectsFromArray:deviceList.nvrs];
        }
        if (deviceList.lights.count > 0) {
            [self.deviceLists addObjectsFromArray:deviceList.lights];
        }
        [self.listView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error --- %@",error);
    }];
}

#pragma mark -- TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.deviceLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.deviceLists[indexPath.row].info.nickname;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceOperationVC *operationVC = [[DeviceOperationVC alloc]init];
    operationVC.camera = self.deviceLists[indexPath.row];
    operationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:operationVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSMutableArray<MeariDevice *> *)deviceLists {
    if (!_deviceLists) {
        _deviceLists = [NSMutableArray array];
    }
    return _deviceLists;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
