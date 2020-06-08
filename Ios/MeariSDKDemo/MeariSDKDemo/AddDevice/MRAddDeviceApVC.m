//
//  MRAddDeviceApVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRAddDeviceApVC.h"

@interface MRAddDeviceApVC ()<MeariDeviceActivatorDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wifissidTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@end

@implementation MRAddDeviceApVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jumpButton.titleLabel.numberOfLines = 0;
    
}
// Go to the wifi page and connect the STRN device
- (IBAction)jumpWifiAction:(id)sender {
    [self WY_openGeneralURL];
}

// start connect
- (IBAction)connectAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerMessage:@"Confirm that the current connection wifi is STRN_xxxxxx, otherwise the network configuration will fail !!!" cancelBlock:^{
        
    } sureBlock:^{
        [self startAP];
    }];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


#pragma mark ---- MeariDeviceActivatorDelegate
- (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
    NSLog(@"返回的设备SN--- netConnect  ------ %@ 设备添加状态 -------- %ld 设备的TP ------- %@",deviceModel.info.nickname,(long)deviceModel.info.addStatus,deviceModel.info.tp);
    
    // suggest !!!! ,
    // Exclude the condition that mqtt is disconnected, the callback cannot be added, it is recommended to check the device list locally。
    
    // use
//    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {
//
//    } failure:^(NSError *error) {
//
//    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark --- private
- (void)WY_openGeneralURL {
    if (@available(iOS 10.0, *)) {
        NSURL *url = [NSURL URLWithString:@"app-Prefs:root=WIFI"];
        [UIApplication.sharedApplication openURL:url options:nil completionHandler:nil];
    } else {
        NSURL *url = [NSURL URLWithString:@"prefs::root=WIFI"];
        [UIApplication.sharedApplication openURL:url];
    }
}
- (void)startAP {
    WY_WeakSelf
    CFTimeInterval st = CFAbsoluteTimeGetCurrent();
    NSString *ssid = self.wifissidTF.text;
    NSString *password = self.passwordTF.text;
    [[MeariDeviceActivator sharedInstance] configApModeWithSSID:ssid password:password token:MR_UserM.configToken relay:NO success:^{
        NSLog(@"device connect network success, will begin to add device");
        [weakSelf addDevice];
    } failure:^(NSError *error) {
        [UIAlertController alertControllerMessage:@"Failed to connect to the network, please check the configuration"];
    }];
}

- (void)addDevice {
    [MeariDeviceActivator sharedInstance].delegate = self;
    [[MeariDeviceActivator sharedInstance] startConfigWiFi:MeariSearchModeAll token:MR_UserM.configToken type:MeariDeviceTokenTypeQRCode nvr:NO timeout:100];
}

@end
