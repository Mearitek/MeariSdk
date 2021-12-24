
<h1><center> 目录 </center></h1>

[TOC]

<center>
---
版本号 | 制定团队 | 更新日期 | 备注
:-:|:-:|:-:|:-:
3.1.0 | 觅睿技术团队 | 2020.07.02 | 优化

</center>

# 1.功能概述

觅睿科技APP SDK提供了与硬件设备、觅睿云通讯的接口封装，加速应用开发过程，主要包括以下功能：

- 账户体系
- 设备添加
- 设备控制
- 设备设置
- 设备共享
- 消息中心

--------------

# 2.集成准备
## 服务端接入代码
```
请先阅读服务端文档，获取重定向和登录的认证信息
```
--------------

# 3.集成SDK
## 3.1 集成流程
### 3.1.1 引入sdk包
```
libs文件夹中的so文件和aar文件引入到自己项目中，so文件根据自己项目的需要全部类型或部分类型引入。
```

### 3.1.2 配置build.gradle
```
build.gradle文件里添加如下配置:

android {
    defaultConfig {
        ...
        ndk {
        //选择要添加的对应 cpu 类型的 .so 库。
        abiFilters  arm64-v7a', 'armeabi-v8a'
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
    // 必需依赖库
    implementation(name: 'sdk-core-3.1.0-beta6', ext: 'aar')
    implementation 'com.squareup.okhttp3:okhttp:3.12.0'
    implementation 'org.eclipse.paho:org.eclipse.paho.client.mqttv3:1.1.0'
    implementation 'org.eclipse.paho:org.eclipse.paho.android.service:1.1.1'
    implementation 'com.alibaba:fastjson:1.2.57'
    implementation 'com.google.zxing:core:3.3.3'
}
```

### 3.1.3 配置AndroidManifest.xml 
```
在AndroidManifest.xml文件里配置appkey和appSecret，在配置相应的权限等
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


## 3.2 初始化SDK

```
【描述】
主要用于初始化内部资源、通信服务、重定向、日志记录等功能。
 
【函数调用】

/**
 * 初始化
 * @param context application
 * @param mqttMessageCallback mqtt消息回调
 */
MeariSdk.init(Context application, MqttMessageCallback mqttMessageCallback);

【代码范例】

public class MeariSmartApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        // 初始化
        MeariSdk.init(this ,new MyMessageHandler());
        // 输出日志
        MeariSdk.getInstance().setDebug(true);
    }
}
```
# 4.用户管理
```
觅睿科技提供手机/邮箱密码登陆，uid登录，重置密码等操作，
在注册或登录成功后，使用返回信息，连接mqtt服务。
```

UserInfo类
- userID      用户ID
- nickName    昵称
- userAccount 用户
- token       用户登陆的时候的唯一标识
- headPic     用户头像路径
- phoneCode   国家电话区号
- countryCode 国家代号
- loginTime   登录时间
- soundFlag   推送声音;
- imageUrl    头像;
- userToken   用户唯一表示;
- desc        用户描述;


## 4.1 手机/邮箱注册
```
【描述】
手机或邮箱注册。

【函数调用】

/**
 * 获取验证码
 *
 * @param countryCode 国家代号
 * @param phoneCode   国家电话号码区号
 * @param userAccount 账户
 * @param callback    网络请求回调
 */
public void getValidateCodeWithAccount(String countryCode, String phoneCode, String userAccount, IValidateCallback callback);

/**
 * register account, and return the mqtt iot info.
 *
 * @param countryCode 国家代号
 * @param phoneCode   国家电话号码区号
 * @param account     账户
 * @param pwd         密码
 * @param nickname    呢称
 * @param code        验证码
 * @param callback    网络请求回调
 */
public void registerWithAccount(String countryCode, String phoneCode, String account, String pwd, String nickname, String code, IRegisterCallback callback);

【代码范例】

MeariUser.getInstance().getValidateCodeWithAccount(countryCode, phoneCode, account, new IValidateCallback() {
    @Override
    public void onSuccess(int leftTime) {
        //leftTime 表示验证码剩余有效时间
    }

    @Override
    public void onError(int code, String error) {
    }
});

MeariUser.getInstance().registerWithAccount(countryCode,phoneCode,account,pwd,nickname,code, new IRegisterCallback() {
    @Override
    public void onSuccess(UserInfo user) {
        //UserInfo 返回用户信息                        
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 4.2 服务端认证信息登录
```
【描述】
服务端认证信息登陆

【函数调用】
/**
 * 用从服务器获取的重定向信息和登录信息登录
 * @param redirectionJson 从服务端获取的重定向信息的json字符串
 * @param loginJson 从服务端获取的登录信息的json字符串
 */
public void loginWithExternalData(String redirectionJson, String loginJson, ILoginCallback callback)

【代码范例】
MeariUser.getInstance().public void loginWithExternalData(String redirectionJson, String loginJson, ILoginCallback callback)
```

## 4.3 重置密码
```
【描述】
重置密码
 
【函数调用】
/**
 * 获取验证码
 *
 * @param countryCode 国家代号
 * @param phoneCode   国家电话号码区号
 * @param userAccount 账户
 * @param callback    网络请求回调
 */
public void getValidateCodeWithAccount(String countryCode, String phoneCode, String userAccount, IValidateCallback callback);

/**
 * 重置密码
 *
 * @param countryCode 国家代号
 * @param phoneCode   国家电话号码区号
 * @param account     国内电话/邮箱
 * @param verificationCode   验证码
 * @param password    用户新密码密码
 * @param callback    网络请求回调
 */
public void resetPasswordWithAccount(String countryCode, String phoneCode, String account, String verificationCode, String pwd, IResetPasswordCallback callback);
    
【代码范例】

MeariUser.getInstance().getValidateCodeWithAccount(countryCode, phoneCode, account, new IValidateCallback() {
    @Override
    public void onSuccess(int leftTime) {
        //leftTime 表示验证码剩余有效时间
    }

    @Override
    public void onError(int code, String error) {
    }
});

MeariUser.getInstance().resetPasswordWithAccount(countryCode, phoneCode, account, verificationCode, pwd, new IResetPasswordCallback() {
    @Override
    public void onSuccess(UserInfo user) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 4.4 uid用户系统

```
【描述】
如果客户有自己的用户体系，那么可以通过uid登陆，接入我们的sdk。
用户uid登录，uid要求唯一，由接入方自己定义。uid体系可以直接登录，不需要注册。

【函数调用】

/**
 * 用户UID登录
 * @param countryCode 国家代号
 * @param phoneCode   国家电话号码区号
 * @param uid         用户唯一标识符
 * @param callback    网络请求回调
 */
public void loginWithUid(String countryCode, String phoneCode, String uuid, ILoginCallback callback);
        
【代码范例】

MeariUser.getInstance().loginWithUid(countryCode, phoneCode,uid, new ILoginCallback() {
    @Override
    public void onSuccess(UserInfo user) {
        // 建议在MainActivity中连接mqtt服务，第一次登陆完保存用户信息，不必每次启动app都去登录。
        // 连接mqtt服务
        MeariUser.getInstance().connectMqttServer(getApplication());
    }
    @Override
    public void onError(String code, String error) {
        // 失败
    }
});
```

## 4.5 退出登录
```
【描述】
退出登录

【函数调用】

/**
 * 退出登录
 *
 * @param callback 网络请求回调
 */
public void logout(ILogoutCallback callback);

【代码范例】
MeariUser.getInstance().logout(new ILogoutCallback() {
    @Override
    public void onSuccess() {
        //清除用户信息，断开mqtt连接等操作
        MqttMangerUtils.getInstance().disConnectService();
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 4.6 上传用户头像
```
【描述】
上传用户头像。
 
【函数调用】

/**
 * 上传用户头像
 *
 * @param file     用户头像图片文件（最好是300*300）
 * @param callback 网络请求回调
 */
public void uploadUserAvatar(List<File> fileList, IAvatarCallback callback);
        
【代码范例】

MeariUser.getInstance().uploadUserAvatar(path, new IAvatarCallback()  {
    @Override
    public void onSuccess(String path) {
		//path 为返回上传后存到服务器头像地址
    }

    @Override
    public void onError(String code, String error) {

    }
});
```
## 4.7 修改昵称
```
【描述】
修改用户昵称。
 
【函数调用】

/**
 * 修改昵称
 *
 * @param nickname 昵称
 * @param callback 网络请求回调
 */
public void renameNickname(String nickname, IResultCallback callback);
        
【代码范例】

MeariUser.getInstance().renameNickname(name, new IResultCallback() {
    @Override
    public void onSuccess() {

    }

    @Override
    public void onError(String code, String error) {

    }
});
```

# 5.添加设备
```
让设备连接上WiFi，并将设备添加到用户的的账号下。推荐使用二维码配网添加
```
## 5.1 二维码配网添加设备
```
获取token后，生成二维码，设备扫描二维码听到提示音，并变成蓝灯后表示配网成功。
然后搜索设备添加，等待添加完成。
```
### 5.1.1 生成二维码
```
【描述】
获取token后，生成二维码，设备扫描二维码听到提示音，并变成蓝灯后表示配网成功。
然后搜索设备添加，等待设备添加完成。

【函数调用】

/**
 * 获取配网token
 *
 * @param callback 回调
 */
public void getToken(IGetTokenCallback callback);

/**
 * 生成配网二维码
 *
 * @param ssid     wifi名称
 * @param password wifi密码
 * @param token    配网token
 * @param callback callback
 */
public void createQRCode(String ssid, String password, String token, ICreateQRCodeCallback callback);

【代码范例】

// 获取配网token
MeariUser.getInstance().getToken(new IGetTokenCallback() {
    @Override
    public void onSuccess(String token, int leftTime, int smart_switch) {
        // token 配网令牌
        // leftTime 剩余有效时间
        // smart_switch smartWifi开关
    }

    @Override
    public void onError(int code, String error) {
    }
});

// 生成配网二维码
MeariUser.getInstance().createQRCode(wifiName, pwd, token, new ICreateQRCodeCallback() {
    @Override
    public void onSuccess(Bitmap bitmap) {
        mQrImage.setImageBitmap(bitmap);// 显示二维码
    }
});
```

### 5.1.2 搜索添加设备
```
【描述】
搜索到设备后，检测设备状态，如果不支持自动添加，调用添加接口添加。
如果支持自动添加，则等待添加成功或失败的mqtt消息。
mqtt消息可能有延时，为了提高体验，可以定时调用getDeviceList()接口，查询有没有多出新设备，来判断添加有没有成功。

【函数调用】

/**
 * 查询设备状态列表
 *
 * @param ssid      wifi名称
 * @param pwd       wifi密码
 * @param wifiMode  wifi加密类型 0:无密码, 1:WPA_PSK加密, 2:WPA_EAP加密
 * @param scanningResultActivity 搜索结果回调
 * @param status    状态
 */
public MangerCameraScanUtils(String ssid, String pwd, int wifiMode, CameraSearchListener scanningResultActivity, boolean status)

/**
 * 查询设备状态列表
 *
 * @paramList<CameraInfo>cameraInfos 设备列表
 * @param deviceTypeID 设备类型ID
 * @param callback 网络请求回调
 */
public void checkDeviceStatus(List<CameraInfo> deviceList, int deviceTypeID, IDeviceStatusCallback callback);

/**
 * 添加设备
 *
 * @paramList<CameraInfo>cameraInfos 设备列表
 * @param deviceTypeID 设备类型ID
 * @param callback 网络请求回调
 */
public void addDevice(CameraInfo cameraInfo, int deviceTypeID, IAddDeviceCallback callback);

【代码范例】

MangerCameraScanUtils mangerCameraScan = new MangerCameraScanUtils(ssid, pwd, wifiMode, new CameraSearchListener() {
    @Override
    public void onCameraSearchDetected(CameraInfo cameraInfo) {
        //发现设备，检查设备状态
        checkDeviceStatus();
    }

    @Override
    public void onCameraSearchFinished() {
        //搜索完毕
    }

    @Override
    public void onRefreshProgress(int time) {
        //搜索进度100-0,100s后结束搜索
    }

}, false);

// 开始搜索
mangerCameraScan.startSearchDevice(false, -1, 100, ActivityType.ACTIVITY_SEARCHCANERARESLUT, token)


MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID, new IDeviceStatusCallback() {
    @Override
    public void onSuccess(ArrayList<CameraInfo> deviceList) {
        // 1代表是自己的设备，2代表别人的分享给设备,3代表设备可添加 4,别人的设备已分享给自己
        if (cameraInfo.getAddStatus() == 3) {
            //添加设备
            if (cameraInfo.getAutoBinding() == 1) {
                //支持自动绑定，无需手动处理
            } else {
                //不支持自动绑定，主动添加
                addDevice(info);
            }
        }
    }

    @Override
    public void onError(int code, String error) {

    }
});

MeariUser.getInstance().addDevice(info, this.mDeviceTypeID, new IAddDeviceCallback() {
@Override
    public void onSuccess(String sn) {
       
    }

    @Override
    public void onError(int code, String error) {
        
    }
});

// 自动添加的设备等待MyMessageHandler中的回调消息
@Override
public void addDeviceSuccess(String message) {
    //添加设备成功消息
}

@Override
public void addDeviceFailed(String message) {
    //添加设备失败消息
}
```

## 5.2 AP配网添加设备

```
让设备处于AP配网模式，连接设备热点，更新token后，发送配置信息后连回之前的wifi听到提示音，并变成蓝灯后表示配网成功。
然后搜索设备添加，等待设备添加完成。
```

## 5.2.1 连接设备热点

```
【描述】
让设备处于AP配网模式，连接设备热点，更新token后，发送配置信息后连回之前的wifi听到提示音，并变成蓝灯后表示配网成功。
然后搜索设备添加，等待设备添加完成。

【函数调用】
/**
 * 创建设备控制类
 *
 */
public MeariDeviceController();

/**
 * 更新token
 *
 * token 配网令牌
 */
public void updateToken(String token);

/**
 * 发送配置信息
 *
 * @param wifiName wifi名称
 * @param password wifi密码
 * @param deviceListener 回调
 */
public void setAp(String wifiName, String password, MeariDeviceListener deviceListener);

【代码范例】

if (deviceController == null) {
    deviceController = new MeariDeviceController();
}
deviceController.updateToken(getToken());  // getToken() 获取配网token
deviceController.setAp(mSsid, mPwd, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        // 连回原来的wifi，开始搜索添加设备
    }

    @Override
    public void onFailed(String errorMsg) {
        
    }
});
```

### 5.2.2 搜索添加设备

```
见5.1.2
```

# 6.设备控制

## 6.1 设备基本操作

### 6.1.1 设备相关类介绍

MeariDevice（管理获取返回的设备列表）

- List<CameraInfo> ipcs; 普通摄像机列表
- List<CameraInfo> doorBells; 门铃列表
- List<CameraInfo> batteryCameras; 电池摄像机列表
- List<CameraInfo> voiceBells; 语音门铃列表
- List<CameraInfo> fourthGenerations; 4G摄像机列表
- List<CameraInfo> flightCameras;泛光灯摄像机列表
- List<CameraInfo> chimes; 中继设备

CameraInfo extends BaseDeviceInfo（设备信息类）

- String deviceID //设备Id
- String snNum//设备SN
- String deviceName//设备呢称
- String deviceIcon//设备图标灰色图标
- int addStatus//设备状态 1代表是自己的设备, 2代表别人的未分享设备, 3代表设备可添加, 4别人的设备已分享给自己
- int devTypeID;//设备类型
- String userAccount;//拥有着账号
- boolean asFriend//是否为好友分享给自己的设备

### 6.1.2 获取设备信息列表
```
【描述】
觅睿提供了丰富的接口供开发者实现设备信息的获取和管理能力(移除等)。设备相关的返回数据都采用异步消息的方式通知接受者。
我们采用了EventBus的方案来实现消息通知。因此在每个设备操作页面都需要注册和销毁通知对象。具体请参考demo实现。

【函数调用】
/**
 * 获取用户的设备列表
 *
 * @param callback Function callback
 */
public void getDeviceList(IDevListCallback callback);

【代码范例】
MeariUser.getInstance().getDeviceList(new IDevListCallback() {
    @Override
    public void onSuccess(MeariDevice dev) {
        //根据自己接入的设备选择
        ArrayList<CameraInfo> cameraInfos = new ArrayList<>();
        cameraInfos.addAll(dev.getIpcs());
        cameraInfos.addAll(dev.getDoorBells());
        cameraInfos.addAll(dev.getBatteryCameras());
        cameraInfos.addAll(dev.getVoiceBells());
        cameraInfos.addAll(dev.getFourthGenerations());
        cameraInfos.addAll(dev.getFlightCameras());
        cameraInfos.addAll(dev.getChimes());
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 6.1.3 设备移除
```
【描述】
设备移除

【函数调用】
/**
 * 移除设备
 *
 * @param devId 设备id
 * @param deviceType 设备类型
 * @param callback Function callback
 */
public void deleteDevice(String devId, int deviceType, IResultCallback callback);

【代码范例】
MeariUser.getInstance().deleteDevice(cameraInfo.getDeviceID(), DeviceType.IPC, new IResultCallback()(
    @Override
    public void onSuccess() {

    }

    @Override
    public void onError(String code, String error) {

    }
));
```

### 6.1.4 设备昵称修改
```
【描述】
设备昵称修改

【函数调用】
/**
 * 修改设备昵称
 *
 * @param deviceId 设备id
 * @param deviceType 设备类型
 * @param nickname 设备昵称
 * @param callback Function callback
 */
public void renameDevice(String deviceId, int deviceType, String nickname, IResultCallback callback);

【代码范例】
MeariUser.getInstance().renameDeviceNickName(cameraInfo.getDeviceID(), DeviceType.IPC, nickName, new IRemoveDeviceCallback()(
    @Override
    public void onSuccess() {

    }

    @Override
    public void onError(String code, String error) {

    }
));
```

### 6.1.5 获取设备报警消息时间片段
```
【描述】
获取设备的报警消息时间片段

【函数调用】

/**
 * 获取设备的报警消息时间片段
 *
 * @param deviceID 设备ID
 * @param dayTime  时间："20200303"
 * @param callback callback
 */
public void getDeviceAlarmMessageTimeForDate(String deviceID, String dayTime, IDeviceAlarmMessageTimeCallback callback);

【代码范例】
MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(deviceID, dayTime, new IDeviceAlarmMessageTimeCallback() {
    @Override
    public void onSuccess(ArrayList<VideoTimeRecord> videoTimeList) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 6.2 设备预览和回放
### 6.2.1 设备预览
```
【描述】
一个设备对应一个CameraInfo和一个MeariDeviceController。在对同一个设备进行多种操作时，保证用同一个对象，不要重复创建。
CameraInfo和一个MeariDeviceController可以保存在MeariUser类中，需要时再去获取。操作另外一个设备时需要重新创建和保存。

【函数调用】

/**
 * 连接设备
 *
 * @param deviceListener device listener
 */
public void startConnect(MeariDeviceListener deviceListener);

/**
 * 开始预览
 *
 * @param ppsGLSurfaceView 视频控件
 * @param videoId 视频清晰度 0-高清；1-标清
 * @param deviceListener 操作监听
 * @param videoStopListener 视频状态变化监听
 */
public void startPreview(PPSGLSurfaceView ppsGLSurfaceView, int videoId, MeariDeviceListener deviceListener,MeariDeviceVideoStopListener videoStopListener);

【代码范例】

LinearLayout ll_video_view = findViewById(R.id.ll_video);
PPSGLSurfaceView videoSurfaceView = new PPSGLSurfaceView(this, screenWidth, screenHeight);
videoSurfaceView.setKeepScreenOn(true);
ll_video_view.addView(videoSurfaceView);

// 连接设备
MeariDeviceController deviceController = new MeariDeviceController();
deviceController.setCameraInfo(cameraInfo);
deviceController.startConnect(new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        // 连接成功后，开始预览
        startPreview();
        // 保存对象，避免重复创建
        MeariUser.getInstance().setCameraInfo(cameraInfo);
        MeariUser.getInstance().setController(deviceController);
    }

    @Override
    public void onFailed(String errorMsg) {
        
    }
});

// 需要时获取保存的对象
CameraInfo cameraInfo = MeariUser.getInstance().getCameraInfo();
MeariDeviceController deviceController = MeariUser.getInstance().getController();

// 开始预览
deviceController.startPreview(videoSurfaceView, videoId, new MeariDeviceListener() {
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

// 切换清晰度
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

// 停止预览
deviceController.stopPreview(new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});

// 断开连接，退出预览和回放时，必须断开连接
deviceController.stopConnect(new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});
```

### 6.2.2 设备SD卡回放

```
【描述】
设备插入SD后，会录制视频并保存到SD卡，然后可以查看SD卡中的录像。需要连接设备成功后，才能进行回放操作。

【函数调用】

/**
 * 获取一个月有视频的日期
 * @param year 年
 * @param month 月
 * @param videoId 视频清晰度
 * @param callback 回调
 */
public void getPlaybackVideoDaysInMonth(int year, int month, int videoId, IPlaybackDaysCallback callback);

/**
 * 获取一天中所有的视频片段
 * @param year 年
 * @param month 月
 * @param videoId 视频清晰度
 * @param callback 回调
 */
public void getPlaybackVideoTimesInDay(int year, int month, int day, int videoId, MeariDeviceListener deviceListener);


/**
 * 开始播放录像
 *
 * @param ppsGLSurfaceView 视频控件
 * @param videoId 视频清晰度 0-高清；1-标清
 * @param startTime 视频开始的时间
 * @param deviceListener 操作监听
 * @param videoStopListener 视频状态变化监听
 */
public void startPlaybackSDCard(PPSGLSurfaceView ppsGLSurfaceView, int videoId, String startTime, MeariDeviceListener deviceListener, MeariDeviceVideoStopListener videoStopListener);

/**
 * 拖动改变播放录像
 *
 * @param seekTime 视频开始的时间
 * @param deviceListener 操作监听
 * @param videoStopListener 视频状态变化监听
 */
public void seekPlaybackSDCard(String seekTime, MeariDeviceListener deviceListener, MeariDeviceVideoSeekListener seekListener);

/**
 * 暂停播放录像
 *
 * @param deviceListener 操作监听
 */
public void pausePlaybackSDCard(MeariDeviceListener deviceListener);

/**
 * 暂停后重新播放录像
 *
 * @param deviceListener 操作监听
 */
public void resumePlaybackSDCard(MeariDeviceListener deviceListener)

/**
 * 停止播放录像
 *
 * @param deviceListener 操作监听
 */
public void stopPlaybackSDCard(MeariDeviceListener deviceListener);


【代码范例】

// 连接设备成功后，才能播放录像
// 获取一个月有视频的日期
deviceController.getPlaybackVideoDaysInMonth(year, month, videoId, new IPlaybackDaysCallback() {
    @Override
    public void onSuccess(ArrayList<Integer> playbackDays) {
        
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});

// 获取一天中所有的视频片段
deviceController.getPlaybackVideoTimesInDay(year, month, day, videoId, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});

// 开始播放录像
deviceController.startPlaybackSDCard(ppsGLSurfaceView, videoId, startTime, new MeariDeviceListener() {
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

// 拖动改变播放录像
deviceController.seekPlaybackSDCard(seekTime, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {

    }

    @Override
    public void onFailed(String errorMsg) {

    }
}, new MeariDeviceVideoSeekListener() {
    @Override
    public void onVideoSeek() {
        
    }
});

// 暂停播放录像
deviceController.pausePlaybackSDCard(new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});

// 暂停后重新播放录像
deviceController.resumePlaybackSDCard(new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});

// 停止播放录像
deviceController.stopPlaybackSDCard(new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});
```
### 6.2.3 设备云回放

```
【描述】
设备开通云存储后，可以进行云回放

【函数调用】

/**
 * 获取一个月有视频的日期
 * @param deviceID 设备ID
 * @param year 年
 * @param month 月
 * @param callback 回调
 */
public void getCloudHaveVideoDaysInMonth(String deviceID, int year, int month, ICloudHaveVideoDaysCallback callback);

/**
 * 获取一天中所有的视频片段
 * @param deviceID 设备ID
 * @param year 年
 * @param month 月
 * @param callback 回调
 */
public void getCloudVideoTimeRecordInDay(String deviceID, int year, int month, int day, ICloudVideoTimeRecordCallback callback);

/**
 * 获取云回放的视频信息
 * @param deviceID 设备ID
 * @param year 年
 * @param month 月
 * @param month 日
 * @param callback 回调
 */
public void getCloudVideo(String deviceID, int index, int year, int month, int day, ICloudGetVideoCallback callback);

【代码范例】

// 获取一个月有视频的日期
MeariUser.getInstance().getCloudHaveVideoDaysInMonth(deviceId, year, month, new ICloudHaveVideoDaysCallback() {
    @Override
    public void onSuccess(String yearAndMonth, ArrayList<Integer> haveVideoDays) {
               
    }

    @Override
    public void onError(int code, String error) {

    }
});

// 获取一天中所有的视频片段
MeariUser.getInstance().getCloudVideoTimeRecordInDay(deviceId,year, month, day, new ICloudVideoTimeRecordCallback(){
    @Override
    public void onSuccess(String yearMonthDay, ArrayList<VideoTimeRecord> recordList) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});

// 获取云回放的视频信息
MeariUser.getInstance().getCloudVideo(deviceid, index, year, month, day, new ICloudGetVideoCallback() {
    @Override
    public void onSuccess(String videoInfo, String startTime, String endTime) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});
```

# 7.分享设备

## 7.1 相关类介绍

ShareUserInfo 被分享者用户信息
- String userAccount; 用户账号
- String userName; 用户名称
- String userIcon; 用户头像
- String shareStatus; 分享状态

ShareDeviceInfo 被分享的设备信息
- long deviceID; 设备 ID
- String deviceName; 设备名称
- String deviceIcon;  设备图标
- List<String> shareUserList;  设备分享的用户列表

## 7.2 获取设备分享列表
```
【描述】
获取设备分享列表

【函数调用】
/**
 * 获取设备分享列表
 * 
 * @param deviceID device ID
 * @param callback Function callback
 */
public void getShareListForDevice(String deviceID, IShareUserListCallback callback);

【代码范例】
MeariUser.getInstance().getShareListForDevice(cameraInfo.getDeviceID(), new IShareUserListCallback() {
    @Override
    public void onSuccess(ArrayList<ShareUserInfo> shareUserInfoList) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 7.3 获取历史分享列表
```
【描述】
获取历史分享列表

【函数调用】
/**
 * 获取历史分享列表
 * 
 * @param deviceID device ID
 * @param callback Function callback
 */
public void getHistoryShare(String deviceID, IShareUserListCallback callback);

【代码范例】
MeariUser.getInstance().getHistoryShare(cameraInfo.getDeviceID(), new IShareUserListCallback() {
    @Override
    public void onSuccess(ArrayList<ShareUserInfo> shareUserInfoList) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 7.4 获取所有设备的分享结果
```
【描述】
获取所有设备的分享结果

【函数调用】
/**
 * 获取所有设备的分享结果
 *
 * @param callback Function callback
 */
public void getAllDeviceShare(IShareDeviceListCallback callback);

【代码范例】
MeariUser.getInstance().getAllDeviceShare(new IShareDeviceListCallback() {
    @Override
    public void onSuccess(ArrayList<ShareDeviceInfo> shareDeviceInfoList) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 7.5 搜索用户
```
【描述】
搜索用户

【函数调用】
/**
 * 搜索用户
 * 
 * @param account 账号
 * @param deviceID device ID
 * @param phoneCode 国家电话号码区号
 * @param callback Function callback
 */
public void searchUser(String account, String deviceID, String phoneCode, ISearchUserCallback callback)

【代码范例】
MeariUser.getInstance().searchUser(account, deviceID, phoneCode, new ISearchUserCallback() {
    @Override
    public void onSuccess(ShareUserInfo shareUserInfo) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 7.6 分享设备
```
【描述】
分享设备

【函数调用】
/**
 * 分享设备
 * @param account 账号
 * @param deviceID device ID
 * @param phoneCode 国家电话号码区号
 * @param callback Function callback
 */
public void shareDevice(String account, String deviceID, String phoneCode, IResultCallback callback);

【代码范例】
MeariUser.getInstance().shareDevice(account, deviceID, phoneCode, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 7.7 取消分享设备
```
【描述】
取消分享设备

【函数调用】
/**
 * 取消分享设备
 * @param account 账号
 * @param deviceID device ID
 * @param phoneCode 国家电话号码区号
 * @param callback Function callback
 */
public void cancelShareDevice(String account, String deviceID, String phoneCode, IResultCallback callback);

【代码范例】
MeariUser.getInstance().cancelShareDevice(account, cameraInfo.getDeviceID(), phoneCode, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 7.8 删除历史分享用户
```
【描述】
删除历史分享用户

【函数调用】
/**
 * 删除历史分享用户
 * 
 * @param accountArray 用户数组
 * @param deviceID device ID
 * @param callback Function callback
 */
public void deleteHistoryShare(String accountArray, String deviceID, IResultCallback callback);

【代码范例】
MeariUser.getInstance().deleteHistoryShare(accountArray, deviceID, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 7.9 处理分享消息
```
【描述】
处理分享消息

【函数调用】
/**
 * 处理分享消息
 *
 * @param msgID 消息ID
 * @param dealFlag 0-拒绝；1-接受
 * @param callback Function callback
 */
public void dealShareMessage(long msgID, int dealFlag, IResultCallback callback);

【代码范例】
MeariUser.getInstance().dealShareMessage(msgID, dealFlag, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

# 8.消息中心
## 8.1 设备分享消息

### 8.1.1 获取设备分享消息列表
```
【描述】
获取设备分享消息列表

【函数调用】
/**
 * 获取设备分享消息列表
 *
 * @param callback Function callback
 */
public void getShareMessage(IShareMessageCallback callback);

【方法调用】

ShareMessage
- String date; 消息时间
- String msgID; 消息ID
- String state; 消息状态：1-接收；0-拒绝
- String shareName; 被分享者名称
- String deviceName; 设备名称

MeariUser.getInstance().getShareMessage(new IShareMessageCallback() {
    @Override
    public void onSuccess(ArrayList<ShareMessage> shareMessages) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 8.1.2 删除设备分享消息
```
【描述】
删除设备分享消息

【函数调用】
/**
 * 删除设备分享消息
 *
 * @param msgIDList Message ID array
 * @param callback Function callback
 */
public void deleteShareMessage(List<String> msgIDList, IResultCallback callback);

【方法调用】

MeariUser.getInstance().deleteShareMessage(msgIDList, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```
## 8.2 设备报警消息

### 8.2.1 获取所有设备是否有消息
```
【描述】
获取所有设备是否有消息

【函数调用】
/**
 * 获取所有设备是否有报警消息
 *
 * @param callback function callback
 */
public void getDeviceMessageStatusList(IDeviceMessageStatusCallback callback);

【方法调用】

DeviceMessageStatus
- long deviceID;  设备ID
- String deviceName; 设备名称
- String snNum; 设备SN
- String deviceIcon; 设备图标
- boolean hasMessage; 该设备是否有报警消息

MeariUser.getInstance().getDeviceMessageStatusList(new IDeviceMessageStatusCallback() {
    @Override
    public void onSuccess(List<DeviceMessageStatus> deviceMessageStatusList) {
        //如果设备有报警消息，则可以获取报警消息
    }

    @Override
    public void onError(int code, String error) {

    }
});
```

### 8.2.2 获取单个设备的报警消息
```
【描述】
获取单个设备的报警消息

【函数调用】
/**
 * 获取单个设备的报警消息（一次获取最新的20条，设备主人拉取后，服务器删除数据，注意保存数据）
 *
 * @param deviceId device id
 * @param day 日期 yyyyMMdd
 * @param callback function callback
 */
public void getAlertMsg(long deviceID, String day, IDeviceAlarmMessagesCallback callback);

【方法调用】

class DeviceAlarmMessage:
- long deviceID;//设备ID
- String deviceUuid;//设备唯一标识符
- String imgUrl;// 报警图片地址
- int imageAlertType;//报警类型（PIR和Motion）
- int msgTypeID;//消息类型
- long userID;//用户Id
- long userIDS;//分享设备时为0，否则为用户Id
- String createDate;//上传时间
- String isRead;//是否已读
- String tumbnailPic;//缩略图
- String decibel;//分贝
- long msgID;//消息Id


MeariUser.getInstance().getAlertMsg(getMsgInfo().getDeviceID(), day, new IDeviceAlarmMessagesCallback() {
    @Override
    public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo) {

    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 8.3 系统消息

### 8.3.1 获取系统消息列表
```
【描述】
获取系统消息列表

【函数调用】
/**
 * 获取系统消息列表
 *
 * @param callback function callback
 */
public void getSystemMessage(ISystemMessageCallback callback);

【方法调用】

class SystemMessage:
- long msgID; //消息Id
- int msgTypeID;//消息类型
- String isRead;//是否已读
- Date createDate;//创建时间时间
- Date updateDate;//更新时间
- long userID;//用户Id
- String userAccount;//用户账号
- String nickName;//用户呢称
- String delState;//是否处理
- long deviceID;//设备Id
- String deviceName;//设备呢称
- String deviceUUID;//设备标识符
- long userIDS;//请求者Id
- String imageUrl;//头像

MeariUser.getInstance().getSystemMessage(new ISystemMessageCallback() {
    @Override
    public void onSuccess(List<SystemMessage> systemMessageList) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 8.3.2 删除系统消息
```
【描述】
删除系统消息

【函数调用】
/**
 * delete system message by message ID
 * 删除系统消息
 *
 * @param msgIdList   message id
 * @param callback function callback
 */
public void deleteSystemMessage(List<String> msgIdList, final IResultCallback callback);

【方法调用】

MeariUser.getInstance().deleteSystemMessage(msgIdList, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

# 9.设备设置
用于设置摄像机的侦测报警，休眠模式，本地回放等等。
不同的设备是否支持某种设置，可以通过设备的能力集来判断


## 9.1 设备能力集
if (cameraInfo.getLed() == 1) {
    // 支持LED等的开关设置
} else {
    // 不支持LED等的开关设置
}

设备能力集

- int dcb; 噪声报警：0-不支持；1-支持
- int pir; 人体侦测：0-不支持；1-支持PIR使能开关+设置选项(高中低),；2-只支持PIR的使能开关；3-预留；4-支持PIR使能开关+设置选项(高低), 5-支持双PIR的使能开关(左和右)+统一的灵敏度设置选项(高低)(用于常电设备，如Flight 4T)；6-支持双PIR的使能开关(左和右)+统一的灵敏度设置选项(高低)(用于低功耗设备，如Flight 3T)；7-支持pir使能开关+pir灵敏度档位设置（10档）； 8-支持pir使能开关+pir灵敏度档位设置，支持图形档位显示，具体档位有多少可以参照plv字段，默认10档
- int plv；pir等级设置使能开关，用于多级设置开关1-N档，0-不支持，10-支持10档（1-10）
- int md;  移动侦测：0-不支持；1-支持
- int cst; 云存储  ：0-不支持；1-支持
- int dnm; 日夜模式：0-不支持；1-支持
- int led; LED灯   ：0-不支持；1-支持
- int flp; 视频翻转：0-不支持；1-支持
- int bcd; 哭声检测：0-不支持；1-支持
- int ptr; 人形跟踪：0-不支持；1-支持
- int pdt; 人形检测：0-不支持；bit0=支持开关设置；bit1=支持画框开关设置；bit2=支持夜间过滤开关设置；bit3=支持白天过滤开关设置
- int ptz; 云台：0-不支持；1-支持左右；2-支持上下；3.支持上下左右


## 9.2 设备参数

DeviceParams

- String firmwareCode;  固件代号  ppstrong-c2-neutral-1.0.0.20190617
- String firmwareVersion;  固件版本号  1.0.0
- String wifiName;  设备连接的WiFi名称
- int wifiStrength;  设备连接的WiFi强度：0至100；
- int netMode;  当前网络模式：0-无线；1-有线；2-4G；3-未知
- int ledEnable;  LED 指示灯状态：0-关；1-开；
- int mirrorEnable;  视频翻转：0-正常；1-翻转；
- int sdRecordType;  SD卡录像类型：0-事件录像；1-全天录像；
- int sdRecordDuration;  SD卡录像时间(秒)：20，30，40，60，120，180
- int dayNightMode;  日夜模式：0-自动；1-白天模式；2-夜间模式；
- int sleepMode;  休眠模式：0-不休眠；1-休眠；2-定时休眠；3-地理围栏休眠；
- String sleepTimeList;  定时休眠时间列表：json数组
- String sleepWifi;   地理围栏休眠的WiFi
- int motionDetEnable;  移动侦测使能开关：0-关；1-开；
- int motionDetSensitivity;  移动侦测灵敏度：0-低；1-中；2-高；
- int PirDetEnable;  人体侦测使能开关：0-关；1-开；
- int PirDetSensitivity;  人体侦测灵敏度：0-低；1-中；2-高；
- int soundDetEnable;  声音报警使能开关：0-关；1-开；
- int soundDetSensitivity;  声音报警灵敏度：0-低；1-中；2-高；
- int cryDetEnable;  哭声检测使能开关：0-关；1-开；
- int humanDetEnable;  人形侦测使能开关：0-关；1-开；
- int humanFrameEnable;  人形画框使能开关：0-关；1-开；
- int humanTrackEnable;  人形跟踪使能开关：0-关；1-开；
- int onvifEnable;  Onvif使能开关：0-关；1-开；
- String onvifPwd;   Onvif密码
- String onvifUrl;  Onvif服务网络地址
- int h265Enable;  H265使能开关：0-H264；1-H265
- String alarmPlanList;  报警计划时间列表：json数组
- int temperature;  温度
- int humidity;  湿度
- int speakVolume;  对讲时(门铃、电池摄像机)的喇叭音量：0-100
- int powerType;  供电方式：0-电池；1-电源；2-电池加电源
- int batteryPercent;  电池电量百分比：0-100
- int batteryRemaining;  电池剩余可用时长：分钟（不准确，暂时不用）
- int chargeStatus;  电池充电状态：0-未充电；1-充电中；2-充满
- int wirelessChimeEnable;  无线铃铛使能开关：0-关；1-开
- int wirelessChimeVolume;  无线铃铛音量：0-100
- String wirelessChimeSongs;  无线铃铛歌曲列表：["song1", "song2", "song3"]


## 9.3 格式化设备SD卡
```
【描述】
设备格式化SD卡，格式化成功后，通过mqtt消息获取格式化进度。

【函数调用】
/**
 * 获取设备SD卡信息
 *
 * @param callback Function callback
 */
public void getSDCardInfo(ISDCardInfoCallback callback);

/**
 * 开始格式化SD卡
 *
 * @param callback Function callback
 */
public void startSDCardFormat(ISDCardFormatCallback callback);

/**
 * 获取格式化SD卡进度
 *
 * @param callback Function callback
 */
public void getSDCardFormatPercent(ISDCardFormatPercentCallback callback)

【代码范例】


SDCardInfo
- sdStatus   SD卡状态   0：无SD卡；1：正常使用；2：卡读写异常；3：格式化中；4：文件系统不支持；5：卡正在识别；6：未格式化；7：其他错误；
- sdCapacity   SD卡总容量
- sdRemainingCapacity  SD卡剩余容量

// 获取设备SD卡信息
MeariUser.getInstance().getSDCardInfo(new ISDCardInfoCallback() {
    @Override
    public void onSuccess(SDCardInfo sdCardInfo) {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});

// 开始格式化SD卡
MeariUser.getInstance().startSDCardFormat(new ISDCardFormatCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});

// 获取格式化SD卡进度
MeariUser.getInstance().getSDCardFormatPercent(new ISDCardFormatPercentCallback() {
    @Override
    public void onSuccess(int percent) {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

## 9.4 升级设备固件
```
【描述】
升级设备固件

【函数调用】

DeviceUpgradeInfo
- boolean forceUpgrade;  是否强制升级
- int upgradeStatus;     是否可以升级 0-不可以；1-可以
- String newVersion;     新版本
- String upgradeDescription;  新版本描述
- String upgradeUrl;     新版本地址

/**
 * 查询设备是否有新版本
 *
 * @param devVersion 设备版本
 * @param licenseID  设备sn
 * @param tp         设备tp
 * @param callback   callback
 */
public void checkNewFirmwareForDev(String devVersion, String licenseID, String tp, ICheckNewFirmwareForDevCallback callback)

/**
 * 开始升级设备固件
 *
 * @param upgradeUrl 升级地址
 * @param upgradeVersion 升级版本
 * @param callback Function callback
 */
public void startDeviceUpgrade(String upgradeUrl, String upgradeVersion, IDeviceUpgradeCallback callback);

/**
 * 获取升级固件的进度
 *
 * @param callback Function callback
 */
public void getDeviceUpgradePercent(IDeviceUpgradePercentCallback callback);

/ **
 * @param deviceID 设备id
 * @param callback Function callback
 * /
public void getDeviceFirmwareVersion(String deviceID, IStringResultCallback callback)


【代码范例】
如果没有获取设备参数，先调用MeariUser.getInstance().getDeviceParams()
DeviceParams deviceParams = getCachedDeviceParams()
String firmwareVersion = deviceParams.getFirmwareCode()
MeariUser.getInstance().checkNewFirmwareForDev(firmwareVersion, cameraInfo.getSnNum, cameraInfo.getTp(), new ICheckNewFirmwareForDevCallback() {
    @Override
    public void onSuccess(DeviceUpgradeInfo info) {
        // 如果info.getUpgradeStatus() != 0, 有新版本
    }

    @Override
    public void onError(int code, String error) {
    }
});

// 如果可以升级，开始升级
MeariUser.getInstance().startDeviceUpgrade(deviceUpgradeInfo.getUpgradeUrl(), deviceUpgradeInfo.getNewVersion(), new IDeviceUpgradeCallback() {
    @Override
    public void onSuccess() {

    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {

    }
});

// 获取升级进度
MeariUser.getInstance().getDeviceUpgradePercent(new IDeviceUpgradePercentCallback() {
    @Override
    public void onSuccess(int percent) {

    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {

    }
});

// 获取设备当前固件版本
MeariUser.getInstance().getDeviceFirmwareVersion(cameraInfo.getDeviceID(), new IStringResultCallback() {

            @Override
            public void onSuccess(String result) {
                try {
                    BaseJSONObject object = new BaseJSONObject(result);
                    BaseJSONObject resultObject = object.optBaseJSONObject("result");
                    String currentVersion = resultObject.optString("devVersion");
                    int protocolVersion = resultObject.optInt("protocolVersion");
                    if (currentVersion.equals(deviceUpgradeInfo.getNewVersion())) {
                        // 重启结束
                        CameraInfo cameraInfo = MeariUser.getInstance().getCameraInfo();
                        // 更新cameraInfo
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


## 9.5 基本参数设置

### 9.5.1 获取设备参数
```
【描述】
获取设备的所有参数

【函数调用】
/**
 * 获取设备的参数
 *
 * @param callback Function callback
 */
public void getDeviceParams(IGetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().getDeviceParams(new IGetDeviceParamsCallback() {
    @Override
    public void onSuccess(DeviceParams deviceParams) {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.2 设备LED灯开关控制
```
【描述】
设备LED灯开关控制

【函数调用】
/**
 * 设置LED灯打开或关闭
 *
 * @param ledEnable 0-off; 1-on
 * @param callback Function callback
 */
public void setLED(int ledEnable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setLED(ledEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.3 设备预览视频翻转控制
```
【描述】
设备预览视频翻转控制

【函数调用】
/**
 * 设置视频是否镜像
 *
 * @param mirrorEnable 0-normal;1-mirror
 * @param callback Function callback
 */
public void setMirror(int mirrorEnable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setMirror(mirrorEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.4 设备本地录像设置
```
【描述】
设备本地录像类型和事件录像片段时间设置

【函数调用】
/**
 * 设置设备SD卡录制视频
 *
 * @param type Recording type
 * @param duration Event recording time
 * @param callback Function callback
 */
public void setPlaybackRecordVideo(int type, int duration, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setPlaybackRecordVideo(type, duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.5 设备日夜模式设置
```
【描述】
设备日夜模式设置

【函数调用】
/**
 * 设置日夜模式
 *
 * @param mode mode
 * @param callback Function callback
 */
public void setDayNightMode(int mode, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setDayNightMode(mode, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.6 设备休眠模式设置
```
【描述】
设备休眠模式设置

【函数调用】
/**
 * 设置休眠模式
 *
 * @param mode mode
 * @param callback Function callback
 */
public void setSleepMode(int mode, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setSleepMode(sleepMode, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.7 设备定时休眠时间段设置
```
【描述】
设备定时休眠时间段设置

【函数调用】
/**
 * 设置休眠的时间段
 *
 * @param timeList the period of sleep
 * @param callback Function callback
 */
public void setSleepModeTimes(String timeList, ISetDeviceParamsCallback callback);

【代码范例】

timeList说明：
enable：是否启用
start_time：开始时间点
stop_time：结束时间点
repeat：每周生效的天数1~7

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

MeariUser.getInstance().setSleepModeTimes(timeList, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.8 设备移动侦测设置
```
【描述】
设备移动侦测设置

【函数调用】
/**
 * 设置移动侦测
 *
 * @param motionDetEnable motion detection enable
 * @param motionDetSensitivity motion detection sensitivity
 * @param callback Function callback
 */
public void setMotionDetection(int motionDetEnable, int motionDetSensitivity, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setMotionDetection(motionDetEnable, motionDetSensitivity, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.9 设备PIR侦测设置
```
【描述】
设备PIR侦测设置

【函数调用】
/**
 * 设置PIR
 *
 * @param pirDetEnable PIR detection enable
 * @param pirDetSensitivity PIR detection sensitivity
 * @param callback Function callback
 */
public void setPirDetection(int pirDetEnable, int pirDetSensitivity, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setPirDetection(pirDetEnable, pirDetSensitivity, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.10 设备噪声侦测设置
```
【描述】
设备噪声侦测设置

【函数调用】
/**
 * 设置声音侦测
 *
 * @param soundDetEnable sound detection enable
 * @param soundDetSensitivity sound detection sensitivity
 * @param callback Function callback
 */
public void setSoundDetection(int soundDetEnable, int soundDetSensitivity, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setSoundDetection(soundDetEnable, soundDetSensitivity, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.11 设备哭声报警设置
```
【描述】
设备哭声报警设置

【函数调用】
/**
 * 设置哭声侦测
 *
 * @param cryDetEnable cry detection
 * @param callback Function callback
 */
public void setCryDetection(int cryDetEnable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setCryDetection(cryDetEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.12 设备人形跟踪设置
```
【描述】
设备人形跟踪设置

【函数调用】
/**
 * 设置人形追踪
 *
 * @param humanTrackEnable human track enable
 * @param callback Function callback
 */
public void setHumanTrack(int humanTrackEnable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setHumanTrack(humanTrackEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.13 设备人形侦测报警设置
```
【描述】
设备人形侦测报警设置

【函数调用】
/**
 * 设置人形侦测
 *
 * @param humanDetEnable human detection enable
 * @param callback Function callback
 */
public void setHumanDetection(int humanDetEnable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setHumanDetection(humanDetEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.14 设备人形框设置
```
【描述】
设备人形框设置

【函数调用】
/**
 * 设置人形画框
 *
 * @param humanFrameEnable human frame enable
 * @param callback Function callback
 */
public void setHumanFrame(int humanFrameEnable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setHumanFrame(humanFrameEnable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.15 设备Onvif设置
```
【描述】
设备Onvif设置

【函数调用】
/**
 * 设置onvif
 *
 * @param enable onvif enable
 * @param password onvif password
 * @param callback Function callback
 */
public void setOnvif(int enable, String password, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setOnvif(enable, password, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.16 设备视频编码格式设置
```
【描述】
设备视频编码格式设置

【函数调用】
/**
 * 设置视频编码类型
 *
 * @param enable H265 enable
 * @param callback Function callback
 */
public void setVideoEncoding(int enable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setVideoEncoding(enable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.17 设备转动控制
```
【描述】
设备转动控制

【函数调用】

/**
 * 开始转动
 *
 * @param direction 转动方向
 */
public void startPTZControl(String direction);

/**
 * 停止转动
 *
 */
public void stopPTZControl();

【代码范例】

MeariMoveDirection.LEFT
MeariMoveDirection.RIGHT
MeariMoveDirection.UP
MeariMoveDirection.DOWN
MeariUser.getInstance().startPTZControl(MeariMoveDirection.LEFT);
MeariUser.getInstance().stopPTZControl();
```

### 9.5.18 设备报警计划时间段设置
```
【描述】
设备报警计划时间段设置

【函数调用】
/**
 * 设置报警的时间段
 *
 * @param timeList he time period of the alarm
 * @param callback Function callback
 */
public void setAlarmTimes(String timeList, ISetDeviceParamsCallback callback);

【代码范例】

if (cameraInfo.getAlp() > 0) {
    // 支持
} else {
    // 不支持
}

String listString = deviceParams.getAlarmPlanList();

// 最多支持4组
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

### 9.5.19 设备推送消息开关设置
```
【描述】
设备推送消息开关设置

【函数调用】
/**
 * 设备推送消息开关设置
 *
 * @param deviceId device id
 * @param status   0-on; 1-off
 * @param callback callback
 */
public void closeDeviceAlarmPush(String deviceId, int status, IPushStatusCallback callback);

【代码范例】

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

## 9.6 门铃参数设置
### 9.6.1 设备对讲音量设置
```
【描述】
设备对讲音量设置

【函数调用】
/**
 * 设置设备对讲音量
 *
 * @param volume intercom volume
 * @param callback Function callback
 */
public void setSpeakVolume(int volume, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setSpeakVolume(volume, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.6.2 解锁电池锁
```
【描述】
解锁电池锁

【函数调用】
/**
 * 解锁电池锁
 *
 * @param callback Function callback
 */
public void unlockBattery(ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().unlockBattery(new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.6.3 绑定无线铃铛
```
【描述】
绑定无线铃铛

【函数调用】
/**
 * 绑定无线铃铛
 *
 * @param callback Function callback
 */
public void bindWirelessChime(ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().bindWirelessChime(new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.6.4 解绑无线铃铛
```
【描述】
解绑无线铃铛

【函数调用】
/**
 * 解绑无线铃铛
 *
 * @param callback Function callback
 */
public void unbindWirelessChime(ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().unbindWirelessChime(new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.6.5 无线铃铛是否工作设置
```
【描述】
无线铃铛是否工作设置

【函数调用】
/**
 * 设置无线铃铛是否工作
 *
 * @param enable wireless chime enable
 * @param callback Function callback
 */
public void setWirelessChimeEnable(int enable, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setWirelessChimeEnable(enable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```


### 9.6.6 无线铃铛音量设置
```
【描述】
无线铃铛音量设置

【函数调用】
/**
 * 设置无线铃铛音量
 *
 * @param volume wireless chime volume
 * @param callback Function callback
 */
public void setWirelessChimeVolume(int volume, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setWirelessChimeVolume(volume, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.6.7 无线铃铛铃声设置
```
【描述】
无线铃铛铃声设置

【函数调用】
/**
 * 设置无线铃铛铃声
 *
 * @param song wireless chime ringtone
 * @param callback Function callback
 */
public void setWirelessChimeSong(String song, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setWirelessChimeSong(song, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.6.8 机械铃铛是否工作设置
```
【描述】
机械铃铛是否工作设置

【函数调用】
/**
 * 设置机械铃铛打开或关闭
 *
 * @param status   0-off; 1-on
 * @param callback Function callback
 */
public void setMechanicalChimeEnable(int status, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setMechanicalChimeEnable(enable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

## 9.7 泛光灯摄像机参数设置
### 9.7.1 灯具摄像机开关灯设置
```
【描述】
灯具摄像机开关灯设置

【函数调用】
/**
 * 设置灯具摄像机开关灯
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightLightStatus(int status, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightLightStatus(enable, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.2 灯具摄像机报警开关设置
```
【描述】
灯具摄像机报警开关设置

【函数调用】
/**
 * 设置灯具摄像机报警开关
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightSirenEnable(int status, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightSirenEnable(status, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.3 灯具摄像机联动照明开关设置
```
【描述】
灯具摄像机联动照明开关设置

【函数调用】
/**
 * 设置灯具摄像机联动照明开关
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightLinkLightingEnable(int status, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightLinkLightingEnable(status, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.4 灯具摄像机联动照明持续时间设置
```
【描述】
灯具摄像机联动照明持续时间设置

【函数调用】
/**
 * 设置灯具摄像机联动照明持续时间
 *
 * @param duration 持续时间
 * @param callback Function callback
 */
public void setFlightPirDuration(int duration, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightPirDuration(duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.5 灯具摄像机照明计划设置
```
【描述】
灯具摄像机照明计划设置

【函数调用】
/**
 * 设置灯具摄像机照明计划
 *
 * @param enable 照明计划开关
 * @param from   照明计划开始时间
 * @param to     照明计划结束时间
 * @param callback Function callback
 */
public void setFlightSchedule(int enable, String from, String to, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightSchedule(enable, from, to, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.6 灯具摄像机亮度设置
```
【描述】
灯具摄像机亮度设置

【函数调用】
/**
 * 设置灯具摄像机亮度
 *
 * @param brightness 亮度
 * @param callback Function callback
 */
public void setFlightBrightness(int brightness, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightBrightness(brightness, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.7 灯具摄像机手动亮灯时长设置
```
【描述】
手动亮灯时长设置

【函数调用】
/**
 * 设置手动亮灯时长
 *
 * @param duration  持续时间
 * @param callback Function callback
 */
public void setFlightManualLightingDuration(int duration, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightManualLightingDuration(duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```
### 9.7.8 灯具摄像机联动报警开关设置
```
【描述】
灯具摄像机联动报警设置

【函数调用】
/**
 * 设置灯具摄像机联动报警
 *
 * @param status  0-off; 1-on
 * @param callback Function callback
 */
public void setFlightLinkSirenEnable(int status, ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setFlightLinkSirenEnable(status, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

# 10.MQTT和推送

```
meari SDK 支持内部的MQTT推送消息，也支持FCM等厂商推送（后续会陆续支持）
```

## 10.1 MQTT消息
```
用于接收设备添加成功消息、门铃呼叫消息、语音门铃呼叫消息、异地登录等消息
```

### 10.1.1 连接MQTT服务

// 用户登录成功后调用
MeariUser.getInstance().connectMqttServer(application);

### 11.1.2 退出MQTT服务

// 用户登出登录成功后调用
MeariUser.getInstance().disConnectMqttService();

### 11.1.3 MQTT消息处理

```
SDK初始化时，需要传入实现MqttMessageCallback接口的内，即demo中的MyMessageHandler。
在MqttMessageCallback接口的实现类中处理MQTT(参考 Demo MyMessageHandler)

/**
 * 其他消息
 * @param messageId 消息ID
 * @param message 消息内容
 */
void otherMessage(int messageId, String message);

/**
 * 异地登录
 */
void loginOnOtherDevices();

/**
 * 主人取消或删除分享设备
 * @param deviceId 设备ID
 * @param deviceName 设备名称
 */
void onCancelSharingDevice(String deviceId, String deviceName);

/**
 * 设备取消绑定(电商解绑)
 */
void deviceUnbundled();

/**
 * 门铃呼叫
 * @param bellJson 门铃信息
 * @param isUpdateScreenshot 是否是更新截图的消息
 */
void onDoorbellCall(String bellJson, boolean isUpdateScreenshot);

/**
 * 添加设备成功
 */
void addDeviceSuccess(String message);

/**
 * 添加设备失败
 */
void addDeviceFailed(String message);

/**
 * 添加设备失败，设备未解绑导致添加失败
 */
void addDeviceFailedUnbundled(String message);

/**
 * 收到某人分享的设备
 */
void ReceivedDevice(String message);

/**
 * 请求接收某人分享的设备
 * @param userName 用户名称
 * @param deviceName 设备名称
 * @param msgID 消息ID
 */
void requestReceivingDevice(String userName, String deviceName, String msgID);

/**
 * 请求分享设备给某人
 * @param userName 用户名称
 * @param deviceName 设备名称
 * @param msgID 消息ID
 */
void requestShareDevice(String userName, String deviceName, String msgID);
```

## 10.2 集成谷歌推送
首先, 参考教程: [Add Firebase to your Android project](https://firebase.google.com/docs/android/setup) 和 [Set up a Firebase Cloud Messaging client app on Android](https://firebase.google.com/docs/cloud-messaging/android/client), 把firebase设置界面生成的admin sdk文件发送给meari服务器配置，在app中获取fcm token并调用MeariUser.getInstance().upload(1, token, callback)上传token

## 10.3 集成其他推送
```
暂不支持
```

# 更新说明：
2020-03-13 wu: 2.2.0 SDK接入指南初稿完成
