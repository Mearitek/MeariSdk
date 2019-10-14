//
//  WYNVRSettingSelectWIFIVC.m
//  Meari
//
//  Created by 李兵 on 2017/2/17.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYNVRSettingSelectWIFIVC.h"

@interface WYNVRSettingSelectWIFIVC ()
{
    NSDictionary *_dic;
    id _bindObj;
}
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *ssidView;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, strong)UITextField *ssidTF;

@end

@implementation WYNVRSettingSelectWIFIVC
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [WYInstructionView nvrSetting_SelectWifi];
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (UIView *)ssidView {
    if (!_ssidView) {
        UIView *v = [UIView new];
        [self.view addSubview:v];
        _ssidView = v;
        UILabel *l1 = [UILabel labelWithFrame:CGRectZero
                                         text:WYLocalString(@"wifi_ssid")
                                    textColor:WY_FontColor_Black
                                     textfont:WYFont_Text_M_Normal
                                numberOfLines:0
                                lineBreakMode:NSLineBreakByTruncatingTail
                                lineAlignment:NSTextAlignmentCenter
                                    sizeToFit:YES];
        [v addSubview:l1];
        [v addSubview:self.ssidTF];
        
        
        [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(l1.size);
            make.centerY.equalTo(v);
            make.leading.equalTo(v).with.offset(20);
        }];
        [self.ssidTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(v);
            make.centerY.equalTo(v);
            make.leading.equalTo(l1.mas_trailing).with.offset(50);
            make.trailing.equalTo(v).with.offset(-20);
        }];
        [_ssidView addLineViewAtBottom];
    }
    return _ssidView;
}
- (UITextField *)ssidTF {
    if (!_ssidTF) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectZero];
        tf.placeholder = WYLocalString(@"noWifi");
        tf.textColor = WY_FontColor_Gray;
        tf.font = WYFont_Text_M_Normal;
        tf.text = WY_WiFiM.currentSSID;
        tf.userInteractionEnabled = NO;
        _ssidTF = tf;
    }
    return _ssidTF;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        UIButton *btn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(nextAction:)];
        [btn setTitle:WYLocal_Next forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20;
        [self.view addSubview:btn];
        _nextBtn = btn;
    }
    return _nextBtn;
}


#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"Select WIFI");
}
- (void)initLayout {
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.topView.size);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
    [self.ssidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@70);
        make.top.equalTo(weakSelf.topView.mas_bottom);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view.mas_width).multipliedBy(0.7);
        make.height.equalTo(@40);
        make.bottom.equalTo(weakSelf.view).with.offset(-25);
        make.centerX.equalTo(weakSelf.view);
    }];
}

#pragma mark -- Utilities
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(appDidEnterForehead:) name:UIApplicationDidBecomeActiveNotification  object:nil];
}
- (void)removeNotification {
    [WY_NotificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)appDidEnterForehead:(NSNotification *)sender {
    NSString *ssid = WY_WiFiM.currentSSID;
    self.ssidTF.text = ssid.length > 0 ? ssid : nil;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self initNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)deallocAction {
    [self removeNotification];
}

#pragma mark -- Action
- (void)nextAction:(UIButton *)sender {
    if (self.ssidTF.text.length <= 0) {
        [WYAlertView showWithTitle:WYLocalString(@"networkSetting")
                           message:[NSAttributedString attributedNetworkSetting]
                      cancelButton:WYLocal_OK
                       otherButton:nil
                         alignment:NSTextAlignmentLeft
                       alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                           
                       }];
    }else {
        [self wy_pushToVC:WYVCTypeNVRSettingCameraBinding sender:_dic];
    }
}
- (void)backAction:(UIButton *)sender {
    [self wy_popToVC:WYVCTypeNVRSettingCameraList sender:_bindObj];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    switch (VCType) {
        case WYVCTypeNVRSettingCameraList: {
            if (WY_IsKindOfClass(obj, NSDictionary)) {
                _dic = obj;
            }
            break;
        }
        case WYVCTypeNVRSettingCameraBinding: {
            _bindObj = obj;
            break;
        }
        default:
            break;
    }
}

#pragma mark - Public




@end
