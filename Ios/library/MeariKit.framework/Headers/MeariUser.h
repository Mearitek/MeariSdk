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
@class MeariMessageInfoShare;
@class MeariShareCameraInfo;
@class MeariDeviceHostMessage;
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
typedef void(^MeariSuccess_DeviceVoiceMsg)(MeariDeviceHostMessage *msg);
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
typedef void(^MeariSuccess_MsgShareList)(NSArray <MeariMessageInfoShare *>*msgs);
typedef void(^MeariSuccess_ShareCameraInfo)(NSArray <MeariShareCameraInfo *>*shareCameraList);
typedef void(^MeariSuccess_payWebUrl)(NSString *payWebUrl, NSString *paySuccessUrl);
typedef void(^MeariSuccess_Dictionary)(NSDictionary *dict);
typedef void(^MeariSuccess_Str)(NSString *str);
typedef void(^MeariSuccess_OnlineHelp)(NSString *str,NSString *type);
typedef void(^MeariSuccess_BOOL)(BOOL isSuccess);
typedef void(^MeariFailure)(NSError *error);
typedef void(^MeariSuccess_RequestAuthority)(NSInteger msgEffectTime,double serverTime);
typedef void(^MeariSuccess_RedDot)(BOOL hasShare, BOOL hasAlarm);

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
 及时消息通知
 */
UIKIT_EXTERN  NSString *const MeariDeviceOnlineNotification;        //Device online (设备上线)
UIKIT_EXTERN  NSString *const MeariDeviceOfflineNotification;       //Device offline(设备离线)
UIKIT_EXTERN  NSString *const MeariDeviceCancelSharedNotification;  //Device is unshared(设备被取消分享)
UIKIT_EXTERN  NSString *const MeariDeviceFriendSharedDeviceNotification;        //Friend sharing device(好友分享设备)
UIKIT_EXTERN  NSString *const MeariDeviceHasVisitorNotification;    //Device (doorbell) has visitors (设备(门铃)有访客)
UIKIT_EXTERN  NSString *const MeariDeviceHasBeenAnswerCallNotification;    //Device (doorbell) has be answered (设备(门铃)已经被接听)
UIKIT_EXTERN  NSString *const MeariDeviceVoiceBellHasVisitorNotification;    //Device (voice doorbell) has visitors (设备(门铃)有访客)
UIKIT_EXTERN  NSString *const MeariDeviceUnbundlingNotification;    //The device is unbundled (设备被解绑)
UIKIT_EXTERN  NSString *const MeariUserLoginInvalidNotification;    //User login information is invalid, need to log in again (用户登录信息失效，需要重新登录)
UIKIT_EXTERN  NSString *const MeariDeviceAutoAddNotification; //Automatic device add (设备自动添加)
UIKIT_EXTERN  NSString *const MeariDeviceConnectMqttNotification; // mqtt connect (mqtt连接)
UIKIT_EXTERN  NSString *const MeariDeviceBindToChimeNotification; // bind chime success (chime 绑定成功)
UIKIT_EXTERN  NSString *const MeariDeviceNewShareToMeNotification; //New share notification (新版分享发送通知)
UIKIT_EXTERN  NSString *const MeariDeviceNewShareToHimNotification; //New share notification (新版分享发送通知)
UIKIT_EXTERN  NSString *const MeariDeviceFloodCameraStatusNotification; // the status of the floot camera (灯具摄像机的开关状态)

@interface MeariUser : NSObject
 
+ (instancetype)sharedInstance;

#pragma mark -- Property

/**
 User Info (用户信息)
 */
@property (nonatomic, strong, readonly)MeariUserInfo *userInfo;
/**
 Logged in (是否已登录)
 */
@property (nonatomic, assign, getter=isLogined, readonly) BOOL logined;

/**
 Account type (账号类型)
 */
@property (nonatomic, assign, readonly) MeariUserAccountType accountType;

/**
Whether mqtt is connected (mqtt是否已连接)
 */
@property (nonatomic, assign, getter=isConnected, readonly) BOOL connected;
/**
 Whether data migration (是否数据迁移)
 */
@property (nonatomic, assign) BOOL migrate;
/**
 Doorbell ringing time (门铃响铃时长)
 */
@property (nonatomic, assign) NSInteger ringDuration;
/**
 是否支持客服
 */
@property (nonatomic, assign) BOOL supportClient;
/**
 是否支持log
 */
@property (nonatomic, assign) BOOL supportLog;

/**
    重新定向访问地址
 
    - 切换账号
    - 修改国家
 */
- (void)resetRedirect;

#pragma mark - User

/**
 register Message notification
 注册苹果推送
 
 @param deviceToken Phone Token (手机Token)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)registerPushWithDeviceToken:(NSData *)deviceToken success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 用户获取验证码

 @param userAccount User account: mailbox or mobile phone(用户账号：邮箱或手机)
 @param countryCode country code (国家代号)
 @param phoneCode country phone code(国际手机前缀).
 @param success Successful callback (成功回调)，返回验证码剩余有效时间，单位秒
 @param failure failure callback (失败回调)
 */
- (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

/**
 注册账号

 @param userAccount User account: E-mail or mobile phone number (in mainland China only) / 用户账号：邮箱或手机号(仅限中国大陆地区)
 @param password User password (用户密码)
 @param countryCode country code (国家代号)
 @param phoneCode country phone code(国际手机前缀).
 @param verificationCode verification code(验证码)
 @param nickname User nickname, can be modified after login(用户昵称，登录后可修改)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)registerWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 登录账号

 @param userAccount User account: mailbox or mobile phone(用户账号：邮箱或手机)
 @param password User password(用户密码)
 @param countryCode country code (国家代号)
 @param phoneCode country phone code(国际手机前缀).
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)loginWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 third type login
 三方登录

 @param userId userId 用户名
 @param thirdToken third token(三方token)
 @param countryCode country code (国家代号)
 @param phoneCode country phone code(国际手机前缀).
 @param thirdUserName username(昵称)
 @param thirdImageUrl user Image (头像)
 @param loginType login type(登录方式 1: fackbook)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)loginThirdWithUserId:(NSString *)userId thirdToken:(NSString *)thirdToken countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode thirdUserName:(NSString *)thirdUserName thirdImageUrl:(NSString *)thirdImageUrl loginType:(MeariThirdLoginType)loginType success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Change-find password
 修改找回密码

 @param userAccount User account: mailbox or mobile phone / 用户账号：邮箱或手机号(仅限中国大陆地区)
 @param password User password / 用户密码
 @param countryCode country code / 国家代号
 @param phoneCode country phone code (国家区号) --- 例如: 中国区的话传 86 (如果是登录后,必须传, 登录前, 传nil)
 @param verificationCode 验证码
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)resetPasswordWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Log in via Uid / 通过Uid登录
 
 @param uid User ID, need to guarantee uniqueness, <=32 bit (用户ID，需要保证唯一性，<=32位)
 @param countryCode country code (国家代号)
 @param phoneCode country phone code(国际手机前缀)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)loginWithUid:(NSString *)uid countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode  success:(MeariSuccess)success  failure:(MeariFailure)failure;



/**
 Log out of the account (登出账号)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;



/**
 上传头像

 @param image Image (原图)
 @param success Successful callback (成功回调)，返回头像的url
 @param failure failure callback (失败回调)
 */
- (void)uploadUserAvatarWithImage:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;


/**
 修改昵称

 @param name New nickname, 6-20 digits in length (新的昵称，长度6-20位)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)renameNicknameWithName:(NSString *)name  success:(MeariSuccess)success failure:(MeariFailure)failure;
#pragma mark - App

/**
 Sound push
 声音推送

 @param openSound whether to open ( 是否开启)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */

- (void)notificationSoundOpen:(BOOL)openSound success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Device push(设备推送)
 
 @param deviceID 设备ID
 @param enable (whether to open)开关
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deviceAlarmNotificationEnable:(BOOL)enable deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Feedback (意见反馈)

 @param content content(Required) (反馈内容(必填))
 @param mark Any string (you can upload device information) E.g: {"Version:":"12.1.3","OS":"iOS","Phone":"iPhone 6s"}  Must be a json string
       任意字符串(可以上传设备信息)(选填) 例如: {"版本／Version:":"12.1.3","系统／OS":"iOS","手机/Phone":"iPhone 6s"} 必须是个json字符串
 @param contactInfo User contact information   E.g: 638933839@163.com Email is the best
                    联系方式  例如: 638933839@163.com  邮箱是最好的
 @param lightStatus 状态灯状态(选填) 例如: 指示灯蓝灯快闪   内容自定义
                    light status(You can upload the current user's indicator status (any string))     E.g: Lights flashing blue light Content Customization
 @param sn 设备sn号(选填) 例如: 056757160
           Device sn number    e.g: 056757160
 @param type 快速提问字符串(选填) : 2,3,4,6
             Quick question json string (0,1,2,3,4,5)   e.g:  2,3,4,6
 @param imageDataArray 反馈图片(选填) 请用UIImageJPEGRepresentation()方法传二进制原图数组,图片个数不超过四张
                       Optional : Feedback picture     Please use the UIImageJPEGRepresentation() method to transfer the binary image array. The number of images is no more than four.
 @param snImageData sn图片(选填) UIImageJPEGRepresentation方法传二进制数据
                   Optional : Sn picture     UIImageJPEGRepresentation method to pass binary data
  @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)feedbackWithContent:(NSString *)content mark:(NSString *)mark contactInfo:(NSString *)contactInfo
                lightStatus:(NSString *)lightStatus sn:(NSString *)sn type:(NSString *)type imageDataArray:(NSArray<NSData *> *)imageDataArray snImageData:(NSData *)snImageData success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 check app version from servion
 app检查版本

 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)appCheckVersionSuccess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 check app version from servion
 从app获取版本

 @param appID appid
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)appCheckVersionFromAppstoreWithAppID:(NSString *)appID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
 Get startup page ads
 获取启动页广告

 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getLaunchADSuccess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 data migration
 数据迁移

 @param countryCode 国家代号
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)AppMigrateWithCountryCode:(NSString *)countryCode success:(MeariSuccess_BOOL)success failure:(MeariFailure)failure;

/**
 Upload Montion File
 上传日志文件
 
 @param fileData Binary data(二进制文件)
 @param preUrl Domain address (域名地址)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)UploadMontionWithFileData:(NSData *)fileData preUrl:(NSString *)preUrl success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 获取code

 @param appID 应用唯一标识
 @param secret 应用密钥AppSecret
 @param code 微信获得的code
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getWeChatAccessTokenWithAppID:(NSString *)appID secret:(NSString *)secret code:(NSString *)code success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;


#pragma mark -- Cloud

/**
 Get cloud storage status (new)
 获取云存储状态 (新)

 @param deviceID device ID (设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cloudGetStatusWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Cloud storage trial
 云存储试用

 @param deviceID  device ID (设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cloudTryWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Cloud storage Activation code
 云存储激活码
 
 @param deviceID  device ID (设备ID)
 @param code Activation code (激活码)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cloudActivationWithDeviceID:(NSInteger)deviceID code:(NSString *)code success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Cloud storage creation order
 云存储创建订单

 @param deviceID  device ID (设备ID)
 @param serverTime Service period (month/year) Example: 11 (服务期限(月/年) 例 : 11)
 @param payMoney 支付金额
 @param mealType Year or month Example: @"Y" @"M"  (年还是月 例 : @"Y" @"M")
 @param storageTime Number of days Example : 30  ( 天数 例 : 30)
 @param storageType 0: Event recording 1: All day recording  (0:事件录像 1:全天录像)
 @param payType 1: Alipay 2 PayPal (1: 支付宝 2贝宝)
 @param paymentMethodNonce PayPal payment callback tokenizedPayPalAccount.nonce (贝宝支付回调tokenizedPayPalAccount.nonce)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cloudCreateOrderWithDeviceID:(NSInteger)deviceID serverTime:(NSInteger)serverTime payMoney:(NSString *)payMoney mealType:(NSString *)mealType storageTime:(NSInteger)storageTime storageType:(NSInteger)storageType payType:(NSInteger)payType paymentMethodNonce:(NSString *)paymentMethodNonce success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

    
/**
 Cloud storage creation order by Alipay
 云存储创建订单

 @param deviceID  device ID (设备ID)
 @param serverTime Service period (month/year) Example: 11 (服务期限(月/年) 例 : 11)
 @param payMoney payment amount (支付金额)
 @param mealType 年还是月 例 : @"Y" @"M"
 @param storageTime 天数 例 : 30
 @param storageType 0:事件录像 1:全天录像
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cloudGetAlipayHtmlWithDeviceID:(NSInteger)deviceID serverTime:(NSInteger)serverTime payMoney:(NSString *)payMoney mealType:(NSString *)mealType storageTime:(NSInteger)storageTime storageType:(NSInteger)storageType success:(MeariSuccess_payWebUrl)success failure:(MeariFailure)failure;
/**
 My order list
 我的订单列表

 @param deviceID  device ID (设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cloudGetOrderListWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Get device payment token
 获取设备付款token

 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cloudGetPayPalTokenSuccess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;



#pragma mark - Device

/**
 Getting device list information
 获取设备列表

 @param success Successful callback (成功回调)，返回设备列表
 @param failure failure callback (失败回调)
 */
- (void)getDeviceListSuccess:(MeariSuccess_DeviceList)success failure:(MeariFailure)failure;

/**
 Get all your own device
 获取当前用户下的自己的设备

 @param success Successful callback (成功回调)，返回设备列表
 @param failure failure callback (失败回调)
 */
- (void)getOwnerDeivcesSuccess:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

/**
 check device's status on server by searched origin device info
 查询设备信息

 @param type device type(设备类型)
 @param devices Device to be queried: need to use the device interface to search for devices(要查询的设备：需使用调用设备接口，搜索出来的设备)
 @param success Successful callback // return to device list(返回设备列表)
 @param failure failure callback (失败回调)
 */
- (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;


/**
 Add device
 添加设备 (推荐)
 
 @param device  the device of search(搜索到的设备)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)addDevice:(MeariDevice *)device success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 Remove the device(移除设备)
 
 @param type device type(设备类型)
 @param deviceID device ID(设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteDeviceWithType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
  rename device 修改设备昵称

 @param type device type(设备类型)
 @param deviceID device ID(设备ID)
 @param nickname New nickname, length 6-20(新的昵称，长度6-20位)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)renameDeviceWithType:(MeariDeviceType)type deviceID:(NSInteger)deviceID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 // a single device one day alarm time point to obtain
 (单个设备某天报警时间点获取)
 
 @param deviceID device ID(设备ID)
 @param date (The format is 20171212) 日期：格式为20171212
 @param success Successful callback (成功回调)：return to the alarm time list(返回报警时刻列表)
 @param failure failure callback (失败回调)
 */
- (void)getAlarmMessageTimesWithDeviceID:(NSInteger)deviceID onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;


/**
 Query the device for a new version
 (查询设备是否有新版本)
 @param deviceSn device SN(设备sn)
 @param tp device tp(设备的tp)
 @param currentFirmware Current version(当前版本)
 @param success Successful callback (成功回调): Returns the latest version information of the device(返回设备最新版本信息)
 @param failure failure callback (失败回调)
 */
- (void)checkNewFirmwareWith:(NSString *)deviceSn tp:(NSString *)tp currentFirmware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;

/**
 Query the device is online?
 (查询设备是否在线)
 
 @param deviceID device ID(设备ID)
 @param success Successful callback (成功回调)：Returns whether the device is online(返回设备是否在线)
 @param failure failure callback (失败回调)
 */
- (void)checkDeviceOnlineStatusWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceOnlineStatus)success failure:(MeariFailure)failure;


/**
 Remote wake-up doorbell
 (远程唤醒门铃)
 
 @param deviceID device ID(设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)remoteWakeUpWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Is the doorbell still answering
 发送心跳
When you are in the answering process, please use the timer to loop this call to call the answer in 10s, and inform the doorbell answering status.
当你在接听过程中 ,请使用定时器10s 循环这个调用这个接听, 告知门铃接听状态.
 
 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)sendHeartBeatWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 The device switches to sleep mode. When Wi-Fi changes, please call this interface to notify whether to enter sleep mode.
 设备切换休眠模式, 当Wi-Fi发生改变的时候, 请调用该接口通知是否进入休眠模式
 deviceList.count must  ==  modeList.count
 
 @param deviceList Device array, which stores the device ID of each device (设备数组, like: [057377002, 057377012, 057377022])
 @param modeList 是否开启的数组 [@"on", @"off", @"off"];
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 
 on or off ==>             NSString *mode =  ((camera.info.sleepMode == MeariDeviceSleepModeLensOffByGeographic||camera.param.sleepMode == MeariDeviceSleepModeLensOffByGeographic) &&
 [camera.info.wifiSsid isEqualToString:ssid]) ? @"on" : @"off";
 */
- (void)settingGeographyLocationWithDeviceList:(NSArray *)deviceList modeList:(NSArray *)modeList success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 iot 设备
The device switches to sleep mode. When Wi-Fi changes, please call this interface to notify whether to enter sleep mode.
设备切换休眠模式, 当Wi-Fi发生改变的时候, 请调用该接口通知是否进入休眠模式
deviceList.count must  ==  modeList.count

@param deviceList Device array, which stores the device ID of each device (设备数组, like: [057377002, 057377012, 057377022])
@param sleepAction 是否开启的数组 [@"0", @"1", @"1"];
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
 
*/
- (void)settingGeographyLocationWithIotDeviceList:(NSArray *)arrays sleepAction:(NSArray *)actions success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 设置地理围栏

 @param ssid wifi SSID
 @param bssid wifi BSSID
 @param deviceID (device ID)设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setGeofenceWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 ota 升级

 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)otaUpgradeWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark -- 留言

/**
 Download message
 (下载留言)
 
 @param voiceUrl Message address(留言地址)
 @param success Successful callback (成功回调)，return value: audio data(返回值：音频数据)
 @param failure failure callback (失败回调)
 */
- (void)downloadVoiceWithVoiceUrl:(NSString *)voiceUrl filePath:(NSString *)filePath success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Upload doorbell message
 (上传门铃留言)
 
 @param deviceID device ID(设备ID)
 @param file message file path(留言文件路径)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)uploadVoiceWithDeviceID:(NSInteger)deviceID videoName:(NSString *)fileName voiceFile:(NSString *)file success:(MeariSuccess_DeviceVoiceMsg)success failure:(MeariFailure)failure;

/**
 Delete doorbell message
 (删除门铃留言)
 
 @param deviceID device ID(设备ID)
 @param voiceID 语音留言ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteVoiceWithDeviceID:(NSInteger)deviceID voiceID:(NSString *)voiceID success:(MeariSuccess)success failure:(MeariFailure)failure;


#pragma mark -- NVR

/**
 nvr get list of bound devices
 nvr获取绑定的设备列表

 @param nvrID nvr ID
 @param success Successful callback (成功回调)：return the list of bound devices and unbound device list(返回绑定的设备列表和未绑定的设备列表)
 @param failure failure callback (失败回调)
 */
- (void)getBindDeviceListWithNvrID:(NSInteger)nvrID success:(MeariSuccess_DeviceListForNVR)success failure:(MeariFailure)failure;


/**
 nvr binding device
 nvr绑定设备

 @param deviceID device ID(设备ID)
 @param nvrID nvr ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)bindDeviceWithDeviceID:(NSInteger)deviceID fromNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 nvr unbundling device
 nvr解绑设备

 @param deviceID device ID(设备ID)
 @param nvrID nvr ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)unbindDeviceWithDeviceID:(NSInteger)deviceID fromNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 nvr unbind multiple devices
 nvr解绑多个设备

 @param deviceIDs Multiple device IDs(多个设备ID)
 @param nvrID nvr ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)unbindDevicesWithDeviceIDs:(NSArray <NSNumber *>*)deviceIDs fromNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark -- Music

/**
  Query music list
 (查询音乐列表)
 
 @param success Successful callback (成功回调)：return to music list(返回音乐列表)
 @param failure failure callback (失败回调)
 */
- (void)getMusicListSuccess:(MeariSuccess_Music)success failure:(MeariFailure)failure;

#pragma mark -- Configure

/**
 Get the distribution network token
 (获取配网token)
 
 @param tokenType Different distribution modes correspond to different Tokens(不同配网模式对应不同的Token)
 @param success Successful callback (成功回调)：
 token: for distribution network(用于配网)
 validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.(token有效时长，超过时长需要重新获取新的token)
 @param failure failure callback (失败回调)
 */
- (void)getTokenWithTokenType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token2)success failure:(MeariFailure)failure;
/**
 Generate QR code
 生成二维码

 @param ssid wifi name(wifi名称)
 @param password wifi password(wifi密码)
 @param token code token(二维码token)
 @param size QR code size(二维码大小)
 @return QR code image(二维码图片)
 */
- (UIImage *)createQRCodeWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;


#pragma mark - Share

/**
 分享设备给好友

 @param type 设备类型
 @param deviceID 设备ID
  @param deviceUUID 用户uuid
 @param friendID 好友ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)shareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID deviceUUID:(NSString *)deviceUUID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 取消对好友的设备分享

 @param type 设备类型
 @param deviceID 设备ID
 @param deviceUUID 用户uuid
 @param friendID 好友ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cancelShareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID deviceUUID:(NSString *)deviceUUID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 查询单个设备被分享的好友列表

 @param type 设备类型
 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getFriendListForDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess_FriendListForDevice)success failure:(MeariFailure)failure;



#pragma mark - Share 2.0
/**
 get shared List of device
 获取设备分享列表
 
 @param deviceID (device ID)设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getShareListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

/**
 取消分享

 @param deviceID 设备ID
 @param shareAccount 分享账号
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)cancelShareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 cancel share devie
 (取消分享设备)
 
 @param deviceID 设备ID
 @param shareAccount 分享账号
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)shareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Search user
 (搜索用户)
 
 @param deviceID 设备ID
 @param userAccount 用户账号
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)searchUserWithDeviceID:(NSInteger)deviceID account:(NSString *)userAccount success:(MeariSuccess_Share)success failure:(MeariFailure)failure;

/**
 get history shared list
 获取历史分享列表
 
 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getHistoryShareWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

/**
 delete history shared user
 删除历史分享用户
 
 @param deviceID 设备ID
 @param shareAccountArray 分享数组
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteHistoryShareWithDeviceID:(NSInteger)deviceID shareAccountArray:(NSArray *)shareAccountArray success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 (get all the your device's shared result)
 获取所有设备的分享结果
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getAllDeviceShareSuccess:(MeariSuccess_ShareCameraInfo)success failure:(MeariFailure)failure;

/**
 请求分享某人的设备(这会发送一条请求, 在 getShareMessageListSuccess:failure: 列表接口中获取, 并发送apns推送消息)
 Request to share someone's device (this will send a request, get it in the getShareMessageListSuccess: failure: list interface, and send an apns push message)
 
 you Request another to share a device to you
 (你请求其他人去分享设备给你)
 
 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)requestShareDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark - Message

/**
 Get whether there is a message red dot (share message, alarm message)
 获取是否有消息红点(分享消息, 报警消息)
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getMessageRedDotSuccess:(MeariSuccess_RedDot)success failure:(MeariFailure)failure;

/**
 Get all devices have a message
 获取所有设备是否有消息
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getAlarmMessageListSuccess:(MeariSuccess_MsgAlarmList)success failure:(MeariFailure)failure;

/**
 Get system messages
 获取系统消息
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getSystemMessageListSuccess:(MeariSuccess_MsgSystemList)success failure:(MeariFailure)failure;


/**
 get all the alarm messgae of one device
 (获取某个设备报警消息)
 
 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getAlarmMessageListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;

/**
 Delete system messages in bulk
 批量删除系统消息
 
 @param msgIDs 多个消息ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteSystemMessagesWithMsgIDs:(NSArray <NSNumber *>*)msgIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Delete multiple device alarm messages in batch
 批量删除多个设备报警消息
 
 @param deviceIDs Multiple device IDs(多个设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteAlarmMessagesWithDeviceIDs:(NSArray <NSNumber *>*)deviceIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 Delete all alarm messages for a device
 删除某个设备的所有报警消息

 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteAllAlarmMessagesWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 同意添加好友

 @param friendID 好友ID
 @param msgID 消息ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)agreeAddFriendWithFriendID:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 拒绝添加好友

 @param friendID 好友ID
 @param msgID 消息ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)refuseAddFriendWithFriendID:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 同意分享设备给好友
 Agree to share the device with friends

 @param deviceID 设备ID
 @param friendID 好友ID
 @param msgID 消息ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)agreeShareDeviceWithDeviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 拒绝分享设备给好友
 Refuse to share device
 
 @param deviceID 设备ID
 @param friendID 好友ID
 @param msgID 消息ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)refuseShareDeviceWithDeviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 标记设备报警消息为已读
 Mark device alarm messages as read

 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)markDeviceAlarmMessageWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 获取oss图片url地址
 Get oss image URL
 
 // Get the alarm message picture address, Note: The valid period of the url is 1 hour, it will expire after one hour, please pay attention to save the original data of the picture
 // 获取报警消息图片地址, 注意: url的有效期为1个小时, 一个小时后失效,  请注意保存图片原数据 
 
 @param url  image url (图片url)
 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getOssImageUrlWithUrl:(NSString *)url deviceID:(NSInteger)deviceID success:(MeariSuccess_Str)success failure:(MeariFailure)failure;

/**
 // Obtain image source data, which can be saved locally, resources are always valid
 // 获取图片源数据, 可以保存之本地, 资源一直有效
 
 @param url 图片url (image url)
 @param deviceID 设备ID
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getOssImageDataWithUrl:(NSString *)url deviceID:(NSInteger)deviceID  success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
// Determine whether the picture ends with jepx1. If it is in the format ending with jepx1, it needs to be decrypted.
// 判断图片是否是以jepx1结尾 如果是以jepx1结尾的格式 需要进行解密操作

@param deviceSN 设备的SN(device.info.sn)
@param imageData  图片的二进制数据 (image data)
@return 解密完成的数据 (image data)
*/
- (NSData *)decryptImageDataWith:(NSString *)deviceSN imageData:(NSData *)imageData;

/**
 Get list of shared messages
 获取分享消息列表
 
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getShareMessageListSuccess:(MeariSuccess_MsgShareList)success failure:(MeariFailure)failure;

/**
 Delete shared message
 删除分享消息
 
 @param msgIDArray 消息ID列表
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteShareRequestListWithMsgIDArray:(NSArray *)msgIDArray success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 Handling shared messages
 处理分享消息
 
 @param msgID (message ID)消息ID
 @param accept whether to accept (是否接受)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)dealShareMsgWithMsgID:(NSString *)msgID accept:(BOOL)accept success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark - VoiceBell
/**
 Get the device's visitor event
 Note: including answering, hanging up, message information
 
 获取设备的访客事件
 注：包括接听、挂断、留言信息
 
 @param deviceID device ID (设备ID)
 @param pageNum Pages(页数) 1~
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)getVisitorMessageListWithDeviceID:(NSInteger)deviceID pageNum:(NSInteger)pageNum success:(MeariSuccess_MsgVoiceDeviceList)success failure:(MeariFailure)failure;


/**
 Mark the message as read
 (标记消息为已读)
 
 @param messageID message ID(消息ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)markReadVoiceMessageWithMessageID:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 Delete a single message from a device
 删除某个设备的单条消息
 
 @param messageID message ID(消息ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteVoiceMessageWithMessageID:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 Delete all messages under a device
 删除某个设备下所有消息
 
 @param deviceID device ID (设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)deleteAllVoiceMessageWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 // Used to answer the doorbell, must be used with "requestReleaseAnswerAuthorityWithID"
 // 用于接听门铃, 必须和“ requestReleaseAnswerAuthorityWithID” 一起使用
 
 @param deviceID 设备ID
 @param messageID 消息ID (the data create by push, or mqtt)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)requestAnswerAuthorityWithDeviceID:(NSInteger)deviceID messageID:(NSInteger)messageID  success:(MeariSuccess_RequestAuthority)success failure:(MeariFailure)failure;

/**
 // Used to hang up the doorbell, must be used with "requestAnswerAuthorityWithDeviceID"
 // 用于挂掉门铃, 必须和“ requestAnswerAuthorityWithDeviceID” 一起使用
 
 @param ID  device ID (设备ID)
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)requestReleaseAnswerAuthorityWithID:(NSInteger)ID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
// get origin data of voice message

@param remoteUrl  voice url (语音链接)
 @param deviceID  device ID (设备ID)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)getVoiceMessageAudioDataWithRemoteUrl:(NSString *)remoteUrl deviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceVoiceData)sourceData failure:(MeariFailure)failure;
/**
 Get customer service page
 获取客服页面

 @param success Successful callback (成功回调) url:客服网页地址
 @param failure failure callback (失败回调)
 */
- (void)getClientServerWithDeviceSns:(NSArray *)sns success:(MeariSuccess_OnlineHelp)success failure:(MeariFailure)failure;
#pragma mark - Monitor
/**
 Listening to the network
 有网

 @param available 有网
 @param unavailable 没网
 */
+ (void)HttpMonitorNetworkAvailable:(MeariSuccess)available unavailable:(MeariSuccess)unavailable;

/**
 Listening for no network
 监听没有网络

 @param unreachable 没有网络
 */
+ (void)HttpMonitorNetworkUnreachable:(MeariSuccess)unreachable;


/**
 Whether the current wifi environment
 当前是否wifi环境

 @return YES or NO
 */
+ (BOOL)checkCurrentNetworkStatusWifi;

/**
 Listening to network status
 监听网络状态

 @param networkChanged 网络状态
 */
+ (void)HttpMonitorNetworkStatus:(void (^)(MeariNetworkReachabilityStatus status))networkChanged;

/**
 Stop listening
 停止监听
 */
+ (void)HttpStopMonitor;

#pragma mark --- html

/**
获取帮助文档链接

 @param helpType 帮助类型
 @param isChinese 是否是中文
 @return 链接
 */
- (NSString *)getHelpLinkWithHelpType:(MeariHelpType)helpType isChinese:(BOOL)isChinese;

#pragma mark - Cancel

/**
 Cancel all network requests
 取消所有的用户请求
 */
- (void)cancelAllRequest;

@end
