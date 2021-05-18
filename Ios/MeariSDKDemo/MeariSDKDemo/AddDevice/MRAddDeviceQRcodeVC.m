//
//  MRAddDeviceQRcodeVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRAddDeviceQRcodeVC.h"

@interface MRAddDeviceQRcodeVC ()<MeariDeviceActivatorDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wifissidTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@end

@implementation MRAddDeviceQRcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"configure network";
}

// create qrcode
- (IBAction)createCodeAction:(id)sender {
    // !!!!!!! make sure wifissid and password are right!!!!!!!!
    
    // use this qrcode to configure network
//    UIImage *image = [[MeariDeviceActivator sharedInstance] createQRCodeWithSSID:_wifissidTF.text pasword:_passwordTF.text token:MR_UserM.configToken size:CGSizeMake(300, 300)];
    UIImage *image = [[MeariDeviceActivator sharedInstance] createQRCodeWithSSID:_wifissidTF.text pasword:_passwordTF.text token:MR_UserM.configToken addSubDevice:NO size:CGSizeMake(300, 300)];
    _qrcodeImageView.image = image;
}

// configure network
- (IBAction)configureAction:(id)sender {
    [MeariDeviceActivator sharedInstance].delegate = self;
    [[MeariDeviceActivator sharedInstance] startConfigWiFi:MeariSearchModeAll token:MR_UserM.configToken type:MeariDeviceTokenTypeQRCode nvr:NO timeout:100];
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

@end
