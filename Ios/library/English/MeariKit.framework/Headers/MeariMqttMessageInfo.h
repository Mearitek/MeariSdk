//
//  MeariMqttMessageInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/18.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeariDeviceInfo.h"
/**
 Message Type
 
  - MeariMqttCodeTypeDeviceOnline: The device is online
  - MeariMqttCodeTypeDeviceOffline: Device offline
 - MeariMqttCodeTypeCancelDeviceShare: Device cancel share
 - MeariMqttCodeTypeAcountTokenInvalid: User token invalid
 - MeariMqttCodeTypeVisitorCall: Visitor call
 - MeariMqttCodeTypeDeviceUnbundling: Device unbind
  - MeariMqttCodeTypeCancelDeviceShare: Device is unshared
  - MeariMqttCodeTypeAcountTokenInvalid: Login information is invalid
  - MeariMqttCodeTypeVisitorCall: The device has visitors
  - MeariMqttCodeTypeDeviceUnbundling: The device has been unbundled
 - MeariMqttCodeTypeDeviceShare: Receive the device share
 - MeariMqttCodeTypeDeviceUpgradeFormat: Firmware upgrade progress
 - MeariMqttCodeTypeSDCardFormat: Sd card formatting progress
 - MeariMqttCodeTypePropertyRefresh: Get a property status in real time
 */
typedef NS_ENUM(NSInteger, MeariMqttCodeType) {
    MeariMqttCodeTypeDeviceOnline            = 101,
    MeariMqttCodeTypeDeviceOffline           = 102,
    MeariMqttCodeTypeCancelDeviceShare       = 103,
    MeariMqttCodeTypeAcountTokenInvalid      = 104,
    MeariMqttCodeTypeVisitorCall             = 111,
    MeariMqttCodeTypeVoiceCall               = 134,
    MeariMqttCodeTypeDeviceUnbundling        = 140,
    MeariMqttCodeTypeDeviceAutobundleSuccess = 170,
    MeariMqttCodeTypeDeviceAutobundleFailure = 171,
    MeariMqttCodeTypeDeviceShare             = 180,
    MeariMqttCodeTypeDeviceUpgradeFormat     = 803,
    MeariMqttCodeTypeSDCardFormat            = 806,
    MeariMqttCodeTypePropertyRefresh         = 809,
};

@interface MeariMqttMessageInfoDevice : MeariBaseModel
@property (assign, nonatomic) BOOL online;   // Whether the device is online
@property (assign, nonatomic) NSInteger deviceID; //device ID
@property (nonatomic, assign) MeariDeviceType devType; //Large type
@property (nonatomic, assign) MeariDeviceSubType devSubType; //Subtype
@property (copy, nonatomic) NSString *deviceType; //Device type
@property (copy, nonatomic) NSString *deviceName; //Device nickname
@property (copy, nonatomic) NSString *msgID; //Message ID
@property (copy, nonatomic) NSString *hostKey; //device token
@property (copy, nonatomic) NSString *deviceUUID; //device uuid
@property (copy, nonatomic) NSString *imgUrl; //Device icon
@property (copy, nonatomic) NSString *bellVoice; //Device doorbell
@property (copy, nonatomic) NSString *p2pInit;
@property (copy, nonatomic) NSString *deviceP2P;
@property (nonatomic, assign) MeariDeviceAddStatus  addStatus;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *grayIconUrl;
@property (nonatomic, strong) NSString *capabilityStr;
@property (nonatomic, strong) NSString *tp;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *version;
@end

@interface MeariEventInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger sdTotalPercent;           // Format percentage
@property (nonatomic, assign) NSInteger upgradeTotalPercent;      // Upgrade firmware percentage
@property (nonatomic, assign) NSInteger upgradeDownloadPercent;   // Upgrade package download percentage
@property (nonatomic, assign) NSInteger upgradeUploadPercent;     // Upgrade package upload percentage
@property (nonatomic, assign) NSInteger wifiStrength;             // Wi-Fi signal strength
@property (nonatomic, assign) NSInteger temperature;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, strong) MeariDeviceParamStorage *sdcard;
@property (nonatomic, assign) BOOL      floodCameraStatus;

@property (nonatomic, assign) BOOL hasWifiStrength;
@property (nonatomic, assign) BOOL hasTempAndHumidity;
@property (nonatomic, assign) BOOL hasFloodCameraStatus;
@property (nonatomic, assign) BOOL hasChangeSd;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end

@interface MeariMqttMessageInfo : MeariBaseModel
@property (assign, nonatomic) double t; //timestamp
@property (strong, nonatomic) MeariMqttMessageInfoDevice *data;
@property (assign, nonatomic) NSInteger msgid; //Message ID
@property (nonatomic, assign) MeariMqttCodeType type; //Message type
@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, copy) MeariEventInfo *eventInfo;

@end


