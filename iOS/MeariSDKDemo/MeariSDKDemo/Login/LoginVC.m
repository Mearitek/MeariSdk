//
//  ViewController.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "LoginVC.h"
//#import <MJExtension/MJExtension.h>
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UIButton *loginInButton;
@property (weak, nonatomic) IBOutlet UITextView *errorCodeTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _errorCodeTextView.layer.borderWidth = 1;
    _errorCodeTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _errorCodeTextView.layer.cornerRadius = 5;
    _errorCodeTextView.layer.masksToBounds = YES;
    
    if ([MeariUser sharedInstance].logined) {
        [self.loginInButton setTitle:@"you already login" forState:(UIControlStateNormal)];
    }
    // Do any additional setup after loading the view.
}

#pragma mark --- navigation
// logout
- (IBAction)logoutItemAction:(id)sender {
    // login first
    if (![MeariUser sharedInstance].logined) {
        UIAlertController *alert = [UIAlertController alertControllerMessage:@"please login account first" sureBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [[MeariUser sharedInstance] logoutSuccess:^{
        self.errorCodeTextView.text = @"logout success";
        [self.loginInButton setTitle:@"login" forState:(UIControlStateNormal)];
    } failure:^(NSError *error) {
        self.errorCodeTextView.text = error.domain;
    }];
    
}

// login account
- (IBAction)loginAction:(id)sender {
    if ([MeariUser sharedInstance].logined) {
        UIAlertController *alert = [UIAlertController alertControllerMessage:@"you already login" sureBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //You must first connect to the cloud through your own server and interact with the Meari server to log in before you can use the login interface
    //Pass the data obtained from Meari server to App
    
    //必须先通过云云对接 通过自己的服务器和Meari服务器交互 登录之后 才能使用登录接口
    //将从Meari服务器获取的数据传递给App
    NSDictionary *loginDic = @{
        @"result": @{
            @"updateDate": @"",
            @"jpushAlias": @"",
            @"tyPassword": @"",
            @"iosUserId": @"",
            @"sourceApp": @"",
            @"loginType": @0,
            @"userRecycle": @"",
            @"iotType": @0,
            @"userID": @"",
            @"iot": @{
                @"pfKey": @{
                    @"accessid": @"",
                    @"platformSignature": @"",
                    @"platformDomain": @"",
                    @"accesskey": @"",
                    @"openapiDomain": @""
                },
                @"mqtt_aws": @{
                    @"subTopic": @"",
                    @"clientId": @"",
                    @"iotPolicyName": @"",
                    @"port": @"",
                    @"host": @"",
                    @"cognitoRegion": @"",
                    @"certId": @"",
                    @"cognitoPoolId": @""
                },
                @"mqtt": @{
                    @"subTopic": @"",
                    @"clientId": @"",
                    @"keepalive": @"",
                    @"dn": @"",
                    @"iotId": @"",
                    @"deviceSecret": @"",
                    @"protocol": @"",
                    @"port": @"",
                    @"crtUrls": @"",
                    @"host": @"",
                    @"pk": @"b",
                    @"region": @"",
                    @"iotToken": @""
                },
                @"iotVersion": @1
            },
            @"password": @"",
            @"lngType": @"",
            @"countryCode": @"CN",
            @"imageUrl": @"",
            @"phoneCode": @"86",
            @"emailAuthFlag": @"0",
            @"createDate": @"",
            @"nickName": @"",
            @"openID": @"",
            @"deviceSecretDesk": @"",
            @"soundFlag": @0,
            @"iotDeviceName": @"",
            @"thirdLoginId": @"",
            @"iotProductKey": @"",
            @"userToken": @"",
            @"deviceSecret": @"",
            @"iotId": @"",
            @"userAccount": @"",
            @"ringDuration": @"",
            @"iotDeviceSecret": @"",
            @"timeFlag": @"",
            @"promotion": @0
        },
        @"t": @"1739949912464",
        @"resultCode": @"1001"
    };

    
    [[MeariUser sharedInstance] loginUidWithExtraParamInfo:loginDic complete:^(NSError *error) {
        if (!error) {
            NSLog(@"login Success");
        }else {
            NSLog(@"login error --- %@",error.description);
        }
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)nicknameTF:(id)sender {
}
@end
