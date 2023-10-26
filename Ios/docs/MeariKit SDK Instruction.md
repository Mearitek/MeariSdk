
<h1><center> Documentation </center></h1>

* 1 [Functional overview ](#1-Functional-overview)
* 2 [Integration preparation](#2-Integration-preparation)
* 3 [Integrated SDK](#3-Integrated-SDK)
    * 3.1 [Add framework](#31-Add-framework)
    * 3.2 [Environment configuration](#32-Environment-configuration)
    * 3.3 [Add dependency library](#33-Add-dependency-library)
    * 3.4 [Initialize the SDK](#34-Initialize-the-SDK)
* 4 [User Management](#4-User-Management)
    * 4.1 [User login](#41-User-login)
    * 4.2 [User logout](#42-User-logout)
    * 4.3 [User upload avatar](#43-User-upload-avatar)
    * 4.4 [Modify nickname](#44-Modify-nickname)
    * 4.5 [APNS Message Push](#45-APNS-Message-Push)
        * 4.5.1 [Register push notifications](#451-Register-push-notifications)
        * 4.5.2 [Message push sound](#452-Message-push-sound)
        * 4.5.3 [Device message push](#453-Device-message-push)
    * 4.6 [Data model](#46-Data-model)
    * 4.7 [User message notification](#47-User-message-notification)
* 5 [Device configuration](#5-Device-configuration)
    * 5.1 [Get configuration token](#51-Get-configuration-token)
    * 5.2 [QR code configuration](#52-QR-code-configuration)
        * 5.2.1 [Common Camera](#521-Common-Camera)
        * 5.2.2 [4G Camera](#522-4G-Camera)
    * 5.3 [Hotspot configuration (AP configuration)](#53-Hotspot-configuration-AP-configuration)
    * 5.4 [Wired network configuration](#54-Wired-network-configuration)
* 6 [Get device information](#6-Get-device-information)
    * 6.1 [Get device list](#61-Get-device-list)
    * 6.2 [Device Information](#62-Device-Information)
    * 6.3 [Delete device](#63-Delete-device)
    * 6.4 [Modify device nickname](#64-Modify-device-nickname)
    * 6.5 [Device alarm time point ](#65-Device-alarm-time-point)
    * 6.6 [Query device version](#66-Query-device-version)
    * 6.7 [Query device online status](#67-Query-device-online-status)
    * 6.8 [Remote wake up doorbell](#68-Remote-wake-up-doorbell)
    * 6.9 [Upload doorbell message](#69-Upload-doorbell-message)
    * 6.10 [Download doorbell message](#610-Download-doorbell-message)
    * 6.11 [Delete doorbell message](#611-Delete-doorbell-message)
* 7 [Device control](#7-Device-control)
    * 7.1 [Connect the device](#71-Connect-the-device)
    * 7.2 [Disconnect device](#72-Disconnect-device)
    * 7.3 [Get bit rate](#73-Get-bit-rate)
    * 7.4 [Preview](#74-Preview)
    * 7.5 [Playback](#75-Playback)
        * 7.5.1 [Playback related](#751-Playback-related)
        * 7.5.2 [Set playback duration](#752-Set-playback-duration)
    * 7.6 [Cloud Playback](#76-Cloud-Playback)
        * 7.6.1 [Cloud Playback 1.0](#761-Cloud-Playback-1.0)
        * 7.6.2 [Cloud Playback 2.0](#762-Cloud-Playback-2.0)
    * 7.7 [Mute](#77-Mute)
    * 7.8 [Voice intercom](#78-Voice-intercom)
    * 7.9 [Screenshots](#79-Screenshots)
    * 7.10 [Video](#710-Video)
    * 7.11 [Get all the parameters of the device](#711-Get-all-the-parameters-of-the-device)
    * 7.12 [PTZ control](#712-PTZ-control)
    * 7.13 [Leave message](#713-Leave-message)
    * 7.14 [Detect alarm](#714-Detect-alarm)
        * 7.14.1 [Motion detection](#7141-Motion-detection)
        * 7.14.2 [Human detection](#7142-Human-detection)
        * 7.14.3 [Alarm interval](#7143-Alarm-interval)
    * 7.15 [Storage (SD card)](#715-Storage-SD-card)
    * 7.16 [Firmware upgrade](#716-Firmware-upgrade)
    * 7.17 [Sleep mode](#717-Sleep-mode)
    * 7.18 [Temperature and humidity](#718-Temperature-and-humidity)
    * 7.19 [Music](#719-Music)
    * 7.20 [Device volume](#720-Device-volume)
    * 7.21 [Doorbell volume](#721-Doorbell-volume)
    * 7.22 [Bell settings](#722-Bell-settings)
    * 7.23 [Floodlight camera settings](#723-Floodlight-camera-settings)
        * 7.23.1 [Switch lights](#7231-Switch-lights)
        * 7.23.2 [Buzzer alarm switch](#7232-Buzzer-alarm-switch)
        * 7.23.3 [Turn on/off the lights according to the time period](#7233-Turn-on/off-the-lights-according-to-the-time-period)
        * 7.23.4 [Turn on/off the lights according to alarm events](#7234-Turn-on/off-the-lights-according-to-alarm-events)
    * 7.24 [Doorbell answering process](#724-Doorbell-answering-process)
* 8 [Share Device](#8-Share-Device) 
* 9 [Family](#9-Family)
    * 9.1 [Family management](#91-Family-management)
        * 9.1.1 [Get family room list (Without device Info)](#911-Get-family-room-list-Without-device-Info)
        * 9.1.2 [Get family list (With device Info)](#912-Get-family-list-With-device-Info)
        * 9.1.3 [Create new family](#913-Create-new-family)
        * 9.1.4 [Updating family Information](#914-Updating-family-Information)
        * 9.1.5 [Delete family](#915-Delete-family)
    * 9.2 [Family sharing](#92-Family-sharing)
        * 9.2.1 [Join a family](#921-Join-a-family)
        * 9.2.2 [Leaving family](#922-Leaving-family)
        * 9.2.3 [Invite members to join a family group](#923-Invite-members-to-join-a-family-group)
        * 9.2.4 [Revoke member invitation](#924-Revoke-member-invitation)
        * 9.2.5 [Remove member from family](#925-Remove-member-from-family])
        * 9.2.6 [Adding family members by account searching](#926-Adding-family-members-by-account-searching)
        * 9.2.7 [Family member list](#927-Family-member-list)
        * 9.2.8 [Family device permission change](#928-Family-device-permission-change)
        * 9.2.9 [Family member name modification](#929-Family-Member-name-modification)
    * 9.3 [Room Management](#93-Room-Management)
        * 9.3.1 [Assign room for the device](#931-Assign-room-for-the-device)
        * 9.3.2 [Add room](#932-Add-Room)
        * 9.3.3 [Room name modification](#933-Room-name-modification)
        * 9.3.4 [Delete room](#934-Delete-room)
        * 9.3.5 [Remove devices from the room](#935-Remove-devices-from-the-room)
* 10 [Message](#10-Message)
    * 10.1 [Get whether all devices have messages](#101-Get-whether-all-devices-have-messages)
    * 10.2 [Alarm message](#102-Alarm-message) 
        * 10.2.1 [Get whether the devices have alarm message](#1021-Get-whether-the-devices-have-alarm-message)
        * 10.2.2 [Get the latest alarm message list](#1022-Get-the-latest-alarm-message-list)
        * 10.2.3 [Get the number of days with alarm messages (the last 7 days)](#1024-get-the-number-of-days-with-alarm-messages-the-last-7-days)
        * 10.2.4 [Get device alarm message in a certain day](#1024-Get-device-alarm-message-in-a-certain-day)
        * 10.2.5 [Load alarm picture](#1025-Load-alarm-picture)
        * 10.2.6 [Delete multiple device alarm messages](#1026-Delete-multiple-device-alarm-messages)
    * 10.3[Alarm message 2.0](#103-Alarm-message-2.0 )
        * 10.3.1 [Get whether the devices have alarm message](#1031-Get-whether-the-devices-have-alarm-message)
        * 10.3.2 [Get a device alarm message](#1032-Get-a-device-alarm-message)
        * 10.3.3 [Load alarm picture](#1033-Load-alarm-picture)
        * 10.3.4 [Delete multiple device alarm messages](#1034-Delete-multiple-device-alarm-messages)
    * 10.4 [System messages](#103-System-messages)
        * 10.4.1 [Get system messages](#1041-Get-system-messages)
        * 10.4.2 [Batch delete system messages](#1042-Batch-delete-system-messages)
    * 10.5 [Shared messages](#104-Shared-messages)
        * 10.5.1 [Get shared messages list of the device](#1051-Get-shared-messages-list-of-the-device)
        * 10.5.2 [Delete shared messages of the device](#1052-Delete-shared-messages-of-the-device)
        * 10.5.3 [Process shared messages of the device](#1053-Process-shared-messages-of-the-device)
        * 10.5.4 [Get shared messages list of the family](#1054-Get-shared-messages-list-of-the-family)
        * 10.5.5 [Delete shared messages of the family](#1055-Delete-shared-messages-of-the-family)
        * 10.5.6 [Process shared messages of the family](#1056-Process-shared-messages-of-the-family)
* 11 [Cloud storage service](#11-Cloud-storage-service)
    * 11.1 [Cloud storage service status](#111-Cloud-storage-service-status)
    * 11.2 [Cloud storage trial](#112-Cloud-storage-trial)
    * 11.3 [Cloud storage activation code](#113-Cloud-storage-activation-code)
    * 11.4 [Cloud storage purchases](#114-Cloud-storage-purchases)
* 12 [NVR](#12-NVR)
    * 12.1 [Add NVR](#121-Add-NVR)
    * 12.2 [Add camera to NVR channel](#122-Add-camera-to-NVR-channel)
        * 12.2.1 [Add an online camera](#1221-Add-an-online-camera)
        * 12.2.2 [Connect NVR to add camera](#1222-Connect-NVR-to-add-camera)
        * 12.2.3 [Connect the router to add camera](#1223-Connect-the-router-to-add-camera)
    * 12.3 [Judgment of NVR and channel equipment](#123-Judgment-of-NVR-and-channel-equipment)
    * 12.4 [NVR settings](#124-NVR-settings)
        * 12.4.1 [NVR parameter related](#1241-NVR-parameter-related)
        * 12.4.2 [NNVR disk management](#1242-NVR-disk-management)
    * 12.5 [NVR channel camera](#125-NVR-channel-camera)
        * 12.5.1 [NVR channel camera information](#1251-NVR-channel-camera-information)
        * 12.5.2 [NVR delete channel camera](#1252-NVR-delete-channel-camera)
        * 12.5.3 [NVR channel camera firmware upgrade](#1253-NVR-channel-camera-firmware-upgrade)     
        * 12.5.4 [NVR all day recording](#1254-NVR-all-day-recording)
* 13 [4G camera](#13-4G-camera)
    * 13.1 [Data details](#131-Data-details)
    * 13.2 [Data plan](#132-Data-plan)
    * 13.3 [Create Data Order](#133-Create-Data-Order)
    * 13.4 [Data activation code](#134-Data-activation-code)
    * 13.5 [Data order list](#135-Data-order-list)
    * 13.6 [Data purchase reminder](#136-Data-purchase-reminder)
    * 13.7 [Trial data plan](#137-Trial-data-plan)
<center>

---
| Version | Team| Update | remark | 
| ------ | ------ | ------ | ------ |
| 2.0.1 | Meari Technology | 2019.06.25 | optimization
| 3.1.0 | Meari Technology | 2021.07.05 | optimization
| 4.1.0 | Meari Technology | 2022.03.23 | Family
| 4.4.0 | Meari Technology | 2022.06.08 | NVR
| 5.0.0 | Meari Technology | 2023.06.08 | 4G + Cloud2.0
</center>

# 1. Functional overview 

Meari Technology APP SDK provides the interface package for communication with hardware devices and Meari Cloud to accelerate the process of application development. It mainly includes the following functions:
- Account system (login, logout, user information modification, registration push, etc.)
- Hardware equipment related (network distribution, control, status reporting, firmware upgrade, preview playback, etc.)
- Cloud storage service (obtaining the activation status, activation of services, creating orders, order lists, etc.)
- Family group related (functions such as creating a family group, creating a new room, assigning a room, inviting members, etc.)
- Message center (alarm message, device share message, family share message, system message)

# 2. Integration preparation

Please read the server documentation before obtaining the authentication information for redirection and login.

# 3. Integrated SDK

## 3.1 Add framework

```
Add MeariKit.framework to target -> General -> Embedded Binaries or target -> General -> Framework, Libraries, and Embedded Content 
```
![framework](framework.png)
## 3.2 Environment configuration

```
Disable bitcode: In the project panel, select target -> Build Settings -> Build Options -> Enable Bitcode -> Set to No
```
![environment](environment.png)
## 3.3 Add dependency library
```
Use cocospod to import AWSS3 required by the framework, as shown below
```
![pod](pod.png)
## 3.4 Initialize the SDK

```
Belong to: MeariSdk tools
```
```
【Description】
       After the cloud to cloud connection, the data obtained from the server v2/third/sdk/redirect is transferred and the SDK is initialized.
【Function】
       -(void)startSDKWithRedirectInfo:(NSDictionary *)info;
【Code】
       [[MeariSDK sharedInstance] startSDKWithRedirectInfo:dic];
```


# 4. User Management 

```
Belong to: MeariUser tool class
```
```
Meari Technology SDK provides a user management system: UID user system
There is a phoneCode file in the Demo project that stores the corresponding country code and phone code
```

## 4.1 User login 
```
【Description】
         After the cloud-to-cloud connection, the data obtained from the server v2/third/sdk/login is transferred to the SDK to realize the login operation.
         Note: Before calling loginUidWithExtraParamInfo each time, you need to call the startSDKWithRedirectInfo method first
【Function】
          /**
          @param info User login information Obtained from the server after cloud-to-cloud docking
          */
            - (void)loginUidWithExtraParamInfo:(NSDictionary *)info complete:(void(^)(NSError *error))complete;
【Code】
      [[MeariUser sharedInstance] loginUidWithExtraParamInfo:dic complete:^(NSError *error) {
          if (!error) {
              NSLog(@"login Success");
          }else {
              NSLog(@"login error --- %@",error.description);
          }
      }];
```

## 4.2 User logout 

```
【Description】
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
## 4.3 User upload avatar 

```
【Description】
     User upload avatar
 
【Function】
     /*
      @param image 
      @param success Successful callback, return the url of the avatar
      @param failure 
      */
     - (void)uploadUserAvatarWithImage:(UIImage *)image success:(MeariSuccess_Avatar)success failure:(MeariFailure)failure;
        
【Code】
     [[MeariUser sharedInstance] uploadUserAvatarWithImage:[UIImage imageWithData:self.imageData] success:^(NSString *avatarUrl) {

     } failure:^(NSError *error) {
    
     }];
```
## 4.4 Modify nickname 

```
【Description】
     Modify user nickname.
 
【Function】
     /*
      @param name New nickname, length 6-20 digits
      @param success 
      @param failure 
     */
    - (void)renameNicknameWithName:(NSString *)name  success:(MeariSuccess)success failure:(MeariFailure)failure;
        
【Code】
     [[MeariUser sharedInstance] renameNicknameWithName:newName success:^{
    
     } failure:^(NSError *error) {
    
     }];
```
## 4.5 APNS message push
### 4.5.1 Register push notifications
```
【Description】
     Sign up for Meari APNS push 
     P8 file, the Key ID of the P8 file, the bundle ID of the App, and the Team ID of the App issuing certificate need to be provieded to relize APNS messages push.
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

```
### 4.5.2 Message push sound
```
【Description】
     Turn off push sound
【Function】
     /**
      Sound push

      @param openSound whether to open 
      @param success Successful callback 
      @param failure failure callback 
   
     */
     - (void)notificationSoundOpen:(BOOL)openSound success:(MeariSuccess)success failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] notificationSoundOpen:YES success:^{

     } failure:^(NSError *error) {

     }];
```
### 4.5.3 Device message push
```
【Description】
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

## 4.6 Data model 

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

## 4.7 Message notification 

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

# 5. Device configuration

```
Belong to: MeariDeviceActivator tool class

The hardware module of Meari Technology supports three network configuration: QR code configuration, hotspot configuration (AP mode), and wired network configuration.
The general process is-get the network tokon-give the token and wifi information to the device-wait for the device to be added successfully. The main difference between each mode is how to send the network configuration information to the device, the QR code is scanned by the camera, the hotspot mode is transmitted through the WIFI link, and the wired distribution network is searched through the LAN.

```
## 5.1 Get configuration token
```
【Description】
     Obtain the configuration token from the server, which needs to be passed to the device
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
## 5.2 QR code configuration
###5.2.2 Common Camera
```
【Description】
     Generate a QR code with WiFi information and configuration token which to be scanned by the camera
      After the device makes a cuckoo sound, it indicates that the recognition is successful, and the device will enter the stat of red light flashing quickly
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

【Description】
       Wait for the successful message which the device added automatically. It is recommended to manually query the device list to avoid the situation that the message is not delivered in time.
【Code】
    1.[MeariDeviceActivator sharedInstance].delegate = self;
    
     Implement proxy method
      - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
         NSLog(@"device --- netConnect  ------ %@ status -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
         if (deviceModel.info.addStatus == MeariDeviceAddStatusSelf) {
           NSLog(@"config success");
         }
      }

    2.Before scanning the QR code by the device, record the device in the device list, and when waiting for the callback of the successful adding of the device, you can actively call the interface for obtaining the device list to check whether a new device has been added.
    
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];

    If you want to search for other devices in the LAN, you can call: 

    [MeariDeviceActivator sharedInstance].delegate = self;
    [[MeariDeviceActivator sharedInstance] startConfigWiFi:MeariSearchModeAll token:token type:MeariDeviceTokenTypeQRCode nvr:NO timeout:100];
	
    Devices in the Lan will be appeared in the proxy method above

    Stop LAN searching for other devices:
    [[MeariDeviceActivator sharedInstance] stopConfigWiFi];

```
###5.2.2 4G Camera
```
【Description】
     4G设备使用蜂窝网络，不需要连接wifi
     将WIFI信息(传空字符串),配网token 生成二维码 给设备扫描。
     在设备发出提示声音之后表明识别成功，设备会进入蓝灯快闪的状态
     
【Function】
     /**
      @param ssid wifi name(wifi名称)
      @param password wifi password(wifi密码)
      @param token code token(二维码token)
      @param size QR code size(二维码大小)
      @param subDevice Sub device (是否为添加子设备)
      @param encryption encryption (是否加密)
      @return QR code image(二维码图片)
     */
     - (UIImage *)createQRCodeWithSSID:(NSString *)ssid pasword:(NSString *)password token:(NSString *)token addSubDevice:(BOOL)subDevice size:(CGSize)size encryption:(BOOL)encryption;

【Code】
    UIImage *image = [[MeariDeviceActivator sharedInstance] createQRCodeWithSSID:@"Meari" pasword:@"12345678" token:token addSubDevice:NO size:CGSizeMake(300, 300) encryption:YES];

【Description】
      等待设备自动添加成功的消息，建议手动查询设备列表，避免消息送达不及时的情况。
【Code】
    1.[MeariDeviceActivator sharedInstance].delegate = self;
     实现代理方法
      - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
         NSLog(@"配网的设备 --- netConnect  ------ %@ 设备添加状态 -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
         if (deviceModel.info.addStatus == MeariDeviceAddStatusSelf) {
           NSLog(@"设备配网成功");
         }
      }

    2.在给设备扫描二维码之前先记录下设备列表的设备, 等待设备添加成功的回调时，可以主动调用获取设备列表的接口来检查是否有新的设备加入
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];

```
## 5.3 Hotspot configuration (AP configuration)
```
【Description】
     Generate a QR code with WiFi information and configuration token which will be transparently transmitted to the device through the hotspot WiFi.
      The mobile phone needs to be connected to the hotspot issued by the device, the hotspot prefix is STRN_xxxxxxxxx
      After the call is successful, and the device will enter the stat of blue light flashing quickly
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

【Description】
       Wait for the successful message which the device added automatically. It is recommended to manually query the device list to avoid the situation that the message is not delivered in time.
       
【Code】
    1.[MeariDeviceActivator sharedInstance].delegate = self;
    
     Implement proxy method
      - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
         NSLog(@"device --- netConnect  ------ %@ status -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
         if (deviceModel.info.addStatus == MeariDeviceAddStatusSelf) {
           NSLog(@"config success");
         }
      }

    2. Before scanning the QR code by the device, record the device in the device list, and when waiting for the callback of the successful adding of the device, you can actively call the interface for obtaining the device list to check whether a new device has been added.
    
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];

    If you want to search for other devices in the LAN, you can call: 

    [MeariDeviceActivator sharedInstance].delegate = self;
    [[MeariDeviceActivator sharedInstance] startConfigWiFi:MeariSearchModeAll token:token type:MeariDeviceTokenTypeQRCode nvr:NO timeout:100];
	
    Devices in the Lan will be appeared in the proxy method above

    Stop LAN searching for other devices:
    [[MeariDeviceActivator sharedInstance] stopConfigWiFi];

```
## 5.4 Wired network configuration
```
【Description】
     Make sure the device is plugged with network cable, the phone and device are in the same local area network
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

【Description】
     Query the adding status of the device from the server to filter some non-compliant devices
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


【Description】
     Transparently transmit the configuration network token to the device
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

【Description】
     Wait for the successful message which the device added automatically. It is recommended to manually query the device list to avoid the situation that the message is not delivered in time.
【Code】
    1.[MeariDeviceActivator sharedInstance].delegate = self;
     Implement proxy method
      - (void)activator:(MeariDeviceActivator *)activator didReceiveDevice:(MeariDevice *)deviceModel error:(NSError *)error {
         NSLog(@"device --- netConnect  ------ %@ status -------- %ld",deviceModel.info.nickname,(long)deviceModel.info.addStatus);
         if (deviceModel.info.addStatus == MeariDeviceAddStatusSelf) {
           NSLog(@"config success");
         }
      }

    2. Before scanning the QR code by the device, record the device in the device list, and when waiting for the callback of the successful adding of the device, you can actively call the interface for obtaining the device list to check whether a new device has been added.
    
    [[MeariUser sharedInstance] getDeviceListSuccess:^(MeariDeviceList *deviceList) {

    } failure:^(NSError *error) {

    }];
```
# 6. Get device information
```
Belong to：MeariUser
```
## 6.1 Get device list 
```
Belong to：MeariDeviceList
```
```
【Description】
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
## 6.2 Device Information

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
## 6.3 Delete device 

```
【Description】
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

## 6.4 Device nickname modification 

```
【Description】
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

## 6.5 Device alarm time point 

```
【Description】
     Get the alarm time of a single device on a certain day
【Function】
     /**
      @param deviceID 
      @param channel  If the device is not an NVR sub-device, pass in 0
      @param date Date: The format is 20171212
      @param success Success callback: return to the alarm time list
      @param failure 
     */
      - (void)getAlarmMessageTimesWithDeviceID:(NSInteger)deviceID channel:(NSInteger)channel onDate:(NSString *)date success:(MeariSuccess_DeviceAlarmMsgTime)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] getAlarmMessageTimesWithDeviceID:self.device.info.ID channel:self.device.channel onDate:@"20171212" success:^(NSArray<NSString *> *time) {

     } failure:^(NSError *error) {

     }];
```

## 6.6 Query device version 

```
【Description】
     Check Whether the device has a new version

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

## 6.7 Query device online status 

```
【Description】
     Only support the device which developed by Meari, ie [camera supportMeariIot] == YES.

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
## 6.8 Remote wake up doorbell 

```
【Description】
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

## 6.9 Upload doorbell message 

```
【Description】
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

## 6.10 Download doorbell message 

```
【Description】
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

## 6.11 Delete doorbell message 

```
【Description】
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

# 7. Device control
```
Belong to：MeariDevice
```
```
MeariDevice Responsible for all operations on the device, including preview, playback, settings, etc. For device settings, you need to ensure that the connection with the device has been established
```
## 7.1 Connect the device 

```
【Description】
     Before performing operations such as preview, playback, and settings, make sure the device is connceted.

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

## 7.2 Disconnect device 

```
【Description】
     Disconnect the device when you don't need to operate it.

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

## 7.3 Get bit rate

```
【Description】
     Get the bit rate of the device

【Function】
     /**
      @return rate
     */
    - (NSString *)getBitrates;

【Code】
     [self.device getBitrates]
```


## 7.4 Preview 

```
【Description】
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

【Description】
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


## 7.5 Playback

### 7.5.1 Playback related
```
【Description】
     Playback the video of the camera
     Note: The SDK does not verify the time of the playback, so even if a time point without an alarm is passed in, the interface will return successfully, so the upper layer needs to judge by itself

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
### 7.5.2 Set playback duration
```
【Description】
    Set the recording duration of the camera
    You can get the supported video playback duration levels through [self.device supportSdRecordLevels]

【Function】
    /**
    Set playback level
 
    @param level MeariDeviceRecordDuration  
    @param success Successful callback 
    @param failure failure callback 
    */
    - (void)setPlaybackRecordVideoLevel:(MeariDeviceRecordDuration)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Set the video playback time
    [self.camera setPlaybackRecordVideoLevel:levels success:^{
    
    } failure:^(NSError *error) {
    
    }];
```

## 7.6 Cloud Playback 
### 7.6.1 Cloud Playback 1.0
```
【Description】
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

【Description】
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
### 7.6.2 Cloud Playback 2.0
```
【Description】
     Cloud storage 2.0 devices support uploading cloud storage clips by default by camera.supportAlarmVideoReport == YES to distinguish
     
【Function】
     /**
     Get the cloud play time of a month
 
     @param monthComponents  obtain month(NSDateComponents *) 
     @param success Successful callback 
     @param failure failure callback
     */
     - (void)getCloud2VideoDaysWithMonthComponents:(NSDateComponents *)monthComponents success:(void(^)(NSArray <MeariDeviceTime *> *days))success failure:(MeariDeviceFailure)failure;

     /**
     Get the cloud play time of a day
 
     @param dayComponents   time(NSDateComponents *),Used to get specific time 
     @param success Successful callback 
      @param failure failure callback 
      */
     - (void)getCloud2VideoMinutesWithDayComponents:(NSDateComponents *)dayComponents success:(void(^)(NSArray <MeariDeviceTime *> *mins, NSArray <MeariDeviceTime *> *alarms, NSString *historyEventEnable, NSString *cloudEndTime,NSInteger storageType))success failure:(MeariDeviceFailure)failure;
     
    /**
     Get cloud 2.0 playback video files
 
     @param startTime startTime(NSDateComponents *) 
     @param success Successful callback 
     @param failure failure callback
     */
     - (void)getCloud2VideoWithStartTime:(NSDateComponents *)startTime success:(void (^)(NSURL *m3u8Url))success failure:(MeariDeviceFailure)failure;

【Code】
     //Get the number of days in cloud storage in the month
      NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
      dateComponents.year = 2021;
      dateComponents.month = 7;
      [device getCloud2VideoDaysWithMonthComponents: dateComponents success:^(NSArray<MeariDeviceTime *> *days) {
         //Get the date with cloud storage recording
      } failure:^(NSError *error) {
        
      }];

     //Get cloud storage video clips in a certain day

      NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
      dateComponents.year = 2021;
      dateComponents.month = 7;
      dateComponents.day = 1;
      [device getCloud2VideoMinutesWithDayComponents:^(NSArray<MeariDeviceTime *> *mins,NSArray <MeariDeviceTime *> *alarms, NSString *historyEventEnable, NSString *cloudEndTime,NSInteger storageType)
          //mins Today's alarm clip
          //alarms Alarm time of the day
          //historyEventEnable Switching time between historical cloud storage 1.0 and 2.0
          //cloudEndTime Effective end time after purchasing the package
         //Get video with cloud storage video
      } failure:^(NSError *error) {
   
      }];

        
      // 获取具体片段的m3u8 url  24小时制
      // 时间以半个小时为间隔 例如:12：00 - 12：30  , 12:30-14:00
      // m3u8文件只有半个小时有效性 过期自动失效
      NSDateComponents * startTime = [[NSDateComponents alloc]init];
      startTime.year = 2021;
      startTime.month = 7;
      startTime.day = 1;
      startTime.hour = 12;
      startTime.minute = 10;

      [self.camera getCloud2VideoWithStartTime:startTime success:^(NSURL *m3u8Url) {
        
      } failure:^(NSError *error) {
        
      }];

【Description】
      云回放2.0的播放器,用来播放m3u8文件，支持播放，录像，Seek等操作
【Function】
     MeariCloudPlayer
     @interface MRCloudPlayer : NSObject

     /**
     初始化

     @param url video url (地址) m3u8文件或者本地mp4文件路径
     @param startTime start time (开始时间)
     @param superView super view (父视图)
     @param pswArr 设备密码 默认为设备SN device.info.sn
     @param isVideoFirst 同步机制是否以视频为主。默认传入NO
     @return MeariPlayer
     */
     - (instancetype)initWithURL:(NSURL *)url startTime:(NSString *)startTime superView:(UIView *)superView psw:(NSArray *)pswArr isVideoFirst:(BOOL)isVideoFirst;

     @property (nonatomic, weak) id<MeariCloudDelegate> delegate; // delegate (代理)
     @property (nonatomic, assign, readonly) MeariCloudStatus playState; // play state (播放状态)
     @property (nonatomic, assign, readonly) MeariCloudRecordState recordState; // record state(录制状态)

     @property (nonatomic, assign, readonly, getter = isPlaying) BOOL playing; // Whether it is playing (是否正在播放)
     @property (nonatomic, assign) BOOL muted; // mute (是否静音)
     // 支持0到4的速度  默认为1
     @property (nonatomic, assign) float speed; // 播放速率

     - (BOOL)snapToPath:(NSString *)path; // Screenshot path : save path (截图,保存路径)
     - (BOOL)startRecord:(NSString *)path; // Record path : save path (录制,保存路径)
     - (void)stopRecord; //End recording (结束录制)
     - (void)play; // start play (开始播放)
     - (void)playWithPostion:(double)pos; //start play with postion (开始从第几秒开始播放)
     - (void)stop; // stop play (停止播放)
     - (void)pause; // pause (暂停)
     - (void)resetPlayerComplete:(void(^)(void))complete; // Turn off playback (关闭播放)
     - (void)hidePlayer; // hide  player (隐藏播放器)
     - (void)playVideoAtTime:(NSString *)time url:(NSURL *)url psw:(NSArray *)pswArr;  // Play video at a certain time (seek进度)
     - (NSTimeInterval)getVideoCurrentSecond;    // Current playback time (unit: second) (当前播放时间（单位：秒）)
     - (NSTimeInterval)getVideoDuration;         // Duration (unit: second)   (时长（单位：秒）)
     + (BOOL)checkPasswordCorrectWithUrl:(NSURL *)url time:(NSString *)time password:(NSString *)password;//检测当前的密码是否匹配

     - (void)seekTime:(double)time;//废弃不使用
     /**
     下载在线m3u8文件 转为mp4
     会堵塞当前线程

     @param url video url m3u8文件地址
     @param password 设备密码 默认传入设备SN device.info.sn
     @param localPath 转换完之后本地mp4文件路径
     @return
     */
     + (int)downloadUrlToTsFile:(NSURL *)url password:(NSString *)password filePath:(NSString *)localPath;
     /**
     将本地mp4文件再次转化为mp4文件
     @param srcMp4Path 原来的mp4文件路径
     @param targetMp4Path 转换完之后本地mp4文件路径
     */
     + (int)transformTsToMp4:(NSString *)srcMp4Path filePath:(NSString *)targetMp4Path;

     //检验url中的密码是否匹配 取一个Ts的url即可
     + (BOOL)checkEncryKey:(NSString *)url password:(NSString *)password;

     ///  根据帧数 绘制生成对应的图片
     /// @param filePath 视频文件路径
     /// @param index 帧数
     /// @param rectArray rectArray中为CGRect的NSValue 类型
     /// @param colors 颜色数组 默认为红色
     /// @param imagePath 输出图片路径
     + (int)creatDrawRectangleImageWith:(NSString *)filePath frameIndex:(int)index rectangleArray:(NSArray <NSValue *>*)rectArray colors:(NSArray <UIColor *>*)colors imagePath:(NSString *)imagePath;

     @end
     //在线播放m3u8
     //psw字段:默认传入当前设备的SN字段 device.info.sn
     //isVideoFirst: 是否以视频作为同步。默认传入NO   
     
     self.cloudPlayer = [[MeariCloudPlayer alloc] initWithURL:m3u8 startTime:@"20210701102035" superView:displayView psw:@[device.info.sn] isVideoFirst:NO];
     self.cloudPlayer.delegate = self;

     //播放本地mp4文件，在报警消息页面推荐使用这种方式。
     1.下载m3u8并转化为mp4文件 
     int ret = [MRCloudPlayer downloadUrlToTsFile:m3u8Url password:devce.info.sn filePath:localMp4Path];

     if (ret < 0){
       //download failed
     }

      self.player = [[MRCloudPlayer alloc] initWithURL:localMp4Path startTime:startTime superView:playerView psw:@[device.info.sn] isVideoFirst:NO];
      self.player.delegate = self;


```
## 7.7 Mute

```
【Description】
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

## 7.8 Voice intercom 


```
【Description】
    The Voice intercom has a half-duplex and full-duplex, half-duplex can only have one party talking at the same time.
    
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

## 7.9 Screenshots 

```
【Description】
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


## 7.10 Video

```
【Description】
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

## 7.11 Get all the parameters of the device

```
【Description】
     Get the parameters of the device, device parameters must be acquired before operating the device

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

## 7.12 PTZ control 

```
【Description】
     Rotate the camera, after starting the rotation, the stop command needs to be called to stop

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
## 7.13 Leave message
```
【Description】
     The doorbell device supports recording of messages, and the message can be played when answering.
【Be applicable】
     Doorbell  
     camera.supportHostMessage == MeariDeviceSupportHostTypeNone  Does not support the message function
     camera.supportHostMessage == MeariDeviceSupportHostTypeOne   Support a message up to 30 seconds
     camera.supportHostMessage == MeariDeviceSupportHostTypeMultiple  Support 3 messages, each of up to 10 seconds

【Description】
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


【Description】
     To start recording a message, you need to obtain microphone permissions.
【Function】
     /**
      @param path  E.g: /var/mobile/Containers/Data/Application/98C4EAB7-D2FF-4519-B732-BEC7DE19D1CE/Documents/audio.wav  warning!!, it must be .wav format (Note!!! The file must be in wav format)
     */
    - (void)startRecordVoiceMailWithPath:(NSString *)path;
【Code】 
      [camera startRecordVoiceMailWithPath:@"xxxx/record.wav"];

【Description】
     End recording
【Function】
      /**
       @param success Return message file path
      */
     - (void)stopRecordVoiceMailSuccess:(MeariDeviceSuccess_RecordAutio)success;
【Code】 
     [camera startRecordVoiceMailWithPath:@"xxxx/record.wav"];
【Description】
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

【Description】
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

## 7.14 Detect alarm 
### 7.14.1 Motion Detection
```
【Description】
     Motion detection settings 
【Be applicable】
     General non-low-power consumption camera
     It can be judged by device.info.capability.caps.md == YES whether it supports the function.
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
```

### 7.14.2 Human detection
```
【Description】
     Set single PIR (human detection) level of doorbell
【Be applicable】
     General low-power consumption camera
     It can be judged by device.supportPir == YES whether it supports human dection
     Get whether the device supports multi-level adjustment through device.supportPirSensitivity
     Get the specific supported level of the device from device.supportPirLevel
    
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
        * 7.14.1 [Motion Detection](#7141-Motion-Detection)
        * 7.14.2 [Human detection](#7142-Human-detection)
### 7.14.3 Alarm interval
```
【Description】
     Set the alarm interval
【Be applicable】
      General low-power consumption camera
      It can be judged by device.supportAlarmInterval whether it supports alarm interval
      An array of supported alarm intervals can be obtained through [self.device supportAlarmFrequencyIntervalLevels]
    
【Function】
     /**
     @param level  Alarm interval level
     @param success Successful callback 
     @param failure failure callback
     */
    - (void)setAlarmInterval:(MeariDeviceCapabilityAFQ)level success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】
     //Set the alarm interval
    [self.camera setAlarmInterval:afqType success:^{
        [weakSelf.tableView reloadData];
        MR_HUD_SHOW_TOAST(MeariLocalString(@"toast_set_success"))
    } failure:^(NSError *error) {
        MR_HUD_SHOW_ERROR(error)
    }];
```


## 7.15 Storage (SD card)

```
【Description】
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

## 7.16 Firmware upgrade

```
【Description】
     Check whether the latest version is available from the server
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

【Description】
      To obtain and upgrade the firmware information, click the upgrade device and the upgrade operation will be operated immediately
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
## 7.17 Sleep mode 

```
【Description】
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


## 7.18 Temperature and humidity 

```
【Description】
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


## 7.19 Music 

```
【Description】
     Get the music status of the device, control the device to play music, Music can only be played when a SD card inserted

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


## 7.20 Device volume 

```
【Description】
     Obtaining and setting the output music volume of the device

【Function】

     /**
      Get the output music volume of the camera

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


## 7.21 Doorbell volume

```
【Description】
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
## 7.22 Bell settings 

```
【Description】
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
【Description】
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
【Description】
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
## 7.23 Floodlight camera settings

### 7.23.1 Switch lights

```
【Description】
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

### 7.23.2 Buzzer alarm switch

```
【Description】
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

### 7.23.3 Turn on/off the lights according to the time period

```
【Description】
     Set a time period for the device. When the device is in the set time period, the device will turn on the light, and when the time is up, the control light will be turned off
    
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

### 7.23.4 Turn on/off lights according to alarm events

```
【Description】
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
## 7.24 Doorbell answering process

- 1 Receive doorbell call messages
> Press the doorbell, receive the doorbell call mqtt message callback or push message
> Register notification to receive call information for notification callback

```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceHasVisitorNotification:) name:MeariDeviceHasVisitorNotification object:nil];
- (void)deviceHasVisitorNotification:(NSNotification *)sender {
    MeariMqttMessageInfo *msg = sender.object;
}
```

- 2 Pop up the answering page based on the acquired call message

- 3 answer or hang up
> Handle the logic of answering, hanging up, etc
> Answering is similar to previewing

```
/**
 // Used to answer the doorbell, must be used with "requestReleaseAnswerAuthorityWithID"

 
 @param deviceID 
 @param messageID  (the data create by push, or mqtt)
 @param success Successful callback 
 @param failure failure callback 
 */
- (void)requestAnswerAuthorityWithDeviceID:(NSInteger)deviceID messageID:(NSInteger)messageID  success:(MeariSuccess_RequestAuthority)success failure:(MeariFailure)failure;

/**
 // Used to hang up the doorbell, must be used with "requestAnswerAuthorityWithDeviceID"
 
 
 @param ID  device ID 
 @param success Successful callback 
 @param failure failure callback 
 */
- (void)requestReleaseAnswerAuthorityWithID:(NSInteger)ID success:(MeariSuccess)success failure:(MeariFailure)failure;
/**
```

# 8. Share Device

```
Belong to: MeariUser

   The device can be shared with other users, they can check the camera after they agree with the share. The shareed users will receive MQTT messages and APNS push notifications.
```

```
【Description】
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
     [[MeariUser sharedInstance] getShareListForDeviceWithDeviceID:camera.info.ID success:^(NSArray<MeariShareInfo *> *shareInfoList) {
 		} failure:^(NSError *error) {
    
   		}];

【Description】
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

【Description】
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

【Description】
     Modify the permissions of the shared user
【Function】
     /**
      change share devie Authority
      @param deviceID 
      @param shareAccount  
      @param authSign Sharing authority identification 0 means that only can be viewed 1 means that it can be controlled
      @param success Successful callback  
      @param failure failure callback  
     */
    - (void)changeShareDeviceWithDeviceID:(NSInteger)deviceID shareUserID:(NSInteger)shareUserID authSign:(NSInteger)authSign success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] changeShareDeviceWithDeviceID:camera.info.ID shareUserID:model.info.shareUserID authSign:1 success:^{
            
     } failure:^(NSError *error) {
    
     }];


【Description】
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

【Description】
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

【Description】
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

【Description】
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

【Description】
     Can monitor App internal notification messages 

     MeariDeviceCancelSharedNotification   (Device cancel unshared)
     MeariDeviceNewShareToMeNotification   (Someone shared his own device with me)
     MeariDeviceNewShareToHimNotification  (Someone requested to share my device with him)

```
# 9. Family

```
Belong to：MeariFamily
```

## 9.1 Family Management

### 9.1.1 Get family room list (Without device Info)

```
Return：MeariFamilyModel
```
```
【Description】
     After the user logs in, obtain the family room list through the interface of the MeariFamily tool class and return it in the form of a model Family Information Array (MeariFamilyModel)

【Function】
    //Get all family room information (only return family information without devices)
    - (void)getFamilyListSuccess:(MeariSuccess_FamilyList)success failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] getFamilyListSuccess:^(NSArray<MeariFamilyModel *> *familyList) {
      
      } failure:^(NSError *error) {
    
      }];
```

MeariFamilyModel property：

```
@property (nonatomic, assign) BOOL isDefault; // Whether the default family
@property (nonatomic, assign) BOOL owner; // Whether the owner

@property (nonatomic, copy) NSString *homeID; // Family ID
@property (nonatomic, copy) NSString *homeName; // Family name
@property (nonatomic, copy) NSString *position; // family location
@property (nonatomic, copy) NSString *userName; // User nickname, value only when homeName does not exist
@property (nonatomic, assign) MRFamilyJoinStatus joinStatus; // Joining status of family to others

@property (nonatomic, copy) NSArray<MeariRoomModel *> *roomList; // room list
@property (nonatomic, copy) NSArray<MeariDevice *> *relaySubDeviceList; // list of all child devices of relay
@property (nonatomic, copy) NSArray<MeariDevice *> *allDeviceList; // All my devices list
@property (nonatomic, copy) NSArray<MeariDevice *> *sharedDeviceList; // Shared device list
@property (nonatomic, copy) NSArray<MeariDevice *> *unDistributionDeviceList;  // Unassigned family room equipment list
```

### 9.1.2 Get family list (With device Info)

```
【Description】
     After the user logs in, the family room list is obtained through the interface of the MeariFamily tool class, and all devices are processed. After success, the return result is obtained through [MeariFamily sharedInstance].familyArray
【Function】
    //Get all family room information (return family information including device information)
    - (void)getFamilyHomeListSuccess:(MeariSuccess)success failure:(MeariFailure)failure;
    //Get the specified family room information (return family information including device information)
    - (void)getFamilyListWithHomeID:(NSString *)homeID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] getFamilyHomeListSuccess:^{
     
    } failure:^(NSError *error) {
    
    }];
    
    [[MeariFamily sharedInstance] getFamilyListWithHomeID:familyid success:^{
     
    } failure:^(NSError *error) {
    
    }];
```

### 9.1.3 Create New Family

```
【Function】
    //Create a new homegroup
    - (void)addFamilyWithHomeName:(nonnull NSString *)homeName
                 homePosition:(nullable NSString *)homePosition
                 roomNameList:(nullable NSArray<NSString *> *)roomNameList
                      success:(MeariSuccess)success
                      failure:(MeariFailure)failure;

【Code】
      [[MeariFamily sharedInstance] addFamilyWithHomeName:familyName homePosition:familyPosition roomNameList:roomList success:^{
      } failure:^(NSError *error) {
        MR_HUD_SHOW_ERROR(error)
    }];
```
### 9.1.4 Update Family Information


```
【Function】
    //Update family information
    - (void)updateFamilyWithHomeID:(NSString *)homeID
                      homeName:(NSString *)homeName
                  homePosition:(NSString *)homePosition
                       success:(MeariSuccess)success
                       failure:(MeariFailure)failure;

【Code】
           [[MeariFamily sharedInstance] updateFamilyWithHomeID:self.familyModel.homeID homeName:homeName homePosition:position success:^{
          } failure:^(NSError *error) {
        }];
```
### 9.1.5 Delete Family 

```

【Function】
    //Delete the family with the specified HomeID (the default family cannot be deleted)
      - (void)removeFamilyWithHomeID:(NSString *)homeID success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] removeFamilyWithHomeID:homeID success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
## 9.2 Family Sharing

### 9.2.1 Join a Family

```

【Function】
    //Request to join a specified homegroup
    - (void)joinFamilyWithHomeIDList:(NSArray<NSString *> *)homeIDList
                       success:(MeariSuccess)success
                       failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] joinFamilyWithHomeIDList:homeIDList success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.2.2 Leaving Family

```
【Function】
    //Leave a joined Family
    - (void)leaveFamilyWithHomeID:(NSString *)homeID
                      success:(MeariSuccess)success
                      failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] leaveFamilyWithHomeID:homeID success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.2.3 Invite members to join a family group
```
【Function】
    //Invite other users to the homegroup (only the home owner has permission)
    - (void)addMemberWithHomeID:(nonnull NSString *)homeID
                   memberID:(nonnull NSString *)memberID
        deviceAuthorityList:(NSArray *)deviceAuthorityList
                       success:(MeariSuccess)success
                       failure:(MeariFailure)failure;

【Code】
       NSArray *array = @[{"deviceID":1,"permission": 0}, {"deviceID":1,"permission": 0}];//home device permissions
     [[MeariFamily sharedInstance] addMemberWithHomeID:homeID memberID:memberID deviceAuthorityList:array success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.2.4 Revoke member invitation

```
【Function】
    //When the member join status is 2, the member invitation message can be revoked through msgID
    - (void)revokeFamilyInviteWithMsgID:(NSString *)msgID
                             homeID:(NSString *)homeID
                            success:(MeariSuccess)success
                            failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] revokeFamilyInviteWithMsgID:msgID homeID:homeID success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.2.5 Remove member from family

```

【Function】
    //Delete family members with specified memberID
    - (void)removeMemberWithHomeID:(nonnull NSString *)homeID
                      memberID:(nonnull NSString *)memberID
                          success:(MeariSuccess)success
                       failure:(MeariFailure)failure;


【Code】
     [[MeariFamily sharedInstance] removeMemberWithHomeID:homeID memberID:memberID :^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.2.6 Adding family members by account searching
```
Return：MeariMemberModel
```

```
【Description】
     When adding a family member, use HomeID and the entered account name to search and return the information of the member to be invited

【Function】
    //Query the information of adding members
    - (void)searchUserWithHomeID:(nullable NSString *)homeID
               memberAccount:(nonnull NSString *)memberAccount
                 countryCode:(NSString *)countryCode
                   phoneCode:(nonnull NSString *)phoneCode
                     success:(MeariSuccess_Member)success
                     failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] searchUserWithHomeID:homeID memberAccount:account countryCode:[MeariUser sharedInstance].userInfo.countryCode phoneCode:[MeariUser sharedInstance].userInfo.phoneCode success:^(MeariMemberModel *member){
     
    } failure:^(NSError *error) {
    
    }];
```
MeariMemberModel property:
```
@property (nonatomic, assign) NSInteger userID; 
@property (nonatomic, copy) NSString *userAccount; // User account
@property (nonatomic, copy) NSString *nickName; // Nick Name
@property (nonatomic, copy) NSString *userName; // Member Name
@property (nonatomic, copy) NSString *imageUrl; 
@property (nonatomic, copy) NSString *msgID; // When the joinStatus is 2, you can use msgid to revoke joining the family
@property (nonatomic, assign) MRFamilyJoinStatus joinStatus; 
@property (nonatomic, assign) BOOL isMaster; //Is the home owner
@property (nonatomic, copy) NSString *hasInvited; 
@property (nonatomic, assign) MRFamilyInvitedStatus invitedStatus;

@property (nonatomic, copy) NSString *homeID;
@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSArray<MeariFamilyDeviceModel *> *devices;

@property (nonatomic, copy) NSArray<MeariFamilyModel *> *homes;
```
### 9.2.7 Family member list
```
Return：MeariMemberModel
```

```
【Function】
    //Get information on all family members
    - (void)getMemberListWithHomeID:(NSString *)homeID success:(MeariSuccess_MemberList)success failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] getMemberListWithHomeID:homeID success:^(MeariMemberModel *member){
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.2.8 family device permission change

```

【Function】
    //Modify family device access to family members
    - (void)updateMemberPermissionMemberID:(nonnull NSString *)memberID
                                homeID:(NSString *)homeID
                   deviceAuthorityList:(NSArray *)deviceAuthorityList
                               success:(MeariSuccess)success
                               failure:(MeariFailure)failure;
【Code】
     [[MeariFamily sharedInstance] updateMemberPermissionMemberID: homeID: deviceAuthorityList: success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.2.9 Family member name modification

```

【Function】
    //Edit family member names 
    - (void)memberNameUpdateWithHomeID:(NSString *)homeID
                    memberID:(NSString *)memberID
                  memberName:(NSString *)memberName
                     success:(MeariSuccess)success
                     failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] memberNameUpdateWithHomeID:homeID memberID: memberID memberName: memberName success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
## 9.3 Room management 
### 9.3.1 Assign room for the device

```
【Function】
    //Assign a device to a room in the home
    - (void)roomDeviceDistributioRoomID:(nonnull NSString *)roomID
                              homeID:(nonnull NSString *)homeID
                          deviceIDList:(nonnull NSArray<NSNumber *> *)deviceIDList
                               success:(MeariSuccess)success
                            failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] roomDeviceDistributioRoomID:roomID homeID:homeID deviceIDList:array success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.3.2 Adding room

```


【Function】
    //Create new room
    - (void)addRoomWithRoomName:(NSString *)roomName
                     homeID:(NSString *)homeID
                    success:(MeariSuccess)success
                    failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] addRoomWithRoomName:roomName homeID:homeID success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.3.3 Room name modification


```
【Function】
    //Modify the room name of the specified room in the homegroup
   - (void)updateRoomNameWithRoomName:(NSString *)roomName
                            homeID:(NSString *)homeID
                            roomID:(NSString *)roomID
                    success:(MeariSuccess)success
                           failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] updateRoomNameWithRoomName:roomName homeID:homeID roomID:roomID success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.3.4 Delete Room

```

【Function】
    //Delete the room of the specified family
    - (void)removeRoomWithRoomIDList:(NSArray<NSString *> *)roomIDList
                      homeID:(NSString *)homeID
                     success:(MeariSuccess)success
                     failure:(MeariFailure)failure;

【Code】
     [[MeariFamily sharedInstance] removeRoomWithRoomIDList:array homeID:homeID success:^{
     
    } failure:^(NSError *error) {
    
    }];
```
### 9.3.5 Remove devices from the room

```

【Function】
    //Remove devices from family room
    - (void)removeDeviceWithRoomID:(NSString *)roomID
                      homeID:(NSString *)homeID
                deviceIDList:(nonnull NSArray<NSNumber *> *)deviceIDList
                     success:(MeariSuccess)success
                     failure:(MeariFailure)failure;
【Code】
     [[MeariFamily sharedInstance] removeDeviceWithRoomID:roomID homeID:homeID deviceIDList:array success:^{
     
    } failure:^(NSError *error) {
    
    }];
```



​	 


# 10. Message 

```
Belong to：MeariMessageInfo
```
```
Note: Once the alarm message is pulled by the owner of the device, the server will delete the message, so it needs to be saved locally. If the user being shared pulls the alarm message of the device, the server will not delete it. Pay attention to the difference of the owner and the shared user. 
```
## 10.1 Get whether all devices have messages 

```
【Description】
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
## 10.2 Alarm message 
### 10.2.1  Get whether the devices have alarm message 

```
【Description】
     Get the alarm message of a certain device, the latest 20 messages on the server will be pulled every time 
     The message record will be deleted from the server after the owner pulled, and then the shared user will not be able to get the message

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
### 10.2.2 Get the latest alarm message list 
```
【Description】
    Get the latest alarm message list of the devices which owned by the user
    After the device alarm message is pulled, the message record will be deleted from the server, and then the interface will no longer return the latest alarm message of the device

【Function】
    //Get the latest alarm message list of the device owned by the user
    @param success 成功回调
    @param failure 失败回调
    -(void)getAlarmLatestMessageListForDeviceListSuccess:(MeariSuccess_MsgLatestAlarmList)success Failure:(MeariFailure)failure;

【Code】
    [[MeariUser sharedInstance] getAlarmLatestMessageListForDeviceListSuccess:^(NSArray<MeariMessageLatestAlarm *> *msgs) {

    } failure:^(NSError *error) {
    
    }];
 【Precautions】
     If the message is pulled by the owner, the server will not save the message, and the shared friend will not see the message.
```
### 10.2.3 Get the number of days with alarm messages (the last 7 days)
```
【Description】 
     Get the number of days with alarms in the last 7 days
【Function】
     /**
      @param deviceID  
      @param channel  If the device is not an NVR sub-device, pass in 0
      @param success Successful callback  
      @param failure failure callback  
     */
     - (void)getAlarmMessageRecentDaysWithDeviceID:(NSInteger)deviceID channel:(NSInteger)channel  success:(void (^)(NSArray *msgHas))success failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] getAlarmMessageRecentDaysWithDeviceID:_deviceID channel:device.channel success:^(NSArray *msgHas) {
	
     } failure:^(NSError *error) {
    
     }];


​     
```
### 10.2.4 Get device alarm message in a certain day
```
【Description】 
      Get the device's alarm message on a certain day
【Function】
     /**
      @param deviceID  
      @param channel  If the device is not an NVR sub-device, pass in 0
      @param day  "20200804"
      @param success Successful callback  
      @param failure failure callback   
     */
    - (void)getAlarmMessageListForDeviceWithDeviceID:(NSInteger)deviceID channel:(NSInteger)channel day:(NSString *)day success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] getAlarmMessageListForDeviceWithDeviceID:_deviceID channel:device.channel day:day success:^(NSArray<MeariMessageInfoAlarmDevice *> *msgs, MeariDevice *device, BOOL msgFrequently) {
       
     } failure:^(NSError *error) {
        
     }];

```
### 10.2.5 Load alarm picture
```
【Description】 
     The alarm pictures of the device are stored in Alibaba Cloud and Amazon Cloud

【Function】
     Judge by the State and cloudType of the MeariMessageInfoAlarmDevice object in the message column
      state is 0, you can access the picture directly through the url
      state is 1:
         cloudType <= 1: a. Obtain image data directly through getOssAlarmImageDataWithUrl
                         b. Get a half-hour url access link through getOssImageUrlWithUrl

         cloudType == 2: a. Get image data directly through getAwsS3ImageDataWithUrl
                         b. Get a half-hour url access link through getAwsS3ImageUrlWithUrl

【Code】
     if ([msg.cloudType integerValue] <= 1 && msg.state == 1) {
        [[MeariUser sharedInstance] getOssImageUrlWithUrl:url deviceID:[m.msg.deviceID integerValue] success:^(NSString *url) {
            NSLog(@"Load pictures directly url")
        } failure:^(NSError *error) {
            NSLog(@"oss signature failed")
        }];                
    }else if ([msg.cloudType integerValue] == 2 && msg.state == 1) {
       [[MeariUser sharedInstance] getAwsS3ImageUrlWithUrl: url deviceID:msg.deviceID integerValue] userID:msg.userID userIDS:msg.userIDS success:^(NSString * url) {
            NSLog(@"Load pictures directly url")			       
       } failure:^(NSError *error) {
            NSLog(@"aws signature failed")
       }];
    }
	
    if ([msg.cloudType integerValue] <= 1 && msg.state == 1) {
        [[MeariUser sharedInstance] getOssAlarmImageDataWithUrl:url deviceID:[m.msg.deviceID integerValue] success:^(NSDictionary *dict) {
            NSData *imageData = dict[@"data"];
            NSLog(@"Load image data directly")
        } failure:^(NSError *error) {
            NSLog(@"oss Failed to get image data")
        }];                
    }else if ([msg.cloudType integerValue] == 2 && msg.state == 1) {
       [[MeariUser sharedInstance] getAwsS3ImageDataWithUrl: url deviceID:msg.deviceID integerValue] userID:msg.userID userIDS:msg.userIDS success:^(NSDictionary *dict) {
            NSData *imageData = dict[@"data"];
            NSLog(@"Load image data directly")
       } failure:^(NSError *error) {
           NSLog(@"aws Failed to get image data")
       }];
    }


​     
```

### 10.2.6 Delete multiple device alarm messages 

```
【Description】
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
## 10.3 Alarm message 2.0 

### 10.3.1  Get whether the devices have alarm message
```
【Description】
    Get cloud storage 2.0 messages. Determine whether the device supports 2.0 alarm messages by judging supportAlarmVideoReport == 1 or evt == 1.

【Function】
     /**
     get all the alarm messgae List for cloud2
     (获取设备是否有最新的报警消息 云存储2.0设备)
     
     @param success Successful callback (成功回调)
     @param failure failure callback (失败回调)
     */
     -(void)getAlarmLatestMessageListCloud2ForDeviceListSuccess:(MeariSuccess_MsgLatestAlarmList)success Failure:(MeariFailure)failure;
【Code】
     [[MeariUser sharedInstance] getAlarmLatestMessageListCloud2ForDeviceListSuccess:^(NSArray<MeariMessageLatestAlarm *> *msgs) {
        
     } Failure:^(NSError *error) {
           
     }];

          
```
### 10.3.2 Get a device alarm message 

```
【Description】
    Get cloud storage 2.0 messages. Determine whether the device supports 2.0 alarm messages by judging supportAlarmVideoReport == 1 or evt == 1.
【Function】

     /**
     get all the alarm messgae of one device  by day 
     (云存储2.0获取某个设备某天的报警消息,每次最多返回20条信息)

     @param deviceID device ID
     @param day format："20200804"
     @param channel Default is 0
     @param msgTime  devLocaTtime，Pass @"0" to get the latest news. Others, such as: "20220406200300" means to get the news after 20220406200300.
     @param eventType eventType (Event alarm type, each message has one type, the value is "1" "2" "3"..."13")
     "-1": Indicates no filtering
     "1": "motion",
     "3": "bell",
     "6": "decibel",
     "7": "cry",
     "9": "baby",
     "10": "tear",
     "11": "human",
     "12": "face",
     "13": "safety"
     @param aiTypes aiType (AI analysis type, each message may have multiple types, value "0" "1" "2"..."7") An empty array means no filtering
     "0": "people"
     "1": "pet"
     "2": "car come"
     "3": "car stay"
     "4": "car leave"
     "5": "The package was dropped off"
     "6": "There is a stranded package"
     "7": "The package was taken away"
     @param direction 1 pulls the latest news, 0 pulls historical news
     @param success Successful callback (成功回调)
     @param failure failure callback (失败回调)
     */
     - (void)getAlarmMessageListCloud2ForDeviceWithDeviceID:(NSInteger)deviceID
                                                  channel:(NSInteger)channel
                                                       day:(NSString *)day
                                                  msgTime:(NSString *)time
                                                  direction:(BOOL)direction
                                                  eventType:(NSInteger)eventType
                                                  aiTypes:(NSArray *)aiTypes
                                                  success:(MeariSuccess_MsgAlarmDeviceList)success failure:(MeariFailure)failure;
【Code】
     //Get the latest news on cloud storage 2.0 without any filtering (获取云存储2.0的最新消息 不作任何的筛选)
     [[MeariUser sharedInstance] getAlarmMessageListCloud2ForDeviceWithDeviceID:deviceID channel:0 day:@"20200804" msgTime:0 direction:1 eventType:-1 aiTypes:[] success:^(NSArray<MeariMessageInfoAlarmDevice *> *newMsgs, MeariDevice *device, BOOL msgFrequently) {
            
      } failure:^(NSError *error) {
           
      }];
```

### 10.3.3 Load alarm picture

```
  【Description】
    Pictures in Cloud Storage 2.0 can be accessed directly. If the link is invalid, please get it again.
    Pictures in Cloud Storage 2.0 are encrypted by the device's SN by default. You need to download the picture data and call the decryption method before it can be displayed.
    Images url ending in jpgx3 indicate that the device is password-encrypted by default. Use device SN encryption
    Images url ending in jpgx2 indicate that the device is encrypted with user passwords.
    (云存储2.0的图片可以直接访问。如果链接失效请重新获取。
    云存储2.0的图片默认以设备的SN进行加密,需要下载图片数据之后调用解密方法后才能显示。
    图片名称以 jpgx3 结尾表明设备默认密码加密。采用设备SN加密
    图片名称以 jpgx2 结尾表明设备采用用户密码加密。)
 
  【Function】
     /**
     //Determine whether the image is based on the jepx2 or jepx3 version of the Key and whether it matches the image.
     // 判断图片是以jepx2、jepx3版本的Key是否与图片匹配

     @param url image url
     @param password Password set by user。The default is the SN of the device
     @return password correct
     */
     - (BOOL)checkImageV2EncryKey:(NSString *)url password:(NSString *)password;


     // Determine whether the image ends with jepx2 or jepx3. If the image ends with jepx2 or jepx3, decryption operation is required.
     // 判断图片是否是以jepx2、jepx3结尾 如果是以jepx2、jepx3结尾的格式 需要进行解密操作

     @param deviceSN (device.info.sn)
     @param imageData (image data)
     @return Decrypt the completed data（解密完成的数据）
     */
     - (NSData *)decryptImageDataV2With:(NSString *)deviceSN imageData:(NSData *)imageData;

  【Code】
        //Check whether the password is correct based on the image URL
         //imageUrl image URL returned by the server
         //Password at the end of jpgx3 defaults to device SN as password password = device.info.sn
       
        BOOL correct = [[MeariUser sharedInstance] checkImageV2EncryKey:imageUrl password:password];

        //imageData image data after downloading
        //Verify whether the password is correct before decrypting. Decrypt the downloaded data
       NSData *decodeData = [[MeariUser sharedInstance] decryptImageDataV2With:password imageData:imageData];

```

### 10.3.4 Delete multiple device alarm messages 

```
【Description】
    Delete cloud storage 2.0 message chanel defaults to 0
【Function】
    /**
     Cloud Storage 2.0 batch delete events by index
     
     @param deviceID 
     @param indexList A collection of event time points that need to be deleted [msgTime,msgTime]
     @param success Successful callback (成功回调)
     @param failure failure callback (失败回调)
     */
     - (void)deleteSystemMessagesCloud2WithDeviceID:(NSInteger)deviceID channel:(NSInteger)channel indexList:(NSArray *)indexList success:(MeariSuccess)success failure:(MeariFailure)failure;

     /**
     Cloud Storage 2.0 batch delete events by day
     
     @param deviceID deviceID
     @param day Event date to be deleted. formart:20210101
     @param success Successful callback (成功回调)
     @param failure failure callback (失败回调)
     */
     - (void)deleteSystemMessagesCloud2WithDeviceID:(NSInteger)deviceID channel:(NSInteger)channel day:(NSString *)day success:(MeariSuccess)success failure:(MeariFailure)failure;

     /**
     Cloud Storage 2.0 delete events by device
     
     @param deviceID 
     @param success Successful callback (成功回调)
     @param failure failure callback (失败回调)
     */
     - (void)deleteSystemMessagesCloud2WithDeviceID:(NSInteger)deviceID channel:(NSInteger)channel success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] deleteSystemMessagesCloud2WithDeviceID:deviceID channel:0 indexList:@[msgTime,msgTime] success:^{
        
    } failure:^(NSError *error) {
       
    }];
```

## 10.4 System messages
### 10.4.1 Get system messages 

```
【Description】
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

### 10.4.2 Batch delete system messages

```
【Description】
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

## 10.5 Shared messages
### 10.5.1 Get shared messages list of the device

```
【Description】
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

 ### 10.5.2 Delete shared messages of the device
 
```
【Description】
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
### 10.5.3 Process shared messages of the device
```
【Description】
     The processing device shares the message, which can be accepted or rejected.
【Function】
     /**

       @param msgID Message ID
       @param sign Sharing permission identification 0-No permission 1-Have permission
       @param accept (Whether to accept)
       @param success (Successful callback)
       @param failure (Failure callback)
     */
     - (void)dealShareMsgWithMsgID:(NSString *)msgID shareAccessSign:(NSInteger)sign accept:(BOOL)accept success:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】
     [[MeariUser sharedInstance] dealShareMsgWithMsgID:msgID shareAccessSign:sign accept:accept success:^{
        
     } failure:^(NSError *error) {
        
     }];
```


### 10.5.4  Get shared messages list of the family

```
【Description】
      Get family sharing messages

【Function】
     
     - (void)getFamilyShareListSuccess:(MeariSuccess_FamilyMessageList)success failure:(MeariFailure)failure;
【Code】
     [[MeariFamily sharedInstance] getFamilyShareListSuccess:^(NSArray<MeariMessageFamilyShare *> *familyMessageList) {
     
     } failure:^(NSError *error) {
    
     }];
```

### 10.5.5 Delete shared messages of the family

```
【Description】
      Delete family shared messages

【Function】
     /**
      Delete family shared messages

      @param msgIDList List of message ID
      @param success Successful callback 
      @param failure failure callback
     */
     - (void)removeFamilyInviteMessageWithMsgIDList:(NSArray<NSString *> *)msgIDList
                     success:(MeariSuccess)success
                     failure:(MeariFailure)failure;
【Code】
     [[MeariFamily sharedInstance] removeFamilyInviteMessageWithMsgIDList:@[model.shareInfo.msgID] success:^{

     } failure:^(NSError *error) {
    
     }];
```

### 10.5.6  Process shared messages of the family

```
【Description】
      Process shared messages

【Function】
     /**
        Deal family shared messages
        @param msgIDList msg id list
        @param flag reject (0) or  accept (1)
        @param success Successful callback
        @param failure failure callback
       */
     - (void)dealFamilyShareMessageWithMsgIDList:(NSArray<NSString *> *)msgIDList
                                       flag:(NSInteger)flag
                                    success:(MeariSuccess)success
                                    failure:(MeariFailure)failure;
【Code】
     [[MeariFamily sharedInstance] dealFamilyShareMessageWithMsgIDList:@[model.msgID] flag:accept success:{
        } failure:^(NSError *error) {

        }];
```


# 11 Cloud storage service
## 11.1 Cloud storage service status
```
【Description】
      Get cloud storage service status

【Function】
       /**
          Get cloud storage status (new)
          @param deviceID device ID 
          @param success Successful callback 
          @param failure failure callback
        */
        - (void)cloudGetStatusWithDeviceID:(NSInteger)deviceID success:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;
【Code】      
        [[MeariUser sharedInstance] cloudGetStatusWithDeviceID:self.camera.info.ID success:^(NSDictionary *dict) {
        
        } failure:^(NSError *error) {

        }];
```
## 11.2 Cloud storage trial
```
【Description】
      Try cloud storage services

【Function】
        /**
          Cloud storage trial
          @param deviceID  device ID 
          @param success Successful callback 
          @param failure failure callback 
        */
        - (void)cloudTryWithDeviceID:(NSInteger)deviceID success:(MeariSuccess)success failure:(MeariFailure)failure;
【Code】
        [[MeariUser sharedInstance] cloudTryWithDeviceID:self.camera.info.ID success:^{
        
        } failure:^(NSError *error) {

        }];
```
## 11.3 Cloud storage activation code
```
【Description】
      Activate cloud storage service via activation code

【Function】
        /**    
          Cloud storage Activation code
          @param deviceID  device ID 
          @param code Activation code 
          @param success Successful callback 
          @param failure failure callback
        */
        - (void)cloudActivationWithDeviceID:(NSInteger)deviceID code:(NSString *)code success:(MeariSuccess)success failure:(MeariFailure)failure;
【Code】
        [[MeariUser sharedInstance] cloudActivationWithDeviceID:self.camera.info.ID code:code success:^{
        
        } failure:^(NSError *error) {

        }];
```
## 11.4 Cloud storage purchases
```
See Demo for details
```

# 12 NVR

## 12.1 Add NVR
```
See: Wired distribution network to add equipment
```
## 12.2 Add camera to NVR channel

### 12.2.1 Add an online camera
```
【Description】
    If the camera is already online, make the camera and the NVR in the same local area network, the camera is turned on and allowed to be discovered, within 5 minutes, the NVR searches and adds the camera to the channel

【Function】
    /**
    Get Sub Device Found Permission
    @param success Successful callback
    @param failure failure callback
    */
    - (void)getSubDeviceFoundPermissionWithSuccess:(MeariDeviceSuccess_Dictionary)success failure:(MeariDeviceFailure)failure;
    /**
     Set Sub Device Found Permission
    @param enable  0-not allowed 1-allow
    @param success Successful callback
    @param failure failure callback 
    */
    - (void)setSubDeviceFoundPermission:(BOOL)enable success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

    /**
     Get Sub Device Found Permission Time (unit second)
    @param success Successful callback 
    @param failure failure callback 
    */
    - (void)getSubDeviceFoundRemainTimeWithSuccess:(MeariDeviceSuccess_Str)success failure:(MeariDeviceFailure)failure;

    /**
    Start Search Nvr Sub Device
    @param success Successful callback 
    @param failure failure callback 
    */
    - (void)startSearchNvrSubDeviceWithSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
    /**
    Get Nvr Sub Device Result
    @param success Successful callback
    @param failure failure callback 
    */
       - (void)getSearchedNvrSubDeviceWithSuccess:(void(^)(BOOL finish, NSArray<MeariSearchNVRSubDeviceModel *>* searchArray))success failure:(MeariDeviceFailure)failure;

    /**
     Nvr adds meari sub-device (in-app binding)
     
     @param ip Searched device's ip
     @param success Successful callback 
     @param failure failure callback 
     */
    - (void)bindNvrSubDeviceWithIp:(NSString *)ip success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

    /**
     Add child device through Nvr (onvif binding)
    
     @param ip Searched device's ip
     @param user onvif user
     @param password onvif password
     @param success Successful callback 
     @param failure failure callback 
     */
    - (void)bindNvrSubDeviceWithIp:(NSString *)ip user:(NSString *)user password:(NSString *)password success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】

    // Whether the camera supports allowing to be connected by Nvr
    if (self.camera.supportFoundPermission) {
    }

    [self.camera getSubDeviceFoundPermissionWithSuccess:^(NSDictionary *dic) {
        BOOL enable = dic[@"enable"];
        NSString *sn = dic[@"nav_name"];//has been added NVR sn
    } failure:^(NSError *error) {
        
    }];
    
    [self.camera getSubDeviceFoundRemainTimeWithSuccess:^(NSString *str) {
        
    } failure:^(NSError *error) {
        
    }];

    [self.camera setSubDeviceFoundPermission:sender.isOn success:^{
        NSLog(@"set success");
    } failure:^(NSError *error) {
    }];
    
    //Start search
    [self.camera startSearchNvrSubDeviceWithSuccess:^{
        [self.camera getSearchedNvrSubDeviceWithSuccess:^(BOOL finish, NSArray * _Nonnull searchArray) {
            NSLog(@"%@",searchArray);
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
    //Get search results
       [self.camera [self.camera getSearchedNvrSubDeviceWithSuccess:^(BOOL finish, NSArray<MeariSearchNVRSubDeviceModel *> *searchArray) {
        // finish：false-Searching, keep getting results；true-Search ends, stop getting results
        dictionary keys:
        //addType: 0-Meari camera; 1-onvif camera
        //sn: Meari camera sn
        //ip: camera IP 
        //addStatus 0-not added；1-adding；2-add success； 3-add failure
        NSLog(@"%@",searchArray);
    } failure:^(NSError *error) {
            
    }];
    

    [self.camera bindNvrSubDeviceWithIp:ip success:^{
        
    } failure:^(NSError *error) {
        
    }];


    [self.camera bindNvrSubDeviceWithIp:ip user:user password:pwd success:^{
        
    } failure:^(NSError *error) {
        
    }];
```
### 12.2.2 Connect NVR to add camera
```
【Description】
    
    If the camera is not online, obtain the NVR token to generate a QR code. After the camera scans the code, it will connect to the NVR and add it to the NVR channel.

【Function】
/**
 Generate QR code

 @param text QR code info
 @param size QR code size
 @return QR code image
 */
- (UIImage *)createQRCodeWithText:(NSString *)text size:(CGSize)size;

【Code】

    NSString *token = [NSString decodeBase64String:self.camera.param.nvr.networkConfig];

    UIImage *image =  [[MeariDeviceActivator sharedInstance] createQRCodeWithText:token size:CGSizeMake(Meari_ScreenWidth, Meari_ScreenWidth)];

```
### 12.2.3 Connect the router to add camera
```
【Description】
    If the camera is not online, obtain the key and wifi name and password of the NVR to generate a QR code. After the camera scans the code, it will connect to the router so that the camera and the NVR are in the same local area network. The NVR searches and adds the camera to the channel.

【Function】
/**
 Get  Nvr Net Config Key
 @param success Successful callback 
 @param failure failure callback 
 */
- (void)getNVRNetConfigKeyWithSucess:(MeariDeviceSuccess_Str)sucess failure:(MeariDeviceFailure)failure ;

/**
 Generate NVR QR code

 @param ssid wifi name
 @param password wifi password
@param key nvr Key
 @param size QR code size
 @return QR code image
 */
- (UIImage *)createNVRQRCodeWithSSID:(NSString *)ssid pasword:(NSString *)password key:(NSString *)key size:(CGSize)size;

【Code】
    [self.camera getNVRNetConfigKeyWithSucess:^(NSString *str) {
        NSLog(@"key: %@",str);
    } failure:^(NSError *error) {
        
    }];

    UIImage *image =  [[MeariDeviceActivator sharedInstance] createNVRQRCodeWithSSID:wifiname pasword:pwd key:key size:CGSizeMake(Meari_ScreenWidth, Meari_ScreenWidth)];

【Description】
    Search for cameras added by routing
【Function】
/**
 Preparing for adding sub-devices in the process of searching for routers
@param success Successful callback 
@param failure failure callback 
*/
- (void)readyForSearchRouterNvrSubDeviceWithSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
Search router process add child device
@param success Successful callback
@param failure failure callback 
*/
- (void)searchRouterNvrSubDeviceWithSuccess:(void(^)(NSArray<MeariSearchNVRSubDeviceModel *>* searchArray))success failure:(MeariDeviceFailure)failure;


【Code】
    [self.nvrDevice readyForSearchRouterNvrSubDeviceWithSuccess:^{
        
    } failure:^(NSError *error) {
        
    }];

    [self.nvrDevice searchRouterNvrSubDeviceWithSuccess:^(NSArray<MeariSearchNVRSubDeviceModel *> *searchArray) {
        
    } failure:^(NSError *error) {
        
    }];
    

```

## 12.3 Judgment of NVR and channel equipment
```
// Judge NVR Device
if (self.camera.isNvr && self.camera.channel == 0) {
}

// Judge the NVR channel
if (self.camera.isNvrSubDevice) {
}
```
## 12.4 NVR settings
### 12.4.1 NVR parameter related
```
MeariDeviceParamNvr：
@property (nonatomic, strong) NSArray *channels; //Array of channels
@property (nonatomic,   copy) NSArray <MeariDeviceParamChannelState *> *channelState;; //Array of channel status
@property (nonatomic,   copy) NSString *network; //Distribution network information
@property (nonatomic,   copy) NSArray <MeariDeviceParamStorage *> *storages; //disk information
@property (nonatomic, assign) NSInteger channel; // number of channels
@property (nonatomic, assign) BOOL antiJamming; // wifi anti-jamming switch
@property (nonatomic,   copy) NSString *tp; // tp
@property (nonatomic,   copy) NSString *networkConfig; // Distribution network information
@property (nonatomic,   copy) NSString *firVersion; // Firmware version number
@property (nonatomic,   copy) NSString *platformModel; // Model
@property (nonatomic,   copy) NSString *platformCode; // platform code
@property (nonatomic, assign) NSInteger onlineTime; //Online Time

MeariDeviceParamChannelState：
@property (nonatomic, assign) NSInteger channel; //channel
@property (nonatomic, assign) NSInteger state; //State
@property (nonatomic, assign) BOOL type; // 0-normal 1-onvif

MeariDeviceParamStorage：
/** Storage Name */
@property (nonatomic, assign)NSInteger name;
/** Total storage space */
@property (nonatomic, copy)NSString *totalSpace;
/** used storage space */
@property (nonatomic, copy)NSString *usedSpace;
/** Remaining storage space */
@property (nonatomic, copy)NSString *freeSpace;
/** Is formatting ? */
@property (nonatomic, assign)BOOL isFormatting;
/** Is there an SD card ? */
@property (nonatomic, assign)BOOL hasSDCard;
/** Is the SD card not supported ? */
@property (nonatomic, assign)BOOL unSupported;
/** ID card is being recognized */
@property (nonatomic, assign)BOOL isReading;
/** Unknown status */
@property (nonatomic, assign)BOOL unKnown;
/** not enough space */
@property (nonatomic, assign)BOOL noSpace;

```
### 12.4.2 NVR disk management
```
【Description】
NVR formatted hard drive

【Function】
/**
 Format memory card
 @param channel HDD channel number
 @param success Successful callback 
 @param failure failure callback
 */
- (void)startHardDiskFormatWithChannel:(NSInteger)channel Success:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;
/**
 Get memory card formatting percentage
 
 @param success Successful callback ,return formatting percentage
 @param failure failure callback 
 */
- (void)getSDCardFormatPercentSuccess:(MeariDeviceSuccess_StoragePercent)success failure:(MeariDeviceFailure)failure;

【Code】
    
    [self.camera startHardDiskFormatWithChannel:_storage.name Success:^{
       
    } failure:^(NSError *error) {
       
    }];

    [self.camera getSDCardFormatPercentSuccess:^(NSInteger percent) {
        
    } failure:^(NSError *error) {
            
    }];
```

## 12.5 NVR channel camera
```
The use of the NVR channel camera is basically the same as that of the ordinary camera. Using the CameraInfo of the NVR channel camera information, you can preview, playback, and set. For the specific process, refer to the preview, playback, and setting of the ordinary camera.
NVR channel cameras do not support cloud playback.
The differences are detailed below.
```

### 12.5.1 NVR channel camera information
```
【Description】
 Get NVR channel camera information Array

【Function】
/**
   Get NVR channel camera information Array
 @param hasUnBind Whether to return the channel information of the unbound camera information
 @param success Successful callback 
 @param failure Failure callback
 */
- (NSMutableArray *)nvrSubDevicesWithUnBind:(BOOL)hasUnBind;


【Code】

    [camera nvrSubDevicesWithUnBind:NO];
```

### 12.5.2 NVR delete channel camera
```
    [self.camera deleteNVRChannel:self.camera.channel success:^{
   
    } failure:^(NSError *error) {
                    
    }];
```

### 12.5.3 NVR channel camera firmware upgrade
```
    // The sn and tp in checkNewFirmware are obtained in different ways
    NSString *deviceSN = self.camera.channel > 0 ? self.camera.param.licenseID : self.camera.info.sn;
    NSString *tp = self.camera.channel > 0 ? self.camera.param.tp : self.camera.info.tp;
    [[MeariUser sharedInstance] checkNewFirmwareWith:deviceSN tp:tp currentFirmware:version success:^(MeariDeviceFirmwareInfo *info) {
        MeariDo_Block_Safe_Main4(update, info.needUpgrade, info.forceUpgrade, info.upgradeDescription,info.appProtocolVer);
    } failure:^(NSError *error) {
    }];
```
### 12.5.4 NVR all day recording
```
【Description】
    Set the all-day recording function of the NVR device

【Function】
    /**
    Set Nvr All Day Record
    @param success Successful callback 
    @param failure failure callback 
    */
    - (void)setNVRAllDayRecord:(BOOL)enable WithSuccess:(MeariDeviceSuccess)success failure:(MeariDeviceFailure)failure;

【Code】

    [self.camera setNVRAllDayRecord:s.on WithSuccess:^{
        NSLog(@"set successfully");
        
    } failure:^(NSError *error) {
        NSLog(@"set failed");
    }];
```
# 13 4G camera
## 13.1 Data details
```
【Description】
    The 4G device carries the SIM card traffic details with the device (it is recommended not to call the query frequently, it is easy to be blocked by the operator)

【Function】
    /**
    Get 4G device SIM card traffic details
    */
    - (void)queryDeviceTrafficWithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID sucess:(void(^)(NSString *simId ,MeariSimTrafficModel *currentModel, NSArray<MeariSimTrafficUnuseModel *>* unuseArray, NSArray<MeariSimTrafficHistoryModel *>* historyArray))success failure:(MeariFailure)failure;

【Code】

    [[MeariUser sharedInstance] queryDeviceTrafficWithUUID:self.uuid deviceID:self.camera.info.ID sucess:^(NSString *simId, MeariSimTrafficModel *currentModel, NSArray<MeariSimTrafficUnuseModel *> *unuseArray, NSArray<MeariSimTrafficHistoryModel *> *historyArray) {
        simId//sim card number
        currentModel//Current package
        unuseArray//unuse package array
        historyArray//Historical usage traffic
    } failure:^(NSError *error) {
        
    }];
```

## 13.2 Data plan
```
【Description】
    4G devices carry SIM card traffic packages with the device

【Function】
//The registration area is outside China and the countryCode is not CN.
   /**
    Get a 4G device SIM card purchase package
    */
    - (void)queryDeviceTrafficPlanWithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID sucess:(void(^)(NSArray<MeariSimTrafficPlanModel *>* planArray, BOOL tryStatus, NSString *maxMonth))success failure:(MeariFailure)failure;
    
    //The use of the countryCode of the registered region of China as CN
    /**
    Get a 4G device SIM card purchase package 2.0
    */
    - (void)queryDeviceTrafficPlan2WithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID payType:(NSInteger)payType sucess:(void(^)(NSArray<MeariSimTrafficPlanModel *>* planArray, BOOL tryStatus, NSString *maxMonth))success failure:(MeariFailure)failure;

【Code】

        if ([Meari_UserM.countryCode isEqualToString:@"CN"]) {
        [[MeariUser sharedInstance] queryDeviceTrafficPlan2WithUUID:self.uuid deviceID:self.camera.info.ID payType:1 sucess:^(NSArray<MeariSimTrafficPlanModel *> *planArray, BOOL tryStatus, NSString *maxMonth) {
            NSMutableArray *result = [NSMutableArray array];
            for (MeariSimTrafficPlanModel *model in planArray) {
                if (model.type == 1) {
                    [result addObject:model];
                }
            }
            weakSelf.payView.dataSource = result;
            weakSelf.selectModel = result.firstObject;
            weakSelf.maxMonth = maxMonth;
            weakSelf.payButton.enabled = YES;
        } failure:^(NSError *error) {
            weakSelf.payButton.enabled = NO;
        }];
    } else {
        [[MeariUser sharedInstance] queryDeviceTrafficPlanWithUUID:self.uuid deviceID:self.camera.info.ID sucess:^(NSArray<MeariSimTrafficPlanModel *> *planArray, BOOL tryStatus, NSString *maxMonth) {
            NSMutableArray *result = [NSMutableArray array];
            for (MeariSimTrafficPlanModel *model in planArray) {
                if (model.type == 1) {
                    [result addObject:model];
                }
            }
            weakSelf.payView.dataSource = result;
            weakSelf.selectModel = result.firstObject;
            weakSelf.maxMonth = maxMonth;
            weakSelf.payButton.enabled = YES;
        } failure:^(NSError *error) {
            weakSelf.payButton.enabled = NO;
        }];
    }
```
## 13.3 Create Data Order
```
【Description】
        Create a corresponding payment order based on the SIM card data package that the 4G device carries with the device
【Function】
    /**
 Create a 4G Device SIM Package Purchase Order
*/
- (void)createDeviceTrafficOrderWithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID packageID:(NSString *)packageID payType:(NSString *)payType payMoney:(NSString *)payMoney paymentMethodNonce:(NSString *)paymentMethodNonce quantity:(NSInteger)quantity sucess:(MeariSuccess)success failure:(MeariFailure)failure;
/**
 Create a 4G Device SIM Package Purchase Order  2.0
*/
- (void)createDeviceTrafficOrder2WithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID packageID:(NSString *)packageID payType:(NSString *)payType payMoney:(NSString *)payMoney quantity:(NSInteger)quantity sucess:(MeariSuccess_Dictionary)success failure:(MeariFailure)failure;

【Code】

    if (![Meari_UserM.countryCode isEqualToString:@"CN"]) {
        [[MeariUser sharedInstance] createDeviceTrafficOrderWithUUID:self.uuid deviceID:self.deviceID packageID:self.plan.planId payType:self.plan.mealType payMoney:Meari_SafeValue(self.plan.money) paymentMethodNonce:Meari_SafeValue(self.payNonce) quantity:1 sucess:^{
            MR_HUD_DISMISS
            MeariSimTrafficPaySuccessVC *successVC = [[MeariSimTrafficPaySuccessVC alloc] init];
            [self.navigationController pushViewController:successVC animated:YES];
            [Meari_NotificationCenter postNotificationName:@"MeariSimTrafficRefreshNotification" object:nil];
        } failure:^(NSError *error) {
            MR_HUD_SHOW_ERROR(error)
        }];
    } else {
        [[MeariUser sharedInstance] createDeviceTrafficOrder2WithUUID:self.uuid deviceID:self.deviceID packageID:self.plan.planId payType:self.plan.mealType payMoney:Meari_SafeValue(self.plan.money) quantity:1 sucess:^(NSDictionary *dict) {
            MR_HUD_DISMISS
            NSDictionary *result = dict[@"result"];
            MeariSimTrafficAliPayWebVC *baseWebVC = [[MeariSimTrafficAliPayWebVC alloc]init];
            baseWebVC.urlString = result[@"payWebUrl"];
            baseWebVC.paySuccessUrl = result[@"payReturnUrl"];
            baseWebVC.camera = weakSelf.camera;
            [weakSelf.navigationController pushViewController:baseWebVC animated:YES];
        } failure:^(NSError *error) {
            MR_HUD_SHOW_ERROR(error)
        }];
```
## 13.4 Data activation code
```
【Description】
    Activation code to activate the SIM card data package that comes with the device

【Function】
  /**
 active  data plan for 4G devices
*/
- (void)activeDeviceTrafficWithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID activeCode:(NSString *)code sucess:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】

        [[MeariUser sharedInstance] activeDeviceTrafficWithUUID:weakSelf.uuid deviceID:weakSelf.camera.info.ID activeCode:code sucess:^{
            NSLog(@"Activation code activated successfully");
        } failure:^(NSError *error) {
            if (error.code == MeariUserCodeVerificationExpired) {
                NSLog(@"Activation code already used");
            }else if (error.code == MeariUserCodeVerificationError ) {
                NSLog(@"activation code error");
            }else {
                NSLog(@"%@",error);
            }
        }];
```
## 13.5 Data order list
```
【Description】
    4G devices carry SIM card traffic order list with the device 

【Function】
   /**
 Get 4G device data plan order list
*/
- (void)getDeviceTrafficOrderListWithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID sucess:(void(^)(NSArray<MeariSimTrafficOrderModel *>* orderArray))success failure:(MeariFailure)failure;

【Code】

    [[MeariUser sharedInstance] getDeviceTrafficOrderListWithUUID:self.uuid deviceID:self.camera.info.ID sucess:^(NSArray<MeariSimTrafficOrderModel *> *orderArray) {
        orderArray//order array
    } failure:^(NSError *error) {
        
    }];
```
## 13.6 Data purchase reminder
```
【Description】
    4G devices carry a SIM card with insufficient traffic to purchase reminders

【Function】
  /**
 Get a reminder to purchase a data plan for 4G devices
*/
- (void)getDeviceTrafficBuyRemindWithDeviceID:(NSInteger)deviceID sucess:(void(^)(BOOL remind))success failure:(MeariFailure)failure;

【Code】

    [[MeariUser sharedInstance] getDeviceTrafficBuyRemindWithDeviceID:self.camera.info.ID sucess:^(BOOL remind) {
        if (remind) {
            NSLog(@"The current remaining data is insufficient, please recharge in time");
        }
    } failure:^(NSError *error) {
            
    }];
```
## 13.7 Trial data plan
```
【Description】
    Try a 4G device to carry SIM card traffic with the device

【Function】
  /**
 Try 4G device data plan
*/
- (void)tryDeviceTrafficPlanWithUUID:(NSString *)uuid deviceID:(NSInteger)deviceID sucess:(MeariSuccess)success failure:(MeariFailure)failure;

【Code】

        [[MeariUser sharedInstance] tryDeviceTrafficPlanWithUUID:self.uuid deviceID:self.camera.info.ID sucess:^{
            NSLog(@"Successful trial");
        } failure:^(NSError *error) {
            
        }];
```
