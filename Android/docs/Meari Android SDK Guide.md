<h1><center> directory </center></h1>
[TOC]

Version number | Development team | Update date | Notes
:-:|:-:|:-:|:-:
2.0.0 | Towers Perrin Technical Team | 2019.09.20 | Optimization

# 1. Function Overview

The Towers Technology APP SDK provides interface packaging with hardware devices and Towers Perrin, and accelerates the application development process, including the following functions:

- Hardware device related (with network, control, status reporting, firmware upgrade, preview playback, etc.)
- Account system (mobile phone number, email registration, login, password reset, etc.)
- Device sharing
- Friends management
- Message Center
- Feedback
- Meari cloud HTTPS API interface package (see Meari cloud api call)

--------------

# 2. Integration preparation
## Create App ID and App Secert
```
Towers Perrin Technology Cloud Platform provides webpages to automatically create App ID and App Secert for user SDK development, configuration in AndroidManifest
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
### 3.1.1 Introducing the sdk package
```
Copy meatisdk_2.0.0.aar to the libs directory and copy the so files from the demo to the libs directory.
The so file is introduced according to the full or partial type of the needs of the project.
```

### 3.1.2 Configuring build.gradle

Add the following configuration to the build.gradle file.
```
Repositories {
    flatDir {
        Dirs 'libs'
    }
}
Android {
     sourceSets {
        Main {
            jniLibs.srcDirs = ['libs']
        }
    }
}
Dependencies {
    Implementation(name: 'mearisdk-1.0.0', ext: 'aar')
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

Aurora push configuration
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
 * @param callback mqtt message callback
 */
MeariSdk.init(Contex context, IMessageCallback callback);

[code example]

Public class MeariMessage implements IMessageCallback {
    @Override
    Public void messageArrived( String message) {
        / / Process mqtt message
    }
}

Public class MeariSmartApp extends Application {
    @Override
    Public void onCreate() {
        super.onCreate();
        // Initialize
        MeariSdk.init(this, new MeariMessage());
        // output log
        MeariSdk.getInstance().setDebug(true);
    }
}
```
# 4. User Management (MeariUser Tools)
```
Towers Perrin provides mobile phone/email password login, uid login, password reset, etc.
After registration or login is successful, use the return information to connect to the mqtt service, initialize the aurora and other operations.
(Hint: Object tag parameter in the function, you can pass this, the following is true)
```

UserInfo class
- jpushAlias ​​Aurora Push Alias
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


## 4.1 Mobile/Email Password Registration
```
【description】
Phone password registration. Currently only supports domestic mobile phone registration.

[function call]
    
/**
 * Get phone verification code
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param account
 * @param tag Network request tag (Hint: Object tag parameter in the function, you can pass this, the following is the same, no longer listed)
 * @paramI ValidateCallback network request return
 */
Public void getValidateCode(String countryCode, String phoneCode, String account, Object tag, final IValidateCallback callback);
  
/**
 * register account
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param account
 * @param pwd password
 * @param nickname nickname
 * @param code verification code
 * @param callback returns callback
 */
Public void registerAccount2(String countryCode, String phoneCode, String account, String pwd, String nickname, String code, IRegisterCallback callback);

[code example]

MeariUser.getInstance().getValidateCode(countryCode, phoneCode, account, this, new IValidateCallback() {
    @Override
    Public void onSuccess(int leftTime) {
        stopProgressDialog();
        startTimeCount(leftTime);//leftTime indicates the remaining valid time of the verification code
    }

    @Override
    Public void onError(int code, String error) {
        stopProgressDialog();
        CommonUtils.showToast(error);
    }
});

MeariUser.getInstance().registerAccount2(countryCode,phoneCode,account,pwd,nickname,code, new IRegisterCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        //UserInfo returns user information
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 4.2 Mobile/Email Password Login
```
【description】
Support domestic mobile phone password login.
 
[function call]

/**
 * Login account
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param userAccount Domestic Phone/Email
 * @param password user password
 * @param callback login callback interface return user information
 */
Public void login2(String countryCode, String phoneCode, String userAccount, String password, ILoginCallback callback);
    
[code example]

MeariUser.getInstance().login2(countryCode,phoneCode, userAccount, password, new ILoginCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        // It is recommended to initialize Aurora and connect mqtt service in MainActivity. After logging in for the first time, save the user information, you don't have to log in every time you start the app.
        / / If you need to receive push messages, contact us to configure the relevant parameters, use our alias to initialize the Aurora push, access process reference Aurora official documentation.
        initJPushAlias(user.getJpushAlias());
        // connect to the mqtt service
        MeariUser.getInstance().connectMqttServer(getApplication());
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 4.3 Reset password
```
【description】
Only passwords for mailbox and / domestic mobile phones are supported.
 
[function call]
/**
 * Get phone verification code
 *
 * @param countryCode country code
 * @param username Mobile number/email
 */
MeariUser.getInstance().getValidateCode(String countryCode, String username, final IValidateCallback callback);

/**
 * reset Password
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param account Domestic Phone/Email
 * @param verificationCode verification code
 * @param password User new password password
 * @param callback login callback interface return user information
 */
Public void resetAccountPassword2(String countryCode, String phoneCode, String account, String verificationCode, String pwd, final IResetPasswordCallback callback)
    
[code example]

MeariUser.getInstance().resetAccountPassword2(countryCode, phoneCode, account, verificationCode, pwd, new IResetPasswordCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        If(user == null) {
/ / means reset password
}else {
/ / Indicates the password is retrieved
}
    }

    @Override
    Public void onError(int code, String error) {
        stopProgressDialog();
    }
});
```

## 4.4 uid user system

```
【description】
If the customer has their own user system, they can log in via uid and access our sdk.
User uid login, uid requires unique, defined by the access side. The uid system can log in directly without registration.

[function call]

/**
 * User uid registration
 * @param countryCode country number (CN)
 * @param phoneCode country phone number area code (+86)
 * @param uid user unique identifier
 * @param callback uid registration callback interface
 */
Public void loginWithUid2(String countryCode, String phoneCode, String uid, final ILoginCallback callback);
        
[code example]

MeariUser.getInstance().loginWithUid2(countryCode, phoneCode,uid, new IRegisterCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        // It is recommended to initialize Aurora and connect mqtt service in MainActivity. After logging in for the first time, save the user information, you don't have to log in every time you start the app.
        / / If you need to receive push messages, contact us to configure the relevant parameters, use our alias to initialize the Aurora push, access process reference Aurora official documentation.
        initJPushAlias(user.getJpushAlias());
        // connect to the mqtt service
        MeariUser.getInstance().connectMqttServer(getApplication());
    }
    @Override
    Public void onError(String code, String error) {
        // failed
    }
});
```

## 4.5 Logout
```
【description】
Call the following interface to log out when you exit the application or log out.

[function call]
/**
 * @param callback logout callback
 */
MeariUser.getInstance().logout(ILogoutCallback callback);

[code example]
MeariUser.getInstance().logout(new ILogoutCallback() {
    @Override
    Public void onSuccess(int resultCode) {
        / / Clear user information, disconnect mqtt connection, etc.
        MqttMangerUtils.getInstance().disConnectService();
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 4.6 Uploading User Avatar (MeariUser Tool Class)
```
【description】
Upload a user avatar.
 
[function call]

/**
 * Upload user avatar
 *
 * @param file User avatar image file path (preferably 300*300)
 * @param callback callback
 */
Public void uploadUserAvatar(String filePath, IAvatarCallback callback);
        
[code example]

MeariUser.getInstance().uploadUserAvatar(path, new IAvatarCallback() {
    @Override
    Public void onSuccess(String path) {
//path is the address of the server avatar after returning the upload.
    }

    @Override
    Public void onError(String code, String error) {

    }
});
```
## 4.7 Modify nickname
```
【description】
Modify the user nickname.
 
[function call]

/**
 * Upload user avatar
 *
 * @param nickname User new nickname
 * @param callback network request callback
 */
Public void renameNickname(String nickname, final IResultCallback callback);
        
[code example]

MeariUser.getInstance().renameNickname(name, new IResultCallback() {
    @Override
    Public void onSuccess() {

    }

    @Override
    Public void onError(String code, String error) {

    }
});
```

# 5. Equipment distribution network (PPSCameraPlayer tool class)
```
Towers Perrin's hardware modules support three distribution modes: Quick Connect mode (TLink, EZ mode for short), Hotspot mode (AP mode), and QR code distribution mode.
The QR code and Quick Connect mode are relatively easy to operate. It is recommended to use the hotspot mode as an alternative after the distribution network fails. Among them, the success rate of the two-dimensional code distribution network is high.
```

## 5.1 Generating QR code
```
【description】
After obtaining the token, generate the QR code for scanning the device.

[function call]

/**
 * Get distribution network temporary token
 *
 * @param type with network type
 * @param callback callback
 */
Public void getToken(int type, IGetTokenCallback callback);

/**
 * Generate distribution network QR code
 *
 * @param ssid wifi name
 * @param password wifi password
 * @param token distribution network temporary token
 * @param callback callback
 */
Public void createQR(String ssid, String password, String token, ICreateQRCallback callback);

[code example]

MeariUser.getInstance().getToken(Distribution.DISTRIBUTION_QR, new IGetTokenCallback() {
    @Override
    Public void onError(int code, String error) {
        // error
    }
    @Override
    Public void onSuccess(String token, int leftTime) {
        // token distribution token
        // leftTime remaining effective time
    }
});


MeariUser.getInstance().createQR(wifiName, wifiPwd, token, new ICreateQRCallback() {
    @Override
    Public void onSuccess(Bitmap bitmap) {
        mQrImage.setImageBitmap(bitmap);// Display QR code
    }
});
```

## 5.2 Searching for added devices
```
【description】
After the device is searched, it is detected whether the device can be added, and then the add interface is added.

[function call]

/**
 * Query device status list
 *
 * @param ssid wifi name
 * @param pwd wifi password
 * @param wifiMode wifi encryption type
 * @param scanningResultActivity search result callback
 * @param status status
 */
Public MangerCameraScanUtils(String ssid, String pwd, int wifiMode, CameraSearchListener scanningResultActivity, boolean status)

/**
 * Query device status list
 *
 * @paramList<CameraInfo>cameraInfos device list
 * @param callback network request callback
 */
Public void checkDeviceStatus(List<CameraInfo>cameraInfos, IDeviceStatusCallback callback);

/**
 * Add device
 *
 * @paramList<CameraInfo>cameraInfos device list
 * @param callback network request callback
 */
Public void addDevice(CameraInfo cameraInfo, int deviceTypeID, IAddDeviceCallback callback);

[code example]

MangerCameraScanUtils mangerCameraScan = new MangerCameraScanUtils(ssid, pwd, wifiMode, new CameraSearchListener() {
    @Override
    Public void onCameraSearchDetected(CameraInfo cameraInfo) {
        / / Search device callback, execute when the device is discovered
    }

    @Override
    Public void onCameraSearchFinished() {
        //Search is complete
    }

    /**
     * @param time How many s have gone?
     * Refresh progress, if it is larger than progress and the search device is not empty, jump to the next interface
     */
    @Override
    Public void onRefreshProgress(int time) {
        
    }

}, false);

// start searching
mangerCameraScan.startSearchDevice(mIsMonitor, -1, ActivityType.ACTIVITY_SEARCHCANERARESLUT);


MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID, new IDeviceStatusCallback() {
    @Override
    Public void onSuccess(ArrayList<CameraInfo> deviceList) {
        // 1 means your own device, 2 means someone else's micro share to the device, 3 means the device can add 4, others' devices have been shared with themselves
        If (cameraInfo.getAddStatus() == 3) {
            / / Add equipment
        }
    }

    @Override
    Public void onError(int code, String error) {

    }
});

MeariUser.getInstance().addDevice(info, this.mDeviceTypeID, new IAddDeviceCallback() {
    @Override
    Public void onSuccess(String sn) {
       
    }

    @Override
    Public void onError(int code, String error) {
        
    }
});
```

# 6. Device Control

## 6.1 Introduction to device related classes

MeariDevice (manage acquisition device return list)

- List<CameraInfo> ipcs; normal camera list
- List<CameraInfo> bells; doorbell list
- List<CameraInfo> snapCameras; battery camera list
- List<CameraInfo> voiceBells; voice doorbell list
- List<CameraInfo> fourthGenerations; 4G camera list
- List<CameraInfo> flightCameras; luminaire camera list
- List<NVRInfo> nvrs; NVR list

BaseDeviceInfo (device information base class)

- String deviceID //Device ID
- String deviceUUID // device unique identifier
- boolean state//device online status
- String hostKey //Device password
- String snNum / / device SN
- String deviceName / / device name
- String tp//device item number
- String deviceIcon / / device icon gray icon
- int addStatus//Device status 1 means that it is your own device, 2 means that others' micro-shares to the device, 3 means that the device can be added 4, others' devices have been shared with themselves
- String deviceIconGray / / device icon gray icon
- int protocolVersion//device version
- int devTypeID; / / device type
- String userAccount; / / has an account


CameraInfo extends BaseDeviceInfo (camera information class)

- int vtk = -1//device capability level voice intercom: 0=none, 1=speaker only, 2=mic only, 3=speaker/mic/halfduplex, 4=speaker/mic/Fullduplex
- int fcr = -1//device capability level face recognition: face recognize support value
- int dcb = -1//device capability level audible alarm: decibel support value
- int ptz = -1//device capability level PTZ 0=not support, 1=left/right, 2=up/down, 3=left/right/up/down
- int pir = -1//device capability level infrared detection
- int tmpr = -1//device capability level temperature support value
- int md = -1//device capability level humidity detect support value
- int hmd = -1//device capability level human body support value
  //doorbell added
- String bellVoiceURL//recorded address of the owner's message
- boolean pirEnable//pir switch, off: 0; on: 1
- int pirLevel//pir level, 1: low; 2: medium; 3: high
- int bellVol// //doorbell volume, 0~100
- boolean batteryLock / / battery lock switch, locked: true; unlock: false
- String bellPower//doorbell power supply, battery powered: battery; wired power: wire; coexistence: both
- int batteryPercent//% of remaining battery, 0~100
- float batteryRemain// remaining usage time, accurate to 1 decimal place, in hours
- String bellStatus //doorbell charging status, charging: charging; full: charged; uncharged: discharing
- int bellPwm / / low power, this is still uncertain, late change
- int charmVol//bell volume, third gear: high, medium and low
- int charmDuration / / bell length, this is still uncertain, later change
- String bellSongs//doorbell ringtone list
- String bellSelectSong//Selected ringtones
- int nvrPort//NVR port number
- String deviceID//device id
- int trialCloud / / whether to try the cloud
- String deviceVersionID//version number
- int nvrID / / bind nvrId
- String nvrUUID//bind nvr uuid
- String nvrKey // bind nvr password
- boolean asFriend// is a friend device
- String sleep//sleep mode
- long userID / / user ID of the device
- boolean isChecked = false / / no is the selected state (4-way check button)
- String isBindingTY//isBindingTY N (unbound) ND (not expired) D (expired) Y
- String deviceType//device type
- boolean hasAlertMsg //whether the server has a message
- boolean updateVersion //whether the server has a new version
- int closePush//turn off server push
- String updatePersion //If the server has a new version, the device must be forced to upgrade.

NVRInfo extends BaseDeviceInfo (NVR information class)

- int userID; / / device also has the ID
- int addStatus;//Add status
- String tp; / / account name
- int nvrFlag; / / binding indicates 0 means cancel 1: indicates existence
- String nvrVersionID; / / nvr device version number
- String nvrTypeName; / / nvr device version number
- String nvrTypeNameGray; / / nvr device version number
- boolean updateVersion = false;

## 6.2 Device Information Acquisition
```
【description】
Towers Perrin provides a rich interface for developers to achieve device information acquisition and management capabilities (removal, etc.). Device-related return data is notified to the recipient by means of asynchronous messages.
We used the EventBus solution to implement message notification. Therefore, the notification object needs to be registered and destroyed on each device operation page. Please refer to the demo implementation for details.

[function call]

/**
 * Get a list of all devices
 *
 * @param callback network request callback
 */
MeariUser.getInstance().getDevList(IDevListCallback callback);

[code example]

MeariUser.getInstance().getDevList(new IDevListCallback() {
    @Override
    Public void onSuccess(MeariDevice dev) {

    }

    @Override
    Public void onError(String code, String error) {

    }
});
```

## 6.3 Device Removal
```
【description】
    Device removal

[function call]

Devtype - 0-nvr 1-ipc 2-bell (can be customized)
/**
 * Remove device
 *
 * @param devId device id
 * @param deviceType device type
 * @param callback callback
 */
Public void removeDevice(String devId, int deviceType, IResultCallback callback);

[code example]

MeariUser.getInstance().removeDevice(cameraInfo.getDeviceID(), DeviceType.IPC, new IResultCallback()(
    @Override
    Public void onSuccess() {

    }

    @Override
    Public void onError(String code, String error) {

    }
));
```

## 6.4 Device nickname modification
```
【description】
Modify device nickname modification

[function call]

/**
 * Modify device nickname
 *
 * @param deviceId device id
 * @param deviceType device type
 * @param nickname device nickname
 * @param callback callback
 */
Public void renameDeviceNickname(String deviceId, int deviceType, String nickname, IResultCallback callback);

[code example]

MeariUser.getInstance().renameDeviceNickName(cameraInfo.getDeviceID(), DeviceType.IPC, nickName, new IRemoveDeviceCallback()(
    @Override
    Public void onSuccess() {

    }

    @Override
    Public void onError(String code, String error) {

    }
));
```

## 6.5 NVR Binding Device
```
【description】
NVR binding device

[function call]

/ / Bind the device
MeariUser.getInstance().bindDevice(int devid, int nvrid, IRemoveDeviceCallback callback);
/ / Unbundling equipment
MeariUser.getInstance().unbindDevice(int nvrid,,List<int>devid,IunBindDeviceCallback callback);
/ / Query the list of bound devices
MeariUser.getInstance().getBindDeviceList(int nvrid,,IGetBindDeviceList callback);

[code example]

/ / Bind the device
MeariUser.getInstance().bindDevice(devid,nvrid,new IRemoveDeviceCallback(){
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(String code, String error) {
    }
});
/ / Unbundling equipment
MeariUser.getInstance().unbindDevice(nvrid,,List<int>devid,new IunBindDeviceCallback(){
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(String code, String error) {
    }
});
/ / Query the list of bound devices
MeariUser.getInstance().getBindDeviceList(nvrid,new IGetBindDeviceList(){
    @Override
    Public void onSuccess(List<MeariDeviceStatusInfo> list) {
    }

    @Override
    Public void onError(String code, String error) {
    }
});
```

## 6.6 Single device one day alarm time point acquisition
```
【description】
Single device one day alarm time point acquisition

[function call]
/**
 * Single device one day alarm time point acquisition
 *
 * @param deviceID device id
 * @param dayTime day time (format YYMMDD)
 * @param callback callback
 */
MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(int devid,String date,IDeviceAlarmMessageTimeCallback callback);

[code example]

MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(devid,date,new IDeviceAlarmMessageTimeCallback()(
    @Override
    Public void onSuccess(List<AlarmMessageTime> list) {
    }

    @Override
    Public void onError(String code, String error) {
    }
));
```

Class AlarmMessageTime:

-int StartHour;//Start time: hour
-int StartMinute;//Start time: minute
-int StartSecond;//Start time: seconds
-int EndHour;//End time: hour
-int EndMinute;//End time: minute
-int EndSecond;//End time: seconds
-int bHasVideo;//has no video
-int recordType;//doorbell adds time point type, in order to facilitate future expansion defined as int type
-int TYPE_PIR = 0x1001; // PIR alarm type time point
-int TYPE_MOVE = 0x1002;//Motion detection alarm type time point
-int TYPE_VISIT = 0x1003; / / visitor alarm type time point


## 6.7 Check if the device has a new version
```
【description】
Check if the device has a new version

[function call]

/**
 * Check if the device has a new version
 *
 * @param devVersion device version
 * @param lanType Language type
 * @param callback callback
 */
Public void checkNewFirmwareForDev(String devVersion, String lanType, ICheckNewFirmwareForDevCallback callback);

[code example]
MeariUser.getInstance().checkNewFirmwareForDev(firmware_version, "zh", new ICheckNewFirmwareForDevCallback() {
    @Override
    Public void onSuccess(DeviceUpgradeInfo info) {
        mDeviceUpgradeInfo = info;
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

DeviceUpgradeInfo:

- String updatePersion;//Do you need a device forced upgrade?
- int updateStatus;//Can the device be upgraded?
- String serVersion ;//server version
- String versionDesc;//Upgrade description
- String devUrl; / / new firmware address

```
Contains the upgraded address, etc.
```

## 6.8 Querying Device Online Status
```
【description】
    Check if the device has a new version

[function call]
/*
 * Query whether the device is online
 *
 * @param deviceId device ID
 * @param callback callback
 *
 */
MeariUser.getInstance().checkDeviceOnline(String devid,ICheckDeviceOnlineCallback callback);

[code example]
MeariUser.getInstance().checkDeviceOnline(info.getDeviceID(), new ICheckDeviceOnlineCallback() {
    @Override
    Public void onSuccess(String deviceId, boolean online) {
        mAdapter.changeDeviceStatus(deviceId,online);
    }
    @Override
    Public void onError(int code, String error) {
        mAdapter.changeStatusByUuid(info.getDeviceID(), -27);
    }
});
```

## 6.9 Querying the music list
```
【description】
    Query music list

[function call]

 /**
 * Query music list
 *
 * @param callback callback
 */
MeariUser.getInstance().getMusicList(new IGetMusicListCallback());

[code example]

MeariUser.getInstance().getMusicList(new IGetMusicListCallback()(
    @Override
    Public void onSuccess(List<MeariMusic> list) {
    }

    @Override
    Public void onError(String code, String error) {
    }
));
```
MeariMusicList:

- String musicID; //id
- int download_percent;//Download progress
- boolean is_playing; / / is playing
- String musicName;//music name
- String musicFormat;//music format
- String musicUrl;//Music address


## 6.10 Remote wake-up doorbell
```
【description】
Remote wake-up doorbell
Note: For doorbell-type low-power products, you need to wake up remotely and then call the hole-punching interface (may need to punch holes multiple times)

[function call]
/**
 * Remote wake-up doorbell
 *
 * @param deviceId deviceId
 * @param callback callback
 */
Public void remoteWakeUp(String deviceId, IResultCallback callback);

[code example]
MeariUser.getInstance().remoteWakeUp(mCameraInfo.getDeviceID(), new IResultCallback() {
    @Override
    Public void onSuccess() {

    }
    @Override
    Public void onError(int code, String error) {

    }
});
```
## 6.11 Sharing equipment

【description】
Share your device with others

```
[function call]

/**
 * Request sharing device
 *
 * @param cameraInfo device information object
 * @param callback callback
 */
Public void requestDeviceShare(BaseDeviceInfo deviceInfo, IRequestDeviceShareCallback callback);

[code example]

MeariUser.getInstance().requestDeviceShare(cameraInfo, new IRequestDeviceShareCallback() {
    @Override
    Public void onSuccess(String sn) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```


# 7. Sharing device

## 7.1 Related Class Introduction

MeariFriend Friends
- String nickName; Nickname
- String accountName; account number
- String userFriendID; buddy id
- String imageUrl; Friend avatar

ShareFriendInfo Friends information shared by a device
- String nickName;
- String imageUrl; Friend avatar
- String userId; buddy id
- boolean share; whether it has been shared
- String userAccount; friend account

MeariSharedDevice shared device information for a friend

- long deviceID; device id
- String deviceName; device name
- String deviceUUID; device unique identifier
- boolean isShared; whether it has been shared
- String snNum; device sn

## 7.1 Friend Management

### 7.1.1 Get a buddy list
```
【description】
Get a list of friends
    
[function call]
/**
 * Get a list of friends
 *
 * @param callback returns callback
 */
Public void getFriendList(IGetFriendCallback callback);

[code example]

MeariUser.getInstance().getFriendList(new IGetFriendCallback() {
    @Override
    public void onSuccess(List<MeariFriend> friends) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 7.1.2 Adding a friend
```
【description】
Request to add a friend

[function call]

/**
 * Request to add a friend
 *
 * @param callback callback
 */
Public void addFriend(String userAccount, IResultCallback callback);

[code example]

MeariUser.getInstance().addFriend(userAccount, new IResultCallback() {
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 7.1.3 Deleting friends
```
【description】
Delete single or multiple friends

[function call]

/**
 * delete friend
 *
 * @param userIds buddy id, format: ["xxxxxxxx","xxxxxxxx"]
 * @param callback callback
 */
Public void deleteFriend(String userIds, IResultCallback callback);

[code example]

MeariUser.getInstance().deleteFriend(userIds, new IResultCallback() {
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(int code, String error) {

    }
});
```

### 7.1.4 Modify friend nickname
```
【description】
Modify a friend's name

[function call]

/**
 * Modify your friend's name
 *
 * @param friendId buddy ID
 * @param nickname buddy tag
 * @param callback returns callback
 */
Public void renameFriendMark(String friendId, String nickname, IResultCallback callback);

[code example]

MeariUser.getInstance().renameFriendMark(meariFriend.getUserFriendID(), nickname, new IResultCallback() {
    @Override
    Public void onSuccess(){
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```
## 7.2 Query sharing

### 7.2.1 Querying the list of friends shared by a single device
```
【description】
Query the list of friends shared by a single device

[function call]

/**
 * Query the list of friends that a single device is shared with
 *
 * @param deviceType device type
 * @param deviceId device id
 * @param callback network request callback callback
 */
Public void queryFriendListForDevice(int deviceType, String deviceId, IQueryFriendListForDeviceCallback callback) ;

[Method call]

MeariUser.getInstance().queryFriendListForDevice(DeviceType.IPC, cameraInfo.getDeviceID(), new IQueryFriendListForDeviceCallback() {
    @Override
    Public void onSuccess(ArrayList<ShareFriendInfo> shareFriendInfos) {
    }
    @Override
    Public void onError(int code, String error) {
    }
});
```

### 7.2.2 Querying the list of devices shared with a friend
```
【description】
Query the list of devices shared with a friend

[function call]
    
/**
 * Query the list of devices shared with a friend
 *
 * @param devType device type 0-nvr 1-ipc 2-bell
 * @param userId share user ID
 */
Public void queryDeviceListForFriend(int devType, String userId, IQueryDeviceListForFriendCallback callback);

[Method call]

MeariUser.getInstance().queryDeviceListForFriend(DeviceType.DEVICE_IPC, meariFriend.getUserFriendID(), new IQueryDeviceListForFriendCallback() {
    @Override
    Public void onSuccess(List<MeariSharedDevice> list) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 7.3 Adding Share
### 7.3.1 Adding a single device share
```
【description】
Share a single device to a given user

[function call]

/**
 * Share a single device to a specified user
 *
 * @param devType device type 0-nvr 1-ipc 2-bell
 * @param userId share user ID
 * @param devUuid device identifier
 * @param callback returns callback
 */
Public void addShareUserForDev(int devType, String userId, String devUuid, String devId, IShareForDevCallback callback);

[Method call]

MeariUser.getInstance().addShareUserForDev(DeviceType.IPC, meariFriend.getUserFriendID(), shareFriendInfo.getDeviceUUID(), shareFriendInfo.getDeviceID(), new IShareForDevCallback() {
    @Override
    Public void onSuccess(String userId, String devId) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 7.3.2 Cancel individual device sharing
```
【description】
Cancel individual device sharing

[function call]
/**
 * Unshare device to friend
 *
 * @param devType device type 0-nvr 1-ipc 2-bell
 * @param userId share user ID
 * @param devUuid device identifier
 * @param devId device id
 * @param callback returns callback
 */
Public void removeShareUserForDev(int devType, String userId, String devUuid, String devId, IShareForDevCallback callback) ;

[Method call]
MeariUser.getInstance().removeShareUserForDev(DeviceType.IPC, shareFriendInfo.getUserId(), cameraInfo.getDeviceID(), cameraInfo.getDeviceUUID(), new IShareForDevCallback() {
    @Override
    Public void onSuccess(String userId, String devId) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});

```

### 7.3.3 Request to share a device
```
【description】
Request to share a device

[function call]

/**
 * Request to share a device
 *
 * @param cameraInfo device
 * @param callback callback
 */
Public void requestDeviceShare(BaseDeviceInfo cameraInfo, IRequestDeviceShareCallback callback);

[Method call]

MeariUser.getInstance().requestDeviceShare(info, new IRequestDeviceShareCallback() {
    @Override
    Public void onError(int code, String error) {
    }

    @Override
    Public void onSuccess(String sn) {
    }
});
```


# 8.Message Center
## 8.1 Get all devices have messages
```
【description】
Get all devices have messages

[function call]
/**
 * Get a list of messages
 *
 * @param callback callback
 */
Public void getAlarmMessageStatusForDev(IGetAlarmMessageStatusForDevCallback callback);

[Method call]
MeariUser.getInstance().getAlarmMessageStatusForDev(new IGetAlarmMessageStatusForDevCallback() {
    @Override
    Public void onError(int code, String error) {
        mPullToRefreshRecyclerView.onRefreshComplete();
        CommonUtils.showToast(error);
    }

    @Override
    Public void onSuccess(List<DeviceMessageStatusInfo> deviceMessageStatus) {
        bindOrderList(deviceMessageStatus);
    }
});
 
```
Class DeviceMessageStatus:

- long deviceID //device ID
- String deviceName //Device name
- String deviceUUID // device unique identifier
- String hasMessgFlag //"Y" indicates that there is an unread message "N" indicates no unread message
- boolean bHasMsg //Do you have a message?
- int delMsgFlag //0 means unedited state, 1 means editing unit selection 2 means selection
- boolean bSysmsg // Is it a system message?
- String snNum // Is it a system message?
- String url // Is it a system message?
- String userAccount // Is it a system message?



## 8.2 Getting System Messages
```
【description】
    Get system messages

[function call]
    /**
     * Get system messages
     *
     * @param callback callback
     */
    Public void getSystemMessage(IGetSystemMessageCallback callback);

[Method call]
    MeariUser.getInstance().getSystemMessage(new IGetSystemMessageCallback() {
        @Override
        Public void onError(int code, String error) {
            mPullToRefreshListView.onRefreshComplete();
            bindError(error);
            CommonUtils.showToast(error);
        }

        @Override
        Public void onSuccess(List<SystemMessageInfo> systemMessages) {
            bindList(systemMessages);
            mPullToRefreshListView.onRefreshComplete();
        }
        });
```
Class SystemMessage:

- long msgID; //MessageId
- int msgTypeID; / / message type
- String isRead; / / Is it read?
- Date createDate; / / create time time
- Date updateDate; / / update time
- long userID; / / user ID
- String userAccount; / / user account
- String nickName;//user name
- String delState; / / whether to deal with
- long deviceID; / / device Id
- String deviceName; / / device name
- String deviceUUID; / / device identifier
- long userIDS; / / requester Id
- String imageUrl;//avatar


## 8.3 Get a device alarm message
```
【description】
    Get a device alarm message

[function call]
    /**
      * refuse friend share device
      *
      * @param deviceId deviceId
      * @param callback callback
      */
    Public void getAlarmMessagesForDev(long deviceId, IGetAlarmMessagesCallback callback);

[Method call]
    MeariUser.getInstance().getAlarmMessagesForDev(this.mMsgInfo.getDeviceID(), new IGetAlarmMessagesCallback() {

        @Override
        Public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo, boolean isDelete) {
            mPullToRefreshListView.onRefreshComplete();
            bindList(deviceAlarmMessages);
            mCameraInfo = cameraInfo;
            deviceStatus = isDelete;
        }

        @Override
        Public void onError(int code, String error) {
            CommonUtils.showToast(error);
            bindError(error);
        }
    });;
 【Precautions】
    If the message is pulled by the owner, the server will not save the message, and the shared friends will not see the message.
```

Class DeviceAlarmMessage:
- long deviceID; / / device ID
- String deviceUuid; / / device unique identifier
- String imgUrl;// Alarm picture address
- int imageAlertType; / / alarm type (PIR and Motion)
- int msgTypeID; / / message type
- long userID; / / user ID
- long userIDS;
- String createDate; / / wear time
- String isRead; / / Is it read?
- String tumbnailPic;//thumbnail
- String decibel; / / decibel
- long msgID; / / message Id


## 8.3 Batch delete system messages
```
【description】

    Batch delete system messages

[function call]
    /**
     * Delete system messages in batches
     *
     * @param callback callback
     * @param msgIds Message Ids
     */
    Public void deleteSystemMessage(List<Long> msgIds, final IResultCallback callback);

[Method call]
    MeariUser.getInstance().deleteSystemMessage(selectDeleteMsgIds, new IResultCallback() {
        @Override
        Public void onSuccess() {
            stopProgressDialog();
            }
        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
            }
        });

```

## 8.4 Batch Delete Multiple Device Alarm Messages
```
【description】
    Delete multiple device alarm messages in bulk

[function call]
     /**
     * Delete multiple device alarm messages in batches
     *
     * @param callback callback
     * @param deviceInfos Device Id
     */
    Public void deleteDevicesAlarmMessage(ArrayList<Long> deviceInfos, IResultCallback callback) ;

[Method call]
    MeariUser.getInstance().deleteDevicesAlarmMessage(deviceInfos, new IResultCallback() {
        @Override
        Public void onSuccess() {
            stopProgressDialog();
            deleteCallback();
        }
        @Override
        Public void onError(int code, String error) {
        stopProgressDialog();
        CommonUtils.showToast(error);
        }
    });
```

## 8.5 Marking a single device message has been read
```
【description】
    Mark a single device message all read

[function call]
    Void MarkDevicesAlarmMessage(int devid, IMarkDevicesAlarmMessageCallback callback);

[Method call]
    MeariUser.getInstance().MarkDevicesAlarmMessage(
        Devid, new IMarkDevicesAlarmMessageCallback() {
            @Override
            Public void onSuccess() {
                
            }

            @Override
            Public void onError(String errorCode, String errorMessage) {

            }
    });
```

## 8.6 Friend Message Processing
```
【description】
    Friend message processing - consent | rejection

[function call]
    /**
     * Agree to add friends
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param callback callback
     */
    Public void agreeFriend(long msgId, long friendId, IDealSystemCallback callback) ;

    /**
     * Refuse to add friends
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param callback callback
     */
    Public void refuseFriend(long msgId, long friendId, IDealSystemCallback callback);

[Method call]
   MeariUser.getInstance().agreeFriend(msgInfo.getMsgID(), msgInfo.getUserID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });

    MeariUser.getInstance().refuseFriend(msgInfo.getMsgID(), msgInfo.getUserID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });;
【Precautions】
    If the message is processed, you need to manually delete the message.
```

## 8.6 Device Message Processing
```
【description】
    Device Message Processing - Agree | Reject

[function call]
    /**
     * Agree to share the device
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param deviceId deviceId
     * @param callback callback
     */
    Public void agreeShareDevice(long msgId, long friendId, long deviceId, IDealSystemCallback callback);

    /**
     * Refuse to share device
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param deviceId deviceId
     * @param callback callback
     */
    Public void refuseShareDevice(long msgId, long friendId, long deviceId, IDealSystemCallback callback);

[Method call]
    MeariUser.getInstance().agreeShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });

    MeariUser.getInstance().refuseShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
            }
    });

【Precautions】
    If the message is processed, you need to manually delete the message.
```

# 9. Camera parameter settings
Used to set the camera's detection alarm, sleep mode, local playback and so on.
Whether different devices support a certain setting can be judged by the device's capability set.

If (cameraInfo.getLed() == 1) {
    / / Support switch settings such as LED
} else {
    // does not support switch settings such as LEDs
}

Equipment capability set

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



## 9.1 P2P Setting Parameters
Set the parameters of the camera by punching holes in P2P. For specific usage, refer to the use of CameraPlayer in demo.

## 9.2 Iot setting parameters
Get and set camera parameters via Iothub.
How to use the reference to the use of CameraSettingIotActivity in the demo

### 9.2.1 Iot settings related classes

Device attribute class obtained by IotPropertyInfo Iot
- String userId; User ID
- String deviceTimeZone; device time zone
- String deviceKey; device key
- String capability; device capability level
- String snNum; SN number
- String firmwareCode; Firmware code ppstrong-c2-neutral-1.0.0.20190617
- String firmwareVersion; Firmware version number 1.0.0
- String cloudRecordType; Cloud service recording type: 0-event recording; 1-all-day recording;
- String cloudSaveCycle; cloud service storage cycle
- String cloudExpireDate; cloud service expiration time
- int cloudUploadEnable; cloud storage upload switch: 0-off; 1-open;
- String wifiName; WiFi name of the device connection
- int wifiStrength; WiFi strength of device connection: 0 to 100;
- int rotateEnable; Video flip: 0-normal; 1-turn;
- int ledEnable; LED indicator status: 0-off; 1-on;
- int sdRecordType; SD card recording type: 0-event recording; 1-all day video;
- int sdRecordDuration; SD card recording time: 0-1 minutes; 1-2 minutes; 2-3 minutes;
- int motionDetEnable; Motion detection enable switch: 0-off; 1-on;
- int motionDetSensitivity; Motion detection sensitivity: 0-low; 1-in; 2-high;
- int humanDetEnable; humanoid detection enable switch: 0-off; 1-open;
- int humanFrameEnable; Humanoid frame enable switch: 0-off; 1-open;
- int humanTrackEnable; Humanoid tracking enable switch: 0-off; 1-open;
- int soundDetEnable; audible alarm enable switch: 0-off; 1-open;
- int soundDetSensitivity; audible alarm sensitivity: 0-low; 1-in; 2-high;
- int cryDetEnable; Cry detection enable switch: 0-off; 1-on;
- int dayNightMode; day and night mode: 0-automatic; 1-day mode; 2-night mode;
- int sdStatus; SD card status:
- String sdCapacity; total SD card capacity
- String sdRemainingCapacity; SD card remaining capacity
- int sleepMode; sleep mode: 0 - no sleep; 1 - sleep; 2 - timed sleep; 3 - geofence sleep;
- String sleepTime; time period for timed sleep
- String sleepWifi; WiFi for geofencing sleep
- int onvifEnable; Onvif enable switch: 0-off; 1-on;
- String onvifPwd; Onvif password
- String onvifUrl; Onvif service network address
- int h265Enable; H265 enable switch: 0-H264; 1-H265
- String ip; device IP address
- int NetMode; device network mode: 0-wireless; 1-wired
- int OTAUpgradeStatus; OTA upgrade status: 0 - not upgraded; 1 - upgrade; 2 - upgrade completed to be restarted;
- int OTAUpgradeDownload; OTA upgrade Download progress: -1 to 100
- int OTAUpgradeUpdate; OTA upgrade Upgrade progress: -1 to 100
- int OTAUpgradeTotal; OTA upgrade Total progress: -1~100
- int temperature; temperature
- int humidity; humidity
- int flightSwitchStatus; luminaire camera headlight switch: 0-off; 1-open;

IotConstants Iot related attribute characters
Device property constant, used when refreshing properties, corresponding to the properties of IotPropertyInfo.

### 9.2.2 Get all attribute parameters of the device
```
【description】
Get all the attribute parameters of the device

[function call]

/**
 * Get all the parameters of the device
 *
 * @param snNum device's sn number
 * @param tag request tag
 * @param callback request callback
 */
Public void getIotProperty(String snNum, Object tag, IPropertyCallback callback);

[code example]

MeariUser.getInstance().getIotProperty(cameraInfo.getSnNum(),this, new IPropertyCallback() {
    @Override
    Public void onSuccess(IotPropertyInfo iotPropertyInfo) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.3 Refreshing device properties
```
【description】
Refresh the device properties, select the properties that need to be refreshed, call the refresh interface, and the device returns the latest property values ​​through the mqtt message.

[function call]

/**
 * Refresh device properties
 *
 * @param snNum device's sn number
 * @param timeList 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void refreshProperty(String snNum, List<String> propertyList, Object tag, IStringResultCallback callback);

[code example]

ArrayList<String> arrayList = new ArrayList<>();
arrayList.add(IotConstants.sdCapacity);
arrayList.add(IotConstants.sdRemainingCapacity);

MeariUser.getInstance().refreshProperty(cameraInfo.getSnNum(), arrayList, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.4 Device upload cloud recording settings
```
【description】
Device upload cloud recording settings

[function call]

/**
 * Device upload cloud recording settings
 *
 * @param snNum device's sn number
 * @param enable 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setCloudUploadEnable(String snNum, int enable, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setCloudUploadEnable(cameraInfo.getSnNum(), enable, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.5 Equipment LED light switch control
```
【description】
Equipment LED light switch control

[function call]

/**
 * Equipment LED light switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setLedEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setLedEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.6 Device Preview Video Flip Control
```
【description】
Device preview video flip control

[function call]

/**
 * Device preview video flip control
 *
 * @param snNum device's sn number
 * @param status 0-normal; 1-turn;
 * @param tag request tag
 * @param callback request callback
 */
Public void setRotateEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setRotateEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.7 Device motion detection switch control
```
【description】
Device motion detection switch control

[function call]

/**
 * Device motion detection switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setMotionDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setMotionDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.8 Device motion detection sensitivity setting
```
【description】
Device motion detection sensitivity setting

[function call]

/**
 * Device motion detection sensitivity setting
 *
 * @param snNum device's sn number
 * @param sensitivity 0-low; 1-in; 2-high;
 * @param tag request tag
 * @param callback request callback
 */
Public void setMotionDetSensitivity(String snNum, int sensitivity, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setMotionDetSensitivity(cameraInfo.getSnNum(), sensitivity, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.9 Device noise detection switch control
```
【description】
Device noise detection switch control

[function call]

/**
 * Equipment noise detection switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setSoundDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSoundDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.10 Device Noise Detection Sensitivity Control
```
【description】
Device noise detection sensitivity control

[function call]

/**
 * Equipment noise detection sensitivity control
 *
 * @param snNum device's sn number
 * @param sensitivity 0-low; 1-in; 2-high;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSoundDetSensitivity(String snNum, int sensitivity, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSoundDetSensitivity(cameraInfo.getSnNum(), sensitivity, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.11 Device Local Recording Type Setting
```
【description】
Device local recording type setting

[function call]

/**
 * Device local recording type setting
 *
 * @param snNum device's sn number
 * @param type 0- event recording; 1-all day video;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSdRecordType(String snNum, int type, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSdRecordType(cameraInfo.getSnNum(),type, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.12 Device local recording event video clip time setting
```
【description】
Device local recording event video clip time setting

[function call]

/**
 * Device local recording event video clip time setting
 *
 * @param snNum device's sn number
 * @param duration 0-1 minutes; 1-2 minutes; 2-3 minutes;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSdRecordDuration(String snNum, int duration, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSdRecordDuration(cameraInfo.getSnNum(), duration, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.13 Equipment day and night mode setting
```
【description】
Device day and night mode setting

[function call]

/**
 * Equipment day and night mode setting
 *
 * @param snNum device's sn number
 * @param status 0-automatic; 1-day mode; 2-night mode;
 * @param tag request tag
 * @param callback request callback
 */
Public void setDayNightMode(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setDayNightMode(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.14 Device Video Encoding Format Settings
```
【description】
Device video encoding format setting

[function call]

/**
 * Device video encoding format setting
 *
 * @param snNum device's sn number
 * @param status 0-H264; 1-H265
 * @param tag request tag
 * @param callback request callback
 */
Public void setH265Enable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setH265Enable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.15 Device Onvif Switch Control
```
【description】
Device Onvif Switch Control

[function call]

/**
 * Device Onvif switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setOnvifEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setOnvifEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.16 Device Onvif Password Settings
```
【description】
Device Onvif password settings

[function call]

/**
 * Device Onvif password settings
 *
 * @param snNum device's sn number
 * @param pwd Onvif password
 * @param tag request tag
 * @param callback request callback
 */
Public void setOnvifPwd(String snNum, String pwd, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setOnvifPwd(cameraInfo.getSnNum(), pwd, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.17 Device Format SD Card
```
【description】
The device formats the SD card. After the format is successful, the format progress is obtained through the mqtt message.

[function call]

/**
 * Device format SD card
 *
 * @param snNum device's sn number
 * @param tag request tag
 * @param callback request callback
 */
Public void formatSdcard(String snNum, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().formatSdcard(cameraInfo.getSnNum(), this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.18 Device upgrade firmware
```
【description】
Call checkNewFirmwareForDev() to detect whether the device has new firmware to update. After the firmware is successfully upgraded, the upgrade progress is obtained through the mqtt message.

[function call]

/**
 * Device upgrade firmware
 *
 * @param snNum device's sn number
 * @param OTAUpgradeInfo 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void upgradeFirmware(String snNum, String OTAUpgradeInfo, Object tag, IStringResultCallback callback);

[code example]

JSONObject object = new JSONObject();
Object.put("url",deviceUpgradeInfo.getDevUrl());
Object.put("version",deviceUpgradeInfo.getSerVersion() + "-upgrade.bin");

MeariUser.getInstance().upgradeFirmware(cameraInfo.getSnNum(), object.toString(), this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.19 Equipment humanoid tracking switch control
```
【description】
Equipment humanoid tracking switch control

[function call]

/**
 * Equipment humanoid tracking switch control
 *
 * @param snNum device's sn number
 * @param OTAUpgradeInfo 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setHumanTrackEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setHumanTrackEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.20 Equipment humanoid detection alarm switch control
```
【description】
Equipment humanoid detection alarm switch control

[function call]

/**
 * Equipment humanoid detection alarm switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setHumanDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setHumanDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.21 Equipment Humanoid Frame Switch Control
```
【description】
Equipment humanoid frame switch control

[function call]

/**
 * Equipment humanoid frame switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setHumanFrameEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setHumanFrameEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.22 Equipment crying alarm switch control
```
【description】
Equipment crying alarm switch control

[function call]

/**
 * Equipment crying alarm switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setCryDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setCryDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.23 Device Sleep Mode Settings
```
【description】
Device sleep mode setting

[function call]

/**
 * Device sleep mode setting
 *
 * @param snNum device's sn number
 * @param mode 0- no sleep; 1-sleep; 2-timed sleep; 3-geo-fence sleep;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSleepMode(String snNum, int mode, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSleepMode(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```
### 9.2.24 Device Timing Sleep Time Period Setting
```
【description】
Device timed sleep period setting

[function call]

/**
 * Device timed sleep period setting
 *
 * @param snNum device's sn number
 * @param timeList sleep time period list
 * @param tag request tag
 * @param callback request callback
 */
Public void setSleepTimeList(String snNum, String timeList, Object tag, IStringResultCallback callback);

[code example]

timeList description:
Enable: whether to enable
Start_time: start time point
Stop_time: end time point
Repeat: The number of days that take effect every week 1~7

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

MeariUser.getInstance().setSleepTimeList(cameraInfo.getSnNum(), timeList, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.25 Device start rotation command
```
【description】
Device start rotation command

[function call]

/**
 * The device starts to rotate
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
<h1><center> directory </center></h1>
[TOC]

<center>
---
Version number | Development team | Update date | Notes
:-:|:-:|:-:|:-:
2.0.0 | Towers Perrin Technical Team | 2019.09.20 | Optimization

</center>

# 1. Function Overview

The Towers Technology APP SDK provides interface packaging with hardware devices and Towers Perrin, and accelerates the application development process, including the following functions:

- Hardware device related (with network, control, status reporting, firmware upgrade, preview playback, etc.)
- Account system (mobile phone number, email registration, login, password reset, etc.)
- Device sharing
- Friends management
- Message Center
- Feedback
- Meari cloud HTTPS API interface package (see Meari cloud api call)

--------------

# 2. Integration preparation
## Create App ID and App Secert
```
Towers Perrin Technology Cloud Platform provides webpages to automatically create App ID and App Secert for user SDK development, configuration in AndroidManifest
<meta-data
    Android:name="MEARI_APPKEY"
    Android:value="your MEARI_APPKEY" />
<meta-data
    Android:name="MEARI_SECRET"
    Android:value="your MEARI_SECRET" />
```

```

### 9.2.26 Device stop rotation command
```
【description】
Device stop rotation command

[function call]

/**
 * Device stop rotation command
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

# 10. Integrated Push (temporarily only supports Aurora)
```
Based on the app developed by Meari SDK, Meari platform supports Push function, which supports users to push device alarms, doorbell calls and other messages.
```
## 10.1 Integrated Aurora
The Push function is based on Aurora Push, and the official document is used to access Aurora.
Contact us to configure the aurora's key and secret.

## 10.2 Setting User Aliases
Get UserInfo after logging in to meari successfully.
After initializing the aurora, use the userInfo.getJpushAlias() successfully obtained by login to set the aurora alias.
Initialize and set the alias reference to the official documentation or the MeariSDK demo

## 10.3 Push Message
Refer to the handling of messages in the MyReceiver file in the demo.

--------------

# 3. Integrated SDK
## 3.1 Integration Process
### 3.1.1 Introducing the sdk package
```
Copy meatisdk_2.0.0.aar to the libs directory and copy the so files from the demo to the libs directory.
The so file is introduced according to the full or partial type of the needs of the project.
```

### 3.1.2 Configuring build.gradle

Add the following configuration to the build.gradle file.
```
Repositories {
    flatDir {
        Dirs 'libs'
    }
}
Android {
     sourceSets {
        Main {
            jniLibs.srcDirs = ['libs']
        }
    }
}
Dependencies {
    Implementation(name: 'mearisdk-1.0.0', ext: 'aar')
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

Aurora push configuration
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
 * @param callback mqtt message callback
 */
MeariSdk.init(Contex context, IMessageCallback callback);

[code example]

Public class MeariMessage implements IMessageCallback {
    @Override
    Public void messageArrived( String message) {
        // Process mqtt message
    }
}

Public class MeariSmartApp extends Application {
    @Override
    Public void onCreate() {
        super.onCreate();
        // Initialize
        MeariSdk.init(this, new MeariMessage());
        // output log
        MeariSdk.getInstance().setDebug(true);
    }
}
```
# 4. User Management (MeariUser Tools)
```
Towers Perrin provides mobile phone/email password login, uid login, password reset, etc.
After registration or login is successful, use the return information to connect to the mqtt service, initialize the aurora and other operations.
(Hint: Object tag parameter in the function, you can pass this, the following is true)
```

UserInfo class
- jpushAlias ​​Aurora Push Alias
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


## 4.1 Mobile/Email Password Registration
```
【description】
Phone password registration. Currently only supports domestic mobile phone registration.

[function call]
    
/**
 * Get phone verification code
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param account
 * @param tag Network request tag (Hint: Object tag parameter in the function, you can pass this, the following is the same, no longer listed)
 * @paramI ValidateCallback network request return
 */
Public void getValidateCode(String countryCode, String phoneCode, String account, Object tag, final IValidateCallback callback);
  
/**
 * register account
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param account
 * @param pwd password
 * @param nickname nickname
 * @param code verification code
 * @param callback returns callback
 */
Public void registerAccount2(String countryCode, String phoneCode, String account, String pwd, String nickname, String code, IRegisterCallback callback);

[code example]

MeariUser.getInstance().getValidateCode(countryCode, phoneCode, account, this, new IValidateCallback() {
    @Override
    Public void onSuccess(int leftTime) {
        stopProgressDialog();
        startTimeCount(leftTime);//leftTime indicates the remaining valid time of the verification code
    }

    @Override
    Public void onError(int code, String error) {
        stopProgressDialog();
        CommonUtils.showToast(error);
    }
});

MeariUser.getInstance().registerAccount2(countryCode,phoneCode,account,pwd,nickname,code, new IRegisterCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        //UserInfo returns user information
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 4.2 Mobile/Email Password Login
```
【description】
Support domestic mobile phone password login.
 
[function call]

/**
 * Login account
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param userAccount Domestic Phone/Email
 * @param password user password
 * @param callback login callback interface return user information
 */
Public void login2(String countryCode, String phoneCode, String userAccount, String password, ILoginCallback callback);
    
[code example]

MeariUser.getInstance().login2(countryCode,phoneCode, userAccount, password, new ILoginCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        // It is recommended to initialize Aurora and connect mqtt service in MainActivity. After logging in for the first time, save the user information, you don't have to log in every time you start the app.
        / / If you need to receive push messages, contact us to configure the relevant parameters, use our alias to initialize the Aurora push, access process reference Aurora official documentation.
        initJPushAlias(user.getJpushAlias());
        // connect to the mqtt service
        MeariUser.getInstance().connectMqttServer(getApplication());
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 4.3 Reset password
```
【description】
Only passwords for mailbox and / domestic mobile phones are supported.
 
[function call]
/**
 * Get phone verification code
 *
 * @param countryCode country code
 * @param username Mobile number/email
 */
MeariUser.getInstance().getValidateCode(String countryCode, String username, final IValidateCallback callback);

/**
 * reset Password
 *
 * @param countryCode country code
 * @param phoneCode country phone number area code
 * @param account Domestic Phone/Email
 * @param verificationCode verification code
 * @param password User new password password
 * @param callback login callback interface return user information
 */
Public void resetAccountPassword2(String countryCode, String phoneCode, String account, String verificationCode, String pwd, final IResetPasswordCallback callback)
    
[code example]

MeariUser.getInstance().resetAccountPassword2(countryCode, phoneCode, account, verificationCode, pwd, new IResetPasswordCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        If(user == null) {
/ / means reset password
}else {
/ / Indicates the password is retrieved
}
    }

    @Override
    Public void onError(int code, String error) {
        stopProgressDialog();
    }
});
```

## 4.4 uid user system

```
【description】
If the customer has their own user system, they can log in via uid and access our sdk.
User uid login, uid requires unique, defined by the access side. The uid system can log in directly without registration.

[function call]

/**
 * User uid registration
 * @param countryCode country number (CN)
 * @param phoneCode country phone number area code (+86)
 * @param uid user unique identifier
 * @param callback uid registration callback interface
 */
Public void loginWithUid2(String countryCode, String phoneCode, String uid, final ILoginCallback callback);
        
[code example]

MeariUser.getInstance().loginWithUid2(countryCode, phoneCode,uid, new IRegisterCallback() {
    @Override
    Public void onSuccess(UserInfo user) {
        // It is recommended to initialize Aurora and connect mqtt service in MainActivity. After logging in for the first time, save the user information, you don't have to log in every time you start the app.
        // If you need to receive push messages, contact us to configure the relevant parameters, use our alias to initialize the Aurora push, access process reference Aurora official documentation.
        initJPushAlias(user.getJpushAlias());
        // connect to the mqtt service
        MeariUser.getInstance().connectMqttServer(getApplication());
    }
    @Override
    Public void onError(String code, String error) {
        // failed
    }
});
```

## 4.5 Logout
```
【description】
Call the following interface to log out when you exit the application or log out.

[function call]
/**
 * @param callback logout callback
 */
MeariUser.getInstance().logout(ILogoutCallback callback);

[code example]
MeariUser.getInstance().logout(new ILogoutCallback() {
    @Override
    Public void onSuccess(int resultCode) {
        // Clear user information, disconnect mqtt connection, etc.
        MqttMangerUtils.getInstance().disConnectService();
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 4.6 Uploading User Avatar (MeariUser Tool Class)
```
【description】
Upload a user avatar.
 
[function call]

/**
 * Upload user avatar
 *
 * @param file User avatar image file path (preferably 300*300)
 * @param callback callback
 */
Public void uploadUserAvatar(String filePath, IAvatarCallback callback);
        
[code example]

MeariUser.getInstance().uploadUserAvatar(path, new IAvatarCallback() {
    @Override
    Public void onSuccess(String path) {
//path is the address of the server avatar after returning the upload.
    }

    @Override
    Public void onError(String code, String error) {

    }
});
```
## 4.7 Modify nickname
```
【description】
Modify the user nickname.
 
[function call]

/**
 * Upload user avatar
 *
 * @param nickname User new nickname
 * @param callback network request callback
 */
Public void renameNickname(String nickname, final IResultCallback callback);
        
[code example]

MeariUser.getInstance().renameNickname(name, new IResultCallback() {
    @Override
    Public void onSuccess() {

    }

    @Override
    Public void onError(String code, String error) {

    }
});
```

# 5. Equipment distribution network (PPSCameraPlayer tool class)
```
Towers Perrin's hardware modules support three distribution modes: Quick Connect mode (TLink, EZ mode for short), Hotspot mode (AP mode), and QR code distribution mode.
The QR code and Quick Connect mode are relatively easy to operate. It is recommended to use the hotspot mode as an alternative after the distribution network fails. Among them, the success rate of the two-dimensional code distribution network is high.
```

## 5.1 Generating QR code
```
【description】
After obtaining the token, generate the QR code for scanning the device.

[function call]

/**
 * Get distribution network temporary token
 *
 * @param type with network type
 * @param callback callback
 */
Public void getToken(int type, IGetTokenCallback callback);

/**
 * Generate distribution network QR code
 *
 * @param ssid wifi name
 * @param password wifi password
 * @param token distribution network temporary token
 * @param callback callback
 */
Public void createQR(String ssid, String password, String token, ICreateQRCallback callback);

[code example]

MeariUser.getInstance().getToken(Distribution.DISTRIBUTION_QR, new IGetTokenCallback() {
    @Override
    Public void onError(int code, String error) {
        // error
    }
    @Override
    Public void onSuccess(String token, int leftTime) {
        // token distribution token
        // leftTime remaining effective time
    }
});


MeariUser.getInstance().createQR(wifiName, wifiPwd, token, new ICreateQRCallback() {
    @Override
    Public void onSuccess(Bitmap bitmap) {
        mQrImage.setImageBitmap(bitmap);// Display QR code
    }
});
```

## 5.2 Searching for added devices
```
【description】
After the device is searched, it is detected whether the device can be added, and then the add interface is added.

[function call]

/**
 * Query device status list
 *
 * @param ssid wifi name
 * @param pwd wifi password
 * @param wifiMode wifi encryption type
 * @param scanningResultActivity search result callback
 * @param status status
 */
Public MangerCameraScanUtils(String ssid, String pwd, int wifiMode, CameraSearchListener scanningResultActivity, boolean status)

/**
 * Query device status list
 *
 * @paramList<CameraInfo>cameraInfos device list
 * @param callback network request callback
 */
Public void checkDeviceStatus(List<CameraInfo>cameraInfos, IDeviceStatusCallback callback);

/**
 * Add device
 *
 * @paramList<CameraInfo>cameraInfos device list
 * @param callback network request callback
 */
Public void addDevice(CameraInfo cameraInfo, int deviceTypeID, IAddDeviceCallback callback);

[code example]

MangerCameraScanUtils mangerCameraScan = new MangerCameraScanUtils(ssid, pwd, wifiMode, new CameraSearchListener() {
    @Override
    Public void onCameraSearchDetected(CameraInfo cameraInfo) {
        / / Search device callback, execute when the device is discovered
    }

    @Override
    Public void onCameraSearchFinished() {
        //Search is complete
    }

    /**
     * @param time How many s have gone?
     * Refresh progress, if it is larger than progress and the search device is not empty, jump to the next interface
     */
    @Override
    Public void onRefreshProgress(int time) {
        
    }

}, false);

// start searching
mangerCameraScan.startSearchDevice(mIsMonitor, -1, ActivityType.ACTIVITY_SEARCHCANERARESLUT);


MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID, new IDeviceStatusCallback() {
    @Override
    Public void onSuccess(ArrayList<CameraInfo> deviceList) {
        // 1 means your own device, 2 means someone else's micro share to the device, 3 means the device can add 4, others' devices have been shared with themselves
        If (cameraInfo.getAddStatus() == 3) {
            / / Add equipment
        }
    }

    @Override
    Public void onError(int code, String error) {

    }
});

MeariUser.getInstance().addDevice(info, this.mDeviceTypeID, new IAddDeviceCallback() {
    @Override
    Public void onSuccess(String sn) {
       
    }

    @Override
    Public void onError(int code, String error) {
        
    }
});
```

# 6. Device Control

## 6.1 Introduction to device related classes

MeariDevice (manage acquisition device return list)

- List<CameraInfo> ipcs; normal camera list
- List<CameraInfo> bells; doorbell list
- List<CameraInfo> snapCameras; battery camera list
- List<CameraInfo> voiceBells; voice doorbell list
- List<CameraInfo> fourthGenerations; 4G camera list
- List<CameraInfo> flightCameras; luminaire camera list
- List<NVRInfo> nvrs; NVR list

BaseDeviceInfo (device information base class)

- String deviceID //Device ID
- String deviceUUID // device unique identifier
- boolean state//device online status
- String hostKey //Device password
- String snNum / / device SN
- String deviceName / / device name
- String tp//device item number
- String deviceIcon / / device icon gray icon
- int addStatus//Device status 1 means that it is your own device, 2 means that others' micro-shares to the device, 3 means that the device can be added 4, others' devices have been shared with themselves
- String deviceIconGray / / device icon gray icon
- int protocolVersion//device version
- int devTypeID; / / device type
- String userAccount; / / has an account


CameraInfo extends BaseDeviceInfo (camera information class)

- int vtk = -1//device capability level voice intercom: 0=none, 1=speaker only, 2=mic only, 3=speaker/mic/halfduplex, 4=speaker/mic/Fullduplex
- int fcr = -1//device capability level face recognition: face recognize support value
- int dcb = -1//device capability level audible alarm: decibel support value
- int ptz = -1//device capability level PTZ 0=not support, 1=left/right, 2=up/down, 3=left/right/up/down
- int pir = -1//device capability level infrared detection
- int tmpr = -1//device capability level temperature support value
- int md = -1//device capability level humidity detect support value
- int hmd = -1//device capability level human body support value
  //doorbell added
- String bellVoiceURL//recorded address of the owner's message
- boolean pirEnable//pir switch, off: 0; on: 1
- int pirLevel//pir level, 1: low; 2: medium; 3: high
- int bellVol// //doorbell volume, 0~100
- boolean batteryLock / / battery lock switch, locked: true; unlock: false
- String bellPower//doorbell power supply, battery powered: battery; wired power: wire; coexistence: both
- int batteryPercent//% of remaining battery, 0~100
- float batteryRemain// remaining usage time, accurate to 1 decimal place, in hours
- String bellStatus //doorbell charging status, charging: charging; full: charged; uncharged: discharing
- int bellPwm / / low power, this is still uncertain, late change
- int charmVol//bell volume, third gear: high, medium and low
- int charmDuration / / bell length, this is still uncertain, later change
- String bellSongs//doorbell ringtone list
- String bellSelectSong//Selected ringtones
- int nvrPort//NVR port number
- String deviceID//device id
- int trialCloud / / whether to try the cloud
- String deviceVersionID//version number
- int nvrID / / bind nvrId
- String nvrUUID//bind nvr uuid
- String nvrKey // bind nvr password
- boolean asFriend// is a friend device
- String sleep//sleep mode
- long userID / / user ID of the device
- boolean isChecked = false / / no is the selected state (4-way check button)
- String isBindingTY//isBindingTY N (unbound) ND (not expired) D (expired) Y
- String deviceType//device type
- boolean hasAlertMsg //whether the server has a message
- boolean updateVersion //whether the server has a new version
- int closePush//turn off server push
- String updatePersion //If the server has a new version, the device must be forced to upgrade.

NVRInfo extends BaseDeviceInfo (NVR information class)

- int userID; / / device also has the ID
- int addStatus;//Add status
- String tp; / / account name
- int nvrFlag; / / binding indicates 0 means cancel 1: indicates existence
- String nvrVersionID; / / nvr device version number
- String nvrTypeName; / / nvr device version number
- String nvrTypeNameGray; / / nvr device version number
- boolean updateVersion = false;

## 6.2 Device Information Acquisition
```
【description】
Towers Perrin provides a rich interface for developers to achieve device information acquisition and management capabilities (removal, etc.). Device-related return data is notified to the recipient by means of asynchronous messages.
We used the EventBus solution to implement message notification. Therefore, the notification object needs to be registered and destroyed on each device operation page. Please refer to the demo implementation for details.

[function call]

/**
 * Get a list of all devices
 *
 * @param callback network request callback
 */
MeariUser.getInstance().getDevList(IDevListCallback callback);

[code example]

MeariUser.getInstance().getDevList(new IDevListCallback() {
    @Override
    Public void onSuccess(MeariDevice dev) {

    }

    @Override
    Public void onError(String code, String error) {

    }
});
```

## 6.3 Device Removal
```
【description】
    Device removal

[function call]

Devtype - 0-nvr 1-ipc 2-bell (can be customized)
/**
 * Remove device
 *
 * @param devId device id
 * @param deviceType device type
 * @param callback callback
 */
Public void removeDevice(String devId, int deviceType, IResultCallback callback);

[code example]

MeariUser.getInstance().removeDevice(cameraInfo.getDeviceID(), DeviceType.IPC, new IResultCallback()(
    @Override
    Public void onSuccess() {

    }

    @Override
    Public void onError(String code, String error) {

    }
));
```

## 6.4 Device nickname modification
```
【description】
Modify device nickname modification

[function call]

/**
 * Modify device nickname
 *
 * @param deviceId device id
 * @param deviceType device type
 * @param nickname device nickname
 * @param callback callback
 */
Public void renameDeviceNickname(String deviceId, int deviceType, String nickname, IResultCallback callback);

[code example]

MeariUser.getInstance().renameDeviceNickName(cameraInfo.getDeviceID(), DeviceType.IPC, nickName, new IRemoveDeviceCallback()(
    @Override
    Public void onSuccess() {

    }

    @Override
    Public void onError(String code, String error) {

    }
));
```

## 6.5 NVR Binding Device
```
【description】
NVR binding device

[function call]

/ / Bind the device
MeariUser.getInstance().bindDevice(int devid, int nvrid, IRemoveDeviceCallback callback);
/ / Unbundling equipment
MeariUser.getInstance().unbindDevice(int nvrid,,List<int>devid,IunBindDeviceCallback callback);
/ / Query the list of bound devices
MeariUser.getInstance().getBindDeviceList(int nvrid,,IGetBindDeviceList callback);

[code example]

/ / Bind the device
MeariUser.getInstance().bindDevice(devid,nvrid,new IRemoveDeviceCallback(){
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(String code, String error) {
    }
});
/ / Unbundling equipment
MeariUser.getInstance().unbindDevice(nvrid,,List<int>devid,new IunBindDeviceCallback(){
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(String code, String error) {
    }
});
/ / Query the list of bound devices
MeariUser.getInstance().getBindDeviceList(nvrid,new IGetBindDeviceList(){
    @Override
    Public void onSuccess(List<MeariDeviceStatusInfo> list) {
    }

    @Override
    Public void onError(String code, String error) {
    }
});
```

## 6.6 Single device one day alarm time point acquisition
```
【description】
Single device one day alarm time point acquisition

[function call]
/**
 * Single device one day alarm time point acquisition
 *
 * @param deviceID device id
 * @param dayTime day time (format YYMMDD)
 * @param callback callback
 */
MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(int devid,String date,IDeviceAlarmMessageTimeCallback callback);

[code example]

MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(devid,date,new IDeviceAlarmMessageTimeCallback()(
    @Override
    Public void onSuccess(List<AlarmMessageTime> list) {
    }

    @Override
    Public void onError(String code, String error) {
    }
));
```

Class AlarmMessageTime:

-int StartHour;//Start time: hour
-int StartMinute;//Start time: minute
-int StartSecond;//Start time: seconds
-int EndHour;//End time: hour
-int EndMinute;//End time: minute
-int EndSecond;//End time: seconds
-int bHasVideo;//has no video
-int recordType;//doorbell adds time point type, in order to facilitate future expansion defined as int type
-int TYPE_PIR = 0x1001; // PIR alarm type time point
-int TYPE_MOVE = 0x1002;//Motion detection alarm type time point
-int TYPE_VISIT = 0x1003; / / visitor alarm type time point


## 6.7 Check if the device has a new version
```
【description】
Check if the device has a new version

[function call]

/**
 * Check if the device has a new version
 *
 * @param devVersion device version
 * @param lanType Language type
 * @param callback callback
 */
Public void checkNewFirmwareForDev(String devVersion, String lanType, ICheckNewFirmwareForDevCallback callback);

[code example]
MeariUser.getInstance().checkNewFirmwareForDev(firmware_version, "zh", new ICheckNewFirmwareForDevCallback() {
    @Override
    Public void onSuccess(DeviceUpgradeInfo info) {
        mDeviceUpgradeInfo = info;
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

DeviceUpgradeInfo:

- String updatePersion;//Do you need a device forced upgrade?
- int updateStatus;//Can the device be upgraded?
- String serVersion ;//server version
- String versionDesc;//Upgrade description
- String devUrl; / / new firmware address

```
Contains the upgraded address, etc.
```

## 6.8 Querying Device Online Status
```
【description】
    Check if the device has a new version

[function call]
/*
 * Query whether the device is online
 *
 * @param deviceId device ID
 * @param callback callback
 *
 */
MeariUser.getInstance().checkDeviceOnline(String devid,ICheckDeviceOnlineCallback callback);

[code example]
MeariUser.getInstance().checkDeviceOnline(info.getDeviceID(), new ICheckDeviceOnlineCallback() {
    @Override
    Public void onSuccess(String deviceId, boolean online) {
        mAdapter.changeDeviceStatus(deviceId,online);
    }
    @Override
    Public void onError(int code, String error) {
        mAdapter.changeStatusByUuid(info.getDeviceID(), -27);
    }
});
```

## 6.9 Querying the music list
```
【description】
    Query music list

[function call]

 /**
 * Query music list
 *
 * @param callback callback
 */
MeariUser.getInstance().getMusicList(new IGetMusicListCallback());

[code example]

MeariUser.getInstance().getMusicList(new IGetMusicListCallback()(
    @Override
    Public void onSuccess(List<MeariMusic> list) {
    }

    @Override
    Public void onError(String code, String error) {
    }
));
```
MeariMusicList:

- String musicID; //id
- int download_percent;//Download progress
- boolean is_playing; / / is playing
- String musicName;//music name
- String musicFormat;//music format
- String musicUrl;//Music address


## 6.10 Remote wake-up doorbell
```
【description】
Remote wake-up doorbell
Note: For doorbell-type low-power products, you need to wake up remotely and then call the hole-punching interface (may need to punch holes multiple times)

[function call]
/**
 * Remote wake-up doorbell
 *
 * @param deviceId deviceId
 * @param callback callback
 */
Public void remoteWakeUp(String deviceId, IResultCallback callback);

[code example]
MeariUser.getInstance().remoteWakeUp(mCameraInfo.getDeviceID(), new IResultCallback() {
    @Override
    Public void onSuccess() {

    }
    @Override
    Public void onError(int code, String error) {

    }
});
```
## 6.11 Sharing equipment

【description】
Share your device with others

```
[function call]

/**
 * Request sharing device
 *
 * @param cameraInfo device information object
 * @param callback callback
 */
Public void requestDeviceShare(BaseDeviceInfo deviceInfo, IRequestDeviceShareCallback callback);

[code example]

MeariUser.getInstance().requestDeviceShare(cameraInfo, new IRequestDeviceShareCallback() {
    @Override
    Public void onSuccess(String sn) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```


# 7. Sharing device

## 7.1 Related Class Introduction

MeariFriend Friends
- String nickName; Nickname
- String accountName; account number
- String userFriendID; buddy id
- String imageUrl; Friend avatar

ShareFriendInfo Friends information shared by a device
- String nickName;
- String imageUrl; Friend avatar
- String userId; buddy id
- boolean share; whether it has been shared
- String userAccount; friend account

MeariSharedDevice shared device information for a friend

- long deviceID; device id
- String deviceName; device name
- String deviceUUID; device unique identifier
- boolean isShared; whether it has been shared
- String snNum; device sn

## 7.1 Friend Management

### 7.1.1 Get a buddy list
```
【description】
Get a list of friends
    
[function call]
/**
 * Get a list of friends
 *
 * @param callback returns callback
 */
Public void getFriendList(IGetFriendCallback callback);

[code example]

MeariUser.getInstance().getFriendList(new IGetFriendCallback() {
    @Override
    public void onSuccess(List<MeariFriend> friends) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 7.1.2 Adding a friend
```
【description】
Request to add a friend

[function call]

/**
 * Request to add a friend
 *
 * @param callback callback
 */
Public void addFriend(String userAccount, IResultCallback callback);

[code example]

MeariUser.getInstance().addFriend(userAccount, new IResultCallback() {
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 7.1.3 Deleting friends
```
【description】
Delete single or multiple friends

[function call]

/**
 * delete friend
 *
 * @param userIds buddy id, format: ["xxxxxxxx","xxxxxxxx"]
 * @param callback callback
 */
Public void deleteFriend(String userIds, IResultCallback callback);

[code example]

MeariUser.getInstance().deleteFriend(userIds, new IResultCallback() {
    @Override
    Public void onSuccess() {
    }

    @Override
    Public void onError(int code, String error) {

    }
});
```

### 7.1.4 Modify friend nickname
```
【description】
Modify a friend's name

[function call]

/**
 * Modify your friend's name
 *
 * @param friendId buddy ID
 * @param nickname buddy tag
 * @param callback returns callback
 */
Public void renameFriendMark(String friendId, String nickname, IResultCallback callback);

[code example]

MeariUser.getInstance().renameFriendMark(meariFriend.getUserFriendID(), nickname, new IResultCallback() {
    @Override
    Public void onSuccess(){
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```
## 7.2 Query sharing

### 7.2.1 Querying the list of friends shared by a single device
```
【description】
Query the list of friends shared by a single device

[function call]

/**
 * Query the list of friends that a single device is shared with
 *
 * @param deviceType device type
 * @param deviceId device id
 * @param callback network request callback callback
 */
Public void queryFriendListForDevice(int deviceType, String deviceId, IQueryFriendListForDeviceCallback callback) ;

[Method call]

MeariUser.getInstance().queryFriendListForDevice(DeviceType.IPC, cameraInfo.getDeviceID(), new IQueryFriendListForDeviceCallback() {
    @Override
    Public void onSuccess(ArrayList<ShareFriendInfo> shareFriendInfos) {
    }
    @Override
    Public void onError(int code, String error) {
    }
});
```

### 7.2.2 Querying the list of devices shared with a friend
```
【description】
Query the list of devices shared with a friend

[function call]
    
/**
 * Query the list of devices shared with a friend
 *
 * @param devType device type 0-nvr 1-ipc 2-bell
 * @param userId share user ID
 */
Public void queryDeviceListForFriend(int devType, String userId, IQueryDeviceListForFriendCallback callback);

[Method call]

MeariUser.getInstance().queryDeviceListForFriend(DeviceType.DEVICE_IPC, meariFriend.getUserFriendID(), new IQueryDeviceListForFriendCallback() {
    @Override
    Public void onSuccess(List<MeariSharedDevice> list) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

## 7.3 Adding Share
### 7.3.1 Adding a single device share
```
【description】
Share a single device to a given user

[function call]

/**
 * Share a single device to a specified user
 *
 * @param devType device type 0-nvr 1-ipc 2-bell
 * @param userId share user ID
 * @param devUuid device identifier
 * @param callback returns callback
 */
Public void addShareUserForDev(int devType, String userId, String devUuid, String devId, IShareForDevCallback callback);

[Method call]

MeariUser.getInstance().addShareUserForDev(DeviceType.IPC, meariFriend.getUserFriendID(), shareFriendInfo.getDeviceUUID(), shareFriendInfo.getDeviceID(), new IShareForDevCallback() {
    @Override
    Public void onSuccess(String userId, String devId) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 7.3.2 Cancel individual device sharing
```
【description】
Cancel individual device sharing

[function call]
/**
 * Unshare device to friend
 *
 * @param devType device type 0-nvr 1-ipc 2-bell
 * @param userId share user ID
 * @param devUuid device identifier
 * @param devId device id
 * @param callback returns callback
 */
Public void removeShareUserForDev(int devType, String userId, String devUuid, String devId, IShareForDevCallback callback) ;

[Method call]
MeariUser.getInstance().removeShareUserForDev(DeviceType.IPC, shareFriendInfo.getUserId(), cameraInfo.getDeviceID(), cameraInfo.getDeviceUUID(), new IShareForDevCallback() {
    @Override
    Public void onSuccess(String userId, String devId) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});

```

### 7.3.3 Request to share a device
```
【description】
Request to share a device

[function call]

/**
 * Request to share a device
 *
 * @param cameraInfo device
 * @param callback callback
 */
Public void requestDeviceShare(BaseDeviceInfo cameraInfo, IRequestDeviceShareCallback callback);

[Method call]

MeariUser.getInstance().requestDeviceShare(info, new IRequestDeviceShareCallback() {
    @Override
    Public void onError(int code, String error) {
    }

    @Override
    Public void onSuccess(String sn) {
    }
});
```


# 8.Message Center
## 8.1 Get all devices have messages
```
【description】
Get all devices have messages

[function call]
/**
 * Get a list of messages
 *
 * @param callback callback
 */
Public void getAlarmMessageStatusForDev(IGetAlarmMessageStatusForDevCallback callback);

[Method call]
MeariUser.getInstance().getAlarmMessageStatusForDev(new IGetAlarmMessageStatusForDevCallback() {
    @Override
    Public void onError(int code, String error) {
        mPullToRefreshRecyclerView.onRefreshComplete();
        CommonUtils.showToast(error);
    }

    @Override
    Public void onSuccess(List<DeviceMessageStatusInfo> deviceMessageStatus) {
        bindOrderList(deviceMessageStatus);
    }
});
 
```
Class DeviceMessageStatus:

- long deviceID //device ID
- String deviceName //Device name
- String deviceUUID // device unique identifier
- String hasMessgFlag //"Y" indicates that there is an unread message "N" indicates no unread message
- boolean bHasMsg //Do you have a message?
- int delMsgFlag //0 means unedited state, 1 means editing unit selection 2 means selection
- boolean bSysmsg // Is it a system message?
- String snNum // Is it a system message?
- String url // Is it a system message?
- String userAccount // Is it a system message?



## 8.2 Getting System Messages
```
【description】
    Get system messages

[function call]
    /**
     * Get system messages
     *
     * @param callback callback
     */
    Public void getSystemMessage(IGetSystemMessageCallback callback);

[Method call]
    MeariUser.getInstance().getSystemMessage(new IGetSystemMessageCallback() {
        @Override
        Public void onError(int code, String error) {
            mPullToRefreshListView.onRefreshComplete();
            bindError(error);
            CommonUtils.showToast(error);
        }

        @Override
        Public void onSuccess(List<SystemMessageInfo> systemMessages) {
            bindList(systemMessages);
            mPullToRefreshListView.onRefreshComplete();
        }
        });
```
Class SystemMessage:

- long msgID; //MessageId
- int msgTypeID; / / message type
- String isRead; / / Is it read?
- Date createDate; / / create time time
- Date updateDate; / / update time
- long userID; / / user ID
- String userAccount; / / user account
- String nickName;//user name
- String delState; / / whether to deal with
- long deviceID; / / device Id
- String deviceName; / / device name
- String deviceUUID; / / device identifier
- long userIDS; / / requester Id
- String imageUrl;//avatar


## 8.3 Get a device alarm message
```
【description】
    Get a device alarm message

[function call]
    /**
      * refuse friend share device
      *
      * @param deviceId deviceId
      * @param callback callback
      */
    Public void getAlarmMessagesForDev(long deviceId, IGetAlarmMessagesCallback callback);

[Method call]
    MeariUser.getInstance().getAlarmMessagesForDev(this.mMsgInfo.getDeviceID(), new IGetAlarmMessagesCallback() {

        @Override
        Public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo, boolean isDelete) {
            mPullToRefreshListView.onRefreshComplete();
            bindList(deviceAlarmMessages);
            mCameraInfo = cameraInfo;
            deviceStatus = isDelete;
        }

        @Override
        Public void onError(int code, String error) {
            CommonUtils.showToast(error);
            bindError(error);
        }
    });;
 【Precautions】
    If the message is pulled by the owner, the server will not save the message, and the shared friends will not see the message.
```

Class DeviceAlarmMessage:
- long deviceID; / / device ID
- String deviceUuid; / / device unique identifier
- String imgUrl;// Alarm picture address
- int imageAlertType; / / alarm type (PIR and Motion)
- int msgTypeID; / / message type
- long userID; / / user ID
- long userIDS;
- String createDate; / / wear time
- String isRead; / / Is it read?
- String tumbnailPic;//thumbnail
- String decibel; / / decibel
- long msgID; / / message Id


## 8.3 Batch delete system messages
```
【description】

    Batch delete system messages

[function call]
    /**
     * Delete system messages in batches
     *
     * @param callback callback
     * @param msgIds Message Ids
     */
    Public void deleteSystemMessage(List<Long> msgIds, final IResultCallback callback);

[Method call]
    MeariUser.getInstance().deleteSystemMessage(selectDeleteMsgIds, new IResultCallback() {
        @Override
        Public void onSuccess() {
            stopProgressDialog();
            }
        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
            }
        });

```

## 8.4 Batch Delete Multiple Device Alarm Messages
```
【description】
    Delete multiple device alarm messages in bulk

[function call]
     /**
     * Delete multiple device alarm messages in batches
     *
     * @param callback callback
     * @param deviceInfos Device Id
     */
    Public void deleteDevicesAlarmMessage(ArrayList<Long> deviceInfos, IResultCallback callback) ;

[Method call]
    MeariUser.getInstance().deleteDevicesAlarmMessage(deviceInfos, new IResultCallback() {
        @Override
        Public void onSuccess() {
            stopProgressDialog();
            deleteCallback();
        }
        @Override
        Public void onError(int code, String error) {
        stopProgressDialog();
        CommonUtils.showToast(error);
        }
    });
```

## 8.5 Marking a single device message has been read
```
【description】
    Mark a single device message all read

[function call]
    Void MarkDevicesAlarmMessage(int devid, IMarkDevicesAlarmMessageCallback callback);

[Method call]
    MeariUser.getInstance().MarkDevicesAlarmMessage(
        Devid, new IMarkDevicesAlarmMessageCallback() {
            @Override
            Public void onSuccess() {
                
            }

            @Override
            Public void onError(String errorCode, String errorMessage) {

            }
    });
```

## 8.6 Friend Message Processing
```
【description】
    Friend message processing - consent | rejection

[function call]
    /**
     * Agree to add friends
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param callback callback
     */
    Public void agreeFriend(long msgId, long friendId, IDealSystemCallback callback) ;

    /**
     * Refuse to add friends
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param callback callback
     */
    Public void refuseFriend(long msgId, long friendId, IDealSystemCallback callback);

[Method call]
   MeariUser.getInstance().agreeFriend(msgInfo.getMsgID(), msgInfo.getUserID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });

    MeariUser.getInstance().refuseFriend(msgInfo.getMsgID(), msgInfo.getUserID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });;
【Precautions】
    If the message is processed, you need to manually delete the message.
```

## 8.6 Device Message Processing
```
【description】
    Device Message Processing - Agree | Reject

[function call]
    /**
     * Agree to share the device
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param deviceId deviceId
     * @param callback callback
     */
    Public void agreeShareDevice(long msgId, long friendId, long deviceId, IDealSystemCallback callback);

    /**
     * Refuse to share device
     *
     * @param msgId messageId
     * @param friendId friend userId
     * @param deviceId deviceId
     * @param callback callback
     */
    Public void refuseShareDevice(long msgId, long friendId, long deviceId, IDealSystemCallback callback);

[Method call]
    MeariUser.getInstance().agreeShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });

    MeariUser.getInstance().refuseShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(), new IDealSystemCallback() {
        @Override
        Public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        Public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
            }
    });

【Precautions】
    If the message is processed, you need to manually delete the message.
```

# 9. Camera parameter settings
Used to set the camera's detection alarm, sleep mode, local playback and so on.
Whether different devices support a certain setting can be judged by the device's capability set.

If (cameraInfo.getLed() == 1) {
    / / Support switch settings such as LED
} else {
    // does not support switch settings such as LEDs
}

Equipment capability set

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



## 9.1 P2P Setting Parameters
Set the parameters of the camera by punching holes in P2P. For specific usage, refer to the use of CameraPlayer in demo.

## 9.2 Iot setting parameters
Get and set camera parameters via Iothub.
How to use the reference to the use of CameraSettingIotActivity in the demo

### 9.2.1 Iot settings related classes

Device attribute class obtained by IotPropertyInfo Iot
- String userId; User ID
- String deviceTimeZone; device time zone
- String deviceKey; device key
- String capability; device capability level
- String snNum; SN number
- String firmwareCode; Firmware code ppstrong-c2-neutral-1.0.0.20190617
- String firmwareVersion; Firmware version number 1.0.0
- String cloudRecordType; Cloud service recording type: 0-event recording; 1-all-day recording;
- String cloudSaveCycle; cloud service storage cycle
- String cloudExpireDate; cloud service expiration time
- int cloudUploadEnable; cloud storage upload switch: 0-off; 1-open;
- String wifiName; WiFi name of the device connection
- int wifiStrength; WiFi strength of device connection: 0 to 100;
- int rotateEnable; Video flip: 0-normal; 1-turn;
- int ledEnable; LED indicator status: 0-off; 1-on;
- int sdRecordType; SD card recording type: 0-event recording; 1-all day video;
- int sdRecordDuration; SD card recording time: 0-1 minutes; 1-2 minutes; 2-3 minutes;
- int motionDetEnable; Motion detection enable switch: 0-off; 1-on;
- int motionDetSensitivity; Motion detection sensitivity: 0-low; 1-in; 2-high;
- int humanDetEnable; humanoid detection enable switch: 0-off; 1-open;
- int humanFrameEnable; Humanoid frame enable switch: 0-off; 1-open;
- int humanTrackEnable; Humanoid tracking enable switch: 0-off; 1-open;
- int soundDetEnable; audible alarm enable switch: 0-off; 1-open;
- int soundDetSensitivity; audible alarm sensitivity: 0-low; 1-in; 2-high;
- int cryDetEnable; Cry detection enable switch: 0-off; 1-on;
- int dayNightMode; day and night mode: 0-automatic; 1-day mode; 2-night mode;
- int sdStatus; SD card status:
- String sdCapacity; total SD card capacity
- String sdRemainingCapacity; SD card remaining capacity
- int sleepMode; sleep mode: 0 - no sleep; 1 - sleep; 2 - timed sleep; 3 - geofence sleep;
- String sleepTime; time period for timed sleep
- String sleepWifi; WiFi for geofencing sleep
- int onvifEnable; Onvif enable switch: 0-off; 1-on;
- String onvifPwd; Onvif password
- String onvifUrl; Onvif service network address
- int h265Enable; H265 enable switch: 0-H264; 1-H265
- String ip; device IP address
- int NetMode; device network mode: 0-wireless; 1-wired
- int OTAUpgradeStatus; OTA upgrade status: 0 - not upgraded; 1 - upgrade; 2 - upgrade completed to be restarted;
- int OTAUpgradeDownload; OTA upgrade Download progress: -1 to 100
- int OTAUpgradeUpdate; OTA upgrade Upgrade progress: -1 to 100
- int OTAUpgradeTotal; OTA upgrade Total progress: -1~100
- int temperature; temperature
- int humidity; humidity
- int flightSwitchStatus; luminaire camera headlight switch: 0-off; 1-open;

IotConstants Iot related attribute characters
Device property constant, used when refreshing properties, corresponding to the properties of IotPropertyInfo.

### 9.2.2 Get all attribute parameters of the device
```
【description】
Get all the attribute parameters of the device

[function call]

/**
 * Get all the parameters of the device
 *
 * @param snNum device's sn number
 * @param tag request tag
 * @param callback request callback
 */
Public void getIotProperty(String snNum, Object tag, IPropertyCallback callback);

[code example]

MeariUser.getInstance().getIotProperty(cameraInfo.getSnNum(),this, new IPropertyCallback() {
    @Override
    Public void onSuccess(IotPropertyInfo iotPropertyInfo) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.3 Refreshing device properties
```
【description】
Refresh the device properties, select the properties that need to be refreshed, call the refresh interface, and the device returns the latest property values ​​through the mqtt message.

[function call]

/**
 * Refresh device properties
 *
 * @param snNum device's sn number
 * @param timeList 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void refreshProperty(String snNum, List<String> propertyList, Object tag, IStringResultCallback callback);

[code example]

ArrayList<String> arrayList = new ArrayList<>();
arrayList.add(IotConstants.sdCapacity);
arrayList.add(IotConstants.sdRemainingCapacity);

MeariUser.getInstance().refreshProperty(cameraInfo.getSnNum(), arrayList, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.4 Device upload cloud recording settings
```
【description】
Device upload cloud recording settings

[function call]

/**
 * Device upload cloud recording settings
 *
 * @param snNum device's sn number
 * @param enable 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setCloudUploadEnable(String snNum, int enable, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setCloudUploadEnable(cameraInfo.getSnNum(), enable, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.5 Equipment LED light switch control
```
【description】
Equipment LED light switch control

[function call]

/**
 * Equipment LED light switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setLedEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setLedEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.6 Device Preview Video Flip Control
```
【description】
Device preview video flip control

[function call]

/**
 * Device preview video flip control
 *
 * @param snNum device's sn number
 * @param status 0-normal; 1-turn;
 * @param tag request tag
 * @param callback request callback
 */
Public void setRotateEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setRotateEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.7 Device motion detection switch control
```
【description】
Device motion detection switch control

[function call]

/**
 * Device motion detection switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setMotionDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setMotionDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.8 Device motion detection sensitivity setting
```
【description】
Device motion detection sensitivity setting

[function call]

/**
 * Device motion detection sensitivity setting
 *
 * @param snNum device's sn number
 * @param sensitivity 0-low; 1-in; 2-high;
 * @param tag request tag
 * @param callback request callback
 */
Public void setMotionDetSensitivity(String snNum, int sensitivity, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setMotionDetSensitivity(cameraInfo.getSnNum(), sensitivity, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.9 Device noise detection switch control
```
【description】
Device noise detection switch control

[function call]

/**
 * Equipment noise detection switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setSoundDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSoundDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.10 Device Noise Detection Sensitivity Control
```
【description】
Device noise detection sensitivity control

[function call]

/**
 * Equipment noise detection sensitivity control
 *
 * @param snNum device's sn number
 * @param sensitivity 0-low; 1-in; 2-high;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSoundDetSensitivity(String snNum, int sensitivity, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSoundDetSensitivity(cameraInfo.getSnNum(), sensitivity, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.11 Device Local Recording Type Setting
```
【description】
Device local recording type setting

[function call]

/**
 * Device local recording type setting
 *
 * @param snNum device's sn number
 * @param type 0- event recording; 1-all day video;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSdRecordType(String snNum, int type, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSdRecordType(cameraInfo.getSnNum(),type, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.12 Device local recording event video clip time setting
```
【description】
Device local recording event video clip time setting

[function call]

/**
 * Device local recording event video clip time setting
 *
 * @param snNum device's sn number
 * @param duration 0-1 minutes; 1-2 minutes; 2-3 minutes;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSdRecordDuration(String snNum, int duration, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSdRecordDuration(cameraInfo.getSnNum(), duration, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.13 Equipment day and night mode setting
```
【description】
Device day and night mode setting

[function call]

/**
 * Equipment day and night mode setting
 *
 * @param snNum device's sn number
 * @param status 0-automatic; 1-day mode; 2-night mode;
 * @param tag request tag
 * @param callback request callback
 */
Public void setDayNightMode(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setDayNightMode(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.14 Device Video Encoding Format Settings
```
【description】
Device video encoding format setting

[function call]

/**
 * Device video encoding format setting
 *
 * @param snNum device's sn number
 * @param status 0-H264; 1-H265
 * @param tag request tag
 * @param callback request callback
 */
Public void setH265Enable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setH265Enable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.15 Device Onvif Switch Control
```
【description】
Device Onvif Switch Control

[function call]

/**
 * Device Onvif switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setOnvifEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setOnvifEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.16 Device Onvif Password Settings
```
【description】
Device Onvif password settings

[function call]

/**
 * Device Onvif password settings
 *
 * @param snNum device's sn number
 * @param pwd Onvif password
 * @param tag request tag
 * @param callback request callback
 */
Public void setOnvifPwd(String snNum, String pwd, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setOnvifPwd(cameraInfo.getSnNum(), pwd, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.17 Device Format SD Card
```
【description】
The device formats the SD card. After the format is successful, the format progress is obtained through the mqtt message.

[function call]

/**
 * Device format SD card
 *
 * @param snNum device's sn number
 * @param tag request tag
 * @param callback request callback
 */
Public void formatSdcard(String snNum, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().formatSdcard(cameraInfo.getSnNum(), this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.18 Device upgrade firmware
```
【description】
Call checkNewFirmwareForDev() to detect whether the device has new firmware to update. After the firmware is successfully upgraded, the upgrade progress is obtained through the mqtt message.

[function call]

/**
 * Device upgrade firmware
 *
 * @param snNum device's sn number
 * @param OTAUpgradeInfo 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void upgradeFirmware(String snNum, String OTAUpgradeInfo, Object tag, IStringResultCallback callback);

[code example]

JSONObject object = new JSONObject();
Object.put("url",deviceUpgradeInfo.getDevUrl());
Object.put("version",deviceUpgradeInfo.getSerVersion() + "-upgrade.bin");

MeariUser.getInstance().upgradeFirmware(cameraInfo.getSnNum(), object.toString(), this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.19 Equipment humanoid tracking switch control
```
【description】
Equipment humanoid tracking switch control

[function call]

/**
 * Equipment humanoid tracking switch control
 *
 * @param snNum device's sn number
 * @param OTAUpgradeInfo 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setHumanTrackEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setHumanTrackEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.20 Equipment humanoid detection alarm switch control
```
【description】
Equipment humanoid detection alarm switch control

[function call]

/**
 * Equipment humanoid detection alarm switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setHumanDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setHumanDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.21 Equipment Humanoid Frame Switch Control
```
【description】
Equipment humanoid frame switch control

[function call]

/**
 * Equipment humanoid frame switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setHumanFrameEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setHumanFrameEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.22 Equipment crying alarm switch control
```
【description】
Equipment crying alarm switch control

[function call]

/**
 * Equipment crying alarm switch control
 *
 * @param snNum device's sn number
 * @param status 0-off 1-open
 * @param tag request tag
 * @param callback request callback
 */
Public void setCryDetEnable(String snNum, int status, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setCryDetEnable(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.23 Device Sleep Mode Settings
```
【description】
Device sleep mode setting

[function call]

/**
 * Device sleep mode setting
 *
 * @param snNum device's sn number
 * @param mode 0- no sleep; 1-sleep; 2-timed sleep; 3-geo-fence sleep;
 * @param tag request tag
 * @param callback request callback
 */
Public void setSleepMode(String snNum, int mode, Object tag, IStringResultCallback callback);

[code example]

MeariUser.getInstance().setSleepMode(cameraInfo.getSnNum(), status, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.24 Device Timing Sleep Time Period Setting
```
【description】
Device timed sleep period setting

[function call]

/**
 * Device timed sleep period setting
 *
 * @param snNum device's sn number
 * @param timeList sleep time period list
 * @param tag request tag
 * @param callback request callback
 */
Public void setSleepTimeList(String snNum, String timeList, Object tag, IStringResultCallback callback);

[code example]

timeList description:
Enable: whether to enable
Start_time: start time point
Stop_time: end time point
Repeat: The number of days that take effect every week 1~7

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

MeariUser.getInstance().setSleepTimeList(cameraInfo.getSnNum(), timeList, this, new IStringResultCallback() {
    @Override
    Public void onSuccess(String result) {
    }

    @Override
    Public void onError(int code, String error) {
    }
});
```

### 9.2.25 Device start rotation command
```
【description】
Device start rotation command

[function call]

/**
 * The device starts to rotate
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