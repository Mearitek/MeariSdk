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
#pragma mark - 信息
/** device info*/
/** 自身的信息*/
@property (nonatomic, strong) MeariDeviceInfo *info;
/** device params*/
/** 控制功能的参数信息*/
@property (nonatomic, strong) MeariDeviceParam *param;
/** normal device*/
/** 是否是普通摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcCommon) BOOL ipcCommon;
/** music device*/
/** 是否是音乐摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcBaby) BOOL ipcBaby;
/** doorbell*/
/** 是否是门铃摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcBell) BOOL ipcBell;
/** nvr network storage*/
/** 是否是网络存储器（NVR）*/
@property (nonatomic, assign, readonly, getter = isNvr) BOOL nvr;
/** voiceBell*/
/** 语言门铃 */
@property (nonatomic, assign, readonly, getter = isVoiceBell) BOOL voiceBell;

/** Whether the device is bound to the NVR*/
/** 是否绑定了网络存储器*/
@property (nonatomic, assign) BOOL hasBindedNvr;
/** Whether the device is support iot*/
/** 是否iOT设备*/
@property (nonatomic, assign) BOOL iotDevice;
#pragma mark -- 状态
/** Whether the device has established a network connection*/
/** 是否已经建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogined;
/** Whether the device is establishing a network connection*/
/** 是否正在建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogining;
/** Whether the device is being previewed*/
/** 是否正在准备预览*/
@property (nonatomic, assign, readonly) BOOL sdkPreparePlay;
/** Whether the device is prepare previewed*/
/** 是否正在预览*/
@property (nonatomic, assign, readonly) BOOL sdkPlaying;
/** Whether the device is being playbacked*/
/** 是否正在回放*/
@property (nonatomic, assign, readonly) BOOL sdkPlayRecord;
/** The time currently being played back*/
/** 当前回放时间*/
@property (nonatomic, strong) NSDateComponents *playbackTime;
/** nvr's camera*/
/** 用于nvr回放*/
- (instancetype)nvrCamera;

#pragma mark -- 支持的功能
/** videoStream 720/1080*/
/** 获取高清码流：720/1080*/
- (MeariDeviceVideoStream)videoStreamHD;
/** videoStream 240/360*/
/** 获取标清码流：240/360*/
- (MeariDeviceVideoStream)videoStreamSD;
/** Get the stream type of device*/
/** 获取支持的码流类型*/
- (NSArray *)supportVideoStreams;
/** Get Supported SDK record type */
/** 获取支持的SDK录像类型*/
- (NSArray *)supportSdRecordLevels;
/** Whether to support two-way voice intercom */
/** 是否支持双向语音对讲 */
@property (nonatomic, assign, readonly) BOOL supportFullDuplex;
/** Whether to support voice intercom */
/** 是否支持单向语音对讲 */
@property (nonatomic, assign, readonly) BOOL supportVoiceTalk;
/** Whether to support mute */
/** 是否有麦克 */
@property (nonatomic, assign, readonly) BOOL supportMute;
/** Whether to support HD SD */
/** 码流是否支持高清标清 */
@property (nonatomic, assign, readonly) BOOL supportVideoHDSD;
/** Only support HD */
/** 码流是否只支持高清 */
@property (nonatomic, assign, readonly) BOOL supportVideoOnlyHD;
/** Whether to support host Message */
/** 是否支持主人录制留言 */
@property (nonatomic, assign, readonly) MeariDeviceSupportHostType supportHostMessage;
/** Whether to support power management */
/** 是否支持功耗管理 */
@property (nonatomic, assign, readonly) BOOL supportPowerManagement;
/** Whether to support SDCard playback */
/** 是否支持SD卡 */
@property (nonatomic, assign, readonly) BOOL supportSDCard;
/** Whether to support Machinery Bell */
/** 是否支持机械铃铛 */
@property (nonatomic, assign, readonly) BOOL supportMachineryBell;
/** Whether to support Wireless Bell */
/** 是否支持无线铃铛 */
@property (nonatomic, assign, readonly) BOOL supportWirelessBell;
/** Whether to support Wireless */
/** 是否支持无线信号开关，用于控制无线铃铛 */
@property (nonatomic, assign, readonly) BOOL supportWirelessEnable;
/** Whether to support local server */
/** 是否支持ONVIF */
@property (nonatomic, assign, readonly) BOOL supportOnvif;
/** Whether to support image flip */
/** 是否支持镜头翻转 */
@property (nonatomic, assign, readonly) BOOL supportFlip;
/** Whether to support upgrade device */
/** 是否支持OTA升级固件版本 */
@property (nonatomic, assign, readonly) BOOL supportOTA;
/** Whether to support set body detection sensitivity */
/** 是否支持设置人体侦测等级 */
@property (nonatomic, assign, readonly) MeariDevicePirSensitivity supportPirSensitivity;
/** Whether to support setting sleep mode */
/** 是否支持设置休眠模式 */
@property (nonatomic, assign, readonly) BOOL supportSleepMode;
/** Is it a low power device */
/** 是否为低功耗设备 */
@property (nonatomic, assign, readonly) BOOL lowPowerDevice;
/** Whether to support switching the main stream */
/** 是否为支持切换主码流 */
@property (nonatomic, assign, readonly) BOOL supportVideoEnc;
/** Whether to support Humanoid detection */
/** 是否为支持人形检测 */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetect;
/** Whether to support Human border*/
/** 是否为支持人形边框 */
@property (nonatomic, assign, readonly) BOOL supportPeopleTrackBorder;
/** Whether to support the alarm plan*/
/** 是否为支持报警计划 */
@property (nonatomic, assign, readonly) BOOL supportAlarmPlan;
/** Whether to support the iot protocol*/
/** 是否为支持iot协议 */
@property (nonatomic, assign, readonly) BOOL supportIotProtocol;
/** Whether to support brightness adjustment*/
/** 是否为支持亮度调节 */
@property (nonatomic, assign, readonly) BOOL supportLightAdjust;
/** Whether to support chromecast*/
/** 是否为支持chromecast */
@property (nonatomic, assign, readonly) BOOL supportChromecast;
/** Whether to support echoshow*/
/** 是否为支持echoshow */
@property (nonatomic, assign, readonly) BOOL supportEchoshow;

@end

@interface MeariDeviceList : MeariBaseModel
/** ipc */
/** 摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;
/** doorbell */
/** 智能门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** voicebell */
/** 语音门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** batteryipc */
/** 电池摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** floot camera */
/** 灯具摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** nvr */
/** 网络存储器 */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;

@end
