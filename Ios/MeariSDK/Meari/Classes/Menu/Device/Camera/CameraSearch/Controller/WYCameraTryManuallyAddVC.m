//
//  WYCameraTryManuallyAddVC.m
//  Meari
//
//  Created by 李兵 on 2017/3/3.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraTryManuallyAddVC.h"

@interface WYCameraTryManuallyAddVC ()
@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel *desLabel;
@property (nonatomic, strong)UILabel *helpLabel;
@property (nonatomic, strong)UIButton *connectBtn;
@property (nonatomic, strong)UILabel *connectLabel;
@property (nonatomic, strong)WYLoadingView *loadingView;
@property (nonatomic, copy) WYWifiInfo *wifi;


@end

@implementation WYCameraTryManuallyAddVC
#pragma mark - Private
#pragma mark -- Getter
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [UIImageView new];;
        _imageV.image = [UIImage imageNamed:@"img_camera_connectAP"];
    }
    if (!_imageV.superview) {
        [self.view addSubview:_imageV];
    }
    return _imageV;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel wy_new];
        _desLabel.attributedText = [NSAttributedString defaultAttributedStringWithString:WYLocalString(@"des_tryToAddManually")
                                                                               fontColor:WY_FontColor_Gray
                                                                                    font:WYFont_Text_S_Normal
                                                                               alignment:NSTextAlignmentCenter];
        CGFloat w = WY_ScreenWidth-60;
        CGFloat h = [_desLabel ajustedHeightWithWidth:w];
        _desLabel.size = CGSizeMake(w, h);
    }
    if (!_desLabel.superview) {
        [self.view addSubview:_desLabel];
    }
    return _desLabel;
}
- (UILabel *)helpLabel {
    if (!_helpLabel) {
        _helpLabel = [UILabel wy_new];
        _helpLabel.attributedText = [NSAttributedString defaultAttributedStringWithString:WYLocalString(@"des_help_noDeviceConnected")
                                                                               fontColor:WY_FontColor_Cyan
                                                                                    font:WYFont_Text_S_Normal
                                                                               alignment:NSTextAlignmentCenter];
        CGFloat w = WY_ScreenWidth-60;
        CGFloat h = [_helpLabel ajustedHeightWithWidth:w];
        _helpLabel.size = CGSizeMake(w, h);
        [_helpLabel setHighlightedTextColor:WY_FontColor_Gray];
        [_helpLabel addTapGestureTarget:self action:@selector(helpAction:)];
    }
    if (!_helpLabel.superview) {
        [self.view addSubview:_helpLabel];
    }
    return _helpLabel;
}
- (UIButton *)connectBtn {
    if (!_connectBtn) {
        _connectBtn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(connectAction:)];
        _connectBtn.layer.cornerRadius = 20;
        _connectBtn.layer.masksToBounds = YES;
        [_connectBtn setTitle:WYLocalString(@"CONNECT") forState:UIControlStateNormal];
    }
    if (!_connectBtn.superview) {
        [self.view addSubview:_connectBtn];
    }
    return _connectBtn;
}
- (UILabel *)connectLabel {
    if (!_connectLabel) {
        _connectLabel = [UILabel wy_new];
        _connectLabel.attributedText = [NSAttributedString defaultAttributedStringWithString:WYLocalString(@"des_apConnect")
                                                                               fontColor:WY_FontColor_Gray
                                                                                    font:WYFont_Text_XS_Normal
                                                                               alignment:NSTextAlignmentCenter];
        CGFloat w = WY_ScreenWidth-60;
        CGFloat h = [_helpLabel ajustedHeightWithWidth:w];
        _connectLabel.size = CGSizeMake(w, h);
        _connectLabel.hidden = YES;
    }
    if (!_connectLabel.superview) {
        [self.view addSubview:_connectLabel];
    }
    return _connectLabel;
}
- (WYLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [WYLoadingView new];
        [_loadingView setCircleColor:WY_MainColor];
        _loadingView.hidden = YES;
    }
    if (!_loadingView.superview) {
        [self.view addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"TRY TO ADD MANUALLY");
}
- (void)initLayout {
    WY_WeakSelf
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(weakSelf.imageV.image.size.width/2, weakSelf.imageV.image.size.height/2));
        make.top.equalTo(weakSelf.view).with.offset(55).priorityHigh();
        make.top.greaterThanOrEqualTo(weakSelf.view).with.offset(10);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.imageV.mas_bottom).with.offset(55).priorityHigh();
        make.top.greaterThanOrEqualTo(weakSelf.imageV.mas_bottom).with.offset(20);
        make.size.mas_equalTo(weakSelf.desLabel.size);
    }];
    [self.helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(weakSelf.helpLabel.size);
        make.top.equalTo(weakSelf.desLabel.mas_bottom).with.offset(20);
    }];
    [self.connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(@40);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
        make.bottom.equalTo(weakSelf.view).with.offset(-30+WY_SAFE_BOTTOM_LAYOUT);
        make.top.greaterThanOrEqualTo(weakSelf.helpLabel.mas_bottom).offset(20);
    }];
    [self.connectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(weakSelf.connectLabel.size);
        make.bottom.equalTo(weakSelf.view).with.offset(-49).priorityHigh();
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(weakSelf.connectLabel.mas_top).with.offset(-20);
        make.top.greaterThanOrEqualTo(weakSelf.helpLabel.mas_bottom).offset(20);
    }];
}

#pragma mark -- Utilities
- (void)startAP {
    WY_WeakSelf
    CFTimeInterval st = CFAbsoluteTimeGetCurrent();
    [MeariDevice startAPConfigureWifiSSID:self.wifi.ssid wifiPwd:self.wifi.password success:^{
        CFTimeInterval t = CFAbsoluteTimeGetCurrent() - st < 1 ? 1 : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.loadingView showSuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.wy_pushFromVCType == WYVCTypeCameraSearch) {
                    [weakSelf wy_popToVC:WYVCTypeCameraSearch];
                }else {
                    [weakSelf wy_pushToVC:WYVCTypeCameraSearch];
                }
            });
        });
    } failure:^(NSError *error) {
        CFTimeInterval t = CFAbsoluteTimeGetCurrent() - st < 1 ? 1 : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.loadingView showFailure];
            [WYAlertView showAPFailureWithCancelAction:^{
                [weakSelf.loadingView dismiss];
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.connectLabel.transform = CGAffineTransformMakeScale(0.1, 1);
                    weakSelf.connectBtn.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    if (finished) {
                        weakSelf.connectLabel.hidden = YES;
                        weakSelf.connectLabel.transform = CGAffineTransformMakeScale(1, 1);
                    }
                }];
            } otherAction:^{
                [weakSelf.loadingView showWithCircle];
                [weakSelf startAP];
            }];
        });
    }];
    
}
- (void)prepareAP {
    self.connectLabel.alpha = 0.0f;
    self.connectLabel.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.connectBtn.transform = CGAffineTransformMakeScale(0, 1);
        self.connectLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.connectLabel.hidden = NO;
            self.loadingView.hidden = NO;
            [self.loadingView showWithCircle];
            [self startAP];
        }
    }];
}


#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}
#pragma mark -- Action
- (void)connectAction:(UIButton *)sender {
    NSString *wifiSSID = WY_WiFiM.currentSSID;
    if ([wifiSSID hasPrefix:WYAPP_AP_Prefix]) {
        [self prepareAP];
    }else {
        if (![WY_Application wy_jumpToWIFI]) {
            [WYAlertView showAPWifiError];
        }
    }
}
- (void)helpAction:(UITapGestureRecognizer *)sender {
    [self wy_pushToVC:WYVCTypeHelpAP];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeCameraManuallyAdd: {
            if (WY_IsKindOfClass(obj, WYWifiInfo)) {
                self.wifi = obj;
            }
            break;
        }
        case WYVCTypeCameraWifi: {
            if (WY_IsKindOfClass(obj, WYWifiInfo)) {
                self.wifi = obj;
            }
            break;
        }
        case WYVCTypeCameraSearch: {
            if (WY_IsKindOfClass(obj, WYWifiInfo)) {
                self.wifi = obj;
            }
            break;
        }
        default:
            break;
    }
}

@end
