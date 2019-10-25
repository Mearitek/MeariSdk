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
typedef void(^MeariDeviceSucess_Online)(BOOL online);
typedef void(^MeariDeviceSucess_SearchDevice)(MeariDevice *device);
typedef void(^MeariDeviceSucess_ID)(id obj);
typedef void(^MeariDeviceSucess_Str)(NSString *str);
typedef void(^MeariDeviceSucess_Dict)(NSString *dict);
typedef void(^MeariDeviceSucess_Result)(NSString *jsonString);
typedef void(^MeariDeviceSucess_PlaybackTimes)(NSArray *times);
typedef void(^MeariDeviceSucess_PlaybackDays)(NSArray *days);
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
typedef void(^MeariDeviceSucess_PlayBackLevel)(MeariDeviceLevel level);


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
 重置内部资源
 */
- (void)reset;
/**
 获取打洞类型
 */
- (MeariDeviceConnectType)getP2pMode;

#pragma mark -- 查询在线

/**
 获取在线状态

 @param completion 是否在线
 */
- (void)getOnlineStatus:(MeariDeviceSucess_Online)completion;

#pragma mark -- 搜索 & 配网

/**
 开始搜索：适用于smartwifi配网和ap配网

 @param success 成功回调：返回搜索到的设备
 @param failure 失败回调
 */
+ (void)startSearch:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 开始搜索：仅适用于二维码配网

 @param token 二维码token
 @param success 成功回调：返回搜索到的设备
 @param failure 失败回调
 */
+ (void)startSearchWithQRcodeToken:(NSString *)token success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 更新Token
 
 @param token 配网方式的token
 @param type  配网方式
 */
+ (void)updatetoken:(NSString *)token type:(MeariDeviceTokenType)type ;

/**
 开始搜索：搜索通用接口
 在使用此接口时要确保调用了updatetoken方法
 @param mode 配网方式
 @param success 成功回调：返回搜索到的设备
 @param failure 失败回调
 */
+ (void)startSearch:(MeariDeviceSearchMode)mode success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 停止搜索
 */
+ (void)stopSearch;


/**
 开始 smartwifi 配网

 @param wifiSSID wifi名称
 @param wifiPwd wifi密码
 @param token   token
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)startMonitorWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd token:(NSString *)token success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;


/**
 停止 smartwifi 配网
 */
+ (void)stopMonitor;


/**
 开始 ap 配网

 @param wifiSSID wifi名称
 @param wifiPwd wifi密码
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)startAPConfigureWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Custom Setting
- (void)setDeviceWithParams:(NSDictionary *)params success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- 打洞

/**
 开始连接设备

 @param success 成功回调
 @param failure 失败回调
 */
- (void)startConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 断开设备

 @param success 成功回调
 @param failure 失败回调
 */
- (void)stopConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 获取参数：（码率、模式、静音）

/**
 获取码率

 @return 码率
 */
- (NSString *)getBitrates;

#pragma mark -- 预览

/**
 开始预览设备

 @param playView 播放视图控件
 @param HD 是否高清播放
 @param success 成功回调
 @param failure 失败回调
 @param close 处于休眠模式，镜头关闭，返回值：休眠模式
 */
- (void)startPreviewWithView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;

/**
 开始预览设备
 
 @param playView 播放视图控件
 @param videoStream 视频质量
 @param success 成功回调
 @param failure 失败回调
 @param close 处于休眠模式，镜头关闭，返回值：休眠模式
 */
- (void)startPreviewWithView:(MeariPlayView *)playView videoStream: (MeariDeviceVideoStream)videoStream success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;

/**
 停止预览设备

 @param success 成功回调
 @param failure 失败回调
 */
- (void)stopPreviewSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 切换高清标清

 @param playView 播放视图
 @param HD 是否高清播放
 @param success 成功回调
 @param failure 失败回调
 */
- (void)switchPreviewWithView:(MeariPlayView *)playView videoStream:(MeariDeviceVideoStream)videoStream success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 回放

/**
 获取某月的视频天数

 @param year 年
 @param month 月
 @param success 成功回调，返回值：json数组--[{"date" = "20171228"},...]
 @param failure 失败回调
 */
- (void)getPlaybackVideoDaysWithYear:(NSInteger)year month:(NSInteger)month success:(MeariDeviceSucess_PlaybackDays)success failure:(MeariDeviceFailure)failure;


/**
 获取某天的视频片段

 @param year 年
 @param month 月
 @param day 日
 @param success 成功回调：返回值：json数组--[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
 @param failure 失败回调
 */
- (void)getPlaybackVideoTimesWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MeariDeviceSucess_PlaybackTimes)success failure:(MeariDeviceFailure)failure;


/**
 开始回放录像：同一个设备同一时间只能一个人查看回放录像

 @param playView 播放视图
 @param startTime 开始时间：格式为20171228102035
 @param success 成功回调
 @param failure 失败回调
 */
- (void)startPlackbackWithView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;



/**
 停止回放

 @param success 成功回调
 @param failure 失败回调
 */
- (void)stopPlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 从某时间开始播放：开始回放成功后才能使用此接口，否则会失败

 @param seekTime 开始时间:格式为20171228102035
 @param success 成功回调
 @param failure 失败回调
 */
- (void)seekPlackbackSDCardToTime:(NSString *)seekTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 暂停回放

 @param success 成功回调
 @param failure 失败回调
 */
- (void)pausePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 继续回放

 @param success 成功回调
 @param failure 失败回调
 */
- (void)resumePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 云回放

/**
 获取云回放录像文件

 @param startTime 开始时间
 @param endTime 结束时间
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getCloudVideoWithBegin:(NSDateComponents *)startTime endTime:(NSDateComponents *)endTime success:(void(^)(NSURL *m3u8Url))success failure:(MeariDeviceFailure)failure;
/**
 获取某天的云播放分钟
 
 @param dayComponents   具体日期
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getCloudVideoMinutes:(NSDateComponents *)dayComponents success:(void(^)(NSArray <MeariDeviceTime *> *mins))success failure:(MeariDeviceFailure)failure;

/**
 获取某月的云播放天数
 
 @param monthComponents  具体某月
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getCloudVideoDays:(NSDateComponents *)monthComponents success:(void(^)(NSArray <MeariDeviceTime *> *days))success failure:(MeariDeviceFailure)failure;

#pragma mark -- 静音
/**
 设置静音

 @param muted 是否静音
 */
- (void)setMute:(BOOL)muted;

#pragma mark -- 语音对讲

/**
 获取语音对讲的实时音量

 @return 0-1.0
 */
- (CGFloat)getVoicetalkVolume;


/**
 设置语音对讲类型
 
 @param type 语音对讲类型
 */
- (void)setVoiceTalkType:(MeariVoiceTalkType)type;


/**
 返回当前对讲类型
 */
- (MeariVoiceTalkType)getVoiceTalkType;

/**
 开始语音对讲

 @param success 成功回调
 @param failure 失败回调
 */
- (void)startVoiceTalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 停止语音对讲

 @param success 成功回调
 @param failure 失败回调
 */
- (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 开启双向语音扬声器

 @param enabled 是否开启
 */
- (void)enableLoudSpeaker:(BOOL)enabled;

#pragma mark -- 截图

/**
 截图

 @param path 图片保存的路径
 @param isPreviewing 是否正在预览
 @param success 成功回调
 @param failure 失败回调
 */
- (void)snapshotToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 录像

/**
 开始录像

 @param path 录像保存的路径
 @param isPreviewing 是否正在预览
 @param Interrputed 录像中断
 @param success 成功回调
 @param failure 失败回调
 
 */
- (void)startRecordMP4ToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success recordInterrputed:(MeariDeviceSucess)Interrputed failure:(MeariDeviceFailure)failure;


/**
 停止录像

 @param isPreviewing 是否正在预览
 @param success 成功回调
 @param failure 失败回调
 */
- (void)stopRecordMP4IsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 云台

/**
 开始转动摄像机

 @param direction 转动方向
 @param success 成功回调
 @param failure 失败回调
 */
- (void)startMoveToDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 停止转动摄像机

 @param success 成功回调
 @param failure 失败回调
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
 设置LED
 
 @param on 是否打开LED
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setLEDOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 日夜模式

/**
 设置日夜模式

 @param type 日夜模式
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDayNightMode:(MeariDeviceDayNightType)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 噪声检测

/**
 设置噪声检测
 
 @param level   噪声等级
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDBDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 网络信息

/**
  获取网络信息

 @param success  成功回调 返回值：当前网络信息MeariDeviceParamNetwork
 @param failure  失败回调
 */
- (void)getNetInfoSuccess:(MeariDeviceSucess_NetInfo)success failure:(MeariDeviceFailure)failure;

#pragma mark---  #pragma mark --- 码流H264-H265

/**
 开关h265编码
 
 @param isH265 是否开启h265编码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)switchVideoEncoding:(BOOL)isH265 success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 画面翻转

/**
 获取镜像状态

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getMirrorSuccess:(MeariDeviceSucess_Mirror)success failure:(MeariDeviceFailure)failure;


/**
 设置镜像

 @param open 是否打开镜像
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setMirrorOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 回放设置
/**
 设置回放等级
 
 @param level   回放等级
 MeariDeviceLevelOff:开启全天录像
 MeariDeviceLevelLow:报警时录像 1*60s
 MeariDeviceLevelMedium:报警时录像 2*60s
 MeariDeviceLevelHigh:报警时录像 3*60s
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setPlaybackRecordVideoLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 获取回放等级
 @param success 成功回调 level回放级别
 @param failure 失败回调
 */
- (void)getPlaybackLevelSuccess:(MeariDeviceSucess_PlayBackLevel)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Onvif

/**
 设置Onvif
 @param enable  开关使能
 @param pwd     连接密码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setOnvifEnable:(BOOL)enable password:(NSString *)pwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- 报警

/**
 获取报警信息

 @param success 成功回调，返回值：报警参数信息
 @param failure 失败回调
 */
- (void)getAlarmSuccess:(MeariDeviceSucess_Motion)success failure:(MeariDeviceFailure)failure;


/**
 设置报警级别

 @param level 报警级别
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setAlarmLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
 人形检测

 @param enable 是否开启
 @param bnddrawEnable 人形边框是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setPeopleDetectEnable:(BOOL)enable bnddrawEnable:(BOOL)bnddrawEnable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 哭声检测

 @param enable 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setCryDetectEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 人形跟踪

 @param enable 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setPeopleTrackEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 防拆报警

 @param enable 是否开启
 @param version 影子设备版本
 @param success 成功回调
 @param failure 失败回调
 */
- (void)antiStealWithEnable:(BOOL)enable version:(NSInteger)version success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 存储
/**
 获取存储信息
 
 @param success 成功回调，返回存储信息
 @param failure 失败回调
 */
- (void)getStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;


/**
 获取内存卡格式化百分比

 @param success 成功回调,返回格式化百分比
 @param failure 失败回调
 */
- (void)getFormatPercentSuccess:(MeariDeviceSucess_StoragePercent)success failure:(MeariDeviceFailure)failure;

/**
 格式化内存卡

 @param success 成功回调
 @param failure 失败回道
 */
- (void)formatSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- 固件版本

/**
 获取固件版本

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getVersionSuccess:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;


/**
 获取固件升级百分比

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getUpgradePercentSuccess:(MeariDeviceSucess_VersionPercent)success failure:(MeariDeviceFailure)failure;


/**
 升级固件

 @param url 固件包地址
 @param currentVersion 固件当前版本号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)upgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 设备重启

/**
 设备重启

 @param success 成功回调
 @param failure 失败回调
 */
- (void)rebootDeviceSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark --- 开通云存储

/**
 开通云存储
 
 @param open 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setCloudStorageOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- 参数信息

/**
 获取所有参数

 @param success 成功回调，返回值：设备参数信息
 @param failure 失败回调
 */
- (void)getParamsSuccess:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 休眠模式
/**
 设置休眠模式

 @param type 休眠模式
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setSleepmodeType:(MeariDeviceSleepmode)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置休眠时间段

 @param open 是否开启休眠模式
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
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setSleepmodeTime:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 地理围栏

/**
 设置地理围栏

 @param radius 半径
 @param longitude 经度
 @param latitude 纬度
 @param open 是否开启地理围栏休眠模式
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setHomeLocationWithRadius:(double)radius longitude:(double)longitude latitude:(double)latitude openGeogSleepmode:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure __deprecated_msg("Use `MeariUser -> settingGeographyWithSSID: BSSID: deviceID: success: failure:`");

/**
 上传区域

 @param deviceType 设备类型
 @param timeZone 时区
 @param ID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)uploadRegionWithDeviceType:(MeariDeviceType)deviceType timeZone:(NSTimeZone *)timeZone ID:(NSInteger)ID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 机械铃铛

/**
 开启机械铃铛

 @param open 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setMachineryBellOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 温湿度

/**
 获取温湿度

 @param success 成功回调，返回值：温度和湿度
 @param failure 失败回调
 */
- (void)getTemperatureHumiditySuccess:(MeariDeviceSucess_TRH)success failure:(MeariDeviceFailure)failure;


#pragma mark -- 音乐
/**
 设置播放模式
 
 @param mode 播放模式
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setPlayMusicMode:(MRBabyMusicPlayMode)mode success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");
/**
 播放音乐

 @param musicID 音乐ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)playMusic:(NSString *)musicID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 暂停播放音乐

 @param success 成功回调
 @param failure 失败回调
 */
- (void)pauseMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 继续播放音乐

 @param success 成功回调
 @param failure 失败回调
 */
- (void)resumeMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 播放下一首

 @param success 成功回调
 @param failure 失败回调
 */
- (void)playNextMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 播放前一首

 @param success 成功回调
 @param failure 失败回调
 */
- (void)playPreviousMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 获取音乐状态：包括播放和下载状态

 @param success 成功回调,返回值：json字典
 @param failure 失败回调
 */
- (void)getMusicStateSuccess:(MeariDeviceSucess_MusicStateAll)success failure:(MeariDeviceFailure)failure;


#pragma mark -- 设备音量

/**
 获取设备输出音量

 @param success 成功回调，返回值：设备输出音量，0-100
 @param failure 失败回调
 */
- (void)getOutputVolumeSuccess:(MeariDeviceSucess_Volume)success failure:(MeariDeviceFailure)failure;


/**
 设置设备输出音量

 @param volume 音量，0-100
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setOutputVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- 门铃
/**
 设置门铃输出音量
 
 @param volume 音量
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置门铃PIR(人体侦测)报警类型

 @param level 报警级别
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellPIRLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置门铃低功耗

 @param open 是否打开低功耗模式
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellLowPowerOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置门铃电池锁

 @param open 是否打开电池锁
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellBatteryLockOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 设置门铃使能
 
 @param enable 铃铛使能
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellJingleBellVolumeEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置门铃配置
 
 @param volumeType 铃铛声音等级
 @param selectedSong 选中的铃声
 @param repeatTimes 重复次数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellJingleBellVolumeType:(MeariDeviceLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
 门铃与铃铛配对
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellJingleBellPairingSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 门铃与铃铛解除绑定
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorebllJingleBellUnbindSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置开门
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellDoorOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 设置开锁
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellLockOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置灯状态
 @param on 灯开关使能
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setDoorBellLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 获取铃铛状态

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getDoorebllJingleBellStatusSuccess:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");

#pragma mark -- 录音

/**
 开始留言
 
 @param path 录音文件路径 例如: /var/mobile/Containers/Data/Application/98C4EAB7-D2FF-4519-B732-BEC7DE19D1CE/Documents/audio.wav  注意!!! 文件必须是wav格式
 */
- (void)startRecordAudioToPath:(NSString *)path;

/**
 停止留言

 @param success 成功回调，返回值：录音文件路径
 */
- (void)stopRecordAudioSuccess:(MeariDeviceSucess_RecordAutio)success;

/**
 开始播放主人留言

 @param filePath 录音文件路径 
 @param finished 完成回调
 */
- (void)startPlayRecordedAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

/**
 停止播放主人留言
 */
- (void)stopPlayRecordedAudio;

/**
 设置门铃留言
 
 @param success 成功回调
 @param failure 成功回调
 */
- (void)playMessageSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 语音门铃

/**
 开始播放客人留言
 
 @param filePath 本地语音文件路径
 @param finished 完成回调
 */
- (void)startPlayVoiceMessageAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

/**
 停止播放客人留言
 */
- (void)stopPlayVoiceMessageAudio;

/**
 关闭手机端麦克
 
 @param success 成功回调
 @param failure 成功回调
 */
- (void)pauseVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 开启手机端麦克
 
 @param success 成功回调
 @param failure 成功回调
 */
- (void)resumeVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 升级固件
 
 @param url 固件包地址
 @param latestVersion 最新固件版本号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)upgradeVoiceBellWithUrl:(NSString *)url latestVersion:(NSString *)latestVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;


/**
 设置语音门铃声音
 
 @param volume 0~100
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setVoiceBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置铃铛属性
 
 @param volumeLevel
    静音=MeariDeviceLevelOff
    低=MeariDeviceLevelLow
    中=MeariDeviceLevelMedium
    高=MeariDeviceLevelHigh
 @param durationLevel
    短=MeariDeviceLevelLow
    中=MeariDeviceLevelMedium
    长=MeariDeviceLevelHigh
 @param index   1~10
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setVoiceBellCharmVolume:(MeariDeviceLevel)volumeLevel songDuration:(MeariDeviceLevel)durationLevel songIndex:(NSInteger)index success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 设置访客留言
 
 @param enterTime 按门铃后进入留言时间10/20/30...60s
 @param durationTime 可留言时长10/20/30...60s
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setVoiceBellEnterMessageTime:(NSInteger)enterTime messageDurationTime:(NSInteger)durationTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- 灯具摄像机

/**
 设置灯开关

 @param on 灯开关
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setFlightCameraLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 设置警报开关
 
 @param on 警报开关
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setFlightCameraSiren:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 设置灯具开灯计划

 @param on 是否使能
 @param fromDateStr 开始时间
 @param toDateStr 结束时间
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setFlightCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 设置灯具的移动监测是否亮灯时长

 @param level 不同等级对应的亮灯时间  MeariDeviceLevelNone : 不开灯,MeariDeviceLevelLow : 20s , MeariDeviceLevelMedium : 40s, MeariDeviceLevelHigh: 60s
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setFlightCameraDurationLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 设置灯具的移动监测开关
 
 @param on 是否使能
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setFlightCameraMotionOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

@end
#endif /* MeariDeviceControl_h */
