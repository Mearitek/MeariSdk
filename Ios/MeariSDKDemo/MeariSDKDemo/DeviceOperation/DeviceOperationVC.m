//
//  DeviceOperationVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "DeviceOperationVC.h"
#import "MRDeviceSettingVC.h"

@import AVFoundation;
@interface DeviceOperationVC ()
@property (weak, nonatomic) IBOutlet MeariPlayView *playView;

@property (nonatomic, strong) NSArray  *playbackTimes;

@end

@implementation DeviceOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.camera.info.nickname;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"setting" style:(UIBarButtonItemStylePlain) target:self action:@selector(settingAction)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 32, 44);
    [btn setImage:[[UIImage imageNamed:@"nav_back_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)backAction {
    [self releaseCamera];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)releaseCamera {
    //Free up camera resources
    // 1. stop preview or playback
    // 2. disconnect
    // 3. Call the "reset" method to release resources
    [self.camera stopPreviewSuccess:^{} failure:^(NSError *error) {}];
    [self.camera stopConnectSuccess:^{} failure:^(NSError *error) {}];
    [self.camera reset];
}
- (void)settingAction {
    MRDeviceSettingVC *setting = [[MRDeviceSettingVC alloc] init];
    setting.camera = self.camera;
    [self.navigationController pushViewController:setting animated:YES];
}
    
- (IBAction)connect:(id)sender {
    if (self.camera.lowPowerDevice) {
        [[MeariUser sharedInstance] remoteWakeUpWithDeviceID:self.camera.info.ID success:^{
            NSLog(@"server remote device success");
        } failure:^(NSError *error) {
            NSLog(@"server remote device failure --- %@",error);
        }];
    }
    [self.camera startConnectSuccess:^{
        NSLog(@"connect success");
    } abnormalDisconnect:^{
        NSLog(@"abnormalDisconnect");
    } failure:^(NSError *error) {
        NSLog(@"connect failure --- %@",error);
    }];
    
}
- (IBAction)disConnect:(id)sender {
    [self.camera stopConnectSuccess:^{
         NSLog(@"stop success");
    } failure:^(NSError *error) {
        NSLog(@"stop failure --- %@",error);
    }];
    
}
- (IBAction)startPreView:(id)sender {
    NSLog(@"camera support videoStream ---- %@",self.camera.supportVideoStreams);
    MeariDeviceVideoStream videoStream = (MeariDeviceVideoStream)([[self transformVideoStream:self.camera.supportVideoStreams].firstObject integerValue]);
    if (self.camera.sdkLogined && self.camera.sdkLogining ) {
        NSLog(@"Device is not connected");
        return;
    }
    if(self.camera.sdkPlayRecord){
        [self stopPlayback:nil];
    }
    [self.camera startPreviewWithPlayView:self.playView videoStream:videoStream success:^{
        NSLog(@"start preview success");
    } failure:^(NSError *error) {
        NSLog(@"start preview failure --- %@",error);
    } close:^(MeariDeviceSleepMode sleepModeType) {
        NSLog(@"device open sleep mode  --- %ld", sleepModeType);
    }];
    
}
- (IBAction)stopPreView:(id)sender {
    [self.camera stopPreviewSuccess:^{
       NSLog(@"stop preview success");
    } failure:^(NSError *error) {
       NSLog(@"stop preview failure --- %@",error);
    }];
    
}
- (IBAction)startPlayback:(id)sender {
    // Get the number of playback days in the specified month
//    [self.camera getPlaybackVideoDaysInMonth:6 year:2020 success:^(NSArray *days) {
//
//    } failure:^(NSError *error) {
//
//    }];
    NSDateComponents *curComponent = [ [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if (self.camera.sdkLogined && self.camera.sdkLogining ) {
        NSLog(@"Device is not connected");
        return;
    }
    if (self.camera.sdkPlaying) {
        [self stopPreView:nil];
    }
    [self.camera getPlaybackVideoTimesInDay:curComponent.day month:curComponent.month year:curComponent.year success:^(NSArray *times) {
        NSLog(@"playback times --- %@",times);
        self.playbackTimes = times;
        NSDictionary *dic = times.firstObject;
        //start playback
        [self.camera startPlackbackSDCardWithPlayView:self.playView startTime:dic[@"starttime"] success:^{
            NSLog(@"playback success time --- %@",dic[@"starttime"]);
        } failure:^(NSError *error) {
            NSLog(@"playback failure time --- %@",error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"get playback times failure --- %@",error);
    }];
    
}
- (IBAction)stopPlayback:(id)sender {
    [self.camera stopPlackbackSDCardSuccess:^{
        NSLog(@"stop playback success");
    } failure:^(NSError *error) {
        NSLog(@"stop playback failure --- %@",error);
    }];
}
- (IBAction)switchPreView:(id)sender {
    MeariDeviceVideoStream videoStream = (MeariDeviceVideoStream)([[self transformVideoStream:self.camera.supportVideoStreams].lastObject integerValue]);
    [self.camera changeVideoResolutionWithPlayView:self.playView videoStream:videoStream success:^{
        NSLog(@"switch resolution success --- %ld",(long)videoStream);
    } failure:^(NSError *error) {
        NSLog(@"switch resolution failure --- %@",error);
    }];
}
- (IBAction)startSeek:(id)sender {
    if (self.playbackTimes.count <= 0) {
        NSLog(@"camera playback times count is empty");
        return;
    }
    NSDictionary *dic = self.playbackTimes.firstObject;
    [self.camera seekPlackbackSDCardWithSeekTime:dic[@"starttime"] success:^{
        NSLog(@"seek success --- %@",dic[@"starttime"]);
    } failure:^(NSError *error) {
        NSLog(@"seek failure --- %@",error);
    }];
}
- (IBAction)screenShot:(id)sender {
    BOOL isPreview = self.camera.sdkPlaying;

    [self.camera snapshotWithSavePath:[self snapshotPath] isPreviewing:isPreview success:^{
        NSLog(@"snapshot success file path --- %@",[self snapshotPath]);
    } failure:^(NSError *error) {
        NSLog(@"snapshot failure error --- %@",error);
    }];
}
- (IBAction)record:(UIButton *)sender {
    sender.selected = !sender.selected;
    BOOL isPreview = self.camera.sdkPlaying;
    if (sender.selected) {
        [self.camera startRecordMP4WithSavePath:[self recordVideoPath] isPreviewing:isPreview success:^{
            NSLog(@"start record success path --- %@",[self recordVideoPath]);
        } abnormalDisconnect:^{
            NSLog(@"record abnormalDisconnect");
        } failure:^(NSError *error) {
            NSLog(@"start record failure --- %@",error);
        }];
    }else {
        [self.camera stopRecordMP4WithIsPreviewing:isPreview success:^{
            NSLog(@"stop record success");
        } failure:^(NSError *error) {
            NSLog(@"stop record failure --- %@",error);
        }];
    }
    
}
- (IBAction)speak:(UIButton *)sender {
    [self checkAuthorityOfMicrophone:^(BOOL granted) {
        if (!granted) {
            return;
        }
    }];
    sender.selected = !sender.selected;
    if (sender.selected) {
        MeariVoiceTalkType type = self.camera.supportFullDuplex ? MeariVoiceTalkTypeFullDuplex : MeariVoiceTalkTypeOneWay;
        [self.camera setVoiceTalkType:type];
        [self.camera enableLoudSpeaker:YES];
        [self.camera startVoiceTalkWithIsVoiceBell:NO success:^{
            NSLog(@"start voice talk success");
        } failure:^(NSError *error) {
            NSLog(@"start voice talk failure --- %@",error);
        }];
    }else {
        [self.camera stopVoicetalkSuccess:^{
            NSLog(@"stop voice talk succes");
        } failure:^(NSError *error) {
            NSLog(@"stop voice talk failure --- %@",error);
        }];
        [self.camera setVoiceTalkType:MeariVoiceTalkTypeOneWay];
    }
}
- (IBAction)mute:(UIButton *)sender  {
    sender.selected = !sender.selected;
    [self.camera setMute:sender.selected];
}

#pragma mark ---  Tool

- (NSArray *)transformVideoStream:(NSArray *)streamStringArray {
    NSMutableArray *videoStream = [NSMutableArray array];
    for (NSString *streamString in streamStringArray) {
        if ([streamString isEqualToString:@"3MP@4M"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_3MP_2_4)];
        }else if ([streamString isEqualToString:@"3MP@4M"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_3MP_1_2)];
        }else if ([streamString isEqualToString:@"1080P@2M"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_1080_2_0)];
        }else if ([streamString isEqualToString:@"1080P@1.5M"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_1080_1_5)];
        }else if ([streamString isEqualToString:@"1080P"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_1080)];
        }else if ([streamString isEqualToString:@"720P"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_720)];
        }else if ([streamString isEqualToString:@"480P"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_480)];
        }else if ([streamString isEqualToString:@"360P"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_360)];
        }else if ([streamString isEqualToString:@"240P"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_240)];
        }else if ([streamString isEqualToString:@"HD"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_HD)];
        }else if ([streamString isEqualToString:@"SD"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_360)];
        }else if ([streamString containsString:@"NEW_SD"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_NEW_SD)];
        }else if ([streamString containsString:@"NEW_HD"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_NEW_HD)];
        }else if ([streamString containsString:@"NEW_FHD"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_NEW_FHD)];
        }else if ([streamString containsString:@"NEW_UHD"]) {
            [videoStream addObject:@(MeariDeviceVideoStream_NEW_UHD)];
        }
    }
    return videoStream.copy;
}

- (NSString *)snapshotPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"test.png"];
}
- (NSString *)recordVideoPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"video.mp4"];
}

- (void)checkAuthorityOfMicrophone:(void(^)(BOOL granted))authorityResult {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if(authorityResult) {
                authorityResult(granted);
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            if(authorityResult) {
               authorityResult(YES);
            }
            break;
        }
        default: {
            if(authorityResult) {
               authorityResult(NO);
            }
            break;
        }
    }
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
