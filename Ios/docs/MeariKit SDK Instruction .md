<h1><center> Directory </center></h1>

[TOC]

<center>

---
| Version number | Develop team | Update date | Notes |
| ------ | ------ | ------ | ------ |
| 2.0.0 | Towers Perrin Technical Team | 2019.05.09 |

</center>

#1. Functional Overview

The Towers Technology APP SDK provides interface packaging with hardware devices and Towers Perrin, and accelerates the application development process, including the following functions:

- Hardware device related (with network, control, status report, firmware upgrade, preview playback, etc.)
- Account system (general account function such as mobile phone number, email registration, login, reset password, etc.)
- Device sharing
- Friends management
- Message Center
- Rui Rui cloud HTTPS API interface package (see 觅睿云api call)


#2. Integration preparation

**Prepare App Key and App Secert**

Meari Technology Cloud Platform provides App ID and App Secert for users to access SDK quick access camera equipment

#3. Integrated SDK

## 3.1 Integration Preparation

### (1) Introducing the sdk package

```
Drag the downloaded MeariKit.framework to the project
```

### (2) Environment configuration

```
1. Add MeariKit.framework to target -> General -> Embedded Binaries
2. Disable bitcode: In the project panel, select target -> Build Settings -> Build Options -> Enable Bitcode -> Set to No
3. Add a file that supports C++: change any .m file to a .mm file, for example, change AppDelegate.m to AppDelegate.mm format.

```

## 3.2 Integrated SDK function

```
Affiliation:MeariSdk tool class
```

### (1) Initialize sdk configuration in Application

```
【Description】
    Mainly used to initialize internal resources, communication services and other functions.
 
【Function Call】
    /**
    Start the SDK

    @param appKey appKey
    @param secretKey secret
    */
    - (void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;
    
    /**
    Set debug print level
    
    @param logLevel print level
    */
    - (void)setLogLevel:(MeariLogLevel)logLevel;
    
    
    /**
    Configuring the server environment
    
    @param environment pre-issued or official
    */
    - (void)configEnvironment:(MearEnvironment)environment;

【Code Example】
    // Start the SDK
    [[MeariSDK sharedInstance] startWithAppKey:@"appKey" secretKey:@"secretKey"];
    
    // Configure the server environment: pre- or formal, is currently a development version, only supports running on the pre-launch environment
    [[MeariSDK sharedInstance] configEnvironment:MearEnvironmentRelease];
    
    // Set the debug log level, will print the input and output information of the internal interface, in order to troubleshoot the problem
    [[MeariSDK sharedInstance] setLogLevel:MeariLogLevelOff];
    
```
#4. User Management

```
Affiliation:MeariUser tool class
```
```
Towers Perrin Technology SDK provides two user management systems: common user system, UID user system

Ordinary user system: account login, registration, password change, password recovery, verification code
UID user system: uid login (up to 64 digits), no need to register without password system, please keep it safe
```

##4.1 User uid login system

```
Towers Perrin provides the uid landing system. If the customer has its own user system, then you can access our sdk through the uid login system.
```

### (1) Redirect

```
【Description】
	Meari SDK supports global services. When selecting different countries, you need to reset the access address, and access the corresponding server according to the incoming country code when logging in.
【Function Call】
	// call the account, modify the country when called
	- (void)resetRedirect;
```

### (2) User uid login

```
【Description】
	User uid registration, uid requires unique.

【Function Call】
	/**
	Log in via Uid
	
	@param uid User ID, need to guarantee uniqueness, <=32 bit
	@param countryCode country code
	@param phoneCode country code
	@param success Successful callback
	@param failure failure callback
	*/
	- (void)loginWithUid:(NSString *)uid countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure
	
【Code Example】
	// Login through Uid
	[[MeariUser sharedInstance] loginWithUid:@"abcdefghijklmn" countryCode:@"CN" phoneCode:@"86" success:^{
	
	} failure:^(NSError *error) {
	
	}];
	
```

### (3) User logout

```
【Description】
	Log out and log out with a normal account

【Function Call】
	// Log out of the account
	@param success Successful callback
	@param failure failure callback
	- (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;


【Code Example】
	// Log out of the account
	[[MeariUser sharedInstance] logoutSuccess:^{
	
	} failure:^(NSError *error) {
	
	}];
```

## 4.2 General User System Management

### (1) Redirect

```
【Description】
    Meari SDK supports global services. When selecting different countries, you need to reset the access address, and access the corresponding server according to the incoming country code when logging in.
【Function Call】
    // call the account, modify the country when called
    - (void)resetRedirect;
```
### (2) Register an account

```
【Description】
    You need to get a verification code before registering an account.
 
【Function Call】
    //get verification code
    @param userAccount User account: mailbox or mobile phone
    @param countryCode country code
    @param phoneCode country code
    @param success Successful callback, return the remaining valid time of the verification code, in seconds
    @param failure failure callback
- (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

    //Register an account
    @param userAccount User account: E-mail or mobile phone number (in mainland China only)
    @param password User password
    @param countryCode country code
    @param phoneCode country code
    @param verificationCode verification code
    @param nickname User nickname, can be modified after login
    @param success Successful callback
    @param failure failure callback
    - (void)registerAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode nickname:(NSString *)nickname success:(MeariSuccess )success failure:(MeariFailure)failure;
    
【Code Example】
    // Get the account verification code
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //success
    } failure:^(NSError *error) {
        //failure
    }];
    //Register an account
    [[MeariUser sharedInstance] registerAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" verificationCode:@"7234" nickname:@"coder man" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### (3) Account login

```
【Description】
    Support email login, mobile phone (in mainland China only) login
 
【Function Call】
    //Login
    @param userAccount User account: mailbox or mobile phone
    @param password User password
    @param countryCode country code
    @param phoneCode country code
    @param success Successful callback
    @param failure failure callback
    - (void)loginAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【Code Example】
    [[MeariUser sharedInstance] loginAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

### (4) Retrieve password

```
【Description】
    You need to get the verification code before you can retrieve your password.
 
【Function Call】
    //get verification code
    @param userAccount User account: mailbox or mobile phone
    @param countryCode country code
    @param phoneCode country code
    @param success Successful callback, return the remaining valid time of the verification code, in seconds
    @param failure failure callback
    - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

    // Retrieve password
    @param userAccount User account: E-mail or mobile phone number (in mainland China only)
    @param password new password
    @param countryCode country code
    @param phoneCode country code
    @param verificationCode verification code
    @param success Successful callback
    @param failure failure callback
    - (void)findPasswordWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure) Failure

【Code Example】
    // Get the account verification code
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //success
    } failure:^(NSError *error) {
        //failure
    }];
    // Retrieve password
    [[MeariUser sharedInstance] findPasswordWithAccount:@"john@163.com" password:@"123123" countryCode:@"CN" phoneCode:@"86" verificationCode:@"6322" success:^{
    } failure:^(NSError *error) {
    
    }];
```


### (5) Change password

```
【Description】
    Change the password after login, you need to obtain the verification code before modifying the password.

【Function Call】
    //get verification code
    @param userAccount User account: mailbox or mobile phone
    @param countryCode country code
    @param phoneCode country code
    @param success Successful callback, return the remaining valid time of the verification code, in seconds
    @param failure failure callback
    - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

    //change Password
    @param userAccount User account: E-mail or mobile phone number (in mainland China only)
    @param password User password
    @param verificationCode verification code
    @param success Successful callback
    @param failure is bound to callback
    - (void)changePasswordWithAccount:(NSString *)userAccount password:(NSString *)password verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    // Get the account verification code
    [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //success
    } failure:^(NSError *error) {
        //failure
    }];
    // Retrieve password
    [[MeariUser sharedInstance] changePasswordWithAccount:@"john@163.com" password:@"234567" verificationCode:@"8902" success:^{
    
    } failure:^(NSError *error) {
    
    }];
```


### (6) Registration message push

```
【Description】
    Sign up for Meari message push
    Called after logging in, registering, and retrieving the password. If the interface returns an error, re-register the push at intervals.

【Function Call】
    @param deviceToken phone token
    @param success Successful callback
    @param failure failure callback
    - (void)registerPushWithDeviceToken:(NSData *)deviceToken success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
```

### (7) User logout

```
【Description】
    Log out, log out

【Function Call】
    // Log out of the account
    @param success Successful callback
    @param failure failure callback
    - (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;


【Code Example】
    // Log out of the account
    [[MeariUser sharedInstance] logoutSuccess:^{
    
    } failure:^(NSError *error) {
    
    }];
```
##4.3 User upload avatar

```
【Description】
    User upload avatar
 
【Function Call】
    /*
     @param image Image
     @param success Successful callback, return the url of the avatar
     @param failure failure callback
     */
    - (void)uploadUserAvatar:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;
        
【Code Example】
    [[MeariUser sharedInstance] uploadUserAvatar:[UIImage imageWithData:self.imageData] success:^(NSString *avatarUrl) {

    } failure:^(NSError *error) {
    
    }];
```
##4.4 Modify? Nickname

```
【Description】
    Modify the user nickname.
 
【Function Call】
    /*
    @param name New nickname, length 6-20
    @param success Successful callback
    @param failure failure callback
     */
    - (void)renameNickname:(NSString *)name success:(MeariSuccess)success failure:(MeariFailure)failure;
        
【Code Example】
    [[MeariUser sharedInstance] renameNickname:newName success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

##4.5 Data Model

User-related data model.

```
[MeariUserInfo]
@property (nonatomic, strong) NSString * avatarUrl; //User avatar
@property (nonatomic, strong) NSString * nickName; //user nickname
@property (nonatomic, strong) NSString * userAccount; //user account
@property (nonatomic, strong) NSString * userID; //user ID
@property (nonatomic, strong) NSString * userToken; //user session
@property (nonatomic, strong) NSString * loginTime; //user login time
@property (nonatomic, strong) NSString * pushAlias; //User push alias for Aurora push (discard)
@property (nonatomic, strong) NSString * token; //User valid ID
@property (nonatomic, strong) NSString * secrect; //User valid ID
@property (nonatomic, strong) NSString * userKey; //user key
@property (nonatomic, strong) NSString * userName; //user name
@property (nonatomic, strong) NSString * countryCode; //Register country code
@property (nonatomic, strong) NSString * phoneCode; //Register the country phone code
@property (nonatomic, assign) BOOL notificationSound; //If the message push has sound
```

#5.Device message notification

```
Timely message notification is that MeariSDK promptly informs the current user of the App and some status of the device under the user account, so as to facilitate the App to achieve a better user experience.

[Notification Type] See: MeariUser.h
    MeariDeviceOnlineNotification (device online)
    MeariDeviceOfflineNotification (device offline)
    MeariDeviceCancelSharedNotification (device owner canceled sharing)
    MeariDeviceHasVisitorNotification (visual doorbell device has a guest ringing the doorbell)
    MeariDeviceVoiceBellHasVisitorNotification (Voice doorbell device has a guest ringing the doorbell)
    MeariDeviceUnbundlingNotification (device has been unbundled)
    MeariUserLoginInvalidNotification (login information is invalid, you need to log in again)
【use】
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginInvalidNotification:) name:MeariUserLoginInvalidNotification object:nil];
```
#6.Equipment distribution network

```
Affiliation:MeariDevice tool class
```
```
Towers Perrin technology hardware modules support three distribution modes: SmartWifi distribution network, hotspot mode (AP mode), two-dimensional code distribution network mode.
The QR code and SmartWifi operation are relatively simple. It is recommended to use the hotspot mode as an alternative after the distribution network fails. Among them, the success rate of the two-dimensional code distribution network is high.
```
##6.1 smartwifi distribution network

```
Before the distribution network, you need to obtain the Token first, and then call the distribution network interface.
```

### (1) Get Token

```
【Description】
Smart wifi distribution network needs to provide the name and password of the connected wifi

【Function Call】
    /**
    Get the distribution network token

    @param tokenType Different distribution modes correspond to different Tokens
    @param success Successful callback:
    Token: for distribution network
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.
    @param failure failure callback
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
【Code Example】
    [[MeariUser sharedInstance] getTokenForType:MeariDeviceTokenTypeSmartWifi success:^(NSString *token, NSInteger validTime) {
        //Don't care about validTime, because this type of Token is long-lived
    } failure:^(NSError *error) {

    }]

```
### (2) Start SmartWifi distribution network

```
【Description】
    Smart wifi distribution network needs to provide the name and password of the connected wifi
 
【Function Call】
	/**
	Start smartwifi distribution network
	
	@param wifiSSID wifi name
	@param wifiPwd wifi password: no password, pass nil
	@param success Successful callback
	@param failure failure callback
	*/
	+ (void)startMonitorWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
        
【Code Example】
    [MeariDevice startMonitorWifiSSID:@"wifi name" wifiPwd:@"12345678" success:^{
        //Successful callback will only return when stopped
    } failure:^(NSError *error){
        // The abnormal callback will return directly
    }];
```
### (3) Stop SmartWifi distribution network

```
    /**
    Stop smartwifi distribution network
    */
    + (void)stopMonitor;
```

##6.2 Hotspot mode (AP distribution network)

```
Before the distribution network, you need to obtain the Token first, and then call the distribution network interface.
```
### (1) Get Token

```
【Description】
    Get the Token required by the AP distribution network

【Function Call】
    /**
    Get the distribution network token

    @param tokenType Different distribution modes correspond to different Tokens
    @param success Successful callback:
    Token: for distribution network
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.
    @param failure failure callback
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
    
【Code Example】
    [[MeariUser sharedInstance] getTokenForType:MeariDeviceTokenTypeAP success:^(NSString *token, NSInteger validTime) {
        // Do not care about validTime, Token has been valid in this mode
    } failure:^(NSError *error) {

    }];
```
### (2) AP distribution network

```
【Description】
    The ap distribution network needs to provide the name and password of the connected wifi, and it needs to be connected to the hotspot of the device before the distribution network. (The device hotspot name is: `STRN` plus `underscore `plus `sn number` such as: STRN_056566188)
 
【Function Call】

	/**
	Start ap distribution network
	
	@param wifiSSID wifi name
	@param wifiPwd wifi password
	@param success Successful callback
	@param failure failure callback
	*/
	+ (void)startAPConfigureWifiSSID:(NSString *)wifiSSID wifiPwd:(NSString *)wifiPwd success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

        
【Code Example】
	// Start smartwifi distribution network
	[MeariDevice startAPConfigureWifiSSID:@"wifi name" wifiPwd:@"12345678" success:^{

    } failure:^(NSString *error) {
    
    }];
    
```

##6.3 QR code distribution network

```
Before the distribution network, you need to obtain the Token first, and then call the distribution network interface.
```
### (1) Get Token

```
【Description】
    Obtain the Token required by the AP distribution network. Note that this Token has an expiration time.

【Function Call】
    /**
    Get the distribution network token

    @param tokenType Different distribution modes correspond to different Tokens
    @param success Successful callback:
    Token: for distribution network
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.
    @param failure failure callback
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getTokenForType:MeariDeviceTokenTypeQRCode success:^(NSString *token, NSInteger validTime) {
        //validTime is the timeout period. The timeout Token cannot be used for the QR code distribution network. You need to regain the Token.
    } failure:^(NSError *error) {

    }];
```
### (2) QR code distribution network

```
【Description】
	The obtained token and the WiFi and password of the mobile phone generate a QR code picture, and the QR code picture is recommended: a 284px square picture
 
【Function Call】
	/**
	Generate QR code
	
	@param ssid wifi name
	@param password wifi password
	@param token QR code token
	@param size QR code size
	@return QR code image
	*/
	- (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;
        
【Code Example】

    // Generate a QR code
    UIImage *image = [[MeariUser sharedInstance] createQRWithSSID:@"wifi name" pasword:@"123456" token:token size:CGSizeMake(100, 100)];
```


##6.4 Searching for devices

```
Search timing: After the device is successfully deployed, the blue light will be on, and the device can be searched.
Search mechanism: The search interface does not have a timeout mechanism, and the search will not stop until the stop interface is called.
Search mode: LAN search and cloud search
```

### (1) smartwifi distribution network and ap distribution network search equipment

```
【Description】
	IPC device: After the device is successfully connected to the network, the blue light is always on, and the device can be searched for display.
    NVR device: The added NVR needs to be in the same network as the mobile phone before it can be searched.
 
【Function Call】

	/**
	Start search: for smartwifi distribution network and ap distribution network
	
	@param success Successful callback: return the searched device
	@param failure failure callback
	*/
	+ (void)startSearch:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【Code Example】
	// Start search: for smartwifi distribution network and ap distribution network
	[MeariDevice startSearch:^(MeariDevice *device) {
        
    } failure:^(NSString *error) {
        
    }];
```
### (2) QR code matching network search device

```
【Method One:】

【Description】
    After the device is successfully connected to the network, the blue light is always on, and the device can be searched for display.
    
    Note: The Token of the search needs to be consistent with the Token of the QR code distribution network, otherwise the device will not be searched.
    
【Function Call】
    /**
    Start search: only for QR code network

    @param token QR code token
    @param success Successful callback: return the searched device
    @param failure failure callback
    */
    + (void)startSearchWithQRcodeToken:(NSString *)token success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【Method Two:】
    
【Description】
    After the device is successfully connected to the network, the blue light is always on, and the device can be searched for display.

    Note: You need to update the Token before searching. The Token to be searched must be consistent with the Token of the QR code. Otherwise, the device will not be searched.

【Function Call】
    /**
    Update Token

    @param token distribution net token
    @param type Distribution network
    */
     + (void)updatetoken:(NSString *)token type:(MeariDeviceTokenType)type;
    
     /**
     Start searching: Search for a generic interface
     Make sure to call the updatetoken method when using this interface.
     @param mode Distribution mode
     @param success Successful callback: return the searched device
     @param failure failure callback
     */
     + (void)startSearch:(MeariDeviceSearchMode)mode success:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;
    
【Code Example】
     [MeariDevice updatetoken: self.token type:MeariDeviceTokenTypeQRCode];
     [MeariDevice startSearch: MeariSearchModeCloud_QRCode success:^(MeariDevice *device) {
   
     } failure:^(NSError *error) {
    
     }];
```
### (3) Equipment? Add

#### <1> Adding a camera

```
【Description】
    After searching for the device, first query the device status query, and add the device operation without being added.

【Be Applicable】
	type:
	MeariDeviceTypeIpc
	subType:
	All

【Function Call】
    // Query device status
    @param type device type
    @param devices Device to be queried: need to use the device interface to search for devices
    @param success Successful callback: return to device list
    @param failure failure callback
    - (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

    // Add equipment
    @param type device type
    @param uuid device uuid
    @param sn device sn
    @param tp device tp
    @param success Successful callback
    @param failure failure callback
    - (void)addDeviceWithDeviceType:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    // Query camera
    [[MeariUser sharedInstance] checkDeviceStatusWithDeviceType:MeariDeviceTypeIpc devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

    //Add camera
    [[MeariUser sharedInstance] addDeviceWithDeviceType:MeariDeviceTypeIpc uuid:device.info.uuid sn:device.info.sn tp:device.info.tp success:^{

    } failure:^(NSError *error) {

    }];

```
#### <2> Adding network storage

```
【Description】
    After searching for an NVR device, query the device status first, and add the device operation if it is not added.
    
【Be Applicable】
Type:
MeariDeviceTypeNVR

【Function Call】
    // Query device status
    @param type device type
    @param devices Device to be queried: need to use the device interface to search for devices
    @param success Successful callback: return to device list
    @param failure failure callback
    - (void)checkDeviceStatusWithDeviceType:(MeariDeviceType)type devices:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;

    // Add equipment
    @param type device type
    @param uuid device uuid
    @param sn device sn
    @param tp device tp
    @param success Successful callback
    @param failure failure callback
    - (void)addDeviceWithDeviceType:(MeariDeviceType)type uuid:(NSString *)uuid sn:(NSString *)sn tp:(NSString *)tp success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    // Query nvr
    [[MeariUser sharedInstance] checkDeviceStatusWithDeviceType:MeariDeviceTypeNvr devices:deviceArray success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

    //Add nvr
    [[MeariUser sharedInstance] addDeviceWithDeviceType:MeariDeviceTypeNvr uuid:device.info.uuid sn:device.info.sn tp:device.info.tp success:^{

    } failure:^(NSError *error) {

    }];

```
### (4) Stop searching

```
【Description】
    When you finish adding, if you have a search turned on, you need to stop the search operation.
【Function Call】
    /**
    Stop searching
    */
    + (void)stopSearch;
【Code Example】
    [MeariDevice stopSearch];
    [[MeariUser sharedInstance] cancelAllRequest];
```
##6.5 Autobind Device
```
Before the distribution network, you need to obtain the Token first, and then call the distribution network interface.
Allow the device to automatically add to the user account after scanning the QR code or AP mode.

```
### (1) Get Token
```
【Description】
    Get the Token required by the QRcode and AP mode

【Function Call】
    /**
 	token for config device
 
 	@param success return  config dictionary
        token: config token
        validTime: token invalid time
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

### (2) Start Config
```
【Description】
	start search and config device
【Function Call】
    /**
 	 start config 

  	 @param mode    search device mode
 	 @param token   config token
  	 @param timeout  Timeout time, the default is 100 seconds. If it is less than 0, the distribution network will not be closed. You need to manually call stopSearch.
 	*/
	- (void)startConfigWiFi:(MeariDeviceSearchMode)mode  token:(NSString *)token type:(MeariDeviceTokenType)type nvr:(BOOL)isNvr timeout:(NSTimeInterval)timeout;
  
【Code Example】
	[[MeariDeviceActivator sharedInstance] startConfigWiFi:(MeariSearchModeAll) token:token type:(MeariDeviceTokenTypeQRCode) nvr:NO timeout:100];

```
### (3) Config Complete
```
【Description】
	Obtain the device completed by the distribution network.  must set  [MeariDeviceActivator sharedInstance].delete = self; before implement this method
【Function Call】
   /**
 	Device Complete callback

 	@param activator activator
 	@param deviceModel return the device which config network completed
 	@param error return error
 	*/
	- (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error;
  
【Code Example】

	 - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(nullable MeariDevice *)deviceModel error:(nullable NSError *)error {
		// Use deviceModel.info.addStatus to determine whether the device is successfully added.
	   //BOOL success =  deviceModel.info.addStatus == MeariDeviceAddStatusSelf;

	 }

```

#7 NVR Binding Device

##7.1 Searching for devices

```
【Description】
    The device blue light is always on to be searched. It is used to display the binding NVR to the user. MeariDevice->hasBindedNvr is used to determine whether the NVR has been bound.

【Function Call】
    /**
    Start search: Search for devices under the current network

    @param success Successful callback: return the searched device
    @param failure failure callback
    */
    + (void)startSearch:(MeariDeviceSucess_SearchDevice)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Start search: for smartwifi distribution network and ap distribution network
    [MeariDevice startSearch:^(MeariDevice *device) {

    } failure:^(NSString *error) {

    }];
```
##7.2 Binding device

```
【Description】
    After the NVR is bound to the device, the video files of the device are stored in the NVR.

【Function Call】
    @param deviceID device ID
    @param nvrID nvr ID
    @param success Successful callback
    @param failure failure callback
    - (void)bindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] bindDevice:model.device.info.ID toNVR:self.nvr.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```
##7.3 End binding device

```
【Description】
    When the binding ends, if there is a search, you need to stop the search operation.
【Function Call】
    /**
    Stop searching
    */
    + (void)stopSearch;
【Code Example】
    [MeariDevice stopSearch];
    [[MeariUser sharedInstance] cancelAllRequest];
```
##7.4 Obtaining NVR-bound devices

```
【Description】
    Used to check which devices are bound to the NVR.

【Function Call】
    @param nvrID nvr ID
    @param success Successful callback: return the list of bound devices and unbound device list
    @param failure failure callback
    - (void)getBindDeviceList:(NSInteger)nvrID success:(MeariSuccess_DeviceListForNVR)success failure:(MeariFailure)failure;

【Code Example】
    // Query the list of bound devices
    [[MeariUser sharedInstance] getBindDeviceList:self.nvr.info.ID success:^(NSArray<MeariDevice *> *bindedDevices, NSArray<MeariDevice *> *unbindedDevices) {

    } failure:^(NSError *error) {

    }];
```
##7.5 Unbinding the device from the NVR

```
【Description】
    After the device is bound from the NVR, the video files of the device will not continue to be stored in the NVR.

【Function Call】
    @param deviceID device ID
    @param nvrID nvr ID
    @param success Successful callback
    @param failure failure callback
    - (void)unbindDevice:(NSInteger)deviceID toNVR:(NSInteger)nvrID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【Code Example】
    @param deviceIDs Multiple device IDs
    @param nvrID nvr ID
    @param success Successful callback
    @param failure failure callback
    [[MeariUser sharedInstance] unbindDevices:arr toNVR:self.nvr.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```
#8. Device information acquisition
```
Affiliation:MeariUser
```
##8.1 Getting Device Columns
```
Affiliation: MeariDeviceList
```
```
【Description】
    After the device is added, obtain the device list through the interface of the MeariUser tool class and return it as a model.
The device information is the info attribute of the device object (MeariDeviceInfo)

【Function Call】
    // Get a list of all devices
    - (void)getDeviceList:(MeariSuccess_DeviceList)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getDeviceList:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];
```

MeariDeviceList attribute:

```
 /** Camera */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;
/** Smart doorbell */
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** voice doorbell */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** Battery Camera */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** Lamp camera */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** Network Memory */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;
```
##8.2 Device Information

```
Affiliation:MeariDevice
```
```
@property (nonatomic, strong) MeariDeviceInfo *info; //Device information
@property (nonatomic, strong) MeariDeviceParam *param; //Device parameters
@property (nonatomic, assign, readonly, getter=isIpcCommon)BOOL ipcCommon; // Is it a normal camera?
@property (nonatomic, assign, readonly, getter=isIpcBaby)BOOL ipcBaby; //is it a music camera?
@property (nonatomic, assign, readonly, getter=isIpcBell)BOOL ipcBell; //whether it is a doorbell camera
@property (nonatomic, assign, readonly, getter=isNvr)BOOL nvr; //whether it is a box
@property (nonatomic, assign)BOOL hasBindedNvr; //Do you bind?
@property (nonatomic, assign, readonly)BOOL sdkLogined; //whether logged in
@property (nonatomic, assign, readonly)BOOL sdkLogining; //whether you are logged in
@property (nonatomic, assign, readonly)BOOL sdkPlaying; //Whether previewing
@property (nonatomic, assign, readonly)BOOL sdkPlayRecord; //Whether it is playing back
@property (nonatomic, strong)NSDateComponents *playbackTime; //current playback time
@property (nonatomic, assign, readonly)BOOL supportFullDuplex; //Do you support two-way voice intercom?
@property (nonatomic, assign, readonly)BOOL supportVoiceTalk; //support voice intercom
. . .
```
##8.3 Deleting a device

```
【Description】
    Device removal

【Function Call】
    // Remove the device
    @param type device type
    @param deviceID device ID
    @param success Successful callback
    @param failure failure callback
    - (void)deleteDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] deleteDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:cell.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```

##8.4 Device nickname modification

```
【Description】
    Device nickname modification

【Function Call】
    @param type device type
    @param deviceID device ID
    @param nickname New nickname, length 6-20
    @param success Successful callback
    @param failure failure callback
    - (void)renameDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    // Modify the IPC device nickname
    [[MeariUser sharedInstance] renameDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.camera.info.ID nickname:newNickName success:^{
    
    } failure:^(NSError *error) {
    
    }];
    
    // Modify the NVR device nickname
    [[MeariUser sharedInstance] renameDeviceWithDeviceType:MeariDeviceTypeNVR deviceID:self.nvr.info.ID nickname:newNickName success:^{

    } failure:^(NSError *error) {

    }];
```

##8.5 Single device one day alarm time point acquisition

```
【Description】
    Single device one day alarm time point acquisition

【Function Call】
    // a single device one day alarm time point to obtain
    @param deviceID device ID
    @param date Date: The format is 20171212
    @param success Successful callback: return to the alarm time list
    @param failure failure callback
    - (void)getAlarmMessageTimes:(NSInteger)deviceID onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getAlarmMessageTimes:self.device.info.ID onDate:@"20171212" success:^(NSArray<NSString *> *time) {

    } failure:^(NSError *error) {

    }];
```

##8.6 Check if the device has a new version

```
【Description】
    Check if the device has a new version

【Function Call】
    // Query the device for a new version
    @param currentFirmware Current version
    @param success Successful callback: Returns the latest version information of the device
    @param failure failure callback
    - (void)checkNewFirmwareWithCurrentFirmware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirmware:self.currentVersion success:^(MeariDeviceFirmwareInfo *info) {
    
    } failure:^(NSError *error) {
    
    }];
```

MeariDeviceFirmwareInfo:

```
@property (nonatomic, copy) NSString *upgradeUrl; //Device upgrade address
@property (nonatomic, copy) NSString *latestVersion; //The latest version of the device
@property (nonatomic, copy) NSString *upgradeDescription; //Device upgrade description
@property (nonatomic, assign) BOOL needUpgrade; //Do you need to upgrade?
```

##8.7 Querying Device Online Status

```
【Description】
    Check if the device has a new version

【Function Call】
    // Query the device for a new version
    @param deviceID device ID
    @param success Successful callback: Returns whether the device is online
    @param failure failure callback
    - (void)checkDeviceOnlineStatus:(NSInteger)deviceID success:(MeariSuccess_DeviceOnlineStatus)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] checkDeviceOnlineStatus:self.device.info.ID success:^(BOOL online) {

    } failure:^(NSError *error) {

    }];
```

##8.8 Querying the music list

```
【Description】
    Query music list

【Function Call】
    // Query music list
    @param success Successful callback: return to music list
    @param failure failure callback
    - (void)getMusicList:(MeariSuccess_Music)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getMusicList:^(NSArray<MeariMusicInfo *> *musicList) {

    } failure:^(NSError *error) {

    }];
```
```
MeariMusicInfo:
@property (nonatomic, strong) NSString * musicFormat; //Music format
@property (nonatomic, strong) NSString * musicID; //Music ID
@property (nonatomic, strong) NSString * musicName; //music name
@property (nonatomic, strong) NSString * musicUrl; //Music address
```

##8.9 Generate distribution network QR code

```
【Description】
    Generate distribution network QR code

【Function Call】
    // Get the QR code token
    /**
    Get the distribution network token
    
    @param tokenType Different distribution modes correspond to different Tokens
    @param success Successful callback:
    Token: for distribution network
    validTime: The length of time the token is valid. If it exceeds the length, you need to reacquire the new token.
    @param failure failure callback
    */
    - (void)getTokenForType:(MeariDeviceTokenType)tokenType success:(MeariSuccess_Token)success failure:(MeariFailure)failure;
    // Generate distribution network QR code
    @param ssid wifi name
    @param password wifi password
    @param token QR code token
    @param size QR code size
    @return QR code image
    - (UIImage *)createQRWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token size:(CGSize)size;

【Code Example】
    // Get the QR code token
    [[MeariUser sharedInstance] getTokenForQrcode:^(NSString *token) {

    } failure:^(NSError *error) {

    }];
    
    // Generate distribution network QR code
   UIImage *image = [[MeariUser sharedInstance] createQRWithSSID:weakSelf.wifi.ssid pasword:weakSelf.wifi.password token:obj size:CGSizeMake(WY_ScreenWidth, WY_ScreenHeight)];
```
##8.10 Remote wake-up doorbell

```
【Description】
    Remote wake-up doorbell

【Function Call】
    // Remote wake doorbell
    @param deviceID device ID
    @param success Successful callback
    @param failure failure callback
    - (void)remoteWakeUp:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] remoteWakeUp:self.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
【Precautions】
    For doorbell-type low-power products, you need to call the remote wake-up interface first, and then call the hole-punching interface.
```

##8.11 Uploading the doorbell message

```
【Description】
Upload doorbell message

【Function Call】
    /**
    Upload message

    @param deviceID device ID
    @param file message file path
    @param success Successful callback
    @param failure failure callback
    */
    - (void)uploadVoice:(NSInteger)deviceID voiceFile:(NSString *)file success:(MeariSuccess_DeviceVoiceUrl)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] uploadVoice:self.camera.info.ID voiceFile:_filePath success:^(NSString *voiceUrl) {
    
    } failure:^(NSError *error) {
    
    }];
```

##8.12 Download the doorbell message

```
【Description】
	Download the doorbell message

【Function Call】
    /**
    Download message

    @param voiceUrl Message address
    @param success Successful callback, return value: audio data
    @param failure failure callback
    */
    - (void)downloadVoice:(NSString *)voiceUrl success:(MeariSuccess_DeviceVoiceData)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] downloadVoice:urlStr success:^(NSData *data) {

    } failure:^(NSError *error) {
    
    }];
```

##8.13 Deleting the doorbell message

```
【Description】
	Delete doorbell message

【Function Call】
    /**
    Delete message

    @param deviceID device ID
    @param success Successful callback
    @param failure failure callback
    */
    - (void)deleteVoice:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] deleteVoice:self.camera.info.ID success:^{

    } failure:^(NSError *error) {

    }];
```

#9.Device Control
```
Affiliation:MeariDevice
```
```
MeariDevice is responsible for all operations on the device, including preview, playback, settings, etc. For device settings, you need to make sure that you have established a connection with the device.
```
##9.1 Connecting devices

```
【Description】
    Before you can preview, play back, set up, etc., you need to connect the device first.

【Function Call】
    /**
    Start connecting devices

    @param success Successful callback
    @param failure failure callback
    */
    - (void)startConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    [self.device startConnectSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 9.2 Disconnecting the device

```
【Description】
    When you do not need to operate the device, you need to disconnect the device

【Function Call】
    /**
    Disconnect device

    @param success Successful callback
    @param failure failure callback
    */
    - (void)stopConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    [self.device stopConnectSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 9.3 Get the bit rate

```
【Description】
    When you do not need to operate the device, you need to disconnect the device

【Function Call】
    /**
    Acquisition rate

    @return code rate
    */
    - (NSString *)getBitrates;

【Code Example】
    [self.device getBitrates]
```


## 9.4 Preview

```
【Description】
    Real-time streaming playback of the camera, support HD/SD switching

【Function Call】
    /**
    Start previewing the device

    @param playView play view control
    @param HD Whether to play HD
    @param success Successful callback
    @param failure failure callback
    @param close is in sleep mode, the lens is off, return value: sleep mode
    */
    - (void)startPreviewWithView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(void(^)(BOOL isPlaying))failure close:(void(^)(MeariDeviceSleepmode sleepmodeType))close;


    /**
    Stop previewing device

    @param success Successful callback
    @param failure failure callback
    */
    - (void)stopPreviewSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Switch HD SD

    @param playView play view
    @param HD Whether to play HD
    @param success Successful callback
    @param failure failure callback
    */
    - (void)switchPreviewWithView:(MeariPlayView *)playView streamid:(BOOL)HD success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Create a MeariPlayView
    MeariPlayView *playView = [[MeariPlayView alloc] initWithFrame:CGRectMake(0, 0,160, 90];

    // Start previewing the device
    [self.camera startPreviewWithView:playView streamid:YES success:^{

    } failure:^(BOOL isPlaying) {

    } close:^(MeariDeviceSleepmode sleepmodeType) {

    }];

    // Stop preview device
    [self.camera stopPreviewSuccess:^{

    } failure:^(NSString *error) {

    }];

    // Switch HD standard definition
    [self.camera switchPreviewWithView:self.drawableView streamid:HD success:^{

    } failure:^(NSString *error) {

    }];
```


## 9.5 Playback

```
【Description】
    Play back the video of the camera
    Note: The SDK does not check the playing time, so even if you pass in a time point without an alarm, the interface will return success, so the upper layer needs to judge by itself.

【Function Call】
    /**
    Get the number of video days in a month

    @param year year
    @param month月
    @param success Successful callback, return value: json array --[{"date" = "20171228"},...]
    @param failure failure callback
    */
    - (void)getPlaybackVideoDaysWithYear:(NSInteger)year month:(NSInteger)month success:(MeariDeviceSucess_Days)success failure:(MeariDeviceFailure)failure;


    /**
    Get a video clip of a day

    @param year year
    @param month月
    @param day
    @param success Successful callback: return value: json array --[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
    @param failure failure callback
    */
    - (void)getPlaybackVideoTimesWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day success:(MeariDeviceSucess_Times)success failure:(MeariDeviceFailure)failure;

    /**
    Start playback of video: only one person can view playback video at the same time

    @param playView play view
    @param startTime Start time: format is 20171228102035
    @param success Successful callback
    @param failure failure callback
    @param otherPlaying others watching playback
    */
    - (void)startPlackbackWithView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSucess)success failure:(void(^)(BOOL isPlaying))failure otherPlaying:(MeariDeviceSucess)otherPlaying;


    /**
    Stop playback

    @param success Successful callback
    @param failure failure callback
    */
    - (void)stopPlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Play from a certain time: This interface can only be used after the playback is successful, otherwise it will fail.

    @param seekTime Start time: format is 20171228102035
    @param success Successful callback
    @param failure failure callback
    */
    - (void)seekPlackbackSDCardToTime:(NSString *)seekTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Pause playback

    @param success Successful callback
    @param failure failure callback
    */
    - (void)pausePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Continue playback

    @param success Successful callback
    @param failure failure callback
    */
    - (void)resumePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Get video days
    [self.device getPlaybackVideoDaysWithYear:year month:month success:^(NSArray *days) {

    } failure:^(NSString *error) {

    }];

    // Get the video duration of a certain day
    [self.device getPlaybackVideoTimesWithYear:year month:month day:day success:^(NSArray *times) {

    } failure:^(NSString *error) {

    }];


    // Start playing back the video
    [self.device startPlackbackWithView:playview startTime:starttime success:^{

    } failure:^(BOOL isPlaying) {

    } otherPlaying:^{

    }];

    // stop playback
    [self.device stopPlackbackSDCardSuccess:^{
    WYDo_Block_Safe_Main(success)
    } failure:^(NSString *error) {
    WYDo_Block_Safe_Main(success)
    }];

    //seek playback
    [self.device seekPlackbackSDCardToTime:self.currentComponents.timeStringWithNoSprit success:^{

    } failure:^(NSString *error) {

    }];

    // Pause playback
    [self.device pausePlackbackSDCardSuccess:^{

    } failure:^(NSString *error) {

    }];

    // continue playback
    [self.device resumePlackbackSDCardSuccess:^{

    } failure:^(NSString *error) {

    }];
```

## 9.6 Silent

```
【Description】
    Set mute

【Function Call】
    /**
    Set mute

    @param muted is mute?
    */
    - (void)setMute:(BOOL)muted;

【Code Example】

    // Set the mute
    [self.device setMute:muted];

```

## 9.7 Voice Intercom

### (1) One-way intercom

```
【Description】
    One-way intercom is that the mobile phone and the device cannot talk at the same time. The mobile terminal starts the intercom call startVoicetalk, and the end of the speech needs to call to stop the intercom stopVoicetalkSuccess, otherwise the mobile phone terminal cannot receive the speech.
    
【Be Applicable】
	subType:
	    MeariDeviceSubTypeIpcCommon = 1,
	    MeariDeviceSubTypeIpcBaby = 2,
	    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】

	/**
    Set the voice intercom type

    @param type voice intercom type
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    Get the real-time volume of the voice intercom

    @return 0-1.0
    */
    - (CGFloat)getVoicetalkVolume;

    /**
    Start voice intercom

    @param success Successful callback
    @param failure failure callback
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Stop voice intercom

    @param success Successful callback
    @param failure failure callback
    */
    - (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

	// Set the voice intercom type
    [self.camera setVoiceTalkType:MeariVoiceTalkTypeOneWay];

    // Get the real-time volume of the voice intercom
    [self.camera getVoicetalkVolume]


    // Start voice intercom
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

    // Stop the voice intercom
    [self.camera stopVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

```
### (2) Two-way intercom

```
【Description】
    Two-way intercom is a mobile phone and device ** can ** speak at the same time, the mobile terminal starts the intercom call startVoicetalk, does not call stopVoicetalkSuccess, does not affect the sound from the device side
    
【Be Applicable】
	subType:
	  MeariDeviceSubTypeIpcBell = 3,
	  MeariDeviceSubTypeIpcBattery = 4,

【Function Call】

	/**
    Set the voice intercom type

    @param type voice intercom type
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    Start voice intercom

    @param success Successful callback
    @param failure failure callback
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    Stop voice intercom

    @param success Successful callback
    @param failure failure callback
    */
    - (void)stopVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

	// Set the voice intercom type
    [self.camera setVoiceTalkType:MeariVoiceTalkTypeFullDuplex];

 
    // Start voice intercom
    [self.camera startVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

    // Stop the voice intercom
    [self.camera stopVoicetalkSuccess:^{

    } failure:^(NSString *error) {

    }];

```

### (3) Voice doorbell intercom

```
【Description】
    The voice doorbell intercom is different from other intercom modes. It supports two-way intercom. If the mobile phone needs to turn off the microphone, you can call the pause interface. When you need to re-open the microphone, you need to reset the intercom operation.
    
【Be Applicable】
	subType:
	  MeariDeviceSubTypeIpcVoiceBell = 5,

【Function Call】
	/**
    Set the voice intercom type

    @param type voice intercom type
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
    Start voice intercom

    @param success Successful callback
    @param failure failure callback
    */
    - (void)startVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

	/**
	Turn off the phone side microphone
	
	@param success Successful callback
	@param failure Successful callback
	*/
	- (void)pauseVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;
	
	/**
	Turn on the phone microphone
	
	@param success successful callback
	@param failure Successful callback
	*/
	- (void)resumeVoicetalkSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

	  // Set the voice intercom type
     [self.camera setVoiceTalkType: MeariVoiceTalkTypeFullDuplex];

     // Start voice intercom
     [self.camera startVoicetalkSuccess:^{

     } failure:^(NSString *error) {

     }];

	// Close the phone microphone
	[self.camera pauseVoicetalkSuccess:^{
	
	} failure:^(NSError *error) {
	
	};

	// Open the phone microphone
	[self.camera resumeVoicetalkSuccess:^{
	
	} failure:^(NSError *error) {
	
	};
	
```
## 9.8 Screenshot

```
【Description】
    Capture video image

【Function Call】

    /**
    Screenshot

    @param path The path where the image is saved
    @param isPreviewing is previewing
    @param success Successful callback
    @param failure failure callback
    */
    - (void)snapshotToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

    // screenshot
    [self.camera snapshotToPath:snapShotPath isPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

```


## 9.9 Video

```
【Description】
    Video recording

【Function Call】
    /**
    Start recording

    @param path The path where the video is saved
    @param isPreviewing is previewing
    @param success Successful callback
    @param failure failure callback
    */
    - (void)startRecordMP4ToPath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Stop recording

    @param isPreviewing is previewing
    @param success Successful callback
    @param failure failure callback
    */
    - (void)stopRecordMP4IsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

    // Start recording
    [self.camera startRecordMP4ToPath:path isPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

    // Stop recording
    [self.nvr stopRecordMP4IsPreviewing:_isPreviewing success:^{

    } failure:^(NSString *error) {

    }];

```


## 9.10 PTZ control

```
【Description】
    Rotate the camera

【Function Call】

/**
    Start turning the camera

    @param direction
    @param success Successful callback
    @param failure failure callback
    */
    - (void)startMoveToDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Stop turning the camera

    @param success Successful callback
    @param failure failure callback
    */
    - (void)stopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

    // Start to turn
    [self.camera startMoveToDirection:MeariMoveDirectionUp success:^{

    } failure:^(NSString *error) {

    }];

    // stop turning
    [self.camera stopMoveSuccess:^{

    } failure:^(NSString *error) {

    }];

```


## 9.11 Mirroring

```
【Description】
    Mirror status acquisition and setting

【Function Call】

    /**
    Get mirror status

    @param success Successful callback
    @param failure failure callback
    */
    - (void)getMirrorSuccesss:(MeariDeviceSucess_Mirror)success failure:(MeariDeviceFailure)failure;


    /**
    Setting mirror

    @param open Whether to open the image
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setMirrorOpen:(BOOL)open successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

    // Start to turn
    [self.camera startMoveToDirection:MeariMoveDirectionUp success:^{

    } failure:^(NSString *error) {

    }];

    // stop turning
    [self.camera stopMoveSuccess:^{

    } failure:^(NSString *error) {

    }];

```


## 9.12 Motion Detection Alarm

```
【Description】
    Alarm information acquisition and setting

【Function Call】

    /**
    Get alarm information

    @param success Successful callback, return value: alarm parameter information
    @param failure failure callback
    */
    - (void)getAlarmSuccesss:(MeariDeviceSucess_Motion)success failure:(MeariDeviceFailure)failure


    /**
    Set the alarm level

    @param level alarm level
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setAlarmLevel:(MeariDeviceLevel)level successs:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

【Code Example】

    // Get the alarm information
    [self.camera getAlarmSuccesss:^(MeariDeviceParamMotion *motion) {

    } failure:^(NSString *error) {

    }];

    // Set the alarm level
    [self.camera setAlarmLevel:level successs:^(id obj) {

    } failure:^(NSString *error) {

    }];

```


## 9.13 Storage (SD card)

```
【Description】
    Stored information acquisition and formatting

【Function Call】
    /**
    Get storage information

    @param success Successful callback, return storage information
    @param failure failure callback
    */
    - (void)getStorageInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;


    /**
    Get memory card formatting percentage

    @param success Successful callback, return formatting percentage
    @param failure failure callback
    */
    - (void)getFormatPercentSuccesss:(MeariDeviceSucess_StoragePercent)success failure:(MeariDeviceFailure)failure;

    /**
    Format memory card

    @param success Successful callback
    @param failure
    */
    - (void)formatSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】

    // Get storage information
    [self.device getStorageInfoSuccess:^(MeariDeviceParamStorage *storage) {

    } failure:^(NSString *error) {

    }];

    // Get the formatting percentage
    [self.device getFormatPercentSuccesss:^(NSInteger percent) {

    } failure:^(NSString *error) {

    }];

    // Format the memory card
    [self.device formatSuccesss:^{

    } failure:^(NSString *error) {

    }];

```

## 9.14 Firmware Upgrade

### (1) Online upgrade

```
【Description】
    Firmware information acquisition and upgrade, point upgrade equipment will be upgraded immediately.
    Note: You need to operate the device online and establish a successful connection.
    
【Be Applicable】
	subType:
	    MeariDeviceSubTypeIpcCommon = 1,
	    MeariDeviceSubTypeIpcBaby = 2,
	    MeariDeviceSubTypeIpcBell = 3,
	    MeariDeviceSubTypeIpcBattery = 4,
	    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】

    /**
    Get the firmware version

    @param success Successful callback
    @param failure failure callback
    */
    - (void)getVersionSuccesss:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;


    /**
    Get firmware upgrade percentage

    @param success Successful callback
    @param failure failure callback
    */
    - (void)getUpgradePercentSuccesss:(MeariDeviceSucess_VersionPercent)successFailure:(MeariDeviceFailure)failure;


    /**
    Upgrade firmware

    @param url firmware package address
    @param currentVersion Firmware current version number
    @param success Successful callback
    @param failure failure callback
    */
    - (void)upgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】

    // Get the firmware version
    [self getVersionSuccesss:^(id obj) {

    } failure:^(NSError *error) {

    }];

    // Get the firmware upgrade percentage
    [self.camera getUpgradePercentSuccesss:^(NSInteger percent) {

    } failure:^(NSError *error) {

    }];

    // Upgrade the firmware
    [weakSelf.camera upgradeWithUrl:weakSelf.devUrl currentVersion:weakSelf.currentVersion successs:^{

    } failure:^(NSError *error) {

    }];

```
### (2) Plan to upgrade

```
【Description】
    Firmware information acquisition and upgrade, point upgrade equipment will not be upgraded immediately, and the upgrade plan will not be executed until the device is started.
    Note: The device can be upgraded if it is not online.
    
【Be Applicable】
	subType:
	MeariDeviceSubTypeIpcVoiceBell = 5,

【Function Call】
	1. Get device version information first.
	    /**
	Get the version information: param.voiceBell.deviceVersion
	
	@param success Successful callback, return value: device parameter information
	@param failure failure callback
	*/
	- (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;
    
   2, check if you need to upgrade
   [MeariUser:checkNewFirmwareWithCurrentFirmware](#8.6 Check if the device has a new version)

	3, perform the upgrade operation
	/**
	Upgrade firmware
	
	@param url firmware package address
	@param latestVersion latest firmware version number
	@param success Successful callback
	@param failure failure callback
	*/
	- (void)upgradeVoiceBellWithUrl:(NSString *)url latestVersion:(NSString *)latestVersion successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure ;


【Code Example】

    [self.device getParamsSuccesss:^(MeariDeviceParam *param) {
       weakSelf.deviceUrl = param.voiceBell.deviceVersion;
		[[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirmware:weakSelf.deviceUrl success:^(MeariDeviceFirmwareInfo *info) {
			[weakSelf.device upgradeVoiceBellWithUrl:info.upgradeUrl latestVersion:info.latestVersion successs:^{
			NSLog (@"Upgrade voice doorbell success");
			} failure:^(NSError *error) {
				NSLog (@"Upgrade voice doorbell failure %@", error);
			}];
		} failure:^(NSError *error) {
		                
		}];
	} failure:^(NSError *error) {
	
	}];

```
## 9.15 Get parameter information

```
【Description】
    Obtain all the parameter information of the device, and the function parameters set for the device can be obtained through this interface.

【Function Call】
    /**
    Get all parameters

    @param success Successful callback, return value: device parameter information
    @param failure failure callback
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

【Code Example】
    [self.camera getParamsSuccesss:^(WYCameraParams *params) {

    } failure:^(NSString *error) {

    }];
```


## 9.16 Sleep Mode

```
【Description】
    Set different modes to control the device lens,
    MeariDeviceSleepmodeLensOn : Lens on
    MeariDeviceSleepmodeLensOff : The lens is permanently off
    MeariDeviceSleepmodeLensOffByTime : The lens is turned off by time period
    MeariDeviceSleepmodeLensOffByGeographic : The lens is closed according to geographical location

【Function Call】
    /**
    Set sleep mode

    @param type sleep mode
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setSleepmodeType:(MeariDeviceSleepmode)type successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    Set the sleep period

    @param open Whether to enable sleep mode
    @param times Sleep time period
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setSleepmodeTime:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
	Set geofence
	
	@param ssid wifi SSID
	@param bssid wifi BSSID
	@param deviceID device ID
	@param success Successful callback
	@param failure failure callback
	*/
	- (void)settingGeographyWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    // Set sleep mode
    [self.camera setSleepmodeType:model.type successs:^{

    } failure:^(NSError *error) {

    }];

    // Set the sleep time period
    [self.camera setSleepmodeTime:open times:timesArr successs:^{

    }failure:^(NSError *error) {

    }];
    
    // Set the WiFi information
	[[MeariUser sharedInstance] settingGeographyWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:^(NSString *str){
	
	} failure:^(NSError *error){
	
	}];
    
```


## 9.17 Temperature and Humidity

```
【Description】
    Get all parameter information of the device

【Function Call】

    /**
    Get temperature and humidity

    @param success Successful callback, return value: temperature and humidity
    @param failure failure callback
    */
    - (void)getTemperatureHumiditySuccesss:(MeariDeviceSucess_TRH)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Set sleep mode
    [self.camera getTemperatureHumiditySuccesss:^(CGFloat temperature, CGFloat humidty) {

    } failure:^(NSError *error) {
        If (error.code == MeariDeviceCodeNoTemperatureAndHumiditySensor) {
        // No temperature and humidity sensor
        }else {

        }
    }];
```


## 9.18 Music

```
【Description】
    Get the music status of the device, control the device to play music, you need a memory card to play

【Function Call】

    /**
    play music

    @param musicID music ID
    @param success Successful callback
    @param failure failure callback
    */
    - (void)playMusic:(NSString *)musicID successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Pause music

    @param success Successful callback
    @param failure failure callback
    */
    - (void)pauseMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

    /**
    Keep playing music

    @param success Successful callback
    @param failure failure callback
    */
    - (void)resumeMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Play the next song

    @param success Successful callback
    @param failure failure callback
    */
    - (void)playNextMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Play the previous one

    @param success Successful callback
    @param failure failure callback
    */
    - (void)playPreviousMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Get music status: including play and download status

    @param success Successful callback, return value: json dictionary
    @param failure failure callback
    */
    - (void)getMusicStateSuccesss:(MeariDeviceSucess_MusicStateAll)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Start playing music
    [self.camera playMusic:musicID successs:^{
    } failure:^(NSError *error) {

    }];

    // Pause to play music
    [self.camera pauseMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    //Continue to play music
    [self.camera resumeMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    //Play the next music
    [self.camera playNextMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    //Play the last music
    [self.camera playPreviousMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    // Get the playing status of all music
    [self.camera getMusicStateSuccesss:^(NSDictionary *allMusicState) {

    } failure:^(NSError *error) {

    }];

```


## 9.19 Device Volume

```
【Description】
    Device output volume acquisition and setting

【Function Call】

    /**
    Get device output volume

    @param success Successful callback, return value: device output volume, 0-100
    @param failure failure callback
    */
    - (void)getOutputVolumeSuccesss:(MeariDeviceSucess_Volume)success failure:(MeariDeviceFailure)failure;


    /**
    Set the device output volume

    @param volume volume, 0-100
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setOutputVolume:(NSInteger)volume successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Get the device output volume
    [self.camera getOutputVolumeSuccesss:^(CGFloat volume) {

    } failure:^(NSError *error) {

    }];

    // Set the device output volume
    [self.camera setOutputVolume:volume successs:^{

    } failure:^(NSError *error) {

    }];
```


## 9.20Doorbell volume

### (1) Visual doorbell

```
【Description】
    Doorbell output volume acquisition and setting
    
【Be Applicable】
	subType:
	  MeariDeviceSubTypeIpcBell = 3,

【Function Call】
    /**
    Set the doorbell output volume

    @param volume
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setDoorBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Get the doorbell output volume
    [self.camera setDoorBellVolume:roundf(slider.value) success:^{

    } failure:^(NSError *error) {

    }];
```
### (2) Voice doorbell

```
【Description】
    Get and set the doorbell output volume. Note that this setting does not take effect immediately. It needs to be activated once the device is activated.
    
【Be Applicable】
	subType:
	MeariDeviceSubTypeIpcVoiceBell = 5,

【Function Call】
    /**
	Set the voice doorbell sound
	
	@param volume 0~100
	@param success Successful callback
	@param failure failure callback
	*/
	- (void)setVoiceBellVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Set the voice doorbell sound
    [self.device setVoiceBellVolume:50 success:^{
        NSLog(@"set voice bell volume success-%ld",weakSelf.device.param.voiceBell.ringSpeakerVolume);
    } failure:^(NSError *error) {
        NSLog(@"set voice bell volume failure");
    }];
```

## 9.21 Bell settings

### (1) Visual doorbell

```
【Description】
    Doorbell output volume acquisition and setting
    
【Be applicable】
subType:
  MeariDeviceSubTypeIpcBell = 3,

【Function Call】
    /**
Set the wireless bell

@param volumeType Bell sound level
@param selectedSong Selected ringtone
@param repeatTimes number of repetitions
@param success Successful callback
@param failure failure callback
*/
- (void)setDoorBellJingleBellVolumeType:(MeariDeviceLevel)volumeType selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Set the wireless bell
    [self.camera setDoorBellJingleBellVolumeType:_jingleBellVolumeLevel selectedSong:self.selectedSong repeatTimes:_repeatTimes success:^(id obj) {
        [SVProgressHUD wy_showToast: WYLocalString(@"success_set")];
    } failure:^(NSError *error) {
        [SVProgressHUD wy_showToast: WYLocalString(@"fail_set")];
    }];

```
### (2) Voice doorbell

```
【Description】
    Get and set the doorbell output volume. Note that this setting does not take effect immediately. It needs to be activated once the device is activated.
    
【Be applicable】
subType:
  MeariDeviceSubTypeIpcVoiceBell = 5,

【Function Call】
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


【Code Example】
    // Set the wireless bell
    [self.device setVoiceBellCharmVolume: MeariDeviceLevelLow songDuration:MeariDeviceLevelLow songIndex:1 success:^{
        NSLog(@"set voice bell charm success-Volume-%ld-Duration-%ld-songIndex-%ld",weakSelf.device.param.voiceBell.jingleVolume,weakSelf.device.param.voiceBell.jingleDuration,weakSelf.device. param.voiceBell.jingleRing);
    } failure:^(NSError *error) {
        NSLog(@"set voice bell charm success");
    }];

```

## 9.22 Message Settings

```
【Description】
    Set guest message parameters, note that this setting does not take effect immediately, you need to wait for the device to start once to take effect.
    
【Be applicable】
subType:
  MeariDeviceSubTypeIpcVoiceBell = 5,

【Function Call】
/**
Set guest message

@param enterTime Press the doorbell to enter the message time 10/20/30...60s
@param durationTime Message length 10/20/30...60s
@param success Successful callback
@param failure failure callback
*/
- (void)setVoiceBellEnterMessageTime:(NSInteger)enterTime messageDurationTime:(NSInteger)durationTime success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】
    // Set the wireless bell
    [self.device setVoiceBellCharmVolume: MeariDeviceLevelLow songDuration:MeariDeviceLevelLow songIndex:1 success:^{
        NSLog(@"set voice bell charm success-Volume-%ld-Duration-%ld-songIndex-%ld",weakSelf.device.param.voiceBell.jingleVolume,weakSelf.device.param.voiceBell.jingleDuration,weakSelf.device. param.voiceBell.jingleRing);
    } failure:^(NSError *error) {
        NSLog(@"set voice bell charm success");
    }];

```


## 9.23 Human body detection alarm

```
【Description】
    Acquisition and setting of doorbell PIR alarm: Get the call parameter interface

【Function Call】
    // Doorbell PIR alarm acquisition, see 7.15 Obtaining parameter information
    /**
    Get all parameters

    @param success Successful callback, return value: device parameter information
    @param failure failure callback
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    Set the doorbell PIR (human body detection) alarm type

    @param level alarm level
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setDoorBellPIRLevel:(MeariDeviceLevel)level successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Get the doorbell PIR alarm information
    [self.camera getParamsSuccesss:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    // Set the doorbell PIR (human body detection) alarm type
    [self.camera setDoorBellPIRLevel:level successs:^{

    } failure:^(NSError *error) {

    }];
```


## 9.24 Doorbell low power consumption

```
【Description】
    Doorbell low power acquisition and setting: Get the call parameter interface

【Function Call】
    //doorbell low power acquisition, see 7.15 for parameter information
    /**
    Get all parameters

    @param success Successful callback, return value: device parameter information
    @param failure failure callback
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    Set the doorbell low power consumption

    @param open Whether to turn on low power mode
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setDoorBellLowPowerOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Get the doorbell low power consumption
    [self.camera getParamsSuccesss:^(MeariDeviceParam *params) {

    } failure:^(NSError *error) {

    }];

    // Set the doorbell low power to turn on or off
    [self.camera setDoorBellLowPowerOpen:open success:^{

    } failure:^(NSError *error) {

    }];
```


## 9.25 Doorbell battery lock

```
【Description】
    Doorbell battery lock acquisition and setting: Get the call parameter interface

【Function Call】
    //doorbell battery lock acquisition, see 7.15 for parameter information
    /**
    Get all parameters

    @param success Successful callback, return value: device parameter information
    @param failure failure callback
    */
    - (void)getParamsSuccesss:(MeariDeviceSucess_Param)success failure:(MeariDeviceFailure)failure;

    /**
    Set the doorbell battery lock

    @param open Whether to open the battery lock
    @param success Successful callback
    @param failure failure callback
    */
    - (void)setDoorBellBatteryLockOpen:(BOOL)open success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code Example】
    // Get the doorbell battery lock
    [self.camera getParamsSuccesss:^(MeariDeviceParam *params) {} failure:^(NSError *error) {

    }];

    // Set the doorbell low power to turn on or off
    [self.camera setDoorBellBatteryLockOpen:open success:^{

    } failure:^(NSError *error) {

    }];
```

## 9.26 Message

### (1) Owner's Message

```
【Description】
    The owner can set a message for the device, and the owner can play the recorded message on the mobile terminal control device.

【Be applicable】
subType:
  MeariDeviceSubTypeIpcBell = 3,
  
【Function Call】

    /**
    Start message

    @param path message file path
    */
    - (void)startRecordAudioToPath:(NSString *)path;

    /**
    Stop message

    @param success Successful callback, return value: message file path
    */
    - (void)stopRecordAudioSuccess:(MeariDeviceSucess_RecordAutio)success;

    /**
    Start playing a message

    @param filePath message file path
    @param finished complete callback
    */
    - (void)startPlayRecordedAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

    /**
    Stop playing the message
    */
    - (void)stopPlayRecordedAudio;


【Code Example】
    // Start a message
    [self.camera startRecordAudioToPath:_filePath];

    // Stop the message
    [self.camera stopRecordAudioSuccess:^(NSString *filePath) {

    }];

    // Start playing the message
    [self.camera startPlayRecordedAudioWithFile:_filePath finished:^{

    }];

    // Stop playing the message
    [self.camera stopPlayRecordedAudio];

```
### (2) Guestbook

```
【Description】
    After the guest rings the door, no device responds, the device will enter the message mode, the guest can leave a message on the device, and the owner can view the guest message through the mobile app.

【Be applicable】
subType:
MeariDeviceSubTypeIpcVoiceBell = 5,
  
【Function Call】
1. Get visitor information
/**
Get the device's visitor event
Note: including answering, hanging up, message information

@param deviceID device ID
@param pageNum Pages 1~
@param success Successful callback
@param failure failure callback
*/
- (void)getVisitorMessageListForDevice:(NSInteger)deviceID pageNum:(NSInteger)pageNum success:(MeariSuccess_MsgVoiceDeviceList)success failure:(MeariFailure)failure;

2, get voice data
/**
Get voice data

@param remoteUrl Audio Network Address
@param sourceData successfully callback audio data
@param failure failure callback
*/
- (void)getVoiceMessageAudioData:(NSString *)remoteUrl deviceID:(NSInteger)deviceID success:(MeariSuccess_DeviceVoiceData)sourceData failure:(MeariFailure)failure;

3, play voice data
/**
Start playing guest message

@param filePath local voice file path
@param finished complete callback
*/
- (void)startPlayVoiceMessageAudioWithFile:(NSString *)filePath finished:(MeariDeviceSucess)finished;

4, stop playing voice data
/**
Stop playing guest messages
*/
- (void)stopPlayVoiceMessageAudio;

5, mark the message has been read
/**
Mark the message as read

@param messageID message ID
@param success Successful callback
@param failure failure callback
*/
- (void)markReadVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;

6, delete a single message (answer, hang up, message information)
/**
Delete a single message for a device

@param messageID message ID
@param success Successful callback
@param failure failure callback
*/
- (void)deleteVoiceMessage:(NSInteger)messageID success:(MeariSuccess)success failure:(MeariFailure)failure;

7, delete all messages (answer, hang up, message information)
/**
Delete all messages under a device

@param deviceID device ID
@param success Successful callback
@param failure failure callback
*/
- (void)deleteAllVoiceMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

    
【Code Example】
   Affiliation: MeariSDK: WYVoiceDoorbellAlarmMsgDetailVC.h

```


## 9.27 Device playback message

```
【Description】
    Play message

【Function Call】

    /**
    Play message

    @param success Successful callback
    @param failure Successful callback
    */
    - (void)playMessageSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】

    // Control device to play a message
    [self.camera playMessageSuccess:^{

    } failure:^(NSError *error) {

    }];
```


##9.28 Lighting camera settings

### (1) Switch light

```
【Description】
    Control light switch
    
【Be applicable】
subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】
    /**
Setting the light switch

@param on light switch
@param success Successful callback
@param failure failure callback
*/
- (void)setFlightCameraLightOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】
// Set the light switch
     [self.camera setFlightCameraLightOn: isOn success:^{
     
     } failure:^(NSError *error) {

     }];
```

### (2) Alarm switch

```
【Description】
    Control the alarm switch through the device to achieve the warning function
    
【Be applicable】
subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】

    
/**
Set the alarm switch

@param on alarm switch
@param success Successful callback
@param failure failure callback
*/
- (void)setFlightCameraSiren:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】
// Set the alarm switch
    [weakSelf.camera setFlightCameraSiren:NO success:^{

    } failure:^(NSError *error) {
  
    }];

```

### (3) Turn on the lights by time period

```
【Description】
Set a time period for the device. When the device is in the set time period, the device will turn on the light, and when the time is off, the control light will be turned off.
    
【Be applicable】
subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】

    /**
Set up the lighting plan

@param on Is it enabled?
@param fromDateStr start time
@param toDateStr End time
@param success Successful callback
@param failure failure callback
*/
- (void)setFlightCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】

    // Set the lighting program
     [self.camera setFlightCameraScheduleOn: self.lightSwitch.isOn fromDate:_timeArray[0] toDate:_timeArray[1] success:^{

    } failure:^(NSError *error) {
 
    }];
```

### (4) Press the alarm event switch light

```
【Description】
    After turning on the mobile alarm, the device monitors the movement of the human body and turns the light on. It will go out after a period of time.
    
【Be applicable】
subType:
    MeariDeviceSubTypeIpcFloodlight = 6,

【Function Call】

    /**
Set up the movement monitoring of the luminaire

@param on Is it enabled?
@param level The lighting time for different levels MeariDeviceLevelLow : 20s , MeariDeviceLevelMedium : 40s, MeariDeviceLevelHigh: 60s
@parAm success successful callback
@param failure failure callback
*/
- (void)setFlightCameraMotionOn:(BOOL)on durationLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


【Code Example】

    NSInteger durationTime = [duration integerValue];
    MeariDeviceLevel level = MeariDeviceLevelLow;
    If (durationTime == 20) {
        Level = MeariDeviceLevelLow;
    }else if (durationTime == 40) {
        Level = MeariDeviceLevelMedium;
    }else if (durationTime == 60){
       Level = MeariDeviceLevelHigh;
    }
    [self.camera setFlightCameraMotionOn: isOn durationLevel:level success:^{

    } failure:^(NSError *error) {

    }];
```


# 10.Shared device

## 10.1 Friend Management

### (1) Add a friend

```
【Description】
    Request to add a friend

【Function Call】
    // Request to add friends
    @param userAccount buddy account
    @param success Successful callback
    @param failure failure callback
    - (void)addFriend:(NSString *)userAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] addFriend:self.searchView.text success:^{

    } failure:^(NSError *error) {
    
    }];
```

### (2) Delete a friend

```
【Description】
    delete friend

【Function Call】
    //delete friend
    @param friendIDs Multiple friend IDs
    @param success Successful callback
    @param failure failure callback
    - (void)deleteFriends:(NSArray <NSNumber *> *)friendIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] deleteFriends:userIDs success:^{

    } failure:^(NSError *error) {

    }];
```

### (3) Modify friend nickname

```
【Description】
    Modify friend nickname

【Function Call】
    // Modify the friend nickname
    @param friendID buddy ID
    @param nickname Friend Nickname
    @param success Successful callback
    @param failure failure callback
    - (void)renameFriend:(NSInteger)friendID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] renameFriend:self.model.info.userID nickname:self.tf.text success:^{

    } failure:^(NSError *error) {

    }];
```

### (4) Get friends list

```
【Description】
    Get a list of friends
    Affiliation:MeariFriendInfo

【Function Call】
    // Get a list of friends
    @param success Successful callback: return to the buddy list
    @param failure failure callback
    - (void)getFriendList:(MeariSuccess_FriendList)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getFriendList:^(NSArray<MeariFriendInfo *> *friends) {

    } failure:^(NSError *error) {

    }];
```

##10.2 Adding a share

### (1) Sharing a single device

```
【Description】
    Share a single device to a given user

【Function Call】
    //Active sharing device
    @param type device type
    @param deviceID device ID
    @param friendID buddy ID
    @param success Successful callback
    @param failure failure callback
    - (void)shareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] shareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID toFriend:model.info.userID success:^{

    } failure:^(NSError *error) {

    }];
```

### (2) Cancel individual device sharing

```
【Description】
    Cancel individual device sharing

【Function Call】
    //Cancel individual device sharing
    @param type device type
    @param deviceID device ID
    @param friendID buddy ID
    @param success Successful callback
    @param failure failure callback
    - (void)cancelShareDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID toFriend:(NSInteger)friendID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] cancelShareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID toFriend:model.info.userID success:^{

    } failure:^(NSError *error) {

    }];
```

### (3) Request to share a device

```
【Description】
    Request to share a device

【Function Call】
    // Request to share a device
    @param type device type
    @param sn device sn
    @param success Successful callback
    @param failure failure callback
    - (void)requestShareDeviceWithDeviceType:(MeariDeviceType)type sn:(NSString *)sn success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] requestShareDeviceWithDeviceType:MeariDeviceTypeIpc sn:device.info.sn success:^{

    } failure:^(NSError *error) {

    }];
```

##10.3 Query sharing

### (1) Query the list of friends that the device has been shared with.

```
【Description】
    Query the list of friends that a single device is shared with

【Function Call】
    // Query the list of friends shared by a single device
    @param type device type
    @param deviceID device ID
    @param success Successful callback
    @param failure failure callback
    - (void)getFriendListForDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess_FriendListForDevice)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getFriendListForDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:self.deviceID success:^(NSArray<MeariFriendInfo *> *friends) {
    
    } failure:^(NSError *error) {
    
    }];
```

### (2) Query a list of shared devices of a friend

```
【Description】
Query if a friend has a device that I have shared

【Function Call】
    // Query a friend's list of shared devices
    @param friendID buddy ID
    @param success Successful callback
    @param failure failure callback
    - (void)getDeviceListForFriend:(NSInteger)friendID success:(MeariSuccess_DeviceListForFriend)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getDeviceListForFriend:self.model.info.userID success:^(NSArray<MeariDevice *> *devices) {

    } failure:^(NSError *error) {

    }];

```

#11.Message Center

```
Affiliation:MeariMessageInfo
```
```
Note: The alarm message of the device will be deleted after the device owner pulls it.In addition to the message, it needs to be saved locally. The shared person pulls the alarm message of the device, and the server does not delete it. Here, pay attention to the difference between the owner and the shared person.
```
##11.1 Get all devices have messages

```
【Description】
    Get all devices have messages
    Affiliation:MeariMessageInfoAlarm

【Function Call】
    // Get all devices have a message
    @param success Successful callback
    @param failure failure callback
    - (void)getAlarmMessageList:(MeariSuccess_MsgAlarmList)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getAlarmMessageList:^(NSArray<MeariMessageInfoAlarm *> *msgs) {

    } failure:^(NSError *error) {

    }];
 【Precautions】
    If the message is pulled by the owner, the server will not save the message, and the shared friends will not see the message.
```

##11.2 Getting system messages

```
【Description】
    Get system messages
    Affiliation:MeariMessageInfoSystem

【Function Call】
    // Get system messages
    @param success Successful callback
    @param failure failure callback
    - (void)getSystemMessageList:(MeariSuccess_MsgSystemList)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getSystemMessageList:^(NSArray<MeariMessageInfoSystem *> *msgs) {

    } failure:^(NSError *error) {

    }];
```

##11.3 Obtaining a device alarm message

```
【Description】
    Get a device alarm message
    Affiliation:MeariMessageInfoAlarmDevice

【Function Call】
    // Get a device alarm message
    @param deviceID device ID
    @param success Successful callback
    @param failure failure callback
    - (void)getAlarmMessageListForDevice:(NSInteger)deviceID success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] getAlarmMessageListForDevice:_deviceID success:^(NSArray<MeariMessageInfoAlarmDevice *> *msgs, MeariDevice *device) {

    } failure:^(NSError *error) {

    }];
 【Precautions】
    If the message is pulled by the owner, the server will not save the message, and the shared friends will not see the message.
```

##11.4 Batch delete system messages

```
【Description】
    Batch delete system messages

【Function Call】
    // Batch delete system messages
    @param msgIDs Multiple message IDs
    @param success Successful callback
    @param failure failure callback
    - (void)deleteSystemMessages:(NSArray <NSNumber *>*)msgIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] deleteSystemMessages:arr success:^{

    } failure:^(NSError *error) {

    }];
```

##11.5 Deleting multiple device alarm messages in batches

```
【Description】
    Delete multiple device alarm messages in bulk

【Function Call】
    // Batch delete multiple device alarm messages
    @param deviceIDs Multiple device IDs
    @param success Successful callback
    @param failure failure callback
    - (void)deleteAlarmMessages:(NSArray <NSNumber *>*)deviceIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] deleteAlarmMessages:arr success:^{

    } failure:^(NSError *error) {

    }];
```

##11.6 Marking a single device message has been read

```
【Description】
    Mark a single device message all read

【Function Call】
    // Mark a single device message has been read
    @param deviceID device ID
    @param success Successful callback
    @param failure failure callback
    - (void)markDeviceAlarmMessage:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    [[MeariUser sharedInstance] markDeviceAlarmMessage:_deviceID success:^{

    } failure:^(NSError *error) {

    }];
```

##11.7 Friend Message Processing

```
【Description】
    Friend message processing - consent | rejection

【Function Call】
    //Agree to add a friend
    @param friendID buddy ID
    @param msgID message ID
    @param success Successful callback
    @param failure failure callback
    - (void)agreeAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
    // Refuse to add friends
    @param friendID buddy ID
    @param msgID message ID
    @param success Successful callback
    @param failure failure callback
    - (void)refuseAddFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    //Agree to add a friend
    [[MeariUser sharedInstance] agreeAddFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{

    } failure:^(NSError *error) {

    }];
    
    // Refuse to add friends
    [[MeariUser sharedInstance] refuseAddFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{
    
    } failure:^(NSError *error) {
    
    }];
【Precautions】
    If the message is processed, you need to manually delete the message.
```

##11.8 Device Message Processing

```
【Description】
    Device Message Processing - Agree | Reject

【Function Call】
    //Agree to share the device
    @param deviceID device ID
    @param friendID buddy ID
    @param msgID message ID
    @param success Successful callback
    @param failure failure callback
    - (void)agreeShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;
    
    //Reject sharing device
    @param deviceID device ID
    @param friendID buddy ID
    @param msgID message ID
    @param success Successful callback
    @param failure failure callback
    - (void)refuseShareDevice:(NSInteger)deviceID toFriend:(NSInteger)friendID msgID:(NSInteger)msgID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code Example】
    //Agree to share the device
    [[MeariUser sharedInstance] agreeShareDevice:model.info.deviceID.integerValue toFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{

    } failure:^(NSError *error) {

    }];
    
    //Reject sharing device
    [[MeariUser sharedInstance] refuseShareDevice:model.info.deviceID.integerValue toFriend:model.info.userID.integerValue msgID:model.info.msgID.integerValue success:^{
    
    } failure:^(NSError *error) {
    
    }];
【Precautions】
    If the message is processed, you need to manually delete the message.
```


