//
//  WYCameraQRCodeMakerVC.m
//  Meari
//
//  Created by 李兵 on 2017/7/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraQRCodeMakerVC.h"

@interface WYCameraQRCodeMakerVC ()
{
    CGFloat _brightness;
}
@property (nonatomic, strong)WYInstructionView *instructView;
@property (nonatomic, strong)UILabel *desTopLabel;
@property (nonatomic, strong)UILabel *desBottomLabel;
@property (nonatomic, strong)UIImageView *qrcodeImageView;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, strong)WYWifiInfo *wifi;
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*searchSource;
@property (nonatomic, strong)NSMutableArray <MeariDevice *>*dataSource;
@property (nonatomic, copy) NSString *token;
@end

@implementation WYCameraQRCodeMakerVC

#pragma mark - Private
#pragma mark -- Getter
- (WYInstructionView *)instructView {
    if (!_instructView) {
        _instructView = [WYInstructionView config_qr];
        [self.view addSubview:_instructView];
    }
    return _instructView;
}
- (UILabel *)desTopLabel {
    if (!_desTopLabel) {
        _desTopLabel = [UILabel labelWithFrame:CGRectZero
                                       text:WYLocalString(@"qrcode_deviceScan_operation_des")
                                  textColor:WY_FontColor_Black
                                   textfont:WYFont_Text_XS_Normal
                              numberOfLines:0
                              lineBreakMode:NSLineBreakByWordWrapping
                              lineAlignment:NSTextAlignmentCenter
                                  sizeToFit:NO];
        CGFloat w = WY_ScreenWidth - 30;
        CGFloat h = [_desTopLabel ajustedHeightWithWidth:w];
        _desTopLabel.size = CGSizeMake(w, h);
        [self.view addSubview:_desTopLabel];
    }
    return _desTopLabel;
}
- (UILabel *)desBottomLabel {
    if (!_desBottomLabel) {
        _desBottomLabel = [UILabel labelWithFrame:CGRectZero
                                          text:WYLocalString(@"qrcode_deviceScan_result_des")
                                     textColor:WY_FontColor_Gray
                                      textfont:WYFont_Text_XS_Normal
                                 numberOfLines:0
                                 lineBreakMode:NSLineBreakByWordWrapping
                                 lineAlignment:NSTextAlignmentCenter
                                     sizeToFit:NO];
        CGFloat w = WY_ScreenWidth - 30;
        CGFloat h = [_desBottomLabel ajustedHeightWithWidth:w];
        _desBottomLabel.size = CGSizeMake(w, h);
        [self.view addSubview:_desBottomLabel];
    }
    return _desBottomLabel;
}
- (UIImageView *)qrcodeImageView {
    if (!_qrcodeImageView) {
        _qrcodeImageView = [UIImageView new];
        [self.view addSubview:_qrcodeImageView];
    }
    return _qrcodeImageView;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(nextAction:)];
        _nextBtn.layer.cornerRadius = 20;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn setTitle:WYLocal_Next forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
}
WYGetter_MutableArray(searchSource)
WYGetter_MutableArray(dataSource)

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _brightness = WY_MainScreen.brightness;
    if (_brightness < 0.3) {
        WY_MainScreen.brightness = 0.5f;
    }
    [self makeQRCode];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    WY_MainScreen.brightness = _brightness;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(qrcodeOvertime) object:nil];
}

#pragma mark -- Init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = WYLocalString(@"device_config_qr");
    if (self.wy_pushFromVCType == WYVCTypeCameraWifi) {
//        self.navigationItem.rightBarButtonItem = [UIBarButtonItem wifiConfigTextItemWithTarget:self action:@selector(wifiConfigAction:)];
    }
}
- (void)initLayout {
    WY_WeakSelf
//    [self.desTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(weakSelf.desTopLabel.size);
//        make.centerX.equalTo(weakSelf.view);
//        make.top.equalTo(weakSelf.view).offset(20);
//    }];
    [self.instructView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@(weakSelf.instructView.height));
    }];
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_lessThanOrEqualTo(284);
        make.width.equalTo(weakSelf.qrcodeImageView.mas_height).multipliedBy(1.0f);
        make.top.equalTo(weakSelf.instructView.mas_bottom).offset(WY_iPhone_4?10: WY_iPhone_5? 10: 40);
    }];
    [self.desBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.desBottomLabel.size);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.qrcodeImageView.mas_bottom).offset(40);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
        make.top.equalTo(weakSelf.desBottomLabel.mas_bottom).offset(20);
        make.bottom.lessThanOrEqualTo(weakSelf.view).offset(-30);
    }];
    
}


#pragma mark -- Utilities
- (void)makeQRCode {
    if (!self.wifi || self.wifi.ssid.length <= 0) {
        WY_HUD_SHOW_FAILURE_STATUS_VC(@"noWifi", self);
        return;
    }
    
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    __weak MeariUser *weakUser = [MeariUser sharedInstance];
    [self networkRequestToken:^(NSString *obj) {
        weakSelf.token = obj;
        UIImage *image = [weakUser createQRWithSSID:weakSelf.wifi.ssid pasword:weakSelf.wifi.password token:obj size:CGSizeMake(WY_ScreenWidth, WY_ScreenHeight)];
        if (image) {
            WY_HUD_DISMISS
            weakSelf.qrcodeImageView.image = image;
            [weakSelf startSearchDeviceByCloud];
        }else {
            WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"device_qrcode_make_error"), weakSelf);
        }
    } failure:^(NSError *error) {
        WY_HUD_SHOW_ServerError
    }];
}

- (void)startSearchDeviceByCloud {
    if (!self.wy_isTop) {
        return;
    }
    WY_WeakSelf
    [MeariDevice updatetoken:self.token type:MeariDeviceTokenTypeQRCode];
    [MeariDevice startSearch:MeariSearchModeCloud_QRCode success:^(MeariDevice *device) {
        if (WY_IsKindOfClass(device, MeariDevice)) {
            [weakSelf foundCamera:@[device]];
        }
    } failure:^(NSError *error) {
    }];
}
- (void)foundCamera:(NSArray *)cameras {
    if (self.wy_isTop) {
        if (self.wy_pushFromVCType == WYVCTypeCameraWifi) {
            [self wy_pushToVC:WYVCTypeCameraSearch sender:cameras];
        }else {
            [self wy_popToVC:WYVCTypeCameraSearch sender:cameras];
        }
    }
}
- (void)qrcodeOvertime {
    WY_HUD_SHOW_Loading(@"device_qrcode_overtime")
    [MeariDevice stopSearch];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self makeQRCode];
    });
}

#pragma mark -- Network
- (void)networkRequestToken:(WYBlock_Str)success failure:(WYBlock_Error)failure {
//    [[MeariUser sharedInstance] getTokenForType:MeariDeviceTokenTypeQRCode success:^(NSString *token, NSInteger validTime,NSInteger smartSwitch) {
//        if (token.length > 0) {
//            WYDo_Block_Safe1(success, token);
//        }else {
//            WYDo_Block_Safe1(failure, nil)
//        }
//    } failure:^(NSError *error) {
//        [WY_UserM dealMeariUserError:error];
//    }];
    
    [[MeariDeviceActivator sharedInstance] getTokenSuccess:^(NSString *token, NSInteger validTime, NSInteger delaySmart) {
        if (token.length > 0) {
            WYDo_Block_Safe1(success, token);
        }else {
            WYDo_Block_Safe1(failure, nil)
        }
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}


#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [MeariDevice stopSearch];
    [self wy_popToVC:WYVCTypeCameraSearch sender:@(NO)];
}
- (void)nextAction:(UIButton *)sender {
    [MeariDevice stopSearch];
    [self wy_pushToVC:WYVCTypeCameraSearch sender:@(YES)];
}
- (void)wifiConfigAction:(UIButton *)sender {
    [MeariDevice stopSearch];
    if (self.wy_pushFromVCType == WYVCTypeCameraWifi) {
        [self wy_pushToVC:WYVCTypeCameraSearch sender:self.dataSource];
    }else {
        [self wy_popToVC:WYVCTypeCameraSearch sender:self.dataSource];
    }
    return;
    [self wy_pushToVC:WYVCTypeCameraInstall sender:@(WYCameraSelectConfigModeWifi)];
    [self wy_dropFromPage:WYVCTypeCameraInstall toPage:WYVCTypeCameraSelectConfig];
}
#pragma mark - Delegate
#pragma mark -- WYTranstion
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    self.wifi = WY_ParamTransfer.wifiInfo;
    switch (VCType) {
        case WYVCTypeCameraSearch: {
            if (WY_IsKindOfClass(obj, NSNumber)) {
                [self wy_pop];
            }
            break;
        }
        default:
            break;
    }
}


@end
