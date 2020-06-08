//
//  MRDeviceSDFormatVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/5.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "MRDeviceSDFormatVC.h"

@interface MRDeviceSDFormatVC ()
@property (weak, nonatomic) IBOutlet UITextView *sdcardStatusTextView;
@property (weak, nonatomic) IBOutlet UITextView *formatStatusTextView;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation MRDeviceSDFormatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"format sdcard";
    self.sdcardStatusTextView.layer.cornerRadius = 5;
    self.sdcardStatusTextView.layer.masksToBounds = YES;
    self.sdcardStatusTextView.layer.borderWidth = 1;
    self.sdcardStatusTextView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.formatStatusTextView.layer.cornerRadius = 5;
    self.formatStatusTextView.layer.masksToBounds = YES;
    self.formatStatusTextView.layer.borderWidth = 1;
    self.formatStatusTextView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (NSTimer *)updateTimer {
    if (!_updateTimer) {
        _updateTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerToQueryPercent:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_updateTimer forMode:NSRunLoopCommonModes];
    }
    return _updateTimer;
}

// get sd card info
- (IBAction)sdCardInfoAction:(id)sender {
    WY_WeakSelf
    [self.camera getSDCardInfoSuccess:^(MeariDeviceParamStorage *storage) {
        if (storage.unSupported) {
            weakSelf.sdcardStatusTextView.text = @"sd card unsupport, please format it";
            
        }else if (storage.isReading){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sdCardInfoAction:nil];
            });
        }else if(storage.unKnown) {
            weakSelf.sdcardStatusTextView.text = @"sd card unknow";
            
        }else {
            if(storage.isFormatting){
                weakSelf.sdcardStatusTextView.text = [NSString stringWithFormat:@"sd card isFormatting ,  %@/%@", storage.totalSpace, storage.freeSpace];
            } else {
                weakSelf.sdcardStatusTextView.text = [NSString stringWithFormat:@"sd card normal ,  %@/%@", storage.totalSpace, storage.freeSpace];
            }
        }
    } failure:^(NSError *error) {
        weakSelf.sdcardStatusTextView.text = @"Cannot get SD card info.";
    }];
}
// start format sd card
- (IBAction)startFormatAction:(id)sender {
    WY_WeakSelf
    [self.camera startSDCardFormatSuccess:^{
        WY_StrongSelf
        [strongSelf enableUpdateP2pTimer:YES];
    } failure:^(NSError *error) {
        weakSelf.formatStatusTextView.text = @"Format SD card failed.";
    }];
}

#pragma mark --- private
- (void)enableUpdateP2pTimer:(BOOL)enabled {
    if (enabled) {
        if (!_updateTimer) {
            [self.updateTimer fire];
        }
    } else {
        if (_updateTimer) {
            [_updateTimer invalidate];
            _updateTimer = nil;
        }
    }
}
- (void)timerToQueryPercent:(NSTimer *)sender {
    WY_WeakSelf
    
    [self.camera getSDCardFormatPercentSuccess:^(NSInteger percent) {
        weakSelf.sdcardStatusTextView.text = [NSString stringWithFormat:@"format sdcard, current : %li", percent];
    } failure:^(NSError *error) {
        weakSelf.sdcardStatusTextView.text = @"format error";
    }];
}

@end
