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
  服务器环境

 - MearEnvironmentRelease: release (发布)
 - MearEnvironmentDeveloper: develop(开发环境)
 - MearEnvironmentPrerelease: prerelease (预发布)
 */
typedef NS_ENUM(NSInteger, MearEnvironment) {
    MearEnvironmentRelease,
    MearEnvironmentDeveloper,
    MearEnvironmentPrerelease
};

/**
 Log flag
 日志等级 (从大到小)

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
 用户界面的接口错误

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
 - MeariUserCodeShareByYourself: share by yourself is not invalid
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
    MeariUserCodeShareByYourself        = 1069,
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
    MeariDeviceCodeDeviceParamFail                = -10000
};

typedef NS_ENUM(NSInteger, MeariNetworkReachabilityStatus) {
    MeariNetworkReachabilityStatusUnknown          = -1,
    MeariNetworkReachabilityStatusNotReachable     = 0,
    MeariNetworkReachabilityStatusReachableViaWWAN = 1,
    MeariNetworkReachabilityStatusReachableViaWiFi = 2,
};

#endif /* MeariEnum_h */
