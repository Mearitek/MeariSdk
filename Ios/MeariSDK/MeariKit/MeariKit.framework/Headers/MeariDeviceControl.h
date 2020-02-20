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
typedef void(^MeariDeviceFailure)(NSError *error);
typedef void(^MeariDeviceFailure_Str)(NSString *error);
typedef void(^MeariDeviceSucess)(void);
typedef void(^MeariDeviceDisconnect)(void);
typedef void(^MeariDeviceSucess_Online)(BOOL online);
typedef void(^MeariDeviceSucess_SearchDevice)(MeariDevice *device);
typedef void(^MeariDeviceSucess_ID)(id obj);
typedef void(^MeariDeviceSucess_Str)(NSString *str);
typedef void(^MeariDeviceSucess_Dict)(NSString *dict);
typedef void(^MeariDeviceSucess_Result)(NSString *jsonString);
typedef void(^MeariDeviceSucess_PlaybackTimes)(NSArray *times);
typedef void(^MeariDeviceSucess_PlaybackDays)(NSArray *days);
typedef void(^MeariDeviceSucess_HostMessages)(NSArray *customArray);
typedef void(^MeariDeviceSucess_MusicStateCurrent)(NSDictionary *currentMusicState);
typedef void(^MeariDeviceSucess_MusicStateAll)(NSDictionary *allMusicState);
typedef void(^MeariDeviceSucess_Mirror)(BOOL mirror);
typedef void(^MeariDeviceSucess_LED)(BOOL on);
typedef void(^MeariDeviceSucess_Motion)(MeariDeviceParamMotion *motion);
typedef void(^MeariDeviceSucess_Storage)(MeariDeviceParamStorage *storage);
typedef void(^MeariDeviceSucess_StoragePercent)(NSInteger percent);
typedef void(^MeariDeviceSucess_UpgradeMode)(MROtaUpgradeMode otaUpgradeMode);
typedef void(^MeariDeviceSucess_Version)(NSString *version);
typedef void(^MeariDeviceSucess_VersionPercent)(NSInteger percent);
typedef void(^MeariDeviceSucess_Param)(MeariDeviceParam *param);
typedef void(^MeariDeviceSucess_TRH)(CGFloat temperature, CGFloat humidity);
typedef void(^MeariDeviceSucess_Volume)(CGFloat volume);
typedef void(^MeariDeviceSucess_RecordAutio)(NSString *filePath);
typedef void(^MeariDeviceSucess_NetInfo)(MeariDeviceParamNetwork *info);
typedef void(^MeariDeviceSucess_PlayBackLevel)(MeariDeviceRecordDuration level);


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
    MeariDeviceVideoStream_360,
    MeariDeviceVideoStream_240,
    MeariDeviceVideoStream_480,
    MeariDeviceVideoStream_720,
    MeariDeviceVideoStream_1080,
    MeariDeviceVideoStream_1080_1_5,
    MeariDeviceVideoStream_1080_2_0,
    MeariDeviceVideoStreamNone,
};
typedef NS_ENUM (NSInteger, MeariDeviceConnectType) {
    MeariDeviceConnectTypeNone = -1,
    MeariDeviceConnectTypeP2p,
    MeariDeviceConnectTypeRelay,
    MeariDeviceConnectTypeLan,
};

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

#pragma mark -- Query online(查询在线)

/**
Get online status
获取在线状态

@param completion Online (是否在线)
*/
- (void)getOnlineStatus:(MeariDeviceSucess_Online)completion;

#pragma mark -- Search & Distribution(搜索 & 配网)

/**
Start search: for smartwifi distribution network and ap distribution network
开始搜索：适用于smartwifi配网和ap配网

@param success Successful callback (成功回调)：返回搜索到的设备
@param failure failure callback (失败回调)
*/
+ (void)startSearch:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
Start search: only for QR code network(开始搜索：仅适用于二维码配网)

@param token QR code token(二维码token)
@param success Successful callback (成功回调)：返回搜索到的设备
@param failure failure callback (失败回调)
*/
+ (void)startSearchWithQRcodeToken:(NSString *)token success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

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
+ (void)startSearch:(MeariDeviceSearchMode)mode success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
Stop smartwifi distribution network
停止 smartwifi 配网
*/
+ (void)stopSearch;


/**
Start smartwifi distribution network(开始 smartwifi 配网)

@param wifiSSID wifi name(wifi名称)
@param wifiPwd wifi password: no password, pass nil(wifi密码：没有密码，传nil)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
+ (void)startMonitorWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd token:(NSString *)token success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

/**
Stop smartwifi distribution network
停止 smartwifi 配网
*/
+ (void)stopMonitor;

/**
Start ap distribution network(开始 ap 配网)

@param wifiSSID wifi name(wifi名称)
@param wifiPwd wifi password(wifi密码)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
+ (void)startAPConfigureWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Custom Setting
- (void)setDeviceWithParams:(NSDictionary *)params success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- Punch holes(打洞)

/**
Start connecting devices(开始连接设备)

@param success Successful callback (成功回调)
 @param disconnect Exception callback(异常回调)
@param failure failure callback (失败回调)
*/
- (void)startConnectSuccess:(MeariDeviceSucess)success abnormalDisconnect:(MeariDeviceDisconnect)disconnect failure:(MeariDeviceFailure)failure;

/**
Disconnect device(断开设备)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)stopConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Get parameters(bit) 获取参数：（码率、模式、静音）

/**
 获取码率

 @return 码率
 */
- (NSString *)getBitrates;

#pragma mark -- Preview(预览)

/**
Start previewing the device(开始预览设备)

@param playView play view control(播放视图控件)
@param HD Whether to play HD(是否高清播放)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
@param close is in sleep mode, the lens is off, return value: sleep mode(close 处于休眠模式，镜头关闭，返回值：休眠模式)
*/
- (void)startPreviewWithView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;

/**
Start previewing the device(开始预览设备)

@param playView play view control(播放视图控件)
@param videoStream  Stream type (码流类型 )
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
@param close is in sleep mode, the lens is off, return value: sleep mode(close 处于休眠模式，镜头关闭，返回值：休眠模式)
*/
- (void)startPreviewWithView:(MeariPlayView *)playView videoStream: (MeariDeviceVideoStream)videoStream success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;

/**
stop preview
停止预览设备

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)stopPreviewSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
change Video Resolution
切换高清标清

@param playView play view(播放视图)
@param videoStream (video type)播放类型
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)switchPreviewWithView:(MeariPlayView *)playView videoStream:(MeariDeviceVideoStream)videoStream success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Playback (回放)

/**
Get the number of video days in a month(获取某月的视频天数)

@param month 月
@param year 年
@param success Successful callback (成功回调)，  return value: json array --[{"date" = "20171228"},...]       (返回值：json数组--[{"date" = "20171228"},...])
@param failure failure callback (失败回调)
*/
- (void)getPlaybackVideoDaysWithYear:(NSInteger)year month:(NSInteger)month success:(MeariDeviceSucess_PlaybackDays)success failure:(MeariDeviceFailure)failure;


/**
Get a video clip of a day(获取某天的视频片段)

@param year year(年)
@param month month(月)
@param day day(日)
@param success Successful callback (成功回调)：返回值：json数组--[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
@param failure failure callback (失败回调)
*/
- (void)getPlaybackVideoTimesWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MeariDeviceSucess_PlaybackTimes)success failure:(MeariDeviceFailure)failure;


/**
 Start playback of video: only one person can view playback video at the same time (开始回放录像：同一个设备同一时间只能一个人查看回放录像)
 
 @param playView play view(播放视图)
 @param startTime Start time: format is 20171228102035 (开始时间:格式为20171228102035)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)startPlackbackWithView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Stop playback(停止回放)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)stopPlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Play from a certain time: This interface can only be used after the playback is successful, otherwise it will fail.
 从某时间开始播放：开始回放成功后才能使用此接口，否则会失败
 
 @param seekTime Start time: format is 20171228102035 (开始时间:格式为20171228102035)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)seekPlackbackSDCardToTime:(NSString *)seekTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
pause playback(暂停回放)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)pausePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Continue playback(继续回放)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)resumePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Cloud playback (云回放)

/**
Get cloud playback video files
获取云回放录像文件

@param startTime startTime(NSDateComponents *) 开始时间
@param endTime endTime(NSDateComponents *) 结束时间
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getCloudVideoWithBegin:(NSDateComponents *)startTime endTime:(NSDateComponents *)endTime success:(void(^)(NSURL *m3u8Url))success failure:(MeariDeviceFailure)failure;
/**
Get the cloud play time of a day
获取某天的云播放分钟

@param dayComponents   time(NSDateComponents *),Used to get specific time 具体日期
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getCloudVideoMinutes:(NSDateComponents *)dayComponents success:(void(^)(NSArray <MeariDeviceTime *> *mins))success failure:(MeariDeviceFailure)failure;

/**
Get the cloud play time of a month
获取某月的云播放天数

@param monthComponents  obtain month(NSDateComponents *) 具体某月
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getCloudVideoDays:(NSDateComponents *)monthComponents success:(void(^)(NSArray <MeariDeviceTime *> *days))success failure:(MeariDeviceFailure)failure;

#pragma mark -- mute (静音)
/**
Set mute(设置静音)

@param muted muted is mute?(是否静音)
*/
- (void)setMute:(BOOL)muted;

#pragma mark -- Voice intercom (语音对讲)

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
- (void)startVoiceTalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Stop voice intercom / 停止语音对讲

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Turn on two-way voice speakers
开启双向语音扬声器

@param enabled 是否开启
*/
- (void)enableLoudSpeaker:(BOOL)enabled;

#pragma mark -- snapshot (截图)

/**
Screenshot  (截图)

@param path The path where the image is saved(图片保存的路径)
@param isPreviewing is previewing(是否正在预览)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)snapshotToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- record (录像)

/**
Start recording(开始录像)

@param path The path where the video is saved(录像保存的路径)
@param isPreviewing is previewing(是否正在预览)
@param Interrputed record Interrputed(录像中断)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)startRecordMP4ToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success abnormalDisconnect:(MeariDeviceSucess)Interrputed failure:(MeariDeviceFailure)failure;


/**
Stop recording(停止录像)

@param isPreviewing is previewing(是否正在预览)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)stopRecordMP4IsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- PTZ(云台)

/**
Start turning the camera (开始转动摄像机)

@param direction direction(转动方向)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)startMoveToDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Stop turning the camera (停止转动摄像机)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)stopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- LED
/**
 获取LED状态
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getLEDSuccess:(MeariDeviceSucess_LED)success failure:(MeariDeviceFailure)failure;

/**
 set LED (设置LED)

@param on 是否打开LED
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setLEDOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- dayNightMode (日夜模式)

/**
// Set day and night mode, the camera will have color or grayscale
// 设置日夜模式, 摄像头会有彩色或灰度两种

@param type  MeariDeviceDayNightType(日夜模式)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDayNightMode:(MeariDeviceDayNightType)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- soundDetection (噪声检测)

/**
// Noise detection, alarm when sound exceeds a certain decibel
// 噪声检测, 当有声音超过一定分贝的时候报警

@param level  MeariDeviceLevel (噪声等级)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDBDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- net Information (网络信息)

/**
 Get network information
 获取网络信息

@param success  成功回调 返回值：当前网络信息MeariDeviceParamNetwork
@param failure  失败回调
*/
- (void)getNetInfoSuccess:(MeariDeviceSucess_NetInfo)success failure:(MeariDeviceFailure)failure;

#pragma mark--- 码流H264-H265

/**
// Whether to enable h265 encoding
// 开关h265编码

@param isH265 Whether to enable h265 encoding(是否开启h265编码)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)switchVideoEncoding:(BOOL)isH265 success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Mirror(画面翻转)

/**
 获取镜像状态

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getMirrorSuccess:(MeariDeviceSucess_Mirror)success failure:(MeariDeviceFailure)failure;

/**
Get mirror status (设置镜像)

@param open  whether to open mirror (是否打开镜像)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setMirrorOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Playback setting(回放设置)
/**
Set playback level
设置回放等级

@param level MeariDeviceRecordDuration  回放等级
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setPlaybackRecordVideoLevel:(MeariDeviceRecordDuration)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 获取回放等级
 @param success 成功回调 level回放级别
 @param failure 失败回调
 */
- (void)getPlaybackLevelSuccess:(MeariDeviceSucess_PlayBackLevel)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Onvif

/**
 Set Onvif  / 设置Onvif
@param enable  Whether to open (是否开启)
@param pwd    Connect onvif password(连接密码)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setOnvifEnable:(BOOL)enable password:(NSString *)pwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- alarm (报警)

/**
 获取报警信息

 @param success 成功回调，返回值：报警参数信息
 @param failure 失败回调
 */
- (void)getAlarmSuccess:(MeariDeviceSucess_Motion)success failure:(MeariDeviceFailure)failure;


/**
set alarm information (设置报警级别)

@param level alarm level(报警级别)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setAlarmLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
// Setting up an alarm plan
// 设置报警计划

@param times Array of MeariDeviceParamSleepTime (MeariDeviceParamSleepTime的数组)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setAlarmTime:(NSArray<MeariDeviceParamSleepTime *> *)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
// Whether people detection  are on , Whether the human border is on
// 人形检测是否开启,  人形边框是否开启

@param enable Whether people detection is on(人形检测是否开启)
@parambnddrawEnable Whether the human border is on(人形边框是否开启)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setPeopleDetectEnable:(BOOL)enable bnddrawEnable:(BOOL)bnddrawEnable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
// Whether to enable cry detection, when a cry is detected, an alarm will appear
// 是否开启哭声检测,当哭声检测到时, 会出现报警

@param enable Whether to open(是否开启)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setCryDetectEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
// Human tracking
// 人形跟踪

@param enable whether to open(是否开启)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setPeopleTrackEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Storage (存储)
/**
Get storage information(获取存储信息)

@param success Successful callback (成功回调)，return storage information(返回存储信息)
@param failure failure callback (失败回调)
*/
- (void)getStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;


/**
Get memory card formatting percentage(获取内存卡格式化百分比)

@param success Successful callback (成功回调),return formatting percentage(返回格式化百分比)
@param failure failure callback (失败回调)
*/
- (void)getFormatPercentSuccess:(MeariDeviceSucess_StoragePercent)success failure:(MeariDeviceFailure)failure;

/**
Format sd card(格式化内存卡)

@param success Successful callback (成功回调)
@param failure 失败回道
*/
- (void)formatSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- FirmwareVersion(固件版本)

/**
Get the firmware version(获取固件版本)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getVersionSuccess:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;


/**
Get firmware upgrade percentage(获取固件升级百分比)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getUpgradePercentSuccess:(MeariDeviceSucess_VersionPercent)success failure:(MeariDeviceFailure)failure;

/**
Upgrade firmware (升级固件)

@param url firmware package address(固件包地址)
@param currentVersion Firmware current version number(固件当前版本号)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)upgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- rebootDevice(设备重启)

/**
Device reboot
设备重启

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)rebootDeviceSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark --- open CloudStorage (开通云存储)

/**
Open cloud storage
开通云存储

@param open 是否开启
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setCloudStorageOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- Device Param (参数信息)

/**
Get all parameters(获取所有参数)

@param success Successful callback (成功回调)，return value: device parameter information (返回值：设备参数信息)
@param failure failure callback (失败回调)
*/
- (void)getParamsSuccess:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

#pragma mark -- sleep mode (休眠模式)
/**
Set sleep mode(设置休眠模式)

@param type sleep mode(休眠模式)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setSleepmodeType:(MeariDeviceSleepmode)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

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
- (void)setSleepmodeTime:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
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
- (void)setHomeLocationWithRadius:(double)radius longitude:(double)longitude latitude:(double)latitude openGeogSleepmode:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure __deprecated_msg("Use `MeariUser -> settingGeographyWithSSID: BSSID: deviceID: success: failure:`");

/**
 upload Region
上传区域

@param deviceType 设备类型
@param timeZone 时区
@param ID device's ID (设备ID)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)uploadRegionWithDeviceType:(MeariDeviceType)deviceType timeZone:(NSTimeZone *)timeZone ID:(NSInteger)ID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- (Machinery chime) 机械铃铛

/**
Turn on the mechanical chime( 开启机械铃铛)

@param open Whether to open (是否开启)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setMachineryBellOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Temperature Humidity (温湿度)

/**
Get temperature and humidity(获取温湿度)

@param success Successful callback (成功回调)，返回值：温度和湿度
@param failure failure callback (失败回调)
*/
- (void)getTemperatureHumiditySuccess:(MeariDeviceSucess_TRH)success failure:(MeariDeviceFailure)failure;


#pragma mark -- music （音乐)
/**
Set play mode
设置播放模式

@param mode play mode(播放模式)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setPlayMusicMode:(MRBabyMusicPlayMode)mode success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");
/**
play music(播放音乐)

@param musicID music ID(音乐ID)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)playMusic:(NSString *)musicID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
Pause music(暂停播放音乐)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)pauseMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Keep playing music(继续播放音乐)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)resumeMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
Play the next song(播放下一首)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)playNextMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Play the previous one(播放前一首)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)playPreviousMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Get music status: including play and download status
(获取音乐状态：包括播放和下载状态)

@param success Successful callback (成功回调), return value: json dictionary (返回值：json字典)
@param failure failure callback (失败回调)
*/
- (void)getMusicStateSuccess:(MeariDeviceSucess_MusicStateAll)success failure:(MeariDeviceFailure)failure;


#pragma mark -- music Volume (音乐播放音量)

/**
Get music device output volume (获取音乐摄像机输出音量)

@param success Successful callback (成功回调)，return value: device output volume, 0-100 (返回值：设备输出音量，0-100)
@param failure failure callback (失败回调)
*/
- (void)getOutputVolumeSuccess:(MeariDeviceSucess_Volume)success failure:(MeariDeviceFailure)failure;

/**
Set the music device output volume (设置babymonitor摄像机输出音量)

@param volume volume(音量)，0-100
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setOutputVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- doorbell (门铃)
/**
Set the doorbell output volume (设置门铃输出音量)

@param volume volume(音量)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Set the doorbell PIR (human body detection) alarm type (设置门铃PIR(人体侦测)报警类型)

@param level alarm level (报警级别)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellPIRLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Set the doorbell low power consumption (设置门铃低功耗)

@param open Whether to turn on low power mode (是否打开低功耗模式)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellLowPowerOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Set the doorbell battery lock (设置门铃电池锁)

@param open Whether to open the battery lock (是否打开电池锁)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellBatteryLockOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
Whether to use a chime(设置铃铛使能)

@param enable Whether to use a chime(设置铃铛使能)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellJingleBellVolumeEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Set the wireless bell (设置无线铃铛)

@param volumeType Bell sound level (铃铛声音等级)
@param selectedSong Selected ringtone (选中的铃声)
@param repeatTimes number of repetitions (重复次数)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellJingleBellVolumeType:(MeariDeviceLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
Doorbell and chime pairing(门铃与铃铛配对)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellJingleBellPairingSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Doorbell and chime unbound (门铃与铃铛解除绑定 )

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorebllJingleBellUnbindSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
设置开门

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellDoorOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
设置开锁

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellLockOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
设置灯状态
@param on 灯开关使能
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setDoorBellLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
获取铃铛状态

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getDoorebllJingleBellStatusSuccess:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");

#pragma mark -- record voice / 录音

/**
Get doorbell message list (获取门铃留言列表)

@param success Successful callback, URL of the file containing the message (成功回调,包含留言的文件的URL地址)
@param failure failure callback (失败回调)
*/
- (void)getHostMessageListSuccess:(MeariDeviceSucess_HostMessages)success failure:(MeariDeviceFailure)failure;

/**
 stop VoiceMail (开始留言)

@param path (path)录音文件路径 例如(likes): /var/mobile/Containers/Data/Application/98C4EAB7-D2FF-4519-B732-BEC7DE19D1CE/Documents/audio.wav  warning!!, it must be .wav format (注意!!! 文件必须是wav格式))
*/
- (void)startRecordAudioToPath:(NSString *)path;

/**
Stop message (停止留言)

@param success Successful callback (成功回调)，return value: message file path (返回值：留言文件路径)
*/
- (void)stopRecordAudioSuccess:(MeariDeviceSucess_RecordAutio)success;

/**
Start playing a message (开始播放留言)

@param filePath message file path(留言文件路径)
@param finished 完成回调
*/
- (void)startPlayRecordedAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

/**
Stop playing the message (停止播放留言)
*/
- (void)stopPlayRecordedAudio;
/**
Play message(播放留言)

@param success Successful callback (成功回调)
@param failure 成功回调
*/
- (void)playMessageSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 门铃播放留言
 @param url url地址
 @param success 成功回调
 @param failure 成功回调
 */
- (void)playMessageWithURL:(NSString *)url success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 设置门铃留言

 @param ID 留言ID
 @param success 成功回调
 @param failure 成功回调
 */
- (void)setPlayMessagWithID:(NSString *)ID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- voiceBell (语音门铃)

/**
Start play audio
开始播放客人留言

@param filePath 本地语音文件路径
@param finished 完成回调
*/
- (void)startPlayVoiceMessageAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

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
- (void)pauseVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Turn on the phone microphone(开启手机端麦克)

@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)resumeVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/// 设置睡眠超时时间
/// @param sleepOverTime 睡眠超时时间
/// @param success callback
/// @param failure failure callback
- (void)setDoorBellSleepOverTime:(NSInteger)sleepOverTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set call waiting time
 设置呼叫等待时
 @param callWaitTime call waiting time (呼叫等待时间)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */

- (void)setDoorBellCallWaitTime:(NSInteger)callWaitTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 set doorbell message limit time
 设置门铃留言限制时间
 
 @param messageLimitTime doorbell message limit time (门铃留言限制时间)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */

- (void)setDoorBellMessageLimitTime:(NSInteger)messageLimitTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
  设置防拆报警
  Set whether to enable the tamper alarm
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */

- (void)setDoorBellTamperAlarmEnable:(NSInteger)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- floot camera / 灯具摄像机

/**
Setting the light switch (设置灯开关)

@param on light switch(灯开关)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFlightCameraLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
Set the alarm switch (设置警报开关)

@param on alarm switch (警报开关)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFlightCameraSiren:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
Set up the lighting plan
设置灯具开灯计划

@param on Is it enabled? (是否使能)
@param fromDateStr start time (开始时间)
@param toDateStr End time (结束时间)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFlightCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
Set up the movement monitoring of the luminaire
设置灯具的移动监测是否亮灯时长

@param level 不同等级对应的亮灯时间  MeariDeviceLevelNone : 不开灯,MeariDeviceLevelLow : 20s , MeariDeviceLevelMedium : 40s, MeariDeviceLevelHigh: 60s
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFlightCameraDurationLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
whether flight camera motion open
设置灯具的移动监测开关

@param on Is it enabled? (是否使能)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFlightCameraMotionOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
Set the brightness of the fixture
设置灯具的亮度调节

@param precent 当前亮度百分比
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)setFlightCameraLightPercent:(NSInteger)precent success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

@end
#endif /* MeariDeviceControl_h */
