
<h1><center> Documentation </center></h1>

[TOC]

<center>

---
| Version | Team| Update | remark | 
| ------ | ------ | ------ | ------ |
| 2.0.1 | Meari Technology | 2019.06.25 | optimization
| 3.1.0 | Meari Technology | 2021.07.05 | optimization

</center>

#1. Functional Overview 

Meari Technology APP SDK provides the interface package for communication with hardware devices and Meari Cloud to accelerate the application development process. It mainly includes the following functions:

- Hardware equipment related (network distribution, control, status reporting, firmware upgrade, preview playback, etc.)
- Account system (general account functions such as mobile phone number, email registration, login, password reset, etc.)
- Equipment sharing
- Message Center

#2. Integration preparation

**App Key & App Secert**

Meari Technology Cloud Platform provides App Key and App Secert for users to access SDK and quickly access camera equipment

#3. Integrated SDK

## 3.1 Integration preparation 

### (1) SDK 

```
Drag the downloaded MeariKit.framework to the project
```

### (2) Environment configuration  

```
1. Add MeariKit.framework to target -> General -> Embedded Binaries or target -> General -> Framework, Libraries, and Embedded Content 
2. Disable bitcode: In the project panel, select target -> Build Settings -> Build Options -> Enable Bitcode -> Set to No
3. Add files that support C++: change any .m file to .mm file, for example, change AppDelegate.m to AppDelegate.mm format
```

## 3.2 Integrated SDK function 

```
Belong to: MeariSdk tools
```

### (1) Initialize the SDK configuration in Application

```
【Description 】
    Mainly used to initialize internal resources, communication services and other functions.
 
【Function】
    /**
     Start SDK
     @param appKey appKey
     @param secretKey secret
    */
    - (void)startWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey;
    
    /**
     Set debug printing level
     @param logLevel print level
    */
     - (void)setLogLevel:(MeariLogLevel)logLevel;
    
    
    /**
     Configure the server environment
     @param environment Release: MearEnvironmentRelease Prrelease: MearEnvironmentPrerelease developer: MearEnvironmentDeveloper
     */
    - (void)configEnvironment:(MearEnvironment)environment;

【Code】
    [[MeariSDK sharedInstance] startWithAppKey:@"appKey" secretKey:@"secretKey"];
    
    [[MeariSDK sharedInstance] configEnvironment:MearEnvironmentPrerelease];
    
    //Set the debug log level, the input and output information of the internal interface will be printed for troubleshooting
    [[MeariSDK sharedInstance] setLogLevel:MeariLogLevelVerbose];
    
    /**
    The language of the push is optional. The default is the same as the local language of the mobile phone and changes dynamically. After setting, the push language will be forced to the set language
    @property sdkPushLanguage 
	 
    Currently the language supported by the server is :  zh,de,en,fr,pl,br,it,pt,es,ko,ja 
    */
【Code】
    [MeariSDK sharedInstance].sdkPushLanguage = @"en";

```


#4. User Management 

```
Belong to: MeariUser tool class
```
```
Meari Technology SDK provides two user management systems: ordinary user system and UID user system.

There is a phoneCode file in the Demo project that stores the corresponding country code and phone code.

Ordinary user system: account login, registration, change password, retrieve password, obtain verification code
UID user system: uid login (maximum 64 bits), no need to register, no password system, please keep it safe
```

##4.1 User uid login system 

```
Meari Technology provides uid login system. If the customer has their own user system, they can log in to our SDK through the uid login system.
```

### (1) Redirect 

```
【Description 】
      Meari SDK supports global services. When you select a different country, you need to reset the access address, and access the corresponding server according to the country code passed in when logging in.
【Function】
	  //Called when switching accounts and changing countries
	  - (void)resetRedirect;    
```
### (2) User uid login 

```
【Description 】
     The user uid is registered, and the uid must be unique.
【Function】
     /**
      @param uid User ID, need to ensure uniqueness, <=32 bits
      @param countryCode E.g. CN
      @param phoneCode E.g. 86
      @param success 
      @param failure 
     */
    - (void)loginWithUid:(NSString *)uid countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode  success:(MeariSuccess)success  failure:(MeariFailure)failure

【Code】
      [[MeariUser sharedInstance] loginWithUid:@"abcdefghijklmn" countryCode:@"CN" phoneCode:@"86" success:^{

      } failure:^(NSError *error) {

      }];

```

### (3) User logout 

```
【Description 】
     Account logout
【Function】
     /**
      @param success 
      @param failure 
     */
    - (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] logoutSuccess:^{

     } failure:^(NSError *error) {

     }];
```

## 4.2 Ordinary user system management 

### (1) Redirect 

```
【Description 】
     MMeari SDK supports global services. When you select a different country, you need to reset the access address, and access the corresponding server according to the country code passed in when logging in.
【Function】
    //Called when switching accounts and changing countries
    - (void)resetRedirect;    
```
### (2) Register an account 

```
【Description 】
     You need to obtain a verification code before registering an account
 
【Function】
     //get verification code
     @param userAccount User account: email or mobile phone
     @param countryCode E.g. CN
     @param phoneCode E.g. 86
     @param success return the remaining valid time of the verification code, in seconds
     @param failure 
	 - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

     //Register an account
     @param userAccount User account: email or mobile phone number (only in mainland China)
     @param password 
     @param countryCode E.g. CN
     @param phoneCode E.g. 86
     @param verificationCode 
     @param nickname 
     @param success
     @param failure 
     - (void)registerAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【Code】
     //Get the verification code of the account
     [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
   
     } failure:^(NSError *error) {

     }];
     
     //Register an account
     [[MeariUser sharedInstance] registerAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" verificationCode:@"7234" nickname:@"coder man" success:^{
    
     } failure:^(NSError *error) {
    
     }];
```

### (3) Account login

```
【Description 】
     Support email login, mobile phone (only in mainland China) login
【Function】
     /**
      @param userAccount User account: email or mobile phone
      @param password
      @param countryCode E.g. CN
      @param phoneCode  E.g. 86
      @param success 
      @param failure 
     */
     - (void)loginAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(MeariSuccess)success failure:(MeariFailure)failure;
    
【Code】
     [[MeariUser sharedInstance] loginAccount:@"john@163.com" password:@"123456" countryCode:@"CN" phoneCode:@"86" success:^{
    
     } failure:^(NSError *error) {
    
     }];
```

### (4) Retrieve password

```
【Description 】
     You need to get the verification code before retrieving the password
 
【Function】
     //get verification code
     @param userAccount User account: email or mobile phone
     @param countryCode E.g. CN
     @param phoneCode E.g. 86
     @param success Successful callback, return the remaining valid time of the verification code, in seconds
     @param failure 
     - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

     //Retrieve password
     @param userAccount User account: email or mobile phone number (only in mainland China)
     @param password New password
     @param countryCode E.g. CN
     @param phoneCode E.g. 86
     @param verificationCode Verification code
     @param success 
     @param failure 
     - (void)findPasswordWithAccount:(NSString *)userAccount password:(NSString *)password countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     //Get the verification code of the account
     [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //success
     } failure:^(NSError *error) {
        //failure
     }];
     
     //Retrieve password
     [[MeariUser sharedInstance] findPasswordWithAccount:@"john@163.com" password:@"123123" countryCode:@"CN" phoneCode:@"86" verificationCode:@"6322" success:^{
     } failure:^(NSError *error) {
    
     }];
```


### (5) Change Password 

```
【Description 】
     Change the password after login, you need to get the verification code before changing the password

【Function】
     @param userAccount 
     @param countryCode 
     @param phoneCode 
     @param success 
     @param failure 
     - (void)getValidateCodeWithAccount:(NSString *)userAccount countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode success:(void(^)(NSInteger seconds))success failure:(MeariFailure)failure;

     //change Password
     @param userAccount 
     @param password 
     @param verificationCode 
     @param success 
     @param failure 
     - (void)changePasswordWithAccount:(NSString *)userAccount password:(NSString *)password verificationCode:(NSString *)verificationCode success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] getValidateCodeWithAccount:@"john@163.com" countryCode:@"CN" phoneCode:@"86" success:^(NSInteger seconds) {
        //success
     } failure:^(NSError *error) {
        //failure
     }];
     
     //Retrieve password
     [[MeariUser sharedInstance] changePasswordWithAccount:@"john@163.com" password:@"234567" verificationCode:@"8902" success:^{
    
     } failure:^(NSError *error) {
    
     }];
```
### (6) User logout 

```
【Description 】
     Log out, log out of account

【Function】
     @param success 
     @param failure 
     - (void)logoutSuccess:(MeariSuccess)success failure:(MeariFailure)failure;


【Code】
     [[MeariUser sharedInstance] logoutSuccess:^{
     
     } failure:^(NSError *error) {
    
     }];
```

##4.3 User upload avatar 

```
【Description 】
     User upload avatar
 
【Function】
     /*
      @param image 
      @param success Successful callback, return the url of the avatar
      @param failure 
      */
     - (void)uploadUserAvatar:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;
        
【Code】
     [[MeariUser sharedInstance] uploadUserAvatar:[UIImage imageWithData:self.imageData] success:^(NSString *avatarUrl) {

     } failure:^(NSError *error) {
    
     }];
```
##4.4 Modify nickname 

```
【Description 】
     Modify user nickname.
 
【Function】
     /*
      @param name New nickname, length 6-20 digits
      @param success 
      @param failure 
     */
    - (void)renameNickname:(NSString *)name  success:(MeariSuccess)success failure:(MeariFailure)failure;
        
【Code】
     [[MeariUser sharedInstance] renameNickname:newName success:^{
    
     } failure:^(NSError *error) {
    
     }];
```
##4.5 APNS Message Push

```
【Description 】
     Sign up for Meari APNS push 
     We need to provide our server with the P8 file, the Key ID of the P8 file, the bundle ID of the App, and the Team ID of the App issuing certificate to push APNS messages.
      Called when logged in, that is, under the condition of [MeariUser sharedInstance].logined == YES

【Function】
     @param deviceToken Phone token
     @param success 
     @param failure 
     - (void)registerPushWithDeviceToken:(NSData *)deviceToken success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
【Code】

     [[MeariUser sharedInstance] registerPushWithDeviceToken:tokenData 	success:^(NSDictionary *dict) {

     } failure:^(NSError *error) {
             
     }];


【Description 】
     Turn off push sound
【Function】
     /**
      Sound push

      @param openSound whether to open 
      @param success Successful callback 
      @param failure failure callback 
   
     */
     - (void)notificationSoundOpen:(BOOL)openSound success:(MeariSuccess)success 	failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] notificationSoundOpen:YES success:^{

     } failure:^(NSError *error) {

     }];

【Description 】
	 Turn off device push
【Function】
    /**
     @param deviceID 
     @param enable (whether to close)
     @param success Successful callback 
     @param failure failure callback 
     */
      - (void)deviceAlarmNotificationEnable:(BOOL)enable deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;
【Code】
       [[MeariUser sharedInstance] deviceAlarmNotificationEnable:closed deviceID:self.camera.info.ID success:^{
        
       } failure:^(NSError *error) {
       
       }]

```

##4.6 Data model 

User-related data model.

```
【MeariUserInfo】
@property (nonatomic, strong) NSString * avatarUrl;     
@property (nonatomic, strong) NSString * nickName;     
@property (nonatomic, strong) NSString * userAccount;   
@property (nonatomic, strong) NSString * userID;       
@property (nonatomic, strong) NSString * loginTime;     
@property (nonatomic, strong) NSString * pushAlias;     // invalid
@property (nonatomic, strong) NSString * token;       
@property (nonatomic, strong) NSString * secrect;      
@property (nonatomic, strong) NSString * userKey;       
@property (nonatomic, strong) NSString * userName;    
@property (nonatomic, strong) NSString * countryCode;   
@property (nonatomic, strong) NSString * phoneCode;     
@property (nonatomic, assign) NSInteger loginType;      
@property (nonatomic, strong) NSString * appleID;      
@property (nonatomic, assign) BOOL notificationSound;  
@property (nonatomic, assign, readonly) MeariThirdLoginType thirdLoginType; 
```

#5.User message notification 

```
Timely message notification means MeariSDK notifies the current user on the App side and some status of the device under the user account in time to facilitate the App side to achieve a better user experience

【Notification type】See：MeariUser.h
    MeariUserLoginInvalidNotification     (Login information is invalid, you need to log in again)
    MeariDeviceCancelSharedNotification   (Device is unshared)
    MeariDeviceNewShareToMeNotification  （Someone shared his own device with me)
    MeariDeviceNewShareToHimNotification (Someone requested to share my device with him)
    MeariUserNoticeNotification           (Received notification announcement message)
    MeariDeviceUnbundlingNotification     (Device is unbound)
    MeariDeviceHasVisitorNotification     (The device (doorbell) has visitors)
    MeariDeviceHasBeenAnswerCallNotification  (The device (doorbell) has been answered)
    MeariIotDeviceOnlineNotification      (Meari iot device offline notification)
   
【Code】
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginInvalidNotification:) name:MeariUserLoginInvalidNotification object:nil];
```

#6.Device distribution network

```
Belong to: MeariDeviceActivator tool class

The hardware module of Meari Technology supports three network distribution modes: QR code network distribution mode, hotspot mode (AP mode), and wired network distribution mode.
The general process is-get the network tokon-give the token and wifi information to the device-wait for the device to be added successfully. The main difference between each mode is how to send the network distribution information to the device, the QR code is scanned by the camera, the hotspot mode is transmitted through the WIFI link, and the wired distribution network is searched through the LAN.

```
##6.1 Get distribution network token
```
【Description 】
     Obtain the distribution network token on the server, which needs to be passed to the device
【Function】
     /** 
      token for config device 
      @param success return  config dictionary
       token: config token 
       validTime: token invalid time The valid duration of the token, after the duration, a new token needs to be re-acquired
       delaySmart: user for smartwifi (Deprecated)
      @param failure 
     */
    - (void)getTokenSuccess:(MeariSuccess_Token2)success failure:(MeariFailure)failure;

【Code】
    [[MeariDeviceActivator sharedInstance] getTokenSuccess:^(NSString *token, NSInteger validTime, NSInteger delaySmart) {
        
    } failure:^(NSError *error) {

    }];

```
##6.2 QR code distribution network
```
【Description 】
     Generate a QR code with WIFI information and network distribution token and scan it for the device.
      After the device emits a cuckoo sound, it indicates that the recognition is successful, and the device will enter a red light flashing state
【Function】
     /**
      @param ssid wifi name
      @param password wifi password
      @param token code token
      @param size QR code size
      @param subDevice Sub device 
      @return QR code image
     */
     - (UIImage *)createQRCodeWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token addSubDevice:(BOOL)subDevice size:(CGSize)size;

【Code】
    UIImage *image = [[MeariDeviceActivator sharedInstance] createQRCodeWithSSID:@"Meari" pasword:@"12345678" token:token addSubDevice:NO size:CGSizeMake(300, 300)];

【Description 】
       Wait for the device to automatically add a successful message. It is recommended to manually query the device list to avoid the situation that the message is not delivered in time.
【Code】
    1.[MeariDeviceActivator sharedInstance].delegate = self;
    
     Implement proxy method
      - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
         NSLog(@"device --- netConnect  ------ %@ status -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
         if (deviceModel.info.addStatus == MeariDeviceAddStatusSelf) {
           NSLog(@"config success");
         }
      }

    2.Before scanning the QR code for the device, record the device in the device list first, and when waiting for the callback of the successful addition of the device, you can actively call the interface for obtaining the device list to check whether a new device has been added.
    
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];

    If you want to search for other devices in the LAN, you can call: 

    [MeariDeviceActivator sharedInstance].delegate = self;
    [[MeariDeviceActivator sharedInstance] startConfigWiFi:MeariSearchModeAll token:token type:MeariDeviceTokenTypeQRCode nvr:NO timeout:100];
	
    In the above proxy method, there will be devices in the local area network

    Stop LAN searching for other devices:
    [[MeariDeviceActivator sharedInstance] stopConfigWiFi];

```
##6.3 Hotspot distribution network (Ap distribution network)
```
【Description 】
     Generate a QR code with WIFI information and network distribution token, and transparently transmit it to the device through the hotspot WIFI.
      The mobile phone needs to be connected to the hotspot issued by the device, the hotspot prefix is STRN_xxxxxxxxx
      After the call is successful, the device will make a cuckoo sound, and then enter the blue light flashing state
【Function】
     /**
      @param ssid wifi name
      @param password wifi password
      @param token config token 
      @param success Successful callback 
      @param failure failure callback 
     */
    - (void)configApModeWithSSID:(NSString *)ssid password:(NSString *)password token:(NSString *)token relay:(BOOL)relayDevice success:(MeariSuccess)success failure:(MeariFailure)failure;
    - 
【Code】
     [[MeariDeviceActivator sharedInstance] configApModeWithSSID:@"Meari" password:@"12345678"  token:token relay:NO success:^{
        NSLog(@"device connect network success);
     } failure:^(NSError *error) {

     }];

【Description 】
       Wait for the device to automatically add a successful message. It is recommended to manually query the device list to avoid the situation that the message is not delivered in time.
       
【Code】
    1.[MeariDeviceActivator sharedInstance].delegate = self;
    
     Implement proxy method
      - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
         NSLog(@"device --- netConnect  ------ %@ status -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
         if (deviceModel.info.addStatus == MeariDeviceAddStatusSelf) {
           NSLog(@"config success");
         }
      }

    2.Before scanning the QR code for the device, record the device in the device list first, and when waiting for the callback of the successful addition of the device, you can actively call the interface for obtaining the device list to check whether a new device has been added.
    
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];

    If you want to search for other devices in the LAN, you can call: 

    [MeariDeviceActivator sharedInstance].delegate = self;
    [[MeariDeviceActivator sharedInstance] startConfigWiFi:MeariSearchModeAll token:token type:MeariDeviceTokenTypeQRCode nvr:NO timeout:100];
	
    In the above proxy method, there will be devices in the local area network

    Stop LAN searching for other devices:
    [[MeariDeviceActivator sharedInstance] stopConfigWiFi];

```
##6.4 Wired distribution network
```
【Description 】
     Make sure the device is plugged into the network cable, and the phone and device are in the same local area network
     Search for devices in the same local area network

【Function】
     /**
      @param mode search mode 
      @param success Successful callback 
      @param failure failure callback 
     */
     - (void)startSearchDevice:(MeariDeviceSearchMode)mode success:(MeariDeviceSuccess_SearchDevice)success failure:(MeariDeviceFailure)failure;
【Code】
	 // device.info.wireDevice == YES  Wired device
	 // device.info.wireConfigIp  The transparent transmission address of the wired device 
     [[MeariDeviceActivator sharedInstance] startSearchDevice:MeariSearchModeLan success:^(MeariDevice *device) {
      NSLog(@"device --- netConnect  ------ %@ status -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
        if (device.info.wireDevice) {
			
        }
      } failure:^(NSError *error) {
        
      }];

	 // Stop searching for LAN devices
    [[MeariDeviceActivator sharedInstance] stopSearchDevice];

【Description 】
     Query the adding status of the device to the server to filter some non-compliant devices
【Function】
     /**
      @param devices device array 
      @param success Successful callback 
      @param failure failure callback
     */
     - (void)checkDeviceStatus:(NSArray <MeariDevice *>*)devices success:(MeariSuccess_DeviceListForStatus)success failure:(MeariFailure)failure;
【Code】
      [[MeariDeviceActivator sharedInstance] checkDeviceStatus:@[device] success:^(NSArray<MeariDevice *> *devices) {
            for (MeariDevice *device in devices) {
                if (device.info.addStatus == MeariDeviceAddStatusNone){
                    NSLog(@"Device not added")
                }
             }
               
        } failure:^(NSError *error) {
                
       }];


【Description 】
     Transparently transmit the distribution network token to the device
【Function】
     /**
      @param ip ip address  
      @param token config token 
      @param success Successful callback 
      @param failure failure callback 
     */
      - (void)startConfigWireDevice:(NSString *)ip token:(NSString *)token success:(MeariSuccess)success failure:(MeariFailure)failure;
【Code】
     [[MeariDeviceActivator sharedInstance] startConfigWireDevice:device.info.wireConfigIp token:token success:^{
         NSLog(@"token success")
     } failure:^(NSError *error) {
           
     }];

【Description 】
     Wait for the device to automatically add a successful message. It is recommended to manually query the device list to avoid the situation that the message is not delivered in time.
【Code】
    1.[MeariDeviceActivator sharedInstance].delegate = self;
     Implement proxy method
      - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
         NSLog(@"device --- netConnect  ------ %@ status -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
         if (deviceModel.info.addStatus == MeariDeviceAddStatusSelf) {
           NSLog(@"config success");
         }
      }

    2.Before scanning the QR code for the device, record the device in the device list first, and when waiting for the callback of the successful addition of the device, you can actively call the interface for obtaining the device list to check whether a new device has been added.
    
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];
```
#7.Device information
```
Belong to:：MeariUser
```
##7.1 Get device list 
```
Belong to:：MeariDeviceList
```
```
【Description 】
     After the device is added, obtain the device list through the interface of the MeariUser tool class and return it in the form of a model
The device information is the info attribute of the device object (MeariDeviceInfo)

【Function】
    - (void)getDeviceListSuccess:(MeariSuccess_DeviceList)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

     } failure:^(NSError *error) {

     }];
```

MeariDeviceList Attributes：

```
/** Camera */
@property (nonatomic, strong) NSArray <MeariDevice *> *ipcs;
/** Bell */
@property (nonatomic, strong) NSArray <MeariDevice *> *bells;
/** Voice bell */
@property (nonatomic, strong) NSArray <MeariDevice *> *voicebells;
/** Battery Camera */
@property (nonatomic, strong) NSArray <MeariDevice *> *batteryIpcs;
/** floodlight Camera */
@property (nonatomic, strong) NSArray <MeariDevice *> *lights;
/** NVR */
@property (nonatomic, strong) NSArray <MeariDevice *> *nvrs;
/** Base */
@property (nonatomic, strong) NSArray <MeariDevice *> *chimes;
```
##7.2 Device Info

```
Belong to：MeariDevice
```
```
@property (nonatomic, strong) MeariDeviceInfo *info;                        //Device Information
@property (nonatomic, strong) MeariDeviceParam *param;                      //Device parameters
@property (nonatomic, assign, readonly, getter=isIpcCommon)BOOL ipcCommon;  
@property (nonatomic, assign, readonly, getter=isIpcBaby)BOOL ipcBaby;      
@property (nonatomic, assign, readonly, getter=isIpcBell)BOOL ipcBell;      
@property (nonatomic, assign, readonly, getter=isNvr)BOOL nvr;              
@property (nonatomic, assign)BOOL hasBindedNvr;                             
@property (nonatomic, assign, readonly)BOOL sdkLogined;                     //Is the device connected
@property (nonatomic, assign, readonly)BOOL sdkLogining;                    //Is the device being connected
@property (nonatomic, assign, readonly)BOOL sdkPlaying;                     //Is previewing
@property (nonatomic, assign, readonly)BOOL sdkPlayRecord;                  //Is it playing back
@property (nonatomic, strong)NSDateComponents *playbackTime;                //Current playback time
@property (nonatomic, assign, readonly)BOOL supportFullDuplex;              //Whether to support FullDuplex intercom
。。。
```
##7.3 Delete device 

```
【Description 】
     Delete device

【Function】
      /**
       @param type device type
       @param deviceID 
       @param success 
       @param failure 
     */
     - (void)deleteDeviceWithDeviceType:(MeariDeviceType)type deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] deleteDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:cell.camera.info.ID success:^{

     } failure:^(NSError *error) {

     }];
```

##7.4 Device nickname modification 

```
【Description 】
    Device nickname modification

【Function】
     /**
       @param type device type
       @param deviceID 
       @param nickname New nickname, length 6-20 digits
       @param success 
       @param failure
     */
     - (void)renameDeviceWithType:(MeariDeviceType)type deviceID:(NSInteger)deviceID nickname:(NSString *)nickname success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] renameDeviceWithType:MeariDeviceTypeIpc deviceID:self.camera.info.ID nickname:newNickName success:^{
    
     } failure:^(NSError *error) {
    
     }];
    
```

##7.5 Device alarm time point 

```
【Description 】
     Obtain the alarm time of a single device on a certain day
【Function】
     /**
      @param deviceID 
      @param date Date: The format is 20171212
      @param success Success callback: return to the alarm time list
      @param failure 
     */
     - (void)getAlarmMessageTimesWithDeviceID:(NSInteger)deviceID onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] getAlarmMessageTimesWithDeviceID:self.device.info.ID onDate:@"20171212" success:^(NSArray<NSString *> *time) {

     } failure:^(NSError *error) {

     }];
```

##7.6 Query device version 

```
【Description 】
     Check if the device has a new version

【Function】
     /**
      @param deviceSn device SN
      @param tp device tp
      @param currentFirmware Current version
      @param success Successful callback : Returns the latest version information of the device
      @param failure failure callback 
     */
     - (void)checkNewFirmwareWith:(NSString *)deviceSn tp:(NSString *)tp currentFirmware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirmware:self.currentVersion success:^(MeariDeviceFirmwareInfo *info) {
      
     } failure:^(NSError *error) {
    
     }];
```

MeariDeviceFirmwareInfo:

```
@property (nonatomic, copy) NSString *upgradeUrl;           //(Device upgrade address)
@property (nonatomic, copy) NSString *latestVersion;        //(The latest version of the device)
@property (nonatomic, copy) NSString *upgradeDescription;   //(Device Upgrade Description)
@property (nonatomic, assign) BOOL needUpgrade;             //(Whether need to upgrade)
@property (nonatomic, assign) BOOL forceUpgrade;            //(Whether need to be forced to upgrade)

```

##7.7 Query device online status 

```
【Description 】
     Only supports Meari's self-developed version of the device, ie [camera supportMeariIot] == YES.

【Function】
     /**
      @param device.info.sn
      @return Returns whether it is online 0 means less than the query 1 means online 2 means offline 3 means dormant
     */
     - (NSInteger)checkMeariIotDeviceOnlineStatus:(NSString *)deviceSN;
【Code】
     if ([camera supportMeariIot]) {
         NSInteger status = [[MeariUser  sharedInstance] checkMeariIotDeviceOnlineStatus:camera.info.sn];
        if (status == 0) {
            NSLog("The device does not support online status query");
        }else if (status == 1){
            NSLog("device online");
        }else if (status == 2){
            NSLog("device offline ");
        }else if (status == 3){
            //State only available for low-power devices camera.lowPowerDevice == YES
            NSLog("device dormancy");
        }
        
       //Listen for notifications of device online and offline
       [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOnlineChange:) name:MeariIotDeviceOnlineNotification object:nil];

       - (void)deviceOnlineChange:(NSNotification *)noti {
             NSDictionary *onlineDic = noti.object;
             NSString *deviceTag = onlineDic[@"deviceTag"];
             NSInteger status = [onlineDic[@"online"] integerValue];
            // ......

       }


```
##7.8 Remote wake up doorbell 

```
【Description 】
     Remote wake up doorbell

【Function】
     /**
      @param device  
      @param success  
      @param failure  
    */
    - (void)remoteWakeUpWithDevice:(MeariDevice *)device success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] remoteWakeUpWithDevice:device success:^{

     } failure:^(NSError *error) {

     }];
【Precautions】
     Doorbell low-power products (camera.lowPowerDevice == YES), you need to call the remote wake-up interface first, and then call the hole-punching interface
```

##7.9 Upload doorbell message 

```
【Description 】
      Upload doorbell message

【Function】
     /**
      @param deviceID  
      @param videoName Message name
      @param file Message file path
      @param success  
      @param failure  
     */
     - (void)uploadVoiceWithDeviceID:(NSInteger)deviceID videoName:(NSString *)fileName voiceFile:(NSString *)file success:(MeariSuccess_DeviceVoiceMsg)success failure:(MeariFailure)failure

【Code】
     [[MeariUser sharedInstance] uploadVoiceWithDeviceID:device.info.ID videoName:videoName voiceFile:filePath success:^(MeariDeviceHostMessage *msg) {
        
     } failure:^(NSError *error) {

     }];
```

##7.10 Download doorbell message 

```
【Description 】
     Download doorbell message Download the message to the specified location

【Function】
     /**
      @param voiceUrl Message address
      @param filePath Message local file path
      @param success Successful callback, return value: audio data
      @param failure 
     */
     - (void)downloadVoiceWithVoiceUrl:(NSString *)voiceUrl filePath:(NSString *)filePath success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
    [[MeariUser sharedInstance] downloadVoiceWithVoiceUrl:urlStr filePath:localPath success:^(void) {

    } failure:^(NSError *error) {
    
    }];
```

##7.11 Delete doorbell message 

```
【Description 】
     Delete doorbell message

【Function】
     /**
      @param deviceID  
      @param voiceID  
      @param success  
      @param failure  
     */
     - (void)deleteVoiceWithDeviceID:(NSInteger)deviceID voiceID:(NSString *)voiceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] deleteVoiceWithDeviceID:device.info.ID voiceID:voiceID success:^{

     } failure:^(NSError *error) {

     }];
```

#8.Device control
```
Belong to：MeariDevice
```
```
MeariDevice Responsible for all operations on the device, including preview, playback, settings, etc. For device settings, you need to ensure that the connection with the device has been established
```
##8.1 Connect the device 

```
【Description 】
     Before performing operations such as preview, playback, and settings on the device, you need to connect the device first

【Function】
     /**
      @param success Success callback
      @param disconnect Abnormal disconnection
      @param failure Failure callback
     */
     - (void)startConnectSuccess:(MeariDeviceSuccess)success abnormalDisconnect:(MeariDeviceDisconnect)disconnect failure:(MeariDeviceFailure)failure;

【Code】
     [self.device startConnectSuccess:^{

     } abnormalDisconnect:^{
     
     } failure:^(NSString *error) {

     }];
```

## 8.2 Disconnect device 

```
【Description 】
     When you do not need to operate the device, you need to disconnect the device

【Function】
     /**
      @param success  
      @param failure  
     */
     - (void)stopConnectSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code】
     [self.device stopConnectSuccess:^{

     } failure:^(NSString *error) {

     }];

```

## 8.3 Get bit rate

```
【Description 】
     Get the bit rate of the device

【Function】
     /**
      @return rate
     */
    - (NSString *)getBitrates;

【Code】
     [self.device getBitrates]
```


## 8.4 Preview 

```
【Description 】
   Get the resolution supported by the device 

【Code】
     NSArray *streamArray = [camera supportVideoStreams];
     The corresponding relationship is:
     MeariDeviceVideoStream_HD            ========   @"HD"
     MeariDeviceVideoStream_360           ========   @"SD"
     MeariDeviceVideoStream_240           ========   @"240P"
     MeariDeviceVideoStream_480           ========   @"480P"
     MeariDeviceVideoStream_720           ========   @"720P"
     MeariDeviceVideoStream_1080          ========   @"1080P",
     MeariDeviceVideoStream_1080_1_5      ========   @"1080P@1.5M"
     MeariDeviceVideoStream_1080_2_0      ========   @"1080P@2M"
     MeariDeviceVideoStream_3MP_1_2       ========   @"3MP@2M"
     MeariDeviceVideoStream_3MP_2_4       ========   @"3MP@4M"
     MeariDeviceVideoStream_NEW_SD        ========   @"0/NEW_SD/xxx"
     MeariDeviceVideoStream_NEW_HD        ========   @"1/NEW_HD/xxx"
     MeariDeviceVideoStream_NEW_FHD       ========   @"2/NEW_FHD/xxx"
     MeariDeviceVideoStream_NEW_UHD       ========   @"3/NEW_UHD/xxx"

【Description 】
    Take real-time streaming to the camera
	
【Function】
     /**
      @param playView Play view control
      @param videoStream 
      @param success 
      @param failure 
      @param close In sleep mode, the lens is off, return value: sleep mode
    */
    - (void)startPreviewWithPlayView:(MeariPlayView *)playView videoStream: (MeariDeviceVideoStream)videoStream success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure close:(void(^)(MeariDeviceSleepMode sleepModeType))close;


    /**
    Stop previewing device

    @param success  
    @param failure  
    */
    - (void)stopPreviewSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
    Switch resolution

    @param playView  
    @param videoStream  
    @param success  
    @param failure  
    */
    - (void)changeVideoResolutionWithPlayView:(MeariPlayView *)playView videoStream:(MeariDeviceVideoStream)videoStream success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
     //create MeariPlayView
      MeariPlayView *playView = [[MeariPlayView alloc] initWithFrame:CGRectMake(0, 0,160, 90];

     //Start preview device
     [camera startPreviewWithView:playView videoStream:videoStream  success:^{

     } failure:^(NSString *error) {

     } close:^(MeariDeviceSleepmode sleepmodeType) {

     }];

     //Stop preview device
     [camera stopPreviewSuccess:^{

     } failure:^(NSString *error) {

     }];

     //Switch resolution
     [camera switchPreviewWithView:self.drawableView videoStream:videoStream success:^{

     } failure:^(NSString *error) {

     }];
```


## 8.5 Play back

```
【Description 】
     Play back the video of the camera
     Note: The SDK does not verify the playback time, so even if a time point without alarm is passed in, the interface will return success, so the upper layer needs to judge by itself

【Function】
     /**
     Get the number of video days in a month

     @param year  
     @param month  
     @param success Success callback, return value: json array--[{"date" = "20171228"},...]
     @param failure  
     */
     - (void)getPlaybackVideoDaysInMonth:(NSInteger)month year:(NSInteger)year success:(MeariDeviceSuccess_PlaybackDays)success failure:(MeariDeviceFailure)failure;


     /**
     Get a video clip of a certain day

     @param year  
     @param month  
     @param day  
     @param success Success callback, return value: json array--[{"endtime" = "20171228005958","starttime = 20171228000002"},...]
     @param failure  
     */
     - (void)getPlaybackVideoTimesInDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year success:(MeariDeviceSuccess_PlaybackTimes)success failure:(MeariDeviceFailure)failure;

     /**
     Start playback video: Only one person can view playback video at the same time on the same device

     @param playView  
     @param startTime Start time: The format is 20171228102035
     @param success  
     @param failure  
    */
     - (void)startPlackbackSDCardWithPlayView:(MeariPlayView *)playView startTime:(NSString *)startTime success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


     /**
     Stop playback

     @param success  
     @param failure  
     */
     - (void)stopPlackbackSDCardSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


     /**
     Play from a certain time: This interface can only be used after the playback is successful, otherwise it will fail

     @param seekTime Start time: The format is 20171228102035
     @param success  
     @param failure  
     */
    - (void)seekPlackbackSDCardWithSeekTime:(NSString *)seekTime success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


     /**
     Pause playback

     @param success  
     @param failure  
     */
     - (void)pausePlackbackSDCardSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


     /**
     Resume playback

     @param success  
     @param failure  
     */
     - (void)resumePlackbackSDCardSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Get video days
     [device getPlaybackVideoDaysWithYear:year month:month success:^(NSArray *days) {
 
     } failure:^(NSString *error) {

     }];

     //Get the video duration of a certain day
     [device getPlaybackVideoTimesWithYear:year month:month day:day success:^(NSArray *times) {

     } failure:^(NSString *error) {

     }];


     //Start playback of video
     [device startPlackbackSDCardWithPlayView:playview startTime:starttime success:^{
 
     } failure:^(NSString *error) {
        if (error.code == MeariDeviceCodePlaybackIsPlayingByOthers) {
            NSLog(@"Others are watching the replay")
        }
     }];

     //Stop playback
     [self.device stopPlackbackSDCardSuccess:^{
	
      } failure:^(NSString *error) {
	
      }];

     //seek playback
     [device seekPlackbackSDCardToTime:self.currentComponents.timeStringWithNoSprit success:^{

     } failure:^(NSString *error) {

     }];

     //Pause playback
     [device pausePlackbackSDCardSuccess:^{

     } failure:^(NSString *error) {

     }];

     //Continue playback
     [device resumePlackbackSDCardSuccess:^{
 
     } failure:^(NSString *error) {

     }];
```
## 8.6 Cloud Play back 
```
【Description 】
     After the device activates the cloud storage service, the records will be stored in the cloud.

【Function】

     /**
       Get the number of cloud playback days in a month
      @param monthComponents  obtain month(NSDateComponents *)  
      @param success Successful callback  
      @param failure failure callback 
     */
     - (void)getCloudVideoDaysWithMonthComponents:(NSDateComponents *)monthComponents success:(void(^)(NSArray <MeariDeviceTime *> *days))success failure:(MeariDeviceFailure)failure;

     /**
       Get cloud play minutes of a certain day
       @param dayComponents   time(NSDateComponents *)  
       @param success Successful callback  
       @param failure failure callback  
     */
     - (void)getCloudVideoMinutesWithDayComponents:(NSDateComponents *)dayComponents success:(void(^)(NSArray <MeariDeviceTime *> *mins))success failure:(MeariDeviceFailure)failure;
   

     /**
       Get cloud playback video files - only half an hour validity period
       @param startTime startTime(NSDateComponents *)  
       @param endTime endTime(NSDateComponents *)   
       @param success Successful callback  
       @param failure failure callback  
      */
      - (void)getCloudVideoWithStartTime:(NSDateComponents *)startTime endTime:(NSDateComponents *)endTime success:(void(^)(NSURL *m3u8Url))success failure:(MeariDeviceFailure)failure;

【Code】
      //Get the number of days in the cloud storage in the month
      NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
      dateComponents.year = 2021;
      dateComponents.month = 7;
      [device getCloudVideoDaysWithMonthComponents: dateComponents success:^(NSArray<MeariDeviceTime *> *days) {
	 	//Get the date of cloud storage recording
      } failure:^(NSError *error) {
        
      }];

     //Get cloud storage video clips in a certain day

      NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
      dateComponents.year = 2021;
      dateComponents.month = 7;
      dateComponents.day = 1;
      [device getCloudVideoMinutesWithDayComponents:^(NSArray<MeariDeviceTime *> *mins)
         //Get videos with cloud storage videos times
      } failure:^(NSError *error) {
   
      }];

		
	  // Obtain the m3u8 url of the specific fragment in 24-hour format
     // The time is half an hour apart. For example: 12:00-12:30, 13:30-14:00
     // The m3u8 file is only valid for half an hour, and it will automatically expire after expiration.
      NSDateComponents * startTime = [[NSDateComponents alloc]init];
      startTime.year = 2021;
      startTime.month = 7;
      startTime.day = 1;
      startTime.hour = 12;
      startTime.minute = 0;

      NSDateComponents *endTime = [[NSDateComponents alloc]init];
      endTime.year = 2021;
      endTime.month = 7;
      endTime.day = 1;
      endTime.hour = 12;
      endTime.minute = 30;

      [self.camera getCloudVideoWithStartTime:startTime endTime:endTime success:^(NSURL *m3u8Url) {
		
      } failure:^(NSError *error) {
        
      }];

【Description 】
      Cloud playback player, used to play m3u8 files, support playback, recording, Seek and other operations
【Function】
      MeariCloudPlayer   
      /**
      init

      @param url video url  m3u8 file
      @param startTime start time  The time format is 20171228102035
      @param superView super view 
      @return MeariPlayer
      */
      - (instancetype)initWithURL:(NSURL *)url startTime:(NSString *)startTime superView:(UIView *)superView;

     @property (atomic, strong, readonly) id<IJKMediaPlayback> meariPlayer; // player   
     @property (nonatomic, weak) id<meariCloudDelegate> delegate; // delegate  
     @property (nonatomic, assign, readonly) MeariCloudStatus playState; // play state  
     @property (nonatomic, assign, readonly) MeariCloudRecordState recordState; // record state 

     @property (nonatomic, assign, readonly, getter = isPlaying) BOOL playing; // Whether it is playing  
     @property (nonatomic, assign) BOOL muted; // mute  

     - (BOOL)snapToPath:(NSString *)path; // Screenshot path : save path 
     - (BOOL)startRecord:(NSString *)path; // Record path : save path  
     - (void)stopRecord; //End recording  
     - (void)play; // start play  
     - (void)stop; // stop play  
     - (void)pause; // pause  
     - (void)shutdown; // Turn off playback  
     - (void)hidePlayer; // hide  player 
     - (void)playVideoAtTime:(NSString *)time url:(NSURL *)url;  // Play video at a certain time  
     - (NSTimeInterval)getVideoCurrentSecond;    // Current playback time (unit: second)  
     - (NSTimeInterval)getVideoDuration;         // Duration (unit: second)   

【Code】
      
      self.cloudPlayer = [[MeariCloudPlayer alloc] initWithURL:m3u8 startTime:@"20210701102035" superView:displayView];
      self.cloudPlayer.delegate = self;


```
## 8.7 Mute

```
【Description 】
     Set mute

【Function】
      /**
      @param muted muted
      */
     - (void)setMute:(BOOL)muted;

【Code】
     //Set mute
     [self.device setMute:NO];

```

## 8.8 Voice intercom 


```
【Description 】
    Voice intercom is divided into one-way intercom and two-way intercom, one-way intercom can only have one party talking at the same time.
    
【Be applicable】
	[device supportFullDuplex] == YES Support two-way intercom
	
	[device supportFullDuplex] == NO  Support one-way intercom

【Function】

	/**
     Set the type of voice intercom

     @param type intercom type
    */
    - (void)setVoiceTalkType:(MeariVoiceTalkType)type;

    /**
      return current voice talk type
    */
    - (MeariVoiceTalkType)getVoiceTalkType;

    /**
      Get real-time volume of voice intercom
      @return 0-1.0
    */
    - (CGFloat)getVoicetalkVolume;


    /**
     Start voice intercom
     @param isVoiceBell  
     @param success  
     @param failure  
    */
    - (void)startVoiceTalkWithIsVoiceBell:(BOOL)isVoiceBell success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;


    /**
      Stop voice intercom

      @param success  
      @param failure  
     */
    - (void)stopVoicetalkSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
	  //Set the voice intercom type Set according to the supported type
      MeariVoiceTalkType type = self.camera.supportFullDuplex ?  MeariVoiceTalkTypeFullDuplex : MeariVoiceTalkTypeOneWay;

     //Get real-time volume of voice intercom
     [self.camera getVoicetalkVolume]
     //Turn on the speaker
     [self.camera enableLoudSpeaker:YES];

     //Start voice intercom
     [self.camera startVoiceTalkWithIsVoiceBell:NO success:^{

     } failure:^(NSString *error) {

     }];


     //Stop voice intercom
     [self.camera stopVoicetalkSuccess:^{
 
     } failure:^(NSString *error) {

     }];  
     //Set up
     [self.camera setVoiceTalkType:MeariVoiceTalkTypeOneWay];

```

## 8.9 Screenshots 

```
【Description 】
     Capture video pictures

【Function】

    /**
     @param path The path where the picture is saved
     @param isPreviewing  
     @param success  
     @param failure  
    */
     - (void)snapshotWithSavePath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code】
     [self.camera snapshotToPath:snapShotPath isPreviewing:NO success:^{

     } failure:^(NSString *error) {

     }];

```


## 8.10 Video

```
【Description 】
   Video recording

【Function】
    /**
     Start recording

     @param path The path where the video is saved
     @param isPreviewing  
     @param success  
     @param failure  
    */
    - (void)startRecordMP4WithSavePath:(NSString *)path isPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


    /**
     Stop recording

     @param isPreviewing  
     @param success  
     @param failure  
    */
    - (void)stopRecordMP4WithIsPreviewing:(BOOL)isPreviewing success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Start recording
     [self.camera startRecordMP4ToPath:path isPreviewing:NO success:^{

     } failure:^(NSString *error) {

     }];

     //Stop recording
     [self.camera stopRecordMP4IsPreviewing:_isPreviewing success:^{

     } failure:^(NSString *error) {

     }];

```

## 8.11 Get all the parameters of the device

```
【Description 】
     Get the parameters of the device, you must get the device parameters before operating the device

【Function】
     /**
      @param success  
      @param failure  
     */
     - (void)getDeviceParamsSuccess:(MeariDeviceSuccess_Param)success failure:(MeariDeviceFailure)failure;
【Code】
    [device getParamsSuccesss:^(WYCameraParams *params) {

    } failure:^(NSString *error) {

    }];
```

## 8.12 PTZ control 

```
【Description 】
     Rotate the camera, after starting the rotation, you need to call the Stop command to stop.

【Function】
     /**
      @param direction Direction of rotation
      @param success  
      @param failure  
     */
     - (void)startPTZControlWithDirection:(MeariMoveDirection)direction success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


     /**
      Stop turning the camera
      @param success  
      @param failure  
     */
     - (void)stopMoveSuccess:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code】

    //Start turning
    [self.camera startPTZControlWithDirection:MeariMoveDirectionUp success:^{

    } failure:^(NSString *error) {

    }];

    //Stop spinning
    [self.camera stopMoveSuccess:^{

    } failure:^(NSString *error) {

    }];

```
## 8.13 Leave message
```
【Description 】
     The doorbell device supports recording of messages, and you can choose to play the message when answering.
【Be applicable】
     Doorbell  
     camera.supportHostMessage == MeariDeviceSupportHostTypeNone  Does not support the message function
     camera.supportHostMessage == MeariDeviceSupportHostTypeOne   Support a message up to 30 seconds
     camera.supportHostMessage == MeariDeviceSupportHostTypeMultiple  Support 3 messages, each of up to 10 seconds

【Description 】
	 Get device message list
【Function】
     /**
      @param success (Successful callback, the URL address of the file containing the message)
      @param failure failure callback  
     */
    - (void)getVoiceMailListSuccess:(MeariDeviceSuccess_HostMessages)success failure:(MeariDeviceFailure)failure;
【Code】 
     [self.camera getVoiceMailListSuccess:^(NSArray *list) {

     } failure:^(NSError *error) {

     }];


【Description 】
     To start recording a message, you need to obtain microphone permissions.
【Function】
     /**
      @param path  E.g: /var/mobile/Containers/Data/Application/98C4EAB7-D2FF-4519-B732-BEC7DE19D1CE/Documents/audio.wav  warning!!, it must be .wav format (Note!!! The file must be in wav format)
     */
    - (void)startRecordVoiceMailWithPath:(NSString *)path;
【Code】 
	  [camera startRecordVoiceMailWithPath:@"xxxx/record.wav"];

【Description 】
     End recording
【Function】
      /**
       @param success Return message file path
      */
     - (void)stopRecordVoiceMailSuccess:(MeariDeviceSuccess_RecordAutio)success;
【Code】 
     [camera startRecordVoiceMailWithPath:@"xxxx/record.wav"];
【Description 】
     Mobile phone playback and recording
【Function】
     /**
      @param filePath message file path(Message file path)
      @param finished  
     */
     - (void)startPlayVoiceMailWithFilePath:(NSString *)filePath finished:(MeariDeviceSuccess)finished;

【Code】 
     [camera startPlayVoiceMailWithFilePath:@"xxxx/record.wav" finished:^{
          
      }];

【Description 】
    After pressing the doorbell, control the device to play the message

【Function】
    /**

    @param success  
    @param failure  
    */
    - (void)makeDeivcePlayVoiceMail:(MeariDeviceHostMessage *)hostMessage success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】 
    //Control the device to play messages 
    [camera makeDeivcePlayVoiceMail:model success:^{

    } failure:^(NSError *error) {

    }]

```

## 8.14 Detect alarm 

```
【Description 】
     Motion detection settings 
【Be applicable】
     General non-low power camera
     It can be judged by device.info.capability.caps.md == YES
【Function】
     /**
     Set alarm level

     @param level  
     @param success  
     @param failure  
     */
     - (void)setMotionDetectionLevel:(MeariDeviceLevel)level successs:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
      
     [self.camera setMotionDetectionLevel:level successs:^{

     } failure:^(NSString *error) {
 
     }];

【Description 】
     Set the doorbell single PIR (human detection) alarm type)
【Be applicable】
     General low-power camera
     It can be judged by device.supportPir == YES
     Get the Pir level supported by the device through device.supportPirSensitivity
	
【Function】
     /**
     @param level alarm level  
     @param success Successful callback  
     @param failure failure callback  
     */
    - (void)setPirDetectionLevel:(MeariDeviceLevel)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
     [self.camera setPirDetectionLevel:level successs:^{

     } failure:^(NSString *error) {
 
     }];

```


## 8.14 Storage (SD card)

```
【Description 】
     Information acquisition and formatting of the memory card
【Function】
     /**
     Get memory card information
 
     @param success Success callback, return storage information
     @param failure  
     */
     - (void)getSDCardInfoSuccess:(MeariDeviceSucess_Storage)success failure:(MeariDeviceFailure)failure;

     /**
      Format the memory card

      @param success  
      @param failure 
     */
     - (void)formatSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

     /**
      Get the memory card formatting percentage
      @param success Success callback, return formatting percentage
      @param failure  
     */
     - (void)getFormatPercentSuccesss:(MeariDeviceSucess_StoragePercent)success failure:(MeariDeviceFailure)failure;

【Code】
     //Get storage information
     [device getSDCardInfoSuccess:^(MeariDeviceParamStorage *storage) {

     } failure:^(NSString *error) {

     }];

     //Format the memory card
     [device startSDCardFormatSuccess:^{

     } failure:^(NSString *error) {

     }];

     //Get formatting percentage
     [device getSDCardFormatPercentSuccess:^(NSInteger percent) {

     } failure:^(NSString *error) {

     }];
 
```

## 8.15 Firmware upgrade

```
【Description 】
     Check if the latest version is available from the server
【Function】
     /**
      @param deviceSn  
      @param tp  
      @param currentFirmware  
      @param success Successful callback 
      @param failure failure callback  
     */
     - (void)checkNewFirmwareWith:(NSString *)deviceSn tp:(NSString *)tp currentFirmware:(NSString *)currentFirmware success:(MeariSuccess_DeviceFirmwareInfo)success failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] checkNewFirmwareWith:self.camera.info.sn tp:self.camera.info.tp currentFirmware:version success:^(MeariDeviceFirmwareInfo *info) {
         NSLog(@"Does it need to be upgraded, is it mandatory to upgrade, the latest version");
     } failure:^(NSError *error) {

     }];

【Description 】
      To obtain and upgrade the firmware information, click the upgrade device and the upgrade operation will be carried out immediately
【Function】

     /**
      Get the current firmware version of the device

      @param success  
      @param failure  
     */
     - (void)getFirmwareVersionSuccess:(MeariDeviceSucess_Version)success failure:(MeariDeviceFailure)failure;


     /**
      Get the latest version of the current firmware of the device

      @param success Successful callback  
      @param failure failure callback  
    */
     - (void)getDeviceLatestVersionSuccess:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;

    /**
     Get the firmware upgrade percentage

     @param success  
     @param failure  
    */
    - (void)getDeviceUpgradePercentSuccess:(MeariDeviceSucess_VersionPercent)success failure:(MeariDeviceFailure)failure;


    /**
     Upgrade firmware

     @param url Firmware package address
     @param currentVersion Current firmware version  
     @param success  
     @param failure  
    */
    - (void)startDeviceUpgradeWithUrl:(NSString *)url currentVersion:(NSString *)currentVersion successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code】
     // Check if you need to upgrade
     [[MeariUser sharedInstance] checkNewFirmwareWith:self.camera.info.sn tp:self.camera.info.tp currentFirmware:version success:^(MeariDeviceFirmwareInfo *info) {
         NSLog(@"Does it need to be upgraded, is it mandatory to upgrade, the latest version");
     } failure:^(NSError *error) {

     }];

     //Get the current firmware version of the device
     [device getDeviceLatestVersionSuccess:^(Dictionary *dic) {

     } failure:^(NSError *error) {

     }];

     //Upgrade firmware
     [device upgradeWithUrl:upgradeUrl currentVersion:version successs:^{

     } failure:^(NSError *error) {

     }];

     //Get the firmware upgrade percentage
     [device getUpgradePercentSuccesss:^(NSInteger totalPercent, NSInteger downloadPercent, NSInteger updatePercent) {

     } failure:^(NSError *error) {

     }];

	 //Check the latest version of the device to assist in verifying whether the upgrade is successful
     [device getDeviceLatestVersionSuccess:^(NSDictionary *dict) {
     
     } failure:^(NSError *error) {

     }];
        

```
## 8.16 Sleep mode 

```
【Description 】
     Set different modes to control the device lens
     MeariDeviceSleepmodeLensOn ： Lens open
     MeariDeviceSleepmodeLensOff ： Lens off
     MeariDeviceSleepmodeLensOffByTime ： The lens is closed by time period
     MeariDeviceSleepmodeLensOffByGeographic ： The lens is closed based on geographic location

【Function】
     /**
      Set sleep mode

      @param type Sleep mode
      @param success  
      @param failure  
     */
     - (void)setSleepmodeType:(MeariDeviceSleepmode)type successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

     /**
      Set sleep time period

      @param open  
      @param times Sleep time period
      @param success  
      @param failure  
     */
     - (void)setSleepModeTimesOpen:(BOOL)open times:(NSArray <MeariDeviceParamSleepTime *>*)times successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

     /**
      Set up geofencing
	
      @param ssid  
      @param bssid  
      @param deviceID  
      @param success  
      @param failure  
      */
      - (void)setGeofenceWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     //Set sleep mode
     [self.camera setSleepmodeType:model.type successs:^{

     } failure:^(NSError *error) {

     }];

     //Set sleep time period
     [self.camera setSleepModeTimesOpen:open times:timesArr successs:^{

     }failure:^(NSError *error) {

     }];
    
     //Set WiFi information
     [[MeariUser sharedInstance] setGeofenceWithSSID:(NSString *)ssid BSSID:(NSString *)bssid deviceID:(NSInteger)deviceID success:^(NSString *str){
	
     } failure:^(NSError *error){

     }];
    
```


## 8.17 Temperature and humidity 

```
【Description 】
      Get all parameter information of the device

【Function】

     /**
     Get temperature and humidity
 
     @param success Successful callback, return value: temperature and humidity
     @param failure  
     */
     - (void)getTemperatureHumiditySuccess:(MeariDeviceSucess_TRH)success failure:(MeariDeviceFailure)failure;

【Code】
     [self.camera getTemperatureHumiditySuccess:^(CGFloat temperature, CGFloat humidty) {

     } failure:^(NSError *error) {
         if (error.code == MeariDeviceCodeNoTemperatureAndHumiditySensor) {
         //No temperature and humidity sensor
         }else {

         }
     }];
```


## 8.18 Music 

```
【Description 】
     Get the music status of the device, control the device to play music, you need a memory card to play

【Function】

     /**
      play music

      @param musicID  
      @param success  
      @param failure  
     */
     - (void)playMusicWithMusicID:(NSString *)musicID successs:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


     /**
      Pause music

      @param success  
      @param failure  
     */
     - (void)pauseMusicWithMusicID:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

     /**
      Play next song

      @param success  
      @param failure  
     */
     - (void)playNextMusicWithMusicID:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


     /**
      Play previous song

      @param success  
      @param failure  
     */
     - (void)playPreviousMusicSuccesss:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;


     /**
      Get music status: including playing and downloading status

      @param success Success callback, return value: json dictionary
      @param failure Failure callback
     */
     - (void)playPreviousMusicWithMusicID:(MeariDeviceSucess_MusicStateAll)success failure:(MeariDeviceFailure)failure;

     /**
      (Get music status: including playing and downloading status)
 
      @param success (Success callback), (Return value: json dictionary)
      @param failure  
     */
     - (void)getPlayMusicStatus:(MeariDeviceSuccess_MusicStateAll)success failure:(MeariDeviceFailure)failure;

【Code】
 
    [self.camera playMusicWithMusicID:musicID successs:^{
    
    } failure:^(NSError *error) {

    }];

    [self.camera pauseMusicWithMusicID:^{

    } failure:^(NSError *error) {

    }];

    [self.camera playNextMusicWithMusicID:^{

    } failure:^(NSError *error) {

    }];

    [self.camera playPreviousMusicSuccesss:^{

    } failure:^(NSError *error) {

    }];

    [self.camera getPlayMusicStatus:^(NSDictionary *allMusicState) {

    } failure:^(NSError *error) {

    }];

```


## 8.19 Device volume 

```
【Description 】
     Obtaining and setting the output music volume of the device

【Function】

     /**
      Get the output volume of the music camera

      @param success Successful callback, return value: device output volume, 0-100
      @param failure  
     */
      - (void)getMusicOutputVolumeSuccess:(MeariDeviceSucess_Volume)success failure:(MeariDeviceFailure)failure;


     /**
      Set device output volume

      @param volume Volume, 0-100
      @param success  
      @param failure  
     */
      - (void)setMusicOutputVolume:(NSInteger)volume success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Get device music output volume
     [self.camera getMusicOutputVolumeSuccess:^(CGFloat volume) {

     } failure:^(NSError *error) {

     }];

     //Set the device music output volume
     [self.camera setMusicOutputVolume:volume successs:^{

     } failure:^(NSError *error) {

     }];
```


## 8.20 Doorbell volume

```
【Description 】
    Obtaining and setting doorbell output volume
 
【Function】
    /**
    Set doorbell output volume

    @param volume  
    @param success  
    @param failure  
    */
    - (void)setSpeakVolume:(NSInteger)volume success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Set doorbell output volume
    [self.camera setSpeakVolume:roundf(slider.value) success:^{

    } failure:^(NSError *error) {

    }];
```
## 8.21 Bell settings 

```
【Description 】
     Set up wireless bell

【Function】
     /**	 
      @param volumeType  
      @param selectedSong  
      @param repeatTimes  
      @param success  
      @param failure  
	 */
     - (void)setWirelessChimeVolumeLevel:(MeariDeviceLevel)volumeLevel selectedSong:(NSString *)selectedSong repeatTimes:(NSInteger)repeatTimes success:(MeariDeviceSucess_ID)success failure:(MeariDeviceFailure)failure;

【Code】
     //Set up wireless bell
     [self.camera setWirelessChimeVolumeLevel: MeariDeviceLevelLow selectedSong:@"song1" repeatTimes:_repeatTimes success:^(id obj) {

     } failure:^(NSError *error) {

     }];
【Description 】
     Wireless bell pairing Please refer to the specific instructions for how to operate the bell device

【Function】
     /**
       Doorbell and bell pairing
       @param success  
       @param failure  
     */
     - (void)bindWirelessChime:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Bind wireless bell
     [self.camera bindWirelessChime:^{

     } failure:^(NSError *error) {

     }];
【Description 】
     Please refer to the specific instructions for how to operate the wireless bell device

【Function】
     /**
       Untie the doorbell from the bell
       @param success  
       @param failure  
     */
     - (void)unbindWirelessChime:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Bind wireless bell
     [self.camera unbindWirelessChime:^{

     } failure:^(NSError *error) {

     }];
```
## 8.22 Floodlight camera settings

### (1) Switch lights

```
【Description 】
     Control the light switch
  

【Function】
     /**
	
	  @param on  
	  @param success  
	  @param failure  
	 */
	 - (void)setFloodCameraLampOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure; 


【Code】
	 //Set the light switch
     [self.camera setFloodCameraLampOn:isOn success:^{
     
     } failure:^(NSError *error) {
	
     }];
```

### (2) Sound alarm switch

```
【Description 】
     The switch of the alarm is controlled by the device to achieve the function of warning
    
【Function】
	 /**
	
	  @param on 
	  @param success  
	  @param failure  
	 */
	 - (void)setFloodCameraSirenOn:(BOOL)on success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;     

【Code】
 
     [weakSelf.camera setFloodCameraSirenOn:NO success:^{

     } failure:^(NSError *error) {
  
     }];

```

### (3) Turn on the lights according to the time period

```
【Description 】
	 Set a time period for the device. When the device is in the set time period, the device will turn on the light, and when the time is up, the control light will turn off
    
【Function】
     /**
	
	  @param on  
	  @param fromDateStr  
	  @param toDateStr  
	  @param success  
	  @param failure  
	 */
	 - (void)setFloodCameraScheduleOn:(BOOL)on fromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;   

【Code】
     [self.camera setFloodCameraScheduleOn:self.lightSwitch.isOn fromDate:_timeArray[0] toDate:_timeArray[1]  success:^{

    } failure:^(NSError *error) {
 
    }];
```

### (4) Switch lights on and off according to alarm events

```
【Description 】
    Turn on the movement alarm and turn on the light, and the device will detect the movement of the human body and turn on the light, and then turn it off after a period of time.
    
【Function】
     /**
	
	   @param on  
	   @param level Lighting time corresponding to different levels MeariDeviceLevelLow: 20s, MeariDeviceLevelMedium: 40s, MeariDeviceLevelHigh: 60s
	   @param success 
	   @param failure  
	 */
	 - (void)setFloodCameraLampOnDuration:(BOOL)on durationLevel:(MeariDeviceLevel)level success:(MeariDeviceSucess)success failure:(MeariDeviceFailure)failure;   

【Code】

     NSInteger durationTime = [duration integerValue];
     MeariDeviceLevel level =  MeariDeviceLevelLow;
     if (durationTime == 20) {
         level = MeariDeviceLevelLow;
     }else if (durationTime == 40) {
         level = MeariDeviceLevelMedium;
     }else  if (durationTime == 60){
        level = MeariDeviceLevelHigh;
     }
     [self.camera setFloodCameraLampOnDuration:isOn durationLevel:level success:^{

     } failure:^(NSError *error) {

     }];
```


# 9.Share Device
```
Belong to: MeariUser

    You can share your device with other users, and you can view the camera after the other users agree. The shareee will receive MQTT messages and APNS push notifications.

```
```
【Description 】
     Get the shared list of a single device
【Function】
     /**
      Get device sharing list
      @param deviceID (device ID) 
      @param success Successful callback  
      @param failure failure callback  
     */
     - (void)getShareListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_ShareList)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] getShareListForDeviceWithDeviceID:camera.info.ID success:^(NSArray<MeariFriendInfo *> *friends) {
            
     } failure:^(NSError *error) {

     }];

【Description 】
     Cancel device share
【Function】
     /**
      @param deviceID (device ID) 
      @param success Successful callback 
      @param failure failure callback  
     */
     - (void)cancelShareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] cancelShareDeviceWithDeviceID:camera.info.ID success:^{
            
     } failure:^(NSError *error) {

     }];

【Description 】
     Share the device to other users and set permissions (you can realize the function display of different permissions by yourself)
【Function】
     /**
      @param deviceID  
      @param shareAccount  
      @param authSign Sharing authority identification 0 means that only can be viewed 1 means that it can be controlled
      @param success Successful callback  
      @param failure failure callback  
     */
     - (void)shareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount authSign:(NSInteger)authSign success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] shareDeviceWithDeviceID:camera.info.ID shareAccount:@"test@meari.com" authSign:0 success:^{
            
     } failure:^(NSError *error) {

     }];

【Description 】
     Modify the permissions of the shared person
【Function】
     /**
      @param deviceID 
      @param shareAccount  
      @param authSign Sharing authority identification 0 means that only can be viewed 1 means that it can be controlled
      @param success Successful callback  
      @param failure failure callback  
     */
     - (void)changeShareDeviceWithDeviceID:(NSInteger)deviceID shareAccount:(NSString *)shareAccount authSign:(NSInteger)authSign success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] changeShareDeviceWithDeviceID:camera.info.ID shareAccount:@"test@meari.com" authSign:1 success:^{
            
     } failure:^(NSError *error) {

     }];


【Description 】
     Search for users
【Function】
     /**
      @param deviceID  
      @param userAccount  
      @param success Successful callback  
      @param failure failure callback  
     */
     - (void)searchUserWithDeviceID:(NSInteger)deviceID account:(NSString *)userAccount success:(MeariSuccess_Share)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] searchUserWithDeviceID:camera.info.ID shareAccount:@"test@meari.com" success:^(MeariShareInfo *shareInfo){
            
     } failure:^(NSError *error) {

     }];

【Description 】
     Get the shared results of all devices
【Function】
     /**
    
      @param success 
      @param failure 
     */
     - (void)getAllDeviceShareSuccess:(MeariSuccess_ShareCameraInfo)success failure:(MeariFailure)failure;

【Code】
      [[MeariUser sharedInstance] getAllDeviceShareSuccess:^(NSArray<MeariShareCameraInfo *> *shareCameraList) {

      } failure:^(NSError *error) {

      }];

【Description 】
      Ask others to share his device with you. For example, when a device of another person is found in the local area network, you can request to share the device of another person with yourself.
      The requested account will receive MQTT notification and APNS message prompt
【Function】
     /**
     @param deviceID  
     @param success Successful callback  
     @param failure failure callback  
     */
     - (void)requestShareDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] requestShareDeviceWithDeviceID:device.info.ID success:^{
      
     } failure:^(NSError *error) {
       
     }];

【Description 】
	 Processing the shared message, you can accept or reject it.
【Function】
     /**
       @param msgID  
       @param sign  
       @param accept  
       @param success  
       @param failure  
     */
     - (void)dealShareMsgWithMsgID:(NSString *)msgID shareAccessSign:(NSInteger)sign accept:(BOOL)accept success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] dealShareMsgWithMsgID:msgID shareAccessSign:sign accept:accept success:^{
        
     } failure:^(NSError *error) {
        
     }];

【Description 】
     Can monitor App internal notification messages 

     MeariDeviceCancelSharedNotification   (Device cancel unshared)
     MeariDeviceNewShareToMeNotification   (Someone shared his own device with me)
     MeariDeviceNewShareToHimNotification  (Someone requested to share my device with him)

```
	 


#10.Message Center 

```
Belong to：MeariMessageInfo
```
```
Note: The alarm message of the device, once pulled by the owner of the device, the server will delete the message, so it needs to be saved locally. If the person being shared pulls the alarm message of the device, the server will not delete it. Pay attention to the owner and being shared here. The difference between people
```
##10.1 Get whether all devices have messages 

```
【Description 】
    Get whether all devices have messages
    belong to：MeariMessageInfoAlarm

【Function】
       /**
     @param success 
     @param failure
    */
    - (void)getAlarmMessageListSuccess:(MeariSuccess_MsgAlarmList)success failure:(MeariFailure)failure;

【Code】
    [[MeariUser sharedInstance] getAlarmMessageListSuccess:^(NSArray<MeariMessageInfoAlarm *> *msgs) {

    } failure:^(NSError *error) {

    }];
【Precautions】
    If the message is pulled by the owner, the server will not save the message, and the shared user will not see the message.
```

##10.2 Get the alarm message of a certain device 

```
【Description 】
     Get the alarm message of a certain device, every time the latest 20 messages on the server will be pulled
     After the master pulls, the message record will be deleted from the server, and then the sharer will not be able to get the message

【Function】
    /**
     @param deviceID 
     @param success  
     @param failure  
       */
    - (void)getAlarmMessageListForDeviceWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;

【Code】
    [[MeariUser sharedInstance] getAlarmMessageListForDeviceWithDeviceID:_deviceID success:^(NSArray<MeariMessageInfoAlarmDevice *> *msgs, MeariDevice *device) {

    } failure:^(NSError *error) {

    }];
【Precautions】
     If the message is pulled by the owner, the server will not save the message, and the shared friend will not see the message.
```
##10.3 Get the number of days with alarm messages (the last 7 days)
```
【Description 】 
     Get the number of days with alarms in the last 7 days
【Function】
     /**
      @param deviceID  
      @param success Successful callback  
      @param failure failure callback  
     */
     - (void)getAlarmMessageRecentDaysWithDeviceID:(NSInteger)deviceID   success:(void (^)(NSArray *msgHas))success failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] getAlarmMessageRecentDaysWithDeviceID:_deviceID success:^(NSArray *msgHas) {
	
     } failure:^(NSError *error) {

     }];

     
```
##10.4 Get device alarm message
```
【Description 】 
      Get the device's alarm message on a certain day
【Function】
     /**
      @param deviceID  
      @param day  "20200804"
      @param success Successful callback  
      @param failure failure callback   
     */
     - (void)getAlarmMessageListForDeviceWithDeviceID:(NSInteger)deviceID
                                             day:(NSString *)day success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] getAlarmMessageListForDeviceWithDeviceID:_deviceID day:day success:^(NSArray<MeariMessageInfoAlarmDevice *> *msgs, MeariDevice *device, BOOL msgFrequently) {
       
     } failure:^(NSError *error) {
        
     }];
     
```
##10.5 Load alarm picture
```
【Description 】 
     The alarm pictures of the device are stored in Alibaba Cloud and Amazon Cloud

【Function】
     Judge by the State and iotType of the MeariMessageInfoAlarmDevice object in the message column
      state is 0, you can access the picture directly through the url
      state is 1:
         cloudType <= 1: a. Obtain image data directly through getOssAlarmImageDataWithUrl
                         b. Get a half-hour url access link through getOssImageUrlWithUrl

         cloudType == 2: a. Get image data directly through getAwsS3ImageDataWithUrl
                         b. Get a half-hour url access link through getAwsS3ImageUrlWithUrl

【Code】
     if ([msg.cloudType integerValue] <= 1 && msg. state == 1) {
        [[MeariUser sharedInstance] getOssImageUrlWithUrl:url deviceID:[m.msg.deviceID integerValue] success:^(NSString *url) {
            NSLog(@"Load pictures directly url")
        } failure:^(NSError *error) {
            NSLog(@"oss signature failed")
        }];                
    }else if ([msg.cloudType integerValue] == 2 && msg. state == 1) {
       [[MeariUser sharedInstance] getAwsS3ImageUrlWithUrl: url deviceID:msg.deviceID integerValue] userID:msg.userID userIDS:msg.userIDS success:^(NSString * url) {
            NSLog(@"Load pictures directly url")			       
       } failure:^(NSError *error) {
            NSLog(@"aws signature failed")
       }];
    }
	
    if ([msg.cloudType integerValue] <= 1 && msg. state == 1) {
        [[MeariUser sharedInstance] getOssAlarmImageDataWithUrl:url deviceID:[m.msg.deviceID integerValue] success:^(NSDictionary *dict) {
            NSData *imageData = dict[@"data"];
            NSLog(@"Load image data directly")
        } failure:^(NSError *error) {
            NSLog(@"oss Failed to get image data")
        }];                
    }else if ([msg.cloudType integerValue] == 2 && msg. state == 1) {
       [[MeariUser sharedInstance] getAwsS3ImageDataWithUrl: url deviceID:msg.deviceID integerValue] userID:msg.userID userIDS:msg.userIDS success:^(NSDictionary *dict) {
            NSData *imageData = dict[@"data"];
            NSLog(@"Load image data directly")
       } failure:^(NSError *error) {
           NSLog(@"aws Failed to get image data")
       }];
    }

     
```

##10.6 Delete multiple device alarm messages 

```
【Description 】
     Delete multiple device alarm messages in batch

【Function】
     /**
     @param deviceIDs  
     @param success  
     @param failure  
     */
    - (void)deleteAlarmMessagesWithDeviceIDs:(NSArray <NSNumber *>*)deviceIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
    [[MeariUser sharedInstance] deleteAlarmMessagesWithDeviceIDs:@[deviceID,devviceID] success:^{

    } failure:^(NSError *error) {

    }];

```

##10.7 Get system messages 

```
【Description 】
    Belong to：MeariMessageInfoSystem

【Function】
        /**
     @param success  
     @param failure  
       */
    - (void)getSystemMessageListSuccess:(MeariSuccess_MsgSystemList)success failure:(MeariFailure)failure;

【Code】
    [[MeariUser sharedInstance] getSystemMessageListSuccess:^(NSArray<MeariMessageInfoSystem *> *msgs) {

    } failure:^(NSError *error) {

    }];
```

## 10.8 Delete system messages

```
【Description 】
     Delete system messages

【Function】
	 /**
     @param msgIDs  
     @param success  
     @param failure  
    */
    - (void)deleteSystemMessages:(NSArray <NSNumber *>*)msgIDs success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
    [[MeariUser sharedInstance] deleteSystemMessages:arr success:^{

    } failure:^(NSError *error) {

    }];
```

##11.9 Get a list of shared messages
```
【Description 】
	Get all shared messages

【Function】
     /**
      @param success Successful callback 
      @param failure failure callback 
     */
    - (void)getShareMessageListSuccess:(MeariSuccess_MsgShareList)success failure:(MeariFailure)failure;
【Code】
    [[MeariUser sharedInstance] getShareMessageListSuccess:^(NSArray<MeariMessageInfoShare *> *msgs) {
        
    } failure:^(NSError *error) {
        
    }];
```
 
##10.10 Delete shared message
```
【Description 】
	  Delete shared message

【Function】
     /**
      @param msgIDArray @[@"msgID",@"msgID"]
      @param success Successful callback 
      @param failure failure callback 
     */
     - (void)deleteShareRequestListWithMsgIDArray:(NSArray *)msgIDArray success:(MeariSuccess)success failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] deleteShareRequestListWithMsgIDArray:@[model.shareInfo.msgID] success:^{

     } failure:^(NSError *error) {

     }];


```

