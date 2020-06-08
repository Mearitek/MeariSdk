//
//  MRDeviceUpgradeVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/5.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRDeviceUpgradeVC.h"

@interface MRDeviceUpgradeVC () {

}
@property (weak, nonatomic) IBOutlet UITextView *deviceVersionTextView;
@property (weak, nonatomic) IBOutlet UITextView *checkTextView;
@property (weak, nonatomic) IBOutlet UITextView *upgradeTextView;


@property (nonatomic, copy) NSString *currentVersion;
@property (nonatomic, strong) MeariDeviceFirmwareInfo *info;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation MRDeviceUpgradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"device upgrade";
    
    self.deviceVersionTextView.layer.cornerRadius = 5;
    self.deviceVersionTextView.layer.masksToBounds = YES;
    self.deviceVersionTextView.layer.borderWidth = 1;
    self.deviceVersionTextView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.checkTextView.layer.cornerRadius = 5;
    self.checkTextView.layer.masksToBounds = YES;
    self.checkTextView.layer.borderWidth = 1;
    self.checkTextView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.upgradeTextView.layer.cornerRadius = 5;
    self.upgradeTextView.layer.masksToBounds = YES;
    self.upgradeTextView.layer.borderWidth = 1;
    self.upgradeTextView.layer.borderColor = [UIColor blackColor].CGColor;
    // Do any additional setup after loading the view from its nib.
}

- (NSTimer *)updateTimer {
    if (!_updateTimer) {
        _updateTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerToQueryPercent:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_updateTimer forMode:NSRunLoopCommonModes];
    }
    return _updateTimer;
}

// get device version
- (IBAction)getDeviceVersionAction:(id)sender {
    WY_WeakSelf
    //  get device version
    [self.camera getFirmwareVersionSuccess:^(NSString *version) {
        self.deviceVersionTextView.text = version;
        weakSelf.camera.info.version = version;
        weakSelf.currentVersion = version;
        
        //  get whether the deivice can be upgrade
        [[MeariUser sharedInstance] checkNewFirmwareWith:weakSelf.camera.info.sn tp:weakSelf.camera.info.tp currentFirmware:weakSelf.currentVersion success:^(MeariDeviceFirmwareInfo *info) {
            weakSelf.checkTextView.text = [NSString stringWithFormat:@"upgradeUrl = %@, latestVersion = %@, upgradeDescription = %@, needUpgrade = %@", info.upgradeUrl, info.latestVersion, info.upgradeDescription, info.needUpgrade ? @"1" : @"0"];
            
            weakSelf.info = info;
        } failure:^(NSError *error) {
            weakSelf.checkTextView.text = error.domain;
        }];
        
    } failure:^(NSError *error) {
        weakSelf.deviceVersionTextView.text = error.domain;
    }];
}

// start upgrade device
- (IBAction)startUpgradeAction:(id)sender {
    if (!self.currentVersion.length) {
        [UIAlertController alertControllerMessage:@"please get device version first"];
        return;
    }
    if (!self.info.needUpgrade) {
        [UIAlertController alertControllerMessage:@"device already the latest version "];
        return;
    }
    [self.camera startDeviceUpgradeWithUrl:self.info.upgradeUrl currentVersion:self.currentVersion success:^{
         [self enableUpdateTimer:YES];
    } failure:^(NSError *error) {
        if (error.code == MeariDeviceCodeVersionIsUpgrading) {
            [self enableUpdateTimer:YES];
        }else if (error.code == MeariDeviceCodeVersionLowPower) {
            self.upgradeTextView.text = @"The device is with low power, can not be upgraded.";
        }else {
            self.upgradeTextView.text = @"Update Failed!";
        }
    }];
}
- (void)timerToQueryPercent:(NSTimer *)sender {
    WY_WeakSelf
   [self.camera getDeviceUpgradePercentSuccess:^(NSInteger percent) {
       weakSelf.upgradeTextView.text = [NSString stringWithFormat:@"device updgrade, current : %li", percent];
       if (percent == 100) {
           weakSelf.upgradeTextView.text = @"device updgrade success";
       }
   } failure:^(NSError *error) {
       weakSelf.upgradeTextView.text = error.domain;
   }];
}
#pragma mark - timer
- (void)enableUpdateTimer:(BOOL)enabled {
    if (enabled) {
        if (!_updateTimer) {
            NSLog(@"升级设备定时器：开启");
            [self.updateTimer fire];
        }
    } else {
        if (_updateTimer) {
            NSLog(@"升级设备定时器：关闭");
            [_updateTimer invalidate];
            _updateTimer = nil;
        }
    }
}

#pragma mark --- private

@end
