<h1><center> directory </center></h1>

```
[TOC]
```

* 1 [Function overview](#1-Function-overview)
* 2 [Integration preparation](#2-Integration-preparation)
* 3 [Integrated SDK](#3-Integrated-SDK)
    * 3.1 [Integration Process](#31-Integration-Process)
        * 3.1.1 [Import the sdk package](#311-Import-the-sdk-package)
        * 3.1.2 [Configure build.gradle](#312-Configure-buildgradle)
        * 3.1.3 [Configure AndroidManifest.xml](#313-Configure-AndroidManifestxml)
    * 3.2 [Initialize the SDK](#32-Initialize-the-SDK)
* 4 [User Management](#4-User-Management)
    * 4.1 [User login](#41-User-login)
    * 4.2 [Log out](#42-Log-out)
    * 4.3 [Upload user avatar](#43-Upload-user-avatar)
    * 4.4 [Modify nickname](#44-Modify-nickname)
* 5 [Add device](#5-Add-device)
    * 5.1 [Add device via QR code](#51-Add-device-via-QR-code)
        * 5.1.1 [Generate QR Code](#511-Generate-QR-Code)
        * 5.1.2 [Search and add device](#512-Search-and-add-device)
    * 5.2 [Add device via AP mode](#52-Add-device-via-AP-mode)
        * 5.2.1 [Connect to device hotspot](#521-Connect-to-device-hotspot)
        * 5.2.2 [Search and add device](#522-Search-and-add-device)
    * 5.3 [Add device via wired network](#53-Add-device-via-wired-network)
        * 5.3.1 [Search device](#531-Search-device)
        * 5.3.2 [Add device](#532-Add-device)
    * 5.4 [Scan QR Code to Add](#54-Scan-QR-Code-to-Add) 
        * 5.4.1 [Scan QR Code](#541-Scan-QR-Code)
        * 5.4.2 [Get Device Status](#542-Get-Device-Status)
        * 5.4.3 [Add device](#543-Add-device)
    * 5.5 [Bluetooth Distribution Network](#55-Bluetooth-Distribution-Network) 
        * 5.5.1 [Search Devices](#551-Search-Devices)
        * 5.5.2 [Connect Device](#552-Connect-Device)
        * 5.5.3 [Get WiFi List](#553-Get-WiFi-List)
        * 5.5.4 [Add device](#554-Add-device)
    * 5.6 [Device QR Code](#56-Device-QR-Code) 
        * 5.6.1 [Get Device Information](#561-Get-Device-Information)
* 6 [Device Control](#6-Device-Control)
    * 6.1 [Basic device operations](#61-Basic-device-operations)
        * 6.1.1 [Introduction of device-related classes](#611-Introduction-of-device-related-classes)
        * 6.1.2 [Get device information list](#612-Get-device-information-list)
        * 6.1.3 [Device removal](#613-Device-removal)
        * 6.1.4 [Device nickname modification](#614-Device-nickname-modification)
        * 6.1.5 [Get time segment of device alarm message](#615-Get-time-segment-of-device-alarm-message)
        * 6.1.6 [Get device online status](#616-Get-device-online-status)
        * 6.1.7 [Reboot the device](#617-Reboot-the-device)
    * 6.2 [Device preview and playback](#62-Device-preview-and-playback)
        * 6.2.1 [Device preview](#621-Device-preview)
        * 6.2.2 [Device SD card playback](#622-Device-SD-card-playback)
        * 6.2.3 [Device cloud playback](#623-Device-cloud-playback)
    * 6.3 [Device related](#63-Device-related)
        * 6.3.1 [Doorbell answering process](#631-Doorbell-answering-process)
        * 6.3.2 [Master Message](#632-Master-Message)
* 7 [Share device](#7-Share-device)
    * 7.1 [Introduction of related class](#71-Introduction-of-related-class)
    * 7.2 [Get device share list](#72-Get-device-share-list)
    * 7.3 [Get history share list](#73-Get-history-share-list)
    * 7.4 [Get shared results of all devices](#74-Get-shared-results-of-all-devices)
    * 7.5 [Search users](#75-Search-users)
    * 7.6 [Share device](#76-Share-device)
    * 7.7 [Cancel shared device](#77-Cancel-shared-device)
    * 7.8 [Delete history shared user](#78-Delete-history-shared-user)
    * 7.9 [Processing shared messages](#79-Processing-shared-messages)
* 8 [Message center](#8-Message-center)
    * 8.1 [Device shared messages](#81-Device-shared-messages)
        * 8.1.1 [Get list of the device shared message](#811-Get-list-of-the-device-shared-message)
        * 8.1.2 [Delete shared messages of device](#812-Delete-shared-messages-of-device)
    * 8.2 [Device alarm message](#82-Device-alarm-message)
        * 8.2.1 [Get the newest message of all device](#821-Get-the-newest-message-of-all-device)
        * 8.2.2 [Get alarm messages of a single device](#822-Get-alarm-messages-of-a-single-device)
        * 8.2.3 [Delete device messages](#823-Delete-device-messages)
    * 8.3 [System message](#83-System-message)
        * 8.3.1 [Get system message list](#831-Get-system-message-list)
        * 8.3.2 [Delete system messages](#832-Delete-system-messages)
* 9 [Device settings](#9-Device-settings)
    * 9.1 [Device capability](#91-Device-capability)
    * 9.2 [Device parameters](#92-Device-parameters)
    * 9.3 [Format device SD Card](#93-Format-device-SD-Card)
    * 9.4 [Upgrade device firmware](#94-Upgrade-device-firmware)
    * 9.5 [Basic parameter settings](#95-Basic-parameter-settings)
        * 9.5.1 [Get device parameters](#951-Get-device-parameters)
        * 9.5.2 [Device LED light switch control](#952-Device-LED-light-switch-control)
        * 9.5.3 [Device preview video flip control](#953-Device-preview-video-flip-control)
        * 9.5.4 [Device local recording setting](#954-Device-local-recording-setting)
        * 9.5.5 [Device day and night mode setting](#955-Device-day-and-night-mode-setting)
        * 9.5.6 [Device sleep mode setting](#956-Device-sleep-mode-setting)
        * 9.5.7 [Device scheduled sleep period setting](#957-Device-scheduled-sleep-period-setting)
        * 9.5.8 [Device motion detection setting](#958-Device-motion-detection-setting)
        * 9.5.9 [Device PIR detection setting](#959-Device-PIR-detection-setting)
        * 9.5.10 [Device noise detection setting](#9510-Device-noise-detection-setting)
        * 9.5.11 [Device cry alarm setting](#9511-Device-cry-alarm-setting)
        * 9.5.12 [Device human tracking setting](#9512-Device-human-tracking-setting)
        * 9.5.13 [Device human detection alarm setting](#9513-Device-human-detection-alarm-setting)
        * 9.5.14 [Device humanoid frame setting](#9514-Device-humanoid-frame-setting)
        * 9.5.15 [Device Onvif setting](#9515-Device-Onvif-setting)
        * 9.5.16 [Device video encoding format setting](#9516-Device-video-encoding-format-setting)
        * 9.5.17 [Device rotation control](#9517-Device-rotation-control)
        * 9.5.18 [Device alarm plan time period setting](#9518-Device-alarm-plan-time-period-setting)
        * 9.5.19 [Device push message switch setting](#9519-Device-push-message-switch-setting)
        * 9.5.20 [Alarm frequency setting](#9520-Alarm-frequency-setting)
        * 9.5.21 [PIR level setting](#9521-PIR-level-setting)
        * 9.5.22 [SD card recording type and time setting](#9522-SD-card-recording-type-and-time-setting)
        * 9.5.23 [Device Full Color Mode setting](#9523-Device-Full-Color-Mode-setting)
        * 9.5.24 [Device sound and light alarm setting](#9524-Device-sound-and-light-alarm-setting)
        * 9.5.25 [Device 12-hour switch setting](#9525-Device-12-hour-switch-setting)
        * 9.5.26 [Device anti-flicker Settings](#9526-Device-anti-flicker-Settings)
        * 9.5.27 [Device microphone, recording, speaker Settings](#9527-Device-microphone,-recording,-speaker-Settings)
        * 9.5.28 [Device video encryption Settings](#9528-Device-video-encryption-Settings)
        * 9.5.29 [Device anti-demolition alarm Settings](#9529-Device-anti-demolition-alarm-Settings)
        * 9.5.30 [Device Sound Touch Settings](#9530-Device-Sound-Touch-Settings)    
        * 9.5.31 [Device Work Mode](#9531-Device-Work-Mode)
        * 9.5.32 [Humanoid alarm area (picture frame) Settings](#9532-Humanoid-alarm-area-(picture-frame)-Settings)
        * 9.5.33 [Humanoid switch setup](#9533-Humanoid-switch-setup)
        * 9.5.34 [Recording duration setting](#9534-Recording-duration-setting)
        * 9.5.35 [Music Playback Settings](#9535-Music-Playback-Settings)
    * 9.6 [Doorbell parameter setting](#96-Doorbell-parameter-setting)
        * 9.6.1 [Device Intercom volume settings](#961-Device-Intercom-volume-settings)
        * 9.6.2 [Unlock the battery lock](#962-Unlock-the-battery-lock)
        * 9.6.3 [Bind Wireless Chime](#963-Bind-Wireless-Chime)
        * 9.6.4 [Unbind Wireless Chime](#964-Unbind-Wireless-Chime)
        * 9.6.5 [Whether the wireless chime works setting](#965-Whether-the-wireless-chime-works-setting)
        * 9.6.6 [Wireless chime volume setting](#966-Wireless-chime-volume-setting)
        * 9.6.7 [Wireless chime ringtone setting](#967-Wireless-chime-ringtone-setting)
        * 9.6.8 [Whether the mechanical chime works setting](#968-Whether-the-mechanical-chime-works-setting)
    * 9.7 [Flight camera parameter setting](#97-Flight-camera-parameter-setting)
        * 9.7.1 [Light swtitch setting](#971-Light-switch-setting)
        * 9.7.2 [Alarm switch setting](#972-Alarm-switch-setting)
        * 9.7.3 [Camera trigger light swtich setting](#973-Camera-trigger-light-swtich-setting)
        * 9.7.4 [Camera trigger lighting duration setting](#974-Camera-trigger-lighting-duration-setting)
        * 9.7.5 [Lighting schedule setting](#975-Lighting-schedule-setting)
        * 9.7.6 [Lighting brightness setting](#976-Lighting-brightness-setting)
        * 9.7.7 [Manual lighting duration setting](#977-Manual-lighting-duration-setting)
        * 9.7.8 [Camera trigger alarm setting](#978-Camera-trigger-alarm-setting)
* 10 [Family](#10-Family)
    * 10.1 [Family operation](#101-Family-operation)
        * 10.1.1 [Get family list](#1011-Get-family-list)
        * 10.1.2 [Create family](#1012-Create-family)
        * 10.1.3 [Update family information](#1013-Update-family-information)
        * 10.1.4 [Delete family](#1014-Delete-family)
    * 10.2 [Family Share](#102-Family-Share)
        * 10.2.1 [Search for member accounts to be added](#1021-Search-for-member-accounts-to-be-added)
        * 10.2.2 [Search for the family account to be joined](#1022-Search-for-the-family-account-to-be-joined)
        * 10.2.3 [Add member to the family](#1023-Add-member-to-the-family)
        * 10.2.4 [Join a family](#1024-Join-a-family)
        * 10.2.5 [Get family shared messages](#1025-Get-family-shared-messages)
        * 10.2.6 [Handle family shared messages](#1026-Handle-family-shared-messages)
        * 10.2.7 [Get family member list](#1027-Get-family-member-list)
        * 10.2.8 [Modify device permissions of the family member](#1028-Modify-device-permissions-of-the-family-member)
        * 10.2.9 [Remove member from the family](#1029-Remove-a-member-from-the-family)
        * 10.2.10 [Revoke member invitation](#10210-Revoke-member-invitation)
        * 10.2.11 [Leave family](#10211-Leave-family)
    * 10.3 [Room Operation](#103-Room-Operation)
        * 10.3.1 [Add a room](#1031-Add-a-room)
        * 10.3.2 [Modify room information](#1032-Modify-room-information)
        * 10.3.3 [Delete room](#1033-Delete-room)
        * 10.3.4 [Add device to the room](#1034-Add-device-to-the-room)
        * 10.3.5 [Remove device from the room](#1035-Remove-device-from-the-room)
        * 10.3.6 [Batch remove devices](#1036-Batch-remove-devices)
    * 10.4 [Family Related Classes](#104-Family-Related-Classes)
        * 10.4.1 [MeariFamily](#1041-MeariFamily)
        * 10.4.2 [MeariRoom](#1042-MeariRoom)
        * 10.4.3 [DevicePermission](#1043-DevicePermission)
        * 10.4.4 [FamilyShareMsg](#1044-FamilyShareMsg)
        * 10.4.5 [FamilyMember](#1045-FamilyMember)
* 11 [MQTT and push](#11-MQTT-and-push)
    * 11.1 [MQTT messages](#111-MQTT-messages)
        * 11.1.1 [Connect to MQTT Service](#1111-Connect-to-MQTT-Service)
        * 11.1.2 [Exit MQTT Service](#1112-Exit-MQTT-Service)
        * 11.1.3 [MQTT message processing](#1113-MQTT-message-processing)
    * 11.2 [MQTT Related Classes](#112-MQTT-Related-Classes)
        * 11.2.1 [MqttMsg](#1121-MqttMsg)
        * 11.2.2 [FamilyMqttMsg extends MqttMsg](#1122-FamilyMqttMsg-extends-MqttMsg)
        * 11.2.3 [MsgItem](#1123-MsgItem)
    * 11.3 [Integrated FCM Push](#113-Integrated-FCM-Push)
    * 11.4 [Integration with other pushes](#114-Integration-with-other-pushes)
* 12 [Cloud storage service](#12-Cloud-storage-service)
    * 12.1 [Cloud storage service status](#121-Cloud-storage-service-status)
    * 12.2 [Cloud Storage Trial](#122-Cloud-Storage-Trial)
    * 12.3 [Cloud storage activation code usage](#123-Cloud-storage-activation-code-usage)
    * 12.4 [Cloud storage purchases](#124-Cloud-storage-purchases)
* 13 [NVR](#13-NVR)
    * 13.1 [Add NVR](#131-Add-NVR)
    * 13.2 [Add camera to NVR channel](#132-Add-camera-to-NVR-channel)
        * 13.2.1 [Add online camera](#1321-Add-online-camera)
        * 13.2.2 [Connect NVR to add camera](#1322-Connect-NVR-to-add-camera)
        * 13.2.3 [Connect router to add camera](#1323-Connect-router-to-add-camera)
    * 13.3 [NVR and channel judgment](#133-NVR-and-channel-judgment)
    * 13.4 [NVR settings](#134-NVR-settings)
        * 13.4.1 [NVR obtain parameters](#1341-NVR-obtain-parameters)
        * 13.4.2 [NVR Disk Management](#1342-NVR-Disk-Management)
    * 13.5 [NVR Channel Camera](#135-NVR-Channel-Camera)
        * 13.5.1 [NVR Channel Camera Information](#1351-NVR-Channel-Camera-Information)
        * 13.5.2 [NVR Channel Camera Parameters](#1352-NVR-Channel-Camera-Parameters)
        * 13.5.3 [NVR Channel Camera Firmware Upgrade](#1353-NVR-Channel-Camera-Firmware-Upgrade)
* 16 [AI service](#16-AI-service)
    * 16.1 [AI service status](#161-AI-service-status)
    * 16.2 [AI service activation code usage](#162-AI-service-activation-code-usage)
    * 16.3 [AI service purchase](#163-AI-service-purchase)
* 17 [Release Notes](#17-Release-Notes)
<center>

---
Version number | Development team | Update date | Notes
:-:|:-:|:-:|:-:
3.1.0 | Meari Technical Team | 2021.07.02 | Optimization
4.1.0 | Meari Technical Team | 2022.03.31 | Optimization
5.3.0 | Meari Technical Team | 2023.08.28 | Bluetooth Distribution Network,Device QR Code

<center>

# 1 Function overview

The Meari SDK provides interface of communicating with hardware devices and Meari Cloud to accelerate the application development process, including the following functions:

- Account System
- Add Device
- Device Control
- Device Settings
- Share Devices
- Family
- Message Center

--------------

# 2 Integration preparation

- 1. Get App Key and App secret
- 2. Please read the server documentation first to obtain authentication information for redirection and login

--------------

# 3 Integrated SDK
## 3.1 Integration Process
### 3.1.1 Import the SDK package
```
Import the so files and aar files from libs directory into your own project, you can partialy or fully import so files base on your project.
```

### 3.1.2 Configure build.gradle
```
Add the following configuration to the build.gradle file:

android {
     defaultConfig {
         ...
         ndk {
         // Select the .so library corresponding to the cpu type to be added.
         abiFilters arm64-v7a', 'armeabi-v8a'
         }
     }
      sourceSets {
         main {
             jniLibs.srcDirs = ['libs']
         }
     }
}

repositories {
     flatDir {
         dirs 'libs'
     }
}

dependencies {
     // Required libraries
    // aar required
    implementation(name: 'core-sdk-device-500-20230602', ext: 'aar')
    implementation(name: 'core-sdk-meari-500-20230602', ext: 'aar')

    implementation 'com.tencent:mmkv-static:1.0.23'
    implementation 'com.squareup.okhttp3:okhttp:3.12.0'
    implementation 'org.eclipse.paho:org.eclipse.paho.client.mqttv3:1.1.0'
    implementation 'com.alibaba:fastjson:1.1.67.android'
    implementation 'com.google.code.gson:gson:2.8.6'
    implementation 'com.google.zxing:core:3.3.3'
    implementation 'androidx.localbroadcastmanager:localbroadcastmanager:1.0.0'
    def aws_version = "2.16.+"
    implementation("com.amazonaws:aws-android-sdk-iot:$aws_version") {
        exclude group: 'org.eclipse.paho'
    }
    implementation ("com.amazonaws:aws-android-sdk-mobile-client:$aws_version") { transitive = true }
    implementation 'io.reactivex.rxjava2:rxjava:2.2.6'
    implementation 'io.reactivex.rxjava2:rxandroid:2.1.1'
}
```

### 3.1.3 Configure AndroidManifest.xml
```
Configure appkey and appSecret in the AndroidManifest.xml file, configure the corresponding permissions, etc.
    <uses-permission android:name="android.permission.CHANGE_WIFI_MULTICAST_STATE" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.SYSTEM_OVERLAY_WINDOW" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.PROCESS_OUTGOING_CALLS" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_LOGS" />
    <uses-permission android:name="android.permission.CHANGE_CONFIGURATION" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

    <uses-permission android:name="android.permission.RECEIVE_USER_PRESENT" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.WRITE_SETTINGS" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_LOCATION_EXTRA_COMMANDS" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.GET_TASKS" />
```


## 3.2 Initialize the SDK

```
【description】
It is mainly used to initialize internal resources, communication services, redirection, and logging.
 
[function call]

/**
 * Initialization
 * @param context application
 * @param mqttMessageCallback mqtt message callback
 */
MeariSdk.init(Context application, MqttMessageCallback mqttMessageCallback);

[code example]

Public class MeariSmartApp extends Application {
    @Override
    Public void onCreate() {
        super.onCreate();
        // Initialize
        MeariSdk.init(this, new MyMessageHandler());
        // output log
        MeariSdk.getInstance().setDebug(true);
    }
}
```
# 4 User Management
```
Meari SDK provides mobile/email login, uid login, password reset, etc.
After registration or login is successful, use the response information to connect to the mqtt service.
```

UserInfo class
- userID user ID
- nickName nickname
- userAccount user
- token unique identifier when the user logs in
- headPic user avatar path
- phoneCode country phone code
- countryCode country code
- loginTime login time
- soundFlag pushes the sound;
- imageUrl avatar;
- userToken user unique representation;
- desc user description;


## 4.1 User login
```
【description】
Login with authorization info from sever

[Function call]
/**
 * login with redirect and login info from server
 * @param redirectionJson redirect json string from server
 * @param loginJson redirect login string from server
 */
public void loginWithExternalData(String redirectionJson, String loginJson, ILoginCallback callback)
    
[Code example]

MeariUser.getInstance().loginWithExternalData(redirectionJson, loginJson, new ILoginCallback() {
    @Override
    public void onSuccess(UserInfo userInfo) {

    }

    @Override
    public void onError(int i, String s) {

    }
});
```

## 4.2 Log out
```
【description】
sign out

[Function call]

/**
 * sign out
 *
 * @param callback network request callback
 * /
public void logout (ILogoutCallback callback);

[Code example]
MeariUser.getInstance (). Logout (new ILogoutCallback () {
    @Override
    public void onSuccess () {
        // Clear user information, disconnect mqtt connection, etc.
        MeariUser.getInstance().removeUserInfo();
        MqttMangerUtils.getInstance (). DisConnectService ();
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 4.3 Upload user avatar
```
【description】
Upload a user avatar.
 
[Function call]

/**
 * Upload user avatar
 *
 * @param file User avatar picture file (preferably 300 * 300)
 * @param callback network request callback
 * /
public void uploadUserAvatar (List <File> fileList, IAvatarCallback callback);
        
[Code example]

MeariUser.getInstance (). UploadUserAvatar (path, new IAvatarCallback () {
    @Override
    public void onSuccess (String path) {
// path is the avatar address stored on the server after returning the upload
    }

    @Override
    public void onError (String code, String error) {

    }
});
```

## 4.4 Modify nickname
```
【description】
Modify user nickname.
 
[Function call]

/**
 * change username
 *
 * @param nickname
 * @param callback network request callback
 * /
public void renameNickname (String nickname, IResultCallback callback);
        
[Code example]

MeariUser.getInstance (). RenameNickname (name, new IResultCallback () {
    @Override
    public void onSuccess () {

    }

    @Override
    public void onError (String code, String error) {

    }
});
```

# 5 Add device
```
Connecting the device to WiFi and add the device to the user's account. It is recommended to add device via QR code
```
## 5.1 Add device via QR code
```
After obtaining the token, generating an QR code, let device scan the QR code, the network setting is successful if you hear a beep and the device turns to blue light.
Then you can start searching and waiting for the device addition to complete.
```
### 5.1.1 Generate QR Code
```
【description】
Using token to generate an QR code.

[Function call]

/**
 * Get distribution token
 *
 * @param callback callback
 * /
public void getToken (IGetTokenCallback callback);

/**
 * Generate distribution network QR code
 *
 * @param ssid wifi name
 * @param password wifi password
 * @param token distribution network token
 * @param callback callback
 * /
public void createQRCode (String ssid, String password, String token, ICreateQRCodeCallback callback);

[Code example]

// Get distribution token
MeariUser.getInstance (). GetToken (new IGetTokenCallback () {
    @Override
    public void onSuccess (String token, int leftTime, int smart_switch) {
        // token distribution token
        // leftTime remaining valid time
        // smart_switch smartWifi switch
    }

    @Override
    public void onError (int code, String error) {
    }
});

// Generate distribution network QR code
MeariUser.getInstance (). CreateQRCode (wifiName, pwd, token, new ICreateQRCodeCallback () {
    @Override
    public void onSuccess (Bitmap bitmap) {
        mQrImage.setImageBitmap (bitmap); // Show QR code
    }
});
```

### 5.1.2 Search and add device
```
【description】
After the device is found, the status of the device is detected. If automatic addition is not supported, you should call the interface to add the device.
If automatic addition is supported, waiting for the mqtt message to verify it's successful or fails.
There may be a delay in the mqtt message. In order to improve the experience, you can periodically call the getDeviceList() and check whether there are more new devices to determine whether the addition was successful.

[Function call]

/**
 * Query device status list
 *
 * @param ssid wifi name
 * @param pwd wifi password
 * @param wifiMode wifi encryption type 0:no password, 1:WPA_PSK, 2:WPA_EAP
 * @param scanningResultActivity search result callback
 * @param status status
 * /
public MangerCameraScanUtils (String ssid, String pwd, int wifiMode, CameraSearchListener scanningResultActivity, boolean status)

/**
 * Query device status list
 *
 * @paramList <CameraInfo> cameraInfos device list
 * @param deviceTypeID device type id
 * @param callback network request callback
 * /
public void checkDeviceStatus (List <CameraInfo> cameraInfos, IDeviceStatusCallback callback);

/**
 * Add device
 *
 * @paramList <CameraInfo> cameraInfos device list
 * @param deviceTypeID device type id
 * @param callback network request callback
 * /
public void addDevice (CameraInfo cameraInfo, int deviceTypeID, IAddDeviceCallback callback);

[Code example]

MangerCameraScanUtils mangerCameraScan = new MangerCameraScanUtils (ssid, pwd, wifiMode, new CameraSearchListener () {
    @Override
    public void onCameraSearchDetected (CameraInfo cameraInfo) {
        // Discover the device and check the device status
        checkDeviceStatus ();
    }

    @Override
    public void onCameraSearchFinished () {
        // Search completed
    }

    @Override
    public void onRefreshProgress (int time) {
        // Search progress 100-0, search ends after 100s
    }

}, false);

// start searching
// 130*1000:Search time
// FLAG：Any int type flag bit, the same value will use the same object, different values will create a new object
// token：MeariUser.getInstance().getToken()
mangerCameraScan.startSearchDevice(false, -1, 130*1000, FLAG, token)

MeariUser.getInstance (). CheckDeviceStatus (cameraInfos, deviceTypeID, new IDeviceStatusCallback () {
    @Override
    public void onSuccess (ArrayList <CameraInfo> deviceList) {
        // 1 means your own device, 2 means others' device has not been shared, 3 means the device can be added 4 means others' device have been shared to you
        if (cameraInfo.getAddStatus () == 3) {
            // Add device
            if (cameraInfo.getAutoBinding () == 1) {
                // Support automatic binding, no manual processing required
            } else {
                // Automatic binding is not supported. Active addition
                addDevice (info);
            }
        }
    }

    @Override
    public void onError (int code, String error) {

    }
});

MeariUser.getInstance (). AddDevice (info, this.mDeviceTypeID, new IAddDeviceCallback () {
    @Override
    public void onSuccess (String sn) {
       
    }

    @Override
    public void onError (int code, String error) {
        
    }
});

// The automatically added device waits for a callback message in MyMessageHandler
@Override
public void addDeviceSuccess (String message) {
    // Add device success message
}

@Override
public void addDeviceFailed (String message) {
    // Add device failure message
}
```

## 5.2 Add device via AP mode

```
Turning the device to the AP mode, connect to the hotspot of the device, after the token is updated and configuration information is sent, connect to the original network,the setting is successful if you hear a beep and the indicator LED light turns to blue.
Then searching and waiting for the device configuration complete.
```
### 5.2.1 Connect to device hotspot
```
【description】
Turning the device to the AP mode, connect to the hotspot of the device, after the token is updated and configuration information is sent, connect to the original network,the setting is successful if you hear a beep and the indicator LED light turns to blue.
Then searching and waiting for the device configuration complete.

[Function call]

/**
 * create device controller
 *
 */
public MeariDeviceController();

/**
 * update token
 *
 * token distribution token
 */
public void updateToken(String token);

/**
 * send configuration information
 *
 * @param wifiName wifi name
 * @param password wifi password
 * @param deviceListener callback
 */
public void setAp(String wifiName, String password, MeariDeviceListener deviceListener);

【Code example】

if (deviceController == null) {
    deviceController = new MeariDeviceController();
}
deviceController.updateToken(getToken());  // getToken() get distribution token
deviceController.setAp(mSsid, mPwd, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        // connect to original wifi，start searching and adding device
    }

    @Override
    public void onFailed(String errorMsg) {
        
    }
});
```
### 5.2.2 Search and add device

```
see 5.1.2
```

## 5.3 Add device via wired network
```
Make sure the wired device and the mobile phone are in the same local area network and start searching for the device. If it is a wired device, start to check status of the device. If the device can be added, start adding the device.
```
### 5.3.1 Search device
```
【description】
Search for devices in the local area network, whether it is a wired device, check the status of the device

【Code example】
MangerCameraScanUtils mangerCameraScan = new MangerCameraScanUtils(null, null, 0, new CameraSearchListener() {
    @Override
    public void onCameraSearchDetected(CameraInfo cameraInfo) {
        //Discover the device, if it is a wired device, check the device status
        if(deviceInfo!=null && deviceInfo.isWireDevice()) {
            checkDeviceStatus();
        }
    }

    @Override
    public void onCameraSearchFinished() {
        //search done
    }

    @Override
    public void onRefreshProgress(int time) {
        //Search progress
    }

}, false);

// start search
// 130*1000:Search time
// FLAG：Any int type flag bit, the same value will use the same object, different values will create a new object
mangerCameraScan.startSearchDevice(false, -1, 130*1000, FLAG)

// Check device status
MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID, new IDeviceStatusCallback() {
    @Override
    public void onSuccess(ArrayList<CameraInfo> deviceList) {
        // 1 means it's your own device, 2 means someone else's share to the device, 
        // 3 means the device can be added, 4 means someone else's device has been shared with you
        if (cameraInfo.getAddStatus() == 3) {
            //Add device
            addDevice(info);
        }
    }

    @Override
    public void onError(int code, String error) {

    }
});
```

### 5.3.2 Add device
```
【description】
Get token and add device

【Code example】
// Get token
MeariUser.getInstance().getToken(new IGetTokenCallback() {
    @Override
    public void onSuccess(String token, int leftTime, int smart_switch) {
        mToken = token;
    }

    @Override
    public void onError(int code, String error) {
    }
}, DeviceType.NVR_NEUTRAL);

//add device
public void addDevice(CameraInfo info) {
    MeariDeviceController deviceController = new MeariDeviceController();
    deviceController.setWireDevice(info.getWireConfigIp(), mToken);
}
```
## 5.4 Scan QR Code to Add
```
For wired devices or 4G devices, scan the QR code to start detecting the device status. If the device can be added, add the device directly.
```
### 5.4.1 Scan QR Code
```
Scan the fuselage code to obtain the value of the fuselage code.

[Function call]

/**
 * Process the body QR Code and obtain the uuid of the device
 *
 * @param result      
 * 
 * return  uuid
 */
public static String dealUUiD(String result)

【Code example】
val dealUUiD = SdkUtils.dealUUiD(result)

```

### 5.4.2 Get Device Status
```
Get the online and offline status of the device through uuid. Only when the device is online can you continue to add it. Otherwise, the user will be guided to go through the power-on process.

[Function call]

/**
 * Get device online status by body QR Code
 *
 * @param uuid       uuid
 * 
 *
 */

public void getDeviceStatus(String uuid, IStringResultCallback callback)

【Code Example】
MeariUser.getInstance().getDeviceStatus(uuid, object : IStringResultCallback {
            override fun onSuccess(result: String) {
                
            }

            override fun onError(code: Int, error: String) {
                
            }
        })


【JSON】
{
  "resultCode": "1001",
  "result": {
    "sn": "",
    "licenseID": "",
    "deviceTypeName": "",
    "firmID": "8",
    "capability ": "",
    "model": "",
    "status": 1
  }
}

status
1: online
2: offline
8: strong binding
9: The app account number and the device encryption country code do not match


 ```

### 5.4.3 Add device
A wired device or 4G device queries the online status and can add the device by calling the add interface.

```
【description】
Add device

[Function call]

/**
 * 
 *
 * @param result      QR code
 * return      ture:new code    
               false：old code
 *
 */
public static boolean dealUUiDisNew(String result)

【Code Example】
SdkUtils.dealUUiDisNew(scanResult)





/**
 * Add device 
 *
 * @param sn       Interface getDeviceStatus()  returned sn
 * @param safePwd   Device password. If no value is set, pass "" as an empty string
 *
 */

public void addDeviceServerSendToken(String sn,String safePwdIStringResultCallback callback)

【Code Example】
MeariUser.getInstance().addDeviceServerSendToken(sn, safePwd, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                //It only means that the adding command is sent successfully. If the adding is successful, you still need to wait for mqtt or poll the device list to confirm whether the adding is successful.
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });

 ```


## 5.5 Bluetooth Distribution Network
```
Bluetooth Distribution Network
```
### 5.5.1 Search Devices
Search for surrounding Bluetooth devices

```
【description】
Search device tools

【Code Example】
public class DeviceBleHelper {
    
    public static final int AUTO_CLOSE_BLE_TIME_MS = 130_000;
    
    private static volatile DeviceBleHelper helper;
    private final DeviceNetConfigBle deviceNetConfigBle;

    private final Handler closeHandler = new Handler(Looper.getMainLooper());
    private Runnable r = new Runnable() {
        @Override
        public void run() {
            Logger.i("deviceBleHelper", "auto " +
                    "disconnect ble device! not impl!!!!!!!!!!!!!!!!!!");
//            deviceNetConfigBle.stopConnect();
        }
    };

    public static DeviceBleHelper getInstance() {
        if (helper == null) {
            synchronized (DeviceBleHelper.class) {
                if (helper == null) {
                    helper = new DeviceBleHelper();
                }
            }
        }
        return helper;
    }

    private DeviceBleHelper() {
        deviceNetConfigBle = new DeviceNetConfigBle(){
            @Override
            public void stopConnect() {
                super.stopConnect();
            }
        };
    }

    public DeviceNetConfigBle getDeviceNetConfigBle() {
        if(closeHandler!=null) {
            closeHandler.removeCallbacks(r);
            closeHandler.postDelayed(r, AUTO_CLOSE_BLE_TIME_MS);
        }
        return deviceNetConfigBle;
    }
}


/**
**
* init     activity-onCreate
*/
【Code Example】
DeviceNetConfigBle.init(getApplication());
deviceNetConfigBle = DeviceBleHelper.getInstance().getDeviceNetConfigBle();

/**
*activity-ondestory
*/

if (deviceNetConfigBle != null) {
    deviceNetConfigBle.stopConnect();
    deviceNetConfigBle.unregisterStateCallback(meariBleCallback);
    deviceNetConfigBle.stopDeviceWifiScan();
 }

/**
 * Start searching for Bluetooth
 *
 *
 */

【Code Example】
if (!DeviceNetConfigBle.bleEnable()) {
 //Bluetooth cannot be used  
     return;
}
deviceNetConfigBle.setScanDeviceTimeoutMs(Constant.ADD_DEVICE_WAIT_TIME_MS);
        deviceScanCallback = new DeviceScanCallback() {
            @Override
            public void finish(Set<MeariBleDevice> data) {
                
            }

            @Override
            public void scanning(MeariBleDevice device) {
                
            }

            @Override
            public void onScanStarted(boolean success) {
                
            }
        };
        deviceNetConfigBle.scanDevice(deviceScanCallback);


```
### 5.5.2 Connect Device

Connect Device

```

/**
 * Connect Device
 * 
 *
 */

【Code Example】
        if (bleCallback == null) {
            bleCallback = new MeariBleCallback() {
                @Override
                public void tokenCallback(String token) {
                    
                }

                @Override
                public void connect() {
                    //Device connected successfully
                }

                @Override
                public void disconnect() {
                    
        //       showToast("Device bluetooth disconnected");
                }

                @Override
                public void failed(String err) {
                    
                }
            };
        }
       deviceNetConfigBle.startConnectByDevice(meariBleDevice, bleCallback);

```
### 5.5.3 Get WiFi List

Get the list of WiFi devices that the device can connect to

```
【Code Example】
deviceNetConfigBle.startDeviceWifiScan(new MeariBleOpCallback() {
                @Override
                public void onFail(int code, String error) {
                    //If it fails, try again.
                }

                @Override
                public void onSuccess() {
                    
                }
            }, new DeviceWifiCallback() {
                @Override
                public void callback(Set<DeviceWifi> data) {
                    //wifi list
                }
            });
```
### 5.5.4 Add device

Add device

```
【Code Example】
        DeviceNetConfigBle deviceNetConfigBle = DeviceBleHelper.getInstance().getDeviceNetConfigBle();
        if (setWifiInfoErrorListener == null) {
            setWifiInfoErrorListener = new DeviceNetConfigErrorListener() {
                @Override
                public void onError(int code, String msg) {
                    //Error reason
                }
            };
        }
        deviceNetConfigBle.setNetConfigErrorListener(setWifiInfoErrorListener);

        if (deviceNetConfigBle.getDeviceBtWifiMode() == 1 || deviceNetConfigBle.getDeviceBtWifiMode() == 2) {
            deviceNetConfigBle.enableAutoConnect(true);
            deviceNetConfigBle.enableGetLastSetWifiResultOnConnect(true);
            Logger.i(TAG, "enable bt auto connect! auto get errorCode");
        } else {
            Logger.i(TAG, "not bt auto connect. mode=" + deviceNetConfigBle.getDeviceBtWifiMode());
        }

        //connect
        if (bleDevice != null && (deviceNetConfigBle.getDeviceBtWifiMode() == -1 || deviceNetConfigBle.getDeviceBtWifiMode() == 1)) {
            Logger.i(TAG, "ble device[not support get-wifi] need connect first.");
            deviceNetConfigBle.enableAutoConnect(true);
            if (meariBleCallback == null) {
                meariBleCallback = new MeariBleCallback() {
                    @Override
                    public void connect() {
                        //Close reconnection
                        deviceNetConfigBle.enableAutoConnect(false);
                        //Sending information while connected
                        setWifiInfo();
                    }

                    @Override
                    public void disconnect() {

                    }

                    @Override
                    public void failed(String err) {
                        Logger.i(TAG, "ble connect error.");
                    }
                };
            }
            deviceNetConfigBle.startConnectByDevice(bleDevice, meariBleCallback);
        } else {
            setWifiInfo();
        }

        //Send distribution network information
        deviceNetConfigBle.setWifiInfo(ssid, pwd, token, new MeariBleOpCallback() {
                @Override
                public void onFail(int code, String error) {

                    //Retry immediately after failure
                    
                }

                @Override
                public void onSuccess() {
                    //The device receives the information successfully and traverses the device list to determine whether the addition is successful.
                    getdevicelist();
                }
            });

            //Determine whether there is a new device in the device list
            MeariUser.getInstance().getDeviceList(new IDevListCallback()

```
## 5.6 Device QR Code
```
Body QR code processing, including analyzing the device type and network distribution method from the QR code information, which is convenient and fast
```
### 5.6.1 Get Device Information
```
Obtain device information through uuid, which is the scan result of the fuselage code.
【function call】

/**
 * Obtain device information by body code
 *
 * @param uuid       uuid
 * QR Code rules
 QR code format = Product category code + device code + Add device mode code + Sales country
 Example： LWCN056565099123AL
 Explain： 
 N056565099 express sn: 056565099
 123 express AP first、QR code and LAN next
      No distribution options 0
      Add device via AP mode  1
      Add device via QR code  2
      Add device via wired network 3 
      Bluetooth Distribution Network 4
      Scan QR Code to Add     5
 *
 */

public void getDeviceStatus(String uuid, IStringResultCallback callback)

【Code Example】
MeariUser.getInstance().getDeviceStatus(uuid, object : IStringResultCallback {
            override fun onSuccess(result: String) {
                
            }

            override fun onError(code: Int, error: String) {
                
            }
        })

 ```


# 6 Device Control

## 6.1 Basic Device operations

### 6.1.1 Introduction of device-related classes

MeariDevice (manages the list of devices)

-List <CameraInfo> ipcs; common cameras list
-List <CameraInfo> doorBells; doorBell list
-List <CameraInfo> batteryCameras; batteryCamera list
-List <CameraInfo> voiceBells; voiceBell list
-List <CameraInfo> fourthGenerations; 4G camera list
-List <CameraInfo> flightCameras; floodlight camera list
-List <CameraInfo> chimes; relay device list

CameraInfo extends BaseDeviceInfo (device information class)

-String deviceID // device Id
-String snNum // Device SN
-String deviceName // device name
-String deviceIcon // device icon gray icon
-int addStatus // device status 1 means own device, 2 means others' device has not been shared, 3 means device can be added 4, others' device have been shared to you
-int devTypeID; // device type
-String userAccount; // Has an account
-boolean asFriend // Whether to share to your device as a friend

### 6.1.2 Get device information list
```
【description】
Meari SDK provides multiple interfaces for developers to achieve device information acquisition and management capabilities (removal, etc.). The device data is notified to the recipient using an asynchronous message.
We use the EventBus to implement message notification. Therefore, the notification object needs to be registered and destroyed on each device operation page. For details, please refer to the demo implementation.

[Function call]
/**
 * Get user's device list
 *
 * @param callback Function callback
 * /
public void getDeviceList (IDevListCallback callback);

[Code example]
MeariUser.getInstance (). GetDeviceList (new IDevListCallback () {
    @Override
    public void onSuccess (MeariDevice dev) {
        // Select according to the device you access
        ArrayList <CameraInfo> cameraInfos = new ArrayList <> ();
        cameraInfos.addAll (dev.getNvrs ());
        cameraInfos.addAll (dev.getIpcs ());
        cameraInfos.addAll (dev.getDoorBells ());
        cameraInfos.addAll (dev.getBatteryCameras ());
        cameraInfos.addAll (dev.getVoiceBells ());
        cameraInfos.addAll (dev.getFourthGenerations ());
        cameraInfos.addAll (dev.getFlightCameras ());
        cameraInfos.addAll (dev.getChimes ());
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

### 6.1.3 Device removal
```
【description】
Device removal

[Function call]
/**
 * Remove device
 *
 * @param devId device id
 * @param deviceType device type
 * @param callback Function callback
 * /
public void deleteDevice (String devId, int deviceType, IResultCallback callback);

[Code example]
MeariUser.getInstance (). DeleteDevice (cameraInfo.getDeviceID (), DeviceType.IPC, new IResultCallback () (
    @Override
    public void onSuccess () {

    }

    @Override
    public void onError (String code, String error) {

    }
));
```

### 6.1.4 Device nickname modification
```
【description】
Device nickname modification

[Function call]
/**
 * Modify device nickname
 *
 * @param deviceId device id
 * @param deviceType device type
 * @param nickname device nickname
 * @param callback Function callback
 * /
public void renameDevice (String deviceId, int deviceType, String nickname, IResultCallback callback);

[Code example]
MeariUser.getInstance (). RenameDeviceNickName (cameraInfo.getDeviceID (), DeviceType.IPC, nickName, new IRemoveDeviceCallback () (
    @Override
    public void onSuccess () {

    }

    @Override
    public void onError (String code, String error) {

    }
));
```

### 6.1.5 Get time segment of device alarm message
```
【description】
Get time segment of device alarm message

[Function call]

Use the following method if cameraInfo.getEvt() < 1:
/**
  * Get time segment of devcie alarm message
  *
  * @param deviceID device ID
  * @param dayTime Time: "20200303"
  * @param callback callback
  * /
public void getDeviceAlarmMessageTimeForDate (String deviceID, String dayTime, IDeviceAlarmMessageTimeCallback callback);

Use the following method if cameraInfo.getEvt() == 1:
/**
 * Get time segment of devcie alarm message
 *
 * @param deviceID device ID
 * @param dayTime Time: "20200303"
 * @param callback callback
 */
public void getDeviceAlarmMessageTimeForDate2(String deviceID, String dayTime, IDeviceAlarmMessageTimeCallbackNew callback);

[Code example]

Call the following mehod when cameraInfo.getEvt() < 1:
MeariUser.getInstance().GetDeviceAlarmMessageTimeForDate (deviceID, dayTime, new IDeviceAlarmMessageTimeCallback () {
     @Override
     public void onSuccess (ArrayList <VideoTimeRecord> videoTimeList) {
     }

     @Override
     public void onError (int code, String error) {
     }
});

Call the following mehod when cameraInfo.getEvt() == 1:
MeariUser.getInstance().getDeviceAlarmMessageTimeForDate2(deviceID, dayTime, new IDeviceAlarmMessageTimeCallbackNew() {
    @Override
    public void onSuccess(ArrayList<VideoTimeRecord> videoTimeList, long historyEventEnable) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 6.1.6 Get device online status
```
【description】
Get device online status

[Function call]

/**
 * Get device online status
 *
 * String Intercepted SN，cameraInfo.getSnNum().substring(4)
 * Integer 0-connecting; 1-online; 2-offline; 3-sleep
 */
public Map<String, Integer> queryDeviceStatus();

[Code example]
// After obtaining the device list, obtain the device state in a loop, and update the device state if the state changes
Map<String, Integer> temStatus = MeariIotController.getInstance().queryDeviceStatus();
```

### 6.1.7 Reboot the device
```
【description】
Reboot the device

[Function call]

/**
 * Reboot the device
 * @param callback callback
 */
public void setDevicesReboot(ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance().setDevicesReboot(new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

## 6.2 Device preview and playback
### 6.2.1 Device Preview
```
【description】
One device corresponds to one CameraInfo and one MeariDeviceController. When performing multiple operations on the same device, ensure to use the same object and do not create it repeatedly.
CameraInfo and MeariDeviceController can be stored in the MeariUser class and retrieved when needed. You need to recreate and save when operating another device.

[Function call]
/**
 * Connected device
 *
 * @param deviceListener device listener
 * /
public void startConnect (MeariDeviceListener deviceListener);

/**
 * Start preview

 * @param ppsGLSurfaceView video control
 * @param videoId video resolution 0-HD; 1-SD
 * @param deviceListener operation listen
 * @param videoStopListener
 * /
public void startPreview (PPSGLSurfaceView ppsGLSurfaceView, int videoId, MeariDeviceListener deviceListener, MeariDeviceVideoStopListener videoStopListener);


[Code example]

LinearLayout ll_video_view = findViewById (R.id.ll_video);
PPSGLSurfaceView videoSurfaceView = new PPSGLSurfaceView (this, screenWidth, screenHeight);
videoSurfaceView.setKeepScreenOn (true);
ll_video_view.addView (videoSurfaceView);

// Connect the device
MeariDeviceController deviceController = new MeariDeviceController ();
deviceController.setCameraInfo (cameraInfo);
deviceController.startConnect (new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {
        // After successful connection, start preview
        startPreview ();
        // Save the object and avoid duplicate creation
        MeariUser.getInstance (). SetCameraInfo (cameraInfo);
        MeariUser.getInstance (). SetController (deviceController);
        // Get bit rate
        String mBitRate = deviceController.getBitRate() + "KB/s";
    }

    @Override
    public void onFailed (String errorMsg) {
        
    }
});

// Get saved objects when needed
CameraInfo cameraInfo = MeariUser.getInstance (). GetCameraInfo ();
MeariDeviceController deviceController = MeariUser.getInstance (). GetController ();

// start preview
deviceController.startPreview (videoSurfaceView, videoId, new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {

    }

    @Override
    public void onFailed (String errorMsg) {

    }
}, new MeariDeviceVideoStopListener () {
    @Override
    public void onVideoClosed (int code) {
        
    }
});

// switch resolution
deviceController.changeVideoResolution (videoSurfaceView, videoId, new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {

    }

    @Override
    public void onFailed (String errorMsg) {

    }
}, new MeariDeviceVideoStopListener () {
    @Override
    public void onVideoClosed (int code) {
        
    }
});

// stop preview
deviceController.stopPreview (new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {
        
    }

    @Override
    public void onFailed (String errorMsg) {

    }
});

// Disconnect, you must disconnect when exiting preview and playback
deviceController.stopConnect (new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {
        
    }

    @Override
    public void onFailed (String errorMsg) {

    }
});
```

### 6.2.2 Device SD card playback
```
【description】
After the SD card is inserted into the device, it will record the video and save it to the SD card, and then you can view the video from the SD card. The playback operation can only be performed after the device is successfully connected.

[Function call]

/**
 * Get a month with a video date
 * @param year
 * @param month
 * @param videoId video definition
 * @param callback callback
 * /
public void getPlaybackVideoDaysInMonth (int year, int month, int videoId, IPlaybackDaysCallback callback);

/**
 * Get all video clips of the day
 * @param year
 * @param month
 * @param videoId video definition
 * @param callback callback
 * /
public void getPlaybackVideoTimesInDay (int year, int month, int day, int videoId, MeariDeviceListener deviceListener);


/**
 * Start playing video
 *
 * @param ppsGLSurfaceView video control
 * @param videoId video resolution 0-HD; 1-SD
 * @param startTime video start time
 * @param deviceListener operation listen
 * @param videoStopListener
 * /
public void startPlaybackSDCard (PPSGLSurfaceView ppsGLSurfaceView, int videoId, String startTime, MeariDeviceListener deviceListener, MeariDeviceVideoStopListener videoStopListener);

/**
 * Drag to change playback video
 *
 * @param seekTime the time the video started
 * @param deviceListener operation listen
 * @param videoStopListener
 * /
public void seekPlaybackSDCard (String seekTime, MeariDeviceListener deviceListener, MeariDeviceVideoSeekListener seekListener);

/**
 * Pause video
 *
 * @param deviceListener operation listen
 * /
public void pausePlaybackSDCard (MeariDeviceListener deviceListener);

/**
 * Replay video after pause
 *
 * @param deviceListener operation listen
 * /
public void resumePlaybackSDCard (MeariDeviceListener deviceListener)

/**
 * Stop playing video
 *
 * @param deviceListener operation listen
 * /
public void stopPlaybackSDCard (MeariDeviceListener deviceListener);

support download record when MeariDeviceUtil.isSupportDownloadSdRecord(cameraInfo) == true
/**
 * download record
 *
 * @param channelId camera channelId cameraInfo.getChannelId()
 * @param startTime yyyyMMddHHmmss startTime must be in the record
 * @param endTime yyyyMMddHHmmss
 * @param filePath download path of record
 * @param listener listener
 */
public void startDownloadSdRecord(int channelId, String startTime, String endTime, String filePath, @NonNull MeariDeviceSdRecordDownloadListener listener)

/**
 * progress of downloading record
 *
 * @param callback callback
 */
public void getSdRecordDownloadProgress(IProgressCallback callback)

support delete record when MeariDeviceUtil.isSupportDeleteSdRecord(cameraInfo) == true
/**
 * delete record of one day
 *
 * @param channelId camera channel
 * @param day yyyyMMdd
 * @param listener listener
 */
public void deleteSdRecordOfDay(int channelId, String day, @NonNull MeariDeviceListener listener)

/**
 * status of deleting record
 *
 * @param callback callback
 */
public void getSdRecordDeleteState(IProgressCallback callback)


[Code example]

// Play the video only after the device is successfully connected
// Get the date of a month with video
deviceController.getPlaybackVideoDaysInMonth (year, month, videoId, new IPlaybackDaysCallback () {
    @Override
    public void onSuccess (ArrayList <Integer> playbackDays) {
        
    }

    @Override
    public void onFailed (String errorMsg) {

    }
});

// Get all video clips of the day
deviceController.getPlaybackVideoTimesInDay (year, month, day, videoId, new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {
        
    }

    @Override
    public void onFailed (String errorMsg) {

    }
});

// start playing video
deviceController.startPlaybackSDCard (ppsGLSurfaceView, videoId, startTime, new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {

    }

    @Override
    public void onFailed (String errorMsg) {

    }
}, new MeariDeviceVideoStopListener () {
    @Override
    public void onVideoClosed (int code) {
        
    }
});

// Drag to change playback video
deviceController.seekPlaybackSDCard (seekTime, new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {

    }

    @Override
    public void onFailed (String errorMsg) {

    }
}, new MeariDeviceVideoSeekListener () {
    @Override
    public void onVideoSeek () {
        
    }
});

// Pause video
deviceController.pausePlaybackSDCard (new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {
        
    }

    @Override
    public void onFailed (String errorMsg) {

    }
});

// Replay video after pause
deviceController.resumePlaybackSDCard (new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {
        
    }

    @Override
    public void onFailed (String errorMsg) {

    }
});

// stop playing video
deviceController.stopPlaybackSDCard (new MeariDeviceListener () {
    @Override
    public void onSuccess (String successMsg) {
        
    }

    @Override
    public void onFailed (String errorMsg) {

    }
});

// download record
deviceController.startDownloadSdRecord(channelId, start, end, path, new MeariDeviceSdRecordDownloadListener() {
    @Override
    public void onSuccess(int index) {
        MeariUser.getInstance().getSdRecordDownloadProgress()
    }

    @Override
    public void onFailed(int code, String msg) {

    }
});

// progress of downloading record
MeariUser.getInstance().getSdRecordDownloadProgress(new IProgressCallback() {
    @Override
    public void onSuccess(int progress) {
        if (progress >= 100) {
            // stop download when download is success
            deviceController.stopDownloadSdRecord(channel, index, new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
                
            }

            @Override
            public void onFailed(String errorMsg) {
                
            }
        });

        }
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {

    }
});

// delete record of one day
deviceController.deleteSdRecordOfDay(cameraInfo.getNvrChannelId(), ymd, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        MeariUser.getInstance().getSdRecordDeleteState()
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});

// status of deleting record
MeariUser.getInstanace().getSdRecordDeleteState(new IProgressCallback() {
    @Override
    public void onSuccess(int state) {
        if (state == 0) {
            // not under deleting, success
        } else {
            // under deleting
        }
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {

    }
});
```

### 6.2.3 Device cloud playback

```
[description]
The device can do cloud playback when it opened the cloud service.

[Function call]

Use the following method if cameraInfo.getEvt() < 1:
/**
 * get the day which has video in one month
 * @param deviceID device id
 * @param year year
 * @param month month
 * @param callback callback
 */
public void getCloudHaveVideoDaysInMonth(String deviceID, int year, int month, ICloudHaveVideoDaysCallback callback);
Use the following method if cameraInfo.getEvt() == 1:
/**
 * get the day which has video in one month
 * @param deviceID device id
 * @param year year
 * @param month month
 * @param callback callback
 */
public void getCloudHaveShortVideoDaysInMonth(String deviceID, int year, int month, ICloudHaveVideoDaysCallback callback);

Use the following method if cameraInfo.getEvt() < 1:
/**
 * get all the video clips in one day
 * @param deviceID device id
 * @param year year
 * @param month month
 * @param day day
 * @param callback callback
 */
public void getCloudVideoTimeRecordInDay(String deviceID, int year, int month, int day, ICloudVideoTimeRecordCallback callback);
Use the following method if cameraInfo.getEvt() == 1:
/**
 * get all the video clips in one day
 * @param deviceID device id
 * @param year year
 * @param month month
 * @param day day
 * @param callback callback
 */
public void getCloudShortVideoTimeRecordInDay(String deviceID, int year, int month, int day, ICloudShortVideoTimeRecordCallback callback);

Use the following method if cameraInfo.getEvt() < 1:
/**
 * get the video information
 * @param deviceID device id
 * @param index index of time  for example: 00:30:00 is 1, 01:00:00 is 2
 * @param year year
 * @param month month
 * @param month day
 * @param callback callback
 */
public void getCloudVideo(String deviceID, int index, int year, int month, int day, ICloudGetVideoCallback callback);
Use the following method if cameraInfo.getEvt() == 1:
/**
 * get the video information
 * @param deviceID device id
 * @param index index of time  for example: 00:20:00 is 1, 00:40:00 is 2
 * @param year year
 * @param month month
 * @param month day
 * @param callback callback
 */
public void getCloudShortVideo(String deviceID, int index, int year, int month, int day, ICloudGetShortVideoCallback callback);

[Code example]

// get the day which has video in one month
Call the following mehod when cameraInfo.getEvt() < 1:
MeariUser.getInstance().getCloudHaveVideoDaysInMonth(deviceId, year, month, new ICloudHaveVideoDaysCallback() {
    @Override
    public void onSuccess(String yearAndMonth, ArrayList<Integer> haveVideoDays) {
               
    }

    @Override
    public void onError(int code, String error) {

    }
});
Call the following mehod when cameraInfo.getEvt() == 1:
MeariUser.getInstance().getCloudHaveShortVideoDaysInMonth(deviceId, year, month, new ICloudHaveVideoDaysCallback() {
    @Override
    public void onSuccess(String yearAndMonth, ArrayList<Integer> haveVideoDays) {
               
    }

    @Override
    public void onError(int code, String error) {

    }
});

// get all the video clips in one day
Call the following mehod when cameraInfo.getEvt() < 1:
MeariUser.getInstance().getCloudVideoTimeRecordInDay(deviceId,year, month, day, new ICloudVideoTimeRecordCallback(){
    @Override
    public void onSuccess(String yearMonthDay, ArrayList<VideoTimeRecord> recordList) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});
Call the following mehod when cameraInfo.getEvt() == 1:
MeariUser.getInstance().getCloudShortVideoTimeRecordInDay(deviceId,year, month, day, new ICloudShortVideoTimeRecordCallback(){
    @Override
    public void onSuccess(long historyEventEnable, long cloudEndTime, String todayStorageType, String yearMonthDay, ArrayList<VideoTimeRecord> recordList, ArrayList<VideoTimeRecord> eventList) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});

// get the video information
Call the following mehod when cameraInfo.getEvt() < 1:
MeariUser.getInstance().getCloudVideo(deviceid, index, year, month, day, new ICloudGetVideoCallback() {
    @Override
    public void onSuccess(String videoInfo, String startTime, String endTime) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});
Call the following mehod when cameraInfo.getEvt() == 1:
MeariUser.getInstance().getCloudShortVideo(deviceid, index, year, month, day, new ICloudGetShortVideoCallback() {
    @Override
    public void onSuccess(String videoInfo, String startTime, String endTime) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});
```

## 6.3 Device related
### 6.3.1 Doorbell answering process

- 1 Receive doorbell call message
> Press the doorbell, receive the doorbell call mqtt message callback or push message
> Need to connect to mqtt or access push
```
/**
 * doorbell call callback
 * @param bellJson doorbell info
 * @param isUpdateScreenshot Whether this message is to update the picture; false-call; true-update the picture
 */
public void onDoorbellCall(String bellJson, boolean isUpdateScreenshot);
```

- 2 Pop up the doorbell answering page
> Through the mqtt message callback or click on the push message to pop up the doorbell answering page
> Parse bellJson and display relevant information
```
//Get doorbell information
bellJsonStr = bundle.getString("bellInfo");
try {
    JSONObject bellJsonObject = new JSONObject(bellJson);
    CameraInfo bellInfo = JsonUtil.getCameraInfo(bellJsonObject);
} catch (JSONException e) {
}
```

- 3 Answer or hang up
> Handle the logic of answering, hanging up, etc.
> Answering is similar to previewing
```
// answer
MeariUser.getInstance().postAnswerBell(bellInfo.getDeviceID(), String.valueOf(bellInfo.getMsgID()), new IStringResultCallback() {
    @Override
    public void onError(int code, String error) {
        if (code == 1045) {
            // someone has answered
        } else {
            // other errors, close
        }
    }

    @Override
    public void onSuccess(String result) {
        acceptSuccess();
    }
});

private void acceptSuccess() {
    // Heartbeat every 20s
    MeariUser.getInstance().postSendBellHeartBeat(bellInfo.getDeviceID());
    // StartConnect and preview
    ...
}

// hang up
MeariUser.getInstance().postHangUpBell(bellInfo.getDeviceID(), new IResultCallback() {
    @Override
    public void onSuccess() {
        // Close the hole, close the page
        ...
    }

    @Override
    public void onError(int code, String error) {
        // Close the hole, close the page
        ...
    }
});
```

### 6.3.2 Master Message

> Doorbell devices that support messages can record messages and choose to play them when answering the call.

- 1 Determine whether to support the message function
```
if (MeariDeviceUtil.isSupportHostMessage(cameraInfo)) {
}

// The maximum number of master messages
private int voiceMailMaxSize;
// The maximum time for the owner to leave a message (seconds)
private int voiceMailDuration = 10;

if (cameraInfo.getHms() == 1) {
    voiceMailMaxSize = 1;
    voiceMailDuration = 30;
} else if (cameraInfo.getHms() == 2){
    voiceMailMaxSize = 3;
    voiceMailDuration = 10;
}
```

- 2 Get device message list
```
MeariUser.getInstance().getVoiceMailList(cameraInfo.getDeviceID(), this, new IGetVoiceMailListCallback() {
    @Override
    public void onSuccess(ArrayList<VoiceMailInfo> voiceMailList) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```
- 3 To record and upload messages, microphone permission is required
```
private String g711uFilePath;
private String wavFilePath;
private String pcmFilePath;

// start recording
controller.startRecordVoiceMail(pcmFilePath, g711uFilePath);

// end recording
controller.stopRecordVoiceMail();

// convert format
controller.changeG711u2WAV(g711uFilePath, wavFilePath, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {
    }
});

// upload message
File wavFile = new File(wavFilePath);
List<File> fileList = new ArrayList<>();
fileList.add(wavFile);
MeariUser.getInstance().uploadVoiceMail(cameraInfo.getDeviceID(), voiceMailName, fileList, new IUploadVoiceMailCallback() {
    @Override
    public void onSuccess(VoiceMailInfo voiceMailInfo) {
        
    }

    @Override
    public void onError(int code, String error) {
        handler.sendEmptyMessage(MSG_UPLOAD_RECORD_FAILED);
    }
});
```

- 4 Control device to play message
```
MeariUser.getInstance().sendVoiceMail(cameraInfo.getDeviceID(), voiceMailInfo.getVoiceId(), this, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

- 5 Play message on mobile phone
```
// download message
MeariUser.getInstance().downloadFile(voiceMailInfo.getVoiceUrl(), destFileDir, destFileName, new IDownloadFileCallback() {
    @Override
    public void onSuccess(File file) {
        changeWav2Pcm(file);
    }
    @Override
    public void downloadProgress(long currentSize, long totalSize, float progress, long networkSpeed) {
    }
    @Override
    public void onError(int code, String error) {
    }
});

// convert format
controller.changeG711u2Pcm(wavFilePath, pcmFilePath, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
    }

    @Override
    public void onFailed(String errorMsg) {
    }
});

// play message
AudioUtil.getInstance().playPCM(pcmFilePath);
AudioUtil.getInstance().setOnPlayListener(flag -> {
    // play complete
    Message msg = Message.obtain();
    msg.what = MSG_PLAY_RECORD_COMPLETE;
    msg.obj = type;
    handler.sendMessage(msg);
});
```

# 7 Share device

## 7.1 Introduction of related class

ShareUserInfo Share user information
-String userAccount; User account
-String userName; User name
-String userIcon; User avatar
-String shareStatus; Share status.0-Not shared; 1-Shared; 2-Wait to receive

ShareDeviceInfo shared device information
-long deviceID; device ID
-String deviceName; device name
-String deviceIcon; device icon
-List <String> shareUserList; list of users shared by the device

## 7.2 Get device share list
```
【description】
Get device share list

[Function call]
/**
 * Get device share list
 *
 * @param deviceID device ID
 * @param callback Function callback
 * /
public void getShareListForDevice (String deviceID, IShareUserListCallback callback);

[Code example]
MeariUser.getInstance (). GetShareListForDevice (cameraInfo.getDeviceID (), new IShareUserListCallback () {
    @Override
    public void onSuccess (ArrayList <ShareUserInfo> shareUserInfoList) {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 7.3 Get history share list
```
【description】
Get history share list

[Function call]
/**
 * Get history share list
 *
 * @param deviceID device ID
 * @param callback Function callback
 * /
public void getHistoryShare (String deviceID, IShareUserListCallback callback);

[Code example]
MeariUser.getInstance (). GetHistoryShare (cameraInfo.getDeviceID (), new IShareUserListCallback () {
    @Override
    public void onSuccess (ArrayList <ShareUserInfo> shareUserInfoList) {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 7.4 Get shared results of all devices
```
【description】
Get shared results of all devices

[Function call]
/**
 * Get sharing results of all devices
 *
 * @param callback Function callback
 * /
public void getAllDeviceShare (IShareDeviceListCallback callback);

[Code example]
MeariUser.getInstance (). GetAllDeviceShare (new IShareDeviceListCallback () {
    @Override
    public void onSuccess (ArrayList <ShareDeviceInfo> shareDeviceInfoList) {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 7.5 Search users
```
【description】
Search users

[Function call]
/**
 * Search for a user
 *
 * @param account
 * @param deviceID device ID
 * @param phoneCode country phone code
 * @param callback Function callback
 * /
public void searchUser (String account, String deviceID, String phoneCode, ISearchUserCallback callback)

[Code example]
MeariUser.getInstance (). SearchUser (account, deviceID, phoneCode, new ISearchUserCallback () {
    @Override
    public void onSuccess (ShareUserInfo shareUserInfo) {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 7.6 Share device
```
【description】
Share device

[Function call]
/**
 * Share device
 * @param account
 * @param deviceID device ID
 * @param phoneCode country phone code
 * @param callback Function callback
 * /
public void shareDevice (String account, String deviceID, String phoneCode, IResultCallback callback);

[Code example]
MeariUser.getInstance (). ShareDevice (account, deviceID, phoneCode, new IResultCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 7.7 Cancel shared device
```
【description】
Cancel shared device

[Function call]
/**
 * Cancel shared device
 * @param account
 * @param deviceID device ID
 * @param phoneCode country phone code
 * @param callback Function callback
 * /
public void cancelShareDevice (String account, String deviceID, String phoneCode, IResultCallback callback);

[Code example]
MeariUser.getInstance (). CancelShareDevice (account, cameraInfo.getDeviceID (), phoneCode, new IResultCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 7.8 Delete history shared user
```
【description】
Delete history shared user

[Function call]
/**
 * Delete history shared users
 *
 * @param accountArray user array
 * @param deviceID device ID
 * @param callback Function callback
 * /
public void deleteHistoryShare (String accountArray, String deviceID, IResultCallback callback);

[Code example]
MeariUser.getInstance (). DeleteHistoryShare (accountArray, deviceID, new IResultCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 7.9 Processing shared messages
```
【description】
Processing shared messages

[Function call]
/**
 * Handle shared messages
 *
 * @param msgID message ID
 * @param dealFlag 0-reject; 1-accept
 * @param callback Function callback
 * /
public void dealShareMessage (long msgID, int dealFlag, IResultCallback callback);

[Code example]
MeariUser.getInstance (). DealShareMessage (msgID, dealFlag, new IResultCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

# 8 Message Center
## 8.1 Device shared messages

### 8.1.1 Get list of the device shared message
```
【description】
Get list of device shared message

[Function call]
/**
 * Get share message list of devicw
 *
 * @param callback Function callback
 * /
public void getShareMessage (IShareMessageCallback callback);

[Method call]

ShareMessage
-String date; Message time
-String msgID; Message ID
-String state; Message status: 1-receive; 0-reject
-String shareName; name of the person being shared
-String deviceName; device name

MeariUser.getInstance (). GetShareMessage (new IShareMessageCallback () {
    @Override
    public void onSuccess (ArrayList <ShareMessage> shareMessages) {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

### 8.1.2 Delete shared messages of device
```
【description】
Delete shared messages of device

[Function call]
/**
 * Delete share messages of device
 *
 * @param msgIDList Message ID array
 * @param callback Function callback
 * /
public void deleteShareMessage (List <String> msgIDList, IResultCallback callback);

[Method call]

MeariUser.getInstance (). DeleteShareMessage (msgIDList, new IResultCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```
## 8.2 Device alarm message

### 8.2.1 Get the newest message of all device
```
【description】
Get the newest message of all device

[Function call]
/**
 * Get the newest message of all device if cameraInfo.getEvt() < 1
 *
 * @param callback function callback
 */
public void getAllDeviceAlarmListWithNewestMsg(IBaseModelCallback callback);

/**
 * Get the newest message of all device if cameraInfo.getEvt() == 1
 *
 * @param callback function callback
 */
public void getAllDeviceAlarmListWithNewestMsgNew(IBaseModelCallback callback);

Calling the above two methods and merge the data if you have the device which cameraInfo.getEvt < 1 and the device which cameaInfo.getEvt() == 1

[Method call]

MeariUser.getInstance().getAllDeviceAlarmListWithNewestMsgNew(new IBaseModelCallback<List<DevicesWithNewestMsg>>() {
                    @Override
                    public void onSuccess(List<DevicesWithNewestMsg> devicesWithNewestMsgs) {
                        
                    }

                    @Override
                    public void onFailed(int code, String errorMsg) {
                        
                    }
                });
MeariUser.getInstance().getAllDeviceAlarmListWithNewestMsg(new IBaseModelCallback<List<DevicesWithNewestMsg>>() {
                    @Override
                    public void onSuccess(List<DevicesWithNewestMsg> devicesWithNewestMsgs) {

                    }

                    @Override
                    public void onFailed(int code, String errorMsg) {
                        
                    }
                });

DevicesWithNewestMsg
devLocalTime 20230613101425
deviceID device ID
imageAlertType message type 1:PIR   2:movement detection  3:visitor   6:noise  7:cry  8:face recognition  9:calling   10:tamper alarm  11:human detection  12:face detection  17:smart car detection  18:smart pet detection  19:smart package detection  20:smart human detection
deviceName get the device name from the device list by device ID
```

### 8.2.2 Get alarm messages of a single device
```
【description】
Get alarm messages of a single device

[Function call]
Use the following method if cameraInfo.getEvt() < 1:
/**
 * Get the alarm message of a single device (get the latest 20 messages at a time, after the device owner pulls it, the server deletes the data, pay attention to save the data)
 *
 * @param deviceId device id
 * @param day date yyyyMMdd
 * @param callback function callback
 * /
public void getAlertMsg (long deviceId, String day, IGetAlarmMessagesCallback callback);

Use the following method if cameraInfo.getEvt() == 1:
/**
 * Get the alarm message of a single device (get the latest 20 messages at a time, the server will delete the data after 30 days if user open the cloud service, otherwise is 7 days)
 *
 * @param deviceId device id
 * @param day date yyyyMMdd
 * @param index pass "0" when direction=1, pass the eventTime of the last message when direction=0
 * @param direction 1: refresh 0: load more
 * @param eventType message type, for filtering
 "1": "motion",
 "2": "pir",
 "3": "bell",
 "6": "decibel",
 "7": "cry",
 "9": "baby",
 "10": "tear",
 "11": "human",
 "12": "face",
 "13": "safety",
 * @param aiType ai type, for filtering
 "0": "people"
 "1": "pet"
 "2": "car is comming"
 "3": "car retention"
 "4": "car is driving away"
 "5": "package is dropping down"
 "6": "package retention"
 "7": "package has taken"
 * @param callback function callback
 */
 public void getAlertMsgWithVideo(long deviceId, String day, String index, int direction, int eventType, int[] aiType, IDeviceAlarmMessagesCallback callback);
 Passing eventType=0 and aiType=null if you want to get all messages


【Method call】

class DeviceAlarmMessage:
Common fields:
-long deviceID; // device ID
-String deviceUuid; // device unique identifier
-int imageAlertType; // Alarm type (PIR and Motion)
-int msgTypeID; // message type
-long userID; // User Id
-long userIDS;// if it's a shared device, the value is 0, or it will be user id
-String createDate; // wear time
-String isRead; // whether read
-String decibel; // dB
-long msgID; // Message Id

exclusive for cameraInfo.getEvt() < 1
-String imgUrl; // Alarm picture address
-String tumbnailPic; // Thumbnails

exclusive for cameraInfo.getEvt() == 1
- long imageUrl;  // Alarm picture address 
- String eventTime; // event time
- List<AiVideoInfo> aiVideoInfo // ai analysis information
AiVideoInfo 
name: people,car,pet,package
event: //  "come" is default for people and pet, no ther status
       //  package and car has 3 status:"come" "stay" "go"
       //  "come" means package is dropping down, car is comming
       //  "stay" means package retention, car retention
       //  "go " means package has taken, car is driving away
left: the distance from left in the alarm picture, for draw box
top: the distance from top in the alarm picture, for draw box
width: the width of box, for draw box
height: the height of box, for draw box
- List<VideoInfo> videoUrl // the url of alarm short video
VideoInfo
url: download url
duration: the duration of the video clip
- long historyEventEnable // the time when device update to evt==1

Call the following mehod when cameraInfo.getEvt() < 1:
MeariUser.getInstance().getAlertMsg(getMsgInfo().getDeviceID(), day, new IDeviceAlarmMessagesCallback() {
    @Override
    public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo) {

    }

    @Override
    public void onError(int code, String error) {
    }
});

Call the following mehod when cameraInfo.getEvt() == 1:
MeariUser.getInstance().getAlertMsgWithVideo(deviceId, day, index, direction, eventType, aiType, new IDeviceAlarmMessagesCallback() {
                @Override
                public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo) {
                
                }

                @Override
                public void onError(int code, String error) {
                    
                }
            });
Call the following mehod to decrypt the picture
/**
 * decrypt the picture
 *
 * @param url the download url of the picture
 * @param img byte array of the picture
 * @param sn device sn
 * @param device password, default it has no password, the parameter is empty set
 * @return [byte[], bool] the picture data after decrypted, result
 */
Object[] result = SdkUtils.handleEncodedImage(String url, byte[] img, String sn, Set<String> allPwd)

Using the following method to download short video:
/**
 * generate m3u8 to specified path
 *
 * @param videoInfoList videoUrl form DeviceAlarmMessage
 * @param path_m3u8 output path of m3u8
 */
String path_m3u8 = SdkUtils.getM3U8Path(List<VideoInfo> videoInfoList, String path_m3u8)

// Using the first url of video to check if the video is encrypted
VideoInfo videoInfo = videoInfoList.get(0);
String url = videoInfo.getUrl();
String[] strList = url.split("__");
String v = strList[1];
if (v.startsWith("vn")) {
    // not encrypted
    SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, "")
} else {
    String decKey = "";
    if (v.startsWith("v2")) {
        // license encrypted
        decKey = SdkUtils.formatLicenceId(cameraInfo.getSnNum());
        SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, decKey)
    } else {
        Set<String> curDecKey =  the device password that is setting form user
        keyCheckStr = v.split("-")[1];
        for (String key: curDecKey) {
            keyCheckStr=" + keyCheckStr + " " + MeariMediaUtil.checkVideoPwd(keyCheckStr, key));
            if (MeariMediaUtil.checkVideoPwd(keyCheckStr, key) == 0) {
                decKey = key;
                SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, decKey)
                break;
            } else {
                // password is not right
            }
        }
    }        
}

/**
 * download mp4 file from m3u8
 *
 * @param path_m3u8 path of m3u8
 * @param path_mp4 path of mp4
 * @param decKey password
 */
String path_m3u8 = SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, String decKey)

// play short video
<LinearLayout
  android:id="@+id/ll_video_view"
  android:layout_width="match_parent"
  android:layout_height="match_parent"
  android:background="@color/dark"
  android:orientation="horizontal">
  <com.ppstrong.weeye.widget.media.IjkVideoView
    android:id="@+id/video_view"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:layout_gravity="center" />
</LinearLayout>

IjkVideoView mVideoView = findViewById(R.id.video_view)
CloudPlayerController cloudPlayerController = new CloudPlayerController(context, mVideoView, new ICloudPlayerCallback() {
            @Override
            public void mediaPlayingCallback() {
                // paly success
                
            }

            @Override
            public void mediaPauseCallback() {

            }

            @Override
            public void upDateProgress(long postion) {
                // play progress

            }

            @Override
            public void mediaPlayFailedCallback(int code) {
                // play failed

            }

            @Override
            public void playNext() {
                // play complete

            }

            @Override
            public void stopRecordVideo() {

            }

            @Override
            public void showStopRecordVideoView(String path) {

            }

            @Override
            public void screenshotSuccess(String path) {

            }
        });
cloudPlayerController.setPlayOther(true);
if (!TextUtils.isEmpty(curDecKey)) {
    Set<String> keys = new HashSet<>();
    keys.add(curDecKey);
    cloudPlayerController.setDecKey(keys);
}
// start play
cloudPlayerController.play(path_mp4, "0");
// play from any time(millisecond)
if (isEnd) {
    // play again and pass the seek time when the video is complete
    cloudPlayerController.play(path_mp4, "0");
    cloudPlayerController.play(path_mp4, String.valueOf(millisecond / 1000));
} else  {
    // seek directly
    cloudPlayerController.seekTo(millisecond);
}
```

### 8.2.3 Delete device messages
```
【description】
Delete device messages

[Function call]

Delete device messages
Use the following method if cameraInfo.getEvt() < 1:
/**
 * Delete device messages
 *
 * @param deviceIDs device ID list
 * @param callback function callback
 */
public void deleteDevicesAlarmMessage(List<Long> deviceIDs, IResultCallback callback);

Use the following method if cameraInfo.getEvt() == 1:
/**
 * Delete device messages
 *
 * @param deviceID device ID
 * @param callback function callback
 */
 public void delAlertEventByDevice(String deviceID, IResultCallback callback);

Delete device messages(by day)
Delete the cached messages by day if cameraInfo.getEvt() < 1

Use the following method if cameraInfo.getEvt() == 1:
/**
 * Delete device messages(by day)
 *
 * @param deviceID device ID
 * @param day date yyyyMMdd
 * @param callback function callback
 */
 public void delAlertEventByDay(String deviceID, String day, IResultCallback callback);

Delete device messages(by index)
Delete the cached messages by msgID if cameraInfo.getEvt() < 1

Use the following method if cameraInfo.getEvt() == 1:
/**
 * Delete device messages(by index)
 *
 * @param deviceID device ID
 * @param indexList index list  index:deviceAlarmMessage.getEventTime()
 * @param callback function callback
 */
 public void delAlertEventByIndex(String deviceID, List<String> indexList, IResultCallback callback);


【Method call】

Delete device messages
Use the following method if cameraInfo.getEvt() < 1:
MeariUser.getInstance().deleteDevicesAlarmMessage(deviceIDList, new IResultCallback() {
                @Override
                public void onSuccess() {

                }

                @Override
                public void onError(int code, String error) {
                    
                }
            });

Use the following method if cameraInfo.getEvt() == 1:
MeariUser.getInstance().delAlertEventByDevice(deviceID, new IResultCallback() {
                            @Override
                            public void onSuccess() {
                                
                            }

                            @Override
                            public void onError(int errorCode, String errorMsg) {
                                
                            }
                        });

Delete device messages(by day)
Use the following method if cameraInfo.getEvt() == 1:
MeariUser.getInstance().delAlertEventByDay(String.valueOf(cameraInfo.getDeviceID()), day, new IResultCallback() {
                @Override
                public void onError(int errorCode, String errorMsg) {

                }

                @Override
                public void onSuccess() {
                    
                }
            });

Delete device messages(by index)
Use the following method if cameraInfo.getEvt() == 1:
List<String> _index = new ArrayList<>();
for (DeviceAlarmMessage message : deleteMessages) {
    if (!TextUtils.isEmpty(message.getEventTime())) {
        _index.add(message.getEventTime());
    }        
}  
MeariUser.getInstance().delAlertEventByIndex(String.valueOf(cameraInfo.getDeviceID()), _index, new IResultCallback() {
                    @Override
                    public void onSuccess() {
                        
                    }

                    @Override
                    public void onError(int errorCode, String errorMsg) {
                        
                    }
                });
```

## 8.3 System Message

### 8.3.1 Get system message list
```
【description】
Get list of system messages

[Function call]
/**
 * Get system message list
 *
 * @param callback function callback
 * /
public void getSystemMessage (ISystemMessageCallback callback);

[Method call]

class SystemMessage:
-long msgID; // message Id
-int msgTypeID; // message type
-String isRead; // whether read
-Date createDate; // Creation time
-Date updateDate; // Update time
-long userID; // User Id
-String userAccount; // User account
-String nickName; // user name
-String delState; // Whether to process
-long deviceID; // device Id
-String deviceName; // device name
-String deviceUUID; // device identifier
-long userIDS; // Requester Id
-String imageUrl; // Avatar

MeariUser.getInstance (). GetSystemMessage (new ISystemMessageCallback () {
    @Override
    public void onSuccess (List <SystemMessage> systemMessageList) {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

### 8.3.2 Delete system messages
```
【description】
Delete system messages

[Function call]
/**
 * delete system message by message ID
 * Delete system messages
 *
 * @param msgIdList message id
 * @param callback function callback
 * /
public void deleteSystemMessage (List <String> msgIdList, final IResultCallback callback);

[Method call]

MeariUser.getInstance (). DeleteSystemMessage (msgIdList, new IResultCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```



# 9 Device settings
Used to set the camera's detection alarm, sleep mode, local playback, etc.
Whether different devices support a certain setting can be judged by the device's capability set.


## 9.1 Device capability
If (cameraInfo.getLed() == 1) {
    / / Support switch settings such as LED
} else {
    // does not support switch settings such as LEDs
}

device Capability

- int dcb; noise alarm: 0-not supported; 1-support
- int pir; human detection: 0-not supported; 1-support pir switch and high/medium/low setting; 2-support pir switch only; 3-reserved; 4-support pir switch and high/low setting; 5-support double pir(left/right) switch and global sensitivity setting(high/low)(for normal power device); 6-support double pir(left/right) switch and global sensitivity setting(high/low)(for low power consumption device); 7- support pir switch and pir sensitivity setting(10 levels); 8-support pir switch and pir sensitivity setting(refer to plv), defalut is 10
- int plv; pir level: 0-not supported; 10-support level 10(1-10)
- int md; motion detection: 0-not supported; 1-support
- int cst; cloud storage : 0 - not supported; 1 - support night vision mode; 2 - support Full Color Mode
- int dnm; day and night mode: 0-not supported; 1-support
- int led; LED lights : 0 - not supported; 1 - support
- int flp; video flip: 0-not supported; 1-support
- int bcd; crying detection: 0-not supported; 1-support
- int ptr; humanoid tracking: 0-not supported; 1-support
- int pdt; humanoid detection: 0-not supported; bit0-support switch setting; bit1-support picture frame setting; bit2-support night filter switch setting; bit3-support day filter switch setting
- int ptz; pan-tilt: 0-not supported; 1-support left/top/right/bottom; 2-support top/bottom; 3-support left/right
- int sla; sound and light alarm: 0-not supported; 1-support

## 9.2 Device parameters

- String firmwareCode; firmware code ppstrong-c2-neutral-1.0.0.20190617
- String firmwareVersion; firmware version 1.0.0
- String wifiName; WiFi name to which the device is connected
- int wifiStrength; WiFi strength to which the device is connected: 0 to 100;
- int netMode; current network mode: 0-wireless; 1-wired; 2-4G; 3-unknown
- int ledEnable; LED indicator status: 0-off; 1-on;
- int mirrorEnable; video flip: 0-normal; 1-flip;
- int sdRecordType; SD card recording type: 0-event recording; 1-all day recording;
- int sdRecordDuration; SD card recording time (seconds): 20, 30, 40, 60, 120, 180
- int dayNightMode; day-night mode: 0-automatic; 1-day mode; 2-night mode;
- int fullColorMode; Full Color Mode: 0-Intelligent vision；1-Full color night vision；2-Black and white night vision；
- int sleepMode; sleep mode: 0-not sleep; 1-sleep; 2-timed sleep; 3-geo fencing sleep;
- String sleepTimeList; List of sleep time: json array
- String sleepWifi; Geo-fencing sleep WiFi
- int motionDetEnable; motion detection switch: 0-off; 1-on;
- int motionDetSensitivity; Motion detection sensitivity: 0-low; 1-medium; 2-high;
- int PirDetEnable; human detection switch: 0-off; 1-on;
- int PirDetSensitivity; human detection sensitivity: 0-low; 1-medium; 2-high;
- int soundDetEnable; sound alarm switch: 0-off; 1-on;
- int soundDetSensitivity; sound alarm sensitivity: 0-low; 1-medium; 2-high;
- int cryDetEnable; cry detection enable switch: 0-off; 1-on;
- int humanDetEnable; human shape detection switch: 0-off; 1-on;
- int humanFrameEnable; humanoid picture frame swi: 0-tchoff; 1-on;
- int humanTrackEnable; humanoid tracking switch: 0-off; 1-on;
- int onvifEnable; Onvif switcher: 0-off; 1-on;
- String onvifPwd; Onvif password
- String onvifUrl; Onvif service network address
- int h265Enable; H265 switch: 0-H264; 1-H265
- String alarmPlanList; list of alarm plan time: json array
- int temperature;
- int humidity;
- int speakVolume; speaker volume during intercom (doorbell, battery camera): 0-100
- int powerType; Power supply mode: 0-battery; 1-power; 2-battery plus power
- int batteryPercent; 0-100
- int batteryRemaining; remaining battery life: minutes (inaccurate, not used for the time being)
- int chargeStatus; battery charge status: 0-uncharged; 1-charging; 2-full
- int wirelessChimeEnable; wireless bell switch: 0-off; 1-on
- int wirelessChimeVolume; volume of wireless bell: 0-100
- String wirelessChimeSongs; song list of wireless bell: ["song1", "song2", "song3"]
- int soundLightEnable; sound and light alarm switch: 0-off; 1-on;
- int soundLightType; sound and light alarm mode: 0-sound alarm; 1-white light alarm; 2-sound and light alarm;

## 9.3 Format device SD Card
```
【description】
The device formats the SD card. After the formatting is successful, the formatting progress is obtained through the mqtt message.

[Function call]
/**
 * Get device SD card information
 *
 * @param callback Function callback
 * /
public void getSDCardInfo (ISDCardInfoCallback callback);

/**
 * Start formatting SD card
 *
 * @param callback Function callback
 * /
public void startSDCardFormat (ISDCardFormatCallback callback);

/**
 * Get SD card progress
 *
 * @param callback Function callback
 * /
public void getSDCardFormatPercent (ISDCardFormatPercentCallback callback)

[Code example]


SDCardInfo
-sdStatus SD card status 0: No SD card; 1: Normal use; 2: Card read and write abnormal; 3: Formatting; 4: File system is not supported; 5: Card is being recognized; 6: Unformatted; 7: Other errors
-sdCapacity SD card total capacity
-sdRemainingCapacity SD card remaining capacity

// Get SD card information of device
MeariUser.getInstance (). GetSDCardInfo (new ISDCardInfoCallback () {
    @Override
    public void onSuccess (SDCardInfo sdCardInfo) {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});

// start formatting SD card
MeariUser.getInstance (). StartSDCardFormat (new ISDCardFormatCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});

// Get the process of formatting SD card
MeariUser.getInstance (). GetSDCardFormatPercent (new ISDCardFormatPercentCallback () {
    @Override
    public void onSuccess (int percent) {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```


## 9.4 Upgrade Device Firmware
```
【description】
Upgrade device firmware

[Function call]

DeviceUpgradeInfo
-boolean forceUpgrade; whether to force upgrade
-int upgradeStatus; whether it can be upgraded 0-No; 1-Yes
-String newVersion; New version
-String upgradeDescription; New version description
-String upgradeUrl; new version address

/**
 * Check if the device has a new version
 *
 * @param devVersion device version
 * @param licenseID device sn
 * @param tp device tp
 * @param callback callback
 * /
public void checkNewFirmwareForDev(String devVersion, String licenseID, String tp, ICheckNewFirmwareForDevCallback callback)

/**
 * Start to upgrade device firmware
 *
 * @param upgradeUrl upgrade address
 * @param upgradeVersion upgrade version
 * @param callback Function callback
 * /
public void startDeviceUpgrade (String upgradeUrl, String upgradeVersion, IDeviceUpgradeCallback callback);

/**
 * Get progress of firmware upgrade
 * @param callback Function callback
 * /
public void getDeviceUpgradePercent (IDeviceUpgradePercentCallback callback);

/**
 * Get the firmware version of device
 * @param deviceID device id
 * @param callback Function callback
 * /
public void getDeviceFirmwareVersion(String deviceID, IStringResultCallback callback)


[Code example]

If you not get the deviceParams，call MeariUser.getInstance().getDeviceParams() first.
DeviceParams deviceParams = getCachedDeviceParams()
String firmwareVersion = deviceParams.getFirmwareCode()
MeariUser.getInstance().checkNewFirmwareForDev(firmwareVersion, cameraInfo.getSnNum, cameraInfo.getTp(), new ICheckNewFirmwareForDevCallback() {
    @Override
    public void onSuccess(DeviceUpgradeInfo info) {
        // if info.yougetUpgradeStatus() != 0, it has new version
    }

    @Override
    public void onError(int code, String error) {
    }
});

// If you can upgrade, start the upgrade
MeariUser.getInstance (). StartDeviceUpgrade (deviceUpgradeInfo.getUpgradeUrl (), deviceUpgradeInfo.getNewVersion (), new IDeviceUpgradeCallback () {
    @Override
    public void onSuccess () {

    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {

    }
});

// Get the progress of upgrade
MeariUser.getInstance (). GetDeviceUpgradePercent (new IDeviceUpgradePercentCallback () {
    @Override
    public void onSuccess (int percent) {

    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {

    }
});

// Get the firmware verion of device
MeariUser.getInstance().getDeviceFirmwareVersion(cameraInfo.getDeviceID(), new IStringResultCallback() {

            @Override
            public void onSuccess(String result) {
                try {
                    BaseJSONObject object = new BaseJSONObject(result);
                    BaseJSONObject resultObject = object.optBaseJSONObject("result");
                    String currentVersion = resultObject.optString("devVersion");
                    int protocolVersion = resultObject.optInt("protocolVersion");
                    if (currentVersion.equals(deviceUpgradeInfo.getNewVersion())) {
                        // finish reboot
                        CameraInfo cameraInfo = MeariUser.getInstance().getCameraInfo();
                        // update the cameraInfo
                        cameraInfo.setProtocolVersion(protocolVersion);
                        JsonUtil.getCameraCapability(cameraInfo,resultObject);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(int errorCode, String errorMsg) {
                
            }
        })
```


## 9.5 Basic parameter settings

### 9.5.1 Get device parameters
```
【description】
Get all parameters of the device

[function call]
/**
 * Get the parameters of the device
 *
 * @param callback Function callback
 */
public void getDeviceParams(IGetDeviceParamsCallback callback);

[code example]
MeariUser.getInstance().getDeviceParams(new IGetDeviceParamsCallback() {
    @Override
    public void onSuccess(DeviceParams deviceParams) {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.2 Device LED light switch control
```
【description】
Device LED light switch control

[function call]
/**
 * Set LED light on or off
 *
 * @param ledEnable 0-off; 1-on
 * @param callback Function callback
 */
public void setLED(int ledEnable, ISetDeviceParamsCallback callback);

[code example]
MeariUser.getInstance().setLED(ledEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.3 Device preview video flip control
```
【description】
Device preview video flip control

[function call]
/**
 * Set whether the video is mirrored
 *
 * @param mirrorEnable 0-normal;1-mirror
 * @param callback Function callback
 */
public void setMirror(int mirrorEnable, ISetDeviceParamsCallback callback);

[code example]
MeariUser.getInstance().setMirror(mirrorEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.4 Device local recording setting
```
【description】
Local recording type and time of event recoding segment setting of the device

[function call]
/**
 * Local recording type and the time of event recoding segment setting of device
 *
 * @param type Recording type
 * @param duration Event recording time
 * @param callback Function callback
 */
public void setPlaybackRecordVideo(int type, int duration, ISetDeviceParamsCallback callback);

[code example]
MeariUser.getInstance().setPlaybackRecordVideo(type, duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.5 Device day and night mode setting
```
【description】
Day and night mode setting of device

[function call]
/**
 * Day and night mode setting of device
 *
 * @param mode mode
 * @param callback Function callback
 */
public void setDayNightMode(int mode, ISetDeviceParamsCallback callback);

[code example]
int currentMode = deviceParams.getDayNightMode()
MeariUser.getInstance().setDayNightMode(mode, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.6 Device sleep mode setting
```
【description】
Sleep mode setting of device

[Function call]
/**
  * Sleep mode setting of device
  *
  * @param mode mode
  * @param callback Function callback
  * /
public void setSleepMode (int mode, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetSleepMode (sleepMode, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.7 Device scheduled sleep period setting
```
【description】
Scheduled sleep period setting of device

[Function call]
/**
  * Scheduled sleep period setting of device
  *
  * @param timeList the period of sleep
  * @param callback Function callback
  * /
public void setSleepModeTimes (String timeList, ISetDeviceParamsCallback callback);

[Code example]

timeList description:
enable: whether to enable
start_time: start time
stop_time: end time
repeat: 1 ~ 7 days in effect every week

[{
     "enable": true,
     "start_time": "03:00",
     "stop_time": "04:00",
     "repeat": [3, 4]
}, {
     "enable": false,
     "start_time": "00:00",
     "stop_time": "03:00",
     "repeat": [1, 2]
}]

MeariUser.getInstance (). SetSleepModeTimes (timeList, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.8 Device motion detection setting
```
【description】
Motion detection setting of device

[Function call]
/**
  * Motion detection setting of device
  *
  * @param motionDetEnable motion detection enable
  * @param motionDetSensitivity motion detection sensitivity
  * @param callback Function callback
  * /
public void setMotionDetection (int motionDetEnable, int motionDetSensitivity, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetMotionDetection (motionDetEnable, motionDetSensitivity, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.9 Device PIR detection setting
```
【description】
PIR detection setting of device

[Function call]
/**
  * PIR detection setting of device
  *
  * @param pirDetEnable PIR detection enable
  * @param pirDetSensitivity PIR detection sensitivity
  * @param callback Function callback
  * /
public void setPirDetection (int pirDetEnable, int pirDetSensitivity, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetPirDetection (pirDetEnable, pirDetSensitivity, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.10 Device noise detection setting
```
【description】
Noise detection setting of device

[Function call]
/**
  * Noise detection setting of device
  *
  * @param soundDetEnable sound detection enable
  * @param soundDetSensitivity sound detection sensitivity
  * @param callback Function callback
  * /
public void setSoundDetection (int soundDetEnable, int soundDetSensitivity, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetSoundDetection (soundDetEnable, soundDetSensitivity, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.11 Device cry alarm setting
```
【description】
Cry alarm setting of device

[Function call]
/**
  * Cry alarm setting of device
  *
  * @param cryDetEnable cry detection
  * @param callback Function callback
  * /
public void setCryDetection (int cryDetEnable, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetCryDetection (cryDetEnable, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.12 Device human tracking setting
```
【description】
Human tracking setting of Device

[Function call]
/**
 * Human tracking setting of Device
 *
 * @param humanTrackEnable human track enable
 * @param callback Function callback
 * /
public void setHumanTrack (int humanTrackEnable, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetHumanTrack (humanTrackEnable, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```

### 9.5.13 Device human detection alarm setting
```
【description】
Human detection alarm setting of device

[Function call]
/**
 * Human detection alarm setting of device
 *
 * @param humanDetEnable human detection enable
 * @param callback Function callback
 * /
public void setHumanDetection (int humanDetEnable, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetHumanDetection (humanDetEnable, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```

### 9.5.14 Device humanoid frame setting
```
【description】
Humanoid frame setting of device

[Function call]
/**
 * Humanoid frame setting of device
 *
 * @param humanFrameEnable human frame enable
 * @param callback Function callback
 * /
public void setHumanFrame (int humanFrameEnable, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetHumanFrame (humanFrameEnable, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```

### 9.5.15 Device Onvif setting
```
【description】
Onvif setting of device

[Function call]
/**
  * Onvif setting of device
  *
  * @param enable onvif enable
  * @param password onvif password
  * @param callback Function callback
  * /
public void setOnvif (int enable, String password, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetOnvif (enable, password, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.16 Device video encoding format setting
```
【description】
Video encoding format setting of device

[Function call]
/**
  * Video encoding format setting of device
  *
  * @param enable H265 enable
  * @param callback Function callback
  * /
public void setVideoEncoding (int enable, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetVideoEncoding (enable, new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.5.17 Device rotation control
```
【description】
Device rotation control

[Function call]

/**
 * Start turning
 *
 * @param direction Direction of rotation
 */
public void startPTZControl(String direction);

/**
 * Stop turning
 *
 */
public void stopPTZControl();

[Code example]

MeariMoveDirection.LEFT
MeariMoveDirection.RIGHT
MeariMoveDirection.UP
MeariMoveDirection.DOWN
MeariUser.getInstance().startPTZControl(MeariMoveDirection.LEFT);
MeariUser.getInstance().stopPTZControl();
```

### 9.5.18 Device alarm plan time period setting
```
【description】
Device alarm plan time period setting

[Function call]
/**
 * Set the time period of the alarm
 *
 * @param timeList he time period of the alarm
 * @param callback Function callback
 */
public void setAlarmTimes(String timeList, ISetDeviceParamsCallback callback);

[Code example]

if (cameraInfo.getAlp() > 0) {
    // support
} else {
    // not support
}

String listString = deviceParams.getAlarmPlanList();

// Support up to 4 groups
[{
    "enable":   false,
    "start_time":   "10:00",
    "stop_time":    "21:00",
    "repeat":   [1]
}, {
    "enable":   true,
    "start_time":   "02:00",
    "stop_time":    "14:00",
    "repeat":   [1, 2, 3, 4, 5, 7]
}]

MeariUser.getInstance().setAlarmTimes(alarmPlanString, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.19 Device push message switch setting
```
【description】
Device push message switch setting

[Function call]
/**
 * Device push message switch setting
 *
 * @param deviceId device id
 * @param status   0-on; 1-off
 * @param callback callback
 */
public void closeDeviceAlarmPush(String deviceId, int status, IPushStatusCallback callback);

[Code example]

int status = cameraInfo.getClosePush();

MeariUser.getInstance().closeDeviceAlarmPush(cameraInfo.getDeviceID(), status, new IPushStatusCallback() {
    @Override
    public void onSuccess(int status) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 9.5.20 Alarm frequency setting
```
【description】
Alarm frequency setting

【Function call】
/**
 * Alarm frequency setting
 *
 * @param alarmFrequency alarmFrequency
 * @param callback callback
 */
public void setAlarmFrequency(int alarmFrequency, ISetDeviceParamsCallback callback);

【Code example】

// Determine whether to support the alarm frequency setting
if (cameraInfo.getAfq() > 0) {
    int afq = cameraInfo.getAfq();
    // afq: 0-not support; 1-support
    afq      bit-0 bit-1 bit-2 bit-3 bit-4 bit-5
    name     off   1min  2min  3min  5min  10min
    setValue 0     1     2     3     4     5
}

// currently selected frequency
int currentValue = deviceParams.getAlarmFrequency()

// Select the alarm frequency
MeariUser.getInstance().setAlarmFrequency(setValue, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.21 PIR level setting
```
【description】
PIR level setting

【Function call】
/**
 * Multi-level PIR setting
 *
 * @param pirDetSensitivity pirDetSensitivity
 * @param callback callback
 */
public void setPirDetectionSensitivity(int pirDetSensitivity, ISetDeviceParamsCallback callback);

【Code example】

// Determine whether to support multi-level PIR settings
if (cameraInfo.getPlv() > 0) {
    int maxLevel = cameraInfo.getPlv();
    setValue 0-maxLevel
}

// currently selected value
int currentLevel = deviceParams.getPirDetLevel();

// Set the value of PIR
MeariUser.getInstance().setPirDetectionSensitivity(pirLevel, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.22 SD card recording type and time setting
```
【description】
SD card recording type and time setting

【Function call】
/**
 * SD card recording type and time setting
 *
 * @param type     Recording type
 * @param duration Event recording time
 * @param callback Function callback
 */
public void setPlaybackRecordVideo(int type, int duration, ISetDeviceParamsCallback callback)

【Code example】

// Determine whether to support event recording and all-day recording
if (cameraInfo.getVer() >= 57){
    if(cameraInfo.getRec() == 0) {
        // Support event recording and all-day recording
    } else if(cameraInfo.getRec() == 1){
        // Only supports event recording
    }
} else {
    if (MeariDeviceUtil.isLowPowerDevice(cameraInfo)) {
        // Only supports event recording
    } else {
        // Support event recording and all-day recording
    }
}

// current event type
int currenttype = deviceParams.getSdRecordType();
// The time of the current event recording
int currentDuration = deviceParams.getSdRecordDuration();

// set type or time
MeariUser.getInstance().setPlaybackRecordVideo(type, duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.23 Device Full Color Mode setting
```
【description】
Full Color Mode setting of device

[function call]
/**
 * Full Color Mode setting of device
 *
 * @param mode mode
 * @param callback Function callback
 */
public void setFullColorMode(int mode, ISetDeviceParamsCallback callback);

[code example]
int currentMode = deviceParams.getFullColorMode();
MeariUser.getInstance().setFullColorMode(mode, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.24 Device sound and light alarm setting
```
【description】
Device sound and light alarm setting

[function call]
/**
 * Set sound and light alarm switch
 *
 * @param enable enable
 * @param callback Function callback
 */
public void setFloodCameraVoiceLightAlarmEnable(int enable, ISetDeviceParamsCallback callback)
/**
 * Set sound and light alarm mode
 *
 * @param alarmType alarmType
 * @param callback Function callback
 */
public void setFloodCameraVoiceLightAlarmType(int alarmType, ISetDeviceParamsCallback callback)

[code example]
int currentEnable = deviceParams.getSoundLightEnable();
MeariUser.getInstance().setFloodCameraVoiceLightAlarmEnable(enable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});

int currentType = deviceParams.getSoundLightType();
MeariUser.getInstance().setFloodCameraVoiceLightAlarmType(type, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.25 Device 12-hour switch setting
```

【description】
Device 12-hour switch settinge

【function call】
/**
 * Device 12-hour switch settinge
 *
 * @param isOpen true 12-hour time system
 * @param callback Function callback
 */
public void postTimeFormat(boolean isOpen, IResultCallback callback) 


【Code example】
//The 12-hour enabled flag bit is stored locally and will be reset to 24 hours after the device is reset.
MeariUser.getInstance().postTimeFormat(isOpen, new IResultCallback() {

            @Override
            public void onError(int errorCode, String errorMsg) {
                
            }

            @Override
            public void onSuccess() {
                
            }
        });
```


### 9.5.26 Device anti-flicker Settings
```

【description】
Device anti-flicker Settings

【function call】
/**
 * Device anti-flicker Settings
 *
 * @param antiflicker 
 * @param callback Function callback
 */
public void setAntiflicker(int antiflicker, ISetDeviceParamsCallback callback) 


【Code example】
1.Whether anti-flicker is supported
/**
     *
     * 
     * - type: integer
     * - description: Whether anti-flicker is supported 
     * 0-nonsupport,  0x1-support 50HZ, 0x2-support 60HZ, 0x4-support Auto, 0x8=support close, Corresponding DP point 202
     */
flk=cameraInfo.getFlk()
if (flk > 0) {
            if (1 << 3 == (1 << 3 & flk)) {
//                0x8=support close
            }
            if (1 == (1 & flk)) {
              //0x1-support 50HZ
            }
            if (1 << 1 == (1 << 1 & flk)) {
//               0x2-support 60HZ
               
            }
            if (1 << 2 == (1 << 2 & flk)) {
//                0x4-support Auto
                
            }
        }

2.Current anti-flicker Settings
/**
     * anti-flicker Settings  //0-close, 1-50HZ, 2-60HZ, 3-Auto
     */
    private int antiflicker;
antiflicker=deviceParams.getAntiflicker();

3.Set anti-flicker
MeariUser.getInstance().setAntiflicker(antiflicker, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
```

### 9.5.27 Device microphone, recording, speaker Settings
```

【description】
Device microphone, recording, speaker Settings
【matters need attention】
1.Microphone (Turn off recording sound at the same time)
2.When the microphone is on, the recording sound can be turned on

【Code example】
1.microphone
/**
     *  - microphone
     *         - description: Microphone enablement switch, 0=forbidden， 1=enabled
     *         - type: integer
     */
    private int microphone;
    //Obtain the current microphone switch status
    microphone=deviceParams.getMicrophone()
//Set microphone switch
MeariUser.getInstance().setMicroPhone(microphone, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SWITCH_Micro_SUCCESS);
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SWITCH_Micro_FAILED);
            }
        });

2.Speaker
/**
     *
     *     - speaker
     *         - description: Speaker ，0=forbidden， 1=enabled
     *         - type: integer
     */
    private int speaker;
    //Obtain the current speaker switch status
    speaker=deviceParams.getSpeaker()
//Set speaker switch
MeariUser.getInstance().setSpeaker(speaker, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SWITCH_SEN_SUCCESS);
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SWITCH_SEN_FAILED);
            }
        });    

 3.volume
/**
     * Speaker volume during intercom (doorbell, battery camera)：0-100
     */
    private int speakVolume;
    //Get current volume
    speakVolume=deviceParams.getSpeakVolume()
//
MeariUser.getInstance().setSpeakVolume(volume, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SET_SPEAK_VOLUME_SUCCESS);
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SET_SPEAK_VOLUME_FAILED);
            }
        });     

 4.Video sound switch
/**
     *
     *     Video sound switch
     *     rec_audio_en
     *         - type: integer
     *         - description: Video sound switch
     */
    private int rec_audio_en;
    //Get Video sound switch
    rec_audio_en=deviceParams.getRec_audio_en()

//Set Video sound switch
MeariUser.getInstance().setRae(rec_audio_en, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SWITCH_REC_SUCCESS);
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                if (mHandler == null || isViewClose()) {
                    return;
                }
                mHandler.sendEmptyMessage(MSG_SWITCH_REC_FAILED);
            }
        });        

```


### 9.5.28 Device video encryption Settings
```
【description】
Device video encryption Settings
【matters need attention】
1. All video encryption passwords are saved locally, not in the cloud, to increase privacy.
2. After the device is added again, the video encryption will be turned off, and the password can be reset, but if you want to view the previous local video and cloud video, you need to set the video password to decrypt. If the current password is not stored locally, let the user enter it.
3. A device uses the password for each password period to view the password required for the corresponding period, which cannot be universal. If it is stored locally, it can traverse to make holes.
4. Video encryption can be turned off only after checking the current password, and can be turned off directly without checking, preventing users from forgetting the password and not knowing that they can reset the status of the device by adding it again.
5.The owner is allowed to set a password.    camerainfo.isMaster()

【Code example】

/**
     * Whether the user access password is set.  no set - 0； set - 1；
     * @return
     */
int isVideoSetPwd= deviceParams.getIsVideoSetPwd()
After obtaining the value, store it locally
MMKVUtil.setData(DEVICE_VIDEO_PASSWORD_IS_SET+snNum,isVideoSetPwd);
//If you set a video password, you need to either get the stored password locally or let the user enter it and store the password to the corresponding
MMKVUtil.setData(DEVICE_VIDEO_PASSWORD+snNum,pwd);中。
The password is retrieved from the local directory for verification. If the hole fails to be perforated, the error code -18 indicates that the password is incorrect. You need to enter the password again.

//Set password (change password) and turn on video encryption
MeariUser.getInstance().setVidePwd(pwd, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });

//Turn off video encryption
MeariUser.getInstance().setVidePwdSwitch(new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
            MMKVUtil.setData(DEVICE_VIDEO_PASSWORD_IS_SET + cameraInfo.getSnNum(), 0);
                                               
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                                                
            }
            });
//Punch holes before changing the password to check whether the entered password is correct  
private MeariDeviceController controller;  
controller = new MeariDeviceController(cameraInfo);
        controller.startConnect(pwdOldTxt,new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
            
                
            }

            @Override
            public void onFailed(String errorMsg) {
                dismissLoading();
                try {
                    BaseJSONObject object = new BaseJSONObject(errorMsg);
                    int errorCode = object.optInt("code");
                    if (errorCode == -18) {
                        //password error
                        
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });                                  

```


### 9.5.29 Device anti-demolition alarm Settings
```

【Code example】
/**
     * 
     * Anti-demolition alarm capability level，0=no support，1=support
     */
    private int fcb;
//
fcb=camerainfo.getFcb();
//Get anti-tamper alarm switch Settings
    deviceParams.getRemoveProtectEnable()
//Set anti-tamper alarm switch Settings
    MeariUser.getInstance().setRemoveProtectAlert(isCheck ? 1 : 0, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
```

### 9.5.30 Device Sound Touch Settings
```
【description】
Device Sound Touch Settings
【matters need attention】
cameraInfo.getVtk() == 4
Support two-way intercom, support two-way intercom only change voice
【Code example】
/**
*soundTouchType   normal 0  uncle  1    clown 2
**/
if (deviceController != null) {
            deviceController.setVoiceTalk(new MeariDeviceListener() {
                @Override
                public void onSuccess(String successMsg) {

                }

                @Override
                public void onFailed(String errorMsg) {

                }
            }, soundTouchType);
        }
```
### 9.5.31 Device Work Mode
```
【description】
Device Work Mode
【function call】
/**
*lwm：0- Not supported, 1- Work mode is supported, 2- Work mode Added continuous recording mode
* lwm=2，In addition to the original power saving mode, performance mode, custom mode, add continuous recording mode option
If not, only the custom mode is supported.
**/
cameraInfo.getLwm()
//Set Device Work Mode
public void setWorkMode(int workmode, ISetDeviceParamsCallback callback)
【Code example】
/**
*workmode   power saving mod 0    performance mode 1    custom mode 2     continuous recording mode 3 
**/
MeariUser.getInstance().setWorkMode(workmode, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
```
### 9.5.32 Humanoid alarm area (picture frame) Settings
```
【description】
Humanoid alarm area (picture frame) Settings
【Code example】
int pdt = cameraInfo.getPdt();
if (cameraInfo.getVer() >= 12 && pdt != -1 && 1 << 1 == (1 << 1 & pdt)) {
            //support
        } else {
            //not support
        }
/**
*status   switchHumanFrame(isChecked ? 1 : 0)
**/
MeariUser.getInstance().setHumanFrame(status, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
               
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
```

### 9.5.33 Humanoid switch setup
```
【description】
Humanoid switch setup
【Code example】
val pdt: Int = cameraInfo.pdt
if (info.ver >= 12) {
            if (pdt != -1 && 1 == 1 and pdt) {
                //Supports the humanoid switch
            } 
            if (pdt != -1 && 1 shl 2 == 1 shl 2 and pdt) {
                //Support night，Not Supports the humanoid switch
            } 
            if (pdt != -1 && 1 shl 3 == 1 shl 3 and pdt) {
                //Support day，Not Supports the humanoid switch
            }
        }


【Humanoid detection enable switch】：0=forbidden， 1=enabled；
deviceParams.humanDetEnable == 1

MeariUser.getInstance().setHumanDetection(status, object : ISetDeviceParamsCallback)


【Daytime humanoid detection enable switch】：0=forbidden， 1=enabled；
deviceParams.humanDetDayEnable == 1

MeariUser.getInstance().setHumanDetectionDay(status, object : ISetDeviceParamsCallback)

【Nighttime humanoid detection enable switch】：0=forbidden， 1=enabled；
deviceParams.humanDetNightEnable == 1

MeariUser.getInstance().setHumanDetectionNight(status, object : ISetDeviceParamsCallback)


【sensitivity】
//0-Not support，3-Supports 3 levels of sensitivity，5-Supports 5 levels of sensitivity，10-Supports 10 levels of sensitivity
pds = info.pds

set sensitivity
MeariUser.getInstance().setHumanDetectionSensitivity(pirLevel, object : ISetDeviceParamsCallback)
```

### 9.5.34 Recording duration setting
```
【description】
Recording duration setting
【Code example】
val esd: Int = info.esd
if (esd > 0) {
            if (1 shl 6 == 1 shl 6 and esd) {
                //10s
            
            }
            if (1 shl 4 == 1 shl 4 and esd) {
                //20s
                
            }
            if (1 == 1 and esd) {
                //30s
                
            }
            if (1 shl 5 == 1 shl 5 and esd) {
                //40s
                
            }
            if (1 shl 1 == 1 shl 1 and esd) {
                //60s
               
            }
            if (1 shl 2 == 1 shl 2 and esd) {
                //120s
                
            }
            if (1 shl 3 == 1 shl 3 and esd) {
                //180s
            }
        }

Get recording duration（unit s）
deviceParams.sdRecordDuration

Set recording duration
MeariUser.getInstance().setPlaybackRecordVideo(deviceParams.sdRecordType, value, object : ISetDeviceParamsCallback )
```
### 9.5.35 Music Playback Settings
```
【description】
Music playback settings (requires SD card to be available)
【Code Example】
·Whether to support music playback settings: 0-not supported, 1-supported
cameraInfo.getMpc()
·Get music list
MeariUser.getInstance().getMusicListNew(new IGetMusicListCallback(){
            @Override
            public void onSuccess(ArrayList<MeariMusic> songInfos) {
                
            }

            @Override
            public void onError(int code, String error) {

            }
        });
·Get current volume
MeariUser.getInstance().getMusicVolume(new IGetMusicVolumeCallback() {
            @Override
            public void onSuccess(int volume) {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });  
·Set current volume
MeariUser.getInstance().setMusicVolume(value, new ISetDeviceParamsCallback() {
                    @Override
                    public void onSuccess() {

                    }

                    @Override
                    public void onFailed(int errorCode, String errorMsg) {

                    }
                });       
·Refresh current song status
MeariUser.getInstance().getPlayMusicStatus(new IRefreshMusicStatusCallback() {
            @Override
            public void onSuccess(String currentMusicId, boolean isPlaying, ArrayList<MeariMusic> musicList) {
                current song -currentMusicId
                is playing-isPlaying
                music list-musicList
                The current song is being downloaded-info.getDownloadPercent() < 100
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
            
            }
        });   
·play song
MeariUser.getInstance().playMusic(curMusicId, new IControlMusicCallback() {
            @Override
            public void onSuccess(String currentMusicID) {
            
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {

            }
        });     
·pause song
MeariUser.getInstance().pauseMusic(curMusicId, new IControlMusicCallback() {
            @Override
            public void onSuccess(String currentMusicID) {
            
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {

            }
        });                    
·Whether to support music playback duration setting 0-not supported, bit0-on(Play continuously) bit1-10min bit2-30min bit3-60min
cameraInfo.getMul()
  -Play time list
            ArrayList<Integer> times = new ArrayList<>();
            if (1 == (1 & mul)) {
                times.add(0);
            }
            if (1 << 1 == (1 << 1 & mul)) {
                times.add(600);
            }
            if (1 << 2 == (1 << 2 & mul)) {
                times.add(1800);
            }
            if (1 << 3 == (1 << 3 & mul)) {
                times.add(3600);
            }
   -Get the current playback duration setting(s)
   deviceParams.getMusicTime()  
   -Set the current playback duration(s)
   MeariUser.getInstance().setMusicTime(time, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
               
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
·Whether to support music playback mode setting 0-not supported bit1: sequential playback bit2-single loop bit3-random playback
cameraInfo.getMpm()
   -Get the current playback mode (0 means sequential playback (default), 1 means single loop, 2 means random playback)
   deviceParams.getMusicCyclical()
   -Set the current playback mode (0 means sequential playback (default), 1 means single loop, 2 means random playback)
   MeariUser.getInstance().setMusicCyclical(mode, new IControlMusicCallback() {
                @Override
                public void onSuccess(String currentMusicID) {
                    
                }

                @Override
                public void onFailed(int errorCode, String errorMsg) {

                }
            });


```


## 9.6 Doorbell parameter setting
### 9.6.1 Device Intercom volume settings
```
【description】
Intercom volume setting of Device

[Function call]
/**
 * Intercom volume setting of Device
 *
 * @param volume intercom volume
 * @param callback Function callback
 * /
public void setSpeakVolume (int volume, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetSpeakVolume (volume, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```

### 9.6.2 Unlock the battery lock
```
【description】
Unlock the battery lock

[Function call]
/**
 * Unlock the battery lock
 *
 * @param callback Function callback
 * /
public void unlockBattery (ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). UnlockBattery (new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```

### 9.6.3 Bind Wireless Chime
```
【description】
Bind Wireless Chime

[Function call]
/**
  * Bind Wireless Chime
  *
  * @param callback Function callback
  * /
public void bindWirelessChime (ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). BindWirelessChime (new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.6.4 Unbind Wireless Chime
```
【description】
Unbind Wireless Chime

[Function call]
/**
  * Unbind Wireless Chime
  *
  * @param callback Function callback
  * /
public void unbindWirelessChime (ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). UnbindWirelessChime (new ISetDeviceParamsCallback () {
     @Override
     public void onSuccess () {
     }

     @Override
     public void onFailed (int errorCode, String errorMsg) {
     }
});
```

### 9.6.5 Whether the wireless chime works setting
```
【description】
Whether the wireless chime works

[Function call]
/**
 * Whether the wireless chime works
 *
 * @param enable wireless chime enable
 * @param callback Function callback
 * /
public void setWirelessChimeEnable (int enable, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetWirelessChimeEnable (enable, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```


### 9.6.6 Wireless chime volume setting
```
【description】
Volume setting of wireless chime

[Function call]
/**
 * Volume setting of wireless chime
 *
 * @param volume volume of wireless chime
 * @param callback Function callback
 * /
public void setWirelessChimeVolume (int volume, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetWirelessChimeVolume (volume, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```

### 9.6.7 Wireless chime ringtone setting
```
【description】
Ringtone setting of wireless chime

[Function call]
/**
 * Ringtone setting of wireless chime
 *
 * @param song wireless chime ringtone
 * @param callback Function callback
 * /
public void setWirelessChimeSong (String song, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetWirelessChimeSong (song, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```

### 9.6.8 Whether the mechanical chime works setting
```
【description】
Whether the mechanical chime works

[Function call]
/**
 * Whether the mechanical chime works
 *
 * @param status 0-off; 1-on
 * @param callback Function callback
 * /
public void setMechanicalChimeEnable (int status, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetMechanicalChimeEnable (enable, new ISetDeviceParamsCallback () {
    @Override
    public void onSuccess () {
    }

    @Override
    public void onFailed (int errorCode, String errorMsg) {
    }
});
```
## 9.7 Flight camera parameter setting
### 9.7.1 Light switch setting
```
【description】
Light switch

【Function call】
/**
 * Light switch
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightLightStatus(int status, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightLightStatus(enable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.2 Alarm switch setting
```
【description】
Alarm switch

【Function call】
/**
 * Alarm switch
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightSirenEnable(int status, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightSirenEnable(status, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.3 Camera trigger light swtich setting
```
【description】
Camera trigger light swtich setting

【Function call】
/**
 * Camera trigger light swtich setting
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightLinkLightingEnable(int status, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightLinkLightingEnable(status, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.4 Camera trigger lighting duration setting
```
【description】
Camera trigger lighting duration setting

【Function call】
/**
 * Camera trigger lighting duration setting
 *
 * @param duration duration
 * @param callback Function callback
 */
public void setFlightPirDuration(int duration, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightPirDuration(duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.5 Lighting schedule setting
```
【description】
Lighting schedule

【Function call】
/**
 * Lighting schedule
 *
 * @param enable lighting schedule switch
 * @param from   lighting schedule start time
 * @param to     lighting schedule end time
 * @param callback Function callback
 */
public void setFlightSchedule(int enable, String from, String to, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightSchedule(enable, from, to, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.6 Lighting brightness setting
```
【description】
Lighting brightness

【Function call】
/**
 * Lighting brightness
 *
 * @param brightness brightness
 * @param callback Function callback
 */
public void setFlightBrightness(int brightness, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightBrightness(brightness, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.7 Manual lighting duration setting
```
【description】
Manual lighting duration

【Function call】
/**
 * Manual lighting duration
 *
 * @param duration duration
 * @param callback Function callback
 */
public void setFlightManualLightingDuration(int duration, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightManualLightingDuration(duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.8 Camera trigger alarm setting
```
【description】
Camera trigger alarm setting

【Function call】
/**
 * Camera trigger alarm setting
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightLinkSirenEnable(int status, ISetDeviceParamsCallback callback);

【Code example】
MeariUser.getInstance().setFlightLinkSirenEnable(status, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
## 9.8 AOV Camera Setting
### 9.8.1 Preview Change Real Time or Save Data
```
【description】
Preview Change Real Time or Save Data

【Function call】
/**
 * Whether Support Real Time or Save Data
 */
MeariDeviceUtil.isSupportFps(cameraInfo);

/**
*Change Real Time or Save Data
*isLowFps   Real Time：0   Save Data：1
**/
if (MeariDeviceUtil.isSupportFps(cameraInfo)) {
     deviceController.setExtraPreviewParams(isLowFps);
}

【Code example】
//Set the current stream saving mode or real-time mode

if (MeariDeviceUtil.isSupportFps(cameraInfo)) {
     deviceController.setExtraPreviewParams(isLowFps);
}
deviceController.changeVideoResolution(videoSurfaceView, videoId, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {

    }

    @Override
    public void onFailed(String errorMsg) {

    }
}, new MeariDeviceVideoStopListener() {
    @Override
    public void onVideoClosed(int code) {
        
    }
});
```
### 9.8.2 WorkMode
```
【description】
WorkMode
【Code example】
/**
*Determine which mode are supported
**/
        int lwm = -1;
        //SMB-aov
        int alm = cameraInfo.getAlm();
        if (alm > 0) {
            lwm = alm;
            isSMB = true;
        }
        //CIV-aov  wifi aov
        int lwm2 = cameraInfo.getLwm2();
        if (lwm2 > 0) {
            lwm = lwm2;
            isSMB = false;
        }
        if (lwm > 0) {
            if (1 == (1 & lwm)) {
                //Power Saving Mode
            }
            if (1 << 1 == (1 << 1 & lwm)) {
                //Performance Mode
            }
            if (1 << 2 == (1 << 2 & lwm)) {
                //Custom Mode
            }
            if (1 << 3 == (1 << 3 & lwm)) {
                //Always-on Mode
            }
        }

        /*
        **Which mode is it currently in
        *0-Power Saving Mode, 1-Performance Mode, 2-Custom Mode  3-Always-on Mode
        */
        mode = deviceParams.getAovWorkMode();
        if(isSMB) {
            mode = deviceParams.getAovWorkMode();
        }else {
            mode = deviceParams.getWorkMode();
        }


        //Set WorkMode
        if (isSMB) {
            MeariUser.getInstance().setAOVWorkMode(mode, new ISetDeviceParamsCallback() {
                @Override
                public void onSuccess() {
                    
                }

                @Override
                public void onFailed(int errorCode, String errorMsg) {
                    
                }
            });
        } else {
            MeariUser.getInstance().setWorkMode(mode, new ISetDeviceParamsCallback() {
                @Override
                public void onSuccess() {
                    
                }

                @Override
                public void onFailed(int errorCode, String errorMsg) {
                    
                }
            });
        }


```
### 9.8.3 Custom Mode Setting
```
【description】
Custom Mode Setting
【Code example】
1.Event video time lapse
        int erd = cameraInfo.getErd();
        if (erd > 0) {
    
            if (1 == (1 & erd)) {
                //3s（value=0）
                 
            }
            if (1 << 1 == (1 << 1 & erd)) {
                //6s（value=1）
               
            }
            
        }

    //Get Current Value
     value=deviceParams.getAovRecordDelay();


        //Set Value
     MeariUser.getInstance().setAOVRecordDelay(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });


        2.Fill Light Distance
        //- description: Whether Support Fill Light Distance，0-Not Support, bit0-Auto bit1-10m bit2-20m bit3-30m
        int sld = cameraInfo.getSld();
        if (sld > 0) {
           
            if (1 == (1 & sld)) {
                //Auto（value=0）
            
            }
            if (1 << 1 == (1 << 1 & sld)) {
                //10m（value=1）
                
            }
            if (1 << 2 == (1 << 2 & sld)) {
                //20m（value=2）
            
            }
            if (1 << 3 == (1 << 3 & sld)) {
                //30m（value=3）
            }

        }

        //Get Current Value
        value=deviceParams.getAovComplementaryDistance()
        
        //Set Value
        MeariUser.getInstance().setAovComplementaryDistance(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });



        3.Night Scene Mode
        //0-Not Support, bit0-Normal Mode bit1-Enhanced Mode
        int nms = cameraInfo.getNms();
        if (nms > 0) {
            
            if (1 == (1 & nms)) {
                //Normal Mode（value=0）
            }
            if (1 << 1 == (1 << 1 & nms)) {
                //Enhanced Mode（value=1）
            }
        }

        //Get Current Value
        value=deviceParams.getAovNightMode()
        //Set Value
        MeariUser.getInstance().setAovNightMode(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
               
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });

        4.Full-Time Video Frame Rate
        if (cameraInfo.getSfi() > 0) {
            //0-Not Support, >0-Support;
            //bit0-1，bit1-2，bit2-3，bit3-5，bit4-10，bit5-15，bit6-20，bit7-30，bit8-60,bit9-Close
            int sfi = cameraInfo.getSfi();
            if (1 << 9 == (1 << 9 & sfi)) {
                fpsList.add(0);
            }
            if (1 == (1 & sfi)) {
                fpsList.add(1);
            }
            if (1 << 1 == (1 << 1 & sfi)) {
                fpsList.add(2);
            }
            if (1 << 2 == (1 << 2 & sfi)) {
                fpsList.add(3);
            }
            if (1 << 3 == (1 << 3 & sfi)) {
                fpsList.add(5);
            }
            if (1 << 4 == (1 << 4 & sfi)) {
                fpsList.add(10);
            }
            if (1 << 5 == (1 << 5 & sfi)) {
                fpsList.add(15);
            }
            if (1 << 6 == (1 << 6 & sfi)) {
                fpsList.add(20);
            }
            if (1 << 7 == (1 << 7 & sfi)) {
                fpsList.add(30);
            }
            if (1 << 8 == (1 << 8 & sfi)) {
                fpsList.add(60);
            }
        }

        //Get Current Value
        value=deviceParams.getFullTimeFrameRate()

        //Set Value
        MeariUser.getInstance().setAOVFrameRate(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
               
            }
        });

```
# 10 Family

## 10.1 Family Operation

### 10.1.1 Get family list
```
【description】
Get family list 

【Function call】
/**
 * Get family list
 *
 * @param callback callback
 */
public void getFamilyList(IFamilyListCallback callback)

【Code example】
MeariUser.getInstance().getFamilyList(new IFamilyListCallback() {
    @Override
    public void onSuccess(List<MeariFamily> familyList) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.1.2 Create Family
```
【description】
Create a family with up to 10 rooms 

【Function call】
/**
 * Create a family with up to 10 rooms 
 *
 * @param callback callback
 */
public void createFamily(String familyName, String familyLocation, List<MeariRoom> roomList, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().createFamily(familyName, familyLocation, roomList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.1.3 Update Family Information
```
【description】
Update family information 

【Function call】
/**
 * Update family information 
 *
 * @param callback callback
 */
public void updateFamily(String familyId, String familyName, String familyLocation, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().updateFamily(familyId, familyName, familyLocation, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.1.4 Delete Family
```
【description】
delete family from account

【Function call】
/**
 * delete family from account
 *
 * @param callback callback
 */
public void deleteFamily(String familyId, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().deleteFamily(familyId, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

## 10.2 Family Share

### 10.2.1 Search for member accounts to be added
```
【description】
Search for member accounts to be added

【Function call】
/**
 * Search for member accounts to be added
 *
 * @param account account
 * @param familyId  familyId
 */
public void searchContactForAddFamilyMember(String account, String familyId, IBaseModelCallback<FamilyMemberToAdd> callback)

【Code example】
MeariUser.getInstance().searchContactForAddFamilyMember(account, familyId, new IBaseModelCallback<FamilyMemberToAdd>() {
    @Override
    public void onSuccess(FamilyMemberToAdd familyMemberToAdd) {
    }

    @Override
    public void onFailed(int code, String errorMsg) {
    }
});
```

### 10.2.2 Search for the family account to be joined
```
【description】
Search for a family account to join 

【Function call】
/**
 * Search for a family account to join 
 *
 * @param account account
 */
public void searchContactForJoinFamily(String account, IBaseModelCallback<MeariFamilyToJoin> callback)

【Code example】
MeariUser.getInstance().searchContactForJoinFamily(account, new IBaseModelCallback<MeariFamilyToJoin>() {
    @Override
    public void onSuccess(MeariFamilyToJoin meariFamilyToJoin) {
    }

    @Override
    public void onFailed(int code, String errorMsg) {
    }
});
```

### 10.2.3 Add member to the family
```
【description】
Add member to the family

【Function call】
/**
 * Add member to the family
 *
 * @param familyId    family id
 * @param memberId    member user id
 * @param permissions List of permissions for device control
 * @param callback    callback
 */
public void addMemberToFamily(String familyId, String memberId, List<DevicePermission> permissions, IResultCallback callback)

【Code example】
MeariUser.getInstance().addMemberToFamily(familyId, memberId, permissions, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.4 Join a family
```
【description】
Join a family

【Function call】
/**
 * Join a family
 *
 * @param familyIdList family id list to join
 * @param callback     callback
 */
public void joinFamily(List<String> familyIdList, IResultCallback callback) {

【Code example】
MeariUser.getInstance().joinFamily(familyIdList, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.5 Get family shared messages
```
【description】
Get family shared messages

【Function call】
/**
 * Get family shared Messages
 */
public void getFamilyShareMessages(IBaseModelCallback<List<FamilyShareMsg>> callback)

【Code example】
MeariUser.getInstance().getFamilyShareMessages(new IBaseModelCallback<List<FamilyShareMsg>>() {
    @Override
    public void onSuccess(List<FamilyShareMsg> familyShareMsgs) {
    }

    @Override
    public void onFailed(int code, String errorMsg) {
    }
});
```

### 10.2.6 Handle family shared messages
```
【description】
Handle family shared messages

【Function call】
/**
 * @param dealFlag 0-reject，1-agree
 */
public void dealFamilyShareMessage(List<String> msgIDList, int dealFlag, IResultCallback callback)

【Code example】
MeariUser.getInstance().dealFamilyShareMessage(msgIDList, dealFlag, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.7 Get family member list
```
【description】
Get family member list

【Function call】
/**
 * Get family member list
 *
 * @param callback callback
 */
public void getFamilyMemberList(String familyId, IFamilyMemberListCallback callback)

【Code example】
MeariUser.getInstance().getFamilyMemberList(familyId, new IFamilyMemberListCallback() {
    @Override
    public void onSuccess(List<FamilyMember> familyMemberList) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.8 Modify device permissions of the family member
```
【description】
Modify device permissions of the family member

【Function call】
/**
 * Modify device permissions of the family member
 *
 * @param callback callback
 */
public void modifyMemberDevicePermission(String familyId, String memberID, List<DevicePermission> permissions, IResultCallback callback)

【Code example】
MeariUser.getInstance().modifyMemberDevicePermission(familyId, memberID, permissions, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.9 Remove a member from the family
```
【description】
Remove a member from the family 

【Function call】
/**
 * Remove a member from the family 
 *
 * @param callback callback
 */
public void removeMemberFromFamily(String familyId, String memberID, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().removeMemberFromFamily(familyId, memberID, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.10 Revoke member invitation
```
【description】
Revoke member invitation 

【Function call】
/**
 * Revoke member invitation 
 */
public void revokeMemberInvitation(String familyId, String msgId, IResultCallback callback)

【Code example】
MeariUser.getInstance().revokeMemberInvitation(familyId, msgId, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.11 Leave family
```
【description】
Leave family

【Function call】
/**
 * Leave family
 *
 * @param callback callback
 */
public void leaveFamily(String familyId, IResultCallback callback)

【Code example】
MeariUser.getInstance().leaveFamily(familyId, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```
## 10.3 Room operation

### 10.3.1 Add a room
```
【description】
Add room to the family

【Function call】
/**
 * Add room to the family
 *
 * @param callback callback
 */
public void addRoom(String familyId, String roomName, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().addRoom(familyId, roomName, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.2 Modify room information
```
【description】
Modify room information

【Function call】
/**
 * Modify room information
 */
public void updateRoom(String familyId, String roomId, String roomName, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().updateRoom(familyId, roomId, roomName, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.3 Delete room
```
【description】
Delete room from the family

【Function call】
/**
 * Delete room from the family
 *
 * @param callback callback
 */
public void deleteRoom(String familyId, List<String> roomIdList, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().deleteRoom(familyId, roomIdList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.4 Add device to the room
```
【description】
Add device to the room

【Function call】
/**
 * Add device to the room
 *
 * @param callback callback
 */
public void addDeviceToRoom(String familyId, String roomId, List<CameraInfo> deviceList, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().addDeviceToRoom(familyId, roomId, deviceList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.5 Remove device from the room
```
【description】
Remove device from the room

【Function call】
/**
 * Remove device from the room
 *
 * @param callback callback
 */
public void removeDeviceFromRoom(String familyId, String roomId, List<CameraInfo> deviceList, IStringResultCallback callback)

【Code example】
MeariUser.getInstance().removeDeviceFromRoom(familyId, roomId, deviceList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.6 Batch remove devices
```
【description】
Batch remove devices

【Function call】
/**
 * Batch delete devices
 */
public void deleteDeviceBatch(List<String> deviceIDList, IResultCallback callback)

【Code example】
MeariUser.getInstance().deleteDeviceBatch(deviceIDList, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

## 10.4 Family Related Classes

### 10.4.1 MeariFamily
```
private String familyId; family ID
// The default family name is empty, you can determine the name according to "userName", or customize the name
String familyName; family name
boolean owner; Is the owner of the family 
boolean isDefault; Is it the default family 
String userName; user name
String location; family address 
List<MeariRoom> roomList; room list in family
List<CameraInfo> familyDeviceList; all camera in family
```
### 10.4.2 MeariRoom
```
private String roomId; room ID
// The default room name of the default family is empty, you can determine the name yourself according to "roomTarget"
private String roomName; room name
private int roomTarget; room room target
private List<CameraInfo> roomDeviceList; device list in room
```

### 10.4.3 DevicePermission
```
// familyMemberToAdd.getFamilyDevices().get(i).getDeviceID()
String deviceID;
// 0-view only; 1-allow view and control 
int permission;
```

### 10.4.4 FamilyShareMsg
```
long date; time
String msgID; Message ID
String receiverName; message handler name
String inviterName; message originator name
long inviter; message originator ID
String familyName; family name
int msgType; Message Type: 1-Add Member; 2-Join Family
int dealFlag; Message processing flag: 0-reject; 1-agree; 2-processing

if (MeariUser.getInstance().getUserInfo().getUserID() == msg.inviter) {
    // message originator
    if(msgType == 1) {
        if(dealFlag == 2) {
            You are inviting receiverName to join your family： familyName
        } else if(dealFlag == 1){
            receiverName has joined your family： familyName
        } else {
            receiverName refused to join your family： familyName
        }
    } else {
        if(dealFlag == 2) {
            You are applying to join receiverName's family： familyName
        } else if(dealFlag == 1){
            receiverName agrees you to join the family： familyName
        } else {
            receiverName denied you to join the family： familyName
        }
    }
} else {
    // message handler
    if(msgType == 1) {
        if(dealFlag == 2) {
            inviterName invited you to join his family： familyName
            // click processing ：MeariUser.getInstance().dealFamilyShareMessage()
        } else if(dealFlag == 1){
            You have joined inviterName's family： familyName
        } else {
            You declined to join inviterName's family： familyName
        }
        
    } else {
        if(dealFlag == 2) {
            inviterName apply to join your family： familyName
            //click processing ：MeariUser.getInstance().dealFamilyShareMessage()
        } else if(dealFlag == 1){
            You agree to inviterName to join your family： familyName
        } else {
            You declined inviterName to join your family：familyName
        }
    }
}
```

### 10.4.5 FamilyMember
```
String userId; Member ID
String userAccount; Member Account
String nickName; Member nickName
String imageUrl; Member Avatar 
int isMaster; Is it the master 
int joinStatus; Member joining status: 1-joined; 2-joining 
String msgId; Message ID
```


# 11 MQTT and push
```
The meari SDK supports internal MQTT push messages, as well as FCM and other vendors (supported in future)
```

## 11.1 MQTT messages
```
Used to receive messages such as device add success message, doorbell call message, voice doorbell call message, remote login, etc.
```

### 11.1.1 Connect to MQTT Service

No need to call in 5.3.0, it will be called in sdk.

### 11.1.2 Exit MQTT Service

// Called after the user logout successfully
MeariUser.getInstance (). DisConnectMqttService ();

### 11.1.3 MQTT message processing

```
When the SDK is initialized, the implementation of the MqttMessageCallback interface should be passed into it, like MyMessageHandler in the demo.
Handle MQTT in the implementation of the MqttMessageCallback interface (see Demo MyMessageHandler)

/**
 * Other news
 * @param messageId message ID
 * @param message message content
 * /
void otherMessage (int messageId, String message);

/**
 * Offsite login
 * /
void loginOnOtherDevices ();

/**
 * The owner cancels or deletes the shared device
 * @param deviceId device ID
 * @param deviceName device name
 * /
void onCancelSharingDevice (String deviceId, String deviceName);

/**
 * Device unbound (e-commerce unbundling)
 * /
void deviceUnbundled ();

/**
 * Doorbell call
 * @param bellJson doorbell information
 * @param isUpdateScreenshot is the message to update the screenshot
 * /
void onDoorbellCall (String bellJson, boolean isUpdateScreenshot);

/**
 * Device added successfully
 * /
void addDeviceSuccess (String message);

/**
 * Failed to add device
 * /
void addDeviceFailed (String message);

/**
 * Failed to add the device, the device failed to be unbound and the add failed
 * /
void addDeviceFailedUnbundled (String message);

/**
 * Received device shared by someone
 * /
void ReceivedDevice (String message);

/**
 * Request to receive a device shared by someone
 * @param userName user name
 * @param deviceName device name
 * @param msgID message ID
 * /
void requestReceivingDevice (String userName, String deviceName, String msgID);

/**
 * Request to share device to someone
 * @param userName user name
 * @param deviceName device name
 * @param msgID message ID
 * /
void requestShareDevice (String userName, String deviceName, String msgID);

/**
 * Family related mqtt message
 * @param familyMqttMsg Family mqtt message
 */
void onFamilyMessage(FamilyMqttMsg familyMqttMsg);
// handle family messages
// The default family name is empty, update the default family name
if (familyMqttMsg.getItemList().size() > 0) {
    for (MqttMsg.MsgItem msgItem : familyMqttMsg.getItemList()) {
        if (TextUtils.isEmpty(msgItem.name)) {
            String name;
            if (familyMqttMsg.getMsgId() == MqttMsgType.INVITE_JOIN_HOME) {
                name = familyMqttMsg.getUserName();
            } else {
                name = MeariUser.getInstance().getUserInfo().getNickName();
            }
            msgItem.name = String.format(Locale.CHINA, "%s's home", name);
        }
    }
}
if (familyMqttMsg.getMsgId() == MqttMsgType.FAMILY_INFO_CHANGED) {
    // Family information changes, refresh the family list 
} else if (familyMqttMsg.getMsgId() == MqttMsgType.FAMILY_MEMBER_INFO_CHANGED) {
    // Member information changes, refresh member information 
} else if (familyMqttMsg.getMsgId() == MqttMsgType.INVITE_JOIN_HOME) {
    // Someone invites you to join his family, pops up and handles messages 
    // MeariUser.getInstance().dealFamilyShareMessage()
} else if (familyMqttMsg.getMsgId() == MqttMsgType.INVITE_JOIN_HOME_SUCCESS) {
    // You join the family successfully, refresh the family list
} else if (familyMqttMsg.getMsgId() == MqttMsgType.APPLY_ENTER_HOME) {
    // Others apply to join your family, pop up the window and process the message 
    // MeariUser.getInstance().dealFamilyShareMessage()
} else if (familyMqttMsg.getMsgId() == MqttMsgType.APPLY_ENTER_HOME_SUCCESS) {
    // Apply to join the family successfully, refresh the family list
} else if (familyMqttMsg.getMsgId() == MqttMsgType.REMOVE_FROM_FAMILY) {
    // You are removed from the family, refresh the family list
}
```

## 11.2 MQTT Related Classes

### 11.2.1 MqttMsg
> MQTT message base class 
```
int msgId; message ID
String userCountryCode; user Country Code
int userIotType; user Iot Type
long t; time
```

### 11.2.2 FamilyMqttMsg extends MqttMsg
> family MQTT message
```
String familyId; family ID
String familyName; family Name
String userName; user Name
final List<MsgItem> itemList; list in message 
```

### 11.2.3 MsgItem
> list item in message
```
String id;  Item ID
String name; Item name
boolean isCheck; Is it checked 
```

## 11.3 Integrated FCM Push
First, You can follow these guides: [Add Firebase to your Android project](https://firebase.google.com/docs/android/setup) and [Set up a Firebase Cloud Messaging client app on Android](https://firebase.google.com/docs/cloud-messaging/android/client), then go to firebase setting page, geneating the admin sdk file，provide the file to meari,
call MeariUser.getInstance().postPushToken(1, token, callback) to upload your fcm token to meari server.

## 11.4 Integration with other pushes
```
Contact the server to configure other pushes
```

# 12 Cloud storage service
## 12.1 Cloud storage service status
```
【description】
Get cloud storage information

【Function call】
/**
 * Get cloud storage information
 *
 * @param deviceID deviceID
 * @param callback callback
 */
public void getCloudServiceInfo(String deviceID, ICloudServiceCallback callback)

【Code example】
MeariUser.getInstance().getCloudServiceInfo(mCameraInfo.getDeviceID(), new ICloudServiceCallback() {
    @Override
    public void onSuccess(CloudServiceInfo serviceInfo) {
        
    }

    @Override
    public void onError(int code, String error) {

    }
});


// 1. not activated,it can be tried ; 2. not activated,it cannot be tried; 
// 3. It has been activated; 4. It has expired.
int cloudStatus =  mCameraInfo.getCloudStatus();

CloudServiceInfo：

// Cloud service event recording price information
private CloudPriceInfo eventCloudPriceInfo;
// Cloud service all-day video price information
private CloudPriceInfo continueCloudPriceInfo;
// Video save time
private int storageTime;
// price symbol：￥ $
private String currencySymbol;
// The time the cloud service can be tried. Default is 7
private int tryTime = 7;
// The unit of cloud service trial time. The default is days.
private String tryUnit = "D";
// Deadline for cloud services
private long dueDate=0;


CloudPriceInfo：

// Three days of package month
private BigDecimal threeM;
// Three days of package quarter
private BigDecimal threeS;
// Three days of package year
private BigDecimal threeY;
// Video 7-day cycle package month
private BigDecimal sevenM;
// Video 7-day cycle package quarter
private BigDecimal sevenS;
// Video 7-day cycle package year
private BigDecimal sevenY;
// Video 30-day cycle package month
private BigDecimal thirtyM;
// Video 30-day cycle package quarter
private BigDecimal thirtyS;
// Video 30-day cycle package year
private BigDecimal thirtyY;
```
## 12.2 Cloud Storage Trial
```
【description】
Cloud Storage Trial

【Function call】
/**
 * Cloud Storage Trial
 *
 * @param deviceID deviceID
 * @param callback callback
 */
public void freeTrialCloudService(String deviceID, IResultCallback callback)

【Code example】
MeariUser.getInstance().freeTrialCloudService(mCameraInfo.getDeviceID(), new IResultCallback() {
    @Override
    public void onSuccess() {
        
    }

    @Override
    public void onError(int code, String error) {
        
    }
});
```
## 12.3 Cloud storage activation code usage
```
【description】
Cloud storage activation code usage

【Function call】
/**
 * Cloud storage activation code usage
 *
 * @param actCode activation code
 * @param deviceID deviceID
 * @param callback callback
 */
public void requestActive(String actCode, String deviceID, final IResultCallback callback, Object tag)

【Code example】
MeariUser.getInstance().requestActive(actCode, mCameraInfo.getDeviceID(), new IResultCallback() {
    @Override
    public void onSuccess() {

    }

    @Override
    public void onError(int code, String error) {

    }
}, this);
```
## 12.4 Cloud storage purchases
```
See Demo for details
```

# 13 NVR

## 13.1 Add NVR
```
For details, see: Add device to wired network
```
## 13.2 Add camera to NVR channel

### 13.2.1 Add online camera
```
[Description]
If the camera is already online, make the camera and NVR in the same LAN, and enable the camera to be connected by NVR. Within 5 minutes, NVR searches and adds the camera to the channel

[Function call]
/**
* Get the status of being allowed to be discovered by NVR
*/
public void getNvrConnectableStatus(INvrConnectableCallback callback)
/**
* Set whether to allow connection by NVR: 0-no; 1-yes
* Automatically close after 5 minutes of opening
*/
public void setNvrConnectable(int enable, IStringResultCallback callback)
/**
* Get the remaining time allowed to be connected by NVR, in seconds
*/
public void getNvrConnectableTimeLeft(IIntegerPropertyCallback callback)

/**
* nvr starts searching for devices
*/
public void nvrStartSearchDevice(IStringResultCallback callback)
/**
* nvr gets search results
*/
public void nvrGetSearchResult(INVRSearchCallback callback)
/**
* nvr adds meari devices
* ip-searched IP address of the device
*/
public void nvrAddDevice(String ip, INVRAddCallback callback)
/**
* nvr adds onvif devices
* ip-searched IP address of the device; user-onvif user name; pwd-onvif password
*/
public void nvrAddOnvifDevice(String ip, String user, String pwd, INVRAddCallback callback)

[Code Example]

// Does the camera support being connected by Nvr?
if (cameraInfo.getCpn() > 0) {
}

MeariUser.getInstance().getNvrConnectableStatus(new INvrConnectableCallback() {
    @Override
    public void onSuccess(NvrConnectableInfo nvrConnectableInfo) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});

NvrConnectableInfo：
// Has the camera been added to the NVR?
private boolean isAdded;
// Can the camera be connected to the NVR?
private int connectable;
// ID of the NVR to which the camera is connected?
private String NvrId;

MeariUser.getInstance().setNvrConnectable(1, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {

    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});

MeariUser.getInstance().getNvrConnectableTimeLeft(new IIntegerPropertyCallback() {
    @Override
    public void onSuccess(int value) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});

MeariUser.getInstance().nvrStartSearchDevice(new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});

MeariUser.getInstance().nvrGetSearchResult(new INVRSearchCallback() {
    @Override
    public void onSuccess(boolean finish, List<NvrAddInfo> nvrAddInfoList) {
    // finish: false-searching, continue to get results; true-searching is over, stop getting results
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});

NvrAddInfo:
// Unique identifier
private String id;
// 0-Meari camera; 1-onvif camera
private int type;
// Meari camera sn
private String sn;
// Camera IP address
private String ip;
// 0-Not added; 1-Added; 2-Add failed
private int addStatus;

MeariUser.getInstance().nvrAddDevice(nvrAddInfo.getIp(), new INVRAddCallback() {
    @Override
    public void onSuccess(NvrAddInfo nvrAddInfo) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});

MeariUser.getInstance().nvrAddOnvifDevice(nvrAddInfo.getIp(), "user", "pwd", new INVRAddCallback() {
    @Override
    public void onSuccess(NvrAddInfo nvrAddInfo) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```
### 13.2.2 Connect to NVR to add camera
```
[Description]
If the camera is not online, get the token of NVR to generate QR code. After scanning the code, the camera will connect to NVR and add it to NVR channel

[Function call]
/**
* Create Token QR code
*/
public void createNvrTokenQRCode(String token, ICreateQRCodeCallback callback)

[Code example]

MeariUser.getInstance().getDeviceParams(new IGetDeviceParamsCallback() {
    @Override
    public void onSuccess(DeviceParams deviceParams) {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});

MeariUser.getInstance().createNvrTokenQRCode(deviceParams.nvrNeutralParams.getQrCodeToken(), new ICreateQRCodeCallback() {
    @Override
    public void onSuccess(Bitmap bitmap) {
    }
});
```

### 13.2.3 Connect to the router and add the camera
```
[Description]
If the camera is not online, obtain the key and wifi name of the NVR, and the password to generate a QR code. After the camera scans the code, it will connect to the router, and the NVR will automatically add the device to the channel, search for the addition results, and display them.

【Function call】
/**
* Create key QR code
* ssid-WiFi name; password-WiFi password; key-nvr Key
*/
public void createNvrKeyQRCode(String ssid, String password, String key, ICreateQRCodeCallback callback)
/**
* Get NVR add result
*/
MeariUser.getInstance().nvrGetAddResult(new INVRGetAddResultCallback()

【Code example】

MeariUser.getInstance().createNvrKeyQRCode("wifi_name", "pwd", deviceParams.nvrNeutralParams.getQrCodeKey(), new ICreateQRCodeCallback() {
    @Override
    public void onSuccess(Bitmap bitmap) {
    }
});

// Set the timeout (130s) and loop to get the add result. If the add fails due to the timeout, stop searching
MeariUser.getInstance().nvrGetAddResult(new INVRGetAddResultCallback() {
@Override
public void onSuccess(List<NvrAddInfo> nvrAddInfoList) {
        List<NvrAddInfo> list = filterOnvif(nvrAddInfoList);
        if (list.size() > 0) {
        // Add successfully, display the result
        } else {
            if (!isFinishSearch) {
                nvrGetAddResult();
            }
        }
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
        if (!isFinishSearch) {
            nvrGetAddResult();
        }
    }
});

private List<NvrAddInfo> filterOnvif(List<NvrAddInfo> nvrAddInfoList) {
    List<NvrAddInfo> list = new ArrayList<>();
    if (nvrAddInfoList != null && nvrAddInfoList.size() > 0) {
        for (NvrAddInfo nvrAddInfo : nvrAddInfoList) {
            if (nvrAddInfo.getType() == 0) {
                list.add(nvrAddInfo);
            }
        }
    }
    return list;
}
``` 
## 13.4 NVR settings
### 13.4.1 NVR get parameters
```
[Description]
Get NVR channel, hard disk and other parameter information

[Function call]
/**
* Get the params of the device
* Get the device parameters
*
* @param callback Function callback
*/
public void getDeviceParams(IGetDeviceParamsCallback callback)

[Code example]
// Only need to set once to operate the same device
MeariUser.getInstance().setCameraInfo(cameraInfo);
// Get device parameters
MeariUser.getInstance().getDeviceParams(new IGetDeviceParamsCallback() {
    @Override
    public void onSuccess(DeviceParams deviceParams) {
        NvrNeutralParams nvrNeutralParams = deviceParams.nvrNeutralParams;
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});

NvrNeutralParams：
// nvr maximum number of channels
private int maxChannelNumber;
// nvr QR code Token
private String qrCodeToken;
// nvr QR code key
private String qrCodeKey;
// Whether to enable all-day recording
private int allDayRecordEnable;
// Channel information
private List<NvrNeutralChannel> channels = new ArrayList<>();
// Hard disk information
private List<NvrNeutralDisk> disks = new ArrayList<>();
// Channel capability set
private List<String> caps = new ArrayList<>();

NvrNeutralChannel：
private int id;
private String name;
// state: 0-unbound; 1-online; 2-offline; 3-sleep;
private int state;
// 0-private protocol; 1-onvif protocol
private int type;

NvrNeutralDisk:
private int name;
// 0: no SD card; 1: normal use; 2: card read and write abnormality; 3: formatting; 4: file system not supported; 5: card is being identified; 6: not formatted; 7: other errors;
private int state;
// total capacity
private String total;
// remaining capacity
private String free;
// used capacity
private String used;

```
### 13.4.2 NVR disk management
```
[Description]
NVR format hard disk

[Function call]
/**
 * Start formatting hard disk
 * @param seq hard disk serial number, starting from 1
 */
public void startSDCardFormat(int seq, ISDCardFormatCallback callback) 
/** 
 * Get the progress of formatting hard disk 
 */ public void getSDCardFormatPercent(ISDCardFormatPercentCallback callback) 
【Code example】 
MeariUser.getInstance().startSDCardFormat(1, new ISDCardFormatCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});

MeariUser.getInstance().getSDCardFormatPercent(new ISDCardFormatPercentCallback() {
    @Override
    public void onSuccess(int percent) {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

## 13.5 NVR channel camera
```
The use of NVR channel camera is basically the same as that of ordinary camera. You can preview, replay and set it by using CameraInfo of NVR channel camera information. For the specific process, refer to the preview, playback and setting of ordinary camera.
NVR channel camera does not support cloud playback.
The differences will be explained in detail below.
```

### 13.5.1 NVR channel camera information
```
// Get NVR channel camera information
if (DeviceType.NVR_NEUTRAL == cameraInfo.getDevTypeID()) {
List<CameraInfo> channelCameraInfoList = cameraInfo.getNvrChannelList();
}
```

### 13.5.2 NVR channel camera parameters
```
// Only need to set once to operate the same NVR channel
MeariUser.getInstance().setCameraInfo(channelCameraInfo);
// Get device parameters
MeariUser.getInstance().getDeviceParams(new IGetDeviceParamsCallback() {
    @Override
    public void onSuccess(DeviceParams deviceParams) {
        DeviceParams channelDeviceParams = deviceParams;
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 13.5.3 NVR channel camera firmware upgrade
```
// The sn and tp in checkNewFirmwareForDev are obtained in different ways
if (cameraInfo != null && DeviceType.NVR_NEUTRAL == cameraInfo.getDevTypeID() && cameraInfo.getNvrChannelId() > 0) {
    sn = channelDeviceParams.getSnNum();
    tp = channelDeviceParams.getTp();
}
```

# 16 AI service

## 16.1 AI service introduction
```
AI related capability set
- int ai; Whether to support ai: 0-not supported; 1-supported
- int cai; Whether to support cloud ai: ""/"[]"-not supported; non-empty array-supported
- int dai; Whether to support local AI: ""/"[]"-not supported; non-empty array-supported

The format of cai and dai is JSON array string, such as '[1,2,3,4,5]',
Field definition description: 1-person, 2-car, 3-pet, 4-package, 5-crying, 6-barking, 7-wild animal, 8-bird, 9-gunshot, 10-glass shattering, 11-baby blocking, 12-baby sleeping on their stomach.

AI support description for unconnected devices:
1.ai=0, does not support AI function
2.ai=1,dai=support,cai=support, supports local AI and cloud AI: displays the local AI switch and cloud AI purchase entrance when not purchased, and displays the cloud AI switch after purchase
3.ai=1,dai=support,cai=unsupport, only supports local AI: displays the local AI switch, does not display the purchase entrance of cloud AI
4.ai=1,dai=unsupport,cai=support, only supports cloud AI: displays the cloud AI switch, but cannot be operated, displays the cloud AI purchase entrance, and can be operated after purchase.
5. ai=1, dai=not supported, cai=not supported, early AI version (only supports people, cars, pets, packages): cloud AI switch is displayed, but it cannot be operated. Cloud AI purchase entrance is displayed and can be operated after purchase.
```

## 16.2 AI service status
```
[Description]
Get the activation status and switch status of AI service

[Code example]
MeariUser.getInstance().getAiProjects(cameraInfo?.deviceID, object :IStringResultCallback{
    override fun onError(errorCode: Int, errorMsg: String?) {
    }

    override fun onSuccess(result: String?) {
        val jsonResult = BaseJSONObject(result)
        if (jsonResult.has("result")) {
            val resultObject = jsonResult.optString("result")
            val projects = GsonUtil.fromJson(resultObject, object : TypeToken<AiAnalyzeProjectBean?>() {})
        }
    }
})

// Update AI switch status: data: {"person":"1","car":"0"}
// key: "person", "car", "pet", "packageAi", "cry", "bark", "wild_animal", "bird", "shot", "glassbroken", "baby_cover_face", "baby_lie_down"
MeariUser.getInstance().updateAiProjects(data, cameraInfo.getDeviceID(), new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});

AiAnalyzeProjectBean: AI analysis
private String packageAiType; //"0"-Not enabled; "2"-Enabled
private ProjectsDTO projects; //

ProjectsDTO: AI switch status
private String person; //Person: "0"-Off; "1"-On
private String car;//Car: "0"-off; "1"-on
private String pet;//Pet/: "0"-off; "1"-on
private String packageX;//Package: "0"-off; "1"-on
private String cry;//Crying: "0"-off; "1"-on
private String bark;//Barking: "0"-off; "1"-on
private String wildAnimal;//Wild Animal: "0"-off; "1"-on
private String bird;//Bird: "0"-off; "1"-on
private String shot;//Gunshot: "0"-off; "1"-on
private String glassBroken;//GlassBroken: "0"-off; "1"-on
private String babyCoverFace;//BabyCover: "0"-off; "1"-on
private String babyLieDown; //Baby lying on its stomach: "0"-off; "1"-on
```

## 16.3 Use of AI service activation code
```
[Description]
Use activation code to activate AI service

[Code example]
// actCode-activation code
MeariUser.getInstance().requestActive(BuyServiceType.AI, actCode, cameraInfo.getDeviceID(), "", object : IResultCallback {
    override fun onSuccess() {
    }

    override fun onError(code: Int, error: String) {
    }
}, this)
```

## 16.4 AI service purchase
```
[Description]
Purchasing AI service is basically the same as purchasing cloud storage service
Parameter BuyServiceType.CLOUD is replaced by BuyServiceType.AI
```

# 17 Release Notes

## 2025-2-8(5.5.0)
```
1. Added AI service documentation
```

## 2024-10-22(5.5.0)
```
1. Added cloud storage service purchase documentation
```

## 2024-08-28(5.3.0)
```
1. Bluetooth Distribution Network
2. Device QR Code
```

## 2022-10-10(4.4.0)
```
1. Fix Android 12 crash problem, need to comment: // implementation 'org.eclipse.paho:org.eclipse.paho.android.service:1.1.1'
2. ptz capability set error description modification
3. Get device online status
4. Get bit rate
5. NVR support
6. Full Color Mode support
7. sound and light alarm support
```

## 2022-06-21(4.1.0)
```
1. Fix Android 12 crash problem, need to comment: // implementation 'org.eclipse.paho:org.eclipse.paho.android.service:1.1.1'
2. ptz capability set error description modification
```

## 2022-04-28(4.1.0)
```
Add cloud storage documents
```

## 2022-03-31(4.1.0)
```
The first draft of the family interface document is completed
```

## 2020-03-13(2.2.0)
```
Initial draft of SDK access guide completed
```
