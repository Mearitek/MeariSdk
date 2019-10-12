[TOC]

# 1.功能概述
觅睿科技APP SDK提供了与硬件设备、觅睿云通讯的接口封装，加速应用开发过程，主要包括以下功能：

- 硬件设备相关（配网、控制、状态上报、固件升级、预览回放等功能）
- 账户体系（手机号、邮箱的注册、登录、重置密码等通用账户功能）
- 设备共享
- 好友管理
- 消息中心
- 意见反馈
- 觅睿云HTTPS API接口封装（参见觅睿云api调用）

--------------

# 2.集成准备
## 创建App ID和App Secert
```
觅睿科技云平台提供网页自动创建App ID和App Secert，用于用户SDK开发,AndroidManifest中配置
<meta-data
    android:name="MEARI_APPKEY"
    android:value="您的MEARI_APPKEY" />
<meta-data
    android:name="MEARI_SECRET"
    android:value="您的MEARI_SECRET" />
```
--------------

# 3.集成SDK
## 3.1 集成准备
### （1）创建工程
```
在Android Studio中建立你的工程
```

### （2）引入sdk包
```
在工程中新建一个libs目录，将下载好的ppsplayer-app-sdk中的libs下的包拷贝到libs目录中。同时
在工程的src目录下，将ppsplayer-app-sdk中的java下的文件拷贝到src目录下

```

### （3）build.gradle配置

build.gradle文件里添加如下配置
```
repositories {
    flatDir {
        dirs 'libs'
    }
}
android {
     sourceSets {
        main {
            jniLibs.srcDirs = ['libs']
        }
    }
}
dependencies {
    compile(name: 'mearisdk-1.0.0', ext: 'aar')
    //=====依赖库 必要 ====//
    compile 'com.squareup.okhttp3:okhttp:3.7.0'
    compile 'com.squareup.okio:okio:1.9.0'
    compile 'org.eclipse.paho:org.eclipse.paho.client.mqttv3:1.2.0'
}
```

### （4）AndroidManifest.xml 设置
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

    <permission
        android:name="${applicationId}.permission.JPUSH_MESSAGE"
        android:protectionLevel="signature" />

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

极光推送配置
 <!-- Rich push 核心功能 since 2.0.6-->
        <activity
            android:name="cn.jpush.android.ui.PopWinActivity"
            android:theme="@style/MyDialogStyle"
            android:exported="false">
        </activity>

        <!-- Required SDK核心功能-->
        <activity
            android:name="cn.jpush.android.ui.PushActivity"
            android:configChanges="orientation|keyboardHidden"
            android:theme="@android:style/Theme.NoTitleBar"
            android:exported="false">
            <intent-filter>
                <action android:name="cn.jpush.android.ui.PushActivity" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="com.meari.test" />
            </intent-filter>
        </activity>

        <!-- Required SDK 核心功能-->
        <!-- 可配置android:process参数将PushService放在其他进程中 -->
        <service
            android:name="cn.jpush.android.service.PushService"
            android:process=":mult"
            android:exported="false">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.REGISTER" />
                <action android:name="cn.jpush.android.intent.REPORT" />
                <action android:name="cn.jpush.android.intent.PushService" />
                <action android:name="cn.jpush.android.intent.PUSH_TIME" />
            </intent-filter>
        </service>
        <!-- since 3.0.9 Required SDK 核心功能-->
        <provider
            android:authorities="com.meari.test.DataProvider"
            android:name="cn.jpush.android.service.DataProvider"
            android:exported="false"
            />

        <!-- since 1.8.0 option 可选项。用于同一设备中不同应用的JPush服务相互拉起的功能。 -->
        <!-- 若不启用该功能可删除该组件，将不拉起其他应用也不能被其他应用拉起 -->
        <service
            android:name="cn.jpush.android.service.DaemonService"
            android:enabled="true"
            android:exported="true">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.DaemonService" />
                <category android:name="com.meari.test" />
            </intent-filter>

        </service>
        <!-- since 3.1.0 Required SDK 核心功能-->
        <provider
            android:authorities="com.meari.test.DownloadProvider"
            android:name="cn.jpush.android.service.DownloadProvider"
            android:exported="true"
            />
        <!-- Required SDK核心功能-->
        <receiver
            android:name="cn.jpush.android.service.PushReceiver"
            android:enabled="true"
            android:exported="false">
            <intent-filter android:priority="1000">
                <action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED_PROXY" />   <!--Required  显示通知栏 -->
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

        <!-- Required SDK核心功能-->
        <receiver android:name="cn.jpush.android.service.AlarmReceiver" android:exported="false"/>

        <!-- User defined.  For test only  用户自定义的广播接收器-->
        <receiver
            android:name=".receiver.MyReceiver"
            android:exported="false"
            android:enabled="true">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.REGISTRATION" /> <!--Required  用户注册SDK的intent-->
                <action android:name="cn.jpush.android.intent.MESSAGE_RECEIVED" /> <!--Required  用户接收SDK消息的intent-->
                <action android:name="cn.jpush.android.intent.NOTIFICATION_RECEIVED" /> <!--Required  用户接收SDK通知栏信息的intent-->
                <action android:name="cn.jpush.android.intent.NOTIFICATION_OPENED" /> <!--Required  用户打开自定义通知栏的intent-->
                <action android:name="cn.jpush.android.intent.CONNECTION" /><!-- 接收网络变化 连接/断开 since 1.6.3 -->
                <category android:name="com.meari.test" />
            </intent-filter>
        </receiver>

        <!-- User defined.  For test only  用户自定义接收消息器,3.0.7开始支持,目前新tag/alias接口设置结果会在该广播接收器对应的方法中回调-->
        <receiver android:name=".receiver.MyJPushMessageReceiver">
            <intent-filter>
                <action android:name="cn.jpush.android.intent.RECEIVE_MESSAGE" />
                <category android:name="com.meari.test"></category>
            </intent-filter>
        </receiver>
        <!-- Required  . Enable it you can get statistics data with channel -->
        <meta-data android:name="JPUSH_CHANNEL" android:value="developer-default"/>
        <meta-data android:name="JPUSH_APPKEY" android:value="" /> 
````
## 3.2在代码中使用SDK功能（MeariSdk工具类）
### （1）Application中初始化觅睿科技sdk
```
【描述】
    主要用于初始化内部资源、通信服务、重定向、日志记录等功能。
 
【函数调用】
    /*
     *param[in] context 
     *param[in] callback 收到消息回调
     */
    MeariSdk.init(Contex context, IMessageCallback callback);

【代码范例】
	IMessageCallback callback = new IMessageCallback();
    public class MeariSmartApp extends Application {
        @Override
        public void onCreate() {
            super.onCreate();
            MeariSdk.init(this ,callback);
        }
    }
```

### （2）注销觅睿科技云连接
```
【描述】
    在退出应用或者退出登陆的时候调用以下接口注销掉。
    /*
     *param[in] IResultCallback callback 收到网络请求消息回调
     */
    MeariUser.getInstance().logout(IResultCallback callback);
【代码范例】
  MeariUser.getInstance().logout(new IResultCallback() {
                @Override
                public void onSuccess() {
                    stopProgressDialog();
                    loginOut();//相关退出操作
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });
```

# 4.用户管理（MeariUser工具类）
## 4.1 用户手机/邮箱密码登陆
```
觅睿科技提供手机/邮箱密码登陆体系
```

### （1）手机/邮箱密码注册
```
【描述】
    手机密码注册。目前仅支持国内手机注册。

【函数调用】
    //获取手机验证码
	 /**
     * 获取手机验证码
     *
     * @param countryCode 国家代号
     * @param phoneCode   国家电话号码区号
     * @param account     账户
     * @paramI ValidateCallback 网络请求返回
     */
      public void getValidateCode(String countryCode, String phoneCode, String account, final IValidateCallback callback);
	  
	  
     /**
     * 注册账户
     *
     * @param countryCode 国家代号
     * @param phoneCode   国家电话号码区号
     * @param account     账户
     * @param pwd         密码
     * @param nickname    呢称
     * @param code        验证码
     * @param callback    返回回调
     */
    public void registerAccount(String countryCode, String phoneCode, String account, String pwd, String nickname, String code, IRegisterCallback callback);
【代码范例】
	//获取手机验证码
	MeariUser.getInstance().getValidateCode( countryCode,phoneCode,  account, new IValidateCallback() {
            @Override
            public void onSuccess(int leftTime) {
                stopProgressDialog();
                startTimeCount(leftTime);//leftTime 表示验证码剩余有效时间
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });

	//注册账户
	MeariUser.getInstance().registerAccount(countryCode,phoneCode,account,pwd,nickname,code, new IRegisterCallback() {
            @Override
            public void onSuccess(UserInfo user) {
                //UserInfo 返回用户信息                        
            }

            @Override
            public void onError(int code, String error) {
            }
        });
    MeariUser.getInstance().getValidateCode(String countryCode, String phoneNumber, final IValidateCallback callback);

```

### （2）手机/邮箱密码登陆
```
【描述】
    支持国内手机密码登陆。
 
【函数调用】
    //登陆
	/**
	 * 登陆账户
     * @param countryCode 国家代号
     * @param phoneCode   国家电话号码区号
     * @param username    国内电话/邮箱
     * @param password    用户密码
     * @param callback    登陆回调接口 返回用户信息
	 */
    MeariUser.getInstance().login(String countryCode, String phoneCode,String username, String password, final ILoginCallback callback)
    
【代码范例】
   MeariUser.getInstance().login(countryCode,phoneCode, username, password, new ILoginCallback() {
                @Override
                public void onSuccess(UserInfo user) {
                    stopProgressDialog();
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });
```

### （3）密码重置密码
```
【描述】
    仅支持通邮箱和/国内手机重置密码（包含忘记密码和重设密码）。
 
【函数调用】
    //获取手机验证码
    * @param countryCode   国家区号
    * @param username      手机号码/邮箱
    MeariUser.getInstance().getValidateCode(String countryCode, String username, final IValidateCallback callback);
    
    /**
	 * 登陆账户
     * @param countryCode 国家代号
     * @param phoneCode   国家电话号码区号
     * @param account     国内电话/邮箱
     * @param password    用户新密码密码
     * @param callback    登陆回调接口 返回用户信息
	 */
    public void resetAccountPassword(String countryCode, String phoneCode, String account, String verificationCode, String password, final IResetPasswordCallback callback);
    
【代码范例】
    //重置密码
     MeariUser.getInstance().resetAccountPassword(countryCode, phoneCode, account, verificationCode, password, new IResetPasswordCallback() {
            @Override
            public void onSuccess(UserInfo user) {
                if(user == null)
				{
					//表示重设密码
				}else
				{
					//表示找回密码
				}
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
            }
        });

```
## 4.3 用户uid登陆体系
```
觅睿科技提供uid登陆体系。如果客户自有用户体系，那么可以通过uid登陆体系，接入我们的sdk。
```

### （1）用户uid登录/注册
```
【描述】
    用户uid注册，uid要求唯一。
 
【函数调用】
    /**
	 * 用户uid注册
	 *
     * @param countryCode 国家号码(CN)
	 * @param phoneCode   国家电话号码区号(+86)
	 * @param uid         用户uid(用户唯一标识符，服务器生成)
     * @param password    用户密码
     * @param callback    uid 注册回调接口
	 */
    public void loginWithUid(String countryCode, String phoneCode, String uid, final ILoginCallback callback);
        
【代码范例】
    //uid注册
    MeariUser.getInstance().loginWithUid(countryCode, phoneCode,uid, new IRegisterCallback() {
        @Override
        public void onSuccess(UserInfo user) {
            Toast.makeText(mContext, "UID注册成功", Toast.LENGTH_SHORT).show();
        }
        @Override
        public void onError(String code, String error) {
            Toast.makeText(mContext, "code: " + code + "error:" + error, Toast.LENGTH_SHORT).show();
        }
    });
```

## 4.4 上传用户头像(MeariUser工具类)
```
【描述】
    上传用户头像。
 
【函数调用】
    /**
     * 上传用户头像
     *
     * @param file     用户头像图片文件路径（最好是300*300）
     * @param callback 回调
     */
    public void uploadUserAvatar(String filePath, IAvatarCallback callback);
        
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
## 4.6 修改昵称
```
【描述】
    修改用户昵称。
 
【函数调用】
    /**
     * 上传用户头像
     *
     * @param nickname 用户新昵称
     * @param callback 网络请求回调
     */
     public void renameNickname(String nickname, final IResultCallback callback) 
        
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

## 4.7 数据模型
```
用户相关的数据模型。
```

### UserInfo类

- jpushAlias  极光推送的别名
- userID      用户ID
- nickName    昵称
- phoneCode   国家区号
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

--------------

# 5.设备配网(PPSCameraPlayer工具类)
```
觅睿科技硬件模块支持三种配网模式：快连模式（TLink，简称EZ模式）、热点模式（AP模式）、二维码配网模式。
二维码和快连模式操作较为简便，建议在配网失败后，再使用热点模式作为备选方案。其中二维码配网成功率较高。
```

# 6.设备控制(MeariUser工具类)
## 6.1 设备信息获取
```
【描述】
    觅睿提供了丰富的接口供开发者实现设备信息的获取和管理能力(移除等)。设备相关的返回数据都采用异步消息的方式通知接受者。我们采
    用了EventBus的方案来实现消息通知。因此在每个设备操作页面都需要注册和销毁通知对象。具体请参考demo实现。

【函数调用】
	 /**
     * 获取所有设备列表
     *
     * @param callback 网络请求回调
     */
    MeariUser.getInstance().getDevList(IDevListCallback callback);

【代码范例】
    MeariUser.getInstance().getDevList(new IDevListCallback() {
        @Override
        public void onSuccess(MeariDevice dev) {
        }

        @Override
        public void onError(String code, String error) {

        }
    });
```
## 6.2 MeariDevice类
```
MeariDevice类管理获取设备返回列表
- List<CameraInfo>Ipc  摄像头列表
- List<NVRInfo>nvr  nvr列表
- List<CameraInfo>bell bell列表
```

class BaseDeviceInfo
- String deviceID //设备Id
- String deviceUUID //设备唯一标识符
- boolean state//设备在线状态
- String hostKey //设备密码
- String snNum//设备SN
- String deviceName//设备呢称
- String tp//设备料号
- String deviceIcon//设备图标灰色图标
- int addStatus//设备状态 1代表是自己的设备，2代表别人的微分享给设备,3代表设备可添加 4,别人的设备已分享给自己
- String deviceIconGray//设备图标灰色图标
- int protocolVersion//设备版本
- int devTypeID;//设备类型
- String userAccount;//拥有着账号
class CameraInfo
CameraInfo extends BaseDeviceInfo:
- int vtk = -1//设备能力级语音对讲:0=none, 1=speaker only, 2=mic only, 3=speaker/mic/halfduplex, 4=speaker/mic/Fullduplex
- int fcr = -1//设备能力级人脸识别：face recognize support value
- int dcb = -1//设备能力级声音报警：decibel support value
- int ptz = -1//设备能力级云台 0=not support, 1=left/right, 2=up/down, 3=left/right/up/down
- int pir = -1//设备能力级红外侦测
- int tmpr = -1//设备能力级温度temperature support value
- int md = -1//设备能力级湿度motion detect support value
- int hmd = -1//设备能力级人体 human body support value
  //门铃添加 
- String bellVoiceURL//主人留言的录音地址
- boolean pirEnable//pir开关,关：0；开：1
- int pirLevel//pir等级，1：低；2：中；3：高
- int bellVol// //门铃音量，0~100
- boolean batteryLock//电池锁开关,上锁：true；解锁：false   
- String bellPower//门铃供电方式，电池供电：battery；有线供电：wire；两者共存：both  
- int batteryPercent//剩余电量百分比，0~100   
- float batteryRemain//剩余使用时间，精确到1位小数，以小时为单位  
- String bellStatus //门铃充电状态，正在充电：charging；已充满：charged；未充电：discharing    
- int bellPwm//低功耗，这个还不确定，后期改   
- int charmVol//铃铛音量,三挡：高、中、低   
- int charmDuration//铃铛时长，这个还不确定，后期改   
- String bellSongs//门铃铃声列表   
- String bellSelectSong//已选择的铃声
- int nvrPort//NVR端口号
- String deviceID//设备id
- int trialCloud//是否试用云
- String deviceVersionID//版本号
- int nvrID//绑定nvrId
- String nvrUUID//绑定nvr uuid
- String nvrKey //绑定nvr 密码
- boolean asFriend//是否为好友设备
- String sleep//休眠模式
- long userID//设备归属的用户ID
- boolean isChecked = false//否是被选中的状态（4路 check按钮）
- String isBindingTY//isBindingTY N(未绑定)  ND(未过期)   D(过期)  Y
- String deviceType//设备类型
- boolean hasAlertMsg //服务器是否有消息
- boolean updateVersion //服务器是否有新版本
- int closePush//关闭服务器的推送
- String updatePersion //服务器是否有新版本需要设备强制升级
NVRInfo类
NVRInfo extends BaseDeviceInfo:
- int userID;//设备也有者ID
- int addStatus;//添加状态
- String tp;//账户名称
- int nvrFlag;//绑定表示 0表示取消 1：表示存在
- String nvrVersionID;//nvr设备版本号
- String nvrTypeName;//nvr设备版本号
- String nvrTypeNameGray;//nvr设备版本号
- boolean updateVersion = false;

## 6.3 设备添加
```
【描述】
    设备添加

【函数调用】
	 /**
     * 查询设备状态列表
     *
	 * @paramList<CameraInfo>cameraInfos 设备列表
     * @param callback 网络请求回调
     */
    public void checkDeviceStatus(List<CameraInfo>cameraInfos,IDeviceStatusCallback callback)
  
	/**
     * 添加设备
     *
	 * @paramList<CameraInfo>cameraInfos 设备列表
     * @param callback 网络请求回调
     */
    public void addDevice(CameraInfo cameraInfo, int deviceTypeID, IAddDeviceCallback callback);
	
	/**
     * request 分享设备
     *
     * @param cameraInfo device
     * @param callback   callback
     */
    public void requestDeviceShare(BaseDeviceInfo cameraInfo, IRequestDeviceShareCallback callback);

【代码范例】

    MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID, new IDeviceStatusCallback() {
            @Override
            public void onSuccess(ArrayList<CameraInfo> deviceList) {
            }

            @Override
            public void onError(int code, String error) {
            }
        });

    MeariUser.getInstance().addDevice(info, this.mDeviceTypeID, new IAddDeviceCallback() {
            @Override
            public void onSuccess(String sn) {
                stopProgressDialog();
               
            }

            @Override
            public void onError(int code, String error) {
                CommonUtils.showToast(error);
            }
        });
		
	MeariUser.getInstance().requestDeviceShare(info, new IRequestDeviceShareCallback() {
            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }

            @Override
            public void onSuccess(String sn) {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.waiting_deal_share));
                scanningResultAdapter.setStatusBySn(sn, 5);
                if (scanningResultAdapter.getDataCount() == 1 && !mBSearch) {
                    goBackHome();
                }
            }
        });
```
MeariDeviceStatusInfo:
```
搜索的时候的设备列表
```

## 6.4 设备移除
```
【描述】
    设备移除

【函数调用】
    devtype - 0-nvr 1-ipc 2-bell(可以自定义)
	/**
     * request 移除设备
     *
     * @param cameraInfo device
     * @param callback   callback
     */
    public void removeDevice(String devId, int deviceType, IResultCallback callback);

【代码范例】

    MeariUser.getInstance().removeDevice(devid,devtype,new IRemoveDeviceCallback()(
        @Override
        public void onSuccess() {
        }

        @Override
        public void onError(String code, String error) {
        }
    ));
```

### 6.5 设备昵称修改
```
【描述】
    设备昵称修改

【函数调用】
    devtype - 0-nvr 1-ipc 2-bell(可以自定义)
    //移除设备
    MeariUser.getInstance().renameDeviceNickName(String devid,int devtype,String nickName,IRemoveDeviceCallback callback);

【代码范例】

    MeariUser.getInstance().renameDeviceNickName(devid,devtype,nickName,new IRemoveDeviceCallback()(
        @Override
        public void onSuccess() {
        }

        @Override
        public void onError(String code, String error) {
        }
    ));
```

### 6.6 NVR绑定设备
```
【描述】
    NVR绑定设备

【函数调用】
    //绑定设备
    MeariUser.getInstance().bindDevice(int devid,int nvrid,IRemoveDeviceCallback callback);
    //解绑设备
    MeariUser.getInstance().unbindDevice(int nvrid,,List<int>devid,IunBindDeviceCallback callback);
    //查询绑定的设备列表
    MeariUser.getInstance().getBindDeviceList(int nvrid,,IGetBindDeviceList callback);

【代码范例】
    //绑定设备
    MeariUser.getInstance().bindDevice(devid,nvrid,new IRemoveDeviceCallback(){
        @Override
        public void onSuccess() {
        }

        @Override
        public void onError(String code, String error) {
        }
    });
    //解绑设备
    MeariUser.getInstance().unbindDevice(nvrid,,List<int>devid,new IunBindDeviceCallback(){
        @Override
        public void onSuccess() {
        }

        @Override
        public void onError(String code, String error) {
        }
    });
    //查询绑定的设备列表
    MeariUser.getInstance().getBindDeviceList(nvrid,new IGetBindDeviceList(){
        @Override
        public void onSuccess(List<MeariDeviceStatusInfo> list) {
        }

        @Override
        public void onError(String code, String error) {
        }
    });
```

### 6.7 单个设备某天报警时间点获取
```
【描述】
    单个设备某天报警时间点获取

【函数调用】
    /**
     * 单个设备某天报警时间点获取
     *
     * @param deviceID device id
     * @param dayTime  day time(格式YYMMDD)
     * @param callback callback
     */
    MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(int devid,String date,IDeviceAlarmMessageTimeCallback callback);

【代码范例】

    MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(devid,date,new IDeviceAlarmMessageTimeCallback()(
        @Override
        public void onSuccess(List<AlarmMessageTime> list) {
        }

        @Override
        public void onError(String code, String error) {
        }
    ));
```

class AlarmMessageTime:
```
-int StartHour;//开始时间：小时   
-int StartMinute;//开始时间：分钟 
-int StartSecond;//开始时间：秒  
-int EndHour;//结束时间：小时    
-int EndMinute;//结束时间：分钟   
-int EndSecond;//结束时间：秒  
-int bHasVideo;//有没有录像   
-int recordType;//门铃添加时间点类型，为了方便以后扩展定义成int型  
-static int TYPE_PIR = 0x1001;//PIR报警类型时间点  
-static int TYPE_MOVE = 0x1002;//移动侦测报警类型时间点  
-static int TYPE_VISIT = 0x1003;//访客报警类型时间点
```

### 6.8 查询设备是否有新版本
```
【描述】
    查询设备是否有新版本

【函数调用】
    /**
     * 查询设备是否有新版本
     *
     * @param devVersion device version
     * @param lanType    Language type
     * @param callback   callback
     */
    public void checkNewFirmwareForDev(String devVersion, String lanType, ICheckNewFirmwareForDevCallback callback);

【代码范例】
   MeariUser.getInstance().checkNewFirmwareForDev(firmware_version, CommonUtils.getLangType(this), new ICheckNewFirmwareForDevCallback() {
                @Override
                public void onSuccess(DeviceUpgradeInfo info) {
                    isShowedDlg = true;
                    mDeviceUpgradeInfo = info;
                }

                @Override
                public void onError(int code, String error) {
                    stopProgressDialog();
                    CommonUtils.showToast(error);
                }
            });
```

DeviceUpgradeInfo:

- String updatePersion;//是否需要设备强制升级
- int updateStatus;//设备能否升级
- String  serVersion ;//服务器版本
- String versionDesc;//升级描述
- String devUrl;//新固件地址

```
包含了升级的地址等
```

### 6.9 查询设备在线状态
```
【描述】
    查询设备是否有新版本

【函数调用】
/*
 * 查询设备是否在线
 *
 * @param deviceId device ID
 * @param callback callback
 *
 */
MeariUser.getInstance().checkDeviceOnline(String devid,ICheckDeviceOnlineCallback callback);

【代码范例】
    MeariUser.getInstance().checkDeviceOnline(info.getDeviceID(), new ICheckDeviceOnlineCallback() {
        @Override
        public void onSuccess(String deviceId, boolean online) {
            mAdapter.changeDeviceStatus(deviceId,online);
        }
        @Override
        public void onError(int code, String error) {
            mAdapter.changeStatusByUuid(info.getDeviceID(), -27);
        }
    });
```

### 6.10 查询音乐列表
```
【描述】
    查询音乐列表

【函数调用】
     /**
     * 查询音乐列表
     *
     * @param callback callback
     */
    MeariUser.getInstance().getMusicList(new IGetMusicListCallback());
【代码范例】
    MeariUser.getInstance().getMusicList(new IGetMusicListCallback()(
        @Override
        public void onSuccess(List<MeariMusic> list) {
        }

        @Override
        public void onError(String code, String error) {
        }
    ));
```
MeariMusicList:
```
- String musicID; //id
- int download_percent;//下载进度
- boolean is_playing;//是否处于播放状态
- String musicName;//音乐名字
- String musicFormat;//音乐格式
- String musicUrl;//音乐地址
```

### 6.11 生成配网二维码
```
【描述】
    生成配网二维码

【函数调用】

    //type -- 0-二维码  1-smartwifi
    /**
     * 获取配网临时token
     *
     * @param type     distribution type
     * @param callback callback
     */
    public void getToken(int type, IGetTokenCallback callback) {
        UserRequestManager.getInstance().getToken(type, callback);
    }
    

    /**
     * 生成配网二维码
     *
     * @param ssid     wifi名称
     * @param password wifi密码
     * @param token    配网临时token
     * @param callback callback
     */

    public void createQR(String ssid, String password, String token, ICreateQRCallback callback);
   

【代码范例】
    MeariUser.getInstance().getToken(Distribution.DISTRIBUTION_QR, new IGetTokenCallback() {
        @Override
        public void onError(int code, String error) {
            CommonUtils.showToast(error);
                stopProgressDialog();
            }
            @Override
            public void onSuccess(String token, int leftTime) {
                mToken = token;
                startTimeCount(leftTime);
                CreateQrImage();
                stopProgressDialog();
            }
        });
    }

    MeariUser.getInstance().createQR(mWifiName, mPwd, mToken, new ICreateQRCallback() {
        @Override
        public void onSuccess(Bitmap bitmap) {
            mQrImage.setImageBitmap(bitmap);
            stopProgressDialog();
        }
    });

```

### 6.12 远程唤醒门铃
```
【描述】
    远程唤醒门铃

【函数调用】
    /**
     * 远程唤醒门铃
     *
     * @param deviceId 设备Id
     * @param callback callback
     */
    public void remoteWakeUp(String deviceId, IResultCallback callback);

【代码范例】
    MeariUser.getInstance().remoteWakeUp(mCameraInfo.getDeviceID(), new IResultCallback() {
        @Override
        public void onSuccess() {
                Log.i(TAG, "请求成功返回了");
        }
        @Override
        public void onError(int code, String error) {
            CommonUtils.showToast("远程唤醒调用失败:" + error);
        }
    });
【注意事项】
    门铃类低功耗产品，需要远程唤醒先调用，在调用打洞的接口(可能需要多次打洞才通)

```

# 7.共享设备
## 7.1 好友管理
###  (1)添加好友
```
【描述】
   请求添加好友

【函数调用】
    //移除设备
    /**
     * 请求添加好友
     *
     * @param callback 返回回调
     */
    public void addFriend(String userAccount, IResultCallback callback);

【代码范例】

    MeariUser.getInstance().addFriend(accountNumFriendText, new IResultCallback() {
            @Override
            public void onSuccess() {
                stopProgressDialog();
                CommonUtils.showToast(getString(R.string.waiting_deal_share));
            }


            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });
```

###  (2)删除好友
```
【描述】
    删除好友

【函数调用】
    /**
     * 删除好友
     *
     * @param userIds  用户号
     * @param callback 返回回调
     */
    public void deleteFriend(String userIds, IResultCallback callback) {
        UserRequestManager.getInstance().deleteFriend(userIds, callback);
    }

【代码范例】

   MeariUser.getInstance().deleteFriend(friendMoreDel, new IResultCallback() {
        @Override
        public void onSuccess() {
            stopProgressDialog();
            mAdapter.cleaDelData();
            if (mAdapter.getData() == null || mAdapter.getData().size() <= 0) {
                onResumeDelStatus();
                bindEmpty(getString(R.string.no_friends));
                mRightBtn.setVisibility(View.GONE);
                if (mFriendDelBtn.getVisibility() != View.GONE) {
                    mFriendDelBtn.setVisibility(View.GONE);
                }
            }
             mAdapter.notifyDataSetChanged();
        }
        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });
```

###  (3)修改好友昵称
```
【描述】
    修改好友呢称

【函数调用】
   /**
     * 修改好友呢称
     *
     * @param friendId 好友ID
     * @param nickname 好友标注
     * @param callback 返回回调
     */
    public void renameFriendMark(String friendId, String nickname, IResultCallback callback);

【代码范例】
     MeariUser.getInstance().renameFriendMark(mInfo.getUserFriendID(), nickNameText, new IResultCallback() {
        @Override
        public void onSuccess(){
            CommonUtils.showToast(R.string.setting_successfully);
            mInfo.setNickName(mAliasEdit.getText().toString().trim());
            stopProgressDialog();
        }

        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });
```

###  (4)获取好友列表
```
【描述】
    获取好友列表
    
【函数调用】
    /**
     * 获取好友列表
     *
     * @param callback 返回回调
     */
    public void getFriendList(IGetFriendCallback callback);

【代码范例】
   MeariUser.getInstance().getFriendList(new IGetFriendCallback() {
        @Override
        public void onSuccess(List<MeariFriend> friends) {
            mPullToRefreshListView.onRefreshComplete();
            bindFriendList(friends);
        }
        @Override
        public void onError(int code, String error) {
            mPullToRefreshListView.onRefreshComplete();
            CommonUtils.showToast(error);
        }
    });
```

###  MeariFriend
- nickName 昵称
- phoneCode 国家区号
- userAccount 用户
- headPic 用户头像路径
- uid  唯一标识

## 7.2 添加分享
### （1）添加单个设备共享
```
【描述】
    分享单个设备给指定用户

【函数调用】

    /**
     * 主动分享设备
     *
     * @param devType  设备类型  0-nvr 1-ipc 2-bell
     * @param userId   分享用户ID
     * @param devUuid  设备标识符
     * @param callback 返回回调
     */
    public void addShareUserForDev(int devType, String userId, String devUuid, String devId, IShareForDevCallback callback);

【方法调用】
    MeariUser.getInstance().addShareUserForDev(1, mInfo.getUserFriendID(), friendDetailDTO.getDeviceUUID(), friendDetailDTO.getDeviceID(), new IShareForDevCallback() {
        @Override
        public void onSuccess(String userId, String devId) {
            stopProgressDialog();
            CommonUtils.showToast(R.string.share_success);
        }

        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
        }
    });
```

### （2）取消单个设备分享
```
【描述】
    取消单个设备分享

【函数调用】
    /**
     * 取消分享设备给好友
     *
     * @param devType  设备类型  0-nvr 1-ipc 2-bell
     * @param userId   分享用户ID
     * @param callback 返回回调
     */
    public void removeShareUserForDev(int devType, String userId, String devUuid, String devId, IShareForDevCallback callback) ;

【方法调用】
     MeariUser.getInstance().removeShareUserForDev(DeviceType.DEVICE_NVR, friendDetailDTO.getUserId(), mInfo.getDeviceID(), mInfo.getDeviceUUID(), new IShareForDevCallback() {
        @Override
        public void onSuccess(String userId, String devId) {
            stopProgressDialog();
            mAdapter.changeDateByUserId(userId, false);
            mAdapter.notifyDataSetChanged();
            CommonUtils.showToast(R.string.share_success);
        }
        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(R.string.fail);
        }
    });

```

###  (3)请求分享某个设备
```
【描述】
    请求分享某个设备

【函数调用】
     /**
     * 请求分享某个设备
     *
     * @param cameraInfo device
     * @param callback   callback
     */
    public void requestDeviceShare(BaseDeviceInfo cameraInfo, IRequestDeviceShareCallback callback);

【方法调用】
    MeariUser.getInstance().requestDeviceShare(info, new IRequestDeviceShareCallback() {
        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
        @Override
        public void onSuccess(String sn) {
            stopProgressDialog();
            CommonUtils.showToast(getString(R.string.waiting_deal_share));                
            mAdapter.setStatusBySn(sn, 5);
            if (mAdapter.getItemCount() == 1 && !mBSearch) {
                goBackHome();
            }
        }
    });

```

## 7.3 查询分享
### (1)查询单个设备被分享的好友列表
```
【描述】
    查询单个设备被分享的好友列表

【函数调用】
    /**
     * 查询单个设备被分享的好友列表
     *
     * @param deviceType 设备类型
     * @param deviceId   设备 id
     * @param callback   网络请求回调callback
     */
    public void queryFriendListForDevice(int deviceType, String deviceId, IQueryFriendListForDeviceCallback callback) ;

【方法调用】
   MeariUser.getInstance().queryFriendListForDevice(DeviceType.DEVICE_NVR, mInfo.getDeviceID(), new IQueryFriendListForDeviceCallback() {
        @Override
        public void onSuccess(ArrayList<ShareFriendInfo> shareFriendInfos) {
            mPullToRefreshRecyclerView.onRefreshComplete();
                bindOrderList(shareFriendInfos);
        }
        @Override
        public void onError(int code, String error) {
            mPullToRefreshRecyclerView.onRefreshComplete();
            showToast(error);
        }
    });
```

### (2)查询某个好友的被分享设备列表
```
【描述】
    查询某个好友的被分享设备列表

【函数调用】
    
    /**
     * 查询某个好友的被分享设备列表
     *
     * @param devType 设备类型  0-nvr 1-ipc 2-bell
     * @param userId  分享用户ID
     */
    public void queryDeviceListForFriend(int devType, String userId, IQueryDeviceListForFriendCallback callback);

【方法调用】
    MeariUser.getInstance().queryDeviceListForFriend(DeviceType.DEVICE_IPC, mInfo.getUserFriendID(), new IQueryDeviceListForFriendCallback() {
        @Override
        public void onError(int code, String error) {
            mPullToRefreshRecyclerView.onRefreshComplete();
            CommonUtils.showToast(error);
        }

        @Override
        public void onSuccess(List<MeariSharedDevice> list) {
            mPullToRefreshRecyclerView.onRefreshComplete();
            bindOrderList(list);
        }

    });
```

class MeariSharedDevice:

- String deviceName //设备呢称
- String deviceUUID //设备唯一标识符
- boolean isShare   //是否已经分享
- String snNum      //设备sn

```
```

# 8.消息中心
## 8.1 获取所有设备是否有消息
```
【描述】
    获取所有设备是否有消息

【函数调用】
    /**
     *  获取消息列表
     *
     * @param callback callback
     */
    public void getAlarmMessageStatusForDev(IGetAlarmMessageStatusForDevCallback callback)

【方法调用】
    MeariUser.getInstance().getAlarmMessageStatusForDev(new IGetAlarmMessageStatusForDevCallback() {
        @Override
        public void onError(int code, String error) {
            mPullToRefreshRecyclerView.onRefreshComplete();
            CommonUtils.showToast(error);
        }

        @Override
        public void onSuccess(List<DeviceMessageStatusInfo> deviceMessageStatus) {
            bindOrderList(deviceMessageStatus);
        }
    });
 
```
class DeviceMessageStatus：

- long deviceID       //设备ID
- String deviceName   //设备呢称
- String deviceUUID   //设备唯一标识符
- String hasMessgFlag //"Y"表示含有未读消息 "N"表示没有未读消息
- boolean bHasMsg     //是否含有消息
- int delMsgFlag      //0表示未编辑状态，1表示编辑单位选择2表示选择
- boolean bSysmsg     //是否为系统消息
- String snNum        //是否为系统消息
- String url          //是否为系统消息
- String userAccount  //是否为系统消息
```
```

## 8.2 获取系统消息
```
【描述】
    获取系统消息

【函数调用】
    /**
     * 获取系统消息
     *
     * @param callback callback
     */
    public void getSystemMessage(IGetSystemMessageCallback callback);

【方法调用】
    MeariUser.getInstance().getSystemMessage(new IGetSystemMessageCallback() {
        @Override
        public void onError(int code, String error) {
            mPullToRefreshListView.onRefreshComplete();
            bindError(error);
            CommonUtils.showToast(error);
        }

        @Override
        public void onSuccess(List<SystemMessageInfo> systemMessages) {
            bindList(systemMessages);
            mPullToRefreshListView.onRefreshComplete();
        }
        });
```
class SystemMessage:

```
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
```

## 8.3 获取某个设备报警消息
```
【描述】
    获取某个设备报警消息

【函数调用】
    /**
      * refuse friend share device
      *
      * @param deviceId deviceId
      * @param callback callback
      */
    public void getAlarmMessagesForDev(long deviceId, IGetAlarmMessagesCallback callback);

【方法调用】
    MeariUser.getInstance().getAlarmMessagesForDev(this.mMsgInfo.getDeviceID(), new IGetAlarmMessagesCallback() {

        @Override
        public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo, boolean isDelete) {
            mPullToRefreshListView.onRefreshComplete();
            bindList(deviceAlarmMessages);
            mCameraInfo = cameraInfo;
            deviceStatus = isDelete;
        }

        @Override
        public void onError(int code, String error) {
            CommonUtils.showToast(error);
            bindError(error);
        }
    });;
 【注意事项】
    如果消息一经主人拉取后，服务器不会保存消息，被分享的好友也看不到这些消息
```
class DeviceAlarmMessage:
- long deviceID;//设备ID
- String deviceUuid;//设备唯一标识符
- String imgUrl;// 报警图片地址
- int imageAlertType;//报警类型（PIR和Motion）
- int msgTypeID;//消息类型
- long userID;//用户Id
- long userIDS;
- String createDate;//穿时间
- String isRead;//是否已读
- String tumbnailPic;//缩略图
- String decibel;//分贝
- long msgID;//消息Id

```
代写
```


## 8.3 批量删除系统消息
```
【描述】

    批量删除系统消息

【函数调用】
    /**
     * 批量删除系统消息
     *
     * @param callback callback
     * @param msgIds 消息Ids
     */
    public void deleteSystemMessage(List<Long> msgIds, final IResultCallback callback);

【方法调用】
    MeariUser.getInstance().deleteSystemMessage(selectDeleteMsgIds, new IResultCallback() {
        @Override
        public void onSuccess() {
            stopProgressDialog();
            }
        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
            }
        });

```

## 8.4 批量删除多个设备报警消息
```
【描述】
    批量删除多个设备报警消息

【函数调用】
     /**
     * 批量删除多个设备报警消息
     *
     * @param callback callback
     * @param deviceInfos 设备Id
     */
    public void deleteDevicesAlarmMessage(ArrayList<Long> deviceInfos, IResultCallback callback) ;

【方法调用】
    MeariUser.getInstance().deleteDevicesAlarmMessage(deviceInfos, new IResultCallback() {
        @Override
        public void onSuccess() {
            stopProgressDialog();
            deleteCallback();
        }
        @Override
        public void onError(int code, String error) {
        stopProgressDialog();
        CommonUtils.showToast(error);
        }
    });
```

## 8.5 标记单个设备消息全部已读
```
【描述】
    标记单个设备消息全部已读

【函数调用】
    void MarkDevicesAlarmMessage(int devid, IMarkDevicesAlarmMessageCallback callback);

【方法调用】
    MeariUser.getInstance().MarkDevicesAlarmMessage(
        devid, new IMarkDevicesAlarmMessageCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onError(String errorCode, String errorMessage) {

            }
    });
```

## 8.6 好友消息处理
```
【描述】
    好友消息处理-同意|拒绝

【函数调用】
    /**
     * 同意添加好友
     *
     * @param msgId    messageId
     * @param friendId friend userId
     * @param callback callback
     */
    public void agreeFriend(long msgId, long friendId, IDealSystemCallback callback) ;

    /**
     * 拒绝添加好友
     *
     * @param msgId    messageId
     * @param friendId friend userId
     * @param callback callback
     */
    public void refuseFriend(long msgId, long friendId, IDealSystemCallback callback);

【方法调用】
   MeariUser.getInstance().agreeFriend(msgInfo.getMsgID(), msgInfo.getUserID(), new IDealSystemCallback() {
        @Override
        public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });

    MeariUser.getInstance().refuseFriend(msgInfo.getMsgID(), msgInfo.getUserID(), new IDealSystemCallback() {
        @Override
        public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });;
【注意事项】
    如果消息处理完了，需要手动删除消息
```

## 8.6 设备消息处理
```
【描述】
    设备消息处理-同意|拒绝

【函数调用】
    /**
     * 同意分享设备  
     *
     * @param msgId    messageId
     * @param friendId friend userId
     * @param deviceId deviceId
     * @param callback callback
     */
    public void agreeShareDevice(long msgId, long friendId, long deviceId, IDealSystemCallback callback);

    /**
     * 拒绝分享设备
     *
     * @param msgId    messageId
     * @param friendId friend userId
     * @param deviceId deviceId
     * @param callback callback
     */
    public void refuseShareDevice(long msgId, long friendId, long deviceId, IDealSystemCallback callback);

【方法调用】
    MeariUser.getInstance().agreeShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(), new IDealSystemCallback() {
        @Override
        public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
        }
    });

    MeariUser.getInstance().refuseShareDevice(msgInfo.getMsgID(), msgInfo.getUserID(), msgInfo.getDeviceID(), new IDealSystemCallback() {
        @Override
        public void onSuccess(long msgId) {
            stopProgressDialog();
            shareResult(msgId);
        }

        @Override
        public void onError(int code, String error) {
            stopProgressDialog();
            CommonUtils.showToast(error);
            }
    });

【注意事项】
    如果消息处理完了，需要手动删除消息
```

# 9.集成Push（MeariPush工具类）
```
基于Meari SDK开发的app，Meari平台支持Push功能，支持给用户发送运营Push和产品的告警Push。
```
## 集成极光
Push功能是基于极光推送开发的，请先参考极光文档将极光集成到项目中

## 设置用户别名
 TagAliasOperatorHelper.getInstance().handleAction(getApplicationContext(), sequence, tagAliasBean);
## Push接收
MyReceiver文件

