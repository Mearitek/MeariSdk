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
/** 自身的信息*/
@property (nonatomic, strong) MeariDeviceInfo *info;
/** 控制功能的参数信息*/
@property (nonatomic, strong) MeariDeviceParam *param;
/** 是否是普通摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcCommon) BOOL ipcCommon;
/** 是否是音乐摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcBaby) BOOL ipcBaby;
/** 是否是门铃摄像机*/
@property (nonatomic, assign, readonly, getter = isIpcBell) BOOL ipcBell;
/** 是否是网络存储器（NVR）*/
@property (nonatomic, assign, readonly, getter = isNvr) BOOL nvr;
/** 是否绑定了网络存储器*/
@property (nonatomic, assign) BOOL hasBindedNvr;

#pragma mark -- 状态
/** 是否已经建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogined;
/** 是否正在建立连接*/
@property (nonatomic, assign, readonly) BOOL sdkLogining;
/** 是否正在准备预览*/
@property (nonatomic, assign, readonly) BOOL sdkPreparePlay;
/** 是否正在预览*/
@property (nonatomic, assign, readonly) BOOL sdkPlaying;
/** 是否正在回放*/
@property (nonatomic, assign, readonly) BOOL sdkPlayRecord;
/** 当前回放时间*/
@property (nonatomic, strong) NSDateComponents *playbackTime;
/** 用于nvr回放*/
- (instancetype)nvrCamera;

#pragma mark -- 支持的功能
/** 获取高清码流：720/1080*/
- (MeariDeviceVideoStream)videoStreamHD;
/** 获取标清码流：240/360*/
- (MeariDeviceVideoStream)videoStreamSD;
/** 获取支持的码流类型*/
- (NSArray *)supportVideoStreams;
/** 是否支持双向语音对讲 */
@property (nonatomic, assign, readonly) BOOL supportFullDuplex;
/** 是否支持单向语音对讲 */
@property (nonatomic, assign, readonly) BOOL supportVoiceTalk;
/** 是否有麦克 */
@property (nonatomic, assign, readonly) BOOL supportMute;
/** 码流是否支持高清标清 */
@property (nonatomic, assign, readonly) BOOL supportVideoHDSD;
/** 码流是否只支持高清 */
@property (nonatomic, assign, readonly) BOOL supportVideoOnlyHD;
/** 是否支持主人录制留言 */
@property (nonatomic, assign, readonly) BOOL supportHostMessage;
/** 是否支持功耗管理 */
@property (nonatomic, assign, readonly) BOOL supportPowerManagement;
/** 是否支持SD卡 */
@property (nonatomic, assign, readonly) BOOL supportSDCard;
/** 是否支持机械铃铛 */
@property (nonatomic, assign, readonly) BOOL supportMachineryBell;
/** 是否支持无线铃铛 */
@property (nonatomic, assign, readonly) BOOL supportWirelessBell;
/** 是否支持无线信号开关，用于控制无线铃铛 */
@property (nonatomic, assign, readonly) BOOL supportWirelessEnable;
/** 是否支持ONVIF */
@property (nonatomic, assign, readonly) BOOL supportOnvif;
/** 是否支持镜头翻转 */
@property (nonatomic, assign, readonly) BOOL supportFlip;
/** 是否支持OTA升级固件版本 */
@property (nonatomic, assign, readonly) BOOL supportOTA;
/** 是否支持设置人体侦测等级 */
@property (nonatomic, assign, readonly) MeariDevicePirSensitivity supportPirSensitivity;
/** 是否支持设置休眠模式 */
@property (nonatomic, assign, readonly) BOOL supportSleepMode;
/** 是否为低功耗设备 */
@property (nonatomic, assign, readonly) BOOL lowPowerDevice;
/** 是否为支持切换主码流 */
@property (nonatomic, assign, readonly) BOOL supportVideoEnc;
/** 是否为支持人形检测 */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetect;
/** 是否为支持人形边框 */
@property (nonatomic, assign, readonly) BOOL supportPeopleTrackBorder;

@end

@interface MeariDeviceList : MeariBaseModel
/** 摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;       
/** 智能门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** 语音门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** 电池摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** 灯具摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** 网络存储器 */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;

@end
