//
//  MeariDeviceInfo.h
//  MeariKit
//
//  Created by Meari on 2017/12/21.
//  Copyright © 2017年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeariDeviceEnum.h"
@interface MeariDeviceInfoCapabilityFunc : MeariBaseModel
// Voice intercom type
/** 语音对讲类型 */
@property (nonatomic, assign) MeariDeviceVoiceTalkType vtk;
// Face recognition
/** 人脸识别 */
@property (nonatomic, assign) NSInteger fcr;
//Decibel alarm
/** 分贝报警 */
@property (nonatomic, assign) NSInteger dcb;
//Motion Detection
/** 移动侦测 */
@property (nonatomic, assign) NSInteger md;
// PTZ
/** 云台 */
@property (nonatomic, assign) NSInteger ptz;
//Temperature Sensor
/** 温度传感器 */
@property (nonatomic, assign) NSInteger tmpr;
// Humidity Sensor
/** 湿度传感器 */
@property (nonatomic, assign) NSInteger hmd;
// Body detection
/** 人体侦测 */
@property (nonatomic, assign) NSInteger pir;
// Cloud storage
/** 云存储 */
@property (nonatomic, assign) NSInteger cst;
/** Signal strength*/
/** 信号强度*/
@property (nonatomic, assign) NSInteger nst;
/** Playback recording settings*/
/** 回放录像设置*/
@property (nonatomic, assign) NSInteger evs;
/** Playback recording settings*/
/** 回放录像设置*/
@property (nonatomic, assign) NSInteger rec;
/** Battery lock*/
/** 电池锁*/
@property (nonatomic, assign) NSInteger btl;
/** Cloud Storage Switch*/
/** 云存储开关*/
@property (nonatomic, assign) NSInteger cse;
/** Day and night mode*/
/* 是否支持日夜切换开关(自动/日/夜)的能力级, 0/1, default: 0，0=不支持，1=支持非照明灯的夜视模式(自动/日/夜)， 2=支持照明灯的夜视模式（智能夜视/全彩夜视/黑白夜视，3=支持微光全彩式（智能夜视/全彩夜视/黑白夜视/微光全彩）  能力级版本56**/
@property (nonatomic, assign) NSInteger dnm;

/** 新版Day and night mode */
/* description: 是否支持日夜切换开关(自动/日/夜)的能力级,
 default: 0；
 bit0 表示是否支持非照明灯的夜视模式(自动/日/夜)；
 bit1 表示是否支持照明灯的夜视模式（智能夜视/全彩夜视/黑白夜视）；
 bit2 表示是否支持照明灯的微光模式（智能夜视/全彩夜视/黑白夜视/微光模式）*/
@property (nonatomic, assign) NSInteger dnm2;
/** Second generation cloud storage*/
/** 二代云存储*/
@property (nonatomic, assign) NSInteger cs2;
/** High standard definition*/
/** 高标清*/
@property (nonatomic, assign) MeariDeviceCapabilityVSTType vst;
/** Multi-rate setting*/
/** 多码率设置*/
@property (nonatomic, assign) NSInteger bps;
/** led light*/
/** led灯*/
@property (nonatomic, assign) NSInteger led;
/** onvif function*/
/** onvif功能*/
@property (nonatomic, assign) NSInteger svc;
/** onvif function*/
/** onvif新版本*/
@property (nonatomic, assign) NSInteger ovf;
/** Support bell type*/
/** 支持铃铛类型*/
@property (nonatomic, assign) NSInteger rng;
/** Lamp camera function */
/** 灯具摄像头功能 */
@property (nonatomic, assign) NSInteger flt;
/** Power Management*/
/** 功耗管理*/
@property (nonatomic, assign) NSInteger pwm;
/** sd card*/
/** sd卡*/
@property (nonatomic, assign) NSInteger sd;
/** version upgrade*/
/** 版本升级*/
@property (nonatomic, assign) NSInteger ota;
/** Host Message*/
/** 主人留言*/
@property (nonatomic, assign) NSInteger hms;
/** flip */
/** 翻转*/
@property (nonatomic, assign) NSInteger flp;
/** Shadow Agreement*/
/** 影子协议*/
@property (nonatomic, assign) NSInteger shd;
/** Door lock*/
/** 门锁*/
@property (nonatomic, assign) NSInteger dlk;
/** relay */
/** 继电器*/
@property (nonatomic, assign) NSInteger rel;
/** Open the door*/
/** 开门*/
@property (nonatomic, assign) NSInteger dor;
/** Turn on the light*/
/** 开灯*/
@property (nonatomic, assign) NSInteger lgt;
/** Sleep mode*/
/** 休眠模式*/
@property (nonatomic, assign) NSInteger slp;
/** Switch the main stream */
/** 切换主码流*/
@property (nonatomic, assign) NSInteger vec;
/** Cry Detect*/
/** 哭声检测*/
@property (nonatomic, assign) NSInteger bcd;
/** People Track*/
/** 人体跟踪*/
@property (nonatomic, assign) NSInteger ptr;
/** People Detect*/
/** 人形检测*/
@property (nonatomic, assign) NSInteger pdt;
/** Alarm plan*/
/** 报警计划*/
@property (nonatomic, assign) NSInteger alp;
/** Low power consumption*/
/** 低功耗 录像时长*/
@property (nonatomic, assign) NSInteger esd;
/** letter of agreement*/
/** 通信协议*/
@property (nonatomic, assign) NSInteger spp;
/** bright adjustment*/
/** 亮度调节*/
@property (nonatomic, assign) NSInteger ltl;
/** chromecast */
@property (nonatomic, assign) NSInteger cct;
/** echoshow*/
@property (nonatomic, assign) NSInteger ecs;
/** p2p version*/
/** p2p 版本*/
@property (nonatomic, assign) NSInteger p2p;
/** record enable */
/** 录像开关 */
@property (nonatomic, assign) NSInteger ren;
/** 音量调节*/
@property (nonatomic, assign) NSInteger ovc;
/** 区域报警*/
@property (nonatomic, assign) NSInteger roi;
/** 报警频率*/
@property (nonatomic, assign) NSInteger afq;
/** 人脸识别*/
@property (nonatomic, assign) NSInteger fcd;
// 16:9 还是 9:16
@property (nonatomic, assign) NSInteger crm;
/** 声光报警*/
@property (nonatomic, assign) NSInteger sla;
/** 时间风格设置*/
@property (nonatomic, assign) NSInteger ttp;
/** 音乐播放能力级*/
@property (nonatomic, assign) NSInteger mpc;
/** pir等级设置使能开关，，用于多级设置开关1-N档，0=不支持，10=支持10档（1-10）*/
@property (nonatomic, assign) NSInteger plv;
/** 视频能力级, 0=不支持， 1=支持 */
@property (nonatomic, assign) NSInteger vid;
/** 防拆报警*/
@property (nonatomic, assign) NSInteger fcb;
/** 新设备的分辨率 */
@property (nonatomic, strong) NSString *bps2;
/** 新增是否支持灯具摄像机的报警联动亮灯的能力级fld  0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger fld;
/** 噪声异常巡查  0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger dbc;
/** baby 上传用户预览信息  0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger uif;
/**PTZ的高级功能 0x1 预置点 0x2  巡航  0x4 巡视 */
@property (nonatomic, assign) NSInteger pcr;
/**低功耗的报警工作模式设置*/
@property (nonatomic, assign) NSInteger lwm;
/**是否支持webrtc协议*/
@property (nonatomic, assign) NSInteger mts;
/** 是否支持夜灯设置  0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger rgb;
/** 是否支持抗闪烁设置  0-不支持,1-支持+关闭+50HZ+60HZ,2-支持支持+关闭+50HZ+60HZ+自动*/
@property (nonatomic, assign) NSInteger flk;
/** 是否支持自动升级设置  0-不支持,1-支持*/
@property (nonatomic, assign) NSInteger aup;
/** 是否支持统计  0-不支持, 0xb1 支持实时信息统计 0xb10 支持按天/月统计*/
@property (nonatomic, assign) NSInteger sti;
/**是否支持homekit能力级，0-不支持，1-支持； */
@property (nonatomic, assign) NSInteger hkt;
/**是否支持喇叭使能开关, 0-不支持，1-支持 */
@property (nonatomic, assign) NSInteger sen;
/**是否支持麦克使能开关, 0-不支持，1-支持 */
@property (nonatomic, assign) NSInteger men;
/**是否支持鸣笛报警能力级 0-不支持, 1-支持  能力级版本55*/
@property (nonatomic, assign) NSInteger sir;
/**是否支持一键开关灯（非暖光灯）的能力级，0=不支持，1=支持  能力级版本56*/
@property (nonatomic, assign) NSInteger lgh;
/** 是否支持一键开关灯（暖光灯，用于夜间补光用）能力级，0-不支持, 1-支持 能力级版本56*/
@property (nonatomic, assign) NSInteger lgl;
/** 是否支持录像声音开关，0-不支持，1-支持，备注：如果麦克声音也关闭了，则录像声音开启也是无效的*/
@property (nonatomic, assign) NSInteger rae;
/** 是否支持链接加密  - 0-不支持，1-支持 需要设置device.info.connectPwd 字段*/
@property (nonatomic, assign) NSInteger mup;
/** 是否支持上报警报最大时间*/
@property (nonatomic, assign) NSInteger sot;
/** 是否支持亮灯时长设置*/
@property (nonatomic, assign) NSInteger lot;
/** 是否支持时区功能*/
@property (nonatomic, assign) NSInteger tmz;
/** 是否支持重启*/
@property (nonatomic, assign) NSInteger rbt;
/** 是否支持语音电话，0-不支持，1-支持 */
@property (nonatomic, assign) NSInteger voi;
/** 是否支持噪音录像(包含sd卡录像和云存储录像)，0-不支持，1-支持 */
@property (nonatomic, assign) NSInteger ndr;
/** NVR删除则设备ipc*/
@property (nonatomic, assign) NSInteger dpc;
/** 无线抗干扰开关*/
@property (nonatomic, assign) NSInteger ajs;
/** 设备的事件报警方式能力级，0-图片上报(默认), 1-视频上报*/
@property (nonatomic, assign) NSInteger evt;
/** 人形检测灵敏度*/
@property (nonatomic, assign) NSInteger pds;
/** 低功耗亮灯计划能力*/
@property (nonatomic, assign) NSInteger fls;
/** 是否支持连接NVR私有协议能力*/
@property (nonatomic, assign) NSInteger cpn;
/** 是否支持生成配网的二维码*/
@property (nonatomic, assign) NSInteger rwm;
/** 是否支持水印*/
@property (nonatomic, assign) NSInteger lgo;
/** 是否支持Ai 2.0版本*/
@property (nonatomic, assign) NSInteger ai;
/** IPC 设备是否支持显示电量*/
@property (nonatomic, assign) NSInteger bat;
/**是否支持报警总开关 */
@property (nonatomic, assign) NSInteger gal;

/**ptz 2.0版本 */
@property (nonatomic, assign) NSInteger ptz2;
/**智能检测相关功能开关 */
@property (nonatomic, assign) NSInteger idt;
/** IPC 设备是否支持显示低功耗*/
@property (nonatomic, assign) NSInteger lem;
/** 支持事件报警类型设置 0-不支持, >=1-支持设置选项; 设备evt2>=1,*/
@property (nonatomic, assign) NSInteger evt2;

/** 支持多边形报警区域设置*/
@property (nonatomic, assign) NSInteger plg;
/** 支持多边形隐私区域设置*/
@property (nonatomic, assign) NSInteger pva;
/** 支持支持录像下载*/
@property (nonatomic, assign) NSInteger avd;
/** 支持支持录像删除*/
@property (nonatomic, assign) NSInteger pbd;
/** 录像倍速回放 bit0=全帧发送（0.5、1、2、4倍速）, bit1=抽帧发送（8、16倍速）*/
@property (nonatomic, assign) NSInteger pbf;
/** 码率自适应1.0的能力级, 0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger adb;
/** 设备是否为宠物投食机，0-不是 1-是, 默认0*/
@property (nonatomic, assign) NSInteger pet;
/** 设备是否支持一键投食，0-不是 1-是, 默认0*/
@property (nonatomic, assign) NSInteger ptf;
/** 设备是否支持投食计划，0-不是 1-是, 默认0*/
@property (nonatomic, assign) NSInteger pfp;
/** 设备是否支持设置播放抛投效果音(固件写死的提示音，非主人留言),0-不是 1-是, 默认0*/
@property (nonatomic, assign) NSInteger pfv;
/** 是否支持主人投食留言语音设置，0-不是 1-是, 默认0*/
@property (nonatomic, assign) NSInteger pms;
/** 设备是否支持一键投食，0-不是 1-是, 默认0*/
@property (nonatomic, assign) NSInteger pvs;

/** 是否支持扫机身码直接添加功能, 0-不支持, 1(非0)-支持*/
@property (nonatomic, assign) NSInteger sqr;

//高低温报警
/*** 是否支持 温湿度报警 */
@property (nonatomic, assign) NSInteger tha;
/** 是否支持温度阈值 */
@property (nonatomic, assign) NSInteger ttc;
/** 是否支持湿度阈值 */
@property (nonatomic, assign) NSInteger hts;

/** 是否支持wifi切换*/
@property (nonatomic, assign) NSInteger swi;
/**Base设备是否支持音量设置，0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger svt;
/** 设备是否支持安全访问密码设置*/
@property (nonatomic, assign) NSInteger sap;
/** 4G设备是否支持双卡，0-不支持  1-支持*/
@property (nonatomic, assign) NSInteger sdc;

/** 设备是否支持码率、帧率设置*/
@property (nonatomic, copy) NSString *sbf;
/** 4G设备是否支持AOV码流单帧间隔配置，0-不支持 bit0-1秒，bit1-2秒，bit2-3秒，bit3-5秒，bit4-10秒，bit5-15秒，bit6-20秒，bit7-30秒，bit8-60秒*/
@property (nonatomic, assign) NSInteger sfi;
/** 是否支持Aov播放速度模式*/
/** 4G设备 AOV录像回放一秒几帧  0-不支持 1-1秒1帧 2-1秒2帧 3-1秒3帧 4-1秒4帧 5-1秒5帧*/
@property (nonatomic, assign) NSInteger ars;
/**是否支持低功耗休眠电量阈值 设置, 0=不支持，1=支持*/
@property (nonatomic, assign) NSInteger slt;
/**4G设备限流能力集, 0:不支持 1:支持*/
@property (nonatomic, assign) NSInteger lmf;
/**是否支持全时低功耗的工作模式设置*/
@property (nonatomic, assign) NSInteger alm;
/** 是否支持事件录像延时 （事件录像结束后，再多录一定时间的录像）*/
@property (nonatomic, assign) NSInteger erd;
/**是否支持补光距离配置*/
@property (nonatomic, assign) NSInteger sld;
/**是否支持夜景模式配置*/
@property (nonatomic, assign) NSInteger nms;

/**是否支持音乐播放时长设置*/
@property (nonatomic, assign) NSInteger mul;
/**是否支持音乐播放模式设置*/
@property (nonatomic, assign) NSInteger mpm;

//狩猎相机
/** 设置唤醒后抓拍保存图像方式能力级，枚举类型 0-不支持，1-支持三个选项（录像or拍照or录像+拍照）*/
@property (nonatomic, assign) NSInteger vop;
/**设置拍照分辨率能力集，格式为"JSON格式的字符串"，例如{"0":"30M","1":"24M","2":"20M","3":"16M","4":"12M","5":"8M","6":"5M","7":"3M","8":"1M"},数值表示DP点中可以设置的枚举，后面带M的则是APP选择项中的标题 */
@property (nonatomic, strong) NSString *pwh;
/** 设置抓拍张数能力集，枚举类型 0-不支持， > 0-支持，按照bit位显示可设置的张数，bit0-1张，bit1-2张，bit2-3张，bit3-4张，bit4-5张，依次类推，限制最大支持4字节，0xffffffff*/
@property (nonatomic, assign) NSInteger pno;
/**设置录像分辨率能力集，格式为"JSON格式的字符串"，例如{"0":"2.5K","1":"2K","2":"1080P","3":"720P","4":"480P","5":"360P"},数值表示DP点中可以设置的枚举，后面数值的则是APP选择项中的标题 */
@property (nonatomic, strong) NSString *vwh;
/** 设置录像时长能力集，格式为"JSON格式的字符串"，例如{"min":"1","max":"30"}, min表示允许设置的最小值，max表示允许设置的最大值，数据单位为秒 */
@property (nonatomic, strong) NSString *vot;
/** 设置定时拍摄间隔能力集，格式为"JSON格式的字符串"，例如{"min":"1","max":"30"}, min表示允许设置的最小值，max表示允许设置的最大值，数据单位为秒 */
@property (nonatomic, strong) NSString *pit;
/** 设置监控时段能力集，枚举类型 0-不支持，1-支持设置1段时间，2-支持设置2段时间，3-支持设置3段时间。（狩猎相机中使用，目前可设置3段时间） */
@property (nonatomic, assign) NSInteger mper;
///** 设备是否支持用户密码设置，0-不支持，1-支持; Whether the device supports Modify User Password, 0-not supported, 1-supported;*/
//@property (nonatomic, assign) NSInteger mup;
/** 是否支持IR-LED设置0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger ir;
/** 设备是否支持时间设置，时间设置包含时间格式，时区，当前时间设置。*/
@property (nonatomic, assign) NSInteger tms;
/**  设备是否支持恢复出厂设置功能，0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger rst;
/** 是否支持麦克风开关，0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger mic;
/** 是否支持语言设置，0-不支持，1-支持*/
@property (nonatomic, assign) NSInteger lange;

/** 设备是否支持云台一键校准，0-不支持 1-支持, 默认0 */
@property (nonatomic, assign) NSInteger ptc;
/** 0：wifi铃铛  1：中继铃铛 */
@property (nonatomic, assign) NSInteger rly;

/** 是否支持犬吠检测参数设置， 0=不支持， 1=支持（开关设置) */
@property (nonatomic, assign) NSInteger dbd;
/** 是否支持本地宠物检测参数设置， 0=不支持， 1=支持（开关设置)*/
@property (nonatomic, assign) NSInteger ptd;

/** 双目设备能力级 */
@property (nonatomic, strong) NSString *msc;

/** 是否支持对讲格式  0b1 G711  0b10 Aac */
@property (nonatomic, assign) NSInteger auf;

/** 是否支持毫米波雷达 bit0=1支持开关 bit1:呼吸使能 bit2:心跳使能 bit3:身体状态使能 bit4:身体运动状态量 */
@property (nonatomic, assign) NSInteger mrda;

@end


@interface MeariDeviceInfoCapability: MeariBaseModel
/** Protocol version number */
/** 协议版本号 */
@property (nonatomic, assign) NSInteger ver;
/** device type */
/** 设备类型 */
@property (nonatomic, copy) NSString *cat;
/** Supported features */
/** 支持的功能 */
@property (nonatomic, strong) MeariDeviceInfoCapabilityFunc *caps;
@end

#import "MeariDeviceParam.h"
@interface MeariDeviceInfo : MeariBaseModel
/** camera type */
/** 设备类型总类 */
@property (nonatomic, assign) MeariDeviceType type;
/** device sub type */
/** 设备类型子类 */
@property (nonatomic, assign) MeariDeviceSubType subType;
/** device add status */
/** 设备添加状态 */
@property (nonatomic, assign) MeariDeviceAddStatus addStatus;
/** Device auto-bind */
/** 设备自动绑定 */
@property (nonatomic, assign) BOOL autobind;
/** Device weak binding type */
/** 设备弱绑定类型 */
@property (nonatomic, assign) BOOL weakBind;
/** Wire device */
/** 是否为有线设备 */
@property (nonatomic, assign) BOOL wireDevice;
/** Wire device Password*/
/** 有线设备安全协议密码*/
@property (nonatomic, assign) BOOL needDevicePassword;
/** Wire device  ip*/
/** 有线设备配网IP */
@property (nonatomic, copy) NSString *wireConfigIp;
/** Device was added  */
/** 设备被添加过 */
@property (nonatomic, assign) BOOL hasAdd;

@property (nonatomic, assign) MeariDeviceLimitLevel limitLevel;
/** cloud storage State  */
/** 云存储状态  */
@property (nonatomic, assign) MeariDeviceCloudState cloudState;
/** Cloud2 End Time  */
/** 云存储2.0到期时间 */
@property (nonatomic, copy) NSString *cloudEndTime;
/** device capability */
/** 设备能力级 */
@property (nonatomic, strong) MeariDeviceInfoCapability *capability;
/** device sleep mode */
/** 设备休眠模式 */
@property (nonatomic, assign) MeariDeviceSleepMode sleepMode;
/** 设备编号 */
/** device ID */
@property (nonatomic, assign) NSInteger ID;
/** 用户ID */
/** userID */
@property (nonatomic, assign) NSInteger userID;
// device bind sim id(the device is 4G)
@property (nonatomic, assign) NSInteger simID;
// device sim card nedd to buy data(the device is 4G)
@property (nonatomic, assign) BOOL needBuy;
// device bind id(the device is jingle)
@property (nonatomic, assign) NSInteger bindDeviceID;
// device had be bind
@property (nonatomic, assign) NSInteger hasBeBind;
/** tp */
@property (nonatomic, copy) NSString *tp;
/** device uuid */
@property (nonatomic, copy) NSString *uuid;
/** device sn */
@property (nonatomic, copy) NSString *sn;
/** p2p number */
/**  p2p信息 */
@property (nonatomic, copy) NSString *p2p;
/** p2pInit 字符串 */
/** p2pInit string */
@property (nonatomic, copy) NSString *p2pInit;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *connectName;
/** p2p加密 密码*/
@property (nonatomic, copy) NSString *connectPwd;
/** device nickname */
/** 设备昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 设备logo */
/** device logo */
@property (nonatomic, copy) NSString *iconUrl;
/** 灰色默认 */
/** gray icon */
@property (nonatomic, copy) NSString *grayIconUrl;
/** host message url */
/** 主人留言音频路径 */
@property (nonatomic, copy) NSString *bellVoice;
@property (nonatomic, copy) NSString *modelName;
/** nvr's key,user to connect nvr */
/** 设备绑定的nvr设备信息 */
@property (nonatomic, assign) NSInteger nvrPort;
/** nvr's ID */
@property (nonatomic, assign) NSInteger nvrID;
@property (nonatomic, assign) NSInteger devTypeID;
@property (nonatomic, copy) NSString *nvrKey;
@property (nonatomic, copy) NSString *nvrUUID;
@property (nonatomic, copy) NSString *nvrSn;

@property (nonatomic, copy) NSString *capabilityStr;
/** current device userAccount*/
/** 当前设备所属账号 */
@property (nonatomic, copy) NSString *userAccount;
@property (nonatomic, copy) NSString *produceAuth;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *wifiSsid;
@property (nonatomic, copy) NSString *wifiBssid;
/** 是否关闭推送 */
/** whether to close device push */
@property (nonatomic, assign) NSInteger closePush;
@property (nonatomic, assign) NSInteger protocolVersion;
//@property (nonatomic, assign) BOOL iotDevice;

/** chime's password add wifi name */
//中继设备的wifi名称和密码
@property (nonatomic, copy) NSString *wifiName;
@property (nonatomic, copy) NSString *wifiPwd;

@property (nonatomic, copy) NSString *relaySn;
/** whether is chime subdevice  */
/** 是否为relay的子设备 */
@property (nonatomic, assign) BOOL relaySubDevice;
 
@property (nonatomic, strong) NSString *region;


@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *radius;
/** AWS iot thingName */
@property (nonatomic, copy) NSString *awsThingName;
@property (nonatomic, assign) NSInteger iotType;
@property (nonatomic, assign) NSInteger cloudType; // 新版本已废弃（deprecated）
@property (nonatomic, assign) NSInteger awsCloudCompat;//新版本已废弃（deprecated）

@property (nonatomic, strong) NSDictionary *cloudConfig; //云回放的获取方式

/** 报警方式是视频上报的设备返回此字段，是时间戳（1652428935000） */
@property (nonatomic, copy) NSString *historyEventEnable;

/** Whether device is shared by friends */
/** 是否来自好友分享 */
@property (nonatomic, assign) BOOL shared;
/** Whether friends has device set  authority */
/** 好友是否拥有分享设备设置权限 */
@property (nonatomic, assign) MeariDeviceAuthority shareAccessSign;
/** Whether family has device set  authority */
/** 家庭设备设置权限 */
@property (nonatomic, assign) MeariDeviceAuthority familyShareAuthority;

/** Whether there is a message from device  */
/** 是否有报警消息 */
@property (nonatomic, assign) BOOL hasMsg;
/** Whether device is online *//** tp */
/** 是否在线 */
@property (nonatomic, assign) BOOL online;
/** whether device need update */
/** 是否需要升级 */
@property (nonatomic, assign) BOOL needUpdate;
/** whether device need force Update */
/** 是否需要强制升级 */
@property (nonatomic, assign) BOOL needForceUpdate;


@end


