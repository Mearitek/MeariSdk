
<h1><center> directory </center></h1>

[TOC]

<center>

---
Version number | Development team | Update date | Notes
:-:|:-:|:-:|:-:
2.2.0 | Meari Technical Team | 2020.03.03 | Optimization

<center>

# 1. Function Overview

The Meari SDK provides interface of communicating with hardware devices and Merai Cloud to accelerate the application development process, including the following functions:

- Account System
- Add Decvice
- Device Control
- Device Settings
- Share Device
- Message Center

--------------

# 2. Integration preparation
## Create App ID and App Secert
```
Meari Technology Cloud Platform provides webpages to automatically create App ID and App Secert for user SDK development, configuration in AndroidManifest
<meta-data
    Android:name="MEARI_APPKEY"
    Android:value="your MEARI_APPKEY" />
<meta-data
    Android:name="MEARI_SECRET"
    Android:value="your MEARI_SECRET" />
```
--------------

# 3. Integrated SDK
## 3.1 Integration Process
### 3.1.1 Import the sdk package
```
Import the so files and aar files from libs directory into your own project, you can partialy or fully import so files base on your project.
```

### 3.1.2 Configuring build.gradle
```
Add the following configuration to the build.gradle file:

android {
     defaultConfig {
         ...
         ndk {
         // Select the .so library corresponding to the cpu type to be added.
         abiFilters 'armeabi', 'arm64-v8a', 'armeabi-v7a', 'x86_64', 'x86'
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
    implementation(name: 'mearisdk-2.2.0-20200313', ext: 'aar')
    implementation 'com.squareup.okhttp3:okhttp:3.12.0'
    implementation 'org.eclipse.paho:org.eclipse.paho.client.mqttv3:1.2.0'
    implementation 'com.alibaba:fastjson:1.2.57'
    implementation 'com.google.zxing:core:3.3.3'
}
```

### 3.1.3 Configuring AndroidManifest.xml
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

    <permission
        Android:name="${applicationId}.permission.JPUSH_MESSAGE"
        Android:protectionLevel="signature" />

    <uses-permission android:name="${applicationId}.permission.JPUSH_MESSAGE" />
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

Jpush push configuration
 <!-- Rich push core function since 2.0.6-->
        <activity
            Android:name="cn.jpush.android.ui.PopWinActivity"
            Android:theme="@style/MyDialogStyle"
            Android:exported="false">
        </activity>

        <!-- Required SDK core features -->
        <activity
            Android:name="cn.jpush.android.ui.PushActivity"
            Android:configChanges="orientation|keyboardHidden"
            Android:theme="@android:style/Theme.NoTitleBar"
            Android:exported="false">
            <intent-filter>
                <action android:name="cn.jpush.android.ui.PushActivity" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="com.meari.test" />
            </intent-filter>
        </activity>

        <!-- Required SDK Core Features -->
        <!-- Configurable android: process parameter will put PushService in other processes -->
        <service
            Android:name="cn.jpush.android.service.PushService"
            Android:process=":mult"
            Android:exported="false">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.REGISTER" />
                <action android:name="cn.jpush.android.intent.REPORT" />
                <action android:name="cn.jpush.android.intent.PushService" />
                <action android:name="cn.jpush.android.intent.PUSH_TIME" />
            </intent-filter>
        </service>
        <!-- since 3.0.9 Required SDK Core Features -->
        <provider
            Android:authorities="com.meari.test.DataProvider"
            Android:name="cn.jpush.android.service.DataProvider"
            Android:exported="false"
            />

        <!-- since 1.8.0 option is optional. The function of the JPush service for different applications in the same device to pull each other up. -->
        <!-- If you do not enable this feature to delete the component, it will not pull up other applications and can not be pulled up by other applications -->
        <service
            Android:name="cn.jpush.android.service.DaemonService"
            Android:enabled="true"
            Android:exported="true">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.DaemonService" />
                <category android:name="com.meari.test" />
            </intent-filter>

        </service>
        <!-- since 3.1.0 Required SDK Core Features -->
        <provider
            Android:authorities="com.meari.test.DownloadProvider"
            Android:name="cn.jpush.android.service.DownloadProvider"
            Android:exported="true"
            />
        <!-- Required SDK core features -->
        <receiver
            Android:name="cn.jpush.android.service.PushReceiver"
            Android:enabled="true"
            Android:exported="false">
            <intent-filter android:priority="1000">
                <action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED_PROXY" /> <!--Required Display notification bar -->
                <category android:name="com.meari.test" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.USER_PRESENT" />
                <action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
            </intent-filter>
            <!-- Optional -->
            <intent-filter>
                <action android:name="android.intent.action.PACKAGE_ADDED" />
                <action android:name="android.intent.action.PACKAGE_REMOVED" />

                <data android:scheme="package" />
            </intent-filter>
        </receiver>

        <!-- Required SDK core features -->
        <receiver android:name="cn.jpush.android.service.AlarmReceiver" android:exported="false"/>

        <!-- User defined. For test only User-defined broadcast receiver -->
        <receiver
            Android:name=".receiver.MyReceiver"
            Android:exported="false"
            Android:enabled="true">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.REGISTRATION" /> <!--Required User registration SDK intent-->
                <action android:name="cn.jpush.android.intent.MESSAGE_RECEIVED" /> <!--Required User receives the intent of the SDK message-->
                <action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED" /> <!--Required The user receives the intent of the SDK notification bar information-->
                <action android:name="cn.jpush.android.intent.NOTIFICATION_OPENED" /> <!--Required user opens the intent of the custom notification bar-->
                <action android:name="cn.jpush.android.intent.CONNECTION" /><!-- Receive network changes Connection/disconnection since 1.6.3 -->
                <category android:name="com.meari.test" />
            </intent-filter>
        </receiver>

        <!-- User defined. For test only User-defined receiving message, 3.0.7 starts to support, the current tag/alias interface setting result will be called back in the corresponding method of the broadcast receiver -->
        <receiver android:name=".receiver.MyJPushMessageReceiver">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.RECEIVE_MESSAGE" />
                <category android:name="com.meari.test"></category>
            </intent-filter>
        </receiver>
        <!-- Required . Enable it you can get statistics data with channel -->
        <meta-data android:name="JPUSH_CHANNEL" android:value="developer-default"/>
        <meta-data android:name="JPUSH_APPKEY" android:value="" />
```


## 3.2 Initializing the SDK

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
# 4. User Management
```
Meari SDK provides mobile/email login, uid login, password reset, etc.
After registration or login is successful, use the response information to connect to the mqtt service, initialize the Jpush and other operations.
```

UserInfo class
- jpushAlias ​​Jpush Push Alias
- userID user ID
- nickName nickname
- phoneCode country code
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


## 4.1 Mobile / Email Registration
```
【description】
Mobile or email registration (Mobile registration is only supported in Mainland China).

[Function call]

/ **
 * get verification code
 *
 * @param countryCode country code
 * @param phoneCode area code
 * @param userAccount account
 * @param callback network request callback
 * /
public void getValidateCodeWithAccount (String countryCode, String phoneCode, String userAccount, IValidateCallback callback);

/ **
 * register account, and return the mqtt iot info.
 *
 * @param countryCode country code
 * @param phoneCode area code
 * @param account
 * @param pwd password
 * @param nickname
 * @param code verification code
 * @param callback network request callback
 * /
public void registerWithAccount (String countryCode, String phoneCode, String account, String pwd, String nickname, String code, IRegisterCallback callback);

[Code example]

MeariUser.getInstance (). GetValidateCodeWithAccount (countryCode, phoneCode, account, new IValidateCallback () {
    @Override
    public void onSuccess (int leftTime) {
        // leftTime indicates the remaining valid time of the verification code
    }

    @Override
    public void onError (int code, String error) {
    }
});

MeariUser.getInstance (). RegisterWithAccount (countryCode, phoneCode, account, pwd, nickname, code, new IRegisterCallback () {
    @Override
    public void onSuccess (UserInfo user) {
        // UserInfo returns user information
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 4.2 Mobile / Email Login
```
【description】
Mobile / email login

[Function call]

/ **
 * Login Account
 *
 * @param countryCode country code
 * @param phoneCode area code
 * @param userAccount domestic phone / email
 * @param password user password
 * @param callback network request callback
 * /
public void loginWithAccount (String countryCode, String phoneCode, String userAccount, String password, ILoginCallback callback);
    
[Code example]

MeariUser.getInstance (). LoginWithAccount (countryCode, phoneCode, userAccount, password, new ILoginCallback () {
    @Override
    public void onSuccess (UserInfo user) {
        // It is recommended to initialize the Aurora and connect to the mqtt service in MainActivity, save the user information after the first login, and do not have to log in every time you start the app.
        // If you need to receive push messages, contact us to configure related parameters, use our alias to initialize Aurora Push, and refer to the Aurora official document for the access process.
        initJPushAlias ​​(user.getJpushAlias ​​());
        // connect mqtt service
        if (! MeariUser.getInstance (). isMqttConnected ()) {
            MeariUser.getInstance (). ConnectMqttServer (getApplication ());
        }
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 4.3 Reset password
```
【description】
reset Password
 
[Function call]
/ **
 * get verification code
 *
 * @param countryCode country code
 * @param phoneCode area code
 * @param userAccount account
 * @param callback network request callback
 * /
public void getValidateCodeWithAccount (String countryCode, String phoneCode, String userAccount, IValidateCallback callback);

/ **
 * reset Password
 *
 * @param countryCode country code
 * @param phoneCode area code
 * @param account Domestic phone / email
 * @param verificationCode verification code
 * @param password User new password password
 * @param callback network request callback
 * /
public void resetPasswordWithAccount (String countryCode, String phoneCode, String account, String verificationCode, String pwd, IResetPasswordCallback callback);
    
[Code example]

MeariUser.getInstance (). GetValidateCodeWithAccount (countryCode, phoneCode, account, new IValidateCallback () {
    @Override
    public void onSuccess (int leftTime) {
        // leftTime indicates the remaining valid time of the verification code
    }

    @Override
    public void onError (int code, String error) {
    }
});

MeariUser.getInstance (). ResetPasswordWithAccount (countryCode, phoneCode, account, verificationCode, pwd, new IResetPasswordCallback () {
    @Override
    public void onSuccess (UserInfo user) {
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 4.4 uid user system

```
【description】
If customers have their own user system, then you can use uid to login.
The uid is required to be unique and defined by your own. You can login directly without registration.

[Function call]

/ **
 * User UID login
 * @param countryCode country code
 * @param phoneCode area code
 * @param uid user unique identifier
 * @param callback network request callback
 * /
public void loginWithUid (String countryCode, String phoneCode, String uuid, ILoginCallback callback);
        
[Code example]

MeariUser.getInstance (). LoginWithUid (countryCode, phoneCode, uid, new ILoginCallback () {
    @Override
    public void onSuccess (UserInfo user) {
        // It is recommended to initialize the Aurora and connect to the mqtt service in MainActivity, save the user information after the first login, and do not have to log in every time you start the app.
        // If you need to receive push messages, contact us to configure related parameters, use our alias to initialize Aurora Push, and refer to the Aurora official document for the access process.
        initJPushAlias ​​(user.getJpushAlias ​​());
        // connect mqtt service
        if (! MeariUser.getInstance (). isMqttConnected ()) {
            MeariUser.getInstance (). ConnectMqttServer (getApplication ());
        }
    }
    @Override
    public void onError (String code, String error) {
        // fail
    }
});
```

## 4.5 Log out
```
【description】
sign out

[Function call]

/ **
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
        MqttMangerUtils.getInstance (). DisConnectService ();
    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 4.6 Upload user avatar
```
【description】
Upload a user avatar.
 
[Function call]

/ **
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
## 4.7 Change nickname
```
【description】
Modify user nickname.
 
[Function call]

/ **
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

# 5. Add device
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

/ **
 * Get distribution token
 *
 * @param callback callback
 * /
public void getToken (IGetTokenCallback callback);

/ **
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
After the device is found, the status of the device is detected. If automatic addition is not supported, you should call interface to add device.
If automatic addition is supported, waiting for the mqtt message to verify it's successful or fail.
There may be a delay in the mqtt message. In order to improve the experience, you can periodically call the getDeviceList() and check whether there are more new devices to determine whether the addition was successful.

[Function call]

/ **
 * Query device status list
 *
 * @param ssid wifi name
 * @param pwd wifi password
 * @param wifiMode wifi encryption type
 * @param scanningResultActivity search result callback
 * @param status status
 * /
public MangerCameraScanUtils (String ssid, String pwd, int wifiMode, CameraSearchListener scanningResultActivity, boolean status)

/ **
 * Query device status list
 *
 * @paramList <CameraInfo> cameraInfos device list
 * @param callback network request callback
 * /
public void checkDeviceStatus (List <CameraInfo> cameraInfos, IDeviceStatusCallback callback);

/ **
 * Add device
 *
 * @paramList <CameraInfo> cameraInfos device list
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
mangerCameraScan.startSearchDevice (false, -1, 100, ActivityType.ACTIVITY_SEARCHCANERARESLUT, token)


MeariUser.getInstance (). CheckDeviceStatus (cameraInfos, deviceTypeID, new IDeviceStatusCallback () {
    @Override
    public void onSuccess (ArrayList <CameraInfo> deviceList) {
        // 1 means your own device, 2 means someone else ’s micro share to the device, 3 means the device can be added to 4, others' devices have been shared to themselves
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

## 5.2 Add device via AP

# 6. Device Control

## 6.1 Basic Device operation

### 6.1.1 Introduction to device-related classes

MeariDevice (manages the list of devices)

-List <NVRInfo> nvrs; NVR list
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
-int addStatus // device status 1 means own device, 2 means others have not shared to the device, 3 means device can be added 4, others' devices have been shared to themselves
-int devTypeID; // device type
-String userAccount; // Has an account
-boolean asFriend // Whether to share to your device as a friend

### 6.1.2 Get device information list
```
【description】
Meari SDK provides multiple interface for developers to achieve device information acquisition and management capabilities (removal, etc.). The device data is notified to the recipient using an asynchronous message.
We use the EventBus to implement message notification. Therefore, the notification object needs to be registered and destroyed on each device operation page. For details, please refer to the demo implementation.

[Function call]
/ **
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
/ **
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

### 6.1.4 Device Nickname Modification
```
【description】
Device nickname modification

[Function call]
/ **
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

### 6.1.5 Get device alarm message time segment
```
【description】
Get time segment of device alarm message

[Function call]

/ **
  * Get time segment of devcie alarm message
  *
  * @param deviceID device ID
  * @param dayTime Time: "20200303"
  * @param callback callback
  * /
public void getDeviceAlarmMessageTimeForDate (String deviceID, String dayTime, IDeviceAlarmMessageTimeCallback callback);

[Code example]
MeariUser.getInstance().GetDeviceAlarmMessageTimeForDate (deviceID, dayTime, new IDeviceAlarmMessageTimeCallback () {
     @Override
     public void onSuccess (ArrayList <VideoTimeRecord> videoTimeList) {
     }

     @Override
     public void onError (int code, String error) {
     }
});
```

## 6.2 Device preview and playback
### 6.2.1 Device Preview
```
【description】
One device corresponds to one CameraInfo and one MeariDeviceController. When performing multiple operations on the same device, ensure that you use the same object and do not create it repeatedly.
CameraInfo and a MeariDeviceController can be stored in the MeariUser class and retrieved when needed. You need to recreate and save when operating another device.

[Function call]
/ **
 * Connected device
 *
 * @param deviceListener device listener
 * /
public void startConnect (MeariDeviceListener deviceListener);

/ **
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
After the SD is inserted into device, it will record the video and save it to the SD card, and then you can view the video from SD card. The playback operation can only be performed after the device is successfully connected.

[Function call]

/ **
 * Get a month with a video date
 * @param year
 * @param month
 * @param videoId video definition
 * @param callback callback
 * /
public void getPlaybackVideoDaysInMonth (int year, int month, int videoId, IPlaybackDaysCallback callback);

/ **
 * Get all video clips of the day
 * @param year
 * @param month
 * @param videoId video definition
 * @param callback callback
 * /
public void getPlaybackVideoTimesInDay (int year, int month, int day, int videoId, MeariDeviceListener deviceListener);


/ **
 * Start playing video
 *
 * @param ppsGLSurfaceView video control
 * @param videoId video resolution 0-HD; 1-SD
 * @param startTime video start time
 * @param deviceListener operation listen
 * @param videoStopListener
 * /
public void startPlaybackSDCard (PPSGLSurfaceView ppsGLSurfaceView, int videoId, String startTime, MeariDeviceListener deviceListener, MeariDeviceVideoStopListener videoStopListener);

/ **
 * Drag to change playback video
 *
 * @param seekTime the time the video started
 * @param deviceListener operation listen
 * @param videoStopListener
 * /
public void seekPlaybackSDCard (String seekTime, MeariDeviceListener deviceListener, MeariDeviceVideoSeekListener seekListener);

/ **
 * Pause video
 *
 * @param deviceListener operation listen
 * /
public void pausePlaybackSDCard (MeariDeviceListener deviceListener);

/ **
 * Replay video after pause
 *
 * @param deviceListener operation listen
 * /
public void resumePlaybackSDCard (MeariDeviceListener deviceListener)

/ **
 * Stop playing video
 *
 * @param deviceListener operation listen
 * /
public void stopPlaybackSDCard (MeariDeviceListener deviceListener);


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
```

# 7. Share device

## 7.1 Related Classes

ShareUserInfo Share user information
-String userAccount; User account
-String userName; User name
-String userIcon; User avatar
-String shareStatus; Share status

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
/ **
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
/ **
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
Get sharing results of all devices

[Function call]
/ **
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
/ **
 * Search for a user
 *
 * @param account
 * @param deviceID device ID
 * @param callback Function callback
 * /
public void searchUser (String account, String deviceID, ISearchUserCallback callback)

[Code example]
MeariUser.getInstance (). SearchUser (account, deviceID, new ISearchUserCallback () {
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
/ **
 * Share device
 * @param account
 * @param deviceID device ID
 * @param callback Function callback
 * /
public void shareDevice (String account, String deviceID, IResultCallback callback);

[Code example]
MeariUser.getInstance (). ShareDevice (account, deviceID, new IResultCallback () {
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
/ **
 * Cancel shared device
 * @param account
 * @param deviceID device ID
 * @param callback Function callback
 * /
public void cancelShareDevice (String account, String deviceID, IResultCallback callback);

[Code example]
MeariUser.getInstance (). CancelShareDevice (account, cameraInfo.getDeviceID (), new IResultCallback () {
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
/ **
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
Handling shared messages

[Function call]
/ **
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

# 8.Message Center
## 8.1 Device shared messages

### 8.1.1 Get shared message list of device
```
【description】
Get shared message list of device

[Function call]
/ **
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
/ **
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
## 8.2 Alarm message of device

### 8.2.1 Get all devices whether have messages
```
【description】
Gets all devices whether have messages

[Function call]
/ **
 * Get alarm messages of all devices
 *
 * @param callback function callback
 * /
public void getDeviceMessageStatusList (IDeviceMessageStatusCallback callback);

[Method call]

DeviceMessageStatus
-long deviceID; device ID
-String deviceName; device name
-String snNum; device SN
-String deviceIcon; device icon
-boolean hasMessage; whether the device has an alarm message

MeariUser.getInstance (). GetDeviceMessageStatusList (new IDeviceMessageStatusCallback () {
    @Override
    public void onSuccess (List <DeviceMessageStatus> deviceMessageStatusList) {
        // If the device has an alarm message, you can get the alarm message
    }

    @Override
    public void onError (int code, String error) {

    }
});
```

### 8.2.2 Get alarm messages of a single device
```
【description】
Get alarm messages of a single device

[Function call]
/ **
 * refuse friend share device
 * Get the alarm message of a single device (get the latest 20 at a time, after the device owner pulls it, the server deletes the data, pay attention to save the data)
 *
 * @param deviceId device id
 * @param callback function callback
 * /
public void getAlarmMessagesForDev (long deviceId, IGetAlarmMessagesCallback callback);

[Method call]

class DeviceAlarmMessage:
-long deviceID; // device ID
-String deviceUuid; // device unique identifier
-String imgUrl; // Alarm picture address
-int imageAlertType; // Alarm type (PIR and Motion)
-int msgTypeID; // message type
-long userID; // User Id
-long userIDS;
-String createDate; // wear time
-String isRead; // whether read
-String tumbnailPic; // Thumbnails
-String decibel; // dB
-long msgID; // Message Id


MeariUser.getInstance (). GetAlarmMessagesForDev (getMsgInfo (). GetDeviceID (), new IDeviceAlarmMessagesCallback () {
    @Override
    public void onSuccess (List <DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo) {

    }

    @Override
    public void onError (int code, String error) {
    }
});
```

## 8.3 System Message

### 8.3.1 Get system message list
```
【description】
Get list of system messages

[Function call]
/ **
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
/ **
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



# 9. Camera settings
Used to set the camera's detection alarm, sleep mode, local playback and so on.
Whether different devices support a certain setting can be judged by the device's capability set.


## 9.1 device Capability
If (cameraInfo.getLed() == 1) {
    / / Support switch settings such as LED
} else {
    // does not support switch settings such as LEDs
}

device Capability

- int dcb; noise alarm: 0-not supported; 1-support
- int pir; human detection: 0-not supported; 1-support
- int md; motion detection: 0-not supported; 1-support
- int cst; cloud storage : 0 - not supported; 1 - support
- int dnm; day and night mode: 0-not supported; 1-support
- int led; LED lights : 0 - not supported; 1 - support
- int flp; video flip: 0-not supported; 1-support
- int bcd; crying detection: 0-not supported; 1-support
- int ptr; humanoid tracking: 0-not supported; 1-support
- int pdt; humanoid detection: 0-not supported; 1-support

## 9.2 device parameters

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


## 9.3 Format SD Card of device
```
【description】
The device formats the SD card. After the formatting is successful, the formatting progress is obtained through the mqtt message.

[Function call]
/ **
 * Get device SD card information
 *
 * @param callback Function callback
 * /
public void getSDCardInfo (ISDCardInfoCallback callback);

/ **
 * Start formatting SD card
 *
 * @param callback Function callback
 * /
public void startSDCardFormat (ISDCardFormatCallback callback);

/ **
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

/ **
 * Check if the device has a new version
 *
 * @param devVersion device version
 * @param lanType language type ("en")
 * @param callback callback
 * /
public void checkNewFirmwareForDev (String devVersion, String lanType, ICheckNewFirmwareForDevCallback callback);

/ **
 * Start to upgrade device firmware
 *
 * @param upgradeUrl upgrade address
 * @param upgradeVersion upgrade version
 * @param callback Function callback
 * /
public void startDeviceUpgrade (String upgradeUrl, String upgradeVersion, IDeviceUpgradeCallback callback);

/ **
 * Get progress of firmware upgrade
 *
 * @param callback Function callback
 * /
public void getDeviceUpgradePercent (IDeviceUpgradePercentCallback callback);


[Code example]

MeariUser.getInstance (). CheckNewFirmwareForDev (firmware_version, "en", new ICheckNewFirmwareForDevCallback () {
    @Override
    public void onSuccess (DeviceUpgradeInfo info) {
        mDeviceUpgradeInfo = info;
    }

    @Override
    public void onError (int code, String error) {
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
```


## 9.5 Basic parameter settings

### 9.5.1 Get the parameters of the device
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

### 9.5.3 Flip control of device preview video
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

### 9.5.4 Local recording settings of device
```
【description】
Local recording type and the time of event recoding segment setting of device

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

### 9.5.5 Day and night mode setting of device
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
MeariUser.getInstance().setDayNightMode(mode, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.6 Sleep mode setting of device
```
【description】
Sleep mode setting of device

[Function call]
/ **
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

### 9.5.7 Scheduled sleep period setting of device
```
【description】
Scheduled sleep period setting of device

[Function call]
/ **
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

### 9.5.8 Motion detection setting of device
```
【description】
Motion detection setting of device

[Function call]
/ **
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

### 9.5.9 PIR detection setting of device
```
【description】
PIR detection setting of device

[Function call]
/ **
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

### 9.5.10 Noise detection setting of device
```
【description】
Noise detection setting of device

[Function call]
/ **
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

### 9.5.11 Cry alarm setting of device
```
【description】
Cry alarm setting of device

[Function call]
/ **
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

### 9.5.12 Human tracking setting of Device
```
【description】
Human tracking setting of Device

[Function call]
/ **
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

### 9.5.13 Human detection alarm setting of device
```
【description】
Human detection alarm setting of device

[Function call]
/ **
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

### 9.5.14 Humanoid frame setting of device
```
【description】
Humanoid frame setting of device

[Function call]
/ **
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

### 9.5.15 Onvif setting of device
```
【description】
Onvif setting of device

[Function call]
/ **
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

### 9.5.16 Video encoding format setting of device
```
【description】
Video encoding format setting of device

[Function call]
/ **
  * Video encoding format setting of device
  *
  * @param type encoding type
  * @param callback Function callback
  * /
public void setVideoEncoding (int type, ISetDeviceParamsCallback callback);

[Code example]
MeariUser.getInstance (). SetVideoEncoding (type, new ISetDeviceParamsCallback () {
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

## 9.6 Parameter setting of NVR
## 9.7 Parameter setting of babymonitor
## 9.8 Parameter setting of doorbell
### 9.8.1 Intercom volume settings of device
```
【description】
Intercom volume setting of Device

[Function call]
/ **
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

### 9.8.2 Unlocking the battery lock
```
【description】
Unlocking the battery lock

[Function call]
/ **
 * Unlocking the battery lock
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

### 9.8.3 Binding Wireless Chime
```
【description】
Binding Wireless Chime

[Function call]
/ **
  * Binding Wireless Chime
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

### 9.8.4 Unbinding Wireless Chime
```
【description】
Unbinding Wireless Chime

[Function call]
/ **
  * Unbinding Wireless Chime
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

### 9.8.5 Whether the wireless chime works
```
【description】
Whether the wireless chime works

[Function call]
/ **
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


### 9.8.6 Volume setting of wireless chime
```
【description】
Volume setting of wireless chime

[Function call]
/ **
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

### 9.8.7 Ringtone setting of wireless chime
```
【description】
Ringtone setting of wireless chime

[Function call]
/ **
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

### 9.8.8 Whether the mechanical chime works
```
【description】
Whether the mechanical chime works

[Function call]
/ **
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

## 9.9 Parameter setting of voice bell
## 9.10 Parameter setting of floodlight camera
## 9.11 Parameter setting of relay router

### 9.2.25 Start rotation command of device
```
【description】
Start rotation command of device

[function call]

/**
 * Start rotation command of device
 *
 * @param snNum device's sn number
 * @param timeList p: left-80; right 80. t: lower -20; upper 20. z: passed in 0
 * @param tag request tag
 * @param callback request callback
 */
Public void startPTZ(String snNum, int p, int t, int z, Object tag, IStringResultCallback callback);

[code example]

//move to the left
MeariUser.getInstance().startPTZ(cameraInfo.getSnNum(), -80, 0, 0, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 9.2.26 Stop rotation command of device
```
【description】
Stop rotation command of device

[function call]

/**
 * Stop rotation command of device
 *
 * @param snNum device's sn number
 * @param timeList 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void stopPTZ(String snNum, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().stopPTZ(cameraInfo.getSnNum(), this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

# 10.MQTT and push
```
The meari SDK supports internal MQTT push messages, as well as Aurora, FCM and other vendors (supported in future)
```

## 10.1 MQTT messages
```
Used to receive messages such as device add success message, doorbell call message, voice doorbell call message, remote login, etc.
```

### 10.1.1 Connect to MQTT Service

// Called after the user login successfully
if (! MeariUser.getInstance (). isMqttConnected ()) {
    MeariUser.getInstance (). ConnectMqttServer (application);
}

### 11.1.2 Exit MQTT Service

// Called after the user logout successfully
if (MeariUser.getInstance (). isMqttConnected ()) {
    MeariUser.getInstance (). DisConnectMqttService ();
}

### 11.1.3 MQTT message processing

```
When the SDK is initialized, the implementation of the MqttMessageCallback interface should be passed into it, like MyMessageHandler in the demo.
Handle MQTT in the implementation of the MqttMessageCallback interface (see Demo MyMessageHandler)

/ **
 * Other news
 * @param messageId message ID
 * @param message message content
 * /
void otherMessage (int messageId, String message);

/ **
 * Offsite login
 * /
void loginOnOtherDevices ();

/ **
 * The owner cancels or deletes the shared device
 * @param deviceId device ID
 * @param deviceName device name
 * /
void onCancelSharingDevice (String deviceId, String deviceName);

/ **
 * Device unbound (e-commerce unbundling)
 * /
void deviceUnbundled ();

/ **
 * Doorbell call
 * @param bellJson doorbell information
 * @param isUpdateScreenshot is the message to update the screenshot
 * /
void onDoorbellCall (String bellJson, boolean isUpdateScreenshot);

/ **
 * Device added successfully
 * /
void addDeviceSuccess (String message);

/ **
 * Failed to add device
 * /
void addDeviceFailed (String message);

/ **
 * Failed to add the device, the device failed to be unbound and the add failed
 * /
void addDeviceFailedUnbundled (String message);

/ **
 * Received device shared by someone
 * /
void ReceivedDevice (String message);

/ **
 * Request to receive a device shared by someone
 * @param userName user name
 * @param deviceName device name
 * @param msgID message ID
 * /
void requestReceivingDevice (String userName, String deviceName, String msgID);

/ **
 * Request to share device to someone
 * @param userName user name
 * @param deviceName device name
 * @param msgID message ID
 * /
void requestShareDevice (String userName, String deviceName, String msgID);
```

## 10.2 Integrated Aurora Push

### 10.2.1 Apply for an account
```
Please apply for Aurora Push account and create application by yourself, refer to the official document to integrate Aurora Push. Contact us to configure the Aurora key and secret you applied for.
```
### 10.2.2 Setting User Alias
```
UserInfo is obtained after successfully logging in to meari.
After the aurora is successfully initialized, use the userInfo.getJpushAlias ​​() successfully from login to set the aurora alias.
Initialize and set the alias refer to the official document or the MeariSDK demo
```
### 10.2.3 Message Handling
```
Refer to the message processing in the MyReceiver file from the demo
```

## 10.3 Integrated Google Push
```
Not currently supported
```

## 10.3 Integration with other pushes
```
Not currently supported
```

# Release Notes:
2020-03-13 wu: Initial draft of 2.2.0 SDK access guide completed