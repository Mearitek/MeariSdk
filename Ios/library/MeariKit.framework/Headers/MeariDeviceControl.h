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
typedef void(^MeariDeviceSucess_HostMessages)(NSArray *systemsArray,NSArray *customArray);
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

/**
 VoiceTalk Type
 
 - MeariVoiceTalkTypeOneWay: One-way speech
 - MeariVoiceTalkTypeFullDuplex: Two-way intercom
 */
typedef NS_ENUM(NSInteger, MeariVoiceTalkType) {
    MeariVoiceTalkTypeOneWay,
    MeariVoiceTalkTypeFullDuplex,
};

/**
 Device lens movement direction
 
 - MeariMoveDirectionUp: Move up
 - MeariMoveDirectionDown: Move down
 - MeariMoveDirectionLeft: Move left
 - MeariMoveDirectionRight: Move right
 */
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
 Reset playback resources
   */
- (void)reset;
/**
 Get the hole type
 */
- (MeariDeviceConnectType)getP2pMode;
#pragma mark -- Query online

/*
 @param completion whether is online
 */
- (void)getOnlineStatus:(MeariDeviceSucess_Online)completion;

#pragma mark -- Search & Config(Manual)

/**
 Start search: suitable for SmartWiFi distribution network and AP distribution network
 
 @param success Successful callback: return to the search device
 @param failure return error
 */
+ (void)startSearch:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 Start search: only for QR code code distribution networks
 
 @param token QR code token
 @param success Successful callback: return to the search device
 @param failure return error
 */
+ (void)startSearchWithQRcodeToken:(NSString *)token success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 Update token
 
 @param token Distribution network token
 @param type Device search type
 */
+ (void)updatetoken:(NSString *)token type:(MeariDeviceTokenType)type ;

/**
 Start search: search universal interfaces
 Ensure that the updatetoken method is invoked when using this interface.
 @param mode Distribution network mode
 @param success Successful callback: return to the search device
 @param failure return error
 */
+ (void)startSearch:(MeariDeviceSearchMode)mode success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

/**
 Stop search
 */
+ (void)stopSearch;


/**
 Start smartwifi distribution networks
 
 @param wifiSSID wifi name
 @param wifiPwd wifi password
 @param token   token
 @param success Successful callback
 @param failure return error
 */
+ (void)startMonitorWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd token:(NSString *)token success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;


/**
 Stop smartwifi distribution networks
 */
+ (void)stopMonitor;


/**
 Start ap distribution networks
 
 @param wifiSSID wifi name
 @param wifiPwd wifi password
 @param success Successful callback
 @param failure return error
 */
+ (void)startAPConfigureWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark --- Custom Setting
- (void)setDeviceWithParams:(NSDictionary *)params success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- Connect

/**
 Conect device is the first step to control device.
 
 @param success
 @param failure return error
 */
- (void)startConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Disconnect device:If device need not using ,you should disconnect the device
 
 @param success
 @param failure return error
 */
- (void)stopConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Get bitrate

/**
 Get bitrate
 
 @return bitrate
 */
- (NSString *)getBitrates;

#pragma mark -- Preview

/**
 start Device Preview
 
 @param HD whether is HD or SD
 @param success
 @param failure return error
 @param close return sleepmode, see MeariDeviceSleepmode, device is in sleep
 */
- (void)startPreviewWithView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;

/**
 Start preview
 
 @param playView  play view
 @param videoStream Video quality
 @param success
 @param failure return error
 @param close In sleep mode, the lens is off, return value: sleep mode
 */
- (void)startPreviewWithView:(MeariPlayView *)playView videoStream: (MeariDeviceVideoStream)videoStream success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;

/**
 Stop preview
 
 @param success
 @param failure  return error
 */
- (void)stopPreviewSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Switch preview charity
 
 @param playView play view
 @param videoStream stream
 @param success
 @param failure return error
 */
- (void)switchPreviewWithView:(MeariPlayView *)playView videoStream:(MeariDeviceVideoStream)videoStream success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Playback

/**
 Get video days
 
 @param year year
 @param month month
 @param success return video days in json array:--[{"date" = "20171228"},...]
 @param failure return error
 */
- (void)getPlaybackVideoDaysWithYear:(NSInteger)year month:(NSInteger)month success:(MeariDeviceSucess_PlaybackDays)success failure:(MeariDeviceFailure)failure;


/**
 Get video times
 
 @param year year
 @param month month
 @param day day
 @param success return video times in json array--[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
 @param failure return error
 */
- (void)getPlaybackVideoTimesWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MeariDeviceSucess_PlaybackTimes)success failure:(MeariDeviceFailure)failure;


/**
 Start playback: one person only allowed at same time
 
 @param playView play view
 @param startTime start time：--20171228102035
 @param success
 @param failure return error
 */
- (void)startPlackbackWithView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;



/**
 Stop playback
 
 @param success
 @param failure return error
 */
- (void)stopPlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Seek playbck: only available after start playback success
 
 @param seekTime start time:20171228102035
 @param success
 @param failure return error
 */
- (void)seekPlackbackSDCardToTime:(NSString *)seekTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Pause playback
 
 @param success
 @param failure return error
 */
- (void)pausePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Resume playbck
 
 @param success
 @param failure return error
 */
- (void)resumePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- cloud

/**
 Get cloud playback video files
 
 @param startTime startTime(NSDateComponents *)
 @param endTime endTime(NSDateComponents *)
 @param success success
 @param failure return error
 */
- (void)getCloudVideoWithBegin:(NSDateComponents *)startTime endTime:(NSDateComponents *)endTime success:(void(^)(NSURL *m3u8Url))success failure:(MeariDeviceFailure)failure;
/**
 Get the cloud play time of a day
 
 @param dayComponents   time(NSDateComponents *),Used to get specific time
 @param success success
 @param failure failure
 */
- (void)getCloudVideoMinutes:(NSDateComponents *)dayComponents success:(void(^)(NSArray <MeariDeviceTime *> *mins))success failure:(MeariDeviceFailure)failure;

/**
 Get the cloud play time of a month
 
 @param monthComponents  obtain month(NSDateComponents *)
 @param success success
 @param failure failure
 
 */
- (void)getCloudVideoDays:(NSDateComponents *)monthComponents success:(void(^)(NSArray <MeariDeviceTime *> *days))success failure:(MeariDeviceFailure)failure;

#pragma mark -- muted
/**
 set mute
 
 @param muted whether to mute
 */
- (void)setMute:(BOOL)muted;

#pragma mark -- Voice speaking

/**
 Get real volume duaring voice speaking.
 
 @return 0-1.0
 */
- (CGFloat)getVoicetalkVolume;


/**
 Set voicetalk type, see MeariVoiceTalkType
 
 @param type voice talk type
 */
- (void)setVoiceTalkType:(MeariVoiceTalkType)type;

/**
 return voiceType
*/
- (MeariVoiceTalkType)getVoiceTalkType;

/**
 Start voice talk
 @param success
 @param failure return error
 */
- (void)startVoiceTalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Stop voice talk
 
 @param success
 @param failure return error
 */
- (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Enable full duplex speaker
 
 @param enabled
 */
- (void)enableLoudSpeaker:(BOOL)enabled;

#pragma mark -- Snapshot

/**
 Snapshot
 
 @param path picture's path for saving
 @param isPreviewing current is preview or playback
 @param success
 @param failure return error
 */
- (void)snapshotToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Record

/**
 Start record
 
 @param path video's path for saving
 @param isPreviewing current is preview or playback
 @param recordInterrputed  Interrputed
 @param success
 @param failure return error
 */
- (void)startRecordMP4ToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success recordInterrputed:(MeariDeviceSucess)Interrputed failure:(MeariDeviceFailure)failure;


/**
 Stop record
 
 @param isPreviewing current is preview or playback
 @param success
 @param failure return error
 */
- (void)stopRecordMP4IsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- PTZ

/**
 Start move
 
 @param direction direction
 @param success
 @param failure return error
 */
- (void)startMoveToDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Stop move
 
 @param success
 @param failure return error
 */
- (void)stopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- LED
/**
 Get LED status
 
 @param success success
 @param failure return error
 */
- (void)getLEDSuccess:(MeariDeviceSucess_LED)success failure:(MeariDeviceFailure)failure;

/**
 Set LED
 
 @param on open LED
 @param success success
 @param failure return error
 */
- (void)setLEDOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Day night mode

/**
 Set  Day night mode
 
 @param type mode
 @param success success
 @param failure return error
 */
- (void)setDayNightMode:(MeariDeviceDayNightType)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark --  Noise detection

/**
 Set Noise detection
 
 @param level   Noise level
 @param success success
 @param failure return error
 */
- (void)setDBDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- NetInfo

/**
 Get NetInfo
 
 @param success  return MeariDeviceParamNetwork
 @param failure  return error
 */
- (void)getNetInfoSuccess:(MeariDeviceSucess_NetInfo)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Mirror

/**
 switch h265
 
 @param isH265 enable h265
 @param success success
 @param failure return error
 */
- (void)switchVideoEncoding:(BOOL)isH265 success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Get mirror status

/**
 Get mirror status
 
 @param success return yes or no
 @param failure return error
 */
- (void)getMirrorSuccess:(MeariDeviceSucess_Mirror)success failure:(MeariDeviceFailure)failure;


/**
 Set mirror
 
 @param open open mirror
 @param success success
 @param failure return error
 */
- (void)setMirrorOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- playback set
/**
 Playback level (the sdcard recording time)
 
 @param level   playback level
 MeariDeviceLevelOff: open all-day-record
 MeariDeviceLevelLow: 1*60s
 MeariDeviceLevelMedium: 2*60s
 MeariDeviceLevelHigh: 3*60s
 @param success success
 @param failure return error
 
 */
- (void)setPlaybackRecordVideoLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Get playback level
 @param success return playback level
 @param failure return error
 
 */
- (void)getPlaybackLevelSuccess:(MeariDeviceSucess_PlayBackLevel)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Onvif

/**
 Set Onvif
 @param enable  enable
 @param pwd     password
 @param success success
 @param failure return error
 */


- (void)setOnvifEnable:(BOOL)enable password:(NSString *)pwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- alarm

/**
 Get alarm info
 
 @param success return MeariDeviceParamMotion
 @param failure return error
 */
- (void)getAlarmSuccess:(MeariDeviceSucess_Motion)success failure:(MeariDeviceFailure)failure;


/**
 Set alarm level
 
 @param level  Set alarm level
 @param success
 @param failure return error
 */
- (void)setAlarmLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
 PeopleDetect and  bnddrawEnable Enable
 
 @param enable detect Enable
 @param bnddrawEnable bnddraw enable
 @param success return success
 @param failure return error
 */
- (void)setPeopleDetectEnable:(BOOL)enable bnddrawEnable:(BOOL)bnddrawEnable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Cry detect enable
 
 @param enable set detect enable
 @param success return success
 @param failure return error
 */
- (void)setCryDetectEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 People track
 
 @param enable set track enable
 @param success return success
 @param failure return error
 */
- (void)setPeopleTrackEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 Anti steal Alarm
 
 @param enable set anti steal enable
 @param version version
 @param success return success
 @param failure return error
 */
- (void)antiStealWithEnable:(BOOL)enable version:(NSInteger)version success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Storage
/**
 Get storage information
 
 @param success return storage information
 @param failure return error
 */
- (void)getStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;


/**
 Get storage format percent
 
 @param success return format percent
 @param failure return error
 */
- (void)getFormatPercentSuccess:(MeariDeviceSucess_StoragePercent)success failure:(MeariDeviceFailure)failure;

/**
 Format storage
 
 @param success
 @param failure
 */
- (void)formatSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- Firmware

/**
 Get firmware information
 
 @param success return firmware information
 @param failure return error
 */
- (void)getVersionSuccess:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;


/**
 Get firmware update percent
 
 @param success return update percent
 @param failure return error
 */
- (void)getUpgradePercentSuccess:(MeariDeviceSucess_VersionPercent)success failure:(MeariDeviceFailure)failure;


/**
 Update firmware
 
 @param url firmware's url
 @param currentVersion current firmware
 @param success
 @param failure return error
 */
- (void)upgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- device restart

/**
 Device restart
 
 @param success
 @param failure return error
 */
- (void)rebootDeviceSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark --- Open cloud storage

/**
 Open cloud storage
 @param open open
 @param success success
 @param failure failure
 */
- (void)setCloudStorageOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

#pragma mark -- Params info

/**
 Get all params
 
 @param success return params
 @param failure return error
 */
- (void)getParamsSuccess:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Sleepmode
/**
 Set sleepmode type
 
 @param type sleepmode type
 @param success
 @param failure return error
 */
- (void)setSleepmodeType:(MeariDeviceSleepmode)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 set sleepmode
 
 @param open  whether to open
 @param times Sleep time period: The array contains MeariDeviceParamSleepTime, for example, the format of MeariDeviceParamSleepTime is as follows
                           {
                           Enable = 1;
                           Repeat = (
                                   1,
                                   2
                                         );
                           "start_time" = "00:00";
                           "stop_time" = "10:00";
 },
 @param success
 @param failure return error
 */
- (void)setSleepmodeTime:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- Geofence

/**
 Set Geofence to open sleep mode
 
 @param radius radius
 @param longitude longitude
 @param latitude latitude
 @param open whether to open Geofence
 @param success success
 @param failure return error
 */
- (void)setHomeLocationWithRadius:(double)radius longitude:(double)longitude latitude:(double)latitude openGeogSleepmode:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure __deprecated_msg("Use `MeariUser -> settingGeographyWithSSID: BSSID: deviceID: success: failure:`");

/**
 upload Region
 
 @param deviceType deviceType
 @param timeZone timeZone
 @param ID device's ID
 @param success success
 @param failure return error
 */
- (void)uploadRegionWithDeviceType:(MeariDeviceType)deviceType timeZone:(NSTimeZone *)timeZone ID:(NSInteger)ID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Machinery Bell

/**
 open Machinery Bell
 
 @param open open
 @param success success
 @param failure failure
 */
- (void)setMachineryBellOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- Temperature Humidity

/**
 Get temperature humidity
 
 @param success return MeariDeviceSucess_TRH
 @param failure failure
 */
- (void)getTemperatureHumiditySuccess:(MeariDeviceSucess_TRH)success failure:(MeariDeviceFailure)failure;


#pragma mark -- music
/**
 Set play mode
 
 @param mode play mode
 @param success success
 @param failure failure
 */
- (void)setPlayMusicMode:(MRBabyMusicPlayMode)mode success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");
/**
 Play music
 
 @param musicID song id
 @param success
 @param failure return error
 */
- (void)playMusic:(NSString *)musicID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Pause music
 
 @param success
 @param failure return error
 */
- (void)pauseMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Resume music
 
 @param success
 @param failure return error
 */
- (void)resumeMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Play next song
 
 @param success
 @param failure return error
 */
- (void)playNextMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Play previous song
 
 @param success
 @param failure return error
 */
- (void)playPreviousMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Get all songs's status, include download percent, whether is playing
 
 @param success return json Dictionary
 @param failure return error
 */
- (void)getMusicStateSuccess:(MeariDeviceSucess_MusicStateAll)success failure:(MeariDeviceFailure)failure;


#pragma mark -- Volume

/**
 Get device's output volume
 
 @param success return volume, 0-100
 @param failure return error
 */
- (void)getOutputVolumeSuccess:(MeariDeviceSucess_Volume)success failure:(MeariDeviceFailure)failure;


/**
 Set device's output volume
 
 @param volume 0-100
 @param success
 @param failure return error
 */
- (void)setOutputVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- Bell
/**
 Set bell's output volume
 
 @param volume volume, 0-100
 @param success
 @param failure return error
 */
- (void)setDoorBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set pir alarm level
 
 @param level alarm level
 @param success
 @param failure return error
 */
- (void)setDoorBellPIRLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set lowpower mode
 
 @param open whether open lowpower mode or not
 @param success
 @param failure return error
 */
- (void)setDoorBellLowPowerOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set battery lock
 
 @param open whether open battery lock or not
 @param success
 @param failure return error
 */
- (void)setDoorBellBatteryLockOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 Set Doorbell enable
 
 @param enable whether to open
 @param success
 @param failure return error
 */
- (void)setDoorBellJingleBellVolumeEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Bell configuration
 
 @param volumeType Bell sound level
 @param selectedSong Selected ringtone
 @param repeatTimes repeat times
 @param success
 @param failure return error
 */
- (void)setDoorBellJingleBellVolumeType:(MeariDeviceLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

/**
 Doorbell pairing bell
 
 @param success
 @param failure return error
 */
- (void)setDoorBellJingleBellPairingSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Doorbell untie the bell
 
 @param success
 @param failure return error
 */
- (void)setDoorebllJingleBellUnbindSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Open Doorbell
 @param success
 @param failure return error
 
 */
- (void)setDoorBellDoorOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 Lock Doorbell
 
 @param success
 @param failure return error
 */
- (void)setDoorBellLockOpenSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set Doorbell Light On
 @param on whether to open
 @param success
 @param failure return error
 */
- (void)setDoorBellLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Get Doorbell status
 
 @param success
 @param failure return error
 */
- (void)getDoorebllJingleBellStatusSuccess:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure __deprecated_msg("This method is unavailable temporarily");

#pragma mark -- Record
/**
 start record hostmessage
 
 @param path file must be .wav format e.g. /var/mobile/Containers/Data/Application/98C4EAB7-D2FF-4519-B732-BEC7DE19D1CE/Documents/audio.wav  
 */
- (void)startRecordAudioToPath:(NSString *)path;

/**
 Stop record audio
 
 @param success return voice's audio file path
 */
- (void)stopRecordAudioSuccess:(MeariDeviceSucess_RecordAutio)success;

/**
 Start play audio
 
 @param filePath audio file path
 @param finished
 */
- (void)startPlayRecordedAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

/**
 Stop play audio
 */
- (void)stopPlayRecordedAudio;

/**
 Play voice message
 
 @param success
 @param failure return error
 */
- (void)playMessageSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


#pragma mark -- Voice doorbell

/**
 start play recored
 
 @param filePath local path
 @param finished complete
 */
- (void)startPlayVoiceMessageAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

/**
 Stop playing the doorbell message
 */
- (void)stopPlayVoiceMessageAudio;


#pragma mark -- voice bell
/**
 Set the voice doorbell to pause the intercom
  
 @param success Successful callback
 @param failure Successful callback
 */
- (void)pauseVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set the voice doorbell to start the intercom
  
 @param success Successful callback
 @param failure Successful callback
 */
- (void)resumeVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Upgrade firmware
  
 @param url firmware package address
 @param latestVersion latest firmware version number
 @param success Successful callback
 @param failure failure callback
 */
- (void)upgradeVoiceBellWithUrl:(NSString *)url latestVersion:(NSString *)latestVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;


/**
 Set the voice doorbell sound
  
  @param volume 0~100
  @param success Successful callback
  @param failure failure callback
 */
- (void)setVoiceBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set the bell properties
  
   @param volumeLevel
      Mute = MeariDeviceLevelOff
      Low = MeariDeviceLevelLow
      Medium = MeariDeviceLevelMedium
      High=MeariDeviceLevelHigh
   @param durationLevel
      Short = MeariDeviceLevelLow
      Medium = MeariDeviceLevelMedium
      Long = MeariDeviceLevelHigh
   @param index 1~10
   @param success Successful callback
   @param failure failure callback
 */
- (void)setVoiceBellCharmVolume:(MeariDeviceLevel)volumeLevel songDuration:(MeariDeviceLevel)durationLevel songIndex:(NSInteger)index success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Set guest message
  
 @param enterTime Press the doorbell to enter the message time 10/20/30...60s
  @param durationTime Message length 10/20/30...60s
  @param success Successful callback
  @param failure failure callback
 */
- (void)setVoiceBellEnterMessageTime:(NSInteger)enterTime messageDurationTime:(NSInteger)durationTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

#pragma mark -- FlightCamera/FloodCamera

/**
 Open FlightCamera Light On
 
 @param on whether to open
 @param success  Successful callback
 @param failure failure callback
 */
- (void)setFlightCameraLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 Open siren
 
 @param on whether to open
 @param success Successful callback
 @param failure failure callback
 */
- (void)setFlightCameraSiren:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

/**
 Set Schedule
 
 @param on whether to open
 @param fromDateStr time like:  00:01
 @param toDateStr time like:  12:21
 @param success Successful callback
 @param failure failure callback
 */
- (void)setFlightCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


/**
 Set up the movement monitoring of the luminaire
 
   @param on Is it enabled?
   @param level The lighting time for different levels MeariDeviceLevelLow : 20s , MeariDeviceLevelMedium : 40s, MeariDeviceLevelHigh: 60s
   @param success Successful callback
   @param failure failure callback
 */
- (void)setFlightCameraDurationLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
/**
 Switch h265 code stream
 
   @param isH265 Whether to enable h265 stream
   @param success Successful callback
   @param failure failure callback
 */
- (void)setFlightCameraMotionOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

@end
#endif /* MeariDeviceControl_h */
