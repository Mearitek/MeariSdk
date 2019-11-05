//
//  MeariEnum.h
//  MeariKit
//
//  Created by Meari on 2017/12/15.
//  Copyright © 2017年 Meari. All rights reserved.
//

#ifndef MeariEnum_h
#define MeariEnum_h


/**
 Server environment

 - MearEnvironmentRelease: release
 - MearEnvironmentPrerelease: prerelease
 */
typedef NS_ENUM(NSInteger, MearEnvironment) {
    MearEnvironmentRelease,
    MearEnvironmentPrerelease
};


/**
 Log flag

 - MeariLogFlagError: error
 - MeariLogFlagWarning: warning
 - MeariLogFlagInfo: info
 - MeariLogFlagDebug: debug
 - MeariLogFlagVerbose: verbose
 */
typedef NS_ENUM(NSInteger, MeariLogFlag) {
    MeariLogFlagError      = 1 << 0,
    MeariLogFlagWarning    = 1 << 1,
    MeariLogFlagInfo       = 1 << 2,
    MeariLogFlagDebug      = 1 << 3,
    MeariLogFlagVerbose    = 1 << 4,
};
typedef NS_ENUM(NSInteger, MeariLogLevel) {
    MeariLogLevelOff       = 0,
    MeariLogLevelError     = MeariLogFlagError,
    MeariLogLevelWarning   = MeariLogFlagWarning | MeariLogLevelError,
    MeariLogLevelInfo      = MeariLogFlagInfo    | MeariLogLevelWarning,
    MeariLogLevelDebug     = MeariLogFlagDebug   | MeariLogLevelInfo,
    MeariLogLevelVerbose   = MeariLogFlagVerbose | MeariLogLevelDebug,
};



/**
 Error code for User's interface

 - MeariUserCodeUnKnown: unkown error
 - MeariUserCodeNetworkUnavailable : network is unavailable!
 - MeariUserCodeAppKeyNone : App Key is null!
 - MeariUserCodeAppSecretNone : App secret is null!
 - MeariUserCodeAppParameterError : App passed wrong parameter!
 - MeariUserCodeSuccess : success
 - MeariUserCodeFail : failure
 - MeariUserCodeParameterNull : parameter is empty
 - MeariUserCodeRequestError : illegal request
 - MeariUserCodeSystemError : system exception
 - MeariUserCodeDataBaseError : database exception
 - MeariUserCodeDataNotExist : data not exist
 - MeariUserCodeVerCodeError : verification code error
 - MeariUserCodeVerCodeOvertime : verification code timeout
 - MeariUserCodeIsFriends : friend does exist
 - MeariUserCodeWaitForDealing : message will be processing
 - MeariUserCodeDealOK : message is processing
 - MeariUserCodeDeviceIsExist : device already exist
 - MeariUserCodeHasReadMsg : message already read
 - MeariUserCodeHasUnReadMsg : message unread
 - MeariUserCodeShare : device is sharing
 - MeariUserCodePasswordError : password error
 - MeariUserCodeAccountNotExist : account not exist
 - MeariUserCodeAccountIsRegistered : account existed
 - MeariUserCodePasswordCorrect : password correct
 - MeariUserCodeDeviceAdded : the adding device is owned by yourself
 - MeariUserCodeCanNotAddSelf : the adding friend is yourself
 - MeariUserCodeUserTokeyMissing : user token exception ⚠️ you  must login again when see this error
 - MeariUserCodeFriendAlreadyAddYou : need to process messages
 - MeariUserCodeCloudMoneyError : money data error
 - MeariUserCodeCloudOrderOverdue : the order is expired
 - MeariUserCodeCloudOrderDataError : the order data error
 - MeariUserCodeCloudNotPay : the order is not paid
 - MeariUserCodeCloudIsTried : service on trail
 - MeariUserCodeSourceAppError : device version is not machted with app version
 - MeariUserCodeEmailNotExist : the email address not exist
 - MeariUserCodeBindingTooMore : exceed the maximum of ipc count, for nvr
 - MeariUserCodeNoPermission : no permission
 - MeariUserCodeDeviceOffline : device offline
 - MeariUserCodeDeviceOnline : device online
 - MeariUserCodeQrcodeLoginOvertime : qrcode login timeout
 - MeariUserCodeDSTError : daylight information error
 - MeariUserCodeGetCodeFrequent : the verification code sending error, too frequency, etc
 - MeariUserCodeIsNotFriend : not friend
 - MeariUserCodeTuyaTokenError : tuya token error
 - MeariUserCodeUserChanged : the user changed
 - MeariUserCodeIotOffline : iot Device offline
 */
typedef NS_ENUM(NSInteger, MeariUserCode) {
    MeariUserCodeUnKnown                = 0,
    MeariUserCodeNetworkUnavailable     = -100,
    MeariUserCodeAppKeyNone             = -200,
    MeariUserCodeAppSecretNone          = -201,
    MeariUserCodeAppParameterError      = -202,
    MeariUserCodeLocalNotExist          = -203,
    MeariUserCodeSuccess                = 1001,
    MeariUserCodeFail                   = 1002,
    MeariUserCodeParameterNull          = 1003,
    MeariUserCodeRequestError           = 1004,
    MeariUserCodeSystemError            = 1005,
    MeariUserCodeDataBaseError          = 1006,
    MeariUserCodeDataNotExist           = 1007,
    MeariUserCodeVerCodeError           = 1008,
    MeariUserCodeVerCodeOvertime        = 1009,
    MeariUserCodeIsFriends              = 1010,
    MeariUserCodeWaitForDealing         = 1011,
    MeariUserCodeDealOK                 = 1012,
    MeariUserCodeDeviceIsExist          = 1013,
    MeariUserCodeHasReadMsg             = 1014,
    MeariUserCodeHasUnReadMsg           = 1015,
    MeariUserCodeShare                  = 1016,
    MeariUserCodePasswordError          = 1017,
    MeariUserCodeAccountNotExist        = 1018,
    MeariUserCodeAccountIsRegistered    = 1019,
    MeariUserCodePasswordCorrect        = 1020,
    MeariUserCodeDeviceAdded            = 1021,
    MeariUserCodeCanNotAddSelf          = 1022,
    MeariUserCodeUserTokeyMissing       = 1023,
    MeariUserCodeFriendAlreadyAddYou    = 1024,
    MeariUserCodeCloudMoneyError        = 1025,
    MeariUserCodeCloudOrderOverdue      = 1026,
    MeariUserCodeCloudOrderDataError    = 1027,
    MeariUserCodeCloudNotPay            = 1028,
    MeariUserCodeCloudIsTried           = 1029,
    MeariUserCodeSourceAppError         = 1030,
    MeariUserCodeEmailNotExist          = 1031,
    MeariUserCodeBindingTooMore         = 1032,
    MeariUserCodeNoPermission           = 1033,
    MeariUserCodeDeviceOffline          = 1035,
    MeariUserCodeDeviceOnline           = 1036,
    MeariUserCodeQrcodeLoginOvertime    = 1037,
    MeariUserCodeDSTError               = 1038,
    MeariUserCodeGetCodeFrequent        = 1039,
    MeariUserCodeIsNotFriend            = 1040,
    MeariUserCodeTuyaTokenError         = 1041,
    MeariUserCodeUserChanged            = 1042,
    MeariUserCodeDoorbellAnswering      = 1045,
    MeariUserCodeNotDoorbell            = 1046,
    MeariUserCodeDoorbellNoHangupAuth   = 1047,
    MeariUserCodeNotExistInRegion       = 1048,
    MeariUserCodeDeviceCancelShared     = 1050,
    MeariUserCodeCloudOrderHasPaid      = 1051,
    MeariUserCodeCloudOrderPaidFailed   = 1052,
    MeariUserCodeDeviceNotAuthorize     = 1057,
    MeariUserCodeDeviceHasAdded         = 1059,
    MeariUserCodeDataUpgrading          = 1064,
    MeariUserCodeIotOffline             = 1066,
    MeariUserCodeVerificationExpired    = 1067,
    MeariUserCodeVerificationError      = 1068,
};


/**
 Error code for Device's interface

 - MeariDeviceCodeUnknown: unknown error
 - MeariDeviceCodeGeneralError: general communication error
 - MeariDeviceCodeNotJson: result data is not json
 - MeariDeviceCodeParamError: You passed the wrong param!
 - MeariDeviceCodeConnectIsConnecting: device is connecting
 - MeariDeviceCodeConnectPasswordError: use wrong password to connect device
 - MeariDeviceCodeConnectOffline: device is offline
 - MeariDeviceCodeConnectDisconnected: device is been disconnected
 - MeariDeviceCodePreviewIsPlaying: device is previewing
 - MeariDeviceCodePlaybackIsPlaying: device is playbacking
 - MeariDeviceCodePlaybackIsPlayingByOthers: device is playbacking by other people
 - MeariDeviceCodeVersionIsUpgrading: device is upgrading
 - MeariDeviceCodeVersionLowPower: device's power is too low, cann't upgrade
 - MeariDeviceCodeNoTemperatureAndHumiditySensor: device doesn't detect the temperature sensor and humidity sensor.
 - MeariDeviceCodeNoTemperatureAndHumidityCantRead: cant read temperature or humidity data from the device
 */
typedef NS_ENUM(NSInteger, MeariDeviceCode) {
    MeariDeviceCodeUnknown = 0,
    MeariDeviceCodeGeneralError                   = -1001,
    MeariDeviceCodeNotJson                        = -1002,
    MeariDeviceCodeParamError                     = -1003,
    MeariDeviceCodeConnectIsConnecting            = -1011,
    MeariDeviceCodeConnectPasswordError           = -1012,
    MeariDeviceCodeConnectOffline                 = -1013,
    MeariDeviceCodeConnectDisconnected            = -1014,
    MeariDeviceCodePreviewIsPlaying               = -1021,
    MeariDeviceCodePlaybackIsPlaying              = -1031,
    MeariDeviceCodePlaybackIsPlayingByOthers      = -1032,
    MeariDeviceCodeVersionIsUpgrading             = -1041,
    MeariDeviceCodeVersionLowPower                = -1042,
    MeariDeviceCodeNoTemperatureAndHumiditySensor = -1043,
    MeariDeviceCodeNoTemperatureAndHumidityCantRead = -1044,
    MeariDeviceCodeVoiceTalkFail                  = -1045,
    MeariDeviceCodeVideoClipRecording             = -1050,
};

typedef NS_ENUM(NSInteger, MeariNetworkReachabilityStatus) {
    MeariNetworkReachabilityStatusUnknown          = -1,
    MeariNetworkReachabilityStatusNotReachable     = 0,
    MeariNetworkReachabilityStatusReachableViaWWAN = 1,
    MeariNetworkReachabilityStatusReachableViaWiFi = 2,
};

/**
 *@struct MEARIDEV_MEDIA_HEADER
 *@brief Device network parameters structure
 */
typedef struct
{
    unsigned int   magic; /**<Media header: 0x56565099*/
    unsigned int   videoid; /**<Video Source No*/
    unsigned int   streamid; /**<Stream type: 0: The main stream 1: Sub-stream*/
    unsigned int media_format; /**<Media encoding format 0x01=H264 0x02=mpeg4 0x03=mjpeg 0x04=hevc 0x81=aac 0x82=g711u 0x83=g711a 0x84=g726_16 0x85=G726_32*/
    unsigned char frame_type; /**<0xF0- video frame type main frame 0xF1 = video fill the frame 0xF2 = pps 0xF3 = sps 0xFA = audio frame*/
    /**
     *@union PPSDEV_MEDIA_HEADER
     *@brief Device network parameters structure
     */
    union{
        /**
         *@struct video
         *@brief Video parameter structure (If the media type is 0xf0 required when such data)
         */
        struct{
            unsigned char frame_rate; /**<Frame rate*/
            unsigned char width; /**<Video width (a multiple of 8)*/
            unsigned char height; /**<Video High (a multiple of 8)*/
        }video;
        /**
         *@struct audio
         *@brief Audio parameters structure (If the media type is 0xfa required when such data)
         */
        struct{
            unsigned char sample_rate; /**<Sampling Rate 0=8000 1=12000 2=11025 3=16000 4=22050 5=24000 6=32000 7=44100 8=48000*/
            unsigned char bit_rate; /**<Audio of bits*/
            unsigned char channels; /**<Number of channels*/
        }audio;
    };
    
    unsigned int timestamp; /**<Timestamp, millisecond*/
    unsigned int datetime; /**<Utc time the frame data, second grade*/
    unsigned int size; /**<The length of the frame data*/
}MEARIDEV_MEDIA_HEADER,*MEARIDEV_MEDIA_HEADER_PTR;

typedef NS_ENUM(NSInteger, MeariDeviceStreamType) {
    MeariDeviceStreamData = 0, /**<Media head type*/
    MeariDeviceStreamVideo =  1,  /**<Video data type*/
    MeariDeviceStreamAudio =  2,  /**<Audio data types*/
    MeariDeviceStreamClose =  3,  /**<Close callback type*/
    MeariDeviceStreamSeek  =  4,  /**<when you seek play,it will be called*/
    MeariDeviceStreamPause =  5,  /**<when you pause play,it will be called*/
    MeariDeviceStreamInTimeSleep =  6,  /**<when device are in time sleep mode,send me*/
    MeariDeviceStreamInGEOSleep =  7,  /**<when device are in geo sleep mode,send me*/
    MeariDeviceStreamInSleep =  8,  /**<when device are in sleep mode,send me*/
    MeariDeviceStreamLeaveSleep =  9,
    MeariDeviceStreamPlayMode =  10
};
#endif /* MeariEnum_h */
