//
//  MeariUser.h
//  MeariKit
//
//  Created by Meari on 2017/12/12.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeariDeviceInfo.h"
#import "MeariUserInfo.h"
@class MeariDevice;
@class MeariDeviceList;
@class MeariDeviceFirmwareInfo;
@class MeariMusicInfo;
@class MeariMessageInfoAlarm;
@class MeariMessageInfoSystem;
@class MeariMessageInfoAlarmDevice;
@class MeariMessageInfoVisitor;
@class MeariMessageInfoAlarmDeviceInfoPrivate;
@class MeariFriendInfo;
@class MeariShareInfo;
typedef void(^MeariSuccess)(void);
typedef void(^MeariSuccess_Avatar)(NSString *avatarUrl);
typedef void(^MeariSuccess_DeviceList)(MeariDeviceList *deviceList);
typedef void(^MeariSuccess_DeviceOnlineStatus)(BOOL online);
typedef void(^MeariSuccess_DeviceSoundPushStatus)(BOOL open);
typedef void(^MeariSuccess_DeviceListForFriend)(NSArray <MeariDevice *>*devices);
typedef void(^MeariSuccess_DeviceListForStatus)(NSArray <MeariDevice *> *devices);
typedef void(^MeariSuccess_DeviceListForNVR)(NSArray <MeariDevice *> *bindedDevices, NSArray <MeariDevice *> *unbindedDevices);
typedef void(^MeariSuccess_DeviceAlarmMsgTime)(NSArray <NSString *>*ipcTimes, NSArray <NSString *>*bellTimes, NSArray <NSString *>*cryTimes);
typedef void(^MeariSuccess_DeviceFirmwareInfo)(MeariDeviceFirmwareInfo *info);
typedef void(^MeariSuccess_DeviceOnlineStatus)(BOOL online);
typedef void(^MeariSuccess_DeviceVoiceUrl)(NSString *voiceUrl);
typedef void(^MeariSuccess_DeviceVoiceData)(NSData *data);
typedef void(^MeariSuccess_DeviceAlarmImageData)(NSData *data);
typedef void(^MeariSuccess_Music)(NSArray <MeariMusicInfo *>*musicList);
typedef void(^MeariSuccess_Token)(NSString *token, NSInteger validTime);
typedef void(^MeariSuccess_Token2)(NSString *token, NSInteger validTime, NSInteger delaySmart);
typedef void(^MeariSuccess_Share)(MeariShareInfo *shareInfo);
typedef void(^MeariSuccess_ShareList)(NSArray<MeariShareInfo *> *shareInfoList);
typedef void(^MeariSuccess_FriendList)(NSArray <MeariFriendInfo *>*friends);
typedef void(^MeariSuccess_FriendListForDevice)(NSArray <MeariFriendInfo *>*friends);
typedef void(^MeariSuccess_FriendListForNVR)(NSArray <MeariFriendInfo *>*friends);
typedef void(^MeariSuccess_MsgAlarmList)(NSArray <MeariMessageInfoAlarm *>*msgs);
typedef void(^MeariSuccess_MsgSystemList)(NSArray <MeariMessageInfoSystem *>*msgs);
typedef void(^MeariSuccess_MsgAlarmDeviceList)(NSArray <MeariMessageInfoAlarmDevice *>*msgs, MeariDevice *device);
typedef void(^MeariSuccess_MsgVoiceDeviceList)(NSArray <MeariMessageInfoVisitor *>*msgs);
typedef void(^MeariSuccess_payWebUrl)(NSString *payWebUrl, NSString *paySuccessUrl);
typedef void(^MeariSuccess_Dictionary)(NSDictionary *dict);
typedef void(^MeariSuccess_Str)(NSString *str);
typedef void(^MeariSuccess_BOOL)(BOOL isSuccess);
typedef void(^MeariFailure)(NSError *error);
typedef void(^MeariSuccess_RequestAuthority)(NSInteger msgEffectTime,double serverTime);

typedef NS_ENUM(NSInteger, MeariUserAccountType) {
    MeariUserAccountTypeCommon,
    MeariUserAccountTypeUid,
};

typedef NS_ENUM(NSInteger, MeariHelpType) {
    MeariHelpTypeCantReset,
    MeariHelpTypeLightError,
    MeariHelpTypeAll
};

/**
 Timely message notification
 */
UIKIT_EXTERN NSString *const MeariDeviceOnlineNotification; //Device online
UIKIT_EXTERN NSString *const MeariDeviceOfflineNotification; //Device offline
UIKIT_EXTERN NSString *const MeariDeviceCancelSharedNotification; //Device is unshared
UIKIT_EXTERN  NSString *const MeariDeviceFriendSharedDeviceNotification;        //Friend sharing device
UIKIT_EXTERN NSString *const MeariDeviceHasVisitorNotification; //Device (doorbell) has visitors
UIKIT_EXTERN NSString *const MeariDeviceVoiceBellHasVisitorNotification; //Device (voice doorbell) has visitors
UIKIT_EXTERN NSString *const MeariDeviceUnbundlingNotification; //The device is unbundled
UIKIT_EXTERN NSString *const MeariUserLoginInvalidNotification; //User login information is invalid, need to log in again
UIKIT_EXTERN  NSString *const MeariDeviceAutoAddNotification; //Automatic device add
UIKIT_EXTERN  NSString *const MeariDeviceAutobundleSuccessNotification; //After the device is successfully deployed, it will be automatically added to the account without manually adding it. Automatically add success notifications
UIKIT_EXTERN  NSString *const MeariDeviceConnectMqttNotification; // mqtt connect
UIKIT_EXTERN  NSString *const MeariDeviceSDCardFormatPercentNotification; //Format percentage
UIKIT_EXTERN  NSString *const MeariDeviceUpgradePercentPercentNotification; //Upgrade percentage
UIKIT_EXTERN  NSString *const MeariDeviceWiFiStrengthChangeNotification; //Wi-Fi signal strength
UIKIT_EXTERN  NSString *const MeariDeviceFloodCameraStatusNotification;
UIKIT_EXTERN  NSString *const MeariDeviceChangeTempHumidityNotification; //Temperature and humidity change
UIKIT_EXTERN  NSString *const MeariDeviceSdStatusChangeNotification; //Sd card status change


@interface MeariUser : NSObject

+ (instancetype)sharedInstance;

#pragma mark -- Property

/**
 User Info
 */
@property (nonatomic, strong, readonly)MeariUserInfo *userInfo;


/**
 Logged in
 */
@property (nonatomic, assign, getter=isLogined, readonly) BOOL logined;

/**
 Account type
 */
@property (nonatomic, assign, readonly) MeariUserAccountType accountType;

/**
 Whether mqtt is connected
 */
@property (nonatomic, assign, getter=isConnected, readonly) BOOL connected;
/**
 Whether data migration
 */
@property (nonatomic, assign) BOOL migrate;
/**
 Doorbell ringing time
 */
@property (nonatomic, assign) NSInteger ringDuration;


/**
 Redirect access address
 
 - Switch account
 - Change country
 
 note: When revising an account or reselecting a country, you need to redirect the request interface
 */
- (void)resetRedirect;

#pragma mark - User

/**
 register Message notification
 
 @param deviceToken Phone Token
 @param success register success
 @param failure register failure
 */
- (void)registerPushWithDeviceToken:(NSData *)deviceToken success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Get a verfication code
 
 @param userAccount email or telphone, Note: telphone now is only available in China mainland.
 @param countryCode country's code, for example: China's country code is "CN"
 @param phoneCode country's phone code, for example:China's phone code is "86"
 @param success return remain valid time of verfication code, measured in seconds
 @param failure return error.
 */
- (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

/**
 Register account
 
 @param userAccount email or telphone, Note: telphone now is only available in China mainland.
 @param password password for login
 @param countryCode country's code, for example: China's country code is "CN"
 @param phoneCode country's phone code, for example:China's phone code is "86"
 @param verificationCode verfication code which is four numbers
 @param nickname nickname, you can change it after you have logined
 @param success you can get user's login info by calling `userinfo` property.
 @param failure return error
 */
- (void)registerAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Login account
 
 @param userAccount registered account
 @param password password
 @param countryCode country's code, for example: China's country code is "CN"
 @param phoneCode  country's phone code, for example:China's phone code is "86"
 @param success you can get user's login info by calling `userinfo` property.
 @param failure return error
 */
- (void)loginAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Other ways to log in
 
   @param userId username
   @param thirdToken three-party token
   @param countryCode Country code --- For example: In China we can pass: CN
   @param phoneCode Country code --- For example: Words in China
   @param thirdUserName Nickname
   @param thirdImageUrl avatar
   @param loginType Login method 1: fackbook
   @param success Successful callback
   @param failure failure callback
 */
- (void)loginThirdWithUserId:(NSString *)userId thirdToken:(NSString *)thirdToken countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode thirdUserName:(NSString *)thirdUserName thirdImageUrl:(NSString *)thirdImageUrl loginType:(MeariThirdLoginType)loginType success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Find password
 
 @param userAccount registered account
 @param password user's password
 @param verficationCode verfication code
 @param success success
 @param failure return error
 */
- (void)changePasswordWithAccount:(NSString *)userAccount password:(NSString *)password verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Change password
 
 @param userAccount registered account
 @param password user's password
 @param countryCode country's code, for example: China's country code is "CN"
 @param phoneCode country's phone code, for example:China's phone code is "86"
 @param verficationCode verfication code
 @param success you can get user's login info by method of "[MeariUser sharedInstance].userInfo]"
 @param failure return error
 */
- (void)findPasswordWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;



/**
 Login by uid
 
 @param uid unique id among all the uid users.
 @param countryCode country's code, for example: China's country code is "CN"
 @param phoneCode country's phone code, for example:China's phone code is "86"
 @param success you can get user's login info by calling `userinfo` property.
 @param failure return error
 */
- (void)loginWithUid:(NSString *)uid countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode  success:(MeariSuccess)success  failure:(MeariFailure)failure;



/**
 Logout
 
 @param success logout successfully
 @param failure return error
 */
- (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;



/**
 Upload avatar
 
 @param image image
 @param success return image's url
 @param failure return error
 */
- (void)uploadUserAvatar:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;


/**
 Change nickname
 
 @param name nickname, should not be null, and emoji now is unavailable
 @param success
 @param failure return error
 */
- (void)renameNickname:(NSString *)name  success:(MeariSuccess)success failure:(MeariFailure)failure;
#pragma mark - App

/**
 Push sound
 
 @param isOpen Whether to bring sound when pushing
 @param success
 @param failure return error
 */
- (void)notificationSoundSwitch:(BOOL)openSound success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 device push
 
 @param deviceID device's id
 @param enable Whether to open
 @param success
 @param failure return error
 */
- (void)devicePushEnableWithDeviceID:(NSInteger)deviceID enable:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 feedback
 
 @param content content(Required)
 @param mark Optional :  Any string (you can upload device information) E.g: {"Version:":"12.1.3","OS":"iOS","Phone":"iPhone 6s"}  Must be a json string
 @param contactInfo Optional : User contact information   E.g: 638933839@163.com Email is the best
 @param lightStatus Optional : light status(You can upload the current user's indicator status (any string))     E.g: Lights flashing blue light Content Customization
 @param sn Optional : Device sn number    e.g: 056757160
 @param type Optional : Quick question json string (0,1,2,3,4,5)   e.g:  2,3,4,6
 @param imageDataArray Optional : Feedback picture     Please use the UIImageJPEGRepresentation() method to transfer the binary image array. The number of images is no more than four.
 @param snImageData Optional : Sn picture     UIImageJPEGRepresentation method to pass binary data
 @param success
 @param failure return error
 */
- (void)feedbackWithContent:(NSString *)content mark:(NSString *)mark contactInfo:(NSString *)contactInfo
                lightStatus:(NSString *)lightStatus sn:(NSString *)sn type:(NSString *)type imageDataArray:(NSArray<NSData *> *)imageDataArray snImageData:(NSData *)snImageData success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 check app version from servion
 
 @param success return success
 @param failure return error
 
 */
- (void)appCheckVersion:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 check app version from appstore
 
 @param appID appid
 @param success return success
 @param failure return error
 */
- (void)appCheckVersionFromAppstore:(NSString *)appID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
 Get a startup page ad
 
 @param success
 @param failure return error
 */
- (void)getLaunchAD:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 data migration
 
 @param countryCode Country code
 @param success
 @param failure return error
 */
- (void)AppMigrateWithCountryCode:(NSString *)countryCode success:(MeariSuccess_BOOL)success failure:(MeariFailure)failure;

/**
 Upload Montion File
 
 @param fileData Binary data
 @param preUrl Domain address
 @param success
 @param failure return error
 */
- (void)UploadMontionFile:(NSData *)fileData preUrl:(NSString *)preUrl success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Get WeChat code
 
   @param appID App unique ID
   @param secret Application Key AppSecret
   @param code The code obtained by WeChat
   @param success Successful callback
   @param failure failure callback
 */
- (void)getWeChatAccessTokenWithAppID:(NSString *)appID secret:(NSString *)secret code:(NSString *)code success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 checkOut login
 
 @param success return success
 @param failure return error
 */
- (void)checkUserLoginOut:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

#pragma mark -- Cloud

/**
 Get cloud storage status (new)
 
 @param deviceID device ID
 @param success
 @param failure return error
 */
- (void)cloudGetStateWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Cloud storage trial
 
 @param deviceID device id
 @param success
 @param failure return error
 */
- (void)cloudTryWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Cloud storage Activation code
 
 @param deviceID device id
 @param code Activation code
 @param success
 @param failure return error
 */
- (void)cloudActivationWithDeviceID:(NSInteger)deviceID code:(NSString *)code success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Cloud storage creation order
 
 @param deviceID device id
 @param serverTime Service period (month/year) Example: 11
 @param deviceID device id
 @param mealType Year or month Example: @"Y" @"M"
 @param storageTime Number of days Example : 30
 @param storageType 0: Event recording 1: All day recording
 @param payType 1: Alipay 2 PayPal
 @param paymentMethodNonce PayPal payment callback tokenizedPayPalAccount.nonce
 @param success
 @param failure return error
 */
- (void)cloudCreateOrderWithDeviceID:(NSInteger)deviceID serverTime:(NSInteger)serverTime payMoney:(NSString *)payMoney mealType:(NSString *)mealType storageTime:(NSInteger)storageTime storageType:(NSInteger)storageType payType:(NSInteger)payType paymentMethodNonce:(NSString *)paymentMethodNonce success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

    
/**
 Cloud storage creation order by Alipay

 @param deviceID device id
 @param serverTime Service period (month/year) Example: 11
 @param payMoney payment amount
 @param mealType Year or month Example: @"Y" @"M"
 @param storageTime Number of days Example : 30
 @param storageType 0: Event recording 1: All day recording
 @param success
 @param failure return error
 */
- (void)cloudGetAlipayHtmlWithDeviceID:(NSInteger)deviceID serverTime:(NSInteger)serverTime payMoney:(NSString *)payMoney mealType:(NSString *)mealType storageTime:(NSInteger)storageTime storageType:(NSInteger)storageType success:(MeariSuccess_payWebUrl)success failure:(MeariFailure)failure;
/**
 My order list
 
 @param deviceID device id
 @param success
 @param failure return error
 */
- (void)cloudGetOrderListWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Get device payment token
 
 @param success
 @param failure return error
 */
- (void)cloudGetPayPalToken:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;



#pragma mark - Device

/**
 Getting device list information
 
 @param success return device list
 @param failure return error
 */
- (void)getDeviceList:(MeariSuccess_DeviceList)success failure:(MeariFailure)failure;

/**
 Get all your own device
 
 @param success return device list
 @param failure return error
 */
- (void)getOwnerDeivces:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

/**
 check device's status on server by searched origin device info
 
 @param type device type, see MeariDeviceType
 @param devices searched origin devices
 @param success return device list
 @param failure return error
 */
- (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

/**
 Add device
 
 @param type device type, see MeariDeviceType
 @param uuid device's uuid
 @param sn device's sn
 @param tp device's tp
 @param key device's key
 @param success
 @param failure return error
 */
- (void)addDeviceWithDeviceType:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp key:(NSString *)key deviceName:(NSString *)deviceName success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Add device
 Note: If you modify the device name immediately after adding a successful device,
 you need to assign the returned deviceID toinfo.ID
 
 @param type device type
 @param uuid device uuid
 @param sn device sn
 @param tp device tp
 @param key device key
 @param deviceName device nickname
 @param success return device dic
 @param failure return error
 */
- (void)addDeviceWithDeviceType2:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp key:(NSString *)key deviceName:(NSString *)deviceName success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Add device (recommended)
 
 @param device Searched device
 @param success return device dic
 @param failure return error
 */
- (void)addDevice:(MeariDevice *)device success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Delete device
 
 @param type device type, see MeariDeviceType
 @param deviceID device's id
 @param success
 @param failure return error
 */
- (void)deleteDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Change device's nickname
 
 @param type device type, see MeariDeviceType
 @param deviceID device's id
 @param nickname new nickname
 @param success
 @param failure return error
 */
- (void)renameDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Get alarm time list of device
 
 @param deviceID device's id
 @param date date, format like:20171212
 @param success return time list
 @param failure return error
 */
- (void)getAlarmMessageTimes:(NSInteger)deviceID onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;


/**
 Get device's latest version information
 
 @param currentFirmware device's current version
 @param success return device's latest version information
 @param failure return error
 */
- (void)checkNewFirmwareWithCurrentFirmware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;

/**
 check device is online or not
 
 @param deviceID device's id
 @param success return Yes-online, NO-offline
 @param failure return error
 */
- (void)checkDeviceOnlineStatus:(NSInteger)deviceID success:(MeariSuccess_DeviceOnlineStatus)success failure:(MeariFailure)failure;


/**
 Remote wakeup bell
 
 @param deviceID device's id
 @param success
 @param failure return error
 */
- (void)remoteWakeUp:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Get the added device video address
 
 @param success
 @param failure return error
 */
- (void)getVideoUrl:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Send heartbeat
 
 @param deviceID device ID
 @param success
 @param failure return error
 */
- (void)sendHeartBeatWithID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Device: Switch sleep mode
 
 @param deviceList device arrray
 @param modeList Whether to open the array, the length must be equal to the device
 @param success
 @param failure return error
 */
- (void)settingGeographyLocationWithDeviceList:(NSArray *)deviceList modeList:(NSArray *)modeList success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Set geofence
 
 @param ssid wifi'SSID
 @param bssid wifi'BSSID
 @param deviceID deviceID
 @param success
 @param failure
 */
- (void)settingGeographyWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 ota Upgrade
 
 @param deviceID
 @param success
 @param failure
 */
- (void)otaUpgradeWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;
#pragma mark -- Hostmessage

/**
 Download message
 
 @param voiceUrl Message url
 @param success Successful
 @param failure return error
 */
- (void)downloadVoice:(NSString *)voiceUrl success:(MeariSuccess_DeviceVoiceData)success failure:(MeariFailure)failure;

/**
 Upload voice message
 
 @param deviceID device's id
 @param file file url of voice message
 @param success
 @param failure return error
 */
- (void)uploadVoice:(NSInteger)deviceID voiceFile:(NSString *)file success:(MeariSuccess_DeviceVoiceUrl)success failure:(MeariFailure)failure;

/**
 Delete voice message
 
 @param deviceID device id
 @param success
 @param failure return error
 */
- (void)deleteVoice:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


#pragma mark -- NVR

/**
 Get device list for nvr bind
 
 @param nvrID nvr ID
 @param success return device list
 @param failure return error
 */
- (void)getBindDeviceList:(NSInteger)nvrID success:(MeariSuccess_DeviceListForNVR)success failure:(MeariFailure)failure;


/**
 Bind device to nvr, One nvr can bind no more than 8 ipcs.
 
 @param deviceID device id
 @param nvrID nvr ID
 @param success
 @param failure return error
 */
- (void)bindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Unbind device for nvr
 
 @param deviceID device id
 @param nvrID nvr ID
 @param success
 @param failure return error
 */
- (void)unbindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Unbind more than one device for nvr
 
 @param deviceIDs device ids
 @param nvrID nvr ID
 @param success
 @param failure return error
 */
- (void)unbindDevices:(NSArray <NSNumber *>*)deviceIDs toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark -- Music

/**
 Get music list
 
 @param success return music list
 @param failure return error
 */
- (void)getMusicList:(MeariSuccess_Music)success failure:(MeariFailure)failure;

#pragma mark -- Configure
/**
 
Generate QR code
 
 /**
 Create qrcode for QRCode configuration
 
 @param ssid wifi's name
 @param password wifi's password
 @param token token
 @param size qrcode's size
 @return qrcode image
 */
- (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;

#pragma mark - Friend

/**
 Get friend list
 
 @param success return friend list
 @param failure return error
 */
- (void)getFriendList:(MeariSuccess_FriendList)success failure:(MeariFailure)failure;

/**
 Add Friend
 
 @param userAccount friend's account
 @param success
 @param failure return error
 */
- (void)addFriend:(NSString *)userAccount success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Delete Friend
 
 @param friendID friend's id
 @param success
 @param failure return error
 */
- (void)deleteFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Delete more than one friend
 
 @param friendIDs friend's ids
 @param success
 @param failure return error
 */
- (void)deleteFriends:(NSArray <NSNumber *> *)friendIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Change friend markname
 
 @param friendID friend's id
 @param nickname markname for friend
 @param success
 @param failure return error
 */
- (void)renameFriend:(NSInteger)friendID markname:(NSString *)markname success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark - Share

/**
 Share device to friend
 
 @param type device'type see MeariDeviceType
 
 @param type device type
 @param deviceID device's id
 @param deviceUUID device's uuid
 @param friendID friend's id
 @param success
 @param failure return error
 */
- (void)shareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID deviceUUID:(NSString *)deviceUUID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Cancel share device
 
 @param type device'type see MeariDeviceType
 @param type device type
 @param deviceID device's id
 @param deviceUUID device's uuid
 @param friendID friend id
 @param success
 @param failure return error
 */
- (void)cancelShareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID deviceUUID:(NSString *)deviceUUID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Request share one's device
 
 @param type device'type see MeariDeviceType
 @param sn device's sn
 @param success
 @param failure return error
 */
- (void)requestShareDeviceWithDeviceType:(MeariDeviceType)type sn:(NSString *)sn success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Get friend list for device share
 
 @param type device'type see MeariDeviceType
 @param deviceID device id
 @param success return friend list
 @param failure return error
 */
- (void)getFriendListForDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess_FriendListForDevice)success failure:(MeariFailure)failure;


/**
 Get device list for share to friend
 
 @param friendID friend id
 @param success return device list
 @param failure return error
 */
- (void)getDeviceListForFriend:(NSInteger)friendID success:(MeariSuccess_DeviceListForFriend)success failure:(MeariFailure)failure;

#pragma mark - Share 2.0
/**
 Get device sharing list
 
 @param deviceID device id
 @param success return share list
 @param failure return error
 */
- (void)getShareListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

/**
 Cancel share
 
 @param deviceID device id
 @param shareAccount account
 @param success
 @param failure return error
 */
- (void)cancelShareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Share device
 
 @param deviceID device id
 @param shareAccount shareAccount account
 @param success
 @param failure return error
 */
- (void)shareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Search Account
 
 @param deviceID device id
 @param shareAccount shareAccount account
 @param success
 @param failure return error
 */
- (void)searchUserWithDeviceID:(NSInteger)deviceID account:(NSString *)userAccount success:(MeariSuccess_Share)success failure:(MeariFailure)failure;

/**
 Share history list
 
 @param deviceID device id
 @param success return list
 @param failure return error
 */
- (void)getHistoryShareWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

/**
 Delete history
 
 @param deviceID device id
 @param shareAccountArray share account array
 @param success
 @param failure return error
 */
- (void)deleteHistoryShareWithDeviceID:(NSInteger)deviceID shareAccountArray:(NSArray *)shareAccountArray success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark - Message

/**
 Get all device's overview alarm message list, decide device whether has alarm message on server.
 
 @param success return alarm list
 @param failure return error
 */
- (void)getAlarmMessageList:(MeariSuccess_MsgAlarmList)success failure:(MeariFailure)failure;

/**
 Get all system message
 
 @param success return systme message list
 @param failure return error
 */
- (void)getSystemMessageList:(MeariSuccess_MsgSystemList)success failure:(MeariFailure)failure;


/**
 Get all alarm message of device
 
 @param deviceID device's id
 @param success return alarm message list
 @param failure return error
 */
- (void)getAlarmMessageListForDevice:(NSInteger)deviceID success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;


/**
 Get a single alarm picture
 
 @param remoteUrl picture url
 @param deviceID device id
 @param sourceData Binary data of the image
 @param failure return error
 */
- (void)getAlarmImageData:(NSString *)remoteUrl device:(NSInteger)deviceID success:(MeariSuccess_DeviceAlarmImageData)sourceData failure:(MeariFailure)failure;

/**
 Delete system message
 
 @param msgIDs message ids
 @param success
 @param failure return error
 */
- (void)deleteSystemMessages:(NSArray <NSNumber *>*)msgIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Delete all alarm message for more than one device
 
 @param deviceIDs device ids
 @param success
 @param failure return error
 */
- (void)deleteAlarmMessages:(NSArray <NSNumber *>*)deviceIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Delete all alarm message for device
 
 @param deviceID device'id
 @param success
 @param failure return error
 */
- (void)deleteAllAlarmMessagesForDevice:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Agree to be one's friend
 
 @param friendID friend id
 @param msgID message
 @param success
 @param failure return error
 */
- (void)agreeAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Refuse to be one's friend
 
 @param friendID friend id
 @param msgID message
 @param success
 @param failure return error
 */
- (void)refuseAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Agree share device to friend
 
 @param deviceID device's id
 @param friendID friend id
 @param msgID message id
 @param success
 @param failure return error
 */
- (void)agreeShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 Agree refuse device to friend
 
 @param deviceID device's id
 @param friendID friend id
 @param msgID message id
 @param success
 @param failure return error
 */
- (void)refuseShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Mark device's all alarm message as readed
 
 @param deviceID device's id
 @param success
 @param failure return error
 */
- (void)markDeviceAlarmMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
  Get url of OSS image
 
 @param url image url
 @param deviceID device id
 @param success return url
 @param failure return error
 */
- (void)getOssImageUrlWithUrl:(NSString *)url deviceID:(NSInteger)deviceID success:(MeariSuccess_Str)success failure:(MeariFailure)failure;

/**
 Get data of OSS image
 
 @param url image url
 @param deviceID device id
 @param success image dictionary
 @param failure return error
 */
- (void)getOssImageDataWithUrl:(NSString *)url deviceID:(NSInteger)deviceID  success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

#pragma mark - VoiceBell
/**
  Get the device's visitor event
  Note: including answering, hanging up, message information
  
  @param deviceID device ID
  @param pageNum Pages 1~
  @param success Successful callback
  @param failure failure callback
  */
- (void)getVisitorMessageListForDevice:(NSInteger)deviceID pageNum:(NSInteger)pageNum success:(MeariSuccess_MsgVoiceDeviceList)success failure:(MeariFailure)failure;

/**
  Get voice data
  
  @param remoteUrl Audio Network Address
  @param voiceData successfully callback audio data
  @param failure failure callback
  */
- (void)getVoiceMessageAudioData:(NSString *)remoteUrl deviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceVoiceData)sourceData failure:(MeariFailure)failure;

/**
  Mark the message as read
  
  @param messageID message ID
  @param success Successful callback
  @param failure failure callback
  */
- (void)markReadVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
  Delete a single message for a device
  
  @param messageID message ID
  @param success Successful callback
  @param failure failure callback
  */
- (void)deleteVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
  Delete all messages under a device
  
  @param deviceID device ID
  @param success Successful callback
  @param failure failure callback
  */
- (void)deleteAllVoiceMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Answer the doorbell
 
 @param deviceID device id
 @param messageID message id
 @param success
 @param failure failure callback
 */
- (void)requestAnswerAuthorityWithDeviceID:(NSInteger)deviceID messageID:(NSInteger)messageID  success:(MeariSuccess_RequestAuthority)success failure:(MeariFailure)failure;

/**
 Hang up the doorbell
 
 @param ID device ID
 @param success
 @param failure failure callback
 */
- (void)requestReleaseAnswerAuthorityWithID:(NSInteger)ID success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark - Monitor
/**
 Network available
 
 @param available
 @param unavailable
 */
+ (void)HttpMonitorNetworkAvailable:(MeariSuccess)available unavailable:(MeariSuccess)unavailable;

/**
 Monitor no network
 
 @param unreachable  no network
 */
+ (void)HttpMonitorNetworkUnreachable:(MeariSuccess)unreachable;


/**
 Current wifi environment

 @return YES or NO
 */
+ (BOOL)checkCurrentNetworkStatusWifi;

/**
 Monitor network status
 
 @param networkChanged network status
 */
+ (void)HttpMonitorNetworkStatus:(void (^)(MeariNetworkReachabilityStatus status))networkChanged;

/**
 Stop Monitor
 */
+ (void)HttpStopMonitor;

#pragma mark --- html

/**
 Help document
 
 @param helpType type
 @param isChinese support en,cn
 @return link
 */
- (NSString *)getHelpLinkWithHelpType:(MeariHelpType)helpType isChinese:(BOOL)isChinese;

#pragma mark - Cancel

/**
 Cancel all user's interface
 */
- (void)cancelAllRequest;

@end

