//
//  WYCameraSelectConfigVC.m
//  Meari
//
//  Created by 李兵 on 2017/11/27.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSelectConfigVC.h"
#import "WYCameraSelectConfigView.h"

@interface WYCameraSelectConfigVC ()
@property (nonatomic, strong)WYCameraSelectConfigView *qrConfigView;
@property (nonatomic, strong)WYCameraSelectConfigView *wifiConfigView;
@property (nonatomic, strong)WYCameraSelectConfigView *apConfigView;
@property (nonatomic, strong)UIView *lineView;
@end

@implementation WYCameraSelectConfigVC

#pragma mark -- Getter
- (WYCameraSelectConfigView *)qrConfigView {
    if (!_qrConfigView) {
        _qrConfigView = [WYCameraSelectConfigView viewWithImage:[YLGIFImage imageNamed:@"gif_camera_qrcode.gif"]
                                                            des:WYLocalString(@"device_config_qr_des")
                                                       btnTitle:WYLocalString(@"device_config_qr")
                                                         target:self
                                                         action:@selector(qrConfigureAction:)];
        [self.view addSubview:_qrConfigView];
    }
    return _qrConfigView;
}
- (WYCameraSelectConfigView *)wifiConfigView {
    if (!_wifiConfigView) {
        _wifiConfigView = [WYCameraSelectConfigView viewWithImage:[YLGIFImage imageNamed:@"gif_camera_wifi.gif"]
                                                            des:WYLocalString(@"device_config_wifi_des")
                                                       btnTitle:WYLocalString(@"device_config_wifi")
                                                         target:self
                                                         action:@selector(wifiConfigureAction:)];
        [self.view addSubview:_wifiConfigView];
    }
    return _wifiConfigView;
}

- (WYCameraSelectConfigView *)apConfigView {
    if (!_apConfigView) {
        NSString *des = WYLocalString(@"device_config_ap_des");
        NSString *btnTitle = WYLocalString(@"device_config_ap");
        YLGIFImage *gifImg ;
        switch (WY_ParamTransfer.selectedKindModel.deviceType) {
            case MeariDeviceSubTypeIpcBell:
                gifImg = [YLGIFImage imageNamed:@"gif_redLightFlashShow.gif"];
                break;
            case MeariDeviceSubTypeIpcBattery:
                gifImg = [YLGIFImage imageNamed:@"gif_add_battery_camera.gif"];
                break;
            case MeariDeviceSubTypeIpcCommon:
            case MeariDeviceSubTypeIpcBaby:
                gifImg = [YLGIFImage imageNamed:@"gif_redLightFlashShow.gif"];
                break;
            default:
                gifImg = [YLGIFImage imageNamed:@"gif_redLightFlashShow.gif"];
                break;
        }
        _apConfigView = [WYCameraSelectConfigView viewWithImage:gifImg
                                                            des:des btnTitle:btnTitle
                                                         target:self      action:@selector(apConfigAction:)];
        [self.view addSubview:_apConfigView];
    }
    return _apConfigView;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}

#pragma mark - Action
- (void)backAction:(UIButton *)sender {
    switch (WY_ParamTransfer.selectedKindModel.deviceType) {
        case MeariDeviceSubTypeIpcBell:case MeariDeviceSubTypeIpcBattery:
        case MeariDeviceSubTypeIpcCommon:
            WY_ParamTransfer.selectedKindModel.configMode = WYCameraSelectConfigModeQrCode;break;
        default:break;
    }
    [self wy_popToVC:WYVCTypeCameraInstall];
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"device_config_title");
    switch (WY_ParamTransfer.selectedKindModel.deviceType) {
        case MeariDeviceSubTypeIpcBell:
        case MeariDeviceSubTypeIpcBattery:
            WY_ParamTransfer.selectedKindModel.configMode = WYCameraSelectConfigModeAP;
            break;
        case MeariDeviceSubTypeIpcCommon:
        case MeariDeviceSubTypeIpcBaby:
            WY_ParamTransfer.selectedKindModel.configMode = WYCameraSelectConfigModeQRAP;
        default:
            break;
    }
}
- (void)initLayout {
    WY_WeakSelf
    if (WY_ParamTransfer.selectedKindModel.configMode == WYCameraSelectConfigModeQRAP) {
        [self.qrConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(weakSelf.view);
        }];
        [self.qrConfigView addLineViewAtBottom];
        [self.apConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.qrConfigView.mas_bottom);
            make.leading.trailing.equalTo(weakSelf.view);
            make.height.equalTo(weakSelf.qrConfigView);
            make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
        }];
    } else if (WY_ParamTransfer.selectedKindModel.configMode == WYCameraSelectConfigModeWifiAP) {
        [self.wifiConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(weakSelf.view);
        }];
        [self.wifiConfigView addLineViewAtBottom];
        [self.apConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.wifiConfigView.mas_bottom);
            make.leading.trailing.equalTo(weakSelf.view);
            make.height.equalTo(weakSelf.wifiConfigView);
            make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
        }];
    } else if(WY_ParamTransfer.selectedKindModel.configMode == WYCameraSelectConfigModeWifi){
        [self.wifiConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_centerY);
        }];
    } else if(WY_ParamTransfer.selectedKindModel.configMode == WYCameraSelectConfigModeQrCode){
        [self.qrConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_centerY);
        }];
    } else if(WY_ParamTransfer.selectedKindModel.configMode == WYCameraSelectConfigModeAP){
        [self.apConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_centerY);
        }];
    }
}
#pragma mark -- Action
- (void)apConfigAction:(UIButton *)sender {
    WY_ParamTransfer.selectedKindModel.configMode = WYCameraSelectConfigModeAP;
    [self wy_pushToVC:WYVCTypeCameraInstall];
}

- (void)qrConfigureAction:(UIButton *)sender {
    WY_ParamTransfer.selectedKindModel.configMode = WYCameraSelectConfigModeQrCode;
    [self wy_pushToVC:WYVCTypeCameraInstall];
}
- (void)wifiConfigureAction:(UIButton *)sender {
    WY_ParamTransfer.selectedKindModel.configMode = WYCameraSelectConfigModeWifi;
    [self wy_pushToVC:WYVCTypeCameraInstall];
}



@end
