//
//  WYCamera.h
//  Meari
//
//  Created by 李兵 on 2016/11/25.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ppsplayer.h"
//#import "PPSGLView.h"
#import "WYCameraParams.h"
#import "WYCameraCapability.h"
#import "WYCameraTime.h"
#import "WYCameraSettingSleepmodeTimesModel.h"
#import "WYBabymonitorMusicStateModel.h"

typedef NS_ENUM(NSInteger, WYCameraAddStatus) {
    WYCameraAddStatusSelf = 1,
    WYCameraAddStatusUnShare,
    WYCameraAddStatusNone,
    WYCameraAddStatusShared,
    WYCameraAddStatusSharing
};


typedef NS_ENUM(NSInteger, WYDoorBellPIRLevel) {
    WYDoorBellRLevelOff =0,
    WYDoorBellPIRLevelLow,
    WYDoorBellPIRLevelMedium,
    WYDoorBellPIRLevelHigh,
    WYDoorBellPIRLevelNone,
};
typedef NS_ENUM(NSInteger, WYDoorBellJingleBellStatus) {
    WYDoorBellJingleBellStatuslNone,
    WYDoorBellJingleBellStatusOff,
    WYDoorBellJingleBellStatusOn
};

typedef NS_ENUM(NSInteger, WYDeviceType) {
    WYDeviceTypeCamera,
    WYDeviceTypeNVR,
    WYDeviceTypeBabyMonitor,
    WYDeviceTypeDoorBell
};
typedef NS_ENUM(NSInteger, WYCameraLoadingType) { 
    WYCameraLoadingTypeNone  = 0,
    WYCameraLoadingTypeBegin,
    WYCameraLoadingTypeStop
};
typedef NS_OPTIONS(NSInteger, WYCameraSearchMode) {
    WYCameraSearchModeLan = 1 << 0,
    WYCameraSearchModeCloud_Smartwifi = 1 << 1,
    WYCameraSearchModeCloud_AP = 1 << 2,
    WYCameraSearchModeCloud_QRCode = 1 << 3,
    WYCameraSearchModeCloud = WYCameraSearchModeCloud_Smartwifi | WYCameraSearchModeCloud_AP | WYCameraSearchModeCloud_QRCode,
    WYCameraSearchModeAll = WYCameraSearchModeLan | WYCameraSearchModeCloud,
};
typedef NS_ENUM(NSInteger, WYCameraTokenType) {
    WYCameraTokenTypeSmartwifi,
    WYCameraTokenTypeAP,
    WYCameraTokenTypeQRCode
};
typedef NS_ENUM(NSInteger, WYCameraTRHError) {
    WYCameraTRHErrorNone,
    WYCameraTRHErrorT = 255,
    WYCameraTRHErrorT_no = 256,
    WYCameraTRHErrorRH = 255,
    WYCameraTRHErrorRH_no = 256,
};


@class WYNVRModel;
@class WYBabyMonitorMusicModel;
@class WYBabymonitorMusicStateModel;
@interface WYCamera : WYBaseModel
//服务器数据：展示列表
@property (nonatomic, assign) NSInteger devTypeID;
@property (nonatomic, copy) NSString * devUid;
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, copy) NSString * deviceName;
@property (nonatomic, copy) NSString * deviceP2P;
@property (nonatomic, copy) NSString * deviceImg;
@property (nonatomic, copy) NSString * deviceTypeName;
@property (nonatomic, copy) NSString * deviceUUID;
@property (nonatomic, copy) NSString * deviceVersionID;
@property (nonatomic, assign) NSInteger firmID;
@property (nonatomic, assign) BOOL asFriend;
@property (nonatomic, assign) BOOL hasAlertMsg;
@property (nonatomic, copy) NSString * hostKey;
@property (nonatomic, copy) NSString * isBindingTY;
@property (nonatomic, assign) NSInteger nvrID;
@property (nonatomic, copy) NSString * nvrKey;
@property (nonatomic, assign) NSInteger nvrPort;
@property (nonatomic, copy) NSString * nvrUUID;
@property (nonatomic, copy) NSString * nvrNum;
@property (nonatomic, copy) NSString * snNum;
@property (nonatomic, copy) NSString * timeZone;
@property (nonatomic, copy) NSString * timeZone2;
@property (nonatomic, assign) BOOL updateVersion;
@property (nonatomic, copy) NSString * userAccount;
@property (nonatomic, copy) NSString * userFlag;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *updatePersion;
@property (nonatomic, assign)BOOL needForceUpdate;
//2.2.0
@property (nonatomic, assign)NSInteger devStatus;
@property (nonatomic, assign)NSInteger protocolVersion;
@property (nonatomic, assign)NSInteger closePush;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *radius;
@property (nonatomic, copy) NSString *sleep;
//doorbell
@property (nonatomic, copy) NSString *bellVoice;
//能力集
@property (nonatomic, strong) WYCameraCapability *capability;
@property (nonatomic, assign, readonly) BOOL supportVoiceTalk;
@property (nonatomic, assign, readonly) BOOL supportFullDuplex;

//服务器数据：搜索列表
@property (nonatomic, assign) WYCameraAddStatus addStatus;
@property (nonatomic, copy) NSString * deviceTypeNameGray;

//扩展数据：SDK搜索和扫码
@property (nonatomic, copy)NSString *tp;
@property (nonatomic, copy)NSString *ip;
@property (nonatomic, copy)NSString *gw;
@property (nonatomic, copy)NSString *mask;
@property (nonatomic, copy)NSString *model;

//扩展数据：其它
@property (nonatomic, assign)WYCameraLoadingType loadingType;
@property (nonatomic, assign)WYDeviceType deviceType;
@property (nonatomic, assign)BOOL usableNVR;
@property (nonatomic, assign)BOOL usableSDCard;
@property (nonatomic, assign)BOOL versionIsOld;
@property (nonatomic, copy)NSString *wifiSSID;
@property (nonatomic, copy)NSString *connectName;
@property (nonatomic, assign)NSInteger videoid;
@property (nonatomic, strong)UIImage *thumbImage;
@property (nonatomic, assign)BOOL babyMonitor;
@property (nonatomic, assign)BOOL doorBell;
@property (nonatomic, assign)CGFloat outVolume;
@property (nonatomic, copy)NSString *deviceTokey;
@property (nonatomic, assign)WYUIStytle uistytle;
@property (nonatomic, strong)WYCameraParams *params;
@property (nonatomic, strong)WYCameraParamsMotion *motion;
@property (nonatomic, strong)NSDateComponents *playbackTime;

//扩展数据：SDK相关状态
@property (nonatomic, assign)BOOL sdkOnLine;
@property (nonatomic, assign)BOOL sdkLogined;
@property (nonatomic, assign)BOOL sdkLogining;
@property (nonatomic, assign)BOOL sdkPlaying;
@property (nonatomic, assign)BOOL sdkPlayRecord;
@property (nonatomic, assign)NSInteger sdkVoiceSpeakingCount;


- (instancetype)initWithNVRModel:(WYNVRModel *)model;
- (instancetype)nvrCamera;
- (void)resetPlayer;

+ (instancetype)instanceWithMeariIPC:(MeariIpc *)ipc;
+ (instancetype)instanceWithMeariBell:(MeariBell *)bell;


#pragma mark - SDK
#pragma mark -- 查询在线
- (void)checkOnlineStatusSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 搜索 & 配网
- (void)startSearch:(WYCameraSearchMode)mode success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)stopSearch;
- (void)startMonitorWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure ;
- (void)stopMonitor;
- (void)startAPConfigureWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 打洞
- (void)startConnectSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)stopConnectSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 获取参数：（码率、模式、静音）
- (NSString *)getBitrates;
- (NSString *)getModes;
- (BOOL)getMute;

#pragma mark -- 预览
- (void)startPreviewWithView:(PPSGLView *)playView streamid:(BOOL)HD success:(WYBlock_Void)success failure:(void(^)(BOOL isPlaying))failure close:(void(^)(WYCameraSleepmodeType sleepmodeType))close;
- (void)stopPreviewSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)switchPreviewWithView:(PPSGLView *)playView streamid:(BOOL)HD success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 回放
- (void)searchPlaybackVideoDaysInMonth:(NSDateComponents *)month success:(void(^)(NSArray<WYCameraTime *>*videoDays))success empty:(WYBlock_Void)empty failure:(WYBlock_Error_Str)failure;
- (void)searchPlaybackVideoTimesInDay:(NSDateComponents *)day success:(void(^)(NSArray<WYCameraTime *>*videoTimes))success empty:(WYBlock_Void)empty failure:(WYBlock_Error_Str)failure;

- (void)startPlackbackSDCardWithView:(PPSGLView *)playView startTime:(NSString *)startTime success:(WYBlock_Void)success failure:(void(^)(BOOL isPlaying))failure otherPlaying:(WYBlock_Void)otherPlaying;
- (void)stopPlackbackSDCardSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)seekPlackbackSDCardToTime:(NSString *)seekTime success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)pausePlackbackSDCardSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)resumePlackbackSDCardSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 静音
- (CGFloat)getVoiceVolume;
- (void)enableMute:(BOOL)muted;

#pragma mark -- 语音对讲
- (void)startVoicetalkSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)stopVoicetalkSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 截图
- (void)snapshotToPathInDocument:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)snapshotToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 录像
- (void)startRecordMP4ToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)stopRecordMP4IsPreviewing:(BOOL)isPreviewing success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 云台
- (void)startPTZ:(NSInteger)ps ts:(NSInteger)ts zs:(NSInteger)zs success:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;
- (void)stopPTZSuccess:(WYBlock_Void)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- 缩放、平移
- (int)zoom:(float)scale POS_X:(float)x POS_Y:(float)y;
- (int)move:(float)x_len Y_LENGHT:(float)y_len;

#pragma mark -- 设置（镜像、报警、格式化、版本升级）
- (void)getVersionSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)getMirrorSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)getAlarmSuccesss:(void(^)(WYCameraParamsMotion *motion))success failure:(WYBlock_Error_Str)failure;
- (void)getSDCardInfoSuccesss:(void(^)(BOOL suc, NSString *info, BOOL isFormatting))success failure:(WYBlock_Error_Str)failure ;
- (void)getUpgradePercentSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)getFormatPercentSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;

- (void)setMirrorOpen:(BOOL)open successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setAlarmLevel:(WYCameraMotionLevel)level successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)formatSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)upgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure isUpgrading:(WYBlock_Void)isUpgrading upgradLimit:(WYBlock_Void)limit;


#pragma mark -- home模式(2.1.x版本新增)
+ (NSDictionary *)homeDictionaryWithEnable:(BOOL)enable startTime:(NSString *)startTime stopTime:(NSString *)stopTime repeatWeekdays:(NSArray *)weekdays;
- (void)setHomeTimes:(NSArray<WYCameraSettingSleepmodeTimesModel *> *)homeTimes openTimeSleepmode:(BOOL)openTimeSleepmode successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)getHomeTimeSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;

#pragma mark -- babymonitor(2.2.0版本新增)
- (void)getParamsSuccesss:(void(^)(WYCameraParams *params))success failure:(WYBlock_Error_Str)failure;
- (void)getStorageSuccesss:(void(^)(BOOL hasSDCard))success failure:(WYBlock_Error_Str)failure;
- (void)getSleepmodeSuccesss:(void(^)(WYCameraParams *params))success failure:(WYBlock_Error_Str)failure;
- (void)setSleepmodeType:(WYCameraSleepmodeType)type successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)getTemp_HumiditySuccesss:(void(^)(CGFloat temp, CGFloat humidity, WYCameraTRHError tempError, WYCameraTRHError humidityError))success failure:(WYBlock_Error_Str)failure;

- (void)playMusic:(NSString *)musicID successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)playCurrentMusicSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)pauseMusicSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)playNextSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)playPreviousSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)getCurrentMusicStateSuccesss:(void(^)(WYBabyMonitorMusicModel *music))success failure:(WYBlock_Error_Str)failure;
- (void)getMusicStateSuccesss:(void(^)(WYBabymonitorMusicStateModel *musicState))success failure:(WYBlock_Error_Str)failure;
- (void)setMusicMode:(WYBabymonitorMusicPlayMode)mode successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;

- (void)volumeGetOutputSuccesss:(void(^)(NSInteger volume))success failure:(WYBlock_Error_Str)failure;
- (void)volumeSetOutput:(NSInteger)volume successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)volumeGetInputSuccesss:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)volumeSetInput:(id)input successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;

- (void)updatetoken:(NSString *)token type:(WYCameraTokenType)type;

#pragma mark -- doorBell 
- (void)setDoorBellPIRLevel:(WYDoorBellPIRLevel)level successs:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setDoorBellVolume:(NSInteger)volume success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setDoorBellLowPowerOpen:(BOOL)open success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setDoorBellBatteryLockOpen:(BOOL)open success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setDoorBellJingleBellVolumeOpen:(BOOL)open success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setDoorBellJingleBellVolumeType:(WYDoorBellJingleBellVolumeLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setDoorbellPlayHostMessageSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure ;
- (void)setDoorebllJingleBellPairSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)getDoorebllJingleBellStatusSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setDoorebllJingleBellUnbindSuccess:(WYBlock_ID)success failure:(WYBlock_Error_Str)failure;
- (void)setAutoDisconnectTaskOpen:(BOOL)open ;
- (void)setSpeechMode:(SPEECH_MODE)speechMode ;

- (void)startRecordWavToPath:(NSString *)path;
- (void)stopRecordSuccess:(WYBlock_Str)filePath;
- (void)startPlayWavAudioWithPath:(NSString *)audioPath finished:(WYBlock_Void)finished;
- (void)stopPlayWavAudio;
- (void)setFullDuplexLoudSpeaker:(BOOL)enable;
@end


@interface NSDictionary (WYCamera)

+ (NSMutableDictionary *)wy_dictionaryWithAction:(NSString *)action deviceurl:(NSString *)deviceurl;
+ (NSMutableDictionary *)wy_dictionaryWithGET_deviceurl:(NSString *)deviceurl;
+ (NSMutableDictionary *)wy_dictionaryWithPOST_deviceurl:(NSString *)deviceurl;

@end
