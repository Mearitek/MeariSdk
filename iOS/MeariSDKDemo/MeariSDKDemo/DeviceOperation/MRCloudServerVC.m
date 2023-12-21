//
//  MRCloudServerVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/8/26.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRCloudServerVC.h"
#import "MRAliWebPayVC.h"
//#import <Braintree/BraintreePayPal.h>
@interface MRCloudServerVC ()//<BTAppSwitchDelegate,BTViewControllerPresentingDelegate>
//paypal
@property (nonatomic, strong) NSString *payToken;
@property (nonatomic,   copy) NSString *payNonce;
@property (nonatomic,   copy) NSString *payAccount;
//@property (nonatomic, strong) BTAPIClient *apiClient;
//@property (nonatomic, strong) BTPayPalDriver *payPalDriver;

//aliwebPay
@property (nonatomic,   copy) NSString *aliwebUrl;
@property (nonatomic,   copy) NSString *aliwebSuccessUrl;

@end

@implementation MRCloudServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //中国注册地区 countryCode 为CN的应该使用支付支付 其他使用paypal支付
}
- (IBAction)getCloudStatus:(id)sender {
    [[MeariUser sharedInstance] cloudGetStatusWithDeviceID:self.camera.info.ID success:^(NSDictionary *dict) {
        NSLog(@"server status --- %@",dict);
        //可以根据 self.camera.lowPowerDevice 区分是否支持 全天录像
        if (self.camera.lowPowerDevice) {
            //Support all-day recording and alarm recording 支持全天录制和报警录制
        }else  {
            //Only support alarm recording 只支持报警录制
        }
//        {
//            cloudStatus = 1;// Cloud service status 云存储状态
//            dueDate = 0; //Expire date 云存储到期时间
//            resultCode = 1001;
//            // Package type price 套装类型价格
//            storageContinue =     { //All day storage  全天录制
//                sevenM = 25;        // 7 days loop recording, 25 a month 7天循环录制 一个月25
//                sevenS = "74.40000000000001";  // 7 days loop recording, 74 a quarter 7天循环录制 一个季度74
//                sevenY = 249;     // 7 days loop recording, 25 a year 7天循环录制 一个年249
//                storageType = 1;  //Cloud storage type 1 means all day recording 0 means alarm path  云存储类型  1 代表全天录制 0 代表报警录制
//                thirtyM = 52;     // 30 days loop recording, 52 a month 7天循环录制 一个月52
//                thirtyS = "155.39"; // 30 days loop recording, 155.39 a quarter 7天循环录制 一个季度155.39
//                thirtyY = 519;    // 30 days loop recording, 519 a year 7天循环录制 一个年519
//                threeM = 22;     // 3 days loop recording, 22 a month 7天循环录制 一个月22
//                threeS = "65.40000000000001";// 3 days loop recording, 65.4 a quarter 7天循环录制 一个季度65.4
//                threeY = 219;// 3 days loop recording, 219 a year 7天循环录制 一个年219
//            };
//            storageEvent =     {
//                sevenM = 15;
//                sevenS = "44.4";
//                sevenY = 149;
//                storageType = 0;
//                thirtyM = 32;
//                thirtyS = "95.40000000000001";
//                thirtyY = 319;
//                threeM = 12;
//                threeS = "35.4";
//                threeY = 119;
//            };
//            trialCloud = 1; //0 is available for trial 1 is tried 0是可以试用  1是试用过了
//            tryTime = 7;//Length of trial 试用的时间长度
//            tryUnit = D;//Trial time unit 试用的时间单位
//        }
     } failure:^(NSError *error) {
        NSLog(@"get cloudStatus failure ---- %@",error);
     }];
}
- (IBAction)serverTrial:(id)sender {
//    MeariDeviceCloudStateCloseCanTry = 0,      //Not open but can trial (未开通可试用)
//       MeariDeviceCloudStateCloseNotTry,          //Not open and cant trial (未开通不可试用)
//       MeariDeviceCloudStateOpenNotOverDue,       //open (已开通)
//       MeariDeviceCloudStateOpenOverDue           //expired (已过期)
    switch (self.camera.info.cloudState) {
        case MeariDeviceCloudStateCloseCanTry:
            [[MeariUser sharedInstance] cloudTryWithDeviceID:self.camera.info.ID success:^{
                NSLog(@"Cloud storage experience success");
            } failure:^(NSError *error) {
                NSLog(@"Cloud storage experience failure ---- %@",error);
            }];
            break;
        case MeariDeviceCloudStateCloseNotTry:
        
            break;
        case MeariDeviceCloudStateOpenNotOverDue:
            
            break;
        case MeariDeviceCloudStateOpenOverDue:
        
            break;
        default:
            break;
    }
    
    
}
- (IBAction)activationCode:(id)sender {
    [[MeariUser sharedInstance] cloudActivationWithDeviceID:self.camera.info.ID code:@"Activation code" success:^{
       NSLog(@"Successfully purchased cloud storage through activation code");
    } failure:^(NSError *error) {
       NSLog(@"purchased cloud storage through activation code failure ---- %@",error);
    }];
}
- (IBAction)getAlipayWebUrl:(id)sender {
    //serverTime 购买服务的次数
    //例如购买30天循环报警录制类型1次
    [[MeariUser sharedInstance] cloudGetAlipayHtmlWithDeviceID:self.camera.info.ID serverTime:1 payMoney:@"32" mealType:@"M" storageTime:30 storageType: 0 success:^(NSString *payWebUrl, NSString *paySuccessUrl) {
        self.aliwebUrl = payWebUrl;
        self.aliwebSuccessUrl = paySuccessUrl;
        NSLog(@"get alipat web url success");
    } failure:^(NSError *error) {
        NSLog(@"get alipay Web url failure --- %@",error);
    }];
    
}
- (IBAction)getPaypalToken:(id)sender {
    [[MeariUser sharedInstance] cloudGetPayPalTokenSuccess:^(NSDictionary *dict) {
        self.payToken = dict[@"accessToken"];
        [self initPayPalEnvironment];
    } failure:^(NSError *error) {
          
    }];
}
- (IBAction)createOrderToServer:(id)sender {
    [[MeariUser sharedInstance] cloudCreateOrderWithDeviceID:self.camera.info.ID serverTime:1 payMoney:@"32" mealType:@"M" storageTime:30 storageType:0  payType:2 paymentMethodNonce:self.payNonce success:^(NSDictionary *dict) {
        NSLog(@"paypal success");
    } failure:^(NSError *error) {
        NSLog(@"paypal failure --- %@",error);
    }];
}
- (IBAction)alipayProgress:(id)sender {
    //
    if (!self.aliwebUrl || !self.aliwebSuccessUrl) {
         NSLog(@"url cannot be empty, please call \"-cloudGetAlipayHtmlWithDeviceID\"first");
        return;
    }
    MRAliWebPayVC *aliWebVC = [[MRAliWebPayVC alloc]init];
    aliWebVC.urlString = self.aliwebUrl;
    aliWebVC.paySuccessUrl = self.aliwebSuccessUrl;
    [self.navigationController pushViewController:aliWebVC animated:YES];
}
- (IBAction)paypalProgress:(id)sender {
    if (!self.payToken) {
        NSLog(@"token cannot be empty, please call \"-cloudGetPayPalTokenSuccess\"first");
        return;
    }
    [self createPayPalNonce];
}

#pragma makr --- Paypal
// Initialize the paypal client
- (void)initPayPalEnvironment {
//    self.apiClient = [[BTAPIClient alloc] initWithAuthorization:self.payToken];
//    self.payPalDriver = [[BTPayPalDriver alloc] initWithAPIClient:self.apiClient];
//    self.payPalDriver.viewControllerPresentingDelegate = self;
//    self.payPalDriver.appSwitchDelegate = self;
}
#pragma mark - GetPayPalNonce
- (void)createPayPalNonce {
    //totalPrice
//    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"32"];
//    request.currencyCode = @"USD";
//    request.displayName = @"Cloud Storage Service";
//    WY_WeakSelf
//    [self.payPalDriver requestOneTimePayment: request completion:^(BTPayPalAccountNonce *_Nullable tokenizedPayPalAccount, NSError *_Nullable error) {
//        
//        NSLog(@"---BTPayPalDriver--%@", tokenizedPayPalAccount.nonce ? tokenizedPayPalAccount.nonce : error);
//        
//        if (tokenizedPayPalAccount) {
//            weakSelf.payNonce = tokenizedPayPalAccount.nonce ? tokenizedPayPalAccount.nonce : @"";
//            weakSelf.payAccount = tokenizedPayPalAccount.email ? tokenizedPayPalAccount.email : tokenizedPayPalAccount.phone;
//            if (weakSelf.payNonce.length) {
//                [self createOrderToServer:nil];
//            }
//        } else if (error) {
//            NSLog(@"error --- %@",error);
//        }
//    }];
}

#pragma mark --- BTAppSwitchDelegate
- (void)appSwitcherWillPerformAppSwitch:(__unused id)appSwitcher {
    
}

- (void)appSwitcherWillProcessPaymentInfo:(__unused id)appSwitcher {
    
}

//- (void)appSwitcher:(__unused id)appSwitcher didPerformSwitchToTarget:(BTAppSwitchTarget)target {
//    switch (target) {
//        case BTAppSwitchTargetWebBrowser:
//            
//            break;
//        case BTAppSwitchTargetNativeApp:
//            
//            break;
//        case BTAppSwitchTargetUnknown:
//            
//            break;
//    }
//}

#pragma mark --- BTViewControllerPresentingDelegate
- (void)paymentDriver:(__unused id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)paymentDriver:(__unused id)driver requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)upload:(id)sender {
    //通过 getDeviceParamsSuccess 获取设备参数
    //通过 param.cloud_storage.enable 判断是否开启云存储录像上传（默认开启）
    //通过 setCloudUploadEnable 方法打开或关闭云存储录像上传
    
//    [self.camera getDeviceParamsSuccess:^(MeariDeviceParam *param) {
//          [self.camera setCloudUploadEnable:NO success:^{
//
//          } failure:^(NSError *error) {
//
//          }];
//    } failure:^(NSError *error) {
//
//    }];
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
