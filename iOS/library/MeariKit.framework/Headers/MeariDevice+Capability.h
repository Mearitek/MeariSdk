//
//  MeariDevice+Capability.h
//  MeariKit
//
//  Created by duan on 2023/11/28.
//  Copyright © 2023 Meari. All rights reserved.
//

#import <MeariKit/MeariKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariDevice (Capability)
#pragma mark - Preview
/** Whether to support voice intercom */
/** 是否支持单向语音对讲 */
@property (nonatomic, assign, readonly) BOOL supportVoiceTalk;
/** Whether to support two-way voice intercom */
/** 是否支持双向语音对讲 */
@property (nonatomic, assign, readonly) BOOL supportFullDuplex;
/** Whether to support mute */
/** 是否支持静音 */
@property (nonatomic, assign, readonly) BOOL supportMute;
/** Whether to support HD SD */
/** 码流是否支持高清标清 */
@property (nonatomic, assign, readonly) BOOL supportVideoHDSD;
/** Only support HD */
/** 码流是否只支持高清 */
@property (nonatomic, assign, readonly) BOOL supportVideoOnlyHD;

#pragma mark - PTZ
/** Whether to support PTZ*/
/** 是否支持PTZ*/
@property (nonatomic, assign, readonly) BOOL supportPTZ;
/** Whether to support PTZ calibration*/
/** 是否支持云台校准*/
@property (nonatomic, assign, readonly) BOOL supportPTZCorrection;
/** Whether to support PTZ patrol*/
/** 是否支持PTZ巡逻*/
@property (nonatomic, assign, readonly) BOOL supportPtzPatrol;
/** Whether to support PTZ preset points*/
/** 是否支持PTZ预置点*/
@property (nonatomic, assign, readonly) BOOL supportPtzPoint;

#pragma mark - Playback
/** Whether to support downloading local playback videos*/
/** 是否支持下载本地回放视频*/
@property (nonatomic, assign, readonly) BOOL supportVideoDownload;
/** Whether to support deleting local playback videos*/
/** 是否支持删除本地回放视频*/
@property (nonatomic, assign, readonly) BOOL supportVideoDelete;

#pragma mark - Setting
/** Whether to support LED setting */
/** 是否支持指示灯设置 */
@property (nonatomic, assign, readonly) BOOL supportLED;

#pragma mark - Graphics
/** Whether to support image flip */
/** 是否支持镜头翻转 */
@property (nonatomic, assign, readonly) BOOL supportFlip;
/** Whether to support anti-flicker*/
/** 是否支持抗闪烁*/
@property (nonatomic, assign, readonly) BOOL supportFlicker;
#pragma mark - Alarm
/** Whether to support the alarm master switch */
/**是否支持报警总开关*/
@property (nonatomic, assign, readonly) BOOL supportAlarmWhole;
#pragma mark - Motion
/** Whether to support motion detection */
/** 是否支持移动侦测*/
@property (nonatomic, assign, readonly) BOOL supportMotion;
/** Whether to support pir detection */
/** 是否支持pir侦测 */
@property (nonatomic, assign, readonly) BOOL supportPir;
/** Whether to support motion detection working mode (power saving mode + performance mode) */
/** 是否支持 移动侦测工作模式（省电模式+性能模式）*/
@property (nonatomic, assign, readonly) BOOL supportMotionMode;
/** Whether to support continuous recording mode*/
/** 是否支持持续录像模式*/
@property (nonatomic, assign, readonly) BOOL supportCommonMode;
/** Whether to support alarm interval */
/** 是否支持报警间隔 */
@property (nonatomic, assign, readonly) BOOL supportAlarmInterval;
/** Whether to support the alarm plan*/
/** 是否支持报警计划 */
@property (nonatomic, assign, readonly) BOOL supportAlarmPlan;
/** Whether to support alarm plan across days */
/** 是否支持报警计划跨天 */
@property (nonatomic, assign, readonly) BOOL supportAlarmPlanCrossDays;
/** Whether to support setting alarm area */
/** 是否支持设置报警区域 */
@property (nonatomic, assign, readonly) BOOL supportAlarmRoi;
/** Whether to support setting polygonal alarm area*/
/** 是否支持设置多边形报警区域*/
@property (nonatomic, assign, readonly) BOOL supportPolygonRoiAlarm;

#pragma mark --People Detection
///人形检测依赖于移动侦测开启
/** Whether to support Humanoid detection */
/** 是否支持人形检测 */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetect;
/** Whether to support daytime humanoid detection */
/** 是否支持白天人形检测 */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetectDay;
/** Whether to support humanoid detection at night */
/** 是否支持夜间人形检测 */
@property (nonatomic, assign, readonly) BOOL supportPeopleDetectNight;
/** Humanoid detection sensitivity setting, used for multi-level setting switch 1-N level to return to the maximum supported level, 0 is not supported*/
/** 人形检测灵敏度设置，用于多级设置开关1-N档 返回最大支持等级， 0不支持*/
@property (nonatomic, assign, readonly) NSInteger supportHumanLevel;
/** Whether to support humanoid detection frame */
/** 是否支持人形检测画框 */
@property (nonatomic, assign, readonly) BOOL supportPeopleTrackBorder;
#pragma mark --VoiceLight Alarm
///低功耗设备声光报警依赖于移动侦测开启
/** 是否支持声光报警 */
@property (nonatomic, assign, readonly) BOOL supportVoiceLightAlarm;
/** 是否支持声光报警时间段 */
@property (nonatomic, assign, readonly) BOOL supportVoiceLightAlarmPlan;
/** 是否支持声光报警铃声 */
@property (nonatomic, assign, readonly) BOOL supportVoiceLightAlarmRing;

#pragma mark - Cry Detection

/** Whether to support cry detection */
/** 是否支持哭声侦测*/
@property (nonatomic, assign, readonly) BOOL supportCryDetect;

#pragma mark - Noise Detection

/** Whether to support noise detection*/
/** 是否支持噪声侦测*/
@property (nonatomic, assign, readonly) BOOL supportNoiseDetect;
/** Whether to support the noise anomaly patrol function*/
/** 是否支持噪声异常巡查功能*/
@property (nonatomic, assign, readonly) BOOL supportDbPatrol;
/** Whether the noise alarm supports recording*/
/** 噪音报警是否支持录像*/
@property (nonatomic, assign, readonly) BOOL supportNoiseRecord;

#pragma mark - Tamper Alarm

/** Whether to support anti-tamper alarm */
/** 是否支持防拆报警 */
@property (nonatomic, assign, readonly) BOOL supportTamperAlarmSetting;

#pragma mark - Temperature and humidity alarm
/** Whether to support temperature and humidity alarm */
/** 是否支持温湿度报警  */
@property (nonatomic, assign, readonly) BOOL supportHumitureAlarm;
/** Whether to support setting temperature threshold */
/** 是否支持设置温度阈值  */
@property (nonatomic, assign, readonly) BOOL supportTemperatureSetting;
/** Whether to support setting the humidity threshold */
/** 是否支持设置湿度阈值  */
@property (nonatomic, assign, readonly) BOOL supportHumiditySetting;

#pragma mark - Assist

/** Whether to support chromecast*/
/** 是否支持chromecast */
@property (nonatomic, assign, readonly) BOOL supportChromecast;
/** Whether to support echoshow*/
/** 是否支持echoshow */
@property (nonatomic, assign, readonly) BOOL supportEchoshow;
/** Whether to support HomeKit*/
/** 是否支持HomeKit*/
@property (nonatomic, assign, readonly) BOOL supportHomeKit;

#pragma mark - Power
/** Whether to support power management */
/** 是否支持功耗管理 */
@property (nonatomic, assign, readonly) BOOL supportPowerManagement;
/** Whether the IPC device supports power display and charging status display*/
/** IPC设备是否支持电量显示及充电状态显示*/
@property (nonatomic, assign, readonly) BOOL supportShowIpcBattery;
/** Whether the normally powered device supports low power consumption mode*/
/** 常电设备是否支持低功耗模式*/
@property (nonatomic, assign, readonly) BOOL supportIpcLowpowerMode;
/** Whether to support real-time information statistics, including signal strength, battery power, etc. */
/** 是否支持实时信息统计 包括信号强度、电池电量等*/
@property (nonatomic, assign, readonly) BOOL supportRealTimeStatistics;
/** Whether to support daily/monthly information statistics*/
/** 是否支持天/月信息统计*/
@property (nonatomic, assign, readonly) BOOL supportIntervalStatistics;
/** Whether to support false alarm detection count statistics*/
/** 是否支持误报检测次数统计*/
@property (nonatomic, assign, readonly) BOOL supportFalseAlarmStatistics;
#pragma mark - Record
/** Whether to support SDCard playback */
/** 是否支持SD卡 */
@property (nonatomic, assign, readonly) BOOL supportSDCard;
/** Whether to support record off*/
/** 是否支持录像关闭 */
@property (nonatomic, assign, readonly) BOOL supportRecordClose;
/** Whether to support video recording sound switch*/
/** 是否支持录像声音开关*/
@property (nonatomic, assign, readonly) BOOL supportRecordVoice;
/** Whether to support all-day recording*/
/** 是否支持全天录像*/
@property (nonatomic, assign, readonly) BOOL supportFullRecord;
/** Whether to support event recording*/
/** 是否支持事件录像*/
@property (nonatomic, assign, readonly) BOOL supportEventRecord;
#pragma mark - OTA升级
/** Whether to support upgrade device */
/** 是否支持OTA升级固件版本 */
@property (nonatomic, assign, readonly) BOOL supportOTA;
/** Whether to support automatic firmware update*/
/** 是否支持固件自动更新*/
@property (nonatomic, assign, readonly) BOOL supportAutoUpdate;
#pragma mark - Reboot
/** Whether to support reboot the device*/
/** 是否支持手动重启设备*/
@property (nonatomic, assign, readonly) BOOL supportReboot;

#pragma mark - Baby
/** 是否支持音乐播放 */
/** Whether to support music play */
@property (nonatomic, assign, readonly) BOOL supportPlayMusic;
/** 是否支持设置音乐播放模式 */
/** Whether to support setting music play mode */
@property (nonatomic, assign, readonly) BOOL supportPlayMusicMode;
/** 是否支持音乐播放限制时间 */
/** Whether to support music play limit time */
@property (nonatomic, assign, readonly) BOOL supportPlayMusicLimitTime;

/** 是否支持温湿度检测 */
@property (nonatomic, assign, readonly) BOOL supportDetectTemperatureHumidity;
/** 是否支持温度检测 */
@property (nonatomic, assign, readonly) BOOL supportDetectTemperature;
/** 是否支持湿度检测 */
@property (nonatomic, assign, readonly) BOOL supportDetectHumidity;
/** Whether to support the function of uploading user preview information*/
/** 是否支持上传用户预览信息功能*/
@property (nonatomic, assign, readonly) BOOL supportUploadAccountInfo;
/** Whether to support RGB light control function*/
/** 是否支持RGB灯控制功能*/
@property (nonatomic, assign, readonly) BOOL supportRGB;
#pragma mark - Bell
/** Whether to support host Message */
/** 是否支持主人录制留言 */
@property (nonatomic, assign, readonly) MeariDeviceSupportHostType supportHostMessage;
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

#pragma mark - Light
/** Whether to support switching warm light */
/** 是否支持开关暖光灯*/
@property (nonatomic, assign, readonly) BOOL supportOnOffWarmLight;
/** Whether to support switching non-warm light*/
/** 是否支持开关非暖光灯*/
@property (nonatomic, assign, readonly) BOOL supportOnOffUnWarmLight;
/** Whether to support brightness adjustment*/
/** 是否支持亮度调节 */
@property (nonatomic, assign, readonly) BOOL supportLightAdjust;
/** Whether to support the alarm linkage lighting of the lamp camera*/
/** 是否支持灯具摄像机的报警联动亮灯*/
@property (nonatomic, assign, readonly) BOOL supportLinkLight;
/** Whether to support lighting duration setting*/
/** 是否支持亮灯时长设置*/
@property (nonatomic, assign, readonly) BOOL supportLightDuration;
/** Whether to support the lighting plan*/
/** 是否支持亮灯计划*/
@property (nonatomic, assign, readonly) BOOL supportLightSchedule;

@end

NS_ASSUME_NONNULL_END
