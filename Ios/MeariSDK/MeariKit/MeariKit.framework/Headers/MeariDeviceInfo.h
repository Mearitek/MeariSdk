//
//  MeariDeviceInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MeariDeviceType) {
    MeariDeviceTypeNVR = 0, // nvr type
    MeariDeviceTypeIpc = 1, // normal type ipc
};

// all SubType
typedef NS_ENUM(NSInteger, MeariDeviceSubType) {
    MeariDeviceSubTypeNVR = 0,
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,
    MeariDeviceSubTypeIpcVoiceBell = 5,
    MeariDeviceSubTypeIpcFloodlight = 6,
};

typedef NS_ENUM(NSInteger, MeariDeviceAddStatus) {
    MeariDeviceAddStatusSelf = 1, // Your device
    MeariDeviceAddStatusUnShare, // Not shared
    MeariDeviceAddStatusNone,    // Not added
    MeariDeviceAddStatusShared, // Already shared
    MeariDeviceAddStatusSharing, // Sharing
    MeariDeviceAddStatusFailure // device abnormal
};
typedef NS_ENUM(NSInteger, MeariDeviceLimitLevel) {
    MeariDeviceLimitLevelNone, // normal
    MeariDeviceLimitLevelForbidden, // Forbidden
};
typedef NS_ENUM(NSInteger, MeariDeviceVoiceTalkType) {//Voice intercom type
    MeariDeviceVoiceTalkTypeNone         = 0,    //No speakers and microphone
    MeariDeviceVoiceTalkTypeSpeekerOnly  = 1,    //Speaker only
    MeariDeviceVoiceTalkTypeMicOnly      = 2,    //Only Mike
    MeariDeviceVoiceTalkTypeHalfDuplex   = 3,    //Half duplex
    MeariDeviceVoiceTalkTypeFullDuplex   = 4,    //Full duplex
};
typedef NS_ENUM(NSInteger, MeariDeviceCapabilityVSTType) {
    MeariDeviceCapabilityVSTTypeNormal       = 0,    //HD/SD
    MeariDeviceCapabilityVSTTypeOnlyHD       = 1     //HD
};
typedef NS_ENUM (NSUInteger, MeariDeviceSupportBellType) {
    MeariDeviceSupportBellTypeWireless, //Wireless bell is supported by default
    MeariDeviceSupportBellTypeMachinery = 0b1, //mechanical bell
    MeariDeviceSupportBellTypeWirelessBell = 0b10, //Wireless Bell
    MeariDeviceSupportBellTypeWirelessEnable = 0b10000000, //Wireless enable
};

typedef NS_ENUM (NSUInteger, MeariDeviceLocalServerType) {
    MeariDeviceLocalServerTypeChangePSW = 0b1, //Support password modification
    MeariDeviceLocalServerTypeOnvif = 0b10, //Support Onvif
};
typedef NS_OPTIONS(NSUInteger, MeariDevicePeopleDetect) {
    MeariDevicePeopleDetectEnable = 0b1, // Support People Detect
    MeariDevicePeopleDetectBnddraw = 0b10, // Support People Detect Bnddraw
};
typedef NS_ENUM (NSUInteger, MeariDeviceDayNightType) {
    MeariDeviceDayNightTypeAuto, // auto mode
    MeariDeviceDayNightTypeDay, // day mode
    MeariDeviceDayNightTypeNight // night mode
};
typedef NS_ENUM(NSInteger, MeariDeviceTokenType) {
    MeariDeviceTokenTypeSmartWifi, // use SmartWifi Configure the network
    MeariDeviceTokenTypeAP, // use ap Configure the network
    MeariDeviceTokenTypeQRCode // use QRCode  Configure the network
};

typedef NS_ENUM (NSInteger, MeariDeviceCloudState) {
    MeariDeviceCloudStateCloseCanTry = 0,      //Not open but can trial
    MeariDeviceCloudStateCloseNotTry,          //Not open and cant trial
    MeariDeviceCloudStateOpenNotOverDue,       //open
    MeariDeviceCloudStateOpenOverDue           //expired
};

typedef NS_ENUM (NSInteger, MeariDevicePirSensitivity) {
    MeariDevicePirSensitivityNone = 0, // not support
    MeariDevicePirSensitivityAll = 1, // Support all
    MeariDevicePirSensitivityOnlySwitch = 2,//Support enable
    MeariDevicePirSensitivitySwitchAndHighLow= 4,//Support enable And high,low level
};

@interface MeariDeviceInfoCapabilityFunc : MeariBaseModel
@property (nonatomic, assign) MeariDeviceVoiceTalkType vtk; //Voice intercom type
@property (nonatomic, assign) NSInteger fcr;               //Face recognition
@property (nonatomic, assign) NSInteger dcb;               //Decibel alarm
@property (nonatomic, assign) NSInteger md;                //Motion Detection
@property (nonatomic, assign) NSInteger ptz;               //PTZ
@property (nonatomic, assign) NSInteger tmpr;              //Temperature Sensor
@property (nonatomic, assign) NSInteger hmd;               //Humidity Sensor
@property (nonatomic, assign) NSInteger pir;               //Body detection
@property (nonatomic, assign) NSInteger cst;               //Cloud storage
/** Signal strength*/
@property (nonatomic, assign) NSInteger nst;
/** Playback recording settings*/
@property (nonatomic, assign) NSInteger evs;
/** Battery lock*/
@property (nonatomic, assign) NSInteger btl;
/** Cloud Storage Switch*/
@property (nonatomic, assign) NSInteger cse;
/** Day and night mode*/
@property (nonatomic, assign) NSInteger dnm;
/** Second generation cloud storage*/
@property (nonatomic, assign) NSInteger cs2;
/** High standard definition*/
@property (nonatomic, assign) MeariDeviceCapabilityVSTType vst;
/** Multi-rate setting*/
@property (nonatomic, assign) NSInteger bps;
/** led light*/
@property (nonatomic, assign) NSInteger led;
/** onvif function*/
@property (nonatomic, assign) NSInteger svc;
/** Support bell type*/
@property (nonatomic, assign) NSInteger rng;
/** Lamp camera function */
@property (nonatomic, assign) NSInteger flt;
/** Power Management*/
@property (nonatomic, assign) NSInteger pwm;
/** sd card*/
@property (nonatomic, assign) NSInteger sd;
/** version upgrade*/
@property (nonatomic, assign) NSInteger ota;
/** Host Message*/
@property (nonatomic, assign) NSInteger hms;
/** flip */
@property (nonatomic, assign) NSInteger flp;
/** Shadow Agreement*/
@property (nonatomic, assign) NSInteger shd;
/** Door lock*/
@property (nonatomic, assign) NSInteger dlk;
/** relay */
@property (nonatomic, assign) NSInteger rel;
/** Open the door*/
@property (nonatomic, assign) NSInteger dor;
/** Turn on the light*/
@property (nonatomic, assign) NSInteger lgt;
/** Sleep mode*/
@property (nonatomic, assign) NSInteger slp;
/** Switch the main stream */
@property (nonatomic, assign) NSInteger vec;
/** Cry Detect*/
@property (nonatomic, assign) NSInteger bcd;
/** People Track*/
@property (nonatomic, assign) NSInteger ptr;
/** People Detect*/
@property (nonatomic, assign) NSInteger pdt;
@end


@interface MeariDeviceInfoCapability: MeariBaseModel
@property (nonatomic, assign) NSInteger ver;               //Protocol version number
@property (nonatomic, copy) NSString *cat;                 //device type
@property (nonatomic, strong) MeariDeviceInfoCapabilityFunc *caps;//Supported features
@end

#import "MeariDeviceParam.h"
@interface MeariDeviceInfo : MeariBaseModel
@property (nonatomic, assign) MeariDeviceType type;
/** device all type */
@property (nonatomic, assign) MeariDeviceSubType subType;
/** device add status */
@property (nonatomic, assign) MeariDeviceAddStatus addStatus;
/** Device auto-bind */
@property (nonatomic, assign) BOOL autobind;

@property (nonatomic, assign) BOOL hasAdd;

@property (nonatomic, assign) MeariDeviceLimitLevel limitLevel;
/** cloud storage State  */
@property (nonatomic, assign) MeariDeviceCloudState cloudState;
/** device capability */
@property (nonatomic, strong) MeariDeviceInfoCapability *capability;
@property (nonatomic, assign) MeariDeviceSleepmode sleepmode;
/** device ID */
@property (nonatomic, assign) NSInteger ID;
/** userID */
@property (nonatomic, assign) NSInteger userID;
/** tp */
@property (nonatomic, copy) NSString *tp;
/** device uuid */
@property (nonatomic, copy) NSString *uuid;
/** device sn */
@property (nonatomic, copy) NSString *sn;
/** p2p number */
@property (nonatomic, copy) NSString *p2p;
/** p2pInit */
@property (nonatomic, copy) NSString *p2pInit;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *connectName;
/** device nickname */
@property (nonatomic, copy) NSString *nickname;
/** device logo */
@property (nonatomic, copy) NSString *iconUrl;
/** gray icon */
@property (nonatomic, copy) NSString *grayIconUrl;
/** host message url */
@property (nonatomic, copy) NSString *bellVoice;
/** modelName */
@property (nonatomic, copy) NSString *modelName;
/** nvr's key,user to connect nvr */
@property (nonatomic, assign) NSInteger nvrPort;
/** nvr's ID */
@property (nonatomic, assign) NSInteger nvrID;
@property (nonatomic, copy) NSString *nvrKey;
@property (nonatomic, copy) NSString *nvrUUID;
@property (nonatomic, copy) NSString *nvrSn;

@property (nonatomic, copy) NSString *capabilityStr;
/** current device userAccount*/
@property (nonatomic, copy) NSString *userAccount;
@property (nonatomic, copy) NSString *produceAuth;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *wifiSsid;
@property (nonatomic, copy) NSString *wifiBssid;
/** whether to close device push */
@property (nonatomic, assign) NSInteger closePush;
@property (nonatomic, assign) NSInteger protocolVersion;
@property (nonatomic, assign) BOOL iotDevice;
@property (nonatomic, strong) NSString *region;

@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *radius;
/** Whether device is shared by friends */
@property (nonatomic, assign) BOOL shared;
/** Whether there is a message from device  */
@property (nonatomic, assign) BOOL hasMsg;
/** Whether device is online *//** tp */
@property (nonatomic, assign) BOOL online;
/** whether device need update */
@property (nonatomic, assign) BOOL needUpdate;
/** whether device need force Update */
@property (nonatomic, assign) BOOL needForceUpdate;

@end


