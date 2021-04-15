//
//  MeariDeviceControl.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#ifndef MeariDeviceControl_h
#define MeariDeviceControl_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MeariDevice;
@class MeariPlayView;
@class MeariDeviceTime;
@class MeariDeviceHostMessage;
@class MeariChimeRingInfo;
typedef void(^MeariDeviceFailure)(NSError *error);
typedef void(^MeariDeviceFailure_Str)(NSString *error);
typedef void(^MeariDeviceSuccess)(void);
typedef void(^MeariDeviceDisconnect)(void);
typedef void(^MeariDeviceSuccess_Online)(BOOL online);
typedef void(^MeariDeviceSuccess_SearchDevice)(MeariDevice *device);
typedef void(^MeariDeviceSuccess_ID)(id obj);
typedef void(^MeariDeviceSuccess_Str)(NSString *str);
typedef void(^MeariDeviceSuccess_Dict)(NSString *dict);
typedef void(^MeariDeviceSuccess_Result)(NSString *jsonString);
typedef void(^MeariDeviceSuccess_PlaybackTimes)(NSArray *times);
typedef void(^MeariDeviceSuccess_PlaybackDays)(NSArray *days);
typedef void(^MeariDeviceSuccess_HostMessages)(NSArray *customArray);
typedef void(^MeariDeviceSuccess_MusicStateCurrent)(NSDictionary *currentMusicState);
typedef void(^MeariDeviceSuccess_MusicStateAll)(NSDictionary *allMusicState);
typedef void(^MeariDeviceSuccess_Mirror)(BOOL mirror);
typedef void(^MeariDeviceSuccess_LED)(BOOL on);
typedef void(^MeariDeviceSuccess_Motion)(MeariDeviceParamMotion *motion);
typedef void(^MeariDeviceSuccess_Storage)(MeariDeviceParamStorage *storage);
typedef void(^MeariDeviceSuccess_StoragePercent)(NSInteger percent);
typedef void(^MeariDeviceSuccess_UpgradeMode)(MeariDeviceOtaUpgradeMode otaUpgradeMode);
typedef void(^MeariDeviceSuccess_Version)(NSString *version);
typedef void(^MeariDeviceSuccess_VersionPercent)(NSInteger totalPercent, NSInteger downloadPercent, NSInteger updatePercent);
typedef void(^MeariDeviceSuccess_LightState)(BOOL on);
typedef void(^MeariDeviceSuccess_SirenTimeout)(NSInteger second);
typedef void(^MeariDeviceSuccess_Param)(MeariDeviceParam *param);
typedef void(^MeariDeviceSuccess_TRH)(CGFloat temperature, CGFloat humidity);
typedef void(^MeariDeviceSuccess_Volume)(CGFloat volume);
typedef void(^MeariDeviceSuccess_RecordAutio)(NSString *filePath);
typedef void(^MeariDeviceSuccess_NetInfo)(MeariDeviceParamNetwork *info);
typedef void(^MeariDeviceSuccess_ChimeSubDeviceList) (NSArray <MeariDevice *> *deviceList);
typedef void(^MeariDeviceSuccess_ChimeRingList) (NSArray <MeariChimeRingInfo *> *chimeRingInfoList);
typedef void(^MeariDeviceSuccess_PlayBackLevel)(MeariDeviceRecordDuration level);
typedef void(^MeariDeviceSuccess_Dictionary)(NSDictionary *dic);
typedef void(^MeariDeviceSuccess_DetectFace)(int quality);

/**
 search mode for searching device

 - MeariSearchModeLan: only search in lan
 - MeariSearchModeCloud_Smartwifi: only search in cloud for smartwifi
 - MeariSearchModeCloud_AP: only search in cloud for ap
 - MeariSearchModeCloud_QRCode: only search in cloud for qrcode
 - MeariSearchModeCloud: only search in cloud for smartwifi, ap , and qrcode
 - MeariSearchModeAll: all above
 */
typedef NS_OPTIONS(NSInteger, MeariDeviceSearchMode) {
    MeariSearchModeLan = 1 << 0,
    MeariSearchModeCloud_Smartwifi = 1 << 1,
    MeariSearchModeCloud_AP = 1 << 2,
    MeariSearchModeCloud_QRCode = 1 << 3,
    MeariSearchModeCloud = (MeariSearchModeCloud_Smartwifi | MeariSearchModeCloud_AP | MeariSearchModeCloud_QRCode),
    MeariSearchModeAll = (MeariSearchModeLan | MeariSearchModeCloud),
};

typedef NS_ENUM(NSInteger, MeariVoiceTalkType) {
    MeariVoiceTalkTypeOneWay,
    MeariVoiceTalkTypeFullDuplex,
};

typedef NS_ENUM(NSInteger, MeariMoveDirection) {
    MeariMoveDirectionUp,
    MeariMoveDirectionDown,
    MeariMoveDirectionLeft,
    MeariMoveDirectionRight,
};
typedef NS_ENUM (NSInteger, MeariDeviceVideoStream) {
    MeariDeviceVideoStream_HD = 0,
    MeariDeviceVideoStream_360 = 1,
    MeariDeviceVideoStream_240 = 2,
    MeariDeviceVideoStream_480 = 3,
    MeariDeviceVideoStream_720 = 4,
    MeariDeviceVideoStream_1080 = 5,
    MeariDeviceVideoStream_1080_1_5 = 6,
    MeariDeviceVideoStream_1080_2_0 = 7,
    MeariDeviceVideoStream_3MP_1_2 = 8,
    MeariDeviceVideoStream_3MP_2_4 = 9,
    MeariDeviceVideoStream_NEW_SD = 100,
    MeariDeviceVideoStream_NEW_HD = 101,
    MeariDeviceVideoStream_NEW_FHD = 102,
    MeariDeviceVideoStream_NEW_UHD = 103,
    MeariDeviceVideoStreamNone = 999,
};
typedef NS_ENUM (NSInteger, MeariDeviceVideoRatio) {
    MeariDeviceVideoRatio16_9,
    MeariDeviceVideoRatio4_3,
    MeariDeviceVideoRatio1_1,
};
typedef NS_ENUM (NSInteger, MeariDeviceConnectType) {
    MeariDeviceConnectTypeNone = -1,
    MeariDeviceConnectTypeP2p,
    MeariDeviceConnectTypeRelay,
    MeariDeviceConnectTypeLan,
};
typedef NS_OPTIONS(NSInteger, MeariDeviceChimeAlert) {
    MeariDeviceChimeAlertNone = 0,
    MeariDeviceChimeAlertRing = 1 << 0,
    MeariDeviceChimeAlertMotion = 1 <<1,
    MeariDeviceChimeAlertAll = (MeariDeviceChimeAlertRing | MeariDeviceChimeAlertMotion),
};
typedef NS_ENUM(NSInteger, MeariDeviceSoundChangeType) {
    MeariDeviceSoundChangeTypeBoy,
    MeariDeviceSoundChangeTypeGirl,
    MeariDeviceSoundChangeTypeMan,
};
typedef NS_ENUM(NSInteger, MeariDeviceTimeShowType) {
    MeariDeviceTimeShowType24 = 0,
    MeariDeviceTimeShowType12,
};

typedef void(^MeariDeviceSuccess_ChimeAlertType)(MeariDeviceChimeAlert chimeAlertType);

@protocol MeariDeviceControl <NSObject>

#pragma mark - SDK

/**
 Reset internal resources
 重置内部资源
 */
- (void)reset;
/**
 Get punch type
 获取打洞类型
 */
- (MeariDeviceConnectType)getP2pMode;

#pragma mark -- 查询在线

/**
 Get online status
 获取在线状态

 @param completion Online (是否在线)
 */
- (void)getOnlineStatus:(MeariDeviceSuccess_Online)completion;

#pragma mark -- 搜索 & 配网

/**
 Start search: for smartwifi distribution network and ap distribution network
 开始搜索：适用于smartwifi配网和ap配网
 
 @param success Successful callback (成功回调)：返回搜索到的设备
 @param failure failure callback (失败回调)
 */
+ (void)startSearchSuccess:(MeariDeviceSuccess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 Start search: only for QR code network(开始搜索：仅适用于二维码配网)
 
 @param token QR code token(二维码token)
 @param success Successful callback (成功回调)：返回搜索到的设备
 @param failure failure callback (失败回调)
 */
+ (void)startSearchWithQRcodeToken:(NSString *)token success:(MeariDeviceSuccess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 Update Token
 更新Token
 
 @param token 配网方式的token
 @param type  配网方式
 */
+ (void)updatetoken:(NSString *)token type:(MeariDeviceTokenType)type ;

/**
 Start Search: Search for Universal Interface
 Make sure to call the updatetoken method when using this interface
 
 开始搜索：搜索通用接口
 在使用此接口时要确保调用了updatetoken方法
 @param mode 配网方式
 @param success Successful callback (成功回调)：返回搜索到的设备
 @param failure failure callback (失败回调)
 */
+ (void)startSearchWithMode:(MeariDeviceSearchMode)mode success:(MeariDeviceSuccess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 Stop search
 停止搜索
 */
+ (void)stopSearch;


/**
 Start smartwifi distribution network(开始 smartwifi 配网)
 
 @param wifiSSID wifi name(wifi名称)
 @param wifiPwd wifi password: no password, pass nil(wifi密码：没有密码，传nil)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
+ (void)startMonitorWithWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd token:(NSString *)token success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure ;


/**
 Stop smartwifi distribution network
 停止 smartwifi 配网
 */
+ (void)stopMonitor;


/**
 Start ap distribution network(开始 ap 配网)
 
 @param wifiSSID wifi name(wifi名称)
 @param wifiPwd wifi password(wifi密码)
 @param relayDevice relay Device(是否为中继设备)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
+ (void)startAPConfigureWithWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd relay:(BOOL)relayDevice success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Custom Setting
- (void)setDeviceWithParams:(NSDictionary *)params success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- 打洞

/**
 Start connecting devices(开始连接设备)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startConnectSuccess:(MeariDeviceSuccess)success abnormalDisconnect:(MeariDeviceDisconnect)disconnect failure:(MeariDeviceFailure)failure;

/**
 Disconnect device(断开设备)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)stopConnectSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 获取参数：（码率、模式、静音）

/**
 Get bit rate (获取码率)

 @return Bit rate (码率)
 */
- (NSString *)getBitrates;

#pragma mark -- 预览

/**
 Start previewing the device(开始预览设备)
 
 @param playView play view control(播放视图控件)
 @param HD Whether to play HD(是否高清播放)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 @param close is in sleep mode, the lens is off, return value: sleep mode(close 处于休眠模式，镜头关闭，返回值：休眠模式)
 */
- (void)startPreviewWithPlayView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepMode sleepModeType))close;

/**
 Start previewing the device(开始预览设备)
 
 @param playView play view control(播放视图控件)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 @param close is in sleep mode, the lens is off, return value: sleep mode(close 处于休眠模式，镜头关闭，返回值：休眠模式)
 */
- (void)startPreviewWithPlayView:(MeariPlayView *)playView videoStream: (MeariDeviceVideoStream)videoStream success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepMode sleepModeType))close;

/**
 stop preview
 停止预览设备
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)stopPreviewSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 change Video Resolution
 切换高清标清
 
 @param playView play view(播放视图)
 @param videoStream (video type)播放类型
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)changeVideoResolutionWithPlayView:(MeariPlayView *)playView videoStream:(MeariDeviceVideoStream)videoStream success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 回放

/**
 Get the number of video days in a month(获取某月的视频天数)
 
 @param month 月
 @param year 年
 @param success Successful callback (成功回调)，  return value: json array --[{"date" = "20171228"},...]       (返回值：json数组--[{"date" = "20171228"},...])
 @param failure failure callback (失败回调)
 */
- (void)getPlaybackVideoDaysInMonth:(NSInteger)month year:(NSInteger)year success:(MeariDeviceSuccess_PlaybackDays)success failure:(MeariDeviceFailure)failure;


/**
 Get a video clip of a day(获取某天的视频片段)
 
 @param year year(年)
 @param month month(月)
 @param day day(日)
 @param success Successful callback (成功回调)：返回值：json数组--[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
 @param failure failure callback (失败回调)
 */
- (void)getPlaybackVideoTimesInDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year success:(MeariDeviceSuccess_PlaybackTimes)success failure:(MeariDeviceFailure)failure;


/**
 Start playback of video: only one person can view playback video at the same time (开始回放录像：同一个设备同一时间只能一个人查看回放录像)
 
 @param playView play view(播放视图)
 @param startTime Start time: format is 20171228102035 (开始时间:格式为20171228102035)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startPlackbackSDCardWithPlayView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;



/**
 Stop playback(停止回放)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)stopPlackbackSDCardSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Play from a certain time: This interface can only be used after the playback is successful, otherwise it will fail.
 从某时间开始播放：开始回放成功后才能使用此接口，否则会失败
 
 @param seekTime Start time: format is 20171228102035 (开始时间:格式为20171228102035)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)seekPlackbackSDCardWithSeekTime:(NSString *)seekTime success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Continue playback(继续回放)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)pausePlackbackSDCardSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Continue playback(继续回放)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)resumePlackbackSDCardSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 云回放

/**
 Get cloud playback video files
 获取云回放录像文件

 @param startTime startTime(NSDateComponents *) 开始时间
 @param endTime endTime(NSDateComponents *) 结束时间
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getCloudVideoWithStartTime:(NSDateComponents *)startTime endTime:(NSDateComponents *)endTime success:(void(^)(NSURL *m3u8Url))success failure:(MeariDeviceFailure)failure;
/**
 Get the cloud play time of a day
 获取某天的云播放分钟
 
 @param dayComponents   time(NSDateComponents *),Used to get specific time 具体日期
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getCloudVideoMinutesWithDayComponents:(NSDateComponents *)dayComponents success:(void(^)(NSArray <MeariDeviceTime *> *mins))success failure:(MeariDeviceFailure)failure;

/**
 Get the cloud play time of a month
 获取某月的云播放天数
 
 @param monthComponents  obtain month(NSDateComponents *) 具体某月
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getCloudVideoDaysWithMonthComponents:(NSDateComponents *)monthComponents success:(void(^)(NSArray <MeariDeviceTime *> *days))success failure:(MeariDeviceFailure)failure;

#pragma mark -- 静音
/**
 Set mute(设置静音)
 
 @param muted muted is mute?(是否静音)
 */
- (void)setMute:(BOOL)muted;

/**
 Get mute(获取静音)
 
 @param muted muted is mute?(是否静音)
 */
- (BOOL)getMute;


#pragma mark -- 语音对讲

/**
 Get the real-time volume of the voice intercom(获取语音对讲的实时音量)
 
 @return 0-1.0
 */
- (CGFloat)getVoicetalkVolume;


/**
 Set the voice intercom type / 设置语音对讲类型
 
 @param type voice intercom type(语音对讲类型)
 */
- (void)setVoiceTalkType:(MeariVoiceTalkType)type;


/**
 return current voice talk type
 
 返回当前对讲类型
 */
- (MeariVoiceTalkType)getVoiceTalkType;

/**
 Start voice intercom(开始语音对讲)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startVoiceTalkWithIsVoiceBell:(BOOL)isVoiceBell success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Stop voice intercom / 停止语音对讲
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)stopVoicetalkSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Turn on two-way voice speakers
 开启双向语音扬声器

 @param enabled 是否开启
 */
- (void)enableLoudSpeaker:(BOOL)enabled;

#pragma mark -- 截图

/**
 Screenshot  (截图)
 
 @param savePath The path where the image is saved(图片保存的路径)
 @param isPreviewing is previewing(是否正在预览)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)snapshotWithSavePath:(NSString *)savePath isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 录像

/**
 Start recording(开始录像)
 
 @param path The path where the video is saved(录像保存的路径)
 @param isPreviewing is previewing(是否正在预览)
 @param Interrputed record Interrputed(录像中断)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startRecordMP4WithSavePath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSuccess)success abnormalDisconnect:(MeariDeviceSuccess)Interrputed failure:(MeariDeviceFailure)failure;


/**
 Stop recording(停止录像)
 
 @param isPreviewing is previewing(是否正在预览)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)stopRecordMP4WithIsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- 变声 (change sound)
/**
Start change sound(开始变声)

@param type MeariDeviceSoundChangeType voice type (变声类型)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)startSoundChangeWithType:(MeariDeviceSoundChangeType)type success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
Stop change sound(停止变声)

*/
- (void)stopSoundChange;

#pragma mark --- 录音(record sound)

/**
Start record sound(开始录音)

@param savePath 路径(save path)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)startRecordSoundWithSavePath:(NSString *)savePath success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/// 停止录音
- (void)stopRecordSound;

#pragma mark -- 云台

/**
 Start turning the camera (开始转动摄像机)
 
 @param direction direction(转动方向)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startPTZControlWithDirection:(MeariMoveDirection)direction success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Stop turning the camera (停止转动摄像机)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)stopPTZControlSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- LED

/**
  set LED (设置LED)
 
 @param on 是否打开LED
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setLEDOn:(BOOL)on success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 日夜模式

/**
 // Set day and night mode, the camera will have color or grayscale
 // 设置日夜模式, 摄像头会有彩色或灰度两种

 @param type  MeariDeviceDayNightType(日夜模式)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setDayNightModeType:(MeariDeviceDayNightType)type success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 噪声检测

/**
 // Noise detection, alarm when sound exceeds a certain decibel
 // 噪声检测, 当有声音超过一定分贝的时候报警
 
 @param level  MeariDeviceLevel (噪声等级)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setSoundDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 噪声巡回检查

 @param enable 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setSoundPatrolEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 网络信息

/**
  Get network information
  获取网络信息

 @param success  成功回调 返回值：当前网络信息MeariDeviceParamNetwork
 @param failure  失败回调
 */
- (void)getWifiStrengthSuccess:(MeariDeviceSuccess_NetInfo)success failure:(MeariDeviceFailure)failure;

#pragma mark---  #pragma mark --- 码流H264-H265

/**
 // Whether to enable h265 encoding
 // 开关h265编码
 
 @param h265 Whether to enable h265 encoding(是否开启h265编码)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setVideoEncodingWithH265:(BOOL)h265 success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 画面翻转

/**
 Get mirror status (设置镜像)
 
 @param open  whether to open mirror (是否打开镜像)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setMirrorOpen:(BOOL)open success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 回放设置
/**
 Set playback level
 设置回放等级
 
 @param level MeariDeviceRecordDuration  回放等级
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setPlaybackRecordVideoLevel:(MeariDeviceRecordDuration)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Onvif
/**
  Set Onvif  / 设置Onvif
 @param enable  Whether to open (是否开启)
 @param pwd    Connect onvif password(连接密码)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setOnvifEnable:(BOOL)enable password:(NSString *)pwd success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- 报警

/**
 Get alarm information (获取报警级别)
 
 @param level alarm level(报警级别)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setMotionDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 // Setting up an alarm plan
 // 设置报警计划
 
 @param times Array of MeariDeviceParamSleepTime (MeariDeviceParamSleepTime的数组)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setAlarmTimes:(NSArray<MeariDeviceParamSleepTime *> *)times success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 // Whether people detection  are on
 // 人形检测是否开启
 
 @param enable Whether people detection is on(人形检测是否开启)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setHumanDetectionEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 设置报警间隔级别
 
@param level 报警间隔级别
@param success 成功回调
@param failure 失败回调
*/
- (void)setAlarmInterval:(MeariDeviceCapabilityAFQ)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure ;
/**
 设置报警计划

 // Whether human borders  are on
 // 人形边框是否开启
 
 @param enable Whether the human border is on(人形边框是否开启)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setHumanFrameEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 人形检测

 @param enable 是否开启
 @param type  开启的类型  MeariDevicePeopleDetectEnable (old)人形检测开关设置 MeariDevicePeopleDetectDay  // 白天人形开关设置 MeariDevicePeopleDetectNight  // 夜间人形开关设置
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setHumanDetectionEnable:(BOOL)enable detectType:(MeariDevicePeopleDetect)type success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
人形检测  和人形画框 (IPC 设备)

@param detectEnable  人形检测是否开启
@param bnddrawEnable 人形画框是否开启
@param success 成功回调
@param failure 失败回调
*/
- (void)setHumanDetectionEnable:(BOOL)detectEnable humanFrameEnable:(BOOL)bnddrawEnable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure ;
/**
 哭声检测

 @param enable 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setCryDetectionEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 // Human tracking
 // 人形跟踪
 
 @param enable whether to open(是否开启)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setHumanTrackEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 Tamper alarm
 防拆报警

 @param enable whether to open( 是否开启)
 @param version 影子设备版本
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)antiStealWithEnable:(BOOL)enable version:(NSInteger)version success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 设置Roi功能
 
 @param enable 是否开启 设置enbale为NO时,width,height,bitmap参数不生效
 @param width  宽度   使用roi.width
 @param height  高度 使用 roi.height
 @param bitmap 选择区域数组 个数为 width * height  [0,1,0,1,1,0,1]
 @param success 成功回调
 @param failure 失败回调
*/
- (void)setAlarmRoiWithEnable:(BOOL)enable width:(NSInteger)width height:(NSInteger)height bitmap:(NSArray *)bitmap success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 存储
/**
 Get storage information(获取存储信息)
 
 @param success Successful callback (成功回调)，return storage information(返回存储信息)
 @param failure failure callback (失败回调)
 */
- (void)getSDCardInfoSuccess:(MeariDeviceSuccess_Storage)success failure:(MeariDeviceFailure)failure;


/**
 Get memory card formatting percentage(获取内存卡格式化百分比)
 
 @param success Successful callback (成功回调),return formatting percentage(返回格式化百分比)
 @param failure failure callback (失败回调)
 */
- (void)getSDCardFormatPercentSuccess:(MeariDeviceSuccess_StoragePercent)success failure:(MeariDeviceFailure)failure;

/**
 Format memory card(格式化内存卡)
 
 @param success Successful callback (成功回调)
 @param failure 失败回道
 */
- (void)startSDCardFormatSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- 固件版本

/**
 Get the firmware version(获取固件版本)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getFirmwareVersionSuccess:(MeariDeviceSuccess_Version)success failure:(MeariDeviceFailure)failure;

/**
 Get the device latest version(获取固件最新版本)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getDeviceLatestVersionSuccess:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;


/**
 Get firmware upgrade percentage(获取固件升级百分比)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getDeviceUpgradePercentSuccess:(MeariDeviceSuccess_VersionPercent)success failure:(MeariDeviceFailure)failure;


/**
 Gets whether the device is being upgraded
 获取设备是否正在升级

 @param success Successful callback MeariDeviceSuccess_UpgradeMode (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getWhetherDeviceOnUpgradeSuccess:(MeariDeviceSuccess_UpgradeMode)success failure:(MeariDeviceFailure)failure;


/**
 Upgrade firmware (升级固件)
 
 @param url firmware package address(固件包地址)
 @param currentVersion Firmware current version number(固件当前版本号)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startDeviceUpgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 设备重启

/**
 Device reboot
 设备重启

 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)rebootDeviceSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
#pragma mark --- 开通云存储

/**
 upload to  cloud storage
 上传云存储
 
 @param enable 是否开启
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setCloudUploadEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- 参数信息

/**
 Get all parameters(获取所有参数)
 
 @param success Successful callback (成功回调)，return value: device parameter information (返回值：设备参数信息)
 @param failure failure callback (失败回调)
 */
- (void)getDeviceParamsSuccess:(MeariDeviceSuccess_Param)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 休眠模式
/**
 Set sleep mode(设置休眠模式)
 
 @param type sleep mode(休眠模式)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setSleepModeType:(MeariDeviceSleepMode)type success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 set sleepMode
 设置休眠时间段

 @param open Whether to enable sleep mode(是否开启休眠模式)
 @param times 休眠时间段 : 数组里面存放MeariDeviceParamSleepTime, 例如MeariDeviceParamSleepTime格式如下
                         {
                         enable = 1;
                         repeat =     (
                                 1,
                                 2
                                       );
                         "start_time" = "00:00";
                         "stop_time" = "10:00";
                          },
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setSleepModeTimesOpen:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 地理围栏

/**
 设置地理围栏

 @param radius 半径
 @param longitude 经度
 @param latitude 纬度
 @param open 是否开启地理围栏休眠模式
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setHomeLocationWithRadius:(double)radius longitude:(double)longitude latitude:(double)latitude openGeogSleepMode:(BOOL)open success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure __deprecated_msg("Use `MeariUser -> setGeofenceWithSSID: BSSID: deviceID: success: failure:`");

/**
  upload Region
 上传区域

 @param deviceType 设备类型
 @param timeZone 时区
 @param ID device's ID (设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)uploadRegionWithDeviceType:(MeariDeviceType)deviceType timeZone:(NSTimeZone *)timeZone ID:(NSInteger)ID success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 机械铃铛

/**
 Turn on the mechanical chime( 开启机械铃铛)
 
 @param enable Whether to open (是否开启)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setMechanicalChimeEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 温湿度

/**
 Get temperature and humidity(获取温湿度)
 
 @param success Successful callback (成功回调)，返回值：温度和湿度
 @param failure failure callback (失败回调)
 */
- (void)getTemperatureHumiditySuccess:(MeariDeviceSuccess_TRH)success failure:(MeariDeviceFailure)failure;

#pragma mark --- relay

/**
 是否开启relay

 @param enable 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setRelayEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

// 发送relay
- (void)setRelaySuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 音乐
/**
 Set play mode
 设置播放模式
 
 @param mode play mode(播放模式)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setPlayMusicMode:(MRBabyMusicPlayMode)mode success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");
/**
 play music(播放音乐)
 
 @param musicID music ID(音乐ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)playMusicWithMusicID:(NSString *)musicID success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Pause music(暂停播放音乐)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)pauseMusicWithMusicID:(NSString *)musicID success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Play the next song(播放下一首)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)playNextMusicWithMusicID:(NSString *)musicID success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Play the previous one(播放前一首)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)playPreviousMusicWithMusicID:(NSString *)musicID success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Get music status: including play and download status
 (获取音乐状态：包括播放和下载状态)
 
 @param success Successful callback (成功回调), return value: json dictionary (返回值：json字典)
 @param failure failure callback (失败回调)
 */
- (void)getPlayMusicStatus:(MeariDeviceSuccess_MusicStateAll)success failure:(MeariDeviceFailure)failure;

/**
 upload userInfo to baby camera
 上传账户信息给baby设备
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setPreviewInformationSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 设备音量

/**
 Get music device output volume (获取音乐摄像机输出音量)
 
 @param success Successful callback (成功回调)，return value: device output volume, 0-100 (返回值：设备输出音量，0-100)
 @param failure failure callback (失败回调)
 */
- (void)getMusicOutputVolumeSuccess:(MeariDeviceSuccess_Volume)success failure:(MeariDeviceFailure)failure;


/**
 Set the music device output volume (设置babymonitor摄像机输出音量)
 
 @param volume volume(音量)，0-100
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setMusicOutputVolume:(NSInteger)volume success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- 门铃
/**
 Set the doorbell output volume (设置门铃输出音量)
 
 @param volume volume(音量)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setSpeakVolume:(NSInteger)volume success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set the doorbell PIR (human body detection) alarm type (设置门铃单PIR(人体侦测)报警类型) warning : level can contain MeariDeviceLevelOff
 
 @param level alarm level (报警级别)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setPirDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
  Set the switch for double pir (设置双pir 的开关)  ( warning : level cant contain MeariDeviceLevelOff)
@param level  PirSensitivity (灵敏度)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
 */
- (void)setDoublePirStatus:(MeariDeviceDoublePirStatus)doublePirStatus success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/// pir2 level       1-n
/// @param level  1-n
/// @param success Successful callback (成功回调)
/// @param failure failure callback (失败回调)
- (void)setPirDetectionMutiLevel:(NSInteger)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/// pir2 enable
/// @param enable enable
/// @param success Successful callback (成功回调)
/// @param failure failure callback (失败回调)
- (void)setPirDetectionMutiEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set the doorbell low power consumption (设置门铃低功耗)
 
 @param open Whether to turn on low power mode (是否打开低功耗模式)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setDoorBellLowPowerOpen:(BOOL)open success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set the doorbell battery lock (设置门铃电池锁)
 
 @param open Whether to open the battery lock (是否打开电池锁)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)unlockBatterySuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 Whether to use a chime(设置铃铛使能)
 
 @param enable Whether to use a chime(设置铃铛使能)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setWirelessChimeEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set the wireless bell (设置无线铃铛)
 
 @param volumeLevel Bell sound level (铃铛声音等级)
 @param selectedSong Selected ringtone (选中的铃声)
 @param repeatTimes number of repetitions (重复次数)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setWirelessChimeVolumeLevel:(MeariDeviceLevel)volumeLevel selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSuccess_ID)success failure:(MeariDeviceFailure)failure;

/**
 Doorbell and chime pairing(门铃与铃铛配对)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)bindWirelessChime:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Doorbell and chime unbound (门铃与铃铛解除绑定 )
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)unbindWirelessChime:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 设置开门
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setAssociatedDoorOpen:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 设置开锁
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setAssociatedLockOpenSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 设置灯状态
 @param on 灯开关使能
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setAssociatedLightOn:(BOOL)on success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 获取铃铛状态

 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getChimeStatusSuccess:(MeariDeviceSuccess_ID)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");

#pragma mark -- 录音

/**
 Get doorbell message list (获取门铃留言列表)
 
 @param success Successful callback, URL of the file containing the message (成功回调,包含留言的文件的URL地址)
 @param failure failure callback (失败回调)
 */
- (void)getVoiceMailListSuccess:(MeariDeviceSuccess_HostMessages)success failure:(MeariDeviceFailure)failure;

/**
  stop VoiceMail (开始留言)
 
 @param path (path)录音文件路径 例如(likes): /var/mobile/Containers/Data/Application/98C4EAB7-D2FF-4519-B732-BEC7DE19D1CE/Documents/audio.wav  warning!!, it must be .wav format (注意!!! 文件必须是wav格式))
 */
- (void)startRecordVoiceMailWithPath:(NSString *)path;

/**
 Stop message (停止留言)
 
 @param success Successful callback (成功回调)，return value: message file path (返回值：留言文件路径)
 */
- (void)stopRecordVoiceMailSuccess:(MeariDeviceSuccess_RecordAutio)success;

/**
 Start playing a message (开始播放留言)
 
 @param filePath message file path(留言文件路径)
 @param finished 完成回调
 */
- (void)startPlayVoiceMailWithFilePath:(NSString *)filePath finished:(MeariDeviceSuccess)finished;

/**
 Stop playing the message (停止播放留言)
 */
- (void)stopPlayVoiceMail;
/**
 Play message(播放留言)
 
 @param success Successful callback (成功回调)
 @param failure 成功回调
 */
- (void)makeDeivcePlayVoiceMail:(MeariDeviceHostMessage *)hostMessage success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- voiceBell(语音门铃)

/**
 Start play audio
 开始播放客人留言
 
 @param filePath 本地语音文件路径
 @param finished 完成回调
 */
- (void)startPlayVoiceMessageAudioWithFilePath:(NSString *)filePath finished:(MeariDeviceSuccess)finished;

/**
 Stop play audio
 停止播放客人留言
 */
- (void)stopPlayVoiceMessageAudio;

/**
 Turn off the phone side microphone(关闭手机端麦克)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)pauseVoicetalkSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
  Turn on the phone microphone(开启手机端麦克)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)resumeVoicetalkSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
  how long time the bell go sleep normal
  睡眠超时时间

@param sleepOverTimeLevel call waiting time (睡眠超时时间)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setVoiceBellSleepOverTimeLevel:(MeariDeviceLevel)sleepOverTimeLevel success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set call waiting time
 设置呼叫等待时间
 
 @param callWaitTimeLevel call waiting time (呼叫等待时间)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setVoiceBellCallWaitTimeLevel:(MeariDeviceLevel)callWaitTimeLevel success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 set doorbell message limit time
 设置门铃留言限制时间
 
 @param messageLimitTimeLevel doorbell message limit time (门铃留言限制时间)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setVoiceBellMessageLimitTimeLevel:(MeariDeviceLevel)messageLimitTimeLevel success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set whether to enable the tamper alarm
 设置是否开启防拆报警
 
 @param enable  whether to enable the tamper alarm (是否开启防拆报警)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setVoiceBellTamperAlarmEnable:(NSInteger)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 灯具摄像机

/**
 Setting the light switch (设置灯开关)
 
 @param on light switch(灯开关)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setFloodCameraLampOn:(BOOL)on success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 Set the alarm switch (设置警报开关)
 
 @param on alarm switch (警报开关)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setFloodCameraSirenOn:(BOOL)on success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set up the lighting plan
 设置灯具开灯计划
 
 @param on Is it enabled? (是否使能)
 @param fromDateStr start time (开始时间)
 @param toDateStr End time (结束时间)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setFloodCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/// 手动开灯时长，0-默认，10-60s（step：10s），5min-30min（step：5min）
/// Manual lighting time, 0-default, 10-60s (step: 10s), 5min-30min (step: 5min)
/// @param duration duration
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)setFloodCameraLampOnDuration:(NSInteger)duration success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/// 警报器联动开关，时长默认10秒
/// on Alarm linkage switch, the default time is 10 seconds
/// @param on Is it open? (是否使能)
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)setFloodCameraPirSirenEnable:(BOOL)on success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure ;

/// 亮灯计划，最大支持设置4组，每组支持设置每周循环天数，每组最大不超过30分钟
/// Lighting plan, support up to 4 groups, each group supports setting the number of days per week, each group does not exceed 30 minutes
/// @param scheduleArray MeariDeviceParamSleepTime data array
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)setLowPowerFloodCameraScheduleArray:(NSArray<MeariDeviceParamSleepTime *> *)scheduleArray success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set up the movement monitoring of the luminaire
 设置灯具的移动监测是否亮灯时长

 @param level 不同等级对应的亮灯时间  MeariDeviceLevelNone : 不开灯,MeariDeviceLevelLow : 20s , MeariDeviceLevelMedium : 40s, MeariDeviceLevelHigh: 60s
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setFloodCameraDurationLevel:(MeariDeviceLevel)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 whether flight camera motion open
 设置灯具的移动监测开关
 
 @param on Is it enabled? (是否使能)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setFloodCameraMotionOn:(BOOL)on success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Set the brightness of the fixture
 设置灯具的亮度调节

 @param precent 当前亮度百分比
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setFloodCameraLightPercent:(NSInteger)precent success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/// 获取开关灯状态
/// whether the flight is open now
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)getFloodCameralightStateSuccess:(MeariDeviceSuccess_LightState)success failure:(MeariDeviceFailure)failure;

/// 获取警报倒计时
/// Get Siren countdown
/// @param success Successful callback (成功回调)
/// @param failure  failure callback (失败回调)
- (void)getFloodCameraSirenTimeoutSuccess:(MeariDeviceSuccess_SirenTimeout)success failure:(MeariDeviceFailure)failure;

/// 设置声光报警使能开关
/// Set sound and light alarm enable switch
/// @param enable 是否开启
/// @param success 成功回调
/// @param failure 失败回调
- (void)setFloodCameraVoiceLightAlarmEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/// 设置声光报警后的事件
/// Set events after sound and light alarm
/// @param type 类型
/// @param success 成功回调
/// @param failure 失败回调
- (void)setFloodCameraVoiceLightAlarmType:(MeariDeviceVoiceLightType)type success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- chime (中继)
/**
 删除中继
 Delete Chime
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteChimeSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Add child device through Chime (in-app binding)
 中继添加子设备(app内绑定)
 
 @param subDeviceID 子设备deviceID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)bindDeviceWithSubDeviceID:(NSInteger)subDeviceID success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Chime unbundling device (unbundling in app)
 中继解绑子设备(app内解绑)
 
 @param subDeviceID 子设备deviceID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)unbindDeviceWithSubDeviceID:(NSInteger)subDeviceID success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Child device list (added)
 子设备列表(已添加的)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getAddedChimeDeviceListSuccess:(MeariDeviceSuccess_ChimeSubDeviceList)success failure:(MeariDeviceFailure)failure;

/**
 Child device list (can be added)
 子设备列表(可以添加的)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getCanAddChimeDeviceListSuccess:(MeariDeviceSuccess_ChimeSubDeviceList)success failure:(MeariDeviceFailure)failure;

/**
 List of ringtones
 铃声列表
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getChimeRingListSuccess:(MeariDeviceSuccess_ChimeRingList)success failure:(MeariDeviceFailure)failure;

/**
 Rename chime
 重命名chime
 
 @param nickname 昵称
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)renameChimeNickname:(NSString *)nickname success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Chime Do Not Disturb Interval
 
 @param times [MeariDeviceParamSleepTime] 勿扰时间段
                                        [{
                                         enable = 1;
                                             repeat =     (
                                                1,
                                                2
                                               );
                                         "start_time" = "00:00";
                                         "stop_time" = "10:00";
                                         }, ........]
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setChimeSnoozeTimes:(NSArray<MeariDeviceParamSleepTime *> *)times success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set current ring uri
 设置当前响铃uri
 
 @param currentRingUri the alarm uri used  when chime button is ring 当前响铃uri
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setChimeCurrentRingUri:(NSString *)currentRingUri success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set the chime ringer volume
 设置铃铛响铃音量
 
 @param ringVolume   the Volume used when chime button is ring 响铃音量
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setChimeRingVolume:(NSInteger)ringVolume success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set chime motion detection alarm uri
 设置铃铛移动侦测报警uri
 
 @param motionUri the alarm uri used  when motion event happen 移动侦测报警uri
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setChimeMotionUri:(NSString *)motionUri success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set the ringtone size of the motion detection alarm chime
 设置移动侦测报警响铃的铃声大小
 
 @param motionVolume the Volume when motion event happen (侦测报警响铃的铃声大小)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setChimeMotionVolume:(NSInteger)motionVolume success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set the ring interval
 设置响铃间隔
 
 @param snoozeTimes MeariDeviceSnoozeTime
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setRingSnoozeTimes:(MeariDeviceSnoozeTime)snoozeTimes success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 Playing Chime's Songs
 播放中继的歌曲
 
 @param Uri song's uri(歌曲uri)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)playChimeUri:(NSString *)Uri success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

/**
 Set chime sub-device alarm type
 设置中继子设备报警类型
 
 @param ChimeAlertType 报警类型
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setChimeAlertType:(MeariDeviceChimeAlert)ChimeAlertType success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


/**
 Get chime sub-device alarm type
 获取中继子设备报警类型
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getChimeAlertTypeSuccess:(MeariDeviceSuccess_ChimeAlertType)success failure:(MeariDeviceFailure)failure;

/**
Set face recognition enable
开启/关闭设备的人脸识别
@param enable enable 是否开启
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFaceRecognitionEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
update device  face recognition list
更新设备的人脸列表
@param faceIDArray faceIDArray 人脸ID数组 格式为  [faceID,faceID,faceID]
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFaceRecognitionList:(NSArray *)faceIDArray success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 Face pictures converted to YUV format
 @param originYUV yuv格式
 @param width yuv的宽
 @param height yuv的高
 @param complete 成功回调 返回NV12和nv21的yuv数据
 */
- (void)yuvImageConversion:(char *)originYUV width:(int)width height:(int)height complete:(void(^)( char *yuv_nv12,char *yuv_nv21))complete;
/**
Face pictures converted to YUV format
 @param buffer yuv的数据 yuv的格式为nv12
 @param width yuv的宽
 @param height yuv的高
 @return return 指定宽高的图片
*/
+ (UIImage *)YUVNV12toImageBuffer:(char *)buffer width:(int)width height:(int)height;

/**
Face pictures converted to YUV format
 @param buffer yuv的数据 yuv的格式为nv12
 @param width yuv的宽
 @param height yuv的高
 @return return 指定宽高的图片
*/
+ (UIImage *)YUVNV21toImageBuffer:(char *)buffer width:(int)width height:(int)height;

/**
Determine whether it is a face
 @param data yuv的数据 yuv的格式为nv12
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
*/
- (void)detectFaceWithData:(char *)data success:(MeariDeviceSuccess_DetectFace)success failure:(MeariDeviceFailure)failure;

/**
 Set time show type
 设置时间显示格式
 
 @param type 12 hour or 24 hour（12小时制还是24小时制）
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
*/
- (void)setTimeShowType:(MeariDeviceTimeShowType)type
                success:(MeariDeviceSuccess)success
                failure:(MeariDeviceFailure)failure;

/**
 Set tamper alarm
 设置防拆报警
 
 @param enable  Whether it is enable
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
*/
- (void)setTamperAlarm:(BOOL)enable
               success:(MeariDeviceSuccess)success
               failure:(MeariDeviceFailure)failure;

/**
 Get device install guide video
 获取安装指引视频
 
 @param tp  设备的tp值
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
*/
-(void)getInstallGuideVideoUrlWithTp:(NSString *)tp                 success:(MeariDeviceSuccess_Dictionary)success
                             failure:(MeariDeviceFailure)failure;
@end
#endif /* MeariDeviceControl_h */
