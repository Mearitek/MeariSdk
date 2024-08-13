<h1><center> 目录 </center></h1>

```
[TOC]
```

* 1 [功能概述](#1-功能概述)
* 2 [集成准备](#2-集成准备)
* 3 [集成SDK](#3-集成SDK)
    * 3.1 [集成流程](#31-集成流程)
        * 3.1.1 [引入sdk包](#311-引入sdk包)
        * 3.1.2 [配置build.gradle](#312-配置build.gradle)
        * 3.1.3 [配置AndroidManifest.xml](#313-配置AndroidManifest.xml)
    * 3.2 [初始化SDK](#32-初始化SDK)
* 4 [用户管理](#4-用户管理)
    * 4.1 [用户登录](#41-用户登录)
    * 4.2 [退出登录](#42-退出登录)
    * 4.3 [上传用户头像](#43-上传用户头像)
    * 4.4 [修改昵称](#44-修改昵称)
* 5 [添加设备](#5-添加设备)
    * 5.1 [二维码配网添加设备](#51-二维码配网添加设备)
        * 5.1.1 [生成二维码](#511-生成二维码)
        * 5.1.2 [搜索添加设备](#512-搜索添加设备)
    * 5.2 [AP配网添加设备](#52-AP配网添加设备)
        * 5.2.1 [连接设备热点](#521-连接设备热点)
        * 5.2.2 [搜索添加设备](#522-搜索添加设备)
    * 5.3 [有线配网添加设备](#53-有线配网添加设备)
        * 5.3.1 [搜索设备](#531-搜索设备)
        * 5.3.2 [添加设备](#532-添加设备)
    * 5.4 [扫码即添加](#54-扫码即添加) 
        * 5.4.1 [扫描机身码](#541-扫描机身码)
        * 5.3.2 [获取设备状态](#542-获取设备状态)
        * 5.3.2 [添加设备](#543-添加设备)
* 6 [设备控制](#6-设备控制)
    * 6.1 [设备基本操作](#61-设备基本操作)
        * 6.1.1 [设备相关类介绍](#611-设备相关类介绍)
        * 6.1.2 [获取设备信息列表](#612-获取设备信息列表)
        * 6.1.3 [设备移除](#613-设备移除)
        * 6.1.4 [设备昵称修改](#614-设备昵称修改)
        * 6.1.5 [获取设备报警消息时间片段](#615-获取设备报警消息时间片段)
        * 6.1.6 [获取设备在线状态](#616-获取设备在线状态)
        * 6.1.7 [重启设备](#617-重启设备)
    * 6.2 [设备预览和回放](#62-设备预览和回放)
        * 6.2.1 [设备预览](#621-设备预览)
        * 6.2.2 [设备SD卡回放](#622-设备SD卡回放)
        * 6.2.3 [设备云回放](#623-设备云回放)
    * 6.3 [设备相关](#63-设备相关)
        * 6.3.1 [门铃接听流程](#631-门铃接听流程)
        * 6.3.2 [主人留言](#632-主人留言)
* 7 [分享设备](#7-分享设备)
    * 7.1 [相关类介绍](#71-相关类介绍)
    * 7.2 [获取设备分享列表](#72-获取设备分享列表)
    * 7.3 [获取历史分享列表](#73-获取历史分享列表)
    * 7.4 [获取所有设备的分享结果](#74-获取所有设备的分享结果)
    * 7.5 [搜索用户](#75-搜索用户)
    * 7.6 [分享设备](#76-分享设备)
    * 7.7 [取消分享设备](#77-取消分享设备)
    * 7.8 [删除历史分享用户](#78-删除历史分享用户)
    * 7.9 [处理分享消息](#79-处理分享消息)
* 8 [消息中心](#8-消息中心)
    * 8.1 [设备分享消息](#81-设备分享消息)
        * 8.1.1 [获取设备分享消息列表](#811-获取设备分享消息列表)
        * 8.1.2 [删除设备分享消息](#812-删除设备分享消息)
    * 8.2 [设备报警消息](#82-设备报警消息)
        * 8.2.1 [获取所有设备最新的消息](#821-获取所有设备最新的消息)
        * 8.2.2 [获取单个设备的报警消息](#822-获取单个设备的报警消息)
        * 8.2.3 [删除设备的报警消息](#823-删除设备的报警消息)
    * 8.3 [系统消息](#83-系统消息)
        * 8.3.1 [获取系统消息列表](#831-获取系统消息列表)
        * 8.3.2 [删除系统消息](#832-删除系统消息)
* 9 [设备设置](#9-设备设置)
    * 9.1 [设备能力集](#91-设备能力集)
    * 9.2 [设备参数](#92-设备参数)
    * 9.3 [格式化设备SD卡](#93-格式化设备SD卡)
    * 9.4 [升级设备固件](#94-升级设备固件)
    * 9.5 [基本参数设置](#95-基本参数设置)
        * 9.5.1 [获取设备参数](#951-获取设备参数)
        * 9.5.2 [设备LED灯开关控制](#952-设备LED灯开关控制)
        * 9.5.3 [设备预览视频翻转控制](#953-设备预览视频翻转控制)
        * 9.5.4 [设备本地录像设置](#954-设备本地录像设置)
        * 9.5.5 [设备日夜模式设置](#955-设备日夜模式设置)
        * 9.5.6 [设备休眠模式设置](#956-设备休眠模式设置)
        * 9.5.7 [设备定时休眠时间段设置](#957-设备定时休眠时间段设置)
        * 9.5.8 [设备移动侦测设置](#958-设备移动侦测设置)
        * 9.5.9 [设备PIR侦测设置](#959-设备PIR侦测设置)
        * 9.5.10 [设备噪声侦测设置](#9510-设备噪声侦测设置)
        * 9.5.11 [设备哭声报警设置](#9511-设备哭声报警设置)
        * 9.5.12 [设备人形跟踪设置](#9512-设备人形跟踪设置)
        * 9.5.13 [设备人形侦测报警设置](#9513-设备人形侦测报警设置)
        * 9.5.14 [设备人形框设置](#9514-设备人形框设置)
        * 9.5.15 [设备Onvif设置](#9515-设备Onvif设置)
        * 9.5.16 [设备视频编码格式设置](#9516-设备视频编码格式设置)
        * 9.5.17 [设备转动控制](#9517-设备转动控制)
        * 9.5.18 [设备报警计划时间段设置](#9518-设备报警计划时间段设置)
        * 9.5.19 [设备推送消息开关设置](#9519-设备推送消息开关设置)
        * 9.5.20 [报警频率设置](#9520-报警频率设置)
        * 9.5.21 [多档PIR设置](#9521-多档PIR设置)
        * 9.5.22 [SD卡录像类型和时间设置](#9522-SD卡录像类型和时间设置)
        * 9.5.23 [设备全彩模式设置](#9523-设备全彩模式设置)
        * 9.5.24 [设备声光报警设置](#9524-设备声光报警设置)
        * 9.5.25 [设备12小时开关设置](#9525-设备12小时开关设置)
        * 9.5.26 [设备抗闪烁设置](#9526-设备抗闪烁设置)
        * 9.5.27 [设备麦克风、录音、扬声器设置](#9527-设备麦克风、录音、扬声器设置)
        * 9.5.28 [设备视频加密设置](#9528-设备视频加密设置)
        * 9.5.29 [设备防拆报警设置](#9529-设备防拆报警设置)
        * 9.5.30 [设备变声设置](#9530-设备变声设置)    
        * 9.5.31 [设备工作模式](#9531-设备工作模式)
        * 9.5.32 [人形报警区域（画框）设置](#9532-人形报警区域（画框）设置)
        * 9.5.33 [人形开关设置](#9533-人形开关设置)
        * 9.5.34 [录像时长设置](#9534-录像时长设置)
        * 9.5.35 [音乐播放设置](#9535-音乐播放设置)
    * 9.6 [门铃参数设置](#96-门铃参数设置)
        * 9.6.1 [设备对讲音量设置](#961-设备对讲音量设置)
        * 9.6.2 [解锁电池锁](#962-解锁电池锁)
        * 9.6.3 [绑定无线铃铛](#963-绑定无线铃铛)
        * 9.6.4 [解绑无线铃铛](#964-解绑无线铃铛)
        * 9.6.5 [无线铃铛是否工作设置](#965-无线铃铛是否工作设置)
        * 9.6.6 [无线铃铛音量设置](#966-无线铃铛音量设置)
        * 9.6.7 [无线铃铛铃声设置](#967-无线铃铛铃声设置)
        * 9.6.8 [机械铃铛是否工作设置](#968-机械铃铛是否工作设置)
    * 9.7 [泛光灯摄像机参数设置](#97-泛光灯摄像机参数设置)
        * 9.7.1 [灯具摄像机开关灯设置](#971-灯具摄像机开关灯设置)
        * 9.7.2 [灯具摄像机报警开关设置](#972-灯具摄像机报警开关设置)
        * 9.7.3 [灯具摄像机联动照明开关设置](#973-灯具摄像机联动照明开关设置)
        * 9.7.4 [灯具摄像机联动照明持续时间设置](#974-灯具摄像机联动照明持续时间设置)
        * 9.7.5 [灯具摄像机照明计划设置](#975-灯具摄像机照明计划设置)
        * 9.7.6 [灯具摄像机亮度设置](#976-灯具摄像机亮度设置)
        * 9.7.7 [灯具摄像机手动亮灯时长设置](#977-灯具摄像机手动亮灯时长设置)
        * 9.7.8 [灯具摄像机联动报警开关设置](#978-灯具摄像机联动报警开关设置)
    * 9.8 [AOV摄像机参数设置](#98-AOV摄像机参数设置)  
        * 9.8.1 [预览切换实时省流](#981-预览切换实时省流)
        * 9.8.2 [工作模式](#982-工作模式)
        * 9.8.3 [自定义参数设置](#983-自定义参数设置)
* 10 [家庭](#10-家庭)
    * 10.1 [家庭操作](#101-家庭操作)
        * 10.1.1 [获取家庭列表](#1011-获取家庭列表)
        * 10.1.2 [创建家庭](#1012-创建家庭)
        * 10.1.3 [更新家庭信息](#1013-更新家庭信息)
        * 10.1.4 [删除家庭](#1014-删除家庭)
    * 10.2 [家庭分享](#102-家庭分享)
        * 10.2.1 [搜索要添加的成员账号](#1021-搜索要添加的成员账号)
        * 10.2.2 [搜索要加入的家庭账号](#102-搜索要加入的家庭账号)
        * 10.2.3 [添加成员到家庭中](#1023-添加成员到家庭中)
        * 10.2.4 [加入一个家庭](#1024-加入一个家庭)
        * 10.2.5 [获取家庭分享消息](#1025-获取家庭分享消息)
        * 10.2.6 [处理家庭分享消息](#1026-处理家庭分享消息)
        * 10.2.7 [获取家庭成员列表](#1027-获取家庭成员列表)
        * 10.2.8 [修改家庭成员设备权限](#1028-修改家庭成员设备权限)
        * 10.2.9 [从家庭移除成员](#1029-从家庭移除成员)
        * 10.2.10 [撤销成员邀请](#10210-撤销成员邀请)
        * 10.2.11 [离开家庭](#10211-离开家庭)
    * 10.3 [房间操作](#103-房间操作)
        * 10.3.1 [添加房间](#1031-添加房间)
        * 10.3.2 [修改房间信息](#1032-修改房间信息)
        * 10.3.3 [删除房间](#1033-删除房间)
        * 10.3.4 [添加设备到房间](#1034-添加设备到房间)
        * 10.3.5 [从房间移除设备](#1035-从房间移除设备)
        * 10.3.6 [批量删除设备](#1036-批量删除设备)
    * 10.4 [家庭相关类](#104-家庭相关类)
        * 10.4.1 [MeariFamily](#1041-MeariFamily)
        * 10.4.2 [MeariRoom](#1042-MeariRoom)
        * 10.4.3 [DevicePermission](#1043-DevicePermission)
        * 10.4.4 [FamilyShareMsg](#1044-FamilyShareMsg)
        * 10.4.5 [FamilyMember](#1045-FamilyMember)
* 11 [MQTT和推送](#11-MQTT和推送)
    * 11.1 [MQTT消息](#111-MQTT消息)
        * 11.1.1 [连接MQTT服务](#1111-连接MQTT服务)
        * 11.1.2 [退出MQTT服务](#1112-退出MQTT服务)
        * 11.1.3 [MQTT消息处理](#1113-MQTT消息处理)
    * 11.2 [MQTT相关类](#112-MQTT相关类)
        * 11.2.1 [MqttMsg](#1121-MqttMsg)
        * 11.2.2 [FamilyMqttMsg extends MqttMsg](#1122-FamilyMqttMsg-extends-MqttMsg)
        * 11.2.3 [MsgItem](#1123-MsgItem)
    * 11.3 [集成谷歌推送](#113-集成谷歌推送)
    * 11.4 [集成其他推送](#114-集成其他推送)
* 12 [云存储服务](#12-云存储服务)
    * 12.1 [云存储服务状态](#121-云存储服务状态)
    * 12.2 [云存储试用](#122-云存储试用)
    * 12.3 [云存储激活码使用](#123-云存储激活码使用)
    * 12.4 [云存储购买](#124-云存储购买)
* 13 [NVR](#13-NVR)
    * 13.1 [添加NVR](#131-添加NVR)
    * 13.2 [添加摄像机到NVR通道](#132-添加摄像机到NVR通道)
        * 13.2.1 [添加在线摄像机](#1321-添加在线摄像机)
        * 13.2.2 [连接NVR添加摄像机](#1322-连接NVR添加摄像机)
        * 13.2.3 [连接路由器添加摄像机](#1323-连接路由器添加摄像机)
    * 13.3 [NVR和通道的判断](#133-NVR和通道的判断)
    * 13.4 [NVR设置](#134-NVR设置)
        * 13.4.1 [NVR获取参数](#1341-NVR获取参数)
        * 13.4.2 [NVR磁盘管理](#1342-NVR磁盘管理)
    * 13.5 [NVR通道摄像机](#135-NVR通道摄像机)
        * 13.5.1 [NVR通道摄像机信息](#1351-NVR通道摄像机信息)
        * 13.5.2 [NVR通道摄像机参数](#1352-NVR通道摄像机参数)
        * 13.5.3 [NVR通道摄像机固件升级](#1353-NVR通道摄像机固件升级)
* 14 [4G](#14-4G) 
    * 14.1 [添加4G](#141-添加4G)
    * 14.2 [4G流量](#142-4G流量)
        * 14.2.1 [流量充值套餐](#1421-流量充值套餐) 
        * 14.2.2 [流量查询（不可频繁查询）](#1422-流量查询（不可频繁查询）)
        * 14.2.3 [兑换流量](#1423-兑换流量)
        * 14.2.4 [试用流量开通](#1424-试用流量开通) 
        * 14.2.5 [流量购买](#1425-流量购买)
        * 14.2.6 [流量订单](#1426-流量订单)

* 15 [宠物类设备](#15-宠物类设备) 
    * 15.1 [添加设备](#151-添加设备)
    * 15.2 [设置](#152-设置)
        * 15.2.1 [投食喂食](#1521-投食喂食) 
        * 15.2.2 [音效设置](#1522-音效设置)
        * 15.2.3 [一键呼唤](#1523-一键呼唤)
        * 15.2.4 [投食喂食计划](#1524-投食喂食计划)       
* 16 [更新说明](#16-更新说明)

<center>

---
版本号 | 制定团队 | 更新日期 | 备注
:-:|:-:|:-:|:-:
3.1.0 | 觅睿技术团队 | 2020.07.02 | 优化
4.1.0 | 觅睿技术团队 | 2022.03.31 | 优化
5.0.0 | 觅睿技术团队 | 2023.06.09 | 4G,云存储2.0

<center>

# 1 功能概述

觅睿科技APP SDK提供了与硬件设备、觅睿云通讯的接口封装，加速应用开发过程，主要包括以下功能：

- 账户体系
- 设备添加
- 设备控制
- 设备设置
- 设备共享
- 家庭
- 消息中心

--------------

# 2 集成准备

- 1. 获取 App Key 和 App secret
- 2. 请先阅读服务端文档，获取重定向和登录的认证信息

--------------

# 3 集成SDK
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
    // aar 必需依赖库
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
# 4 用户管理
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


## 4.1 用户登录
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
MeariUser.getInstance().loginWithExternalData(redirectionJson, loginJson, new ILoginCallback() {
    @Override
    public void onSuccess(UserInfo userInfo) {

    }

    @Override
    public void onError(int i, String s) {

    }
});
```

## 4.2 退出登录
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
        MeariUser.getInstance().removeUserInfo();
        MqttMangerUtils.getInstance().disConnectService();
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

## 4.3 上传用户头像
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
## 4.4 修改昵称
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

# 5 添加设备
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
 * 生成配网二维码（4G需要使用下面的加密二维码）
 *
 * @param ssid     wifi名称
 * @param password wifi密码
 * @param token    配网token
 * @param callback callback
 */
public void createQRCode(String ssid, String password, String token, ICreateQRCodeCallback callback);

/**
 * 生成配网加密二维码（目前仅4G使用，且必须使用）
 *
 * @param ssid     wifi名称
 * @param password wifi密码
 * @param token    配网token
 * @param callback callback
 * @param isChimeSubDevice  false
 */
public void createSecretQRCode(String ssid, String password, String token, ICreateQRCodeCallback callback, boolean isChimeSubDevice)

createSecretQRCode

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
mangerCameraScan.startSearchDevice(false, -1, 100*1000, ActivityType.ACTIVITY_SEARCHCANERARESLUT, token)


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

## 5.3 有线配网添加设备
```
使有线设备和手机处于同一局域网，开始搜索设备。如果是有线设备，开始检测设备状态。如果设备可以添加，开始添加设备。
```
### 5.3.1 搜索设备
```
【描述】
搜索局域网内的设备，如果是有线设备，判断设备状态

【代码范例】
MangerCameraScanUtils mangerCameraScan = new MangerCameraScanUtils(null, null, 0, new CameraSearchListener() {
    @Override
    public void onCameraSearchDetected(CameraInfo cameraInfo) {
        //发现设备，如果是有线设备，检查设备状态
        if(deviceInfo!=null && deviceInfo.isWireDevice()) {
            checkDeviceStatus();
        }
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
mangerCameraScan.startSearchDevice(false, -1, ACTIVITY_WIRED_OPERATION);

// 检测设备状态
MeariUser.getInstance().checkDeviceStatus(cameraInfos, deviceTypeID, new IDeviceStatusCallback() {
    @Override
    public void onSuccess(ArrayList<CameraInfo> deviceList) {
        // 1代表是自己的设备，2代表别人的分享给设备,3代表设备可添加,4别人的设备已分享给自己
        if (cameraInfo.getAddStatus() == 3) {
            //添加设备
            addDevice(info);
        }
    }

    @Override
    public void onError(int code, String error) {

    }
});
```

### 5.3.2 添加设备
```
【描述】
获取token，并添加设备

【代码范例】
// 获取token
MeariUser.getInstance().getToken(new IGetTokenCallback() {
    @Override
    public void onSuccess(String token, int leftTime, int smart_switch) {
        mToken = token;
    }

    @Override
    public void onError(int code, String error) {
    }
}, DeviceType.NVR_NEUTRAL);

//添加设备
public void addDevice(CameraInfo info) {
    MeariDeviceController deviceController = new MeariDeviceController();
    deviceController.setWireDevice(info.getWireConfigIp(), mToken);
}
```

## 5.4 扫码即添加
```
有线设备或者4G设备，扫描机身码，开始检测设备状态。如果设备可以添加，直接添加设备。
```
### 5.4.1 扫描机身码
```
扫描机身码，获取到机身码的值。

【函数调用】

/**
 * 处理机身码，获取设备的uuid
 *
 * @param result      机身码结果
 * 
 * return  设备的uuid
 */
public static String dealUUiD(String result)

【代码范例】
val dealUUiD = SdkUtils.dealUUiD(result)

```

### 5.4.2 获取设备状态
```
通过uuid获取设备在线离线状态，设备在线才能继续添加，否则引导用户走通电流程
【函数调用】

/**
 * 机身码获取设备在线状态
 *
 * @param uuid       设备的uuid
 * 
 *
 */

public void getDeviceStatus(String uuid, IStringResultCallback callback)

【代码范例】
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
备注：
status
1: 在线
2: 离线
3: 休眠
4: 未上报业务服务器信息
5: 超时
6: 未找到
7: 弱绑定未复位
8: 强绑定
9: app账号和设备加密国家号不匹配

status = 4时，该字段为空

staus = 8时，返回userAccount  或 nickName(第三方登录)

status = 1时，返回 capability 能力级

 ```

### 5.4.3 添加设备
有线设备或者4G设备查询到在线状态，可以通过调用添加接口进行设备添加

```
【描述】
添加设备（区分新旧机身码）

【函数调用】

/**
 * 添加设备（旧码）
 *
 * @param result      机身码结果
 * return      ture:新机身码    false：旧机身码
 *
 */
public static boolean dealUUiDisNew(String result)

【代码范例】
SdkUtils.dealUUiDisNew(scanResult)



/**
 * 添加设备（旧码）
 *
 * @param sn       设备的licenseID
 * @param sn       设备的licenseID
 *
 */

public void add4GDeviceNew(String sn, IStringResultCallback callback) 

【代码范例】
MeariUser.getInstance().add4GDeviceNew(uuid, object : IStringResultCallback {
            override fun onSuccess(result: String) {
                
            }

            override fun onError(code: Int, error: String) {
                //(返回1150是设备未激活，1013被别的绑定)
            }
        })



/**
 * 下发token给设备 （新码）
 *
 * @param licenseID       设备的licenseID
 * 
 *
 */

public void addDeviceServerSendToken(String licenseID,IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().getDeviceStatusGet(sn, new IGetDeviceStatusCallback() {
            @Override
            public void onSuccess(boolean isOnline) {
                //仅代表添加指令发送成功，添加成功还需等待mqtt或者轮询设备列表确认是否添加成功
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });

 ```




# 6 设备控制

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

如果设备能力级cameraInfo.getEvt() < 1使用如下方法：
/**
 * 获取设备的报警消息时间片段
 *
 * @param deviceID 设备ID
 * @param dayTime  时间："20200303"
 * @param callback callback
 */
public void getDeviceAlarmMessageTimeForDate(String deviceID, String dayTime, IDeviceAlarmMessageTimeCallback callback);

如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 获取设备的报警消息时间片段
 *
 * @param deviceID 设备ID
 * @param dayTime  时间："20200303"
 * @param callback callback
 */
public void getDeviceAlarmMessageTimeForDate2(String deviceID, String dayTime, IDeviceAlarmMessageTimeCallbackNew callback);

【代码范例】

如果设备能力级cameraInfo.getEvt() < 1时调用:
MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(deviceID, dayTime, new IDeviceAlarmMessageTimeCallback() {
    @Override
    public void onSuccess(ArrayList<VideoTimeRecord> videoTimeList) {
    }

    @Override
    public void onError(int code, String error) {
    }
});

如果设备能力级cameraInfo.getEvt() == 1时调用:
MeariUser.getInstance().getDeviceAlarmMessageTimeForDate2(deviceID, dayTime, new IDeviceAlarmMessageTimeCallbackNew() {
    @Override
    public void onSuccess(ArrayList<VideoTimeRecord> videoTimeList, long historyEventEnable) {
    }

    @Override
    public void onError(int code, String error) {
    }
});
```

### 6.1.6 获取设备在线状态
```
【描述】
获取设备在线状态

【函数调用】

/**
 * 获取设备在线状态
 *
 * String 截取的SN，cameraInfo.getSnNum().substring(4)
 * Integer 0-连接中；1-在线；2-离线；3-休眠
 */
public Map<String, Integer> queryDeviceStatus();

【代码范例】
// 获取了设备列表后，循环获取设备状态，如果状态有改变，则更新设备状态
Map<String, Integer> temStatus = MeariIotController.getInstance().queryDeviceStatus();
```

### 6.1.7 重启设备
```
【描述】
重启设备

【函数调用】

/**
 * 重启设备
 * @param callback 回调
 */
public void setDevicesReboot(ISetDeviceParamsCallback callback);

【代码范例】
MeariUser.getInstance().setDevicesReboot(new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
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
        // 获取码率
        String mBitRate = deviceController.getBitRate() + "KB/s";
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

MeariDeviceUtil.isSupportDownloadSdRecord(cameraInfo) == true时支持下载录像
/**
 * 下载录像
 *
 * @param channelId camera channelId cameraInfo.getChannelId()
 * @param startTime yyyyMMddHHmmss 开始时间必须在录像片段内
 * @param endTime yyyyMMddHHmmss
 * @param filePath 下载录像的路径
 * @param listener 监听
 */
public void startDownloadSdRecord(int channelId, String startTime, String endTime, String filePath, @NonNull MeariDeviceSdRecordDownloadListener listener)

/**
 * 下载录像进度
 *
 * @param callback callback
 */
public void getSdRecordDownloadProgress(IProgressCallback callback)

MeariDeviceUtil.isSupportDeleteSdRecord(cameraInfo) == true时支持删除录像
/**
 * 删除一天的录像
 *
 * @param channelId camera channel
 * @param day yyyyMMdd
 * @param listener 监听
 */
public void deleteSdRecordOfDay(int channelId, String day, @NonNull MeariDeviceListener listener)

/**
 * 删除录像状态
 *
 * @param callback callback
 */
public void getSdRecordDeleteState(IProgressCallback callback)

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

// 下载录像
deviceController.startDownloadSdRecord(channelId, start, end, path, new MeariDeviceSdRecordDownloadListener() {
    @Override
    public void onSuccess(int index) {
        MeariUser.getInstance().getSdRecordDownloadProgress()
    }

    @Override
    public void onFailed(int code, String msg) {

    }
});

// 下载录像进度
MeariUser.getInstance().getSdRecordDownloadProgress(new IProgressCallback() {
    @Override
    public void onSuccess(int progress) {
        if (progress >= 100) {
            // 下载成功停止下载
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

// 删除一天的录像
deviceController.deleteSdRecordOfDay(cameraInfo.getNvrChannelId(), ymd, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        MeariUser.getInstance().getSdRecordDeleteState()
    }

    @Override
    public void onFailed(String errorMsg) {

    }
});

// 删除录像状态
MeariUser.getInstanace().getSdRecordDeleteState(new IProgressCallback() {
    @Override
    public void onSuccess(int state) {
        if (state == 0) {
            // 不在删除状态，成功
        } else {
            // 正在删除中
        }
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {

    }
});
```
### 6.2.3 设备云回放

```
【描述】
设备开通云存储后，可以进行云回放

【函数调用】

如果设备能力级cameraInfo.getEvt() < 1使用如下方法：
/**
 * 获取一个月有视频的日期
 * @param deviceID 设备ID
 * @param year 年
 * @param month 月
 * @param callback 回调
 */
public void getCloudHaveVideoDaysInMonth(String deviceID, int year, int month, ICloudHaveVideoDaysCallback callback);
如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 获取一个月有视频的日期
 * @param deviceID 设备ID
 * @param year 年
 * @param month 月
 * @param callback 回调
 */
public void getCloudHaveShortVideoDaysInMonth(String deviceID, int year, int month, ICloudHaveVideoDaysCallback callback);

如果设备能力级cameraInfo.getEvt() < 1使用如下方法：
/**
 * 获取一天中所有的视频片段
 * @param deviceID 设备ID
 * @param year 年
 * @param month 月
 * @param callback 回调
 */
public void getCloudVideoTimeRecordInDay(String deviceID, int year, int month, int day, ICloudVideoTimeRecordCallback callback);
如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 获取一天中所有的视频片段
 * @param deviceID 设备ID
 * @param year 年
 * @param month 月
 * @param callback 回调
 */
public void getCloudShortVideoTimeRecordInDay(String deviceID, int year, int month, int day, ICloudShortVideoTimeRecordCallback callback);

如果设备能力级cameraInfo.getEvt() < 1使用如下方法：
/**
 * 获取云回放的视频信息
 * @param deviceID 设备ID
 * @param index 时间序号 例：00:30:00 is 1, 01:00:00 is 2
 * @param year 年
 * @param month 月
 * @param month 日
 * @param callback 回调
 */
public void getCloudVideo(String deviceID, int index, int year, int month, int day, ICloudGetVideoCallback callback);
如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 获取云回放的视频信息
 * @param deviceID 设备ID
 * @param index 时间序号 例：00:20:00 is 1, 00:40:00 is 2
 * @param year 年
 * @param month 月
 * @param month 日
 * @param callback 回调
 */
public void getCloudShortVideo(String deviceID, int index, int year, int month, int day, ICloudGetShortVideoCallback callback);

【代码范例】

// 获取一个月有视频的日期
如果设备能力级cameraInfo.getEvt() < 1时调用:
MeariUser.getInstance().getCloudHaveVideoDaysInMonth(deviceId, year, month, new ICloudHaveVideoDaysCallback() {
    @Override
    public void onSuccess(String yearAndMonth, ArrayList<Integer> haveVideoDays) {
               
    }

    @Override
    public void onError(int code, String error) {

    }
});
如果设备能力级cameraInfo.getEvt() == 1时调用:
// 获取一个月有视频的日期
MeariUser.getInstance().getCloudHaveShortVideoDaysInMonth(deviceId, year, month, new ICloudHaveVideoDaysCallback() {
    @Override
    public void onSuccess(String yearAndMonth, ArrayList<Integer> haveVideoDays) {
               
    }

    @Override
    public void onError(int code, String error) {

    }
});

// 获取一天中所有的视频片段
如果设备能力级cameraInfo.getEvt() < 1时调用:
MeariUser.getInstance().getCloudVideoTimeRecordInDay(deviceId,year, month, day, new ICloudVideoTimeRecordCallback(){
    @Override
    public void onSuccess(String yearMonthDay, ArrayList<VideoTimeRecord> recordList) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});
如果设备能力级cameraInfo.getEvt() == 1时调用:
MeariUser.getInstance().getCloudShortVideoTimeRecordInDay(deviceId,year, month, day, new ICloudShortVideoTimeRecordCallback(){
    @Override
    public void onSuccess(long historyEventEnable, long cloudEndTime, String todayStorageType, String yearMonthDay, ArrayList<VideoTimeRecord> recordList, ArrayList<VideoTimeRecord> eventList) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});

// 获取云回放的视频信息
如果设备能力级cameraInfo.getEvt() < 1时调用:
MeariUser.getInstance().getCloudVideo(deviceid, index, year, month, day, new ICloudGetVideoCallback() {
    @Override
    public void onSuccess(String videoInfo, String startTime, String endTime) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});
如果设备能力级cameraInfo.getEvt() == 1时调用:
MeariUser.getInstance().getCloudShortVideo(deviceid, index, year, month, day, new ICloudGetShortVideoCallback() {
    @Override
    public void onSuccess(String videoInfo, String startTime, String endTime) {
        
    }

    @Override
    public void onError(int errorCode, String errorMsg) {

    }
});
```

## 6.3 设备相关
### 6.3.1 门铃接听流程

- 1 收取门铃呼叫消息
> 按门铃，收到门铃呼叫mqtt消息回调或推送消息
> 需要连接mqtt或接入推送
```
/**
 * 门铃呼叫回调
 * @param bellJson 门铃信息
 * @param isUpdateScreenshot 本次消息是否是更新图片；false-呼叫；true-更新图片
 */
public void onDoorbellCall(String bellJson, boolean isUpdateScreenshot);
```

- 2 弹出门铃接听页面
> 通过mqtt消息回调或点击推送消息弹出门铃接听页面
> 解析bellJson，展示相关信息
```
//获取门铃信息
bellJsonStr = bundle.getString("bellInfo");
try {
    JSONObject bellJsonObject = new JSONObject(bellJson);
    CameraInfo bellInfo = JsonUtil.getCameraInfo(bellJsonObject);
} catch (JSONException e) {
}
```

- 3 接听或挂断
> 处理接听、挂断等逻辑
> 接听与预览相似
```
// 接听
MeariUser.getInstance().postAnswerBell(bellInfo.getDeviceID(), String.valueOf(bellInfo.getMsgID()), new IStringResultCallback() {
    @Override
    public void onError(int code, String error) {
        if (code == 1045) {
            // 有人已接听
        } else {
            // 其他错误，关闭
        }
    }

    @Override
    public void onSuccess(String result) {
        acceptSuccess();
    }
});

private void acceptSuccess() {
    // 每20s发一次心跳
    MeariUser.getInstance().postSendBellHeartBeat(bellInfo.getDeviceID());
    // 开始打洞预览
    ...
}

// 挂断
MeariUser.getInstance().postHangUpBell(bellInfo.getDeviceID(), new IResultCallback() {
    @Override
    public void onSuccess() {
        // 关洞，关闭页面
        ...
    }

    @Override
    public void onError(int code, String error) {
        // 关洞，关闭页面
        ...
    }
});
```

### 6.3.2 主人留言

> 支持留言的门铃设备可以录制留言，并在接听的时候选择播放留言。

- 1 判断是否支持留言功能
```
if (MeariDeviceUtil.isSupportHostMessage(cameraInfo)) {
}

// 主人留言的最大条数
private int voiceMailMaxSize;
// 主人留言的最长时间(秒)
private int voiceMailDuration = 10;

if (cameraInfo.getHms() == 1) {
    voiceMailMaxSize = 1;
    voiceMailDuration = 30;
} else if (cameraInfo.getHms() == 2){
    voiceMailMaxSize = 3;
    voiceMailDuration = 10;
}
```

- 2 获取设备留言列表
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
- 3 录制留言并上传，需要获取麦克风权限
```
private String g711uFilePath;
private String wavFilePath;
private String pcmFilePath;

// 开始录制
controller.startRecordVoiceMail(pcmFilePath, g711uFilePath);

// 结束录制
controller.stopRecordVoiceMail();

// 转换格式
controller.changeG711u2WAV(g711uFilePath, wavFilePath, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
        
    }

    @Override
    public void onFailed(String errorMsg) {
    }
});

// 上传留言
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

- 4 控制设备播放留言
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

- 5 手机播放留言
```
// 下载留言
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

// 转换格式
controller.changeG711u2Pcm(wavFilePath, pcmFilePath, new MeariDeviceListener() {
    @Override
    public void onSuccess(String successMsg) {
    }

    @Override
    public void onFailed(String errorMsg) {
    }
});

// 播放留言
AudioUtil.getInstance().playPCM(pcmFilePath);
AudioUtil.getInstance().setOnPlayListener(flag -> {
    // 播放完成
    Message msg = Message.obtain();
    msg.what = MSG_PLAY_RECORD_COMPLETE;
    msg.obj = type;
    handler.sendMessage(msg);
});
```

# 7 分享设备

## 7.1 相关类介绍

ShareUserInfo 被分享者用户信息
- String userAccount; 用户账号
- String userName; 用户名称
- String userIcon; 用户头像
- String shareStatus; 分享状态。0-未分享；1-已分享；2-等待接收

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

# 8 消息中心
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

### 8.2.1 获取所有设备最新的消息
```
【描述】
获取所有设备最新的消息

【函数调用】
/**
 * 获取cameraInfo.getEvt() < 1的所有设设备最新的消息
 *
 * @param callback function callback
 */
public void getAllDeviceAlarmListWithNewestMsg(IBaseModelCallback callback);

/**
 * 获取cameraInfo.getEvt() == 1的所有设设备最新的消息
 *
 * @param callback function callback
 */
public void getAllDeviceAlarmListWithNewestMsgNew(IBaseModelCallback callback);

如果同时存在cameraInfo.getEvt() < 1和cameraInfo.getEvt() == 1的设备，需要同时请求上面两个接口并合并数据

【方法调用】

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
deviceID 设备ID
imageAlertType 消息类型     1:PIR报警类型   2:移动侦测报警类型  3:访客报警类型   6:噪音报警类型  7:哭声检查报警类型  8:人脸识别
9:呼叫消息类型   10:防拆报警类型  11:人形侦测  12:人脸侦测  17:智能车辆侦测  18:智能宠物侦测  19:智能包裹侦测  20:智能人形侦测
deviceName 设备名称需要从首页接口中根据设备ID获取
```

### 8.2.2 获取单个设备的报警消息
```
【描述】
获取单个设备的报警消息

【函数调用】
如果设备能力级cameraInfo.getEvt() < 1使用如下方法：
/**
 * 获取单个设备的报警消息（一次获取最新的20条，设备主人拉取后，服务器删除数据，注意保存数据）
 *
 * @param deviceId device id
 * @param day 日期 yyyyMMdd
 * @param callback function callback
 */
public void getAlertMsg(long deviceID, String day, IDeviceAlarmMessagesCallback callback);

如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 获取单个设备的报警消息（一次获取最新的20条，如果用户开通了云存储30天后服务器删除数据，未开通云存储7天后服务器删除数据）
 *
 * @param deviceId device id
 * @param day 日期 yyyyMMdd
 * @param index direction=1时传"0", direction=0时传当前最后一条消息的eventTime
 * @param direction 1: 刷新 0：加载更多
 * @param eventType 消息类型，用于过滤
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
 * @param aiType    ai分析类型，用于过滤
 "0": "人"
 "1": "宠物"
 "2": "有车辆驶来"
 "3": "有车辆停滞"
 "4": "有车辆驶离"
 "5": "包裹被放下"
 "6": "有滞留包裹"
 "7": "包裹被拿走"
 * @param callback function callback
 */
 public void getAlertMsgWithVideo(long deviceId, String day, String index, int direction, int eventType, int[] aiType, IDeviceAlarmMessagesCallback callback);
 如果想要获取所有的报警消息，eventType=0, aiType=null


【方法调用】

class DeviceAlarmMessage:
通用字段：
- long deviceID;//设备ID
- String deviceUuid;//设备唯一标识符
- int imageAlertType;//报警类型（PIR和Motion）
- int msgTypeID;//消息类型
- long userID;//用户Id
- long userIDS;//分享设备时为0，否则为用户Id
- String createDate;//上传时间
- String isRead;//是否已读
- String decibel;//分贝
- long msgID;//消息Id

cameraInfo.getEvt() < 1时独有字段
- String imgUrl;// 报警图片地址
- String tumbnailPic;//缩略图

cameraInfo.getEvt() == 1时独有字段
- long imageUrl;  // 报警图片地址 
- String eventTime; // 报警时间点
- List<AiVideoInfo> aiVideoInfo // ai检测的信息
AiVideoInfo 
name: people,car,pet,package
event: //  人和宠物默认为“come”，无其它状态
       //  包裹和车辆有三种状态，“come” “stay” “go”
       //  “come”对应“包裹被放下”、“有车辆驶来”
       //  “stay”对应 “ 有滞留包裹”、“有车辆停滞”
       //  “go”对应 “包裹被拿走” “有车辆驶离”
left: 报警图片中距离左边的距离 用于画框
top: 报警图片中距离上边的距离 用于画框
width: 框的宽度 用于画框
height: 框的高度 用于画框
- List<VideoInfo> videoUrl // 报警短视频的链接
VideoInfo
url: 下载链接
duration：视频长度
- long historyEventEnable // 设备升级到evt=1时的时间点

如果设备能力级cameraInfo.getEvt() < 1时调用:
MeariUser.getInstance().getAlertMsg(getMsgInfo().getDeviceID(), day, new IDeviceAlarmMessagesCallback() {
    @Override
    public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo) {

    }

    @Override
    public void onError(int code, String error) {
    }
});

如果设备能力级cameraInfo.getEvt() == 1时调用:
MeariUser.getInstance().getAlertMsgWithVideo(deviceId, day, index, direction, eventType, aiType, new IDeviceAlarmMessagesCallback() {
                @Override
                public void onSuccess(List<DeviceAlarmMessage> deviceAlarmMessages, CameraInfo cameraInfo) {
                
                }

                @Override
                public void onError(int code, String error) {
                    
                }
            });
下载下来的图片需要调用下面的方法解密：
/**
 * 解密方法
 *
 * @param url 图片下载链接
 * @param img 图片的字节数组
 * @param sn 设备sn
 * @param 设备密码，设备默认没有设置密码，传空Set
 * @return [byte[], bool] 图片数据和解密结果
 */
Object[] result = SdkUtils.handleEncodedImage(String url, byte[] img, String sn, Set<String> allPwd)

通过下面的方法来下载短视频：
/**
 * 生成m3u8到指定路径
 *
 * @param videoInfoList DeviceAlarmMessage中的videoUrl
 * @param path_m3u8 生成m3u8的文件路径
 */
String path_m3u8 = SdkUtils.getM3U8Path(List<VideoInfo> videoInfoList, String path_m3u8)

// 取第一个视频的链接判断是否是加密的
VideoInfo videoInfo = videoInfoList.get(0);
String url = videoInfo.getUrl();
String[] strList = url.split("__");
String v = strList[1];
if (v.startsWith("vn")) {
    // 非加密
    SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, "")
} else {
    String decKey = "";
    if (v.startsWith("v2")) {
        // license加密
        decKey = SdkUtils.formatLicenceId(cameraInfo.getSnNum());
        SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, decKey)
    } else {
        Set<String> curDecKey =  用户设置的密码
        keyCheckStr = v.split("-")[1];
        for (String key: curDecKey) {
            keyCheckStr=" + keyCheckStr + " " + MeariMediaUtil.checkVideoPwd(keyCheckStr, key));
            if (MeariMediaUtil.checkVideoPwd(keyCheckStr, key) == 0) {
                decKey = key;
                SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, decKey)
                break;
            } else {
                // 设备加密，提醒用户输入密码
            }
        }
    }        
}

/**
 * 通过m3u8下载mp4文件
 *
 * @param path_m3u8 m3u8的文件路径
 * @param path_mp4 mp4的文件路径
 * @param decKey 解密密码
 */
String path_m3u8 = SdkUtils.downloadMp4FromM3U8(String path_m3u8, String path_mp4, String decKey)

// 播放短视频
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
                // 播放成功
                
            }

            @Override
            public void mediaPauseCallback() {

            }

            @Override
            public void upDateProgress(long postion) {
                // 播放进度

            }

            @Override
            public void mediaPlayFailedCallback(int code) {
                // 播放失败

            }

            @Override
            public void playNext() {
                // 播放结束

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
// 开始播放
cloudPlayerController.play(path_mp4, "0");
// 从某一时间点(millisecond)播放
if (isEnd) {
    // 如果是已经结束状态就直接从seek的时间点重新开始播放
    cloudPlayerController.play(path_mp4, "0");
    cloudPlayerController.play(path_mp4, String.valueOf(millisecond / 1000));
} else  {
    cloudPlayerController.seekTo(millisecond);
}
```

### 8.2.3 删除设备的报警消息
```
【描述】
删除设备的报警消息

【函数调用】
刪除设备的报警消息
如果设备能力级cameraInfo.getEvt() < 1使用如下方法：
/**
 * 刪除设备的报警消息
 *
 * @param deviceIDs 设备ID列表
 * @param callback function callback
 */
public void deleteDevicesAlarmMessage(List<Long> deviceIDs, IResultCallback callback);

如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 刪除设备的报警消息
 *
 * @param deviceID 设备ID
 * @param callback function callback
 */
 public void delAlertEventByDevice(String deviceID, IResultCallback callback);

刪除设备的报警消息(按天)
如果设备能力级cameraInfo.getEvt() < 1，请根据日期删除缓存下来的消息

如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 刪除设备的报警消息(按天)
 *
 * @param deviceID 设备ID
 * @param day 日期 yyyyMMdd
 * @param callback function callback
 */
 public void delAlertEventByDay(String deviceID, String day, IResultCallback callback);

刪除设备的报警消息(按索引)
如果设备能力级cameraInfo.getEvt() < 1，请根据msgID删除缓存下来的消息

如果设备能力级cameraInfo.getEvt() == 1使用如下方法：
/**
 * 刪除设备的报警消息(按索引)
 *
 * @param deviceID 设备ID
 * @param indexList 索引列表，索引：deviceAlarmMessage.getEventTime()
 * @param callback function callback
 */
 public void delAlertEventByIndex(String deviceID, List<String> indexList, IResultCallback callback);

【方法调用】

刪除设备的报警消息
如果设备能力级cameraInfo.getEvt() < 1时调用:
MeariUser.getInstance().deleteDevicesAlarmMessage(deviceIDList, new IResultCallback() {
                @Override
                public void onSuccess() {

                }

                @Override
                public void onError(int code, String error) {
                    
                }
            });

如果设备能力级cameraInfo.getEvt() == 1时调用:
MeariUser.getInstance().delAlertEventByDevice(deviceID, new IResultCallback() {
                            @Override
                            public void onSuccess() {
                                
                            }

                            @Override
                            public void onError(int errorCode, String errorMsg) {
                                
                            }
                        });

刪除设备的报警消息(按天)
如果设备能力级cameraInfo.getEvt() == 1时调用:
MeariUser.getInstance().delAlertEventByDay(String.valueOf(cameraInfo.getDeviceID()), day, new IResultCallback() {
                @Override
                public void onError(int errorCode, String errorMsg) {

                }

                @Override
                public void onSuccess() {
                    
                }
            });

刪除设备的报警消息(按索引)
如果设备能力级cameraInfo.getEvt() == 1时调用:
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

# 9 设备设置
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
- int dnm; 日夜模式：0-不支持；1-支持日夜模式(自动，彩色，黑白)；2-支持全彩模式(智能夜视，全彩夜视，黑白夜视)
- int led; LED灯   ：0-不支持；1-支持
- int flp; 视频翻转：0-不支持；1-支持
- int bcd; 哭声检测：0-不支持；1-支持
- int ptr; 人形跟踪：0-不支持；1-支持
- int pdt; 人形检测：0-不支持；bit0=支持开关设置；bit1=支持画框开关设置；bit2=支持夜间过滤开关设置；bit3=支持白天过滤开关设置
- int ptz; 云台：0-不支持；1-支持上下左右；2-支持上下；3-支持左右
- int sla; 声光报警：0-不支持；1-支持


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
- int fullColorMode;  全彩模式：0-智能夜视；1-全彩模式；2-黑白夜视模式；
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
- int soundLightEnable;  声光报警开关：0-关；1-开；
- int soundLightType;  声光报警方式：0-声音报警；1-白光灯报警；2-声光报警；


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

### 9.5.20 报警频率设置
```
【描述】
报警频率设置

【函数调用】
/**
 * 报警频率设置
 *
 * @param alarmFrequency alarmFrequency
 * @param callback callback
 */
public void setAlarmFrequency(int alarmFrequency, ISetDeviceParamsCallback callback);

【代码范例】

// 判断是否支持报警频率设置
if (cameraInfo.getAfq() > 0) {
    int afq = cameraInfo.getAfq();
    // afq: 0-not support; 1-support
    afq      bit-0 bit-1 bit-2 bit-3 bit-4 bit-5
    name     off   1min  2min  3min  5min  10min
    setValue 0     1     2     3     4     5
}

// 当前选择的频率
int currentValue = deviceParams.getAlarmFrequency()

// 选择报警频率
MeariUser.getInstance().setAlarmFrequency(setValue, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.21 多档PIR设置
```
【描述】
多档PIR设置

【函数调用】
/**
 * 多档PIR设置
 *
 * @param pirDetSensitivity pirDetSensitivity
 * @param callback callback
 */
public void setPirDetectionSensitivity(int pirDetSensitivity, ISetDeviceParamsCallback callback);

【代码范例】

// 判断是否支持多档PIR设置
if (cameraInfo.getPlv() > 0) {
    int maxLevel = cameraInfo.getPlv();
    setValue 0-maxLevel
}

// 当前选择的值
int currentLevel = deviceParams.getPirDetLevel();

// 设置PIR的值
MeariUser.getInstance().setPirDetectionSensitivity(pirLevel, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.22 SD卡录像类型和时间设置
```
【描述】
SD卡录像类型和时间设置

【函数调用】
/**
 * SD卡录像类型和时间设置
 *
 * @param type     Recording type
 * @param duration Event recording time
 * @param callback Function callback
 */
public void setPlaybackRecordVideo(int type, int duration, ISetDeviceParamsCallback callback)

【代码范例】

// 判断是否支持事件录像和全天录像
if (cameraInfo.getVer() >= 57){
    if(cameraInfo.getRec() == 0) {
        // 支持事件录像和全天录像
    } else if(cameraInfo.getRec() == 1){
        // 仅支持事件录像
    }
} else {
    if (MeariDeviceUtil.isLowPowerDevice(cameraInfo)) {
        // 仅支持事件录像
    } else {
        // 支持事件录像和全天录像
    }
}

// 当前事件类型
int currenttype = deviceParams.getSdRecordType();
// 当前事件录像的时间
int currentDuration = deviceParams.getSdRecordDuration();

// 设置类型或时间
MeariUser.getInstance().setPlaybackRecordVideo(type, duration, new ISetDeviceParamsCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onFailed(int errorCode, String errorMsg) {
    }
});
```

### 9.5.23 设备全彩模式设置
```
【描述】
设备全彩模式设置

【函数调用】
/**
 * 设置全彩模式
 *
 * @param mode mode
 * @param callback Function callback
 */
public void setFullColorMode(int mode, ISetDeviceParamsCallback callback);

【代码范例】
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

### 9.5.24 设备声光报警设置
```
【描述】
设备声光报警设置

【函数调用】
/**
 * 设置声光报警开关
 *
 * @param enable enable
 * @param callback Function callback
 */
public void setFloodCameraVoiceLightAlarmEnable(int enable, ISetDeviceParamsCallback callback)
/**
 * 设置声光报警方式
 *
 * @param alarmType alarmType
 * @param callback Function callback
 */
public void setFloodCameraVoiceLightAlarmType(int alarmType, ISetDeviceParamsCallback callback)

【代码范例】
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

### 9.5.25 设备12小时开关设置
```

【描述】
设备12小时开关设置

【函数调用】
/**
 * 设备12小时开关设置
 *
 * @param isOpen true代表12小时制
 * @param callback Function callback
 */
public void postTimeFormat(boolean isOpen, IResultCallback callback) 


【代码范例】
//12小时制是否开启的标志位存储在本地，设备复位后就会重置成24小时。
MeariUser.getInstance().postTimeFormat(isOpen, new IResultCallback() {

            @Override
            public void onError(int errorCode, String errorMsg) {
                
            }

            @Override
            public void onSuccess() {
                
            }
        });
```


### 9.5.26 设备抗闪烁设置
```

【描述】
设备抗闪烁设置

【函数调用】
/**
 * 设备抗闪烁设置
 *
 * @param antiflicker true代表12小时制
 * @param callback Function callback
 */
public void setAntiflicker(int antiflicker, ISetDeviceParamsCallback callback) 


【代码范例】
1.是否支持抗闪烁
/**
     *
     * 属性  抗闪烁设置
     * - type: integer
     * - description: 是否支持抗闪烁能力级：
     * 0-不支持, 按比特来赋值, 0x1-支持50HZ, 0x2-支持60HZ, 0x4-支持自动, 0x8=支持关闭, 对应DP点202
     */
flk=cameraInfo.getFlk()
if (flk > 0) {
            if (1 << 3 == (1 << 3 & flk)) {
//                0x8=支持关闭
            }
            if (1 == (1 & flk)) {
              //0x1-支持50HZ
            }
            if (1 << 1 == (1 << 1 & flk)) {
//               0x2-支持60HZ
               
            }
            if (1 << 2 == (1 << 2 & flk)) {
//                0x4-支持自动
                
            }
        }

2.当前抗闪烁的设置
/**
     * 抗闪烁设置 //0-关闭, 1-50HZ, 2-60HZ, 3-自动
     */
    private int antiflicker;
antiflicker=deviceParams.getAntiflicker();

3.设置抗闪烁
MeariUser.getInstance().setAntiflicker(antiflicker, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
```

### 9.5.27 设备麦克风、录音、扬声器设置
```

【描述】
设备麦克风、录音、扬声器设置
【注意事项】
1.麦克风（关闭同时关闭录像声音）
2.麦克风打开，录像声音才可以打开

【代码范例】
1.麦克风
/**
     *  - microphone
     *         - description: 麦克风使能开关, 0=禁用， 1=使能
     *         - type: integer
     */
    private int microphone;
    //获取当前麦克风开关状态
    microphone=deviceParams.getMicrophone()
//设置麦克风开关
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

2.扬声器
/**
     *
     *     - speaker
     *         - description: 喇叭使能开关，0=禁用，1=使能
     *         - type: integer
     */
    private int speaker;
    //获取当前扬声器开关状态
    speaker=deviceParams.getSpeaker()
//设置扬声器开关
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

 3.音量
/**
     * 对讲时(门铃、电池摄像机)的喇叭音量：0-100
     */
    private int speakVolume;
    //获取当前音量
    speakVolume=deviceParams.getSpeakVolume()
//设置音量开关
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

 4.录像声音开关
/**
     *
     *     录像声音开关
     *     rec_audio_en
     *         - type: integer
     *         - description: 录像声音开关, 全局开关，保护SD卡和云存储
     */
    private int rec_audio_en;
    //获取当前录像声音开关
    rec_audio_en=deviceParams.getRec_audio_en()
//设置录像声音开关

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


### 9.5.28 设备视频加密设置
```
【描述】
设备视频加密设置
【注意事项】
1.视频加密的密码全部保存在本地，不存储云端，增加隐私性。
2.设备重新添加后视频加密会关闭，可以重新设置密码，但是想查看之前的本地录像和云录像就需要当时设置的视频密码来解密。如果本地没有存储当时的密码需要让用户输入。
3.一个设备每个密码使用时期使用了那个密码查看对应时期需要对应的密码，无法通用，本地如果存储了可以遍历去打洞。
4.视频加密可以校验当前密码后才能关闭，可以不校验直接关闭，防止用户忘记密码后不知道能通过重新添加设备重置状态。
5.主人才允许设置密码camerainfo.isMaster()

【代码范例】
//是否设置了视频加密
/**
     * 用户访问密码是否设置  未设置 - 0；已设置 - 1；
     * @return
     */
int isVideoSetPwd= deviceParams.getIsVideoSetPwd()
获取到数值后存储本地
MMKVUtil.setData(DEVICE_VIDEO_PASSWORD_IS_SET+snNum,isVideoSetPwd);
//如果设置了视频密码，就需要从本地获取存储的密码或者让用户输入，将密码存储到对应的
MMKVUtil.setData(DEVICE_VIDEO_PASSWORD+snNum,pwd);中。
打洞时会从对应的本地取出密码校验，打洞如果失败返回错误码-18代表密码错误，需要用户重新输入。

//设置密码（修改密码）并打开视频加密
MeariUser.getInstance().setVidePwd(pwd, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                //该设备是否设置密码
                MMKVUtil.setData(DEVICE_VIDEO_PASSWORD_IS_SET+snNum,1);
                //更新密码值
                MMKVUtil.setData(DEVICE_VIDEO_PASSWORD+snNum,pwd);
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });

//关闭视频加密
MeariUser.getInstance().setVidePwdSwitch(new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
            MMKVUtil.setData(DEVICE_VIDEO_PASSWORD_IS_SET + cameraInfo.getSnNum(), 0);
                                               
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                                                
            }
            });
//修改密码前打洞校验用户输入的密码是否正确    
private MeariDeviceController controller;  
controller = new MeariDeviceController(cameraInfo);
        controller.startConnect(pwdOldTxt,new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
                //校验通过
                
            }

            @Override
            public void onFailed(String errorMsg) {
                dismissLoading();
                try {
                    BaseJSONObject object = new BaseJSONObject(errorMsg);
                    int errorCode = object.optInt("code");
                    if (errorCode == -18) {
                        //鉴权密码错误
                        
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });                                  

```


### 9.5.29 设备防拆报警设置
```

【代码范例】
/**
     * 
     * 防拆报警能力级，0=不支持，1=支持
     */
    private int fcb;
//fcb=1才支持防拆报警
fcb=camerainfo.getFcb();
//获取防拆报警开关设置
    deviceParams.getRemoveProtectEnable()
//设置防拆报警开关
    MeariUser.getInstance().setRemoveProtectAlert(isCheck ? 1 : 0, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
```

### 9.5.30 设备变声设置
```
【描述】
设备变声设置
【注意事项】
cameraInfo.getVtk() == 4
表示支持双向对讲，支持双向对讲的才有变声
【代码范例】
/**
*soundTouchType   变声参数 正常 0   大叔  1    小丑 2
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
### 9.5.31 设备工作模式
```
【描述】
设备工作模式
【函数调用】
/**
*lwm：0-不支持，1-支持工作模式，2-支持工作模式增加持续录像模式
* 描述：lwm=2，在原有的省电模式、性能模式、自定义模式基础上，增加持续录像模式选项
如果不支持，则只支持自定义模式。
**/
cameraInfo.getLwm()
//设置工作模式
public void setWorkMode(int workmode, ISetDeviceParamsCallback callback)
【代码范例】
/**
*workmode   省电模式 0    性能模式 1    自定义模式 2    常电模式 3 
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
### 9.5.32 人形报警区域（画框）设置
```
【描述】
人形报警区域（画框）设置
【代码范例】
int pdt = cameraInfo.getPdt();
if (cameraInfo.getVer() >= 12 && pdt != -1 && 1 << 1 == (1 << 1 & pdt)) {
            //支持
        } else {
            //不支持
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

### 9.5.33 人形开关设置
```
【描述】
人形开关设置
【代码范例】
val pdt: Int = cameraInfo.pdt
if (info.ver >= 12) {
            if (pdt != -1 && 1 == 1 and pdt) {
                //支持设置人形开关
            } 
            if (pdt != -1 && 1 shl 2 == 1 shl 2 and pdt) {
                //支持夜间，不再设置人形开关
            } 
            if (pdt != -1 && 1 shl 3 == 1 shl 3 and pdt) {
                //支持白天，不再设置人形开关
            }
        }


【人形侦测使能开关】：0-关；1-开；
deviceParams.humanDetEnable == 1
设置
MeariUser.getInstance().setHumanDetection(status, object : ISetDeviceParamsCallback)


【白天人形侦测使能开关】：0-关；1-开；
deviceParams.humanDetDayEnable == 1

MeariUser.getInstance().setHumanDetectionDay(status, object : ISetDeviceParamsCallback)

【夜间人形侦测使能开关】：0-关；1-开；
deviceParams.humanDetNightEnable == 1

MeariUser.getInstance().setHumanDetectionNight(status, object : ISetDeviceParamsCallback)


【灵敏度】
//0-不支持，3-支持3档灵敏度，5-支持5档灵敏度，10-支持10档灵敏度
pds = info.pds

设置灵敏度（几档就设置几，不能超过最大支持档位）
MeariUser.getInstance().setHumanDetectionSensitivity(pirLevel, object : ISetDeviceParamsCallback)
```

### 9.5.34 录像时长设置
```
【描述】
录像时长设置
【代码范例】
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

获取录像时长（单位 s,比如180s值就是180）
deviceParams.sdRecordDuration

设置录像时长(value代表时长，单位 s,比如180s就传180)
MeariUser.getInstance().setPlaybackRecordVideo(deviceParams.sdRecordType, value, object : ISetDeviceParamsCallback )
```



### 9.5.35 音乐播放设置
```
【描述】
音乐播放设置（需要sd卡可用）
【代码范例】
·是否支持音乐播放设置：0-不支持,1-支持
cameraInfo.getMpc()
·获取音乐列表
MeariUser.getInstance().getMusicListNew(new IGetMusicListCallback(){
            @Override
            public void onSuccess(ArrayList<MeariMusic> songInfos) {
                
            }

            @Override
            public void onError(int code, String error) {

            }
        });
·获取当前音量
MeariUser.getInstance().getMusicVolume(new IGetMusicVolumeCallback() {
            @Override
            public void onSuccess(int volume) {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });  
·设置当前音量
MeariUser.getInstance().setMusicVolume(value, new ISetDeviceParamsCallback() {
                    @Override
                    public void onSuccess() {

                    }

                    @Override
                    public void onFailed(int errorCode, String errorMsg) {

                    }
                });       
·刷新当前歌曲状态
MeariUser.getInstance().getPlayMusicStatus(new IRefreshMusicStatusCallback() {
            @Override
            public void onSuccess(String currentMusicId, boolean isPlaying, ArrayList<MeariMusic> musicList) {
                当前歌曲-currentMusicId
                是否正在播放-isPlaying
                音乐列表-musicList
                当前歌曲正在下载中-info.getDownloadPercent() < 100
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
            
            }
        });   
·播放歌曲
MeariUser.getInstance().playMusic(curMusicId, new IControlMusicCallback() {
            @Override
            public void onSuccess(String currentMusicID) {
            
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {

            }
        });     
·暂停歌曲
MeariUser.getInstance().pauseMusic(curMusicId, new IControlMusicCallback() {
            @Override
            public void onSuccess(String currentMusicID) {
            
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {

            }
        });                    
·是否支持音乐播放时长设置 0-不支持, bit0-on(持续播放) bit1-10min bit2-30min bit3-60min
cameraInfo.getMul()
  -播放时长列表
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
   -获取当前播放时长设置(s)
   deviceParams.getMusicTime()  
   -设置当前播放时长(s)
   MeariUser.getInstance().setMusicTime(time, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
               
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });
·是否支持音乐播放模式设置 0-不支持 bit1:顺序播放 bit2-单曲循环 bit3-随机播放
cameraInfo.getMpm()
   -获取当前播放模式（0表示顺序播放（默认）1表示单曲循环 2表示随机播放）
   deviceParams.getMusicCyclical()
   -设置播放模式（0表示顺序播放（默认）1表示单曲循环 2表示随机播放）
   MeariUser.getInstance().setMusicCyclical(mode, new IControlMusicCallback() {
                @Override
                public void onSuccess(String currentMusicID) {
                    
                }

                @Override
                public void onFailed(int errorCode, String errorMsg) {

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

## 9.8 AOV摄像机参数设置
### 9.8.1 预览切换实时省流
```
【描述】
预览页面切换实时省流

【函数调用】
/**
 * 是否支持实时省流
 */
MeariDeviceUtil.isSupportFps(cameraInfo);

/**
*切换实时省流需要调用MeariDeviceController时将这段设置进去
*isLowFps   实时：0   省流：1
**/
if (MeariDeviceUtil.isSupportFps(cameraInfo)) {
     deviceController.setExtraPreviewParams(isLowFps);
}

【代码范例】
//设置当前是省流还是实时模式
if (MeariDeviceUtil.isSupportFps(cameraInfo)) {
     deviceController.setExtraPreviewParams(isLowFps);
}
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
```
### 9.8.2 工作模式
```
【描述】
工作模式
【代码范例】
/**
*判断支持哪些模式
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
                //省电模式/Power Saving Mode
            }
            if (1 << 1 == (1 << 1 & lwm)) {
                //性能模式/Performance Mode
            }
            if (1 << 2 == (1 << 2 & lwm)) {
                //自定义模式/Custom Mode
            }
            if (1 << 3 == (1 << 3 & lwm)) {
                //常电模式/Always-on Mode
            }
        }

        /*
        **当前处于哪种模式
        *0-省电模式, 1-性能模式, 2-自定义模式  3-常电模式
        */
        mode = deviceParams.getAovWorkMode();
        if(isSMB) {
            mode = deviceParams.getAovWorkMode();
        }else {
            mode = deviceParams.getWorkMode();
        }


        //设置工作模式
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
### 9.8.3 自定义参数设置
```
【描述】
自定义模式的参数设置
【代码范例】
1.事件录像延时
        int erd = cameraInfo.getErd();
        if (erd > 0) {
    
            if (1 == (1 & erd)) {
                //3s（value=0）
                 
            }
            if (1 << 1 == (1 << 1 & erd)) {
                //6s（value=1）
               
            }
            
        }

    //获取当前值
     value=deviceParams.getAovRecordDelay();


        //设置事件录像延时
     MeariUser.getInstance().setAOVRecordDelay(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });


        2.补光距离  
        //- description: 是否支持补光距离配置，0-不支持, bit0-自动 bit1-10m bit2-20m bit3-30m
        int sld = cameraInfo.getSld();
        if (sld > 0) {
           
            if (1 == (1 & sld)) {
                //自动（value=0）
            
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

        //获取当前值
        value=deviceParams.getAovComplementaryDistance()
        
        //设置
        MeariUser.getInstance().setAovComplementaryDistance(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });



        3.夜景模式
        //0-不支持, bit0-普通模式 bit1-增强模式
        int nms = cameraInfo.getNms();
        if (nms > 0) {
            
            if (1 == (1 & nms)) {
                //普通模式/Normal Mode（value=0）
            }
            if (1 << 1 == (1 << 1 & nms)) {
                //增强模式/Enhanced Mode（value=1）
            }
        }

        //获取当前值
        value=deviceParams.getAovNightMode()
        //设置
        MeariUser.getInstance().setAovNightMode(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
               
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                
            }
        });

        4.全时录像帧率
        if (cameraInfo.getSfi() > 0) {
            //0-不支持, >0-支持;按bit位显示可设置的单帧间隔，bit0-1秒，bit1-2秒，bit2-3秒，bit3-5秒，bit4-10秒，bit5-15秒，bit6-20秒，bit7-30秒，bit8-60秒,bit9关闭
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

        //获取值
        value=deviceParams.getFullTimeFrameRate()

        //设置
        MeariUser.getInstance().setAOVFrameRate(value, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
               
            }
        });

```
# 10 家庭

## 10.1 家庭操作

### 10.1.1 获取家庭列表
```
【描述】
获取家庭列表

【函数调用】
/**
 * 获取家庭列表
 *
 * @param callback callback
 */
public void getFamilyList(IFamilyListCallback callback)

【代码范例】
MeariUser.getInstance().getFamilyList(new IFamilyListCallback() {
    @Override
    public void onSuccess(List<MeariFamily> familyList) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.1.2 创建家庭
```
【描述】
创建家庭，最多10个房间

【函数调用】
/**
 * 创建家庭，最多10个房间
 *
 * @param callback callback
 */
public void createFamily(String familyName, String familyLocation, List<MeariRoom> roomList, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().createFamily(familyName, familyLocation, roomList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.1.3 更新家庭信息
```
【描述】
更新家庭信息

【函数调用】
/**
 * 更新家庭信息
 *
 * @param callback callback
 */
public void updateFamily(String familyId, String familyName, String familyLocation, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().updateFamily(familyId, familyName, familyLocation, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.1.4 删除家庭
```
【描述】
删除家庭

【函数调用】
/**
 * 删除家庭
 *
 * @param callback callback
 */
public void deleteFamily(String familyId, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().deleteFamily(familyId, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

## 10.2 家庭分享

### 10.2.1 搜索要添加的成员账号
```
【描述】
搜索要添加的成员账号

【函数调用】
/**
 * 搜索要添加的成员账号
 *
 * @param account account
 * @param familyId  familyId
 */
public void searchContactForAddFamilyMember(String account, String familyId, IBaseModelCallback<FamilyMemberToAdd> callback)

【代码范例】
MeariUser.getInstance().searchContactForAddFamilyMember(account, familyId, new IBaseModelCallback<FamilyMemberToAdd>() {
    @Override
    public void onSuccess(FamilyMemberToAdd familyMemberToAdd) {
    }

    @Override
    public void onFailed(int code, String errorMsg) {
    }
});
```

### 10.2.2 搜索要加入的家庭账号
```
【描述】
搜索要加入的家庭账号

【函数调用】
/**
 * 搜索要加入的家庭账号
 *
 * @param account account
 */
public void searchContactForJoinFamily(String account, IBaseModelCallback<MeariFamilyToJoin> callback)

【代码范例】
MeariUser.getInstance().searchContactForJoinFamily(account, new IBaseModelCallback<MeariFamilyToJoin>() {
    @Override
    public void onSuccess(MeariFamilyToJoin meariFamilyToJoin) {
    }

    @Override
    public void onFailed(int code, String errorMsg) {
    }
});
```

### 10.2.3 添加成员到家庭中
```
【描述】
添加成员到家庭中

【函数调用】
/**
 * 添加成员到家庭中
 *
 * @param familyId    family id
 * @param memberId    member user id
 * @param permissions List of permissions for device control
 * @param callback    callback
 */
public void addMemberToFamily(String familyId, String memberId, List<DevicePermission> permissions, IResultCallback callback)

【代码范例】
MeariUser.getInstance().addMemberToFamily(familyId, memberId, permissions, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.4 加入一个家庭
```
【描述】
加入一个家庭

【函数调用】
/**
 * 加入一个家庭
 *
 * @param familyIdList family id list to join
 * @param callback     callback
 */
public void joinFamily(List<String> familyIdList, IResultCallback callback) {

【代码范例】
MeariUser.getInstance().joinFamily(familyIdList, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.5 获取家庭分享消息
```
【描述】
获取家庭分享消息

【函数调用】
/**
 * 获取家庭分享消息
 */
public void getFamilyShareMessages(IBaseModelCallback<List<FamilyShareMsg>> callback)

【代码范例】
MeariUser.getInstance().getFamilyShareMessages(new IBaseModelCallback<List<FamilyShareMsg>>() {
    @Override
    public void onSuccess(List<FamilyShareMsg> familyShareMsgs) {
    }

    @Override
    public void onFailed(int code, String errorMsg) {
    }
});
```

### 10.2.6 处理家庭分享消息
```
【描述】
处理家庭分享消息

【函数调用】
/**
 * @param dealFlag 0-拒绝，1-同意
 */
public void dealFamilyShareMessage(List<String> msgIDList, int dealFlag, IResultCallback callback)

【代码范例】
MeariUser.getInstance().dealFamilyShareMessage(msgIDList, dealFlag, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```


### 10.2.7 获取家庭成员列表
```
【描述】
获取家庭成员列表

【函数调用】
/**
 * 获取家庭成员列表
 *
 * @param callback callback
 */
public void getFamilyMemberList(String familyId, IFamilyMemberListCallback callback)

【代码范例】
MeariUser.getInstance().getFamilyMemberList(familyId, new IFamilyMemberListCallback() {
    @Override
    public void onSuccess(List<FamilyMember> familyMemberList) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.8 修改家庭成员设备权限
```
【描述】
修改家庭成员设备权限

【函数调用】
/**
 * 修改家庭成员设备权限
 *
 * @param callback callback
 */
public void modifyMemberDevicePermission(String familyId, String memberID, List<DevicePermission> permissions, IResultCallback callback)

【代码范例】
MeariUser.getInstance().modifyMemberDevicePermission(familyId, memberID, permissions, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.9 从家庭移除成员
```
【描述】
从家庭移除成员

【函数调用】
/**
 * 从家庭移除成员
 *
 * @param callback callback
 */
public void removeMemberFromFamily(String familyId, String memberID, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().removeMemberFromFamily(familyId, memberID, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.10 撤销成员邀请
```
【描述】
撤销成员邀请

【函数调用】
/**
 * 撤销成员邀请
 */
public void revokeMemberInvitation(String familyId, String msgId, IResultCallback callback)

【代码范例】
MeariUser.getInstance().revokeMemberInvitation(familyId, msgId, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.2.11 离开家庭
```
【描述】
离开家庭

【函数调用】
/**
 * 离开家庭
 *
 * @param callback callback
 */
public void leaveFamily(String familyId, IResultCallback callback)

【代码范例】
MeariUser.getInstance().leaveFamily(familyId, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```
## 10.3 房间操作

### 10.3.1 添加房间
```
【描述】
添加房间

【函数调用】
/**
 * 添加房间
 *
 * @param callback callback
 */
public void addRoom(String familyId, String roomName, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().addRoom(familyId, roomName, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.2 修改房间信息
```
【描述】
修改房间信息

【函数调用】
/**
 * 修改房间信息
 */
public void updateRoom(String familyId, String roomId, String roomName, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().updateRoom(familyId, roomId, roomName, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.3 删除房间
```
【描述】
删除房间

【函数调用】
/**
 * 删除房间
 *
 * @param callback callback
 */
public void deleteRoom(String familyId, List<String> roomIdList, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().deleteRoom(familyId, roomIdList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.4 添加设备到房间
```
【描述】
添加设备到房间

【函数调用】
/**
 * 添加设备到房间
 *
 * @param callback callback
 */
public void addDeviceToRoom(String familyId, String roomId, List<CameraInfo> deviceList, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().addDeviceToRoom(familyId, roomId, deviceList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.5 从房间移除设备
```
【描述】
从房间移除设备

【函数调用】
/**
 * 从房间移除设备
 *
 * @param callback callback
 */
public void removeDeviceFromRoom(String familyId, String roomId, List<CameraInfo> deviceList, IStringResultCallback callback)

【代码范例】
MeariUser.getInstance().removeDeviceFromRoom(familyId, roomId, deviceList, new IStringResultCallback() {
    @Override
    public void onSuccess(String result) {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

### 10.3.6 批量删除设备
```
【描述】
批量删除设备

【函数调用】
/**
 * 批量删除设备
 */
public void deleteDeviceBatch(List<String> deviceIDList, IResultCallback callback)

【代码范例】
MeariUser.getInstance().deleteDeviceBatch(deviceIDList, new IResultCallback() {
    @Override
    public void onSuccess() {
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});
```

## 10.4 家庭相关类

### 10.4.1 MeariFamily
```
private String familyId; 家庭ID
// 默认家庭的名称为空，可以根据"userName"确定名称，或自定义名称
String familyName; 家庭名称
boolean owner; 是否是自己的家庭
boolean isDefault; 是否是默认家庭
String userName; 用户名称
String location; 家庭地址
List<MeariRoom> roomList; 家庭房间列表
List<CameraInfo> familyDeviceList; 家庭设备列表
```
### 10.4.2 MeariRoom
```
private String roomId; 房间ID
// 默认家庭的默认房间名称为空，可以根据"roomTarget"，自己确定名称
private String roomName; 房间名称
private int roomTarget; 房间标志位
private List<CameraInfo> roomDeviceList; 房间设备聊表
```

### 10.4.3 DevicePermission
```
// familyMemberToAdd.getFamilyDevices().get(i).getDeviceID()
String deviceID;
// 0-仅可查看；1-允许查看和控制
int permission;
```

### 10.4.4 FamilyShareMsg
```
long date; 时间
String msgID; 消息ID
String receiverName; 消息处理者名称
String inviterName; 消息发起者名称
long inviter; 消息发起者ID
String familyName; 家庭名称
int msgType; 消息类型：1-添加成员；2-加入家庭
int dealFlag; 消息处理标志位：0-拒绝；1-同意；2-处理中

if (MeariUser.getInstance().getUserInfo().getUserID() == msg.inviter) {
    // 消息发起者
    if(msgType == 1) {
        if(dealFlag == 2) {
            您正在邀请 receiverName 加入您的家庭： familyName
        } else if(dealFlag == 1){
            receiverName 已经加入您的家庭： familyName
        } else {
            receiverName 拒绝加入您的家庭： familyName
        }
    } else {
        if(dealFlag == 2) {
            您正在申请加入 receiverName 的家庭： familyName
        } else if(dealFlag == 1){
            receiverName 同意您加入家庭： familyName
        } else {
            receiverName 拒绝您加入家庭： familyName
        }
    }
} else {
    // 消息处理者
    if(msgType == 1) {
        if(dealFlag == 2) {
            inviterName 邀请您加入他的家庭： familyName
            // 点击处理：MeariUser.getInstance().dealFamilyShareMessage()
        } else if(dealFlag == 1){
            您已经加入了 inviterName 的家庭： familyName
        } else {
            您拒绝加入 inviterName 的家庭： familyName
        }
        
    } else {
        if(dealFlag == 2) {
            inviterName 申请加入您的家庭： familyName
            //点击处理：MeariUser.getInstance().dealFamilyShareMessage()
        } else if(dealFlag == 1){
            您同意 inviterName 加入您的家庭： familyName
        } else {
            您拒绝 inviterName 加入您的家庭：familyName
        }
    }
}
```

### 10.4.5 FamilyMember
```
String userId; 成员ID
String userAccount; 成员账号
String nickName; 成员昵称
String imageUrl; 成员头像
int isMaster; 是否是主人
int joinStatus; 成员加入状态：1-已加入；2-加入中
String msgId; 消息ID
```

# 11 MQTT和推送

```
meari SDK 支持内部的MQTT推送消息，也支持FCM等厂商推送（后续会陆续支持）
```

## 11.1 MQTT消息
```
用于接收设备添加成功消息、门铃呼叫消息、语音门铃呼叫消息、异地登录等消息
```

### 11.1.1 连接MQTT服务

5.3.0不需要调用，内部会自动调用

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

/**
 * 家庭相关的mqtt消息
 * @param familyMqttMsg 家庭MQTT消息
 */
void onFamilyMessage(FamilyMqttMsg familyMqttMsg);
// 处理家庭消息
// 默认家庭名称为空，更新默认家庭名称
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
    // 家庭信息改变，刷新家庭列表
} else if (familyMqttMsg.getMsgId() == MqttMsgType.FAMILY_MEMBER_INFO_CHANGED) {
    // 成员信息改变，刷新成员信息
} else if (familyMqttMsg.getMsgId() == MqttMsgType.INVITE_JOIN_HOME) {
    // 他人邀请您加入他的家庭，弹窗并处理消息
    // MeariUser.getInstance().dealFamilyShareMessage()
} else if (familyMqttMsg.getMsgId() == MqttMsgType.INVITE_JOIN_HOME_SUCCESS) {
    // 您加入家庭成功，刷新家庭列表
} else if (familyMqttMsg.getMsgId() == MqttMsgType.APPLY_ENTER_HOME) {
    // 他人申请加入您的家庭，弹窗并处理消息
    // MeariUser.getInstance().dealFamilyShareMessage()
} else if (familyMqttMsg.getMsgId() == MqttMsgType.APPLY_ENTER_HOME_SUCCESS) {
    // 申请加入家庭成功，刷新家庭列表
} else if (familyMqttMsg.getMsgId() == MqttMsgType.REMOVE_FROM_FAMILY) {
    // 您被移除家庭，刷新家庭列表
}

```
## 11.2 MQTT相关类

### 11.2.1 MqttMsg
> MQTT消息基类
```
int msgId; 消息 ID
String userCountryCode; 用户国家代号
int userIotType; 用户IOT类型
long t; 消息时间
```

### 11.2.2 FamilyMqttMsg extends MqttMsg
> 家庭MQTT消息
```
String familyId; 家庭 ID
String familyName; 家庭名称
String userName; 用户名称
final List<MsgItem> itemList; 消息中的列表
```

### 11.2.3 MsgItem
> 消息中的列表项
```
String id;  Item ID
String name; Item名字
boolean isCheck; 是否选中
```

## 11.3 集成谷歌推送
首先, 参考教程: [Add Firebase to your Android project](https://firebase.google.com/docs/android/setup) 和 [Set up a Firebase Cloud Messaging client app on Android](https://firebase.google.com/docs/cloud-messaging/android/client), 把firebase设置界面生成的admin sdk文件发送给meari服务器配置，在app中获取fcm token并调用MeariUser.getInstance().postPushToken(1, token, callback)上传token

## 11.4 集成其他推送
```
联系服务器配置其他推送
```

# 12 云存储服务
## 12.1 云存储服务状态
```
【描述】
获取云存储信息

【函数调用】
/**
 * 获取云存储信息
 *
 * @param deviceID deviceID
 * @param callback callback
 */
public void getCloudServiceInfo(String deviceID, ICloudServiceCallback callback)

【代码范例】
MeariUser.getInstance().getCloudServiceInfo(mCameraInfo.getDeviceID(), new ICloudServiceCallback() {
    @Override
    public void onSuccess(CloudServiceInfo serviceInfo) {
        
    }

    @Override
    public void onError(int code, String error) {

    }
});


// 1、未开通可试用；2、未开通不可试用；3、已开通；4、已过期。
int cloudStatus =  mCameraInfo.getCloudStatus();

CloudServiceInfo：

// 云服务事件录像价格信息
private CloudPriceInfo eventCloudPriceInfo;
// 云服务全天录像价格信息
private CloudPriceInfo continueCloudPriceInfo;
// 视频保存时间
private int storageTime;
// 价格符号：￥ $
private String currencySymbol;
// 云服务可以试用的时间。默认为7
private int tryTime = 7;
// 云服务试用时间的单位。默认为天。
private String tryUnit = "D";
// 云服务的截止日期
private long dueDate=0;


CloudPriceInfo：

// 3天包月价格
private BigDecimal threeM;
// 3天包季价格
private BigDecimal threeS;
// 3天包年价格
private BigDecimal threeY;
// 7天包月价格
private BigDecimal sevenM;
// 7天包季价格
private BigDecimal sevenS;
// 7天包年价格
private BigDecimal sevenY;
// 30天包月价格
private BigDecimal thirtyM;
// 30天包季价格
private BigDecimal thirtyS;
// 30天包年价格
private BigDecimal thirtyY;
```
## 12.2 云存储试用
```
【描述】
云存储试用

【函数调用】
/**
 * 云存储试用
 *
 * @param deviceID deviceID
 * @param callback callback
 */
public void freeTrialCloudService(String deviceID, IResultCallback callback)

【代码范例】
MeariUser.getInstance().freeTrialCloudService(mCameraInfo.getDeviceID(), new IResultCallback() {
    @Override
    public void onSuccess() {
        
    }

    @Override
    public void onError(int code, String error) {
        
    }
});
```
## 12.3 云存储激活码使用
```
【描述】
云存储激活码使用

【函数调用】
/**
 * 云存储激活码使用
 *
 * @param actCode activation code
 * @param deviceID deviceID
 * @param callback callback
 */
public void requestActive(String actCode, String deviceID, final IResultCallback callback, Object tag)

【代码范例】
MeariUser.getInstance().requestActive(actCode, mCameraInfo.getDeviceID(), new IResultCallback() {
    @Override
    public void onSuccess() {

    }

    @Override
    public void onError(int code, String error) {

    }
}, this);
```
## 12.4 云存储购买
```
详见Demo
```

# 13 NVR

## 13.1 添加NVR
```
详见：有线配网添加设备
```
## 13.2 添加摄像机到NVR通道

### 13.2.1 添加在线摄像机
```
【描述】
如果摄像机已经在线，使摄像机和NVR处于同一个局域网，摄像机开启允许被Nvr连接，5分钟内，NVR搜索并添加摄像机到通道

【函数调用】
/**
 * 获取允许被nvr发现的状态
 */
public void getNvrConnectableStatus(INvrConnectableCallback callback)
/**
 * 设置是否允许被nvr连接：0-不可以；1-可以
 * 开启后5分钟自动关闭
 */
public void setNvrConnectable(int enable, IStringResultCallback callback)
/**
 * 获取允许被nvr连接的剩余时间，单位秒
 */
public void getNvrConnectableTimeLeft(IIntegerPropertyCallback callback)

/**
 * nvr开始搜索设备
 */
public void nvrStartSearchDevice(IStringResultCallback callback)
/**
 * nvr获取搜索结果
 */
public void nvrGetSearchResult(INVRSearchCallback callback)
/**
 * nvr添加meari设备
 * ip-搜索到设备的IP地址
 */
public void nvrAddDevice(String ip, INVRAddCallback callback)
/**
 * nvr添加onvif设备
 * ip-搜索到设备的IP地址；user-onvif用户名；pwd-onvif密码
 */
public void nvrAddOnvifDevice(String ip, String user, String pwd, INVRAddCallback callback)

【代码范例】

// 摄像机是否支持允许被Nvr连接
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
// 摄像机是否已经添加到NVR
private boolean isAdded;
// 摄像机是否可以被NVR连接
private int connectable;
// 摄像机连接的NVR的ID
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
        // finish：false-正在搜索，继续获取结果；true-搜索结束,停止获取结果
    }

    @Override
    public void onError(int errorCode, String errorMsg) {
    }
});

NvrAddInfo：
// 唯一标志
private String id;
// 0-Meari摄像机; 1-onvif摄像机
private int type;
// Meari摄像机 sn
private String sn;
// 摄像机 IP 地址
private String ip;
// 0-未添加；1-已添加；2-添加失败
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
### 13.2.2 连接NVR添加摄像机
```
【描述】
如果摄像机不在线，获取NVR的token生成二维码，摄像机扫码后，将连接NVR，并添加到NVR通道

【函数调用】
/**
 * 创建Token二维码
 */
public void createNvrTokenQRCode(String token, ICreateQRCodeCallback callback)

【代码范例】

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
### 13.2.3 连接路由器添加摄像机
```
【描述】
如果摄像机不在线，获取NVR的key和wifi名、密码生成二维码，摄像机扫码后，将连接路由器，NVR将自动添加设备到通道，搜索添加结果，并显示。

【函数调用】
/**
 * 创建key二维码
 * ssid-WiFi名称；password-WiFi密码；key-nvr Key
 */
public void createNvrKeyQRCode(String ssid, String password, String key, ICreateQRCodeCallback callback)
/**
 * 获取NVR添加结果
 */
MeariUser.getInstance().nvrGetAddResult(new INVRGetAddResultCallback()

【代码范例】

MeariUser.getInstance().createNvrKeyQRCode("wifi_name", "pwd", deviceParams.nvrNeutralParams.getQrCodeKey(), new ICreateQRCodeCallback() {
    @Override
    public void onSuccess(Bitmap bitmap) {
        
    }
});

// 设置超时时间(130s)，循环获取添加结果。超时添加失败，停止搜索
MeariUser.getInstance().nvrGetAddResult(new INVRGetAddResultCallback() {
    @Override
    public void onSuccess(List<NvrAddInfo> nvrAddInfoList) {
        List<NvrAddInfo> list = filterOnvif(nvrAddInfoList);
        if (list.size() > 0) {
            // 添加成功，显示结果
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

## 13.3 NVR和通道的判断
```
// 判断NVR设备
if (DeviceType.NVR_NEUTRAL == cameraInfo.getDevTypeID()) {
}

// 判断NVR通道
if (DeviceType.NVR_NEUTRAL == cameraInfo.getDevTypeID() && cameraInfo.getNvrChannelId() > 0) {
}
```

## 13.4 NVR设置
### 13.4.1 NVR获取参数
```
【描述】
获取nvr通道、硬盘等参数信息

【函数调用】
/**
 * Get the params of the device
 * 获取设备的参数
 *
 * @param callback Function callback
 */
public void getDeviceParams(IGetDeviceParamsCallback callback)

【代码范例】
// 操作同一个设备只需设置一次
MeariUser.getInstance().setCameraInfo(cameraInfo);
// 获取设备参数
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
// nvr最大通道数
private int maxChannelNumber;
// nvr二维码Token
private String qrCodeToken;
// nvr二维码key
private String qrCodeKey;
// 是否开启全天录像
private int allDayRecordEnable;
// 通道信息
private List<NvrNeutralChannel> channels = new ArrayList<>();
// 硬盘信息
private List<NvrNeutralDisk> disks = new ArrayList<>();
// 通道能力集
private List<String> caps = new ArrayList<>();

NvrNeutralChannel：
private int id;
private String name;
// state: 0-未绑定；1-在线；2-离线；3-休眠；
private int state;
// 0-私有协议；1-onvif协议
private int type;

NvrNeutralDisk：
private int name;
// 0：无SD卡；1：正常使用；2：卡读写异常；3：格式化中；4：文件系统不支持；5：卡正在识别；6：未格式化；7：其他错误；
private int state;
// 总容量
private String total;
// 剩余容量
private String free;
// 使用容量
private String used;

```
### 13.4.2 NVR磁盘管理
```
【描述】
NVR格式化硬盘

【函数调用】
/**
 * 开始格式化硬盘
 * @param seq 硬盘序号，从1开始
 */
public void startSDCardFormat(int seq, ISDCardFormatCallback callback)
/**
 * 获取格式化硬盘进度
 */
public void getSDCardFormatPercent(ISDCardFormatPercentCallback callback)

【代码范例】
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


## 13.5 NVR通道摄像机
```
NVR通道摄像机的使用和普通摄像机基本一致，使用 NVR 通道摄像机信息的 CameraInfo ，可以预览、回放、设置，具体流程参考普通摄像机的预览、回放、设置。
NVR通道摄像机不支持云回放。
不同之处下面会详细说明。
```

### 13.5.1 NVR通道摄像机信息
```
// 获取 NVR 通道摄像机信息
if (DeviceType.NVR_NEUTRAL == cameraInfo.getDevTypeID()) {
    List<CameraInfo> channelCameraInfoList = cameraInfo.getNvrChannelList();
}
```

### 13.5.2 NVR通道摄像机参数
```
// 操作同一个NVR通道只需设置一次
MeariUser.getInstance().setCameraInfo(channelCameraInfo);
// 获取设备参数
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

### 13.5.3 NVR通道摄像机固件升级
```
// checkNewFirmwareForDev 中的 sn 和 tp获取方式不同
if (cameraInfo != null && DeviceType.NVR_NEUTRAL == cameraInfo.getDevTypeID() && cameraInfo.getNvrChannelId() > 0) {
    sn = channelDeviceParams.getSnNum();
    tp = channelDeviceParams.getTp();
}
```


# 14 4G

## 14.1 添加4G

```
添加参考(#51-二维码配网添加设备)或者(#54-扫码即添加)。

```

## 14.2 4G流量

### 14.2.1 流量充值套餐
```
【描述】
随设备绑定的SIM卡的流量充值套餐获取

【函数调用】
/**
 * 获取4G套餐
 * @param uuid   机身码解析的uuid
 * @param deviceId   设备的devivceid
 * @param payType   支付类型 1:alipay 2: paypal 3:google 4:apple
 * deviceID和uuid传其中1个，另一个传null或""
 */
public void get4GDeviceFlowV2(String uuid,String deviceId,String payType, IStringResultCallback callback)


【代码范例】
MeariUser.getInstance().get4GDeviceFlowV2(uuid,deviceId, "1",new IStringResultCallback() {
                @Override
                public void onSuccess(String result) {
                    
                }
                @Override
                public void onError(int errorCode, String errorMsg) {

                }
            });

【JSON】
{
    "resultCode":"1001",
    "result":{
        "simID":"",
        "maxMonthQuantity":12,（限制最多买多少个月）
        "trialStatus": false,  （套餐列表中是否有试用套餐）
        "packageList":[
            {
                "id":"",  （套餐id，对应packageId）
                "mealType":"M",  （M是月套餐，S是季套餐，Y是年套餐，X是半年套餐）
                "money":"",
                "currencyCode": "USD",
                "currencySymbol": "$",
                "trafficPackage":"M",   （M是MB，G是GB）
                "quantity":500   （数量），
                "unlimited": 1    (显示不限量)
                "type":0   (0是试用套餐，需要单独筛选出来)
            },
            {
                "id":"",
                "mealType":"",
                "money":"",
                "currencyCode": "USD",
                "currencySymbol": "$",
                "trafficPackage":"G",
                "quantity":3,
                "unlimited": 0
            }
        ]
    }
}

【错误码】
返回状态码1201，未绑定sim卡（不用展示套餐）
返回状态码1202，无效的uuid

```
### 14.2.2 流量查询（不可频繁查询）
```
【描述】
随设备绑定的SIM卡的流量查询，频繁查询会被运营商停止。

【函数调用】
/**
 * 获取4G流量
 * @param uuid   机身码解析的uuid
 * @param deviceId   设备的devivceid
 * deviceID和uuid传其中1个，另一个传null或""
 */
public void getTrafficNumber(String uuid, String deviceId, IStringResultCallback callback)


【代码范例】
MeariUser.getInstance().getTrafficNumber(uuid,deviceId, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                
            }

            @Override
            public void onError(int errorCode, String errorMsg) {
            }
        });

【JSON】
{
	"resultCode": "1001",
	"simID": "4375345345",
	"resultData": {
		"subscriberQuota": { //当前使用套餐
			"qtavalue": "2048.00", //总流量（M）
			"qtabalance": "1960.57", //剩余流量（M）
			"qtaconsumption": "87.43", //已使用流量（M）
			"activeTime": "1658926803000", //激活时间
			"mealType": "M", //套餐类型
			"expireTime": "1658927512000", //过期时间，
			"money": "0.01",
			"unlimited": 1 //(显示不限量)
		},
		"preActivePackageList": [ //未使用套餐
			{
				"mealType": "",
				"trafficPackage": "G",
				"quantity": 3,
				"money": "0.01",
				"unlimited": 1 //(显示不限量)
			}
		],
		"historyQuota": [{ //历史用量
				"time": "20220720",
				"qtaconsumption": "87.43"
			},
			{
				"time": "20220721",
				"qtaconsumption": "87.43"
			}
		]
	}
}

1. 返回值中的subscriberQuota是正在使用中的套餐使用情况，如果设备从来没使用过流量，也就是没激活过sim卡，则这个值里面没有数据
2. historyQuota中是正在使用的套餐的历史流量使用情况，但是因为提供商只能提供中国时区的按天的流量使用明细，所以流量使用明细这一块肯定是和用户本地时区的一天是对应不起来的，这个数据不准，因为时区问题，有可能返回的日期比用户本地时区还晚，有可能会出现流量明细有明天使用量的情况，这个需要app在本地加个逻辑，最少展示的时间不能超过用户本地时间

```
### 14.2.3 兑换流量
```
【描述】
激活码兑换流量

【函数调用】
/**
 * 获取4G流量
 * @param uuid   机身码解析的uuid
 * @param deviceId   设备的devivceid
 * @param code       激活码
 * deviceID和uuid传其中1个，另一个传null或""
 */
public void getTrafficCode(String uuid, String deviceId, String code, IStringResultCallback callback)


【代码范例】
MeariUser.getInstance().getTrafficCode(uuid,deviceId,code, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
            
            }

            @Override
            public void onError(int errorCode, String errorMsg) {
                showToast(CommonUtils.getRequestDesc(TrafficManagerActivity.this, errorCode));
            }
        });



```
### 14.2.4 试用流量开通
```
【描述】
试用流量的开通

【函数调用】
/**
 * 获取4G流量
 * @param uuid   机身码解析的uuid
 * @param deviceId   设备的devivceid
 * @param code       激活码
 * deviceID和uuid传其中1个，另一个传null或""
 */
public void getTrafficCode(String uuid, String deviceId, String code, IStringResultCallback callback)


【代码范例】
MeariUser.getInstance().getTrafficCode(uuid,deviceId,code, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
            
            }

            @Override
            public void onError(int errorCode, String errorMsg) {
                showToast(CommonUtils.getRequestDesc(TrafficManagerActivity.this, errorCode));
            }
        });



```
### 14.2.5 流量购买
```
【描述】
流量的购买（已拥有的套餐加上正要购买的套餐不能超过流量充值套餐接口中的maxMonthQuantity，如果无值默认为12个月）

【函数调用】
/**
 * 获取4G流量
 * @param uuid   机身码解析的uuid
 * @param deviceID   设备的devivceid
 * @param packageId   套餐id 
 * @param payMoney   支付金额 
 * @param payType   支付类型 1:alipay 2: paypal 
 deviceID和uuid传其中1个，另一个传null或""
 */
public void postTrafficPayOrderV2(String deviceID,String uuid,String packageId, String payMoney,String payType, IStringResultCallback callback)


【代码范例】
MeariUser.getInstance().postTrafficPayOrderV2("deviceId",
                    "uuid",
                    "packageId",
                    payMoney, mPayType,
                    new IStringResultCallback() {
                        @Override
                        public void onSuccess(String result) {
                            
                        }

                        @Override
                        public void onError(int errorCode, String errorMsg) {
                            
                        }
                    });

【JSON】
payType = 1（即支付宝支付） 
返回
{
      "resultCode": "1001",
       "result": {
              "payMoney": "108",
              "orderNum": "",
               "payUrl ": " ",
               "LeastTime ": 9906,
               "createDate ": 167940449392
        }
}


```

### 14.2.6 流量订单
```
【描述】
流量的订单查询

【函数调用】
/**
 * 获取4G流量
 * @param uuid   机身码解析的uuid
 * @param deviceID   设备的devivceid
 *deviceID和uuid传其中1个，另一个传null或""
 */
public void getTrafficOrderList(String uuid, String deviceId, IStringResultCallback callback)


【代码范例】
MeariUser.getInstance().getTrafficOrderList(uuid,deviceId, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                if(!TextUtils.isEmpty(result)) {
                    Logger.i(TAG, "--->getTrafficOrderList: " + result);
                    trafficOrderBean = GsonUtil.fromJson(result, TrafficOrderBean.class);
                    if(trafficOrderBean!=null){
                        mHandler.sendEmptyMessage(GET_4G_TRAFFIC_ORDER_SUCCESS);
                    }
                }
            }

            @Override
            public void onError(int errorCode, String errorMsg) {
                mHandler.sendEmptyMessage(GET_4G_TRAFFIC_ORDER_FAIL);
            }
        });

【JSON】
{
  "resultCode": "1001",
  "result": {
    "orderList": [
      {
        "orderNum": "",
        "mealType": "M",
        "payMoney": "",
        "payDate": "",
        "quantity": 3,
        "trafficPackage": "G",
        "trafficQuantity": 3,
        "currencyCode": "USD",
        "currencySymbol": "$",
        "payType": 3,
        "unlimited": 0
      }
    ]
  }
}


```

# 15 宠物类设备

## 15.1 添加设备

```
添加参考(#51-二维码配网添加设备)。

```

## 15.2 设置

### 15.2.1 投食喂食
```
【描述】
投食和喂食（区分投食器和喂食器）

【函数调用】
    /**
     * 版本80
     * pet:
     * type: int
     * description: 设备是否为宠物设备，0-不是 1-是, 默认0
     * 1-宠物投食机 2-宠物喂食器
     * usage:app可以用作设备类型识别
     */
     cameraInfo.getPet()
/**
     * 一键投食：
     * id: '845'
     * name: 一键投食
     * type:  bool（布尔型）
     * definition:  bool（布尔型）
     * description: 投食控制，发送1，抛投搅拌一次,属于一个瞬时控制指令'
     * default: 1
     */
     void setPetFeed(ISetDeviceParamsCallback callback) 

/**
     * 一键喂食
     * copies：喂食份数
     */
public void setPetFeed2(int copies,ISetDeviceParamsCallback callback)


```

### 15.2.2 音效设置
```
【描述】
设置一键呼唤的音效

【函数调用】
    /**
     * 获取音效列表
     */
     public void getVoicePetMailList(String deviceID, Object tag, IStringResultCallback callback)

     /**
     * 获取当前音效（url）
     */
     deviceParams.getPetSoundSetting()
    /**
     * 设置当前音效
     */
     public void setVoiceSetting(String url, IStringResultCallback callback)


【代码范例】
MeariUser.getInstance().getVoicePetMailList(presenter.getCameraInfo().getDeviceID(), this, new IStringResultCallback() {
            @Override
            public void onSuccess(String result) {
                if(!TextUtils.isEmpty(result)){
                    VoicePetMailInfo voicePetMailInfo= GsonUtil.fromJson(result, VoicePetMailInfo.class);
                }
            }

            @Override
            public void onError(int code, String error) {
                
            }
        });

```



### 15.2.3 一键呼唤
```
【描述】
设置一键呼唤

【函数调用】
    /**
     * 一键呼唤
     */
     public void setFeedCall(int enable, ISetDeviceParamsCallback callback)

    
【代码范例】
MeariUser.getInstance().setFeedCall(1, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
            }
        });
```

### 15.2.4 投食喂食计划
```
【描述】
设置投食喂食计划

【函数调用】
    /**
     * 获取喂食计划
     */
     deviceParams.getPetFeedPlanList()
/**
     * 设置喂食计划
     */
     public void setFeedTimes(String timeList, ISetDeviceParamsCallback callback)

    
【代码范例】
/**
*planString: >-
  如果是单次投食 则{ "enable":false, "time":"10:00", "count":1, "once": 1}
  如果是按星期计划投食则：{ "enable":false, "time":"10:00", "count":1, "repeat":[1,2,3,4,5,6,7]}
  repeat中1代表星期一
  示例：最多允许设置8组，JSON字符串，[{ "enable":false, "time":"10:00",
  "repeat":[1] , "count":1}, { "enable":false, "time":"10:00", "count":1, "once": 1}]
**/
MeariUser.getInstance().setFeedTimes(planString, new ISetDeviceParamsCallback() {
            @Override
            public void onSuccess() {
                if (handler == null || isViewClose()) {
                    return;
                }
                Message msg = Message.obtain();
                msg.what = MSG_SET_PLAN_TIME_SUCCESS;
                msg.obj = planString;
                mHandler.sendMessage(msg);
            }

            @Override
            public void onFailed(int errorCode, String errorMsg) {
                if (handler == null || isViewClose()) {
                    return;
                }
                Message msg = Message.obtain();
                msg.what = MSG_SET_PLAN_TIME_FAILED;
                mHandler.sendMessage(msg);
            }
        });
```


# 16 更新说明

## 2022-10-10(4.4.0)
```
1. 修复Android 12 奔溃问题，需要注释：// implementation 'org.eclipse.paho:org.eclipse.paho.android.service:1.1.1'
2. ptz 能力集描述错误修改
3. 获取设备在线状态
4. 获取码率
5. NVR支持
6. 全彩模式支持
7. 声光报警支持
```

## 2022-06-21(4.1.0)
```
1. 修复Android 12 奔溃问题，需要注释：// implementation 'org.eclipse.paho:org.eclipse.paho.android.service:1.1.1'
2. ptz 能力集描述错误修改
```

## 2022-04-28(4.1.0)
```
新增云存储文档
```

## 2022-03-31(4.1.0)
```
家庭接口文档初稿完成
```

## 2020-03-13(2.2.0)
```
SDK接入指南初稿完成
```