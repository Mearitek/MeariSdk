//
//  WYDoorBellSettingBatteryLockVC.m
//  Meari
//
//  Created by FMG on 2017/7/25.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingBatteryLockVC.h"
#import "WYDoorBellSettingSwitchView.h"

@interface WYDoorBellSettingBatteryLockVC ()<WYDoorBellSettingSwitchViewDelegate>
@property (nonatomic, strong) WYDoorBellSettingSwitchView *switchView;
@property (nonatomic, strong) MeariDeviceParamBell *doorBell;
@property (nonatomic, strong) NSTimer *autoLockTimer;
@property (nonatomic,   weak) WYTableHeaderView *headerView;
@property (nonatomic,   weak) UIButton *batteryBtn;
@property (nonatomic,   weak) UILabel *btnDesLabel;
@property (nonatomic,   weak) UILabel *headerLabel;
@property (nonatomic, strong) MeariDevice *camera;
@end

@implementation WYDoorBellSettingBatteryLockVC
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
    [self setLayout];
}
- (void)setLayout {
    WY_WeakSelf
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(WY_ScreenWidth, 30));
    }];
    [self.batteryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerLabel.mas_bottom).offset(114);
        make.centerX.equalTo(weakSelf.headerLabel);
        make.size.mas_equalTo(CGSizeMake(187, 187));
    }];
    [self.btnDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.batteryBtn);
        make.top.equalTo(weakSelf.batteryBtn.mas_bottom).offset(42);
    }];
}
- (void)initSubview {
    self.title = WYLocalString(@"BATTERY LOCK");
}

- (void)batteryBtnAction:(UIButton *)sender {
    WY_WeakSelf
    [WYAlertView showWithTitle:WYLocalString(@"Battery Lock") message:WYLocalString(@"alert_batteryLock") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            [weakSelf setBatteryLock:YES success:^{
                WY_HUD_SHOW_TOAST(WYLocalString(@"status_success_unlock"));
                sender.enabled = NO;
                weakSelf.btnDesLabel.text = nil;
            } failure:^{
                WY_HUD_SHOW_STATUS(WYLocalString(@"fail_unlock"));
            }];
        }
    }];
}

#pragma mark - WYDoorBellSettingSwitchViewDelegate
- (void)doorBellSettingSwitchView:(WYDoorBellSettingSwitchView *)view switchOpen:(BOOL)open {
    WY_WeakSelf
    if (open) {
        [WYAlertView showWithTitle:WYLocalString(@"Battery Lock") message:WYLocalString(@"alert_batteryLock") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex) {
                [self setBatteryLock:open success:^{
                    WY_StrongSelf
                    [strongSelf autoLockTimer];
                } failure:^{
                    [view setSwitchOpen:NO];
                }];
            } else {
                [view setSwitchOpen:NO];
            }
        }];
    }
}
- (void)setBatteryLock:(BOOL)open success:(WYBlock_Void)success failure:(WYBlock_Void)failure {
    [self.camera setDoorBellBatteryLockOpen:open success:^{
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}
#pragma mark - lockTimerAction
- (void)autoLockBatteryAction {
    [WYAlertView dismiss];
    self.btnDesLabel.text = WYLocalString(@"des_batteryUnlockBtn");
    self.batteryBtn.enabled = YES;
    [self.autoLockTimer invalidate];
    _autoLockTimer = nil;

}
#pragma mark - transition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if(WY_IsKindOfClass(obj, NSArray)) {
        NSArray *param = (NSArray *)obj;
        self.camera = param[0];
        if (WY_IsKindOfClass(param[1], MeariDeviceParamBell)) {
            self.doorBell = param[1];
        }
    }
}

#pragma mark - lazyLoad
- (WYDoorBellSettingSwitchView *)switchView {
    if (!_switchView) {
        _switchView = [[WYDoorBellSettingSwitchView alloc] initWithSwTitle:WYLocalString(@"Battery Lock") description:WYLocalString(@"des_batteryLock")];
        [_switchView setSwitchOpen:self.doorBell.batterylock];
        _switchView.delegate = self;
        [self.view addSubview:_switchView];
    }
    return _switchView;
}
- (NSTimer *)autoLockTimer {
    if (!_autoLockTimer) {
        _autoLockTimer = [NSTimer timerInLoopWithInterval:30 target:self selector:@selector(autoLockBatteryAction)];
    }
    return _autoLockTimer;
}
- (WYTableHeaderView *)headerView {
    if (!_headerView) {
        WYTableHeaderView *headerV = [WYTableHeaderView header_prompt_jingleBellPairing];
        [self.view addSubview:headerV];
        self.headerView = headerV;
    }
    return _headerView;
}
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                  text:WYLocalString(@"des_doorbell_batteryLock")
                                  textColor:WY_FontColor_Orange
                                  textfont:WYFont_Text_S_Normal
                                  numberOfLines:0 lineBreakMode:NSLineBreakByTruncatingTail
                                  lineAlignment:NSTextAlignmentCenter
                                                  sizeToFit:NO];
        label.backgroundColor = WY_BGColor_LightOrange;
        [self.view addSubview:label];
        self.headerLabel = label;
    }
    return _headerLabel;
}
- (UIButton *)batteryBtn {
    if (!_batteryBtn) {
        UIButton *btn  = [UIButton new];
        self.batteryBtn = btn;
        btn.wy_normalBGImage = [UIImage imageNamed:@"img_doorbell_battery_locked"];
        btn.wy_disabledBGImage = [UIImage imageNamed:@"img_doorbell_battery_unlock_disabled"];
        [btn addTarget:self action:@selector(batteryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    return _batteryBtn;
}
- (UILabel *)btnDesLabel {
    if(!_btnDesLabel) {
        UILabel *lab = [UILabel new];
        self.btnDesLabel = lab;
        lab.text = WYLocalString(@"des_batteryUnlockBtn");
        lab.font = WYFontNormal(16);
        lab.textColor = WY_FontColor_GrayA;
        [self.view addSubview:lab];
    }
    return _btnDesLabel;
}
@end
