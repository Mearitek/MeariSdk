
<h1><center> 目录 </center></h1>

[TOC]

<center>

---
| 版本号 | 制定团队 | 更新日期 | 备注 | 
| ------ | ------ | ------ | ------ |
| 2.0.1 | 觅睿技术团队 | 2019.06.25 | 优化

</center>

#1. 功能概述 

觅睿科技APP SDK提供了与硬件设备、觅睿云通讯的接口封装，加速应用开发过程，主要包括以下功能：

- 硬件设备相关 (配网、控制、状态上报、固件升级、预览回放等功能) 
- 账号体系 (手机号、邮箱的注册、登录、重置密码等通用账号功能) 
- 设备共享
- 好友管理
- 消息中心
- 觅睿云HTTPS API接口封装 (参见觅睿云api调用) 


#2. 集成准备

**准备App Key和App Secert**

觅睿科技云平台提供App ID和App Secert，用于用户接入SDK快速接入摄像机设备

#3. 集成SDK 

## 3.1 集成准备 

### (1) 引入sdk包 

```
将下载好的MeariKit.framework拖到工程中
```

### (2) 环境配置  

```
1. 将MeariKit.framework 添加到 target -> General -> Embedded Binaries
2. 禁用bitcode：在工程面板中，选中target -> Build Settings -> Build Options -> Enable Bitcode -> 设为 No
3. 添加支持c++的文件：将任意一个.m文件改为.mm文件，例如将AppDelegate.m 改为 AppDelegate.mm格式
```

## 3.2 集成SDK功能 

```
所属：MeariSdk工具类
```

### (1) Application中初始化sdk配置

```
【描述】
    主要用于初始化内部资源、通信服务等功能。
 
【函数调用】
    /**
    启动SDK

    @param appKey appKey
    @param secretKey secret
    */
    - (void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;
    
    /**
    设置调试打印级别
    
    @param logLevel 打印级别
    */
    - (void)setLogLevel:(MeariLogLevel)logLevel;
    
    
    /**
    配置服务器环境
    
    @param environment 预发或正式
    */
    - (void)configEnvironment:(MearEnvironment)environment;

【代码范例】
    //启动SDK
    [[MeariSDK sharedInstance] startWithAppKey:@"appKey" secretKey:@"secretKey"];
    
    //配置服务器环境：预发或正式，当前是开发版本，只支持预发环境上运行
    [[MeariSDK sharedInstance] configEnvironment:MearEnvironmentRelease];
    
    //设置调试log级别，会打印内部接口的输入输出信息，以便排查问题
    [[MeariSDK sharedInstance] setLogLevel:MeariLogLevelOff];
    
```


#4. 用户管理 

```
所属：MeariUser工具类
```
```
觅睿科技SDK提供两种用户管理体系：普通用户体系、UID用户体系

普通用户体系：账号登录、注册、修改密码、找回密码、获取验证码
UID用户体系：uid登录 (最长64位) ，无需注册没有密码系统，请妥善保管
```

##4.1 用户uid登录体系 

```
觅睿科技提供uid登陆体系。如果客户自有用户体系，那么可以通过uid登陆体系，接入我们的sdk。
```

### (1) 重定向 

```
【描述】
Meari SDK 支持全球服务，当选择不同的国家时需要重置访问地址，根据登录时传入国家代号，访问对应的服务器
【函数调用】
//切换账号、修改国家时调用
- (void)resetRedirect;    
```

### (2) 用户uid登录 

```
【描述】
用户uid注册，uid要求唯一。

【函数调用】
/**
通过Uid登录

@param uid 用户ID，需要保证唯一性，<=32位
@param countryCode 国家代号
@param phoneCode 国家区号
@param success 成功回调
@param failure 失败回调
*/
- (void)loginWithUid:(NSString *)uid countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode  success:(MeariSuccess)success  failure:(MeariFailure)failure

【代码范例】
//通过Uid登录
[[MeariUser sharedInstance] loginWithUid:@"abcdefghijklmn" countryCode:@"CN" phoneCode:@"86" success:^{

} failure:^(NSError *error) {

}];

```

### (3)  用户登出 

```
【描述】
登出同普通账号登出

【函数调用】
//登出账号
@param success 成功回调
@param failure 失败回调
- (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;


【代码范例】
//登出账号
[[MeariUser sharedInstance] logoutSuccess:^{

} failure:^(NSError *error) {

}];
```

## 4.2 普通用户体系管理 

### (1) 重定向 

```
【描述】
    Meari SDK 支持全球服务，当选择不同的国家时需要重置访问地址，根据登录时传入国家代号，访问对应的服务器
【函数调用】
    //切换账号、修改国家时调用
    - (void)resetRedirect;    
```
### (2) 注册账号 

```
【描述】
    注册账号前需要获取验证码
 
【函数调用】
    //获取验证码
    @param userAccount 用户账号：邮箱或手机
    @param countryCode 国家代号
    @param phoneCode 国家区号
    @param success 成功回调，返回验证码剩余有效时间，单位秒
    @param failure 失败回调
	- (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

    //注册账号
    @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区)
    @param password 用户密码
    @param countryCode 国家代号
    @param phoneCode 国家区号
    @param verificationCode 验证码
    @param nickname 用户昵称，登录后可修改
    @param success 成功回调
    @param failure 失败回调
    - (void)registerAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【代码范例】
    //获取账号的验证码
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //成功
    } failure:^(NSError *error) {
        //失败
    }];
    //注册账号
    [[MeariUser sharedInstance] registerAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" verificationCode:@"7234" nickname:@"coder man" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### (3) 账号登陆 

```
【描述】
    支持邮箱登录、手机(仅限中国大陆地区)登录
 
【函数调用】
    //登陆
    @param userAccount 用户账号：邮箱或手机
    @param password 用户密码
    @param countryCode 国家代号
    @param phoneCode 国家区号
    @param success 成功回调
    @param failure 失败回调
    - (void)loginAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【代码范例】
    [[MeariUser sharedInstance] loginAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### (4) 找回密码 

```
【描述】
    找回密码前需要先获取验证码
 
【函数调用】
    //获取验证码
    @param userAccount 用户账号：邮箱或手机
    @param countryCode 国家代号
    @param phoneCode 国家区号
    @param success 成功回调，返回验证码剩余有效时间，单位秒
    @param failure 失败回调
    - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

    //找回密码
    @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区)
    @param password 新的密码
    @param countryCode 国家代号
    @param phoneCode 国家区号
    @param verificationCode 验证码
    @param success 成功回调
    @param failure 失败回调
    - (void)findPasswordWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //获取账号的验证码
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //成功
    } failure:^(NSError *error) {
        //失败
    }];
    //找回密码
    [[MeariUser sharedInstance] findPasswordWithAccount:@"john@163.com" password:@"123123" countryCode:@"CN" phoneCode:@"86" verificationCode:@"6322" success:^{
    } failure:^(NSError *error) {
    
    }];
```


### (5) 修改密码 

```
【描述】
    登录后修改密码，修改密码前需要先获取验证码

【函数调用】
    //获取验证码
    @param userAccount 用户账号：邮箱或手机
    @param countryCode 国家代号
    @param phoneCode 国家区号
    @param success 成功回调，返回验证码剩余有效时间，单位秒
    @param failure 失败回调
    - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

    //修改密码
    @param userAccount 用户账号：邮箱或手机号(仅限中国大陆地区)
    @param password 用户密码
    @param verificationCode 验证码
    @param success 成功回调
    @param failure 势必啊回调
    - (void)changePasswordWithAccount:(NSString *)userAccount password:(NSString *)password verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //获取账号的验证码
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //成功
    } failure:^(NSError *error) {
        //失败
    }];
    //找回密码
    [[MeariUser sharedInstance] changePasswordWithAccount:@"john@163.com" password:@"234567" verificationCode:@"8902" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```


### (6) 注册消息推送 

```
【描述】
    注册Meari消息推送
    在登录、注册、找回密码后调用，如果接口返回错误，间隔一段时间重新注册推送

【函数调用】
    @param deviceToken 手机token 
    @param success 成功回调
    @param failure 失败回调
    - (void)registerPushWithDeviceToken:(NSData *)deviceToken success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
```

### (7) 用户登出 

```
【描述】
    登出，退出账号

【函数调用】
    //登出账号
    @param success 成功回调
    @param failure 失败回调
    - (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;


【代码范例】
    //登出账号
    [[MeariUser sharedInstance] logoutSuccess:^{
    
    } failure:^(NSError *error) {
    
    }];
```

##4.3 用户上传头像 

```
【描述】
    用户上传头像
 
【函数调用】
    /*
     @param image 图片
     @param success 成功回调，返回头像的url
     @param failure 失败回调
     */
    - (void)uploadUserAvatar:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;
        
【代码范例】
    [[MeariUser sharedInstance] uploadUserAvatar:[UIImage imageWithData:self.imageData] success:^(NSString *avatarUrl) {

    } failure:^(NSError *error) {
    
    }];
```
##4.4 修改昵称 

```
【描述】
    修改用户昵称。
 
【函数调用】
    /*
    @param name 新的昵称，长度6-20位
    @param success 成功回调
    @param failure 失败回调
     */
    - (void)renameNickname:(NSString *)name  success:(MeariSuccess)success failure:(MeariFailure)failure;
        
【代码范例】
    [[MeariUser sharedInstance] renameNickname:newName success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

##4.5 数据模型 

用户相关的数据模型。

```
【MeariUserInfo】
@property (nonatomic, strong) NSString * avatarUrl;     //用户头像
@property (nonatomic, strong) NSString * nickName;      //用户昵称
@property (nonatomic, strong) NSString * userAccount;   //用户账号
@property (nonatomic, strong) NSString * userID;        //用户ID
@property (nonatomic, strong) NSString * userToken;     //用户session
@property (nonatomic, strong) NSString * loginTime;     //用户登录时间
@property (nonatomic, strong) NSString * pushAlias;     //用户推送别名，用于极光推送 (废弃) 
@property (nonatomic, strong) NSString * token;         //用户有效标识
@property (nonatomic, strong) NSString * secrect;       //用户有效标识
@property (nonatomic, strong) NSString * userKey;       //用户key
@property (nonatomic, strong) NSString * userName;      //用户名称
@property (nonatomic, strong) NSString * countryCode;   //注册国家代号
@property (nonatomic, strong) NSString * phoneCode;     //注册国家手机代号
@property (nonatomic, assign) BOOL notificationSound;   //消息推送是否有声音
```

#5.设备消息通知 

```
及时消息通知是MeariSDK及时通知App端当前用户和用户账户下设备的一些状态，以方便App端实现更好的用户体验

【通知类型】参见：MeariUser.h
    MeariDeviceOnlineNotification  (设备上线) 
    MeariDeviceOfflineNotification  (设备离线) 
    MeariDeviceCancelSharedNotification  (设备主人取消了分享) 
    MeariDeviceHasVisitorNotification    (可视门铃设备有访客按门铃) 
    MeariDeviceVoiceBellHasVisitorNotification  (语音门铃设备有访客按门铃)  
    MeariDeviceUnbundlingNotification   (设备已被解绑)
    MeariUserLoginInvalidNotification    (登录信息失效，需要重新登录) 
【使用】
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginInvalidNotification:) name:MeariUserLoginInvalidNotification object:nil];
```

#6.设备配网

```
所属：MeariDevice工具类
```
```
觅睿科技硬件模块支持三种配网模式：SmartWifi配网、热点模式 (AP模式) 、二维码配网模式。
二维码和SmartWifi操作较为简便，建议在配网失败后，再使用热点模式作为备选方案。其中二维码配网成功率较高。
```
##6.1 smartwifi配网 

```
配网之前需要先获取Token，然后再调用配网接口
```

### (1) 获取Token 

```
【描述】
smart wifi配网需要提供所连wifi的名称和密码

【函数调用】
    /**
    获取配网token

    @param tokenType 不同配网模式对应不同的Token
    @param success 成功回调：
    token: 用于配网
    validTime: token有效时长，超过时长需要重新获取新的token
    @param failure 失败回调
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
【代码范例】
    [[MeariUser sharedInstance] getTokenForType:MeariDeviceTokenTypeSmartWifi success:^(NSString *token, NSInteger validTime) {
        //Don't care about validTime, because this type of Token is long-lived
    } failure:^(NSError *error) {

    }];
```
### (2) 开始SmartWifi配网 

```
【描述】
    smart wifi配网需要提供所连wifi的名称和密码
 
【函数调用】
	/**
	 开始 smartwifi 配网
	
	 @param wifiSSID wifi名称
	 @param wifiPwd wifi密码：没有密码，传nil
	 @param success 成功回调
	 @param failure 失败回调
	 */
	+ (void)startMonitorWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
        
【代码范例】
    [MeariDevice startMonitorWifiSSID:@"wifi name" wifiPwd:@"12345678" success:^{
        //成功的回调只会在停止的时候返回
    } failure:^(NSError *error){
        //异常的回调会直接返回
    }];
```
### (3) 停止SmartWifi配网 

```
    /**
    停止 smartwifi 配网
    */
    + (void)stopMonitor;
```

##6.2 热点模式 (AP配网) 

```
配网之前需要先获取Token，然后再调用配网接口
```
### (1) 获取Token 

```
【描述】
    获取AP配网所需要的Token

【函数调用】
    /**
    获取配网token

    @param tokenType 不同配网模式对应不同的Token
    @param success 成功回调：
    token: 用于配网
    validTime: token有效时长，超过时长需要重新获取新的token
    @param failure 失败回调
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
    
【代码范例】
    [[MeariUser sharedInstance] getTokenForType:MeariDeviceTokenTypeAP success:^(NSString *token, NSInteger validTime) {
        //不用关心validTime，这种模式下Token一直有效
    } failure:^(NSError *error) {

    }];
```
### (2) AP配网 

```
【描述】
    ap配网需要提供所连wifi的名称和密码，且配网前需连接到设备的热点,(设备热点名称为:`STRN`加`下划线`加`sn号`如：STRN_056566188)
 
【函数调用】
	
	/**
	 开始 ap 配网
	
	 @param wifiSSID wifi名称
	 @param wifiPwd wifi密码
	 @param success 成功回调
	 @param failure 失败回调
	 */
	+ (void)startAPConfigureWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

        
【代码范例】
	//开始smartwifi配网
	[MeariDevice startAPConfigureWifiSSID:@"wifi name" wifiPwd:@"12345678" success:^{

    } failure:^(NSString *error) {
    
    }];
    
```

##6.3 二维码配网 

```
配网之前需要先获取Token，然后再调用配网接口
```
### (1) 获取Token 

```
【描述】
    获取AP配网所需要的Token，注意此Token有过期时间

【函数调用】
    /**
    获取配网token

    @param tokenType 不同配网模式对应不同的Token
    @param success 成功回调：
    token: 用于配网
    validTime: token有效时长，超过时长需要重新获取新的token
    @param failure 失败回调
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getTokenForType:MeariDeviceTokenTypeQRCode success:^(NSString *token, NSInteger validTime) {
        //validTime为超时时间，超时的Token不能用于二维码配网，需要重新获取Token
    } failure:^(NSError *error) {

    }];
```
### (2) 二维码配网 

```
【描述】
	将获取到的token和手机所在的WiFi和密码生成二维码图片，二维码图片推荐：284px的正方形图片
 
【函数调用】
	/**
	 生成二维码
	
	 @param ssid wifi名称
	 @param password wifi密码
	 @param token 二维码token
	 @param size 二维码大小
	 @return 二维码图片
	 */
	- (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;
        
【代码范例】
	
    //生成二维码
    UIImage *image = [[MeariUser sharedInstance] createQRWithSSID:@"wifi name" pasword:@"123456" token:token size:CGSizeMake(100, 100)];
```


##6.4 搜索设备 

```
搜索时机：设备配网成功后，会蓝灯常亮，此时即可搜索到设备
搜索机制：搜索接口没有超时机制，直到调用停止接口，才会停止搜索
搜索模式：局域网搜索和云搜索
```

### (1) smartwifi配网和ap配网搜索设备 

```
【描述】
	IPC设备：设备配网成功蓝灯常亮后，才能搜索到设备，用于展示给用户进行添加操作
    NVR设备：被添加的NVR需要与手机在同一个网络下，才可以被搜索到
 
【函数调用】
	
	/**
	 开始搜索：适用于smartwifi配网和ap配网
	
	 @param success 成功回调：返回搜索到的设备
	 @param failure 失败回调
	 */
	+ (void)startSearch:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【代码范例】
	//开始搜索：适用于smartwifi配网和ap配网
	 [MeariDevice startSearch:^(MeariDevice *device) {
        
    } failure:^(NSString *error) {
        
    }];
```
### (2) 二维码配网搜索设备 

```
【方法一：】

【描述】
    设备配网成功蓝灯常亮后，才能搜索到设备，用于展示给用户进行添加操作
    
    注意：搜索的Token需要与二维码配网获取Token保持一致，否则会搜索不到设备
    
【函数调用】
    /**
    开始搜索：仅适用于二维码配网

    @param token 二维码token 
    @param success 成功回调：返回搜索到的设备
    @param failure 失败回调
    */
    + (void)startSearchWithQRcodeToken:(NSString *)token success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【方法二：】
    
【描述】
    设备配网成功蓝灯常亮后，才能搜索到设备，用于展示给用户进行添加操作

    注意：搜索前需要先更新下Token,搜索的Token需要与二维码配网获取Token保持一致，否则会搜索不到设备

【函数调用】
    /**
    更新Token

    @param token 配网方式的token
    @param type  配网方式
    */
    + (void)updatetoken:(NSString *)token type:(MeariDeviceTokenType)type;
    
    /**
    开始搜索：搜索通用接口
    在使用此接口时要确保调用了updatetoken方法
    @param mode 配网方式
    @param success 成功回调：返回搜索到的设备
    @param failure 失败回调
    */
    + (void)startSearch:(MeariDeviceSearchMode)mode success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;
    
【代码范例】
    [MeariDevice updatetoken:self.token type:MeariDeviceTokenTypeQRCode];
    [MeariDevice startSearch:MeariSearchModeCloud_QRCode success:^(MeariDevice *device) {
   
    } failure:^(NSError *error) {
    
    }];
```
### (3)  设备添加 

#### <1> 添加摄像机

```
【描述】
    搜索到设备后，先进行查询设备状态查询，在没有被人添加的情况下，才可以进行添加设备操作

【适用】
	Type:
		MeariDeviceTypeIpc
	subType:
   		All

【函数调用】
    //查询设备状态
    @param type 设备类型
    @param devices 要查询的设备：需使用调用设备接口，搜索出来的设备
    @param success 成功回调：返回设备列表
    @param failure 失败回调
    - (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

    //添加设备
    @param type 设备类型
    @param uuid 设备uuid
    @param sn 设备sn
    @param tp 设备tp
    @param success 成功回调
    @param failure 失败回调
    - (void)addDeviceWithDeviceType:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //查询摄像机
    [[MeariUser sharedInstance] checkDeviceStatusWithDeviceType:MeariDeviceTypeIpc devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

    //添加摄像机
    [[MeariUser sharedInstance] addDeviceWithDeviceType:MeariDeviceTypeIpc uuid:device.info.uuid sn:device.info.sn tp:device.info.tp success:^{

    } failure:^(NSError *error) {

    }];

```
#### <2> 添加网络存储器  

```
【描述】
    搜索到NVR设备后，先进行查询设备状态查询，在没有被人添加的情况下，才可以进行添加设备操作
    
【适用】
	Type:
		MeariDeviceTypeNVR
		
【函数调用】
    //查询设备状态
    @param type 设备类型
    @param devices 要查询的设备：需使用调用设备接口，搜索出来的设备
    @param success 成功回调：返回设备列表
    @param failure 失败回调
    - (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

    //添加设备
    @param type 设备类型
    @param uuid 设备uuid
    @param sn 设备sn
    @param tp 设备tp
    @param success 成功回调
    @param failure 失败回调
    - (void)addDeviceWithDeviceType:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //查询nvr
    [[MeariUser sharedInstance] checkDeviceStatusWithDeviceType:MeariDeviceTypeNvr devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

    //添加nvr
    [[MeariUser sharedInstance] addDeviceWithDeviceType:MeariDeviceTypeNvr uuid:device.info.uuid sn:device.info.sn tp:device.info.tp success:^{

    } failure:^(NSError *error) {

    }];

```
### (4) 停止搜索 

```
【描述】
    结束添加时，如果有开启搜索，需要停止搜索操作
【函数调用】
    /**
    停止搜索
    */
    + (void)stopSearch;
【代码范例】
    [MeariDevice stopSearch];
    [[MeariUser sharedInstance] cancelAllRequest];
```
#7 NVR绑定设备 

##7.1 搜索设备 

```
【描述】
    设备蓝灯常亮才能被搜索到，用于展示给用户进行绑定NVR，MeariDevice->hasBindedNvr 用于判断是否已经绑定了NVR

【函数调用】
    /**
    开始搜索：搜索当前网络下的设备

    @param success 成功回调：返回搜索到的设备
    @param failure 失败回调
    */
    + (void)startSearch:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //开始搜索：适用于smartwifi配网和ap配网
    [MeariDevice startSearch:^(MeariDevice *device) {

    } failure:^(NSString *error) {

    }];
```
##7.2 绑定设备 

```
【描述】
    NVR绑定设备后，设备的录像文件会存储在NVR中

【函数调用】
    @param deviceID 设备ID
    @param nvrID nvr ID
    @param success 成功回调
    @param failure 失败回调
    - (void)bindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] bindDevice:model.device.info.ID toNVR:self.nvr.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```
##7.3 结束绑定设备 

```
【描述】
    结束绑定时，如果有开启搜索，需要停止搜索操作
【函数调用】
    /**
    停止搜索
    */
    + (void)stopSearch;
【代码范例】
    [MeariDevice stopSearch];
    [[MeariUser sharedInstance] cancelAllRequest];
```
##7.4 获取NVR绑定的设备 

```
【描述】
    用于查看NVR绑定了哪些设备

【函数调用】
    @param nvrID nvr ID
    @param success 成功回调：返回绑定的设备列表和未绑定的设备列表
    @param failure 失败回调
    - (void)getBindDeviceList:(NSInteger)nvrID success:(MeariSuccess_DeviceListForNVR)success failure:(MeariFailure)failure;

【代码范例】
    //查询绑定的设备列表
    [[MeariUser sharedInstance] getBindDeviceList:self.nvr.info.ID success:^(NSArray<MeariDevice *> *bindedDevices, NSArray<MeariDevice *> *unbindedDevices) {

    } failure:^(NSError *error) {

    }];
```
##7.5 从NVR解绑设备 

```
【描述】
    从NVR绑定设备后，设备的录像文件将不会继续存储在NVR中

【函数调用】
    @param deviceID 设备ID
    @param nvrID nvr ID
    @param success 成功回调
    @param failure 失败回调
    - (void)unbindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【代码范例】
    @param deviceIDs 多个设备ID
    @param nvrID nvr ID
    @param success 成功回调
    @param failure 失败回调
    [[MeariUser sharedInstance] unbindDevices:arr toNVR:self.nvr.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```
#8.设备信息获取
```
所属：MeariUser
```
##8.1 获取设备列类 
```
所属：MeariDeviceList
```
```
【描述】
    设备添加后，通过MeariUser工具类的接口获取设备列表，以模型形式返回
设备信息为设备对象的info属性 (MeariDeviceInfo) 

【函数调用】
    //获取所有设备列表
    - (void)getDeviceList:(MeariSuccess_DeviceList)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getDeviceList:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];
```

MeariDeviceList属性：

```
 /** 摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;
/** 智能门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** 语音门铃 */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** 电池摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** 灯具摄像机 */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** 网络存储器 */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;
```
##8.2 设备信息 

```
所属：MeariDevice
```
```
@property (nonatomic, strong) MeariDeviceInfo *info;                        //设备信息
@property (nonatomic, strong) MeariDeviceParam *param;                      //设备参数
@property (nonatomic, assign, readonly, getter=isIpcCommon)BOOL ipcCommon;  //是否是普通摄像机
@property (nonatomic, assign, readonly, getter=isIpcBaby)BOOL ipcBaby;      //是否是音乐摄像机
@property (nonatomic, assign, readonly, getter=isIpcBell)BOOL ipcBell;      //是否是门铃摄像机
@property (nonatomic, assign, readonly, getter=isNvr)BOOL nvr;              //是否是盒子
@property (nonatomic, assign)BOOL hasBindedNvr;                             //是否绑定
@property (nonatomic, assign, readonly)BOOL sdkLogined;                     //是否已登录
@property (nonatomic, assign, readonly)BOOL sdkLogining;                    //是否正在登录
@property (nonatomic, assign, readonly)BOOL sdkPlaying;                     //是否正在预览
@property (nonatomic, assign, readonly)BOOL sdkPlayRecord;                  //是否正在回放
@property (nonatomic, strong)NSDateComponents *playbackTime;                //当前回放时间
@property (nonatomic, assign, readonly)BOOL supportFullDuplex;              //是否支持双向语音对讲
@property (nonatomic, assign, readonly)BOOL supportVoiceTalk;               //是否支持语音对讲
。。。
```
##8.3 删除设备 

```
【描述】
    设备移除

【函数调用】
    //移除设备
    @param type 设备类型
    @param deviceID 设备ID
    @param success 成功回调
    @param failure 失败回调
    - (void)deleteDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] deleteDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:cell.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```

##8.4 设备昵称修改 

```
【描述】
    设备昵称修改

【函数调用】
    @param type 设备类型
    @param deviceID 设备ID
    @param nickname 新的昵称，长度6-20位
    @param success 成功回调
    @param failure 失败回调
    - (void)renameDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //修改IPC设备昵称
    [[MeariUser sharedInstance] renameDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.camera.info.ID nickname:newNickName success:^{
    
    } failure:^(NSError *error) {
    
    }];
    
    //修改NVR设备昵称
    [[MeariUser sharedInstance] renameDeviceWithDeviceType:MeariDeviceTypeNVR deviceID:self.nvr.info.ID nickname:newNickName success:^{

    } failure:^(NSError *error) {

    }];
```

##8.5 单个设备某天报警时间点获取 

```
【描述】
    单个设备某天报警时间点获取

【函数调用】
    //单个设备某天报警时间点获取
    @param deviceID 设备ID
    @param date 日期：格式为20171212
    @param success 成功回调：返回报警时刻列表
    @param failure 失败回调
    - (void)getAlarmMessageTimes:(NSInteger)deviceID onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getAlarmMessageTimes:self.device.info.ID onDate:@"20171212" success:^(NSArray<NSString *> *time) {

    } failure:^(NSError *error) {

    }];
```

##8.6 查询设备是否有新版本 

```
【描述】
    查询设备是否有新版本

【函数调用】
    //查询设备是否有新版本
    @param currentFirmware 当前版本
    @param success 成功回调:返回设备最新版本信息
    @param failure 失败回调
    - (void)checkNewFirmwareWithCurrentFirmware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirmware:self.currentVersion success:^(MeariDeviceFirmwareInfo *info) {
    
    } failure:^(NSError *error) {
    
    }];
```

MeariDeviceFirmwareInfo:

```
@property (nonatomic, copy) NSString *upgradeUrl;           //设备升级地址
@property (nonatomic, copy) NSString *latestVersion;        //设备最新版本
@property (nonatomic, copy) NSString *upgradeDescription;   //设备升级描述
@property (nonatomic, assign) BOOL needUpgrade;             //是否需要升级
```

##8.7 查询设备在线状态 

```
【描述】
    查询设备是否有新版本

【函数调用】
    //查询设备是否有新版本
    @param deviceID 设备ID
    @param success 成功回调：返回设备是否在线
    @param failure 失败回调
    - (void)checkDeviceOnlineStatus:(NSInteger)deviceID success:(MeariSuccess_DeviceOnlineStatus)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] checkDeviceOnlineStatus:self.device.info.ID success:^(BOOL online) {

    } failure:^(NSError *error) {

    }];
```

##8.8 查询音乐列表 

```
【描述】
    查询音乐列表

【函数调用】
    //查询音乐列表
    @param success 成功回调：返回音乐列表
    @param failure 失败回调
    - (void)getMusicList:(MeariSuccess_Music)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getMusicList:^(NSArray<MeariMusicInfo *> *musicList) {

    } failure:^(NSError *error) {

    }];
```
```
MeariMusicInfo:
@property (nonatomic, strong) NSString * musicFormat;   //音乐格式
@property (nonatomic, strong) NSString * musicID;       //音乐ID
@property (nonatomic, strong) NSString * musicName;     //音乐名字
@property (nonatomic, strong) NSString * musicUrl;      //音乐地址
```

##8.9 生成配网二维码 

```
【描述】
    生成配网二维码

【函数调用】
    //获取二维码token
    /**
    获取配网token
    
    @param tokenType 不同配网模式对应不同的Token
    @param success 成功回调：
    token: 用于配网
    validTime: token有效时长，超过时长需要重新获取新的token
    @param failure 失败回调
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
    //生成配网二维码
    @param ssid wifi名称
    @param password wifi密码
    @param token 二维码token
    @param size 二维码大小
    @return 二维码图片
    - (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;

【代码范例】
    //获取二维码token
    [[MeariUser sharedInstance] getTokenForQrcode:^(NSString *token) {

    } failure:^(NSError *error) {

    }];
    
    //生成配网二维码
   UIImage *image = [[MeariUser sharedInstance] createQRWithSSID:weakSelf.wifi.ssid pasword:weakSelf.wifi.password token:obj size:CGSizeMake(WY_ScreenWidth, WY_ScreenHeight)];
```

##8.10 远程唤醒门铃 

```
【描述】
    远程唤醒门铃

【函数调用】
    //远程唤醒门铃
    @param deviceID 设备ID
    @param success 成功回调
    @param failure 失败回调
    - (void)remoteWakeUp:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] remoteWakeUp:self.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
【注意事项】
    门铃类低功耗产品，需要先调用远程唤醒接口，再调用打洞的接口
```

##8.11 上传门铃留言 

```
【描述】
上传门铃留言

【函数调用】
    /**
    上传留言

    @param deviceID 设备ID
    @param file 留言文件路径
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)uploadVoice:(NSInteger)deviceID voiceFile:(NSString *)file success:(MeariSuccess_DeviceVoiceUrl)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] uploadVoice:self.camera.info.ID voiceFile:_filePath success:^(NSString *voiceUrl) {
    
    } failure:^(NSError *error) {
    
    }];
```

##8.12 下载门铃留言 

```
【描述】
下载门铃留言

【函数调用】
    /**
    下载留言

    @param voiceUrl 留言地址
    @param success 成功回调，返回值：音频数据
    @param failure 失败回调
    */
    - (void)downloadVoice:(NSString *)voiceUrl success:(MeariSuccess_DeviceVoiceData)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] downloadVoice:urlStr success:^(NSData *data) {

    } failure:^(NSError *error) {
    
    }];
```

##8.13 删除门铃留言 

```
【描述】
删除门铃留言

【函数调用】
    /**
    删除留言

    @param deviceID 设备ID
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)deleteVoice:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] deleteVoice:self.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```

#9.设备控制
```
所属：MeariDevice
```
```
MeariDevice 负责对设备的所有操作，包括预览、回放、设置等，对设备的设置，需要确保已经与设备建立好了连接
```
##9.1 连接设备 

```
【描述】
    对设备进行预览、回放、设置等操作之前，需先连接上设备

【函数调用】
    /**
    开始连接设备

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)startConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    [self.device startConnectSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 9.2 断开设备 

```
【描述】
    当不需要对设备进行操作时，需要断开设备

【函数调用】
    /**
    断开设备

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)stopConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    [self.device stopConnectSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 9.3 获取码率 

```
【描述】
    当不需要对设备进行操作时，需要断开设备

【函数调用】
    /**
    获取码率

    @return 码率
    */
    - (NSString *)getBitrates;

【代码范例】
    [self.device getBitrates]
```


## 9.4 预览 

```
【描述】
    对摄像机取实时流播放，支持高清/标清切换

【函数调用】
    /**
    开始预览设备

    @param playView 播放视图控件
    @param HD 是否高清播放
    @param success 成功回调
    @param failure 失败回调
    @param close 处于休眠模式，镜头关闭，返回值：休眠模式
    */
    - (void)startPreviewWithView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(void(^)(BOOL isPlaying))failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;


    /**
    停止预览设备

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)stopPreviewSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    切换高清标清

    @param playView 播放视图
    @param HD 是否高清播放
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)switchPreviewWithView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //创建一个MeariPlayView
    MeariPlayView *playView = [[MeariPlayView alloc] initWithFrame:CGRectMake(0, 0,160, 90];

    //开始预览设备
    [self.camera startPreviewWithView:playView streamid:YES success:^{

    } failure:^(BOOL isPlaying) {

    } close:^(MeariDeviceSleepmode sleepmodeType) {

    }];

    //停止预览设备
    [self.camera stopPreviewSuccess:^{

    } failure:^(NSString *error) {

    }];

    //切换高清标清
    [self.camera switchPreviewWithView:self.drawableView streamid:HD success:^{

    } failure:^(NSString *error) {

    }];
```


## 9.5 回放 

```
【描述】
    对摄像机的录像进行回放
    注意：SDK不对播放的时间做校验，所以即使传入一个没有报警的时间点，接口也会返回成功，所以上层需要自行判断

【函数调用】
    /**
    获取某月的视频天数

    @param year 年
    @param month 月
    @param success 成功回调，返回值：json数组--[{"date" = "20171228"},...]
    @param failure 失败回调
    */
    - (void)getPlaybackVideoDaysWithYear:(NSInteger)year month:(NSInteger)month success:(MeariDeviceSucess_Days)success failure:(MeariDeviceFailure)failure;


    /**
    获取某天的视频片段

    @param year 年
    @param month 月
    @param day 日
    @param success 成功回调：返回值：json数组--[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
    @param failure 失败回调
    */
    - (void)getPlaybackVideoTimesWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MeariDeviceSucess_Times)success failure:(MeariDeviceFailure)failure;

    /**
    开始回放录像：同一个设备同一时间只能一个人查看回放录像

    @param playView 播放视图
    @param startTime 开始时间:格式为20171228102035
    @param success 成功回调
    @param failure 失败回调
    @param otherPlaying 其他人在查看回放
    */
    - (void)startPlackbackWithView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSucess)success failure:(void(^)(BOOL isPlaying))failure otherPlaying:(MeariDeviceSucess)otherPlaying;


    /**
    停止回放

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)stopPlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    从某时间开始播放：开始回放成功后才能使用此接口，否则会失败

    @param seekTime 开始时间:格式为20171228102035
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)seekPlackbackSDCardToTime:(NSString *)seekTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    暂停回放

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)pausePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    继续回放

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)resumePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //获取视频天数
    [self.device getPlaybackVideoDaysWithYear:year month:month success:^(NSArray *days) {

    } failure:^(NSString *error) {

    }];

    //获取某天视频时长
    [self.device getPlaybackVideoTimesWithYear:year month:month day:day success:^(NSArray *times) {

    } failure:^(NSString *error) {

    }];


    //开始回放录像
    [self.device startPlackbackWithView:playview startTime:starttime success:^{

    } failure:^(BOOL isPlaying) {

    } otherPlaying:^{

    }];

    //停止回放
    [self.device stopPlackbackSDCardSuccess:^{
    WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
    WYDo_Block_Safe_Main(success)
    }];

    //seek回放
    [self.device seekPlackbackSDCardToTime:self.currentComponents.timeStringWithNoSprit success:^{

    } failure:^(NSString *error) {

    }];

    //暂停回放
    [self.device pausePlackbackSDCardSuccess:^{

    } failure:^(NSString *error) {

    }];

    //继续回放
    [self.device resumePlackbackSDCardSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 9.6 静音 

```
【描述】
    设置静音

【函数调用】
    /**
    设置静音

    @param muted 是否静音
    */
    - (void)setMute:(BOOL)muted;

【代码范例】

    //设置静音
    [self.device setMute:muted];

```

## 9.7 语音对讲 

### (1) 单向对讲 

```
【描述】
    单向对讲是手机与设备不能同时讲话，手机端开始对讲调用startVoicetalk，讲话结束需要调用停止对讲stopVoicetalkSuccess，否则设备端讲话手机端无法接收到
    
【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcFloodlight = 6,

【函数调用】

	/**
    设置语音对讲类型

    @param type 语音对讲类型
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    获取语音对讲的实时音量

    @return 0-1.0
    */
    - (CGFloat)getVoicetalkVolume;

    /**
    开始语音对讲

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    停止语音对讲

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

	 //设置语音对讲类型
    [self.camera setVoiceTalkType:MeariVoiceTalkTypeOneWay];

    //获取语音对讲的实时音量
    [self.camera getVoicetalkVolume]


    //开始语音对讲
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

    //停止语音对讲
    [self.camera stopVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

```
### (2) 双向对讲 

```
【描述】
    双向对讲是手机与设备**可以**同时讲话，手机端开始对讲调用startVoicetalk，不调用stopVoicetalkSuccess，不会影响设备端传来声音
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,

【函数调用】

	/**
    设置语音对讲类型

    @param type 语音对讲类型
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    开始语音对讲

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    停止语音对讲

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

	 //设置语音对讲类型
    [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];

 
    //开始语音对讲
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

    //停止语音对讲
    [self.camera stopVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

```

### (3) 语音门铃对讲  

```
【描述】
    语音门铃对讲有别于其他对讲方式，支持双向对讲，如果手机端需要将麦克关闭，可以调用暂停接口，当需要重新打开麦克时需要重置对讲操作
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcVoiceBell = 5,

【函数调用】
	/**
    设置语音对讲类型

    @param type 语音对讲类型
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    开始语音对讲

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

	/**
	 关闭手机端麦克
	 
	 @param success 成功回调
	 @param failure 成功回调
	 */
	- (void)pauseVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
	 开启手机端麦克
	 
	 @param success 成功回调
	 @param failure 成功回调
	 */
	- (void)resumeVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

	 //设置语音对讲类型
    [self.camera setVoiceTalkType: MeariVoiceTalkTypeFullDuplex];

    //开始语音对讲
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];
	
	//关闭手机端麦克
	[self.camera pauseVoicetalkSuccess:^{
	
	} failure:^(NSError *error) {
	
	};
	
    //开启手机端麦克
	[self.camera resumeVoicetalkSuccess:^{
	
	} failure:^(NSError *error) {
	
	};

```

## 9.8 截图 

```
【描述】
    截取视频图片

【函数调用】

    /**
    截图

    @param path 图片保存的路径
    @param isPreviewing 是否正在预览
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)snapshotToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

    //截图
    [self.camera snapshotToPath:snapShotPath isPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

```


## 9.9 录像 

```
【描述】
    对视频录像

【函数调用】
    /**
    开始录像

    @param path 录像保存的路径
    @param isPreviewing 是否正在预览
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)startRecordMP4ToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    停止录像

    @param isPreviewing 是否正在预览
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)stopRecordMP4IsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

    //开始录像
    [self.camera startRecordMP4ToPath:path isPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

    //停止录像
    [self.nvr stopRecordMP4IsPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

```


## 9.10 云台控制 

```
【描述】
    转动摄像机

【函数调用】

/**
    开始转动摄像机

    @param direction 转动方向
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)startMoveToDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    停止转动摄像机

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)stopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

    //开始转动
    [self.camera startMoveToDirection:MeariMoveDirectionUp success:^{

    } failure:^(NSString *error) {

    }];

    //停止转动
    [self.camera stopMoveSuccess:^{

    } failure:^(NSString *error) {

    }];

```


## 9.11 镜像 

```
【描述】
    镜像状态的获取与设置

【函数调用】

    /**
    获取镜像状态

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)getMirrorSuccesss:(MeariDeviceSucess_Mirror)success failure:(MeariDeviceFailure)failure;


    /**
    设置镜像

    @param open 是否打开镜像
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setMirrorOpen:(BOOL)open successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

    //开始转动
    [self.camera startMoveToDirection:MeariMoveDirectionUp success:^{

    } failure:^(NSString *error) {

    }];

    //停止转动
    [self.camera stopMoveSuccess:^{

    } failure:^(NSString *error) {

    }];

```


## 9.12 移动侦测报警 

```
【描述】
    报警信息的获取与设置

【函数调用】

    /**
    获取报警信息

    @param success 成功回调，返回值：报警参数信息
    @param failure 失败回调
    */
    - (void)getAlarmSuccesss:(MeariDeviceSucess_Motion)success failure:(MeariDeviceFailure)failure


    /**
    设置报警级别

    @param level 报警级别
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setAlarmLevel:(MeariDeviceLevel)level successs:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

【代码范例】

    //获取报警信息
    [self.camera getAlarmSuccesss:^(MeariDeviceParamMotion *motion) {

    } failure:^(NSString *error) {

    }];

    //设置报警级别
    [self.camera setAlarmLevel:level successs:^(id obj) {

    } failure:^(NSString *error) {

    }];

```


## 9.13 存储 (SD卡) 

```
【描述】
    存储的信息获取与格式化

【函数调用】
    /**
    获取存储信息

    @param success 成功回调，返回存储信息
    @param failure 失败回调
    */
    - (void)getStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;


    /**
    获取内存卡格式化百分比

    @param success 成功回调,返回格式化百分比
    @param failure 失败回调
    */
    - (void)getFormatPercentSuccesss:(MeariDeviceSucess_StoragePercent)success failure:(MeariDeviceFailure)failure;

    /**
    格式化内存卡

    @param success 成功回调
    @param failure 失败回道
    */
    - (void)formatSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】

    //获取存储信息
    [self.device getStorageInfoSuccess:^(MeariDeviceParamStorage *storage) {

    } failure:^(NSString *error) {

    }];

    //获取格式化百分比
    [self.device getFormatPercentSuccesss:^(NSInteger percent) {

    } failure:^(NSString *error) {

    }];

    //格式化内存卡
    [self.device formatSuccesss:^{

    } failure:^(NSString *error) {

    }];

```

## 9.14 固件升级 

### (1) 在线升级 

```
【描述】
    固件的信息获取与升级，点升级设备会立即进行升级操作，
    注意：需要在设备在线并建立连接成功后才能操作
    
【适用】
	subType:
    MeariDeviceSubTypeIpcCommon = 1,
    MeariDeviceSubTypeIpcBaby = 2,
    MeariDeviceSubTypeIpcBell = 3,
    MeariDeviceSubTypeIpcBattery = 4,
    MeariDeviceSubTypeIpcFloodlight = 6,

【函数调用】

    /**
    获取固件版本

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)getVersionSuccesss:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;


    /**
    获取固件升级百分比

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)getUpgradePercentSuccesss:(MeariDeviceSucess_VersionPercent)success failure:(MeariDeviceFailure)failure;


    /**
    升级固件

    @param url 固件包地址
    @param currentVersion 固件当前版本号
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)upgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【代码范例】

    //获取固件版本
    [self getVersionSuccesss:^(id obj) {

    } failure:^(NSError *error) {

    }];

    //获取固件升级百分比
    [self.camera getUpgradePercentSuccesss:^(NSInteger percent) {

    } failure:^(NSError *error) {

    }];

    //升级固件
    [weakSelf.camera upgradeWithUrl:weakSelf.devUrl currentVersion:weakSelf.currentVersion successs:^{

    } failure:^(NSError *error) {

    }];

```
### (2) 计划升级 

```
【描述】
    固件的信息获取与升级，点升级设备不会立即进行升级操作，需要等设备启动后才会执行升级计划
    注意：设备不在线也可进行升级操作
    
【适用】
	subType: 
	MeariDeviceSubTypeIpcVoiceBell = 5,

【函数调用】
	1、先获取设备版本信息
    /**
	 获取版本信息：param.voiceBell.deviceVersion
	
	 @param success 成功回调，返回值：设备参数信息
	 @param failure 失败回调
	 */
	- (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;
    
   2、检查是否需要升级
   [MeariUser:checkNewFirmwareWithCurrentFirmware](#8.6 查询设备是否有新版本)
	
	3、执行升级操作
	/**
	 升级固件
	 
	 @param url 固件包地址
	 @param latestVersion 最新固件版本号
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)upgradeVoiceBellWithUrl:(NSString *)url latestVersion:(NSString *)latestVersion successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;


【代码范例】

    [self.device getParamsSuccesss:^(MeariDeviceParam *param) {
       weakSelf.deviceUrl = param.voiceBell.deviceVersion;
		[[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirmware:weakSelf.deviceUrl success:^(MeariDeviceFirmwareInfo *info) {
			[weakSelf.device upgradeVoiceBellWithUrl:info.upgradeUrl latestVersion:info.latestVersion successs:^{
				NSLog(@"升级语音门铃成功");
			} failure:^(NSError *error) {
				NSLog(@"升级语音门铃失败%@",error);
			}];
		} failure:^(NSError *error) {
                
		}];
	} failure:^(NSError *error) {
	          
	}];

```


## 9.15 获取参数信息 

```
【描述】
    获取设备的所有参数信息，对设备设置的功能参数，可以通过此接口获取，在设备调用成功的

【函数调用】
    /**
    获取所有参数

    @param success 成功回调，返回值：设备参数信息
    @param failure 失败回调
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

【代码范例】
    [self.camera getParamsSuccesss:^(WYCameraParams *params) {

    } failure:^(NSString *error) {

    }];
```


## 9.16 休眠模式 

```
【描述】
    设置不同的模式控制设备镜头，
    MeariDeviceSleepmodeLensOn ： 镜头打开
    MeariDeviceSleepmodeLensOff ： 镜头永久关闭
    MeariDeviceSleepmodeLensOffByTime ： 镜头按时间段关闭
    MeariDeviceSleepmodeLensOffByGeographic ： 镜头根据地理位置关闭

【函数调用】
    /**
    设置休眠模式

    @param type 休眠模式
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setSleepmodeType:(MeariDeviceSleepmode)type successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    设置休眠时间段

    @param open 是否开启休眠模式
    @param times 休眠时间段
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setSleepmodeTime:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
	 设置地理围栏
	
	 @param ssid wifi的SSID
	 @param bssid wifi的BSSID
	 @param deviceID 设备ID
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)settingGeographyWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //设置休眠模式
    [self.camera setSleepmodeType:model.type successs:^{

    } failure:^(NSError *error) {

    }];

    //设置休眠时间段
    [self.camera setSleepmodeTime:open times:timesArr successs:^{

    }failure:^(NSError *error) {

    }];
    
    //设置WiFi信息
	[[MeariUser sharedInstance] settingGeographyWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:^(NSString *str){
	
	} failure:^(NSError *error){

	}];
    
```


## 9.17 温湿度 

```
【描述】
    获取设备的所有参数信息

【函数调用】

    /**
    获取温湿度

    @param success 成功回调，返回值：温度和湿度
    @param failure 失败回调
    */
    - (void)getTemperatureHumiditySuccesss:(MeariDeviceSucess_TRH)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //设置休眠模式
    [self.camera getTemperatureHumiditySuccesss:^(CGFloat temperature, CGFloat humidty) {

    } failure:^(NSError *error) {
        if (error.code == MeariDeviceCodeNoTemperatureAndHumiditySensor) {
        //没有温湿度传感器
        }else {

        }
    }];
```


## 9.18 音乐 

```
【描述】
    获取设备音乐状态，控制设备播放音乐，需要有内存卡才能播放

【函数调用】

    /**
    播放音乐

    @param musicID 音乐ID
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)playMusic:(NSString *)musicID successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    暂停播放音乐

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)pauseMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    继续播放音乐

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)resumeMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    播放下一首

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)playNextMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    播放前一首

    @param success 成功回调
    @param failure 失败回调
    */
    - (void)playPreviousMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    获取音乐状态：包括播放和下载状态

    @param success 成功回调,返回值：json字典
    @param failure 失败回调
    */
    - (void)getMusicStateSuccesss:(MeariDeviceSucess_MusicStateAll)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //开始播放音乐
    [self.camera playMusic:musicID successs:^{
    } failure:^(NSError *error) {

    }];

    //暂停播放音乐
    [self.camera pauseMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    //继续播放音乐
    [self.camera resumeMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    //播放下一首音乐
    [self.camera playNextMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    //播放上一首音乐
    [self.camera playPreviousMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    //获取所有音乐的播放状态
    [self.camera getMusicStateSuccesss:^(NSDictionary *allMusicState) {

    } failure:^(NSError *error) {

    }];

```


## 9.19 设备音量 

```
【描述】
    设备输出音量的获取与设置

【函数调用】

    /**
    获取设备输出音量

    @param success 成功回调，返回值：设备输出音量，0-100
    @param failure 失败回调
    */
    - (void)getOutputVolumeSuccesss:(MeariDeviceSucess_Volume)success failure:(MeariDeviceFailure)failure;


    /**
    设置设备输出音量

    @param volume 音量，0-100
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setOutputVolume:(NSInteger)volume successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //获取设备输出音量
    [self.camera getOutputVolumeSuccesss:^(CGFloat volume) {

    } failure:^(NSError *error) {

    }];

    //设置设备输出音量
    [self.camera setOutputVolume:volume successs:^{

    } failure:^(NSError *error) {

    }];
```


## 9.20 门铃音量 

### (1) 可视门铃 

```
【描述】
    门铃输出音量的获取与设置
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,

【函数调用】
    /**
    设置门铃输出音量

    @param volume 音量
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setDoorBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //获取门铃输出音量
    [self.camera setDoorBellVolume:roundf(slider.value) success:^{

    } failure:^(NSError *error) {

    }];
```
### (2) 语音门铃 

```
【描述】
    门铃输出音量的获取与设置,注意此设置非立即生效，需要等设备启动一次后才可以生效
    
【适用】
	subType:
	MeariDeviceSubTypeIpcVoiceBell = 5,

【函数调用】
    /**
	设置语音门铃声音
	
	@param volume 0~100
	@param success 成功回调
	@param failure 失败回调
	*/
	- (void)setVoiceBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //设置语音门铃声音
    [self.device setVoiceBellVolume:50 success:^{
        NSLog(@"set voice bell volume success-%ld",weakSelf.device.param.voiceBell.ringSpeakerVolume);
    } failure:^(NSError *error) {
        NSLog(@"set voice bell volume failure");
    }];
```
## 9.21 铃铛设置 

### (1) 可视门铃 

```
【描述】
    门铃输出音量的获取与设置
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,

【函数调用】
    /**
	 设置无线铃铛
	 
	 @param volumeType 铃铛声音等级
	 @param selectedSong 选中的铃声
	 @param repeatTimes 重复次数
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)setDoorBellJingleBellVolumeType:(MeariDeviceLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //设置无线铃铛
    [self.camera setDoorBellJingleBellVolumeType:_jingleBellVolumeLevel selectedSong:self.selectedSong repeatTimes:_repeatTimes success:^(id obj) {
        [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
    } failure:^(NSError *error) {
        [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
    }];

```
### (2) 语音门铃 

```
【描述】
    门铃输出音量的获取与设置,注意此设置非立即生效，需要等设备启动一次后才可以生效
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcVoiceBell = 5,

【函数调用】
    /**
	 设置铃铛属性
	 @param volumeLevel
	    静音=MeariDeviceLevelOff
	    低=MeariDeviceLevelLow
	    中=MeariDeviceLevelMedium
	    高=MeariDeviceLevelHigh
	 @param durationLevel
	    短=MeariDeviceLevelLow
	    中=MeariDeviceLevelMedium
	    长=MeariDeviceLevelHigh
	 @param index   1~10
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)setVoiceBellCharmVolume:(MeariDeviceLevel)volumeLevel songDuration:(MeariDeviceLevel)durationLevel songIndex:(NSInteger)index success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【代码范例】
    //设置无线铃铛
    [self.device setVoiceBellCharmVolume: MeariDeviceLevelLow songDuration:MeariDeviceLevelLow songIndex:1 success:^{
        NSLog(@"set voice bell charm success-Volume-%ld-Duration-%ld-songIndex-%ld",weakSelf.device.param.voiceBell.jingleVolume,weakSelf.device.param.voiceBell.jingleDuration,weakSelf.device.param.voiceBell.jingleRing);
    } failure:^(NSError *error) {
        NSLog(@"set voice bell charm success");
    }];

```

## 9.22 留言设置 

```
【描述】
    设置客人留言参数,注意此设置非立即生效，需要等设备启动一次后才可以生效
    
【适用】
	subType:
  	MeariDeviceSubTypeIpcVoiceBell = 5,

【函数调用】
	/**
	设置访客留言
	
	@param enterTime 按门铃后进入留言时间10/20/30...60s
	@param durationTime 可留言时长10/20/30...60s
	@param success 成功回调
	@param failure 失败回调
	*/
	- (void)setVoiceBellEnterMessageTime:(NSInteger)enterTime messageDurationTime:(NSInteger)durationTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【代码范例】
    //设置无线铃铛
    [self.device setVoiceBellCharmVolume: MeariDeviceLevelLow songDuration:MeariDeviceLevelLow songIndex:1 success:^{
        NSLog(@"set voice bell charm success-Volume-%ld-Duration-%ld-songIndex-%ld",weakSelf.device.param.voiceBell.jingleVolume,weakSelf.device.param.voiceBell.jingleDuration,weakSelf.device.param.voiceBell.jingleRing);
    } failure:^(NSError *error) {
        NSLog(@"set voice bell charm success");
    }];

```


## 9.23 人体侦测报警 

```
【描述】
    门铃PIR报警的获取与设置：获取需要用调用参数接口

【函数调用】
    //门铃PIR报警获取，参见 7.15 获取参数信息
    /**
    获取所有参数

    @param success 成功回调，返回值：设备参数信息
    @param failure 失败回调
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    设置门铃PIR(人体侦测)报警类型

    @param level 报警级别
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setDoorBellPIRLevel:(MeariDeviceLevel)level successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //获取门铃PIR报警信息
    [self.camera getParamsSuccesss:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    //设置门铃PIR(人体侦测)报警类型
    [self.camera setDoorBellPIRLevel:level successs:^{

    } failure:^(NSError *error) {

    }];
```


## 9.24 门铃低功耗 

```
【描述】
    门铃低功耗的获取与设置：获取需要用调用参数接口

【函数调用】
    //门铃低功耗获取，参见 7.15 获取参数信息
    /**
    获取所有参数

    @param success 成功回调，返回值：设备参数信息
    @param failure 失败回调
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    设置门铃低功耗

    @param open 是否打开低功耗模式
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setDoorBellLowPowerOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //获取门铃低功耗
    [self.camera getParamsSuccesss:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    //设置门铃低功耗打开或关闭
    [self.camera setDoorBellLowPowerOpen:open success:^{

    } failure:^(NSError *error) {

    }];
```


## 9.25 门铃电池锁 

```
【描述】
    门铃电池锁的获取与设置：获取需要用调用参数接口

【函数调用】
    //门铃电池锁获取，参见 7.15 获取参数信息
    /**
    获取所有参数

    @param success 成功回调，返回值：设备参数信息
    @param failure 失败回调
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    设置门铃电池锁

    @param open 是否打开电池锁
    @param success 成功回调
    @param failure 失败回调
    */
    - (void)setDoorBellBatteryLockOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【代码范例】
    //获取门铃电池锁
    [self.camera getParamsSuccesss:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    //设置门铃低功耗打开或关闭
    [self.camera setDoorBellBatteryLockOpen:open success:^{

    } failure:^(NSError *error) {

    }];
```

## 9.26 留言 

### (1) 主人留言 

```
【描述】
    主人可为设备设置留言，主人可以在手机端控制设备播放自己录制的留言

【适用】
	subType:
  	MeariDeviceSubTypeIpcBell = 3,
  	
【函数调用】

    /**
    开始留言

    @param path 留言文件路径
    */
    - (void)startRecordAudioToPath:(NSString *)path;

    /**
    停止留言

    @param success 成功回调，返回值：留言文件路径
    */
    - (void)stopRecordAudioSuccess:(MeariDeviceSucess_RecordAutio)success;

    /**
    开始播放留言

    @param filePath 留言文件路径
    @param finished 完成回调
    */
    - (void)startPlayRecordedAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

    /**
    停止播放留言
    */
    - (void)stopPlayRecordedAudio;


【代码范例】
    //开始留言
    [self.camera startRecordAudioToPath:_filePath];

    //停止留言
    [self.camera stopRecordAudioSuccess:^(NSString *filePath) {

    }];

    //开始播放留言
    [self.camera startPlayRecordedAudioWithFile:_filePath finished:^{

    }];

    //停止播放留言
    [self.camera stopPlayRecordedAudio];

```
### (2) 客人留言 

```
【描述】
    在客人按门铃后无人响应，设备会进入留言模式，客人可以对设备进行留言，主人可通过手机App查看客人留言信息

【适用】
	subType:
	MeariDeviceSubTypeIpcVoiceBell = 5,
  	
【函数调用】
	1、获取访客信息
	/**
	 获取设备的访客事件
	 注：包括接听、挂断、留言信息
	 
	 @param deviceID 设备ID
	 @param pageNum 页数 1~
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)getVisitorMessageListForDevice:(NSInteger)deviceID pageNum:(NSInteger)pageNum success:(MeariSuccess_MsgVoiceDeviceList)success failure:(MeariFailure)failure;
	
	2、获取语音数据
	/**
	 获取语音数据
	 
	 @param remoteUrl 音频网络地址
	 @param sourceData 成功回调音频数据
	 @param failure 失败回调
	 */
	- (void)getVoiceMessageAudioData:(NSString *)remoteUrl deviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceVoiceData)sourceData failure:(MeariFailure)failure;

	3、播放语音数据
	/**
	 开始播放客人留言
	 
	 @param filePath 本地语音文件路径
	 @param finished 完成回调
	 */
	- (void)startPlayVoiceMessageAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;
	
	4、停止播放语音数据
	/**
	 停止播放客人留言
	 */
	- (void)stopPlayVoiceMessageAudio;

	5、标记消息已读
	/**
	 标记消息为已读
	 
	 @param messageID 消息ID
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)markReadVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
	
	6、删除单条消息 (接听、挂断、留言信息) 
	/**
	 删除某个设备的单条消息
	 
	 @param messageID 消息ID
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)deleteVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;
	
	7、删除所有消息 (接听、挂断、留言信息) 
	/**
	 删除某个设备下所有消息
	 
	 @param deviceID 设备ID
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)deleteAllVoiceMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;
	
    
【代码范例】
   所属：MeariSDK：WYVoiceDoorbellAlarmMsgDetailVC.h

```


## 9.27 设备播放留言 

```
【描述】
    播放留言

【函数调用】

    /**
    播放留言

    @param success 成功回调
    @param failure 成功回调
    */
    - (void)playMessageSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;     


【代码范例】

    //控制设备播放留言
    [self.camera playMessageSuccess:^{

    } failure:^(NSError *error) {

    }];
```


##9.28 灯具摄像机设置 

### (1) 开关灯 

```
【描述】
    控制灯的开关
    
【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【函数调用】
    /**
	设置灯开关
	
	@param on 灯开关
	@param success 成功回调
	@param failure 失败回调
	*/
	- (void)setFlightCameraLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure; 


【代码范例】
	  //设置灯开关
     [self.camera setFlightCameraLightOn:isOn success:^{
     
     } failure:^(NSError *error) {
	
     }];
```

### (2) 报警器开关 

```
【描述】
    通过设备控制报警器的开关，以达到警示的作用
    
【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【函数调用】

    
	/**
	设置警报开关
	
	@param on 警报开关
	@param success 成功回调
	@param failure 失败回调
	*/
	- (void)setFlightCameraSiren:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;     


【代码范例】
	//设置警报开关
    [weakSelf.camera setFlightCameraSiren:NO success:^{

    } failure:^(NSError *error) {
  
    }];

```

### (3) 按时间段开灯 

```
【描述】
	给设备设置一个时间段，当设备在设置的时间段内，设备会讲灯打开，时间截止则控制灯关闭
    
【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【函数调用】

    /**
	设置灯具开灯计划
	
	@param on 是否使能
	@param fromDateStr 开始时间
	@param toDateStr 结束时间
	@param success 成功回调
	@param failure 失败回调
	*/
	- (void)setFlightCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;   


【代码范例】

    //	设置灯具开灯计划
     [self.camera setFlightCameraScheduleOn:self.lightSwitch.isOn fromDate:_timeArray[0] toDate:_timeArray[1]  success:^{

    } failure:^(NSError *error) {
 
    }];
```

### (4) 按报警事件开关灯 

```
【描述】
    打开移动报警开灯后，设备监测到人体移动，会将灯打开，持续一段时间后熄灭
    
【适用】
	subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【函数调用】

    /**
	 设置灯具的移动监测
	
	 @param on 是否使能
	 @param level 不同等级对应的亮灯时间 MeariDeviceLevelLow : 20s , MeariDeviceLevelMedium : 40s, MeariDeviceLevelHigh: 60s
	 @param success 成功回调
	 @param failure 失败回调
	 */
	- (void)setFlightCameraMotionOn:(BOOL)on durationLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;   


【代码范例】

    NSInteger durationTime = [duration integerValue];
    MeariDeviceLevel level =  MeariDeviceLevelLow;
    if (durationTime == 20) {
        level = MeariDeviceLevelLow;
    }else  if (durationTime == 40) {
        level = MeariDeviceLevelMedium;
    }else  if (durationTime == 60){
       level = MeariDeviceLevelHigh;
    }
    [self.camera setFlightCameraMotionOn:isOn durationLevel:level success:^{

    } failure:^(NSError *error) {

    }];
```


# 10.共享设备 

## 10.1 好友管理 

### (1) 添加好友 

```
【描述】
    请求添加好友

【函数调用】
    //请求添加好友
    @param userAccount 好友账号
    @param success 成功回调
    @param failure 失败回调
    - (void)addFriend:(NSString *)userAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] addFriend:self.searchView.text success:^{

    } failure:^(NSError *error) {
    
    }];
```

### (2) 删除好友 

```
【描述】
    删除好友

【函数调用】
    //删除好友
    @param friendIDs 多个好友ID
    @param success 成功回调
    @param failure 失败回调
    - (void)deleteFriends:(NSArray <NSNumber *> *)friendIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] deleteFriends:userIDs success:^{

    } failure:^(NSError *error) {

    }];
```

### (3) 修改好友昵称 

```
【描述】
    修改好友昵称

【函数调用】
    //修改好友昵称
    @param friendID 好友ID
    @param nickname 好友昵称
    @param success 成功回调
    @param failure 失败回调
    - (void)renameFriend:(NSInteger)friendID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] renameFriend:self.model.info.userID nickname:self.tf.text success:^{

    } failure:^(NSError *error) {

    }];
```

### (4) 获取好友列表 

```
【描述】
    获取好友列表
    所属：MeariFriendInfo

【函数调用】
    //获取好友列表
    @param success 成功回调：返回好友列表
    @param failure 失败回调
    - (void)getFriendList:(MeariSuccess_FriendList)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getFriendList:^(NSArray<MeariFriendInfo *> *friends) {

    } failure:^(NSError *error) {

    }];
```

##10.2 添加分享 

### (1) 分享单个设备 

```
【描述】
    分享单个设备给指定用户

【函数调用】
    //主动分享设备
    @param type 设备类型
    @param deviceID 设备ID
    @param friendID 好友ID
    @param success 成功回调
    @param failure 失败回调
    - (void)shareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] shareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID toFriend:model.info.userID success:^{

    } failure:^(NSError *error) {

    }];
```

### (2) 取消单个设备分享 

```
【描述】
    取消单个设备分享

【函数调用】
    //取消单个设备分享
    @param type 设备类型
    @param deviceID 设备ID
    @param friendID 好友ID
    @param success 成功回调
    @param failure 失败回调
    - (void)cancelShareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] cancelShareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID toFriend:model.info.userID success:^{

    } failure:^(NSError *error) {

    }];
```

### (3) 请求分享某个设备 

```
【描述】
    请求分享某个设备

【函数调用】
    //请求分享某个设备
    @param type 设备类型
    @param sn 设备sn
    @param success 成功回调
    @param failure 失败回调
    - (void)requestShareDeviceWithDeviceType:(MeariDeviceType)type sn:(NSString *)sn success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] requestShareDeviceWithDeviceType:MeariDeviceTypeIpc sn:device.info.sn success:^{

    } failure:^(NSError *error) {

    }];
```

##10.3 查询分享 

### (1) 查询设备被分享过的好友列表 

```
【描述】
    查询单个设备被分享的好友列表

【函数调用】
    //查询单个设备被分享的好友列表
    @param type 设备类型
    @param deviceID 设备ID
    @param success 成功回调
    @param failure 失败回调
    - (void)getFriendListForDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess_FriendListForDevice)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getFriendListForDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID success:^(NSArray<MeariFriendInfo *> *friends) {
    
    } failure:^(NSError *error) {
    
    }];
```

### (2) 查询某个好友的被分享设备列表 

```
【描述】
	查询某个好友是否有自己分享过的设备

【函数调用】
    //查询某个好友的被分享设备列表
    @param friendID 好友ID
    @param success 成功回调
    @param failure 失败回调
    - (void)getDeviceListForFriend:(NSInteger)friendID success:(MeariSuccess_DeviceListForFriend)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getDeviceListForFriend:self.model.info.userID success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

```

#11.消息中心 

```
所属：MeariMessageInfo
```
```
注意：设备的报警消息，一经设备的主人拉取后，服务器就会删除该消息，因此需要本地保存，被分享的人拉取了设备的报警消息，服务器不会删除，这里注意主人和被分享人的区别
```
##11.1 获取所有设备是否有消息 

```
【描述】
    获取所有设备是否有消息
    所属：MeariMessageInfoAlarm

【函数调用】
    //获取所有设备是否有消息
    @param success 成功回调
    @param failure 失败回调
    - (void)getAlarmMessageList:(MeariSuccess_MsgAlarmList)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getAlarmMessageList:^(NSArray<MeariMessageInfoAlarm *> *msgs) {

    } failure:^(NSError *error) {

    }];
 【注意事项】
    如果消息一经主人拉取后，服务器不会保存消息，被分享的好友也看不到这些消息
```

##11.2 获取系统消息 

```
【描述】
    获取系统消息 
    所属：MeariMessageInfoSystem

【函数调用】
    //获取系统消息
    @param success 成功回调
    @param failure 失败回调
    - (void)getSystemMessageList:(MeariSuccess_MsgSystemList)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getSystemMessageList:^(NSArray<MeariMessageInfoSystem *> *msgs) {

    } failure:^(NSError *error) {

    }];
```

##11.3 获取某个设备报警消息 

```
【描述】
    获取某个设备报警消息
    所属：MeariMessageInfoAlarmDevice

【函数调用】
    //获取某个设备报警消息
    @param deviceID 设备ID
    @param success 成功回调
    @param failure 失败回调
    - (void)getAlarmMessageListForDevice:(NSInteger)deviceID success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] getAlarmMessageListForDevice:_deviceID success:^(NSArray<MeariMessageInfoAlarmDevice *> *msgs, MeariDevice *device) {

    } failure:^(NSError *error) {

    }];
 【注意事项】
    如果消息一经主人拉取后，服务器不会保存消息，被分享的好友也看不到这些消息
```

##11.4 批量删除系统消息 

```
【描述】
    批量删除系统消息

【函数调用】
    //批量删除系统消息
    @param msgIDs 多个消息ID
    @param success 成功回调
    @param failure 失败回调
    - (void)deleteSystemMessages:(NSArray <NSNumber *>*)msgIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] deleteSystemMessages:arr success:^{

    } failure:^(NSError *error) {

    }];
```

##11.5 批量删除多个设备报警消息 

```
【描述】
    批量删除多个设备报警消息

【函数调用】
    //批量删除多个设备报警消息
    @param deviceIDs 多个设备ID
    @param success 成功回调
    @param failure 失败回调
    - (void)deleteAlarmMessages:(NSArray <NSNumber *>*)deviceIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] deleteAlarmMessages:arr success:^{

    } failure:^(NSError *error) {

    }];
```

##11.6 标记单个设备消息全部已读 

```
【描述】
    标记单个设备消息全部已读

【函数调用】
    //标记单个设备消息全部已读
    @param deviceID 设备ID
    @param success 成功回调
    @param failure 失败回调
    - (void)markDeviceAlarmMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    [[MeariUser sharedInstance] markDeviceAlarmMessage:_deviceID success:^{

    } failure:^(NSError *error) {

    }];
```

##11.7 好友消息处理 

```
【描述】
    好友消息处理-同意|拒绝

【函数调用】
    //同意添加好友
    @param friendID 好友ID
    @param msgID 消息ID
    @param success 成功回调
    @param failure 失败回调
    - (void)agreeAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
    //拒绝添加好友
    @param friendID 好友ID
    @param msgID 消息ID
    @param success 成功回调
    @param failure 失败回调
    - (void)refuseAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //同意添加好友
    [[MeariUser sharedInstance] agreeAddFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{

    } failure:^(NSError *error) {

    }];
    
    //拒绝添加好友
    [[MeariUser sharedInstance] refuseAddFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{
    
    } failure:^(NSError *error) {
    
    }];
【注意事项】
    如果消息处理完了，需要手动删除消息
```

##11.8 设备消息处理 

```
【描述】
    设备消息处理-同意|拒绝

【函数调用】
    //同意分享设备
    @param deviceID 设备ID
    @param friendID 好友ID
    @param msgID 消息ID
    @param success 成功回调
    @param failure 失败回调
    - (void)agreeShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
    //拒绝分享设备
    @param deviceID 设备ID
    @param friendID 好友ID
    @param msgID 消息ID
    @param success 成功回调
    @param failure 失败回调
    - (void)refuseShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;

【代码范例】
    //同意分享设备
    [[MeariUser sharedInstance] agreeShareDevice:model.info.deviceID.integerValue toFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{

    } failure:^(NSError *error) {

    }];
    
    //拒绝分享设备
    [[MeariUser sharedInstance] refuseShareDevice:model.info.deviceID.integerValue toFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{
    
    } failure:^(NSError *error) {
    
    }];
【注意事项】
    如果消息处理完，需要手动删除消息
```
