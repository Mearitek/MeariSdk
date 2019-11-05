//
//  MeariDevice.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeariDeviceInfo.h"
#import "MeariDeviceParam.h"
#import "MeariDeviceControl.h"

@interface MeariDevice : MeariBaseModel<MeariDeviceControl>
#pragma mark - info
/** device info*/
@property (nonatomic, strong) MeariDeviceInfo *info;
/** device params*/
@property (nonatomic, strong) MeariDeviceParam *param;
/** normal device*/
@property (nonatomic, assign, readonly, getter=isIpcCommon)BOOL ipcCommon;
/** music device*/
@property (nonatomic, assign, readonly, getter=isIpcBaby)BOOL ipcBaby;
/** doorbell*/
@property (nonatomic, assign, readonly, getter=isIpcBell)BOOL ipcBell;
/** nvr network storage*/
@property (nonatomic, assign, readonly, getter=isNvr)BOOL nvr;
/** Whether the device is bound to the NVR*/
@property (nonatomic, assign)BOOL hasBindedNvr;
#pragma mark -- status
/** Whether the device has established a network connection*/
@property (nonatomic, assign, readonly)BOOL sdkLogined;
/** Whether the device is establishing a network connection*/
@property (nonatomic, assign, readonly)BOOL sdkLogining;
/** Whether the device is being previewed*/
@property (nonatomic, assign, readonly) BOOL sdkPreparePlay;
/** Whether the device is prepare previewed*/
@property (nonatomic, assign, readonly)BOOL sdkPlaying;
/** Whether the device is being playbacked*/
@property (nonatomic, assign, readonly)BOOL sdkPlayRecord;
/** The time currently being played back*/
@property (nonatomic, strong)NSDateComponents *playbackTime;
/** nvr's camera*/
- (instancetype)nvrCamera;
/** videoStream 720/1080*/
- (MeariDeviceVideoStream)videoStreamHD;
/** videoStream 240/360*/
- (MeariDeviceVideoStream)videoStreamSD;
/** Get the stream type of device*/
- (NSArray *)supportVideoStreams;
/** Whether to support two-way voice intercom */
@property (nonatomic, assign, readonly) BOOL supportFullDuplex;
/** Whether to support voice intercom */
@property (nonatomic, assign, readonly) BOOL supportVoiceTalk;
/** Whether to support mute */
@property (nonatomic, assign, readonly) BOOL supportMute;
/** Whether to support HD SD */
@property (nonatomic, assign, readonly) BOOL supportVideoHDSD;
/** Only support HD */
@property (nonatomic, assign, readonly) BOOL supportVideoOnlyHD;
/** Whether to support host Message */
@property (nonatomic, assign, readonly) BOOL supportHostMessage;
/** Whether to support power management */
@property (nonatomic, assign, readonly) BOOL supportPowerManagement;
/** Whether to support SDCard playback */
@property (nonatomic, assign, readonly) BOOL supportSDCard;
/** Whether to support Machinery Bell */
@property (nonatomic, assign, readonly) BOOL supportMachineryBell;
/** Whether to support Wireless Bell */
@property (nonatomic, assign, readonly) BOOL supportWirelessBell;
/** Whether to support Wireless */
@property (nonatomic, assign, readonly) BOOL supportWirelessEnable;
/** Whether to support local server */
@property (nonatomic, assign, readonly) BOOL supportOnvif;
/** Whether to support image flip */
@property (nonatomic, assign, readonly) BOOL supportFlip;
/** Whether to support upgrade device */
@property (nonatomic, assign, readonly) BOOL supportOTA;
/** Whether to support set body detection sensitivity */
@property (nonatomic, assign, readonly) MeariDevicePirSensitivity supportPirSensitivity;
/** Whether to support setting sleep mode */
@property (nonatomic, assign, readonly) BOOL supportSleepMode;
/** Is it a low power device */
@property (nonatomic, assign, readonly) BOOL lowPowerDevice;
/** Whether to support switching the main stream */
@property (nonatomic, assign, readonly) BOOL supportVideoEnc;
/** Whether to support Humanoid detection */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetect;
/** Whether to support Human border*/
@property (nonatomic, assign, readonly) BOOL supportPeopleTrackBorder;

@end

@interface MeariDeviceList : MeariBaseModel
/** ipc */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;
/** doorbell */
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** voicebell */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** batteryipc */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** floot camera */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** nvr */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;

@end
