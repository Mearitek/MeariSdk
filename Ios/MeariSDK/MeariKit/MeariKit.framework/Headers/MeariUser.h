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
 及时消息通知
 */
UIKIT_EXTERN  NSString *const MeariDeviceOnlineNotification;        //设备上线
UIKIT_EXTERN  NSString *const MeariDeviceOfflineNotification;       //设备离线
UIKIT_EXTERN  NSString *const MeariDeviceCancelSharedNotification;  //设备被取消分享
UIKIT_EXTERN  NSString *const MeariDeviceFriendSharedDeviceNotification;        //好友分享设备
UIKIT_EXTERN  NSString *const MeariDeviceHasVisitorNotification;    //设备(门铃)有访客
UIKIT_EXTERN  NSString *const MeariDeviceVoiceBellHasVisitorNotification;    //设备(语音门铃)有访客
UIKIT_EXTERN  NSString *const MeariDeviceUnbundlingNotification;    //设备被解绑
UIKIT_EXTERN  NSString *const MeariUserLoginInvalidNotification;    //用户登录信息失效，需要重新登录
UIKIT_EXTERN  NSString *const MeariDeviceAutoAddNotification; //设备自动
UIKIT_EXTERN  NSString *const MeariDeviceAutobundleSuccessNotification; //设备绑定
UIKIT_EXTERN  NSString *const MeariDeviceConnectMqttNotification; // mqtt连接
UIKIT_EXTERN  NSString *const MeariDeviceSDCardFormatPercentNotification; //格式化百分比
UIKIT_EXTERN  NSString *const MeariDeviceUpgradePercentPercentNotification; //升级百分比
UIKIT_EXTERN  NSString *const MeariDeviceWiFiStrengthChangeNotification; //Wi-Fi信号强度
UIKIT_EXTERN  NSString *const MeariDeviceFloodCameraStatusNotification; //灯具摄像机的开关状态
UIKIT_EXTERN  NSString *const MeariDeviceChangeTempHumidityNotification; //温湿度变化
UIKIT_EXTERN  NSString *const MeariDeviceSdStatusChangeNotification; //sd卡状态变化变化


@interface MeariUser : NSObject
 
+ (instancetype)sharedInstance;

#pragma mark -- Property

/**
 用户信息
 */
@property (nonatomic, strong, readonly)MeariUserInfo *userInfo;
/**
 是否已登录
 */
@property (nonatomic, assign, getter=isLogined, readonly) BOOL logined;

/**
 账号类型
 */
@property (nonatomic, assign, readonly) MeariUserAccountType accountType;

/**
 mqtt是否已连接
 */
@property (nonatomic, assign, getter=isConnected, readonly) BOOL connected;
/**
 是否数据迁移
 */
@property (nonatomic, assign) BOOL migrate;
/**
 门铃响铃时长
 */
@property (nonatomic, assign) NSInteger ringDuration;


/**
    重新定向访问地址
 
    - 切换账号
    - 修改国家
 */
- (void)resetRedirect;

#pragma mark - User

/**
 注册苹果推送
 
 @param deviceToken 手机Token
 @param success 成功回调
 @param failure 失败回调
 */
- (void)registerPushWithDeviceToken:(NSData *)deviceToken success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 用户获取验证码

 @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区)
 @param countryCode 国家代号 --- 例如: 在中国我们可以传: CN
 @param phoneCode 国家区号 --- 例如: 中国区的话传 86
 @param success 成功回调，返回验证码剩余有效时间，单位秒
 @param failure 失败回调
 */
- (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

/**
 注册账号

 @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区)
 @param password 用户密码
 @param countryCode 国家代号 --- 例如: 在中国我们可以传: CN
 @param phoneCode 国家区号 --- 例如: 中国区的话传 86
 @param verificationCode 验证码
 @param nickname 用户昵称，登录后可修改
 @param success 成功回调
 @param failure 失败回调
 */
- (void)registerAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 登录账号

 @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区) --- 例如:  15958221112
 @param password 用户密码 --- 例如: 123456
 @param countryCode 国家代号 --- 例如: 在中国我们可以传: CN
 @param phoneCode 国家区号 --- 例如: 中国区的话传 86
 @param success 成功回调
 @param failure 失败回调
 */
- (void)loginAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 三方登录

 @param userId 用户名
 @param thirdToken 三方token
 @param countryCode 国家代号 --- 例如: 在中国我们可以传: CN
 @param phoneCode 国家区号 --- 例如: 中国区的话传 86
 @param thirdUserName 昵称
 @param thirdImageUrl 头像
 @param loginType 登录方式 1: fackbook
 @param success 成功回调
 @param failure 失败回调
 */
- (void)loginThirdWithUserId:(NSString *)userId thirdToken:(NSString *)thirdToken countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode thirdUserName:(NSString *)thirdUserName thirdImageUrl:(NSString *)thirdImageUrl loginType:(MeariThirdLoginType)loginType success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 修改密码

 @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区)
 @param password 用户密码
 @param verificationCode 验证码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)changePasswordWithAccount:(NSString *)userAccount password:(NSString *)password verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 找回密码

 @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区)
 @param password 新的密码
 @param countryCode 国家代号
 @param phoneCode 国家区号
 @param verificationCode 验证码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)findPasswordWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;



/**
 通过Uid登录

 @param uid 用户ID，需要保证唯一性，<=32位
 @param countryCode 国家代号
 @param phoneCode 国家区号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)loginWithUid:(NSString *)uid countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode  success:(MeariSuccess)success  failure:(MeariFailure)failure;



/**
 登出账号

 @param success 成功回调
 @param failure 失败回调
 */
- (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;



/**
 上传头像

 @param image 图片 (传原图即可)
 @param success 成功回调，返回头像的url
 @param failure 失败回调
 */
- (void)uploadUserAvatar:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;


/**
 修改昵称

 @param name 新的昵称，长度6-20位
 @param success 成功回调
 @param failure 失败回调
 */
- (void)renameNickname:(NSString *)name  success:(MeariSuccess)success failure:(MeariFailure)failure;
#pragma mark - App

/**
 声音推送

 @param openSound 是否开启
 @param success 成功回调
 @param failure 失败回调
 */
- (void)notificationSoundSwitch:(BOOL)openSound success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 设备推送
 
 @param deviceID 设备ID
 @param enable 开关
 @param success 成功g回调
 @param failure 失败回调
 */
- (void)devicePushEnableWithDeviceID:(NSInteger)deviceID enable:(BOOL)enable success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 意见反馈

 @param content 反馈内容(必填)
 @param mark 任意字符串(可以上传设备信息)(选填) 例如: {"版本／Version:":"12.1.3","系统／OS":"iOS","手机/Phone":"iPhone 6s"} 必须是个json字符串
 @param contactInfo 联系方式  例如: 638933839@163.com  邮箱是最好的
 @param lightStatus 状态灯状态(选填) 例如: 指示灯蓝灯快闪   内容自定义
 @param sn 设备sn号(选填) 例如: 056757160
 @param type 快速提问字符串(选填) : 2,3,4,6
 @param imageDataArray 反馈图片(选填) 请用UIImageJPEGRepresentation()方法传二进制原图数组,图片个数不超过四张
 @param snImageData sn图片(选填) UIImageJPEGRepresentation方法传二进制数据
  @param success 成功回调
 @param failure 失败回调
 */
- (void)feedbackWithContent:(NSString *)content mark:(NSString *)mark contactInfo:(NSString *)contactInfo
                lightStatus:(NSString *)lightStatus sn:(NSString *)sn type:(NSString *)type imageDataArray:(NSArray<NSData *> *)imageDataArray snImageData:(NSData *)snImageData success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 app检查版本

 @param success 成功回调
 @param failure 失败回调
 */
- (void)appCheckVersion:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 从app获取版本

 @param appID appid
 @param success 成功回调
 @param failure 失败回调
 */
- (void)appCheckVersionFromAppstore:(NSString *)appID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
/**
 获取启动页广告

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getLaunchAD:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 数据迁移

 @param countryCode 国家代号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)AppMigrateWithCountryCode:(NSString *)countryCode success:(MeariSuccess_BOOL)success failure:(MeariFailure)failure;

/**
 上传日志文件
 
 @param fileData 二进制文件
 @param preUrl 域名地址
 @param success 成功回调
 @param failure 失败回调
 */
- (void)UploadMontionFile:(NSData *)fileData preUrl:(NSString *)preUrl success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 获取code

 @param appID 应用唯一标识
 @param secret 应用密钥AppSecret
 @param code 微信获得的code
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getWeChatAccessTokenWithAppID:(NSString *)appID secret:(NSString *)secret code:(NSString *)code success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 检测是否退出登录

 @param success 成功回调
 @param failure 失败回调
 */
- (void)checkUserLoginOut:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

#pragma mark -- Cloud

/**
 获取云存储状态 (新)

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cloudGetStateWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 云存储试用

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cloudTryWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 云存储激活码
 
 @param deviceID 设备ID
 @param code 激活码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cloudActivationWithDeviceID:(NSInteger)deviceID code:(NSString *)code success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 云存储创建订单

 @param deviceID 设备ID
 @param serverTime 服务期限(月/年) 例 : 11
 @param payMoney 支付金额
 @param mealType 年还是月 例 : @"Y" @"M"
 @param storageTime 天数 例 : 30
 @param storageType 0:事件录像 1:全天录像
 @param payType 1: 支付宝 2贝宝
 @param paymentMethodNonce 贝宝支付回调tokenizedPayPalAccount.nonce
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cloudCreateOrderWithDeviceID:(NSInteger)deviceID serverTime:(NSInteger)serverTime payMoney:(NSString *)payMoney mealType:(NSString *)mealType storageTime:(NSInteger)storageTime storageType:(NSInteger)storageType payType:(NSInteger)payType paymentMethodNonce:(NSString *)paymentMethodNonce success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

    
/**
 云存储创建订单

 @param deviceID 设备ID
 @param serverTime 服务期限(月/年) 例 : 11
 @param payMoney 支付金额
 @param mealType 年还是月 例 : @"Y" @"M"
 @param storageTime 天数 例 : 30
 @param storageType 0:事件录像 1:全天录像
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cloudGetAlipayHtmlWithDeviceID:(NSInteger)deviceID serverTime:(NSInteger)serverTime payMoney:(NSString *)payMoney mealType:(NSString *)mealType storageTime:(NSInteger)storageTime storageType:(NSInteger)storageType success:(MeariSuccess_payWebUrl)success failure:(MeariFailure)failure;
/**
 我的订单列表

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cloudGetOrderListWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 获取设备付款token

 @param success 成功回调
 @param failure 失败回调
 */
- (void)cloudGetPayPalToken:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;



#pragma mark - Device

/**
 获取设备列表

 @param success 成功回调，返回设备列表
 @param failure 失败回调
 */
- (void)getDeviceList:(MeariSuccess_DeviceList)success failure:(MeariFailure)failure;

/**
 获取当前用户下的自己的设备

 @param success 成功回调，返回设备列表
 @param failure 失败回调
 */
- (void)getOwnerDeivces:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

/**
 查询设备信息

 @param type 设备类型
 @param devices 要查询的设备：需使用调用设备接口，搜索出来的设备
 @param success 成功回调：返回设备列表
 @param failure 失败回调
 */
- (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

/**
 添加设备

 @param type 设备类型
 @param uuid 设备uuid
 @param sn 设备sn
 @param tp 设备tp
 @param key 设备key
 @param deviceName 设备nickname
 @param success 成功回调
 @param failure 失败回调
 */
- (void)addDeviceWithDeviceType:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp key:(NSString *)key deviceName:(NSString *)deviceName success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 添加设备
 注：如果是添加成功设备后立即修改设备名称，需要更将返回的deviceID赋值给info.ID
 
 @param type 设备类型
 @param uuid 设备uuid
 @param sn 设备sn
 @param tp 设备tp
 @param key 设备key
 @param deviceName 设备nickname
 @param success 成功回调部分设备信息
 @param failure 失败回调
 */
- (void)addDeviceWithDeviceType2:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp key:(NSString *)key deviceName:(NSString *)deviceName success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 添加设备 (推荐)
 
 @param device 搜索到的设备
 @param success 成功回调部分设备信息
 @param failure 失败回调
 */
- (void)addDevice:(MeariDevice *)device success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 删除设备

 @param type 设备类型
 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 修改设备昵称

 @param type 设备类型
 @param deviceID 设备ID
 @param nickname 新的昵称，长度6-20位
 @param success 成功回调
 @param failure 失败回调
 */
- (void)renameDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 获取设备报警时刻列表

 @param deviceID 设备ID
 @param date 日期：格式为20171212
 @param success 成功回调：返回报警时刻列表
 @param failure 失败回调
 */
- (void)getAlarmMessageTimes:(NSInteger)deviceID onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;


/**
 查询设备最新版本信息

 @param currentFirmware 当前版本
 @param success 成功回调:返回设备最新版本信息
 @param failure 失败回调
 */
- (void)checkNewFirmwareWithCurrentFirmware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;

/**
 查询设备在线状态
 
 @param deviceID 设备ID
 @param success 成功回调：返回设备是否在线
 @param failure 失败回调
 */
- (void)checkDeviceOnlineStatus:(NSInteger)deviceID success:(MeariSuccess_DeviceOnlineStatus)success failure:(MeariFailure)failure;


/**
 远程唤醒

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)remoteWakeUp:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 获取视频地址

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getVideoUrl:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

/**
 发送心跳

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)sendHeartBeatWithID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 设备：切换休眠模式

 @param deviceList 设备数组
 @param modeList 是否开启的数组
 @param success 成功回调
 @param failure 失败回调
 */
- (void)settingGeographyLocationWithDeviceList:(NSArray *)deviceList modeList:(NSArray *)modeList success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 设置地理围栏

 @param ssid wifi的SSID
 @param bssid wifi的BSSID
 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)settingGeographyWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 ota 升级

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)otaUpgradeWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;
#pragma mark -- 留言

/**
 下载留言

 @param voiceUrl 留言地址
 @param success 成功回调，返回值：音频数据
 @param failure 失败回调
 */
- (void)downloadVoice:(NSString *)voiceUrl success:(MeariSuccess_DeviceVoiceData)success failure:(MeariFailure)failure;

/**
 上传留言

 @param deviceID 设备ID
 @param file 留言文件路径
 @param success 成功回调
 @param failure 失败回调
 */
- (void)uploadVoice:(NSInteger)deviceID voiceFile:(NSString *)file success:(MeariSuccess_DeviceVoiceUrl)success failure:(MeariFailure)failure;

/**
 删除留言

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteVoice:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


#pragma mark -- NVR

/**
 nvr获取绑定的社别列表

 @param nvrID nvr ID
 @param success 成功回调：返回绑定的设备列表和未绑定的设备列表
 @param failure 失败回调
 */
- (void)getBindDeviceList:(NSInteger)nvrID success:(MeariSuccess_DeviceListForNVR)success failure:(MeariFailure)failure;


/**
 nvr绑定设备

 @param deviceID 设备ID
 @param nvrID nvr ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)bindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 nvr解绑设备

 @param deviceID 设备ID
 @param nvrID nvr ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)unbindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 nvr解绑多个设备

 @param deviceIDs 多个设备ID
 @param nvrID nvr ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)unbindDevices:(NSArray <NSNumber *>*)deviceIDs toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark -- Music

/**
 获取音乐列表

 @param success 成功回调：返回音乐列表
 @param failure 失败回调
 */
- (void)getMusicList:(MeariSuccess_Music)success failure:(MeariFailure)failure;

#pragma mark -- Configure
/**
 
 生成二维码

 @param ssid wifi名称
 @param password wifi密码
 @param token 二维码token
 @param size 二维码大小
 @return 二维码图片
 */
- (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;

#pragma mark - Friend

/**
 获取好友列表

 @param success 成功回调：返回好友列表
 @param failure 失败回调
 */
- (void)getFriendList:(MeariSuccess_FriendList)success failure:(MeariFailure)failure;

/**
 添加好友

 @param userAccount 好友账号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)addFriend:(NSString *)userAccount success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 删除好友

 @param friendID 好友ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 删除多个好友

 @param friendIDs 多个好友ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteFriends:(NSArray <NSNumber *> *)friendIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 修改好友昵称

 @param friendID 好友ID
 @param markname 好友昵称
 @param success 成功回调
 @param failure 失败回调
 */
- (void)renameFriend:(NSInteger)friendID markname:(NSString *)markname success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark - Share

/**
 分享设备给好友

 @param type 设备类型
 @param deviceID 设备ID
  @param deviceUUID 用户uuid
 @param friendID 好友ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)shareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID deviceUUID:(NSString *)deviceUUID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 取消对好友的设备分享

 @param type 设备类型
 @param deviceID 设备ID
 @param deviceUUID 用户uuid
 @param friendID 好友ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cancelShareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID deviceUUID:(NSString *)deviceUUID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 请求分享某人的设备

 @param type 设备类型
 @param sn 设备sn
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestShareDeviceWithDeviceType:(MeariDeviceType)type sn:(NSString *)sn success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 查询单个设备被分享的好友列表

 @param type 设备类型
 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getFriendListForDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess_FriendListForDevice)success failure:(MeariFailure)failure;


/**
 查询某个好友的被分享设备列表

 @param friendID 好友ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getDeviceListForFriend:(NSInteger)friendID success:(MeariSuccess_DeviceListForFriend)success failure:(MeariFailure)failure;

#pragma mark - Share 2.0
/**
 获取设备分享列表

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getShareListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

/**
 取消分享

 @param deviceID 设备ID
 @param shareAccount 分享账号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)cancelShareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 分享设备

 @param deviceID 设备ID
 @param shareAccount 分享账号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)shareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 搜索用户

 @param deviceID 设备ID
 @param userAccount 用户账号
 @param success 成功回调
 @param failure 失败回调
 */
- (void)searchUserWithDeviceID:(NSInteger)deviceID account:(NSString *)userAccount success:(MeariSuccess_Share)success failure:(MeariFailure)failure;

/**
 获取历史分享列表

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getHistoryShareWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

/**
 删除历史记录

 @param deviceID 设备ID
 @param shareAccountArray 分享数组
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteHistoryShareWithDeviceID:(NSInteger)deviceID shareAccountArray:(NSArray *)shareAccountArray success:(MeariSuccess)success failure:(MeariFailure)failure;

#pragma mark - Message

/**
 获取报警消息

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getAlarmMessageList:(MeariSuccess_MsgAlarmList)success failure:(MeariFailure)failure;

/**
 获取系统消息

 @param success 成功回调
 @param failure 失败回调
 */
- (void)getSystemMessageList:(MeariSuccess_MsgSystemList)success failure:(MeariFailure)failure;


/**
 获取设备的报警消息

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getAlarmMessageListForDevice:(NSInteger)deviceID success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;


/**
 获取单张报警图片
 
 @param remoteUrl 图片网络地址
 @param deviceID 设备ID
 @param sourceData 图片二进制
 @param failure 失败回调
 */
- (void)getAlarmImageData:(NSString *)remoteUrl device:(NSInteger)deviceID success:(MeariSuccess_DeviceAlarmImageData)sourceData failure:(MeariFailure)failure;

/**
 删除系统消息

 @param msgIDs 多个消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteSystemMessages:(NSArray <NSNumber *>*)msgIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 删除多个设备消息

 @param deviceIDs 多个设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteAlarmMessages:(NSArray <NSNumber *>*)deviceIDs success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 删除某个设备的所有报警消息

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteAllAlarmMessagesForDevice:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 同意添加好友

 @param friendID 好友ID
 @param msgID 消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)agreeAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 拒绝添加好友

 @param friendID 好友ID
 @param msgID 消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)refuseAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 同意分享设备给好友

 @param deviceID 设备ID
 @param friendID 好友ID
 @param msgID 消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)agreeShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 拒绝分享设备给好友
 
 @param deviceID 设备ID
 @param friendID 好友ID
 @param msgID 消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)refuseShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;


/**
 标记设备报警消息为已读

 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)markDeviceAlarmMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 获取oss图片url地址

 @param url 图片url
 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getOssImageUrlWithUrl:(NSString *)url deviceID:(NSInteger)deviceID success:(MeariSuccess_Str)success failure:(MeariFailure)failure;

/**
 获取oss图片url data

 @param url 图片url
 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getOssImageDataWithUrl:(NSString *)url deviceID:(NSInteger)deviceID  success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

#pragma mark - VoiceBell
/**
 获取设备的访客事件
 注：包括接听、挂断、留言信息
 
 @param deviceID 设备ID
 @param pageNum 页数 1~
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getVisitorMessageListForDevice:(NSInteger)deviceID pageNum:(NSInteger)pageNum success:(MeariSuccess_MsgVoiceDeviceList)success failure:(MeariFailure)failure;

/**
 获取语音数据
 
 @param remoteUrl 音频网络地址
 @param sourceData 成功回调音频数据
 @param failure 失败回调
 */
- (void)getVoiceMessageAudioData:(NSString *)remoteUrl deviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceVoiceData)sourceData failure:(MeariFailure)failure;

/**
 标记消息为已读
 
 @param messageID 消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)markReadVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 删除某个设备的单条消息
 
 @param messageID 消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 删除某个设备下所有消息
 
 @param deviceID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteAllVoiceMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 接听门铃

 @param deviceID 设备ID
 @param messageID 消息ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestAnswerAuthorityWithDeviceID:(NSInteger)deviceID messageID:(NSInteger)messageID  success:(MeariSuccess_RequestAuthority)success failure:(MeariFailure)failure;

/**
 挂断门铃

 @param ID 设备ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestReleaseAnswerAuthorityWithID:(NSInteger)ID success:(MeariSuccess)success failure:(MeariFailure)failure;

/**
 获取客服页面

 @param success 成功回调 url:客服网页地址
 @param failure 失败回调
 */
- (void)getclientServerSuccess:(MeariSuccess_Str)success failure:(MeariFailure)failure;
#pragma mark - Monitor
/**
 有网

 @param available 有网
 @param unavailable 没网
 */
+ (void)HttpMonitorNetworkAvailable:(MeariSuccess)available unavailable:(MeariSuccess)unavailable;

/**
 监听没有网络

 @param unreachable 没有网络
 */
+ (void)HttpMonitorNetworkUnreachable:(MeariSuccess)unreachable;


/**
 当前是否wifi环境

 @return YES or NO
 */
+ (BOOL)checkCurrentNetworkStatusWifi;

/**
 监听网络状态

 @param networkChanged 网络状态
 */
+ (void)HttpMonitorNetworkStatus:(void (^)(MeariNetworkReachabilityStatus status))networkChanged;

/**
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
 取消所有的用户请求
 */
- (void)cancelAllRequest;

@end

