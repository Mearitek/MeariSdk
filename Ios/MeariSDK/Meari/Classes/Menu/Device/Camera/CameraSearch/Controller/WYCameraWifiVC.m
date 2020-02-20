//
//  WYCameraWifiVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/16.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraWifiVC.h"
#import <CoreLocation/CoreLocation.h>
@interface WYCameraWifiVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *wifiDesView;
@property (weak, nonatomic) IBOutlet UILabel *wifiDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *ssidDesLabel;
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdDesLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *seePwdBtn;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ssidW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desViewHeight;
@property (nonatomic, assign) WYCameraSelectConfigMode mode;
    

@end

@implementation WYCameraWifiVC
#pragma mark - Private
#pragma mark -- Getter
#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"WLAN CONNECTION");
    
    self.wifiDesView.backgroundColor = WY_BGColor_LightOrange;
    self.wifiDesLabel.text = WYLocalString(@"wifi_des");
    self.wifiDesLabel.textColor = WY_FontColor_Orange;
    self.wifiDesLabel.font = WYFont_Text_S_Normal;
    
    self.ssidLabel.text = WYLocalString(@"wifi_ssid");
    self.ssidLabel.textColor = WY_FontColor_Black;
    self.ssidLabel.font = WYFont_Text_M_Normal;
    self.ssidDesLabel.text = WYLocalString(@"wifi_ssid_des");
    self.ssidDesLabel.textColor = WY_FontColor_Gray;
    self.ssidDesLabel.font = WYFont_Text_S_Normal;
    self.pwdLabel.text = WYLocalString(@"wifi_pwd");
    self.pwdLabel.textColor = WY_FontColor_Black;
    self.pwdLabel.font = WYFont_Text_M_Normal;
    self.pwdDesLabel.text = WYLocalString(@"wifi_pwd_des");
    self.pwdDesLabel.textColor = WY_FontColor_Gray;
    self.pwdDesLabel.font = WYFont_Text_S_Normal;
    
    self.ssidTextField.placeholder = WYLocalString(@"wifi_ssid_placeholder");
    self.ssidTextField.textColor = WY_FontColor_Gray;
    self.ssidTextField.font = WYFont_Text_M_Normal;
    self.ssidTextField.delegate = self;
//    [self.ssidTextField setValue:WYFont_Text_S_Normal forKeyPath:@"_placeholderLabel.font"];
    self.pwdTextField.placeholder = WYLocalString(@"wifi_pwd_placeholder");
    self.pwdTextField.textColor = WY_FontColor_Gray;
    self.pwdTextField.font = WYFont_Text_M_Normal;
    self.pwdTextField.secureTextEntry = NO;
    self.seePwdBtn.selected = YES;
    self.pwdTextField.delegate = self;
    CGFloat pwdW = roundf([self.pwdLabel.text sizeWithAttributes:@{NSFontAttributeName:self.pwdLabel.font}].width+1);
    CGFloat ssidW = roundf([self.ssidLabel.text sizeWithAttributes:@{NSFontAttributeName:self.ssidLabel.font}].width+1);
    self.ssidW.constant = MAX(pwdW, ssidW);
//    [self.pwdTextField setValue:WYFont_Text_S_Normal forKeyPath:@"_placeholderLabel.font"];
    
    self.line1.backgroundColor =
    self.line2.backgroundColor =
    self.line3.backgroundColor =
    self.line4.backgroundColor = WY_LineColor_LightGray;
    
    UIButton *nextBtn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(nextAction:)];
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = 20;
    [nextBtn setTitle:WYLocal_Next forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    WY_WeakSelf
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view.mas_width).multipliedBy(0.7);
        make.height.equalTo(@40);
        make.top.equalTo(weakSelf.pwdTextField.mas_bottom).with.offset(100);
        make.centerX.equalTo(weakSelf.view);
    }];
    self.desViewHeight.constant = [self.wifiDesLabel ajustedHeightWithWidth:WY_ScreenWidth-30]+20;
}

#pragma mark -- Utilities
- (void)jumpToNextVC {
    WY_WeakSelf
    WYWifiInfo *wifi = [[WYWifiInfo alloc] init];
    wifi.ssid = self.ssidTextField.text;
    wifi.password = self.pwdTextField.text;
    WY_ParamTransfer.wifiInfo = wifi;
    switch (self.wy_pushFromVCType) {
        case WYVCTypeDoorBellInstall:
        case WYVCType4GCameraInstall:
        case WYVCTypeCameraInstall: {
            [UIResponder cancelPreviousPerformRequestsWithTarget:self.pwdTextField];
            switch (WY_ParamTransfer.selectedKindModel.configMode) {
                case WYCameraSelectConfigModeWifi: {
                    [weakSelf wy_pushToVC:WYVCTypeCameraSearch];
                    break;
                }
                case WYCameraSelectConfigModeQrCode: {
                    [self wy_pushToVC:WYVCTypeCameraQRCodeMaker];
                    break;
                }
                case WYCameraSelectConfigModeAP: {
                    [self wy_pushToVC:WYVCTypeCameraTryManuallyAdd];
                    break;
                }
                default: {
                    [weakSelf wy_pushToVC:WYVCTypeCameraSearch];
                    break;
                }
            }
            break;
        }
        case WYVCTypeCameraManuallyAdd: {
            [self wy_pushToVC:WYVCTypeCameraTryManuallyAdd sender:wifi];
            break;
        }
        default:
            break;
    }
}
- (void)updateWifiInfo {
    NSString *ssid = WY_WiFiM.currentSSID;
    self.ssidTextField.text = ssid;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    
    if (@available(iOS 13.0, *)) {
        //wifi need location Permission
        [WYAuthorityManager checkAuthorityOfLocation:^(BOOL granted) {
            if (!granted) {
                [WYAlertView showNeedAuthorityOfLocationServices];
            }
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.ssidTextField.enabled = NO;
    NSString *ssid = WY_WiFiM.currentSSID;
    self.ssidTextField.text = ssid;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark -- Action
- (void)nextAction:(UIButton *)sender {

    if (self.ssidTextField.text.length <= 0) {
        [WYAlertView showNoWifi];
        return;
    }
    
    if (self.pwdTextField.text.length <= 0) {
        WY_WeakSelf
        [WYAlertView showNoWifiPasswordWithCancelAction:nil otherAction:^{
            [weakSelf jumpToNextVC];
        }];
        return;
    }
    [self jumpToNextVC];

}
- (IBAction)eyeAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.pwdTextField.secureTextEntry = !sender.isSelected;
}
- (IBAction)rememberAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.ssidTextField.enabled = NO;
        NSString *ssid = WY_WiFiM.currentSSID;
        self.ssidTextField.text = ssid;
    }else {
        self.ssidTextField.enabled = YES;
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)appDidEnterForehead:(NSNotification *)sender {
    [self updateWifiInfo];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, NSNumber)) {
        self.mode = [obj integerValue];
    }
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.ssidTextField) {
        [self.pwdTextField becomeFirstResponder];
    }else if (textField == self.pwdTextField) {
        [self nextAction:nil];
    }
    return YES;
}


@end
