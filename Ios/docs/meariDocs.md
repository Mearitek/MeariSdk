
<h1><center> 目录 </center></h1>

[TOC]

<center>

---
| Version number | Develop team | Update date | Notes |
| ------ | ------ | ------ | ------ |
| 2.1.0 | Towers Perrin Technical Team | 2019.11.25 |

</center>

<center>

---
| 版本号 | 制定团队 | 更新日期 | 备注 | 
| ------ | ------ | ------ | ------ |
| 2.1.0 | 觅睿技术团队 | 2019.11.25 | 优化

</center>

#1. Functional Overview / 功能概述 

The Towers Technology APP SDK provides interface packaging with hardware devices and Towers Perrin, and accelerates the application development process, including the following functions:

- Hardware device related (with network, control, status report, firmware upgrade, preview playback, etc.)
- Account system (general account function such as mobile phone number, email registration, login, reset password, etc.)
- Device sharing
- Friends management
- Message Center
- Rui Rui cloud HTTPS API interface package (see 觅睿云api call)

-

觅睿科技APP SDK提供了与硬件设备、觅睿云通讯的接口封装，加速应用开发过程，主要包括以下功能：

- 硬件设备相关 (配网、控制、状态上报、固件升级、预览回放等功能) 
- 账号体系 (手机号、邮箱的注册、登录、重置密码等通用账号功能) 
- 设备共享
- 好友管理
- 消息中心
- 觅睿云HTTPS API接口封装 (参见觅睿云api调用) 


#2. Integration preparation / 集成准备

**准备App Key和App Secert** / **Prepare App Key and App Secert**

Meari Technology Cloud Platform provides App ID and App Secert for users to access SDK quick access camera equipment

-
觅睿科技云平台提供App ID和App Secert，用于用户接入SDK快速接入摄像机设备

#3. 集成SDK / Integrated SDK

## 3.1 集成准备 / Integration Preparation

### (1) Introducing the sdk package / 引入sdk包 

```
Drag the downloaded MeariKit.framework to the project
```
```
将下载好的MeariKit.framework拖到工程中
```

### (2) 环境配置  
```
1. Add MeariKit.framework to target -> General -> Embedded Binaries
2. Disable bitcode: In the project panel, select target -> Build Settings -> Build Options -> Enable Bitcode -> Set to No
3. Add a file that supports C++: change any .m file to a .mm file, for example, change AppDelegate.m to AppDelegate.mm format.
```

```
1. 将MeariKit.framework 添加到 target -> General -> Embedded Binaries
2. 禁用bitcode：在工程面板中，选中target -> Build Settings -> Build Options -> Enable Bitcode -> 设为 No
3. 添加支持c++的文件：将任意一个.m文件改为.mm文件，例如将AppDelegate.m 改为 AppDelegate.mm格式
```

## 3.2 Integrated SDK function / 集成SDK功能 

```
所属：MeariSdk工具类 / Affiliation:MeariSdk tool class
```

### (1) Initialize sdk configuration in Application / Application中初始化sdk配置

```
【Description】/【描述】
    Mainly used to initialize internal resources, communication services and other functions. 
  (主要用于初始化内部资源、通信服务等功能。)
 
【Function Call】【函数调用】
    /**
    Start the SDK (启动SDK)

    @param appKey appKey
    @param secretKey secret
    */
    - (void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;
    
    /**
    Set debug print level (设置调试打印级别)
    
    @param logLevel logLevel print level(打印级别)
    */
    - (void)setLogLevel:(MeariLogLevel)logLevel;
    
    
    /**
    Configuring the server environment (配置服务器环境)
    
    @param environment pre-issued or official(预发或正式)
    */
    - (void)configEnvironment:(MearEnvironment)environment;

【Code Example】【代码范例】
    //Start the SDK (启动SDK)
    [[MeariSDK sharedInstance] startWithAppKey:@"appKey" secretKey:@"secretKey"];
    
    //Configure the server environment: pre- or formal, is currently a development version, only supports running on the pre-launch environment
    // (配置服务器环境：预发或正式，当前是开发版本，只支持预发环境上运行)
    [[MeariSDK sharedInstance] configEnvironment:MearEnvironmentRelease];
    
    // Set the debug log level, will print the input and output information of the internal interface, in order to troubleshoot the problem
    // 设置调试log级别，会打印内部接口的输入输出信息，以便排查问题
    [[MeariSDK sharedInstance] setLogLevel:MeariLogLevelOff];
    
```


#4. User Management / 用户管理 

```
Affiliation:MeariUser tool class(所属：MeariUser工具类)
```
```
Towers Perrin Technology SDK provides two user management systems: common user system, UID user system

Ordinary user system: account login, registration, password change, password recovery, verification code
UID user system: uid login (up to 64 digits), no need to register without password system, please keep it safe
```
```
觅睿科技SDK提供两种用户管理体系：普通用户体系、UID用户体系

普通用户体系：账号登录、注册、修改密码、找回密码、获取验证码
UID用户体系：uid登录 (最长64位) ，无需注册没有密码系统，请妥善保管
```

##4.1 User uid login / 用户uid登录体系 

```
Towers Perrin provides the uid landing system. If the customer has its own user system, then you can access our sdk through the uid login system.
```

```
觅睿科技提供uid登陆体系。如果客户自有用户体系，那么可以通过uid登陆体系，接入我们的sdk。
```

### (1) User uid login / 用户uid登录 

```
【Description】/【描述】
用户uid注册，uid要求唯一。
User uid registration, uid requires unique.

【Function Call】/【Function Call】【函数调用】
/**
Log in via Uid / 通过Uid登录

@param uid User ID, need to guarantee uniqueness, <=32 bit (用户ID，需要保证唯一性，<=32位)
@param countryCode country code (国家代号)
@param phoneCode country phone code(国际手机前缀)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
*/
- (void)loginWithUid:(NSString *)uid countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode  success:(MeariSuccess)success  failure:(MeariFailure)failure

【Code Example】【代码范例】
//Login through Uid (通过Uid登录)
[[MeariUser sharedInstance] loginWithUid:@"abcdefghijklmn" countryCode:@"CN" phoneCode:@"86" success:^{

} failure:^(NSError *error) {

}];

```

### (2)  User logout / 用户登出 

```
【Description】/【描述】
Log out and log out with a normal account(登出同普通账号登出)

【Function Call】【函数调用】
//Log out of the account (登出账号)
@param success Successful callback (成功回调)
@param failure failure callback (失败回调)
- (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;


【Code Example】【代码范例】
// Log out of the account (登出账号)
[[MeariUser sharedInstance] logoutSuccess:^{

} failure:^(NSError *error) {

}];
```

## 4.2 General User System Management / 普通用户体系管理 

### (1) Register an account / 注册账号 

```
【【Description】/【描述】
    You need to get a verification code before registering an account.(注册账号前需要获取验证码)
 
【Function Call】【函数调用】
    //获取验证码
    @param userAccount User account: mailbox or mobile phone(用户账号：邮箱或手机)
    @param countryCode country code (国家代号)
    @param phoneCode country phone code(国际手机前缀). 
    @param success Successful callback (成功回调)，返回验证码剩余有效时间，单位秒
    @param failure failure callback (失败回调)
	- (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

    //注册账号
    @param userAccount User account: E-mail or mobile phone number (in mainland China only) / 用户账号：邮箱或手机号(仅限中国大陆地区)
    @param password User password (用户密码)
    @param countryCode country code (国家代号)
    @param phoneCode country phone code(国际手机前缀). 
    @param verificationCode verification code(验证码)
    @param nickname User nickname, can be modified after login(用户昵称，登录后可修改)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)registerWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【Code Example】【代码范例】
    // Get the account verification code(获取账号的验证码)
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        // success(成功)
    } failure:^(NSError *error) {
        // failure(失败)
    }];
    // Register an account (注册账号)
    [[MeariUser sharedInstance] registerWithAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" verificationCode:@"7234" nickname:@"coder man" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### (2) Account login / 账号登陆 

```
【Description】/【描述】
    支持邮箱登录、手机(仅限中国大陆地区)登录
 
【Function Call】【函数调用】
    //登陆
    @param userAccount User account: mailbox or mobile phone(用户账号：邮箱或手机)
    @param password User password(用户密码)
    @param countryCode country code (国家代号)
    @param phoneCode country phone code(国际手机前缀). 
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)loginWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【Code Example】【代码范例】
    [[MeariUser sharedInstance] loginWithAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### (3) Change-find password / 找回密码 修改密码
```
  
  /**
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
```


```
【Description】/【描述】
    找回密码前需要先获取验证码/ You need to get the verification code before you can change your password.
 
【Function Call】【函数调用】
    //获取验证码
    @param userAccount (User account: mailbox or mobile phone) 用户账号：邮箱或手机
    @param countryCode country code (国家代号)
    @param phoneCode country phone code(国际手机前缀). 
    @param success Successful callback (成功回调)，返回验证码剩余有效时间，单位秒
    @param failure failure callback (失败回调)
    - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    // (Get the account verification code)获取账号的验证码
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //success / 成功
    } failure:^(NSError *error) {
        //failure / 失败
    }];
    // Retrieve password (找回密码)
    [[MeariUser sharedInstance] resetPasswordWithAccount:@"john@163.com" password:@"123123" countryCode:@"CN" phoneCode:@"86"  verificationCode:@"6322" success:^{
    } failure:^(NSError *error) {
    
    }];
```

### (4) Registration message push / 注册消息推送 

```
【Description】/【描述】

    Sign up for Meari message push
    Called after logging in, registering, and retrieving the password. If the interface returns an error, re-register the push at intervals.
    
    注册Meari消息推送
    在登录、注册、找回密码后调用，如果接口返回错误，间隔一段时间重新注册推送

【Function Call】【函数调用】
    @param deviceToken (phone token)手机token 
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)registerPushWithDeviceToken:(NSData *)deviceToken success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
```

### (5) User logout / 用户登出 

```
【Description】/【描述】
    (log out)登出，退出账号

【Function Call】【函数调用】
    //登出账号
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;


【Code Example】【代码范例】
    //登出账号
    [[MeariUser sharedInstance] logoutSuccess:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### 4.3 User upload avatar / 用户上传头像 

```
【Description】/【描述】
    User upload avatar( 用户上传头像)
 
【Function Call】【函数调用】
    /*
     @param image Image (图片)
     @param success Successful callback (成功回调)，返回头像的url
     @param failure failure callback (失败回调)
     */
    - (void)uploadUserAvatarWithImage:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;
        
【Code Example】【代码范例】
    [[MeariUser sharedInstance] uploadUserAvatarWithImage:[UIImage imageWithData:self.imageData] success:^(NSString *avatarUrl) {

    } failure:^(NSError *error) {
    
    }];
```
### 4.4 Modify Nickname / 修改昵称 

```
【Description】/【描述】
    修改用户昵称。
 
【Function Call】【函数调用】
    /*
    @param name


    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
     */
    - (void)renameNicknameWithName:(NSString *)name  success:(MeariSuccess)success failure:(MeariFailure)failure;
        
【Code Example】【代码范例】
    [[MeariUser sharedInstance] renameNicknameWithName:newName success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### 4.5 Data Model / 数据模型 

User-related data model (用户相关的数据模型。)

```
【MeariUserInfo】
@property (nonatomic, strong) NSString * avatarUrl;     // User avatar (用户头像)
@property (nonatomic, strong) NSString * nickName;      // user nickname(用户昵称)
@property (nonatomic, strong) NSString * userAccount;   // user account(用户账号)
@property (nonatomic, strong) NSString * userID;        // user ID(用户ID)
@property (nonatomic, strong) NSString * userToken;     // user session(用户session)
@property (nonatomic, strong) NSString * loginTime;     // user login time(用户登录时间)
@property (nonatomic, strong) NSString * pushAlias;     // ser push alias for Aurora push (discard)(用户推送别名，用于极光推送 (废弃) )
@property (nonatomic, strong) NSString * token;         // User valid ID(用户有效标识)
@property (nonatomic, strong) NSString * secrect;       // User valid ID(用户有效标识)
@property (nonatomic, strong) NSString * userKey;       // user key(用户key)
@property (nonatomic, strong) NSString * userName;      // user name(用户名称)
@property (nonatomic, strong) NSString * countryCode;   // Register country code(注册国家代号)
@property (nonatomic, strong) NSString * phoneCode;     //Register the country phone code(注册国家手机代号)
@property (nonatomic, assign) BOOL notificationSound;   // If the message push has sound(消息推送是否有声音)
@property (nonatomic, assign, readonly) MeariThirdLoginType thirdLoginType; // LoginType / 登录类型
```

# 5.设备消息通知 

```
及时消息通知是MeariSDK及时通知App端当前用户和用户账户下设备的一些状态，以方便App端实现更好的用户体验

【通知类型】参见：MeariUser.h
    MeariDeviceOnlineNotification  // device online(设备上线) 
    MeariDeviceOfflineNotification  // device offline(设备离线) 
    MeariDeviceCancelSharedNotification  // device owner canceled sharing (设备主人取消了分享) 
    MeariDeviceFriendSharedDeviceNotification // has friend share your device (好友分享设备)
    MeariDeviceHasVisitorNotification    // visual doorbell device has a guest ringing the doorbell(可视门铃设备有访客按门铃) 
    MeariDeviceVoiceBellHasVisitorNotification  // Voice doorbell device has a guest ringing the doorbell (语音门铃设备有访客按门铃)  
    MeariDeviceUnbundlingNotification   // device has been unbundled (设备已被解绑)
    MeariUserLoginInvalidNotification   // login information is invalid, you need to log in again (登录信息失效，需要重新登录) 
    MeariDeviceAutoAddNotification  // device has added auto (设备自动添加)
    MeariDeviceConnectMqttNotification // mqtt connect success (mqtt连接成功)
    MeariDeviceNewShareToMeNotification // A share device to B (新版分享发送通知)
    MeariDeviceNewShareToHimNotification // A request B to share a device to A (新版分享发送通知)
【使用】
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginInvalidNotification:) name:MeariUserLoginInvalidNotification object:nil];
```
## 5.1 Whether to open device push / 是否开启设备推送
```
【Description】/【描述】
// You can enable or disable the device push function of a device
// 可以开启或者关闭一个设备的设备推送功能

【Function Call】【函数调用】
	/**
	 Device push(设备推送)
	 
	 @param deviceID 设备ID
	 @param enable (whether to open)开关
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)deviceAlarmNotificationEnable:(BOOL)enable deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] deviceAlarmNotificationEnable:closed deviceID:self.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];

```

# 6.Equipment distribution network / 设备配网
```
Affiliation:MeariDevice tool class
```
```
Towers Perrin technology hardware modules support three distribution modes: SmartWifi distribution network, hotspot mode (AP mode), two-dimensional code distribution network mode.
The QR code and SmartWifi operation are relatively simple. It is recommended to use the hotspot mode as an alternative after the distribution network fails. Among them, the success rate of the two-dimensional code distribution network is high.
```

```
所属：MeariDevice工具类
```
```
觅睿科技硬件模块支持三种配网模式：SmartWifi配网、热点模式 (AP模式) 、二维码配网模式。
二维码和SmartWifi操作较为简便，建议在配网失败后，再使用热点模式作为备选方案。其中二维码配网成功率较高。
```
## 6.1 smartwifi distribution network / smartwifi配网 
```
Before the distribution network, you need to obtain the Token first, and then call the distribution network interface.
```

```
配网之前需要先获取Token，然后再调用配网接口
```

### (1) Get Token / 获取Token 

```
【Description】/【描述】
Smart wifi distribution network needs to provide the name and password of the connected wifi(smart wifi配网需要提供所连wifi的名称和密码)

【Function Call】【函数调用】
    /**
    Get the distribution network token(获取配网token)

    @param tokenType Different distribution modes correspond to different Tokens(不同配网模式对应不同的Token)
    @param success Successful callback (成功回调)：
    token: 用于配网
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.(token有效时长，超过时长需要重新获取新的token)
    @param failure failure callback (失败回调)
    */
    - (void)getTokenWithTokenType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
【Code Example】【代码范例】
    [[MeariUser sharedInstance] getTokenWithTokenType:MeariDeviceTokenTypeSmartWifi success:^(NSString *token, NSInteger validTime) {
        //Don't care about validTime, because this type of Token is long-lived
    } failure:^(NSError *error) {

    }];
```
### (2) 开始SmartWifi配网 

```
【Description】/【描述】
    Smart wifi distribution network needs to provide the name and password of the connected wifi(smart wifi配网需要提供所连wifi的名称和密码)
 
【Function Call】【函数调用】
	/**
	 Start smartwifi distribution network(开始 smartwifi 配网)
	
	 @param wifiSSID wifi name(wifi名称)
	 @param wifiPwd wifi password: no password, pass nil(wifi密码：没有密码，传nil)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	+ (void)startMonitorWithWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
        
【Code Example】【代码范例】
    [MeariDevice startMonitorWithWifiSSID:@"wifi name" wifiPwd:@"12345678" success:^{
        //Successful callback will only return when stopped
        //成功的回调只会在停止的时候返回
    } failure:^(NSError *error){
         // The abnormal callback will return directly
        //异常的回调会直接返回
    }];
```
### (3) Stop SmartWifi distribution network / 停止SmartWifi配网 

```
    /**
    Stop smartwifi distribution network
    停止 smartwifi 配网
    */
    + (void)stopMonitor;
```

## 6.2 Hotspot mode (AP distribution network) / 热点模式 (AP配网) 

```
配网之前需要先获取Token，然后再调用配网接口
```
### (1) 获取Token 

```
【Description】/【描述】
    Get the Token required by the AP distribution network(获取AP配网所需要的Token)

【Function Call】【函数调用】
    /**
    Get the distribution network token(获取配网token)

    @param tokenType Different distribution modes correspond to different Tokens(不同配网模式对应不同的Token)
    @param success Successful callback (成功回调)：
    token: 用于配网
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.(token有效时长，超过时长需要重新获取新的token)
    @param failure failure callback (失败回调)
    */
    - (void)getTokenWithTokenType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
    
【Code Example】【代码范例】
    [[MeariUser sharedInstance] getTokenWithTokenType:MeariDeviceTokenTypeAP success:^(NSString *token, NSInteger validTime) {
        // Do not care about validTime, Token has been valid in this mode
        // 不用关心validTime，这种模式下Token一直有效
    } failure:^(NSError *error) {

    }];
```
### (2) AP配网 

```
【Description】/【描述】
    The ap distribution network needs to provide the name and password of the connected wifi, and it needs to be connected to the hotspot of the device before the distribution network. (The device hotspot name is: `STRN` plus `underscore `plus `sn number` such as: STRN_056566188)
    ap配网需要提供所连wifi的名称和密码，且配网前需连接到设备的热点,(设备热点名称为:`STRN`加`下划线`加`sn号`如：STRN_056566188)
 
【Function Call】【函数调用】
	
	/**
	 Start ap distribution network(开始 ap 配网)
	
	 @param wifiSSID wifi name(wifi名称)
	 @param wifiPwd wifi password(wifi密码)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	+ (void)startAPConfigureWithWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

        
【Code Example】【代码范例】
	//开始smartwifi配网
	[MeariDevice startAPConfigureWithWifiSSID:@"wifi name" wifiPwd:@"12345678" success:^{

    } failure:^(NSString *error) {
    
    }];
    
```

## 6.3 QR code distribution network / 二维码配网 
```
Before the distribution network, you need to obtain the Token first, and then call the distribution network interface.
```
```
配网之前需要先获取Token，然后再调用配网接口
```
### (1) Get Token / 获取Token 

```
【Description】/【描述】
    Obtain the Token required by the AP distribution network. Note that this Token has an expiration time.
    获取AP配网所需要的Token，注意此Token有过期时间

【Function Call】【函数调用】
     /**
    Get the distribution network token(获取配网token)

    @param tokenType Different distribution modes correspond to different Tokens(不同配网模式对应不同的Token)
    @param success Successful callback (成功回调)：
    token: 用于配网
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.(token有效时长，超过时长需要重新获取新的token)
    @param failure failure callback (失败回调)
    */
    - (void)getTokenWithTokenType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getTokenWithTokenType:MeariDeviceTokenTypeQRCode success:^(NSString *token, NSInteger validTime) {
       //validTime is the timeout period. The timeout Token cannot be used for the QR code
        //validTime为超时时间，超时的Token不能用于二维码配网，需要重新获取Token
    } failure:^(NSError *error) {

    }];
```
### (2) QR code distribution network / 二维码配网 

```
【Description】/【描述】
	The obtained token and the WiFi and password of the mobile phone generate a QR code picture, and the QR code picture is recommended: a 284px square picture 
	将获取到的token和手机所在的WiFi和密码生成二维码图片，二维码图片推荐：284px的正方形图片
 
【Function Call】【函数调用】
	/**
	 Generate QR code(生成二维码)
	
	 @param ssid wifi name(wifi名称)
	 @param password wifi password(wifi密码)
	 @param token code token(二维码token)
	 @param size QR code size(二维码大小)
	 @return QR code image(二维码图片)
	 */
	- (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;
        
【Code Example】【代码范例】
	
    //生成二维码
    UIImage *image = [[MeariUser sharedInstance] createQRWithSSID:@"wifi name" pasword:@"123456" token:token size:CGSizeMake(100, 100)];
```


## 6.4 Searching for devices / 搜索设备 
```
Search timing: After the device is successfully deployed, the blue light will be on, and the device can be searched.
Search mechanism: The search interface does not have a timeout mechanism, and the search will not stop until the stop interface is called.
Search mode: LAN search and cloud search
```

```
搜索时机：设备配网成功后，会蓝灯常亮，此时即可搜索到设备
搜索机制：搜索接口没有超时机制，直到调用停止接口，才会停止搜索
搜索模式：局域网搜索和云搜索
```

### (1) smartwifi distribution network and ap distribution network search equipment / smartwifi配网和ap配网搜索设备 

```
【Description】/【描述】
    IPC device: After the device is successfully connected to the network, the blue light is always on, and the device can be searched for display.
    NVR device: The added NVR needs to be in the same network as the mobile phone before it can be searched.
    
	IPC设备：设备配网成功蓝灯常亮后，才能搜索到设备，用于展示给用户进行添加操作
    NVR设备：被添加的NVR需要与手机在同一个网络下，才可以被搜索到
 
【Function Call】【函数调用】
	
	/**
	 Start search: for smartwifi distribution network and ap distribution network
	 开始搜索：适用于smartwifi配网和ap配网
	
	 @param success Successful callback (成功回调)：返回搜索到的设备
	 @param failure failure callback (失败回调)
	 */
	+ (void)startSearchSuccess:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Start search: for smartwifi distribution network and ap distribution network
	//开始搜索：适用于smartwifi配网和ap配网
	 [MeariDevice startSearchSuccess:^(MeariDevice *device) {
        
    } failure:^(NSString *error) {
        
    }];
```
### (2) QR code matching network search device / 二维码配网搜索设备 

```
【方法一：】

【Description】/【描述】'
    After the device is successfully connected to the network, the blue light is always on, and the device can be searched for display.
    Note: The Token of the search needs to be consistent with the Token of the QR code distribution network, otherwise the device will not be searched.
    
    设备配网成功蓝灯常亮后，才能搜索到设备，用于展示给用户进行添加操作
    注意：搜索的Token需要与二维码配网获取Token保持一致，否则会搜索不到设备
    
【Function Call】【函数调用】
    /**
    Start search: only for QR code network(开始搜索：仅适用于二维码配网)

    @param token QR code token(二维码token) 
    @param success Successful callback (成功回调)：返回搜索到的设备
    @param failure failure callback (失败回调)
    */
    + (void)startSearchWithQRcodeToken:(NSString *)token success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

```
### (3) device Add /  设备添加 

#### <1> adding a camera(添加摄像机)

```
【Description】/【描述】
    After searching for the device, first query the device status query, and add the device operation without being added.
    搜索到设备后，先进行查询设备状态查询，在没有被人添加的情况下，才可以进行添加设备操作

【Be Applicable】【适用】
	Type:
		MeariDeviceTypeIpc
	subType:
   		All

【Function Call】【函数调用】
    //Query device status(查询设备状态)
    @param type device type(设备类型)
    @param devices Device to be queried: need to use the device interface to search for devices(要查询的设备：需使用调用设备接口，搜索出来的设备)
    @param success Successful callback // return to device list(返回设备列表)
    @param failure failure callback (失败回调)
    - (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;
    
    /**
    add device(recommend) 添加设备 (推荐)
 
   @param device  the device of search(搜索到的设备)
   @param isNvr 是否是nvr
   @param success 成功回调部分设备信息 
   @param failure 失败回调
     */
  - (void)addDevice:(MeariDevice *)device nvr:(BOOL)isNvr success:(void(^)(MeariDevice *camera))success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    // Query camera(查询摄像机)
    [[MeariUser sharedInstance] checkDeviceStatusWithDeviceType:MeariDeviceTypeIpc devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

    // Add camera(添加摄像机)
        [[MeariDeviceActivator sharedInstance] addDevice:camera nvr:NO success:^(MeariDevice * _Nonnull device) {
        
        } failure:^(NSError *error) {

        }];

```
#### <2> Adding network storage(添加网络存储器 ) 

```
【Description】/【描述】
    搜索到NVR设备后，先进行查询设备状态查询，在没有被人添加的情况下，才可以进行添加设备操作
    After searching for an NVR device, query the device status first, and add the device operation if it is not added.
【Be Applicable】【适用】
	Type:
		MeariDeviceTypeNVR
		
【Function Call】【函数调用】
    //查询设备状态
    @param type device type(设备类型)
    @param devices Device to be queried: need to use the device interface to search for devices(要查询的设备：需使用调用设备接口，搜索出来的设备)
    @param success Successful callback (成功回调)：return to device list(返回设备列表)
    @param failure failure callback (失败回调)
    - (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

    /**
    add device(recommend) 添加设备 (推荐)
 
   @param device  the device of search(搜索到的设备)
   @param isNvr 是否是nvr
    @param success Successful callback (成功回调)
   @param failure failure callback (失败回调)
     */
  - (void)addDevice:(MeariDevice *)device nvr:(BOOL)isNvr success:(void(^)(MeariDevice *camera))success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    //查询nvr
    [[MeariUser sharedInstance] checkDeviceStatusWithDeviceType:MeariDeviceTypeNvr devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

    //添加nvr
        [[MeariDeviceActivator sharedInstance] addDevice:camera nvr:YES success:^(MeariDevice * _Nonnull device) {
        
        } failure:^(NSError *error) {

        }];

```
### (4) Stop searching / 停止搜索 

```
【Description】/【描述】
    When you finish adding, if you have a search turned on, you need to stop the search operation.
    结束添加时，如果有开启搜索，需要停止搜索操作
【Function Call】【函数调用】
    /**
    Stop searching(停止搜索)
    */
    + (void)stopSearch;
【Code Example】【代码范例】
    [MeariDevice stopSearch];
    [[MeariUser sharedInstance] cancelAllRequest];
```

##6.5 Autobind Device / 自动配网
```
Before the distribution network, you need to obtain the Token first, and then call the distribution network interface.
Allow the device to automatically add to the user account after scanning the QR code or AP mode.

```
```
在配网之前，您需要先获取令牌，然后再调用配网接口。
通过扫描QR码或AP模式后，设备自动添加到用户账号。
```
### (1) Get Token / 获取token
```
【Description】
    Get the Token required by the QRcode and AP mode(qrcode和ap模式需要获取token)

【Function Call】
    /**
    Get the distribution network token(获取配网token)
 
 	@param success return  config dictionary
        token: config token (配网token)
        validTime: token invalid time(token 有效时间)
        delaySmart: user for smartwifi (Deprecated)

 	@param failure return error
 	*/
     - (void)getTokenSuccess:(MeariSuccess_Token2)success failure:(MeariFailure)failure;;

    
【Code Example】
	[[MeariDeviceActivator sharedInstance] getTokenSuccess:^(NSString *token, NSInteger validTime, NSInteger delaySmart) {
     // Do not care about validTime, Token has been valid in this mode
    } failure:^(NSError *error) {
    //....
    }];

```

### (2) Start Config / 开始配网
```
【Description】【描述】
	start search and config device(开始搜索, 配网)
【Function Call】
    /**
 	 start config (开始配置)

  	 @param mode    search device mode(设备类型)
 	 @param token   config token (设备token)
  	 @param timeout  Timeout time, the default is 100 seconds. If it is less than 0, the distribution network will not be closed. You need to manually call stopSearch.
 	*/
	- (void)startConfigWiFi:(MeariDeviceSearchMode)mode  token:(NSString *)token type:(MeariDeviceTokenType)type nvr:(BOOL)isNvr timeout:(NSTimeInterval)timeout;
  
【Code Example】【代码范例】
	[[MeariDeviceActivator sharedInstance] startConfigWiFi:(MeariSearchModeAll) token:token type:(MeariDeviceTokenTypeQRCode) nvr:NO timeout:100];

```
### (3) Config Complete / 完成
```
【Description】
	Obtain the device completed by the distribution network.  must set  [MeariDeviceActivator sharedInstance].delete = self; before implement this method
【Function Call】
   /**
 	Device Complete callback

 	@param activator MeariDeviceActivator
 	@param deviceModel return the device which config network completed(配网成功的设备)
 	@param error return error
 	*/
	- (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error;
  
【Code Example】【代码范例】

	 - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error {
		// Use deviceModel.info.addStatus to determine whether the device is successfully added.
	   //BOOL success =  deviceModel.info.addStatus == MeariDeviceAddStatusSelf;

	 }

```
# 7 NVR Binding Device / NVR绑定设备 

## 7.1 Searching for devices / 搜索设备 

```
【Description】/【描述】
    The device blue light is always on to be searched. It is used to display the binding NVR to the user. MeariDevice->hasBindedNvr is used to determine whether the NVR has been bound.
    设备蓝灯常亮才能被搜索到，用于展示给用户进行绑定NVR，MeariDevice->hasBindedNvr 用于判断是否已经绑定了NVR

【Function Call】【函数调用】
    /**
    Start search: Search for devices under the current network(开始搜索：搜索当前网络下的设备)

    @param success Successful callback (成功回调)：return the searched device(返回搜索到的设备)
    @param failure failure callback (失败回调)
    */
    + (void)startSearchSuccess:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Start search: for smartwifi distribution network and ap distribution network
    //开始搜索：适用于smartwifi配网和ap配网
    [MeariDevice startSearchSuccess:^(MeariDevice *device) {

    } failure:^(NSString *error) {

    }];
```
## 7.2 Binding device / 绑定设备 

```
【Description】/【描述】
    After the NVR is bound to the device, the video files of the device are stored in the NVR.(NVR绑定设备后，设备的录像文件会存储在NVR中)

【Function Call】【函数调用】
    @param deviceID device ID(设备ID)
    @param nvrID nvr ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)bindDeviceWithDeviceID:(NSInteger)deviceID fromNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] bindDeviceWithDeviceID:model.device.info.ID fromNVR:self.nvr.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```
## 7.3 End binding device / 结束绑定设备 

```
【Description】/【描述】
    When the binding ends, if there is a search, you need to stop the search operation.
    结束绑定时，如果有开启搜索，需要停止搜索操作
【Function Call】【函数调用】
    /**
    Stop searching(停止搜索)
    */
    + (void)stopSearch;
【Code Example】【代码范例】
    [MeariDevice stopSearch];
    [[MeariUser sharedInstance] cancelAllRequest];
```
## 7.4 Obtaining NVR-bound devices / 获取NVR绑定的设备 

```
【Description】/【描述】
    Used to check which devices are bound to the NVR.(用于查看NVR绑定了哪些设备)

【Function Call】【函数调用】
    nvr get list of bound devices
    @param nvrID nvr ID
    @param success Successful callback (成功回调)：return the list of bound devices and unbound device list(返回绑定的设备列表和未绑定的设备列表)
    @param failure failure callback (失败回调)
    - (void)getBindDeviceListWithNvrID:(NSInteger)nvrID success:(MeariSuccess_DeviceListForNVR)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    //查询绑定的设备列表
    [[MeariUser sharedInstance] getBindDeviceListWithNvrID:self.nvr.info.ID success:^(NSArray<MeariDevice *> *bindedDevices, NSArray<MeariDevice *> *unbindedDevices) {

    } failure:^(NSError *error) {

    }];
```
## 7.5 Unbinding the device from the NVR / 从NVR解绑设备 

```
【Description】/【描述】
    After the device is bound from the NVR, the video files of the device will not continue to be stored in the NVR.
    (从NVR绑定设备后，设备的录像文件将不会继续存储在NVR中)

【Function Call】【函数调用】
    @param deviceID device ID(设备ID)
    @param nvrID nvr ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)unbindDeviceWithDeviceID:(NSInteger)deviceID fromNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
    
    
    @param deviceIDs Multiple device IDs(多个设备ID)
    @param nvrID nvr ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    [[MeariUser sharedInstance] unbindDevicesWithDeviceIDs:arr fromNVR:self.nvr.info.ID success:^{

    } failure:^(NSError *error) {
    
    }];
```
# 8. Chime
```
Affiliation:MeariDevice
所属：MeariDevice
```

## 8.1 


# 9. Device information acquisition / 设备信息获取
```
Affiliation:MeariUser
所属：MeariUser
```
## 9.1 Getting Device Columns / 获取设备列类 
```
Affiliation: MeariDeviceList
所属：MeariDeviceList
```
```
【Description】/【描述】
    After the device is added, obtain the device list through the interface of the MeariUser tool class and return it as a model.
The device information is the info attribute of the device object (MeariDeviceInfo)
    (设备添加后，通过MeariUser工具类的接口获取设备列表，以模型形式返回
设备信息为设备对象的info属性 (MeariDeviceInfo) )

【Function Call】【函数调用】
    // Get a list of all devices(获取所有设备列表)
    - (void)getDeviceListSuccess:(MeariSuccess_DeviceList)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];
```

MeariDeviceList attribute:(MeariDeviceList属性)

```
 /** Camera(摄像机) */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;
/** Smart doorbell(智能门铃)*/
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** voice doorbell(语音门铃) */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** Battery Camera(电池摄像机) */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** Lamp camera(灯具摄像机) */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** Network Memory(网络存储器) */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;
```
## 9.2 Device Information / 设备信息 

```
所属：MeariDevice
```
```
@property (nonatomic, strong) MeariDeviceInfo *info;                        // Device information (设备信息)
@property (nonatomic, strong) MeariDeviceParam *param;                      // Device parameters (设备参数)
@property (nonatomic, assign, readonly, getter=isIpcCommon)BOOL ipcCommon;  // Is it a normal camera? (是否是普通摄像机)
@property (nonatomic, assign, readonly, getter=isIpcBaby)BOOL ipcBaby;      // is it a music camera? (是否是音乐摄像机)
@property (nonatomic, assign, readonly, getter=isIpcBell)BOOL ipcBell;      // whether it is a doorbell camera (是否是门铃摄像机)
@property (nonatomic, assign, readonly, getter=isNvr)BOOL nvr;              // whether it is a nvr (是否是nvr)
@property (nonatomic, assign)BOOL hasBindedNvr;                             // Do you bind? (是否绑定)
@property (nonatomic, assign, readonly)BOOL sdkLogined;                     // whether logged in (是否已登录)
@property (nonatomic, assign, readonly)BOOL sdkLogining;                    // whether you are logged in (是否正在登录)
@property (nonatomic, assign, readonly)BOOL sdkPlaying;                     // Whether previewing (是否正在预览)
@property (nonatomic, assign, readonly)BOOL sdkPlayRecord;                  // Whether it is playing back (是否正在回放)
@property (nonatomic, strong)NSDateComponents *playbackTime;                // current playback time (当前回放时间)
@property (nonatomic, assign, readonly)BOOL supportFullDuplex;              // Do you support two-way voice intercom? (是否支持双向语音对讲)
@property (nonatomic, assign, readonly)BOOL supportVoiceTalk;               // support voice intercom (是否支持语音对讲)
。。。
```
## 9.3 Deleting a device / 删除设备 

```
【Description】/【描述】
   Device remove /  设备移除

【Function Call】【函数调用】
    // Remove the device(移除设备)
    @param type device type(设备类型)
    @param deviceID device ID(设备ID)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)deleteDeviceWithType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] deleteDeviceWithType:MeariDeviceTypeIpc deviceID:cell.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```

## 9.4 设备昵称修改 

```
【Description】/【描述】
    Device nickname modification(设备昵称修改)

【Function Call】【函数调用】
    @param type device type(设备类型)
    @param deviceID device ID(设备ID)
    @param nickname New nickname, length 6-20(新的昵称，长度6-20位)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)renameDeviceWithType:(MeariDeviceType)type deviceID:(NSInteger)deviceID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    // Modify the IPC device nickname(修改IPC设备昵称)
    [[MeariUser sharedInstance] renameDeviceWithType:MeariDeviceTypeIpc deviceID:self.camera.info.ID nickname:newNickName success:^{
    
    } failure:^(NSError *error) {
    
    }];
    
    // Modify the NVR device nickname(修改NVR设备昵称)
    [[MeariUser sharedInstance] renameDeviceWithType:MeariDeviceTypeNVR deviceID:self.nvr.info.ID nickname:newNickName success:^{

    } failure:^(NSError *error) {

    }];
```

## 9.5 Single device one day alarm time point acquisition / 单个设备某天报警时间点获取 

```
【Description】/【描述】
    Single device one day alarm time point acquisition(单个设备某天报警时间点获取)

【Function Call】【函数调用】
    // a single device one day alarm time point to obtain(单个设备某天报警时间点获取)
    @param deviceID device ID(设备ID)
    @param date (The format is 20171212) 日期：格式为20171212
    @param success Successful callback (成功回调)：return to the alarm time list(返回报警时刻列表)
    @param failure failure callback (失败回调)
    - (void)getAlarmMessageTimesWithDeviceID:(NSInteger)deviceID onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getAlarmMessageTimesWithDeviceID:self.device.info.ID onDate:@"20171212" success:^(NSArray<NSString *> *time) {

    } failure:^(NSError *error) {

    }];
```

## 9.6 Check if the device has a new version / 查询设备是否有新版本 

```
【Description】/【描述】
    Check if the device has a new version / 查询设备是否有新版本

【Function Call】【函数调用】
    // Query the device for a new version(查询设备是否有新版本)
    @param currentFirmware Current version(当前版本)
    @param success Successful callback (成功回调): Returns the latest version information of the device(返回设备最新版本信息)
    @param failure failure callback (失败回调)
    - (void)checkNewFirmwareWithCurrentFirware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirware:self.currentVersion success:^(MeariDeviceFirmwareInfo *info) {
    
    } failure:^(NSError *error) {
    
    }];
```

MeariDeviceFirmwareInfo:

```
@property (nonatomic, copy) NSString *upgradeUrl;           // Device upgrade address(设备升级地址)
@property (nonatomic, copy) NSString *latestVersion;        // The latest version of the device(设备最新版本)
@property (nonatomic, copy) NSString *upgradeDescription;   // Device upgrade description (设备升级描述)
@property (nonatomic, assign) BOOL needUpgrade;             // Do you need to upgrade?(是否需要升级)
```

## 9.7 Querying Device Online Status / 查询设备在线状态 

```
【Description】/【描述】
    Check if the device is online / 查询设备是否有新版本

【Function Call】【函数调用】
    // Query the device is online? (查询设备是否在线)
    @param deviceID device ID(设备ID)
    @param success Successful callback (成功回调)：Returns whether the device is online(返回设备是否在线)
    @param failure failure callback (失败回调)
    - (void)checkDeviceOnlineStatusWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceOnlineStatus)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] checkDeviceOnlineStatusWithDeviceID:self.device.info.ID success:^(BOOL online) {

    } failure:^(NSError *error) {

    }];
```

## 9.8 Querying the music list / 查询音乐列表 

```
【Description】/【描述】
    Query music list(查询音乐列表)

【Function Call】【函数调用】
    // Query music list(查询音乐列表)
    @param success Successful callback (成功回调)：return to music list(返回音乐列表)
    @param failure failure callback (失败回调)
    - (void)getMusicListSuccess:(MeariSuccess_Music)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getMusicListSuccess:^(NSArray<MeariMusicInfo *> *musicList) {

    } failure:^(NSError *error) {

    }];
```
```
MeariMusicInfo:
@property (nonatomic, strong) NSString * musicFormat;   // Music format(音乐格式)
@property (nonatomic, strong) NSString * musicID;       // Music ID(音乐ID)
@property (nonatomic, strong) NSString * musicName;     // music name(音乐名字)
@property (nonatomic, strong) NSString * musicUrl;      // Music address(音乐地址)
```

## 9.9 Generate distribution network QR code / 生成配网二维码 

```
【Description】/【描述】
    Generate distribution network QR code(生成配网二维码)

【Function Call】【函数调用】
    // Get the QR code token(获取二维码token)
    /**
    Get the distribution network token(获取配网token)
    
    @param tokenType Different distribution modes correspond to different Tokens(不同配网模式对应不同的Token)
    @param success Successful callback (成功回调)：
    token: for distribution network(用于配网)
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.(token有效时长，超过时长需要重新获取新的token)
    @param failure failure callback (失败回调)
    */
    - (void)getTokenWithTokenType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
    //生成配网二维码
    @param ssid wifi name(wifi名称)
    @param password wifi password(wifi密码)
    @param token code token(二维码token)
    @param size QR code size(二维码大小)
    @return QR code image(二维码图片)
    - (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;

【Code Example】【代码范例】
    // Get the QR code token(获取二维码token)
    [[MeariUser sharedInstance] getTokenWithTokenType:^(NSString *token) {

    } failure:^(NSError *error) {

    }];
    
    // Generate distribution network QR code(生成配网二维码)
   UIImage *image = [[MeariUser sharedInstance] createQRWithSSID:weakSelf.wifi.ssid pasword:weakSelf.wifi.password token:obj size:CGSizeMake(WY_ScreenWidth, WY_ScreenHeight)];
```

## 9.10 Remote wake-up doorbell(远程唤醒门铃 )

```
【Description】/【描述】
    Remote wake-up doorbell(远程唤醒门铃)

【Function Call】【函数调用】
    //Remote wake-up doorbell(远程唤醒门铃)
    @param deviceID device ID(设备ID)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)remoteWakeUpWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] remoteWakeUpWithDeviceID:self.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
【Precautions】【注意事项】
    For doorbell-type low-power products, you need to call the remote wake-up interface first, and then call the hole-punching interface.
    (门铃类低功耗产品，需要先调用远程唤醒接口，再调用打洞的接口)
```

## 9.11 Uploading the doorbell message / 上传门铃留言 

```
【Description】/【描述】
Upload doorbell message(上传门铃留言)

【Function Call】【函数调用】
    /**
    Upload doorbell message(上传门铃留言)

    @param deviceID device ID(设备ID)
    @param file message file path(留言文件路径)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)uploadVoiceWithDeviceID:(NSInteger)deviceID voiceFile:(NSString *)file success:(MeariSuccess_DeviceVoiceUrl)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] uploadVoiceWithDeviceID:self.camera.info.ID voiceFile:_filePath success:^(NSString *voiceUrl) {
    
    } failure:^(NSError *error) {
    
    }];
```

## 9.12 Download the doorbell message / 下载门铃留言 

```
【Description】/【描述】
下载门铃留言

【Function Call】【函数调用】
    /**
    Download message(下载留言)

    @param voiceUrl Message address(留言地址)
    @param success Successful callback (成功回调)，return value: audio data(返回值：音频数据)
    @param failure failure callback (失败回调)
    */
    - (void)downloadVoiceWithVoiceUrl:(NSString *)voiceUrl success:(MeariSuccess_DeviceVoiceData)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] downloadVoiceWithVoiceUrl:urlStr success:^(NSData *data) {

    } failure:^(NSError *error) {
    
    }];
```

## 9.13 Deleting the doorbell message / 删除门铃留言 

```
【Description】/【描述】
Delete doorbell message(删除门铃留言)

【Function Call】【函数调用】
    /**
    Delete doorbell message(删除门铃留言)

    @param deviceID device ID(设备ID)
    @param voiceID 语音留言ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)deleteVoiceWithDeviceID:(NSInteger)deviceID voiceID:(NSString *)voiceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
     [[MeariUser sharedInstance] deleteVoiceWithDeviceID:self.camera.info.ID voiceID:voiceID success:^{

    } failure:^(NSError *error) {

    }];
```

# 10.Device Control / 设备控制
```
Affiliation:MeariDevice
```
```
MeariDevice is responsible for all operations on the device, including preview, playback, settings, etc. For device settings, you need to make sure that you have established a connection with the device.
```

```
所属：MeariDevice
```
```
MeariDevice 负责对设备的所有操作，包括预览、回放、设置等，对设备的设置，需要确保已经与设备建立好了连接
```
## 10.1 Connecting devices / 连接设备 

```
【Description】/【描述】
    Before you can preview, play back, set up, etc., you need to connect the device first.
    (对设备进行预览、回放、设置等操作之前，需先连接上设备)

【Function Call】【函数调用】
    /**
    Start connecting devices(开始连接设备)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)startConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.device startConnectSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 10.2 Disconnecting the device / 断开设备 

```
【Description】/【描述】
    When you do not need to operate the device, you need to disconnect the device
    (当不需要对设备进行操作时，需要断开设备)

【Function Call】【函数调用】
    /**
    Disconnect device(断开设备)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)stopConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.device stopConnectSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 10.3 Get the bit rate / 获取码率 

```
【Description】/【描述】
    When you do not need to operate the device, you need to disconnect the device
    (当不需要对设备进行操作时，需要断开设备)

【Function Call】【函数调用】
    /**
    Acquisition rate(获取码率)

    @return code rate(码率)
    */
    - (NSString *)getBitrates;

【Code Example】【代码范例】
    [self.device getBitrates]
```


## 10.4 Preview / 预览 

```
【Description】/【描述】
    Real-time streaming playback of the camera, support HD/SD switching
    (对摄像机取实时流播放，支持高清/标清切换)

【Function Call】【函数调用】
    /**
    Start previewing the device(开始预览设备)

    @param playView play view control(播放视图控件)
    @param HD Whether to play HD(是否高清播放)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    @param close is in sleep mode, the lens is off, return value: sleep mode(close 处于休眠模式，镜头关闭，返回值：休眠模式)
    */
    - (void)startPreviewWithPlayView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(void(^)(BOOL isPlaying))failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;
    
    /**

    /**
    stop preview 
    停止预览设备

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)stopPreviewSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    change Video Resolution
    切换高清标清

    @param playView play view(播放视图)
    @param videoStream (video type)播放类型
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)changeVideoResolutionWithPlayView:(MeariPlayView *)playView videoStream:(MeariDeviceVideoStream)videoStream success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Create a MeariPlayView(创建一个MeariPlayView)
    MeariPlayView *playView = [[MeariPlayView alloc] initWithFrame:CGRectMake(0, 0,160, 90];

    // Start previewing the device(开始预览设备)
    [self.camera startPreviewWithPlayView:playView streamid:YES success:^{

    } failure:^(BOOL isPlaying) {

    } close:^(MeariDeviceSleepmode sleepmodeType) {

    }];

    // Stop preview device(停止预览设备)
    [self.camera stopPreviewSuccess:^{

    } failure:^(NSString *error) {

    }];

    // Switch HD standard definition(切换高清标清)
    [self.camera changeVideoResolutionWithPlayView:self.drawableView videoStream:MeariDeviceVideoStream_HD success:^{

    } failure:^(NSString *error) {

    }];
```


## 10.5 Playback / 回放 

```
【Description】/【描述】
    Play back the video of the camera
    Note: The SDK does not check the playing time, so even if you pass in a time point without an alarm, the interface will return success, so the upper layer needs to judge by itself.
    
    对摄像机的录像进行回放
    注意：SDK不对播放的时间做校验，所以即使传入一个没有报警的时间点，接口也会返回成功，所以上层需要自行判断

【Function Call】【函数调用】
    
    /**
    Get the number of video days in a month(获取某月的视频天数)
    
    @param month 月
    @param year 年
    @param success Successful callback (成功回调)，  return value: json array --[{"date" = "20171228"},...]       (返回值：json数组--[{"date" = "20171228"},...])
    @param failure failure callback (失败回调)
    */
    - (void)getPlaybackVideoDaysInMonth:(NSInteger)month year:(NSInteger)year success:(MeariDeviceSucess_PlaybackDays)success failure:(MeariDeviceFailure)failure;

    /**
    Get a video clip of a day(获取某天的视频片段)

    @param year year(年)
    @param month month(月)
    @param day day(日)
    @param success Successful callback (成功回调)：返回值：json数组--[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
    @param failure failure callback (失败回调)
    */
    - (void)getPlaybackVideoTimesInDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year success:(MeariDeviceSucess_PlaybackTimes)success failure:(MeariDeviceFailure)failure;

    /**
    Start playback of video: only one person can view playback video at the same time (开始回放录像：同一个设备同一时间只能一个人查看回放录像)

    @param playView play view(播放视图)
    @param startTime Start time: format is 20171228102035 (开始时间:格式为20171228102035)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)startPlackbackSDCardWithPlayView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Stop playback(停止回放)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)stopPlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    Set playback level
	 设置回放等级
 
	 @param level MeariDeviceRecordDuration  回放等级
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
	- (void)setPlaybackRecordVideoLevel:(MeariDeviceRecordDuration)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Play from a certain time: This interface can only be used after the playback is successful, otherwise it will fail.
    从某时间开始播放：开始回放成功后才能使用此接口，否则会失败

    @param seekTime Start time: format is 20171228102035 (开始时间:格式为20171228102035)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)seekPlackbackSDCardWithSeekTime:(NSString *)seekTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Pause playback (暂停回放)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)pausePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Continue playback(继续回放)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)resumePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Get video days(获取视频天数)
    [self.device getPlaybackVideoDaysWithYear:year month:month success:^(NSArray *days) {

    } failure:^(NSString *error) {

    }];

    // Get the video duration of a certain day(获取某天视频时长)
    [self.device getPlaybackVideoTimesInDay:day month:month year:year success:^(NSArray *times) {

    } failure:^(NSError *error) {
    
    }];


    // Start playing back the video(开始回放录像)
    [self.device startPlackbackSDCardWithPlayView:playview startTime:starttime success:^{

    } failure:^(BOOL isPlaying) {

    }];

    // stop playback(停止回放)
    [self.device stopPlackbackSDCardSuccess:^{
    WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
    WYDo_Block_Safe_Main(success)
    }];

    // seek playback(seek回放)
    [self.device seekPlackbackSDCardWithSeekTime:self.currentComponents.timeStringWithNoSprit success:^{

    } failure:^(NSString *error) {

    }];

    // Pause playback(暂停回放)
    [self.device pausePlackbackSDCardSuccess:^{

    } failure:^(NSString *error) {

    }];

    // continue playback(继续回放)
    [self.device resumePlackbackSDCardSuccess:^{

    } failure:^(NSString *error) {

    }];
    
    // Set playback level
    [self.camera setPlaybackRecordVideoLevel:level success:^{

    } failure:^(NSError *error) {

    }];
```

## 10.6 mute / 静音 

```
【Description】/【描述】
    Set mute(设置静音)

【Function Call】【函数调用】
    /**
    Set mute(设置静音)

    @param muted muted is mute?(是否静音)
    */
    - (void)setMute:(BOOL)muted;

【Code Example】【代码范例】

    // Set the mute(设置静音)
    [self.device setMute:muted];

```

## 10.7 Voice Intercom / 语音对讲 

### (1) One-way intercom / 单向对讲 

```
【Description】/【描述】
    One-way intercom is that the mobile phone and the device cannot talk at the same time. The mobile terminal starts the intercom call startVoicetalk, and the end of the speech needs to call to stop the intercom stopVoicetalkSuccess, otherwise the mobile phone terminal cannot receive the speech.
    
    单向对讲是手机与设备不能同时讲话，手机端开始对讲调用startVoicetalk，讲话结束需要调用停止对讲stopVoicetalkSuccess，否则设备端讲话手机端无法接收到
    
【Be Applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】

	/**
    Set the voice intercom type(设置语音对讲类型)

    @param type voice intercom type(语音对讲类型)
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    Get the real-time volume of the voice intercom(获取语音对讲的实时音量)

    @return 0-1.0
    */
    - (CGFloat)getVoicetalkVolume;

    /**
    Start voice intercom(开始语音对讲)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Stop voice intercom / 停止语音对讲

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

	 // Set the voice intercom type(设置语音对讲类型)
    [self.camera setVoiceTalkType:MeariVoiceTalkTypeOneWay];

    // Get the real-time volume of the voice intercom(获取语音对讲的实时音量)
    [self.camera getVoicetalkVolume]


    // Start voice intercom(开始语音对讲)
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

    // Stop the voice intercom(停止语音对讲)
    [self.camera stopVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

```
### (2) Two-way intercom / 双向对讲 

```
【Description】/【描述】 
    Two-way intercom is a mobile phone and device ** can ** speak at the same time, the mobile terminal starts the intercom call startVoicetalk, does not call stopVoicetalkSuccess, does not affect the sound from the device side
    
    双向对讲是手机与设备**可以**同时讲话，手机端开始对讲调用startVoicetalk，不调用stopVoicetalkSuccess，不会影响设备端传来声音
    
【Be Applicable】【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,

【Function Call】【函数调用】

	/**
    Set the voice intercom type / 设置语音对讲类型

    @param type voice intercom type(语音对讲类型)
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    Start voice intercom(开始语音对讲)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    Stop voice intercom(停止语音对讲)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
	 Turn on two-way voice speakers
	 开启双向语音扬声器

	 @param enabled 是否开启
	 */
	- (void)enableLoudSpeaker:(BOOL)enabled;

【Code Example】【代码范例】

	 // Set the voice intercom type(设置语音对讲类型)
    [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];

 
    // Start voice intercom(开始语音对讲)
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

    // Stop the voice intercom (停止语音对讲)
    [self.camera stopVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];
    
    // Turn on two-way voice speakers (开启双向语音扬声器)
    [self.camera enableLoudSpeaker:YES];

```

### (3) Voice doorbell intercom / 语音门铃对讲  

```
【Description】/【描述】
    The voice doorbell intercom is different from other intercom modes. It supports two-way intercom. If the mobile phone needs to turn off the microphone, you can call the pause interface. When you need to re-open the microphone, you need to reset the intercom operation.
    语音门铃对讲有别于其他对讲方式，支持双向对讲，如果手机端需要将麦克关闭，可以调用暂停接口，当需要重新打开麦克时需要重置对讲操作
    
【Be Applicable】【适用】
	subType:
  	MeariDeviceSubTypeIpcVoiceBell = 5,

【Function Call】【函数调用】
	/**
    Set the voice intercom type(设置语音对讲类型)

    @param type voice intercom type(语音对讲类型)
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    Start voice intercom(开始语音对讲)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

	/**
	 Turn off the phone side microphone(关闭手机端麦克)
	 
	 @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
	- (void)pauseVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
	 Turn on the phone microphone(开启手机端麦克)
	 
	 @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
	- (void)resumeVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

	 // Set the voice intercom type (设置语音对讲类型)
    [self.camera setVoiceTalkType: MeariVoiceTalkTypeFullDuplex];

    // Start voice intercom (开始语音对讲)
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];
	
	// Close the phone microphone(关闭手机端麦克)
	[self.camera pauseVoicetalkSuccess:^{
	
	} failure:^(NSError *error) {
	
	};
	
    // Open the phone microphone (开启手机端麦克)
	[self.camera resumeVoicetalkSuccess:^{
	
	} failure:^(NSError *error) {
	
	};

```

## 10.8 Screenshot / 截图 

```
【Description】/【描述】
    Capture video image (截取视频图片)

【Function Call】【函数调用】

    /**
     Screenshot  (截图)

    @param path The path where the image is saved(图片保存的路径)
    @param isPreviewing is previewing(是否正在预览)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)snapshotWithSavePath:(NSString *)savePath isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

    // screenshot(截图)
    [self.camera snapshotWithSavePath:snapShotPath isPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

```


## 10.9 Video / 录像 

```
【Description】/【描述】
    Video recording(视频录像)

【Function Call】【函数调用】

    /**
    Start recording(开始录像) 

    @param path The path where the video is saved(录像保存的路径)
    @param isPreviewing is previewing(是否正在预览)
    @param Interrputed record Interrputed(录像中断)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)startRecordMP4WithSavePath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success abnormalDisconnect:(MeariDeviceSucess)Interrputed failure:(MeariDeviceFailure)failure;


    /**
    Stop recording(停止录像)

    @param isPreviewing is previewing(是否正在预览)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)stopRecordMP4WithIsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

    // Stop recording(开始录像)
    [self.camera startRecordMP4WithSavePath:path isPreviewing:_isPreviewing success:^{

    } abnormalDisconnect:^{
   
    } failure:^(NSString *error) {

    }];

    //停止录像
    [self.nvr stopRecordMP4WithIsPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

```


## 10.10 PTZ control / 云台控制 

```
【Description】/【描述】
    Rotate the camera (转动摄像机)

【Function Call】【函数调用】

/**
    Start turning the camera (开始转动摄像机)

    @param direction direction(转动方向)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)startPTZControlWithDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Stop turning the camera (停止转动摄像机)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)stopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

    // Start to turn (开始转动)
    [self.camera startPTZControlWithDirection:MeariMoveDirectionUp success:^{

    } failure:^(NSString *error) {

    }];

    // stop turning (停止转动)
    [self.camera stopMoveSuccess:^{

    } failure:^(NSString *error) {

    }];

```


## 10.11 Mirroring / 镜像 

```
【Description】/【描述】
    Mirror status acquisition and setting
    镜像状态的获取与设置

【Function Call】【函数调用】

    /**
    Get mirror status (设置镜像)

    @param open  whether to open mirror (是否打开镜像) 
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setMirrorWithOpen:(BOOL)open Success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
     [self.camera setMirrorWithOpen: NO success:^{

    } failure:^(NSError *error) {

    }];

```


## 10.12 Motion Detection Alarm / 移动侦测报警 

```
【Description】/【描述】
    Alarm information acquisition and setting ( 报警信息的获取与设置 )

【Function Call】【函数调用】

    /**
    Get alarm information (获取报警级别)

    @param level alarm level(报警级别)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setMotionDetectionLevel:(MeariDeviceLevel)level Success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

    // Set the alarm level(设置报警级别)
    [self.camera setMotionDetectionLevel:level Success:^(id obj) {

    } failure:^(NSString *error) {

    }];

```


## 10.13 Storage (SD card) / 存储 (SD卡) 

```
【Description】/【描述】
    Stored information acquisition and formatting(存储的信息获取与格式化)

【Function Call】【函数调用】
    /**
    Get storage information(获取存储信息)

    @param success Successful callback (成功回调)，return storage information(返回存储信息)
    @param failure failure callback (失败回调)
    */
    - (void)getSDCardInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;


    /**
    Get memory card formatting percentage(获取内存卡格式化百分比)

    @param success Successful callback (成功回调),return formatting percentage(返回格式化百分比)
    @param failure failure callback (失败回调)
    */
    - (void)getSDCardFormatPercentSuccess:(MeariDeviceSucess_StoragePercent)success failure:(MeariDeviceFailure)failure;

    /**
    Format memory card(格式化内存卡)

    @param success Successful callback (成功回调)
    @param failure 失败回道
    */
    - (void)startSDCardFormatSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

    // Get storage information (获取存储信息)
    [self.device getSDCardInfoSuccess:^(MeariDeviceParamStorage *storage) {

    } failure:^(NSString *error) {

    }];

    // Get the formatting percentage (获取格式化百分比)
    [self.device getSDCardFormatPercentSuccess:^(NSInteger percent) {

    } failure:^(NSString *error) {

    }];

    // Format the memory card (格式化内存卡)
    [self.device startSDCardFormatSuccess:^{

    } failure:^(NSString *error) {

    }];

```

## 10.14 Firmware Upgrade / 固件升级 

### (1) Online upgrade / 在线升级 

```
【Description】/【描述】
    Firmware information acquisition and upgrade, point upgrade equipment will be upgraded immediately.
    Note: You need to operate the device online and establish a successful connection.
    
    固件的信息获取与升级，点升级设备会立即进行升级操作，
    注意：需要在设备在线并建立连接成功后才能操作
    
【Be Applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】

    /**
    Get the firmware version(获取固件版本)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)getFirmwareVersionSuccess:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;


    /**
    Get firmware upgrade percentage(获取固件升级百分比)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)getDeviceUpgradePercentSuccess:(MeariDeviceSucess_VersionPercent)success failure:(MeariDeviceFailure)failure;


    /**
    Upgrade firmware (升级固件)

    @param url firmware package address(固件包地址)
    @param currentVersion Firmware current version number(固件当前版本号)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)startDeviceUpgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】【代码范例】

    // Get the firmware version(获取固件版本)
    [self getFirmwareVersionSuccess:^(id obj) {

    } failure:^(NSError *error) {

    }];

    // Get the firmware upgrade percentage (获取固件升级百分比)
    [self.camera getDeviceUpgradePercentSuccess:^(NSInteger percent) {

    } failure:^(NSError *error) {

    }];

    // Upgrade the firmware(升级固件)
    [weakSelf.camera startDeviceUpgradeWithUrl:weakSelf.devUrl currentVersion:weakSelf.currentVersion success:^{

    } failure:^(NSError *error) {

    }];

```

## 10.15 Get parameter information / 获取参数信息 

```
【Description】/【描述】
    Obtain all the parameter information of the device, and the function parameters set for the device can be obtained through this interface.
    获取设备的所有参数信息，对设备设置的功能参数，可以通过此接口获取，在设备调用成功的

【Function Call】【函数调用】
    /**
    Get all parameters(获取所有参数)

    @param success Successful callback (成功回调)，return value: device parameter information (返回值：设备参数信息)
    @param failure failure callback (失败回调)
    */
    - (void)getDeviceParamsSuccess:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.camera getDeviceParamsSuccess:^(WYCameraParams *params) {

    } failure:^(NSString *error) {

    }];
```


## 10.16 Sleep Mode / 休眠模式 

```
【Description】/【描述】
    Set different modes to control the device lens,(设置不同的模式控制设备镜头，)
    MeariDeviceSleepmodeLensOn ： Lens on(镜头打开)
    MeariDeviceSleepmodeLensOff ： The lens is permanently off(镜头永久关闭)
    MeariDeviceSleepmodeLensOffByTime ： The lens is turned off by time period(镜头按时间段关闭)
    MeariDeviceSleepmodeLensOffByGeographic ： The lens is closed according to geographical location(镜头根据地理位置关闭)

【Function Call】【函数调用】
    /**
    Set sleep mode(设置休眠模式)

    @param type sleep mode(休眠模式)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setSleepModeType:(MeariDeviceSleepmode)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    Set the sleep period(设置休眠时间段)

    @param open Whether to enable sleep mode(是否开启休眠模式)
    @param times Sleep time period(休眠时间段)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setSleepModeTimesOpen:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
	 Set geofence(设置地理围栏)
	
	 @param ssid wifi SSID
	 @param bssid wifi BSSID
	 @param deviceID (device ID)设备ID
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
     - (void)setGeofenceWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

     /**
     The device switches to sleep mode. When Wi-Fi changes, please call this interface to notify whether to enter sleep mode.
	 设备切换休眠模式, 当Wi-Fi发生改变的时候, 请调用该接口通知是否进入休眠模式
	 deviceList.count must  ==  modeList.count

	 @param deviceList Device array, which stores the device ID of each device (设备数组, like: [057377002, 057377012, 057377022])
	 @param modeList 是否开启的数组 [@"on", @"off", @"off"];
	 @param success 成功回调
	 @param failure 失败回调
	 
	 on or off ==>             NSString *mode =  ((camera.info.sleepmode == MeariDeviceSleepmodeLensOffByGeographic||camera.param.sleepmode == MeariDeviceSleepmodeLensOffByGeographic) &&
                               [camera.info.wifiSsid isEqualToString:ssid]) ? @"on" : @"off";
	 */
		 
	- (void)settingGeographyLocationWithDeviceList:(NSArray *)deviceList modeList:(NSArray *)modeList success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    // Set sleep mode(设置休眠模式)
    [self.camera setSleepModeType:model.type success:^{

    } failure:^(NSError *error) {

    }];

    // Set the sleep time period(设置休眠时间段)
    [self.camera setSleepModeTimesOpen:open times:timesArr success:^{

    }failure:^(NSError *error) {

    }];
    
    // Set the WiFi information(设置WiFi信息)
	[[MeariUser sharedInstance] setGeofenceWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:^(NSString *str){
	
	} failure:^(NSError *error){

	}];
    
```


## 10.17 Temperature and Humidity / 温湿度 

```
【Description】/【描述】
    Get all parameter information of the device
    获取设备的所有参数信息

【Function Call】【函数调用】

    /**
    Get temperature and humidity(获取温湿度)

    @param success Successful callback (成功回调)，返回值：温度和湿度
    @param failure failure callback (失败回调)
    */
    - (void)getTemperatureHumiditySuccess:(MeariDeviceSucess_TRH)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Get temperature and humidity(获取温湿度)
    [self.camera getTemperatureHumiditySuccess:^(CGFloat temperature, CGFloat humidty) {

    } failure:^(NSError *error) {
        if (error.code == MeariDeviceCodeNoTemperatureAndHumiditySensor) {
        // No temperature and humidity sensor(没有温湿度传感器)
        }else {

        }
    }];
```


## 10.18 Music / 音乐 

```
【Description】/【描述】
    Get the music status of the device, control the device to play music, you need a memory card to play
    获取设备音乐状态，控制设备播放音乐，需要有内存卡才能播放

【Function Call】【函数调用】

    /**
    play music(播放音乐)

    @param musicID music ID(音乐ID)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)playMusicWithMusicID:(NSString *)musicID success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Pause music(暂停播放音乐)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)pauseMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    Keep playing music(继续播放音乐)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)resumeMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Play the next song(播放下一首)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)playNextMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Play the previous one(播放前一首)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)playPreviousMusicSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Get music status: including play and download status
    (获取音乐状态：包括播放和下载状态)

    @param success Successful callback (成功回调), return value: json dictionary (返回值：json字典)
    @param failure failure callback (失败回调)
    */
    - (void)getMusicStatusSuccess:(MeariDeviceSucess_MusicStateAll)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Start playing music(开始播放音乐)
    [self.camera playMusicWithMusicID:musicID Success:^{
    } failure:^(NSError *error) {

    }];

    // Pause to play music (暂停播放音乐 )
    [self.camera pauseMusicSuccess:^{

    } failure:^(NSError *error) {

    }];

    // Continue to play music (继续播放音乐)
    [self.camera resumeMusicSuccess:^{

    } failure:^(NSError *error) {

    }];

    // Play the next music(播放下一首音乐)
    [self.camera playNextMusicSuccess:^{

    } failure:^(NSError *error) {

    }];

    // Play the last music (播放上一首音乐 )
    [self.camera playPreviousMusicSuccess:^{

    } failure:^(NSError *error) {

    }];

    // Get the playing status of all music (获取所有音乐的播放状态)
    [self.camera getMusicStatusSuccess:^(NSDictionary *allMusicState) {

    } failure:^(NSError *error) {

    }];

```


## 10.19 Music Device Volume / 设备音量 

```
【Description】/【描述】
    Device output volume acquisition and setting (设备输出音量的获取与设置)

【Function Call】【函数调用】

    /**
    Get music device output volume (获取babymonitor摄像机输出音量)

    @param success Successful callback (成功回调)，return value: device output volume, 0-100 (返回值：设备输出音量，0-100)
    @param failure failure callback (失败回调)
    */
    - (void)getMusicOutputVolumeSuccess:(MeariDeviceSucess_Volume)success failure:(MeariDeviceFailure)failure;


    /**
    Set the music device output volume (设置babymonitor摄像机输出音量)

    @param volume volume(音量)，0-100
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setMusicOutputVolume:(NSInteger)volume Success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Get the music device output volume (获取babymonitor摄像机输出音量)
    [self.camera getMusicOutputVolumeSuccess:^(CGFloat volume) {

    } failure:^(NSError *error) {

    }];

    // Set the music device output volume (设置babymonitor摄像机输出音量)
    [self.camera setMusicOutputVolume:volume Success:^{

    } failure:^(NSError *error) {

    }];
```


## 10.20 Doorbell volume / 门铃音量 

### (1) Visual doorbell / 可视门铃 

```
【Description】/【描述】
    Doorbell output volume acquisition and setting
    门铃输出音量的获取与设置
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,

【Function Call】【函数调用】
    /**
    Set the doorbell output volume (设置门铃输出音量)

    @param volume volume(音量)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Get the doorbell output volume(获取门铃输出音量)
    [self.camera setVolume:roundf(slider.value) success:^{

    } failure:^(NSError *error) {

    }];
```

## 10.21  Bell settings / 铃铛设置 

### (1) Visual doorbell / 可视门铃 

```
【Description】/【描述】
    Doorbell output volume acquisition and setting (门铃输出音量的获取与设置)
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,

【Function Call】【函数调用】

	/**
	 Whether to use a chime(设置铃铛使能)
	 
	 @param enable Whether to use a chime(设置铃铛使能)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)setChimeVolumeEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

	
	/**
	 Set the wireless bell (设置无线铃铛)
	 
	 @param volumeLevel Bell sound level (铃铛声音等级)
	 @param selectedSong Selected ringtone (选中的铃声)
	 @param repeatTimes number of repetitions (重复次数)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)setChimeVolumeLevel:(MeariDeviceLevel)volumeLevel selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

		/**
	 Doorbell and chime pairing(门铃与铃铛配对)
	 
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)setChimePairingSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
	
	/**
	 Doorbell and chime unbound (门铃与铃铛解除绑定 )
	 
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)setChimeUnbindSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

	/**
	
	 Turn on the mechanical chime( 开启机械铃铛)
	
	 @param open Whether to open (是否开启)
    @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)setMachineryBellOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】  
   // Whether to use a chime(设置铃铛使能)
    [weakSelf.camera setChimeVolumeEnable:!item.selected success:^{

    } failure:^(NSError *error) {

    }];  
    
    // Set the wireless bell (设置无线铃铛)
    [self.camera setChimeVolumeLevel:MeariDeviceLevelHigh selectedSong:self.selectedSong repeatTimes:1 success:^(id obj) {

    } failure:^(NSError *error) {

    }];
    
    // Doorbell and chime pairing(门铃与铃铛配对)
    [self.camera setChimePairingSuccess:^{

    } failure:^(NSError *error) {

    }];
    
    // Doorbell and chime unbound (门铃与铃铛解除绑定 )
    [self.camera setChimeUnbindSuccess:^{

    } failure:^(NSError *error) {

    }];
    
    // Turn on the mechanical chime( 开启机械铃铛)
   [self.camera setMachineryBellOpen:sender.on success:^{

    } failure:^(NSError *error) {
   
    }];

```

## 10.22 Message Settings / 留言设置 

```
【Description】/【描述】
    Set guest message parameters, note that this setting does not take effect immediately, you need to wait for the device to start once to take effect.
    设置客人留言参数,注意此设置非立即生效，需要等设备启动一次后才可以生效
    
【Be applicable】【适用】
	subType:
  	MeariDeviceSubTypeIpcVoiceBell = 5,

【Function Call】【函数调用】
	/**
	Set guest message (设置访客留言)
	
	@param enterTime  Press the doorbell to enter the message time 10/20/30...60s (按门铃后进入留言时间10/20/30...60s)
	@param durationTime Message length 10/20/30...60s (可留言时长10/20/30...60s)
	@param success Successful callback (成功回调)
	@param failure failure callback (失败回调)
	*/
	- (void)setVoiceBellEnterMessageTime:(NSInteger)enterTime messageDurationTime:(NSInteger)durationTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】【代码范例】
    // Set the wireless bell (设置无线铃铛)
    [self.device setVoiceBellCharmVolumeLevel: MeariDeviceLevelLow songDuration:MeariDeviceLevelLow songIndex:1 success:^{
        NSLog(@"set voice bell charm success-Volume-%ld-Duration-%ld-songIndex-%ld",weakSelf.device.param.voiceBell.jingleVolume,weakSelf.device.param.voiceBell.jingleDuration,weakSelf.device.param.voiceBell.jingleRing);
    } failure:^(NSError *error) {
        NSLog(@"set voice bell charm success");
    }];

```


## 10.23 Human body detection alarm / 人体侦测报警 

```
【Description】/【描述】
    Acquisition and setting of doorbell PIR alarm: Get the call parameter interface
    (门铃PIR报警的获取与设置：获取需要用调用参数接口)

【Function Call】【函数调用】
    // Doorbell PIR alarm acquisition, see 7.15 Obtaining parameter information
    // 门铃PIR报警获取，参见 7.15 获取参数信息
    /**
    Get all parameters (获取所有参数)

    @param success Successful callback (成功回调)，return value: device parameter information (返回值：设备参数信息)
    @param failure failure callback (失败回调)
    */
    - (void)getDeviceParamsSuccess:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    Set the doorbell PIR (human body detection) alarm type (设置门铃PIR(人体侦测)报警类型)

    @param level alarm level (报警级别)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setPirDetectionLevel:(MeariDeviceLevel)level Success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Get the doorbell PIR alarm information (获取门铃PIR报警信息)
    [self.camera getDeviceParamsSuccess:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    // Set the doorbell PIR (human body detection) alarm type (设置门铃PIR(人体侦测)报警类型)
    [self.camera setPirDetectionLevel:level Success:^{

    } failure:^(NSError *error) {

    }];
```


## 10.24 Doorbell low power consumption / 门铃低功耗 

```
【Description】/【描述】
    Doorbell low power acquisition and setting: Get the call parameter interface
    (门铃低功耗的获取与设置：获取需要用调用参数接口)

【Function Call】【函数调用】
    // doorbell low power acquisition, see 7.15 for parameter information
    // 门铃低功耗获取，参见 7.15 获取参数信息
    /**
    Get all parameters (获取所有参数)

    @param success Successful callback (成功回调)，return value: device parameter information (返回值：设备参数信息)
    @param failure failure callback (失败回调)
    */
    - (void)getDeviceParamsSuccess:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    Set the doorbell low power consumption (设置门铃低功耗)

    @param open Whether to turn on low power mode (是否打开低功耗模式)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setDoorBellLowPowerOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Get the doorbell low power consumption (获取门铃低功耗)
    [self.camera getDeviceParamsSuccess:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    // Set the doorbell low power to turn on or off (设置门铃低功耗打开或关闭)
    [self.camera setDoorBellLowPowerOpen:open success:^{

    } failure:^(NSError *error) {

    }];
```


## 10.25 Doorbell battery lock / 门铃电池锁

```
【Description】/【描述】
    Doorbell battery lock acquisition and setting: Get the call parameter interface
    门铃电池锁的获取与设置：获取需要用调用参数接口

【Function Call】【函数调用】
    // doorbell battery lock acquisition, see 7.15 for parameter information
    // 门铃电池锁获取，参见 7.15 获取参数信息
    /**
    Get all parameters (获取所有参数)

    @param success Successful callback (成功回调)，return value: device parameter information (返回值：设备参数信息)
    @param failure failure callback (失败回调)
    */
    - (void)getDeviceParamsSuccess:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    Set the doorbell battery lock (设置门铃电池锁)

    @param open Whether to open the battery lock (是否打开电池锁)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setBatteryLockOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    // Get the doorbell battery lock (获取门铃电池锁)
    [self.camera getDeviceParamsSuccess:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    // Set the doorbell low power to turn on or off (设置门铃低功耗打开或关闭)
    [self.camera setBatteryLockOpen:open success:^{

    } failure:^(NSError *error) {

    }];
```

## 10.26 Message / 留言 

### (1) Owner's Message / 主人留言 

```
【Description】/【描述】
    The owner can set a message for the device, and the owner can play the recorded message on the mobile terminal control device.
    主人可为设备设置留言，主人可以在手机端控制设备播放自己录制的留言

【Be applicable】【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,
  	
【Function Call】【函数调用】

    /**
    Start message (开始留言)

    @param path (path)录音文件路径 例如(likes): /var/mobile/Containers/Data/Application/98C4EAB7-D2FF-4519-B732-BEC7DE19D1CE/Documents/audio.wav  warning!!, it must be .wav format (注意!!! 文件必须是wav格式))
    */
    
	 /**
	 Get doorbell message list (获取门铃留言列表)
	
	 @param success Successful callback, URL of the file containing the message (成功回调,包含留言的文件的URL地址)
    @param failure failure callback (失败回调)
	 */
	- (void)getVoiceMailListSuccess:(MeariDeviceSucess_HostMessages)success failure:(MeariDeviceFailure)failure;
    
    
    - (void)startRecordVoiceMailWithPath:(NSString *)path;

    /**
    Stop message (停止留言)

    @param success Successful callback (成功回调)，return value: message file path (返回值：留言文件路径)
    */
    - (void)stopRecordAudioSuccess:(MeariDeviceSucess_RecordAutio)success;

    /**
    Start playing a message (开始播放留言)

    @param filePath message file path(留言文件路径)
    @param finished 完成回调
    */
    - (void)startPlayVoiceMailWithFilePath:(NSString *)filePath finished:(MeariDeviceSucess)finished;

    /**
    Stop playing the message (停止播放留言)
    */
    - (void)stopPlayVoiceMail;


【Code Example】【代码范例】
    // Start a message (开始留言)
    [self.camera startRecordVoiceMailWithPath:_filePath];

    // Stop the message (停止留言)
    [self.camera stopRecordAudioSuccess:^(NSString *filePath) {

    }];

    // Start playing the message (开始播放留言)
    [self.camera startPlayVoiceMailWithFilePath:_filePath finished:^{

    }];

    // Stop playing the message (停止播放留言)
    [self.camera stopPlayVoiceMail];
    
    // Get doorbell message list (获取门铃留言列表)
    [self.camera getVoiceMailListSuccess:^(NSArray *customArray) {
 
    } failure:^(NSError *error) {

    }];

```
### (2) Guestbook / 客人留言 

```
【Description】/【描述】
    After the guest rings the door, no device responds, the device will enter the message mode, the guest can leave a message on the device, and the owner can view the guest message through the mobile app.
    在客人按门铃后无人响应，设备会进入留言模式，客人可以对设备进行留言，主人可通过手机App查看客人留言信息

【Be applicable】【适用】
	subType:
	MeariDeviceSubTypeIpcVoiceBell = 5,
  	
【Function Call】【函数调用】
	1、Get visitor information (获取访客信息)
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
	
	2、get voice data (获取语音数据)
	/**
	 Get voice data (获取语音数据)
	 
	 @param remoteUrl Audio Network Address(音频网络地址)
	 @param sourceData audio data(成功回调音频数据)
	 @param failure failure callback (失败回调)
	 */
	- (void)getVoiceMessageAudioDataWithRemoteUrl:(NSString *)remoteUrl deviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceVoiceData)sourceData failure:(MeariFailure)failure;

	3、play voice dataH26 (播放语音数据)
	/**
	 Start playing guest message (开始播放客人留言)
	 
	 @param filePath local voice file path(本地语音文件路径)
	 @param finished 完成回调
	 */
	- (void)startPlayVoiceMailWithFilePath:(NSString *)filePath finished:(MeariDeviceSucess)finished;
	
	4、stop playing voice data (停止播放语音数据)
	/**
	 Stop playing guest messages (停止播放客人留言)
	 */
	- (void)stopPlayVoiceMessageAudio;

	5、mark the message has been read (标记消息已读)
	/**
	 Mark the message as read (标记消息为已读)
	 
	 @param messageID message ID(消息ID)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)markReadVoiceMessageWithMessageID:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
	
	6、delete a single message (answer, hang up, message information)
	  删除单条消息 (接听、挂断、留言信息)
	/**
	 Delete a single message for a device
	 删除某个设备的单条消息
	 
	 @param messageID message ID(消息ID)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)deleteVoiceMessageWithMessageID:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
	
	7、delete all messages (answer, hang up, message information)
	   删除所有消息 (接听、挂断、留言信息) 
	/**
	Delete all messages under a device
	 删除某个设备下所有消息
	 
	 @param deviceID device ID (设备ID)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
	- (void)deleteAllVoiceMessageWithMessageID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;
	
    
【Code Example】【代码范例】
   所属：MeariSDK：WYVoiceDoorbellAlarmMsgDetailVC.h

```


## 10.27 Device playback message / 设备播放留言 

```
【Description】/【描述】
     Play message (播放留言)

【Function Call】【函数调用】

    /**
    Play message(播放留言)

    @param success Successful callback (成功回调)
    @param failure 成功回调
    */
    - (void)makeDeivcePlayVoiceMailSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;     


【Code Example】【代码范例】

    // Control device to play a message (控制设备播放留言)
    [self.camera makeDeivcePlayVoiceMailSuccess:^{

    } failure:^(NSError *error) {

    }];
```


##9.28 Lighting camera settings / 灯具摄像机设置 

### (1) Switch light / 开关灯 

```
【Description】/【描述】
   Control light switch (控制灯的开关)
    
【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】
    /**
	Setting the light switch (设置灯开关)
	
	@param on light switch(灯开关)
	@param success Successful callback (成功回调)
	@param failure failure callback (失败回调)
	*/
	- (void)setFlightCameraLampOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure; 


【Code Example】【代码范例】
	  // Set the light switch (设置灯开关)
     [self.camera setFlightCameraLampOn:isOn success:^{
     
     } failure:^(NSError *error) {
	
     }];
```

### (2) Alarm switch / 报警器开关 

```
【Description】/【描述】
    Control the alarm switch through the device to achieve the warning function
    通过设备控制报警器的开关，以达到警示的作用
    
【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】

    
	/**
	Set the alarm switch (设置警报开关)
	
	@param on alarm switch (警报开关)
	@param success Successful callback (成功回调)
	@param failure failure callback (失败回调)
	*/
	- (void)setFlightCameraSirenOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;     


【Code Example】【代码范例】
	// Set the alarm switch (设置警报开关)
    [weakSelf.camera setFlightCameraSirenOn:NO success:^{

    } failure:^(NSError *error) {
  
    }];

```

### (3) Turn on the lights by time period / 按时间段开灯 

```
【Description】/【描述】
   Set a time period for the device. When the device is in the set time period, the device will turn on the light, and when the time is off, the control light will be turned off.
	给设备设置一个时间段，当设备在设置的时间段内，设备会讲灯打开，时间截止则控制灯关闭
    
【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】

    /**
    Set up the lighting plan
	设置灯具开灯计划
	
	@param on Is it enabled? (是否使能)
	@param fromDateStr start time (开始时间)
	@param toDateStr End time (结束时间)
	@param success Successful callback (成功回调)
	@param failure failure callback (失败回调)
	*/
	- (void)setFlightCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;   


【Code Example】【代码范例】

    //	Set the lighting program (设置灯具开灯计划)
     [self.camera setFlightCameraScheduleOn:self.lightSwitch.isOn fromDate:_timeArray[0] toDate:_timeArray[1]  success:^{

    } failure:^(NSError *error) {
 
    }];
```

### (4) Press the alarm event switch light / 按报警事件开关灯 

```
【Description】/【描述】
    After turning on the mobile alarm, the device monitors the movement of the human body and turns the light on. It will go out after a period of time.
    打开移动报警开灯后，设备监测到人体移动，会将灯打开，持续一段时间后熄灭
    
【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】

    /**
	 Set up the movement monitoring of the luminaire
	 设置灯具的移动监测level
	
    @param level The lighting time for different levels (不同等级对应的亮灯时间)。 MeariDeviceLevelNone : 0 , MeariDeviceLevelLow : 20s , MeariDeviceLevelMedium : 40s, MeariDeviceLevelHigh: 60s
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
     - (void)setFlightCameraDurationLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
    


【Code Example】【代码范例】

    NSInteger durationTime = [duration integerValue];
    MeariDeviceLevel level =  MeariDeviceLevelLow;
    if (durationTime == 20) {
        level = MeariDeviceLevelLow;
    }else  if (durationTime == 40) {
        level = MeariDeviceLevelMedium;
    }else  if (durationTime == 60){
       level = MeariDeviceLevelHigh;
    }
    [self.camera setFlightCameraDurationLevel:level success:^{

    } failure:^(NSError *error) {

    }];
```

### (5) flight camera motion event open / 灯具摄像机移动侦测是否开启
```
【Description】/【描述】
whether flight camera motion open (灯具摄像机移动侦测是否开启)

【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】
	/**
	whether flight camera motion open
	 设置灯具的移动监测开关
 
	 @param on 是否开启(open?)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)setFlightCameraMotionOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.camera setFlightCameraMotionOn:isOn success:^{

    } failure:^(NSError *error) {
  
    }];
```

### (6) the brightness of the flightCamera / 灯具摄像机亮度调节
```
【Description】/【描述】
the brightness of the flightCamera (灯具摄像机亮度调节) set (0-100) 

【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】【函数调用】
	/**
	 Set the brightness of the fixture
	 设置灯具的亮度调节

	 @param precent  current brightness (当前亮度百分比) 0-100
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)setFlightCameraLightPercent:(NSInteger)precent success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.camera setFlightCameraLightPercent:30 success:^{

    } failure:^(NSError *error) {

    }];
```

## 10.29 Doorbell answer / 门铃接听
```
// When Apple push msgType == 2 or mqtt type is (MeariMqttCodeTypeVisitorCall), someone rings the doorbell.
// 当苹果推送msgType==2 或者mqtt类型为(MeariMqttCodeTypeVisitorCall), 为有人按门铃.
```

### (1) 	 Doorbell answer / 接听门铃
```
【Description】/【描述】
 // Used to answer the doorbell, must be used with "requestReleaseAnswerAuthorityWithID"
 // 用于接听门铃, 必须和“ requestReleaseAnswerAuthorityWithID” 一起使用

【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcBell = 3,

【Function Call】【函数调用】
	/**
	// Doorbell answer
	//  接听门铃

	 @param deviceID 设备ID
	 @param messageID 消息ID (the data create by push, or mqtt)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)requestAnswerAuthorityWithDeviceID:(NSInteger)deviceID messageID:(NSInteger)messageID  success:(MeariSuccess_RequestAuthority)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] requestAnswerAuthorityWithDeviceID:camera.info.ID messageID:[_pushModel.msgID intValue] success:^(NSInteger msgEffectTime,double severTime){

    } failure:^(NSError *error) {

    }];
    
```

### (2)	 hang up Doorbell / 挂断门铃
```
【Description】/【描述】
 // Used to hang up the doorbell, must be used with "requestAnswerAuthorityWithDeviceID" 
 // 用于挂掉门铃, 必须和“ requestAnswerAuthorityWithDeviceID” 一起使用

【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcBell = 3,

【Function Call】【函数调用】
	/**
	// hang up Doorbell
	//  挂断门铃

	 @param ID  device ID (设备ID) 
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)requestReleaseAnswerAuthorityWithID:(NSInteger)ID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] requestReleaseAnswerAuthorityWithID:camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
    
```

### (3)	Is the doorbell still answering / 门铃是否还在接听
```
【Description】/【描述】
 // When you are in the answering process, please use the timer to loop this call to call the answer, and inform the doorbell answering status.
 // 当你在接听过程中 ,请使用定时器循环这个调用这个接听, 告知门铃接听状态.

【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcBell = 3,

【Function Call】【函数调用】
	/**
	Is the doorbell still answering
	发送心跳

	 @param deviceID 设备ID
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)sendHeartBeatWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] sendHeartBeatWithDeviceID:camera.info.ID success:^{
    
    } failure:^(NSError *error) {
    
    }];
    
```

## 10.30 LED 
```

【Description】/【描述】
  Set whether the device's LED is turned on (设置设备的led是否开启) 

【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,

【Function Call】【函数调用】
/**
  set LED (设置LED)
 
 @param on (whether to open led)是否打开LED
 @param success Successful callback (成功回调)
 @param failure failure callback (失败回调)
 */
- (void)setLEDOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

    [self.camera setLEDOn:sender.isOn success:^{

    } failure:^(NSError *error) {
    
    }];
```

## 10.31 Day night mode / 日夜模式
```

【Description】/【描述】
 // Set day and night mode, the camera will have color or grayscale
 // 设置日夜模式, 摄像头会有彩色或灰度两种

【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,

【Function Call】【函数调用】
	/**
	 set daynight mode
	 设置日夜模式

	 @param type  MeariDeviceDayNightType(日夜模式)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)setDayNightModeType:(MeariDeviceDayNightType)type success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
#pragma mark -- 噪声检测


【Code Example】【代码范例】
   [self.camera setDayNightModeType:MeariDeviceDayNightTypeNight success:^{

    } failure:^(NSError *error) {

    }];

```

## 10.32 Noise detection / 噪声检测 
```

【Description】/【描述】
  // Noise detection, alarm when sound exceeds a certain decibel
  // 噪声检测, 当有声音超过一定分贝的时候报警

【Function Call】【函数调用】
	/**
	 set DBDetection
	 设置噪声检测
 
	 @param level  MeariDeviceLevel (噪声等级)
	 @param success Successful callback (成功回调)
	 @param failure failure callback (失败回调)
	 */
- (void)setSoundDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
	 [self.camera setSoundDetectionLevel:MeariDeviceLevelHigh success:^{

    } failure:^(NSError *error) {

    }];

```

## 10.33 Get network information / 获取网络信息 
```

【Description】/【描述】
// Get network information : Wi-Fi
// 获取网络信息: Wi-Fi


【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,

【Function Call】【函数调用】
	/**
	  Get network information 
	  获取网络信息

	 @param success Successful callback 成功回调 return(MeariDeviceParamNetwork) 返回值：当前网络信息
	 @param failure Successful callback 失败回调
	 */
- (void)getNetInfoSuccess:(MeariDeviceSucess_NetInfo)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.camera getNetInfoSuccess:^(MeariDeviceParamNetwork *info) {

    } failure:^(NSError *error) {

    }];

```
## 10.34 H265
```

【Description】/【描述】
// Whether to enable h265 encoding
// 是否开启h265编码

【Function Call】【函数调用】
	/**
	 // Whether to enable h265 encoding
	 // 开关h265编码
 
	 @param h265 Whether to enable h265 encoding(是否开启h265编码)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)setVideoEncodingWithH265:(BOOL)h265 success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】【代码范例】
    [self.camera setVideoEncodingWithH265:YES success:^{

    } failure:^(NSError *error) {
 
    }];
    


``` 
## 10.35 set Onvif / 设置 Onvif 功能是否开启
```

【Description】/【描述】
 // Set whether the Onvif function is turned on
 // 设置 Onvif 功能是否开启

【Function Call】【函数调用】
	/**
	 设置Onvif
	 @param enable  Whether to open (是否开启)
	 @param pwd    Connect onvif password(连接密码)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)setOnvifEnable:(BOOL)enable password:(NSString *)pwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;

【Code Example】【代码范例】
    [self.camera setOnvifEnable:self.headerView.isOpen password:self.passwordTF.text success:^{

    } failure:^(NSError *error) {

    }];


```
## 10.36 Setting up an alarm plan / 设置报警计划
```

【Description】/【描述】
 // Setting up an alarm plan
 // 设置报警计划

【Function Call】【函数调用】

	/**
	 // Setting up an alarm plan
	 // 设置报警计划

	 @param times Array of MeariDeviceParamSleepTime (MeariDeviceParamSleepTime的数组)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)setAlarmTimes:(NSArray<MeariDeviceParamSleepTime *> *)times success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】

    [self.camera setAlarmTimes:times success:^{

    } failure:^(NSError *error) {

    }];


```
## 10.37 Whether people detection and borders are on / 人形检测和边框是否开启
```

【Description】/【描述】
  // Whether people detection and borders are on
  // 人形检测和边框是否开启
  
【Function Call】【函数调用】
    /**
    // Whether people detection  are on
    // 人形检测是否开启

    @param enable Whether people detection is on(人形检测是否开启)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)setHumanDetectionEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

    /**
    // Whether human borders  are on
    // 人形边框是否开启

    @param enable Whether the human border is on(人形边框是否开启)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)setHumanFrameEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


【Code Example】【代码范例】
    [self.camera setHumanDetectionEnable:sender.on success:^{
    
    } failure:^(NSError *error) {

    }];
    
    [self.camera setHumanFrameEnable:sender.on success:^{
    
    } failure:^(NSError *error) {
    
    }];

```
## 10.38 Cry detection/ 哭声检测
```

【Description】/【描述】
// Whether to enable cry detection, when a cry is detected, an alarm will appear
// 是否开启哭声检测,当哭声检测到时, 会出现报警

【Function Call】【函数调用】
	/**
	 Cry detection
	 哭声检测
	
	 @param enable Whether to open(是否开启)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)setCryDetectionEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】【代码范例】
    [self.camera setCryDetectionEnable:sender.on success:^{

    } failure:^(NSError *error) {
  
    }];


```
## 10.39 Human tracking / 人形跟踪
```

【Description】/【描述】
 // 镜头跟随人体移动
 // The camera follows the human body


【Be applicable】【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,

【Function Call】【函数调用】
	/**
	  // Human tracking
	 // 人形跟踪
	
	 @param enable (whether to open)是否开启
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)setHumanTrackEnable:(BOOL)enable success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】【代码范例】
    [self.camera setHumanTrackEnable:sender.on success:^{

    } failure:^(NSError *error) {

    }];


```

## 10.40 Device reboot / 设备重启
```

【Description】/【描述】
// rebootDevice (重启)

【Function Call】【函数调用】
	/**
	Device reboot
	 设备重启
	
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)rebootDeviceSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
	[camera rebootDeviceSuccess:^{
	 
	} failure:^(NSError *error) {
	  
	}];

```
## 10.41 sound and light alarm/ 声光报警
```

【Description】/【描述】
// sound and light alarm enable switch (声光报警使能开关)

【Function Call】【函数调用】
    /// 设置声光报警使能开关
    /// Set sound and light alarm enable switch
    /// @param enable 是否开启
    /// @param success 成功回调
    /// @param failure 失败回调
    - (void)setFloodCameraVoiceLightAlarmEnable:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.camera setFloodCameraVoiceLightAlarmEnable:voiceLightSwitch.on success:^{
        
    } failure:^(NSError *error) {
        
    }];
    

【Description】/【描述】
// Set events after sound and light alarm (声光报警后的事件)

【Function Call】【函数调用】
    /// 设置声光报警后的事件
    /// Set events after sound and light alarm
    /// @param type 类型
    /// @param success 成功回调
    /// @param failure 失败回调
    - (void)setFloodCameraVoiceLightAlarmType:(MeariDeviceVoiceLightType)type success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code Example】【代码范例】
    [self.camera setFloodCameraVoiceLightAlarmType:MeariDeviceVoiceLightTypeLight success:^{
        
    } failure:^(NSError *error) {
        
    }];
```

# 11.Shared device / 共享设备 
```
Affiliation:MeariUser
```

```
所属：MeariUser
```

## 11.1 Get share user List of device / 获取设备分享用户列表

```
【Description】/【描述】
   get share user List of device, the user maybe state is added or requesting.
   (获取设备分享列表, 状态)

【Function Call】【函数调用】
    /**
    // get shared List of device
    // 获取设备分享列表
    @param deviceID (device ID)设备ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
    - (void)getShareListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
   [[MeariUser sharedInstance] getShareListForDeviceWithDeviceID:self.camera.info.ID success:^(NSArray<MeariFriendInfo *> *friends) {
    
    } failure:^(NSError *error) {
       
    }];

```
    
## 11.2 Cancel share device for someone / 取消某人的设备分享

```
【Description】/【描述】
 cancel share device, it will send a notification (MeariDeviceCancelSharedNotification) to another one.  
 (取消分享设备, 会发送一条通知消息MeariDeviceCancelSharedNotification 给另一个人)

【Function Call】【函数调用】
    /**
    cancel share devie (取消分享设备)

    @param deviceID 设备ID
    @param shareAccount 分享账号
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)cancelShareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] cancelShareDeviceWithDeviceID:self.camera.info.ID shareAccount:model.info.shareAccount success:^{
 
    } failure:^(NSError *error) {

    }];

```

## 11.3 Share device / 分享设备
```
【Description】/【描述】
 if A share device to B , B will send a notification to B(MeariDeviceNewShareToMeNotification),  
 如果A分享设备给B, B将会收到一条通知消息, (MeariDeviceNewShareToMeNotification)

【Function Call】【函数调用】
     /**
    分享设备

    @param deviceID 设备ID
    @param shareAccount 分享账号
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
     */
- (void)shareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] shareDeviceWithDeviceID:self.camera.info.ID shareAccount:self.shareInfo.shareAccount success:^{
    
    } failure:^(NSError *error) {

    }];
    
```

## 11.4 Search user to share device / 搜索用户去分享
```
【Description】/【描述】
search user for you to share device. 
搜索用户去分享

【Function Call】【函数调用】
    /**
    Search user(搜索用户)

    @param deviceID 设备ID
    @param userAccount 用户账号
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)searchUserWithDeviceID:(NSInteger)deviceID account:(NSString *)userAccount success:(MeariSuccess_Share)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
     [[MeariUser sharedInstance] searchUserWithDeviceID:self.camera.info.ID account:self.accountTF.text success:^(MeariShareInfo *shareInfo) {

    } failure:^(NSError *error) {

    }];

```

## 11.5 Get history shared list / 获取历史分享账号
```
【Description】/【描述】
Get all previously shared users
获取所有以前分享过的用户

【Function Call】【函数调用】
   /**
    get history shared list
    获取历史分享列表

    @param deviceID 设备ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)getHistoryShareWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getHistoryShareWithDeviceID:self.camera.info.ID success:^(NSArray<MeariShareInfo *> *shareInfoList) {

    } failure:^(NSError *error) {

    }];


```

## 11.6 Delete history shared user / 删除历史分享用户
```
【Description】/【描述】
delete previously shared users
删除历史分享用户

【Function Call】【函数调用】
    /**
    delete history shared user
    删除历史分享用户

    @param deviceID 设备ID
    @param shareAccountArray 分享数组
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)deleteHistoryShareWithDeviceID:(NSInteger)deviceID shareAccountArray:(NSArray *)shareAccountArray success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] deleteHistoryShareWithDeviceID:self.camera.info.ID shareAccountArray:@[] success:^{
  
    } failure:^(NSError *error) {

    }];


```

## 11.7 Get all the your device's shared result /  获取所有设备的分享结果
```
【Description】/【描述】
Get all the your device's shared result (获取所有设备的分享结果)

【Function Call】【函数调用】
    /**
    (get all the your device's shared result)
    获取所有设备的分享结果

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)getAllDeviceShareSuccess:(MeariSuccess_ShareCameraInfo)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getAllDeviceShareSuccess:^(NSArray<MeariShareCameraInfo *> *shareCameraList) {

    } failure:^(NSError *error) {

    }];


```

## 11.8 you Request another to share a device to you (你请求其他人去分享设备给你)
```
【Description】/【描述】
 this will send a notification (MeariDeviceNewShareToHimNotification) to tell another exist share message.
 会发送一个通知消息MeariDeviceNewShareToHimNotification, 
 
【Function Call】【函数调用】
    /**
     you Request another to share a device to you 
     (你请求其他人去分享设备给你)
 
    @param deviceID 设备ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
     */
- (void)requestShareDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] requestShareDeviceWithDeviceID:device.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```


# 12.Message Center / 消息中心 
```
Affiliation:MeariMessageInfo
```
```
Note: The alarm message of the device will be deleted after the device owner pulls it.In addition to the message, it needs to be saved locally. The shared person pulls the alarm message of the device, and the server does not delete it. Here, pay attention to the difference between the owner and the shared person.
```


```
所属：MeariMessageInfo
```
```
注意：设备的报警消息，一经设备的主人拉取后，服务器就会删除该消息，因此需要本地保存，被分享的人拉取了设备的报警消息，服务器不会删除，这里注意主人和被分享人的区别
```
## 12.1 Get all devices have messages / 获取所有设备是否有消息 

```
【Description】/【描述】
    Get all devices have messages
    Affiliation:MeariMessageInfoAlarm
    
    获取所有设备是否有消息
    所属：MeariMessageInfoAlarm

【Function Call】【函数调用】
    // Get all devices have a message
    // 获取所有设备是否有消息
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)getAlarmMessageListSuccess:(MeariSuccess_MsgAlarmList)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getAlarmMessageListSuccess:^(NSArray<MeariMessageInfoAlarm *> *msgs) {

    } failure:^(NSError *error) {

    }];
    
 【Precautions】
    If the message is pulled by the owner, the server will not save the message, and the shared friends will not see the message.  
 【注意事项】
    如果消息一经主人拉取后，服务器不会保存消息，被分享的好友也看不到这些消息
```

## 12.2 Getting system messages / 获取系统消息 

```
【Description】/【描述】
    Get system messages
    Affiliation:MeariMessageInfoSystem
    
    获取系统消息 
    所属：MeariMessageInfoSystem

【Function Call】【函数调用】
    //获取系统消息
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)getSystemMessageListSuccess:(MeariSuccess_MsgSystemList)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getSystemMessageListSuccess:^(NSArray<MeariMessageInfoSystem *> *msgs) {

    } failure:^(NSError *error) {

    }];
```

## 12.3 Get a device alarm message / 获取某个设备报警消息 

```
【Description】/【描述】
    (get all the alarm messgae of one device)获取某个设备报警消息
    所属：MeariMessageInfoAlarmDevice

【Function Call】【函数调用】
    // get all the alarm messgae of one device (获取某个设备报警消息)
    @param deviceID 设备ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)getAlarmMessageListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] getAlarmMessageListForDeviceWithDeviceID:_deviceID success:^(NSArray<MeariMessageInfoAlarmDevice *> *msgs, MeariDevice *device) {

    } failure:^(NSError *error) {

    }];
 【注意事项】
    If the message is pulled by the host, the server will not save the message, and the shared friends will not see the message
    如果消息一经主人拉取后，服务器不会保存消息，被分享的好友也看不到这些消息
```

## 12.4 Delete system messages in bulk / 批量删除系统消息 

```
【Description】/【描述】
    Delete system messages in bulk
    批量删除系统消息

【Function Call】【函数调用】
    // Delete system messages in bulk
    //批量删除系统消息
    @param msgIDs 多个消息ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)deleteSystemMessagesWithMsgIDs:(NSArray <NSNumber *>*)msgIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] deleteSystemMessagesWithMsgIDs:arr success:^{

    } failure:^(NSError *error) {

    }];
```

## 12.5 Delete multiple device alarm messages in batch / 批量删除多个设备报警消息 

```
【Description】/【描述】
   Delete multiple device alarm messages in batch
    批量删除多个设备报警消息

【Function Call】【函数调用】
    // Delete multiple device alarm messages in batch
    //批量删除多个设备报警消息
    @param deviceIDs Multiple device IDs(多个设备ID)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)deleteAlarmMessagesWithDeviceIDs:(NSArray <NSNumber *>*)deviceIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] deleteAlarmMessagesWithDeviceIDs:arr success:^{

    } failure:^(NSError *error) {

    }];
```

## 12.6 Mark single device messages all read / 标记单个设备消息全部已读 

```
【Description】/【描述】
    Mark single device messages all read
    标记单个设备消息全部已读

【Function Call】【函数调用】
    // Mark single device messages all read
    //标记单个设备消息全部已读
    @param deviceID 设备ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)markDeviceAlarmMessageWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    [[MeariUser sharedInstance] markDeviceAlarmMessageWithDeviceID:_deviceID success:^{

    } failure:^(NSError *error) {

    }];
```
## 12.7 Get share message list / 获取分享消息列表
```
【Description】/【描述】
return all share message (获取所有的分享消息)

【Function Call】【函数调用】
   /**
    获取分享消息列表
    Get list of shared messages
 
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)getShareMessageListSuccess:(MeariSuccess_MsgShareList)success failure:(MeariFailure)failure;


【Code Example】【代码范例】
[[MeariUser sharedInstance] getShareMessageListSuccess:^(NSArray<MeariMessageInfoShare *> *msgs) {

    } failure:^(NSError *error) {

    }];
```

## 12.8 delete share message / 获取分享消息列表
```
【Description】/【描述】
if the message has been dealed, use this function
if the message not be dealed, user "deleteSystemMessagesWithMsgIDs:success:failure" instead.

【Function Call】【函数调用】
    /**
    Delete shared message
    删除分享消息
 
    @param msgIDArray 消息ID列表
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    */
- (void)deleteShareRequestListWithMsgIDArray:(NSArray *)msgIDArray success:(MeariSuccess)success failure:(MeariFailure)failure;


【Code Example】【代码范例】
 [[MeariUser sharedInstance] deleteShareRequestListWithMsgIDArray:@[model.shareInfo.msgID] success:^{

        } failure:^(NSError *error) {

        }];

```

## 12.9 deal share request / 处理分享请求
```
【Description】/【描述】
 your can accpet or reject the share request (可以去接受和拒绝分享请求)

【Function Call】【函数调用】
    /**
    处理分享消息
    Handling shared messages
 
    @param msgID (message ID)消息ID
    @param accept whether to accept (是否接受)
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
     */
- (void)dealShareMsgWithMsgID:(NSString *)msgID accept:(BOOL)accept success:(MeariSuccess)success failure:(MeariFailure)failure;


【Code Example】【代码范例】
    [[MeariUser sharedInstance] dealShareMsgWithMsgID:model.shareInfo.msgID accept:accept success:^{

    } failure:^(NSError *error) {

    }];
```

## 12.10 Device message processing / 设备消息处理 

```
【Description】/【描述】
    设备消息处理-同意|拒绝

【Function Call】【函数调用】
    //同意分享设备
    Agree to share the device with friends
    
    @param deviceID 设备ID
    @param friendID 好友ID
    @param msgID 消息ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)agreeShareDeviceWithDeviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
    //拒绝分享设备
    Refuse to share device
    
    @param deviceID 设备ID
    @param friendID 好友ID
    @param msgID 消息ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
    - (void)refuseShareDeviceWithDeviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】【代码范例】
    //同意分享设备
    [[MeariUser sharedInstance] agreeShareDeviceWithDeviceID:model.info.deviceID.integerValue toFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{

    } failure:^(NSError *error) {

    }];
    
    //拒绝分享设备
    [[MeariUser sharedInstance] refuseShareDeviceWithDeviceID:model.info.deviceID.integerValue toFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{
    
    } failure:^(NSError *error) {
    
    }];
【注意事项】
    如果消息处理完，需要手动删除消息
```
## 12.11 Get the app's new message  / 获取app是否有新消息
```
【Description】/【描述】
// Get whether there are new messages in the app, including whether sharing and alarm messages exist, can't get system messages
// 获取app是否有新消息, 包括分享和报警消息是否存在, 不能获取是否存在系统消息
【Function Call】【函数调用】
	/**
	Get whether there is a message red dot (share message, alarm message)
	 获取是否有消息红点(分享消息, 报警消息)

    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)getMessageRedDotSuccess:(MeariSuccess_RedDot)success failure:(MeariFailure)failure;


【Code Example】【代码范例】
 [[MeariUser sharedInstance] getMessageRedDotSuccess:^(BOOL hasShare, BOOL hasAlarm) {
        xxx.shareMessageFlag = hasShare;
        xxx.alarmMessageFlag = hasAlarm;
        [self showRedRot];
  } failure:nil];

```

## 12.12 Get alarm message image address  / 获取报警消息图片地址
```
【Description】/【描述】
 // Get the alarm message picture address, Note: The valid period of the url is 1 hour, it will expire after one hour, please pay attention to save the original data of the picture
 // 获取报警消息图片地址, 注意: url的有效期为1个小时, 一个小时后失效,  请注意保存图片原数据 

【Function Call】【函数调用】
	/**
	 获取oss图片url地址

	 @param url  image url (图片url)
	 @param deviceID 设备ID
    @param success Successful callback (成功回调)
    @param failure failure callback (失败回调)
	 */
- (void)getOssImageUrlWithUrl:(NSString *)url deviceID:(NSInteger)deviceID success:(MeariSuccess_Str)success failure:(MeariFailure)failure;


【Code Example】【代码范例】
    [[MeariUser sharedInstance] getOssImageUrlWithUrl:model.msg.alarmImageUrl.absoluteString deviceID:[model.msg.deviceID integerValue] success:^(NSString *str) {
             
    } failure:^(NSError *error) {

    }];

```

## 12.13 Get alarm message image data  / 获取报警消息图片数据data
```
【Description】/【描述】
   // Obtain image source data, which can be saved locally, resources are always valid
   // 获取图片源数据, 可以保存之本地, 资源一直有效


【Function Call】【函数调用】
	/**
	 Get alarm message image data(获取oss图片url data)

	 @param url 图片url (image url)
	 @param deviceID 设备ID
	 @param success 成功回调
	 @param failure 失败回调
	 */
- (void)getOssImageDataWithUrl:(NSString *)url deviceID:(NSInteger)deviceID  success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;


【Code Example】【代码范例】

```
