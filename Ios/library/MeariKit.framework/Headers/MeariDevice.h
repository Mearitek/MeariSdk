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
typedef NS_ENUM(NSInteger, MeariDevicePtzDirection) {
    MeariDevicePtzDirectionNone = 0,      //not support
    MeariDevicePtzDirectionAll = 1,       //left/right/up/down
    MeariDevicePtzDirectionUpDown = 2,    //up/down
    MeariDevicePtzDirectionLeftRight = 3  //left/right
};

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
/** chime*/
/** 中继铃铛 */
@property (nonatomic, assign, readonly, getter = isChime) BOOL chime;
/** voiceBell*/
/** 语言门铃 */
@property (nonatomic, assign, readonly, getter = isVoiceBell) BOOL voiceBell;
/** FloodCamera*/
/** 灯具摄像机*/
@property (nonatomic, assign, readonly, getter = isFloodCamera) BOOL FloodCamera;
/** nvr network storage*/
/** 是否是网络存储器（NVR）*/
@property (nonatomic, assign, readonly, getter = isNvr) BOOL nvr;
/** Whether the device is bound to the NVR*/
/** 是否绑定了网络存储器*/
@property (nonatomic, assign) BOOL hasBindedNvr;
/** Whether the device is support iot*/
/** 是否iOT设备*/
@property (nonatomic, assign) BOOL iotDevice;

@property (nonatomic, assign,readonly) BOOL supportAwsIot;
@property (nonatomic, assign,readonly) BOOL supportMeariIot;

#pragma mark -- 状态
/** Whether the device has established a network connection*/
/** 是否已经建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogined;
/** Whether the MeariIot device has established a network connection*/
/** meariIot是否已经建立连接*/
@property (nonatomic, assign, readonly) BOOL meariIotLogined;
/** Whether the device is establishing a network connection*/
/** 是否正在建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogining;
/** Whether the device is being previewed*/
/** 是否正在准备预览*/
@property (nonatomic, assign, readonly) BOOL sdkPreparePlay;
/** Whether the device is playing*/
/** 是否正在预览*/
@property (nonatomic, assign, readonly) BOOL sdkPlaying;
/** Whether the device is speaking*/
/** 是否正在预览*/
@property (nonatomic, assign, readonly) BOOL sdkSpeaking;
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
/** 设备回放/云回放/报警图片视频比例 默认去bsp2的1字段*/
/** Get the stream type of device*/
- (CGFloat)defalutVideoRatio;
/** 获取支持的视频比例 supportNewVideoStream 为YES 才启用*/
- (CGFloat)videoRatioForVideoStream:(MeariDeviceVideoStream)stream;
/** Get Supported SDK record type */
/** 获取支持的SDK录像类型*/
- (NSArray *)supportSdRecordLevels;
/** Get Supported SDK alarm frequency interval*/
/** 获取支持的SDK报警间隔类型*/
- (NSArray *)supportAlarmFrequencyIntervalLevels;
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
/** Whether to support Wireless */
/** 是否支持无线信号开关，用于开关无线铃铛 */
@property (nonatomic, assign, readonly) BOOL supportWirelessSwitchEnable;
/** Whether to support Wireless */
/** 是否支持无线信号配对，用于控制配对铃铛 */
@property (nonatomic, assign, readonly) BOOL supportWirelessPairEnable;
/** Whether to support Wireless */
/** 是否支持无线信号音量，用于控制无线铃铛音量 */
@property (nonatomic, assign, readonly) BOOL supportWirelessVolumeEnable;
/** Whether to support Wireless */
/** 是否支持无线信号歌曲，用于控制无线铃铛歌曲选择 */
@property (nonatomic, assign, readonly) BOOL supportWirelessSongsEnable;

/** Whether to support local server */
/** 是否支持ONVIF */
@property (nonatomic, assign, readonly) BOOL supportOnvif;
/** Whether to support local server */
/** 是否支持新版本ONVIF */
@property (nonatomic, assign, readonly) BOOL supportNewOnvif;
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
/** 是否为支持白天人形检测 */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetectDay;
/** 是否为支持夜间人形检测 */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetectNight;
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
/** Whether to support record off*/
/** 是否为支持录像关闭 */
@property (nonatomic, assign, readonly) BOOL supportRecordClose;
/** 是否为支持音量调节 */
@property (nonatomic, assign, readonly) BOOL supportSpeakVolume;
/** 是否为支持报警间隔 */
@property (nonatomic, assign, readonly) BOOL supportAlarmInterval;
/** 是否为支持roi区域报警 */
@property (nonatomic, assign, readonly) BOOL supportAlarmRoi;
/** 是否为支持人脸识别 */
@property (nonatomic, assign, readonly) BOOL supportFaceRecognition;
/** 是否为支持roi区域报警 */
@property (nonatomic, assign, readonly) BOOL supportVoiceLightAlarm;
/** 视频显示的类型 */
@property (nonatomic, assign, readonly) MeariDeviceVideoType displayVideoType;
/** 灯具摄像机类型 */
@property (nonatomic, assign, readonly) MeariDeviceFloodCameraType floodCameraType;
/** 是否支持时间风格设置 */
@property (nonatomic, assign, readonly) BOOL supportTimeShowSetting;
/** 是否支持babymonitor音乐播放 */
@property (nonatomic, assign, readonly) BOOL supportPlayMusic;
/** 是否支持babymonitor温湿度检测 */
@property (nonatomic, assign, readonly) BOOL supportDetectTemperatureHumidity;
/** 是否支持 报警计划跨天 */
@property (nonatomic, assign, readonly) BOOL supportAlarmPlanCrossDays;
/** pir等级设置，用于多级设置开关1-N档 返回最大支持等级， 0不支持*/
@property (nonatomic, assign, readonly) NSInteger supportPirLevel;
/** 是否支持视频预览出图 (语音门铃使用) */
@property (nonatomic, assign, readonly) BOOL supportPreviewImage;
/** 是否防拆报警 */
@property (nonatomic, assign, readonly) BOOL supportTamperAlarmSetting;
/** 支持的云台方向 */
@property (nonatomic, assign, readonly) MeariDevicePtzDirection ptzDirection;
/** 支持新版本的码率 */
@property (nonatomic, assign, readonly) BOOL supportNewVideoStream;
/** 是否支持pir显示 */
@property (nonatomic, assign, readonly) BOOL supportPir;
/** 是否支持灯具摄像机的联动亮灯*/
@property (nonatomic, assign, readonly) BOOL supportLinkLight;
/** 是否噪声异常巡查功能*/
@property (nonatomic, assign, readonly) BOOL supportDbPatrol;
/** baby是否支持上传用户预览信息功能*/
@property (nonatomic, assign, readonly) BOOL supportUploadAccountInfo;
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
/** chime */
/** 中继铃铛 */
@property (nonatomic, strong) NSArray <MeariDevice *> *chimes;

@end
