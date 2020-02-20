//
//  WYCameraSettingSleepOverTimeVC.m
//  Meari
//
//  Created by maj on 2020/1/9.
//  Copyright © 2020 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepOverTimeVC.h"

@interface WYCameraSettingSleepOverTimeVC ()

@property (nonatomic, strong) UIButton *sleepOverTimeButton;

@end

@implementation WYCameraSettingSleepOverTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.sleepOverTimeButton setTitle:[NSString stringWithFormat:@"set Sleep Over Time = %li", self.camera.param.voiceBell.sleepOverTime] forState:UIControlStateNormal];
}

#pragma mark --- lazyload
- (UIButton *)sleepOverTimeButton {
    if (!_sleepOverTimeButton) {
        _sleepOverTimeButton = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(sleepOverTime:)];
        [_sleepOverTimeButton setTitle:@"set Sleep Over Time" forState:UIControlStateNormal];
    }
    return _sleepOverTimeButton;
}

#pragma mark --- initSet
- (void)initSet {
    [self.view addSubview:self.sleepOverTimeButton];
}
- (void)initLayout {
   [self.sleepOverTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}
                                
#pragma mark --- network
- (void)sleepOverTime:(UIButton *)button {
    // SleepOverTime range 0-60
    [self.camera iotSetDoorBellSleepOverTime:33 success:^{
        [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
        [self.sleepOverTimeButton setTitle:[NSString stringWithFormat:@"set Sleep Over Time = %li", self.camera.param.voiceBell.sleepOverTime] forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
    }];
}

@end
