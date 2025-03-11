//
//  MeariPetInfo.h
//  MeariKit
//
//  Created by duan on 2024/5/10.
//  Copyright © 2024 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MeariPetFenceAreaType) {
    MeariPetFenceAreaTypeDanger = 0,
    MeariPetFenceAreaTypeSafe = 1,
};
typedef NS_ENUM(NSInteger, MeariPetFenceShapeType) {
    MeariPetFenceShapeTypeCircle = 0,
    MeariPetFenceShapeTypeRectangle = 1,
    MeariPetFenceShapeTypePolygon = 2
};

@interface MeariPetInfo : MeariBaseModel

@property(nonatomic, copy) NSString *nickName; //昵称
@property(nonatomic, copy) NSString *avatarUrl; //图标
@property(nonatomic, copy) NSString *signedUrl;
@property(nonatomic, copy) NSString *gender; //性别
@property(nonatomic, copy) NSString *birthday;//生日
@property(nonatomic, copy) NSString *weight;//体重
@property(nonatomic, copy) NSString *category;//类别
@property(nonatomic, copy) NSString *variety;//品种
@property(nonatomic, copy) NSString *sterilization;//是否绝育
@property(nonatomic, copy) NSString *addr;//家庭住址
@property(nonatomic, assign) double lon;   //家庭住址的经度
@property(nonatomic, assign) double lat;   //家庭住址的纬度
@property(nonatomic, copy) NSString *phone;//紧急联系方式
@property(nonatomic, copy) NSString *introduce;//宠物介绍
@property(nonatomic, assign) NSInteger sleepDuration;//睡眠时常(h)
@property(nonatomic, assign) NSInteger stepCount;//目标步数
@property(nonatomic, assign) NSInteger motionDuration;//运动时长

@end

@interface MeariPetHistoryTrack : MeariBaseModel

@property(nonatomic, assign) double lon;  //运动总时长，单位分钟
@property(nonatomic, assign) double lat; //睡眠总时长，单位分钟
@property(nonatomic, assign) float alt; //当天总计步数
@property(nonatomic, assign) float spd; //当天总计步数

@property(nonatomic, copy) NSString *t;
@property(nonatomic, copy) NSString *utc;

@property(nonatomic, strong) NSArray *users;
@property(nonatomic, copy) NSString *mac;
@property(nonatomic, copy) NSString *snNum;
@property(nonatomic, assign) NSInteger userID;
@end

@interface MeariPetHealthInfo : MeariBaseModel

@property(nonatomic, assign) float moveTime;  //运动总时长，单位分钟
@property(nonatomic, assign) float sleepTime; //睡眠总时长，单位分钟
@property(nonatomic, assign) NSInteger stepNums; //当天总计步数

@property(nonatomic, strong) NSMutableDictionary *moveDictionary;
@property(nonatomic, strong) NSMutableDictionary *sleepDictionary;
@property(nonatomic, strong) NSMutableDictionary *stepDictionary;

@property(nonatomic, copy) NSString *date;
@end

@interface MeariPetFence : MeariBaseModel

@property(nonatomic, copy) NSString *fenceID; //id
@property(nonatomic, copy) NSString *name; //名称
@property(nonatomic, assign) MeariPetFenceAreaType areaType; //危险区、安全区
@property(nonatomic, assign) MeariPetFenceShapeType shapeType;//区域类型
@property(nonatomic, assign) BOOL enable;//启用状态
@property(nonatomic, assign) NSInteger sign;//围栏标识
@property(nonatomic, assign) double lon;//圆心经度
@property(nonatomic, assign) double lat;//圆心纬度
@property(nonatomic, assign) NSInteger rad;//圆半径
@property(nonatomic, strong) NSArray *lonlats;//区域各顶点的经纬度数组

@property(nonatomic, assign) NSInteger buzzerEnable;//蜂鸣器开关
@property(nonatomic, assign) NSInteger buzzerDuration;//蜂鸣器响铃时长

@end

@interface MeariPetWifiFence : MeariBaseModel


@property(nonatomic, copy) NSString *name; //名称
@property(nonatomic, copy) NSString *wifiName; //id
@property(nonatomic, copy) NSString *mac; //名称
@property(nonatomic, copy) NSString *addr;   //wifi的地址
@property(nonatomic, copy) NSString *range;//围栏范围
@property(nonatomic, assign) NSInteger strength; //WiFi信号强度
@property(nonatomic, assign) double lon;   //wifi的经度
@property(nonatomic, assign) double lat;   //wifi的纬度

@property(nonatomic, assign) NSInteger buzzerEnable;//蜂鸣器开关
@property(nonatomic, assign) NSInteger buzzerDuration;//蜂鸣器响铃时长

@end
@interface MeariPetFenceAlarmStatus : MeariBaseModel


@property(nonatomic, assign) BOOL enterWifiZone; //进入wifi区域:0不报警,1报警
@property(nonatomic, assign) BOOL leaveWifiZone; //离开wifi区域:0不报警,1报警
@property(nonatomic, assign) BOOL enterSafeZone; //进入安全区域:0不报警,1报警
@property(nonatomic, assign) BOOL leaveSafeZone; //离开安全区域:0不报警,1报警
@property(nonatomic, assign) BOOL enterDangerousZone; //进入危险区域:0不报警,1报警
@property(nonatomic, assign) BOOL leaveDangerousZone; //离开危险区域:0不报警,1报警


@end

@interface MeariPetWarnStatus : MeariBaseModel

@property(nonatomic, assign) BOOL promptLightEnable; //提示灯开关: 0关,1开
@property(nonatomic, assign) NSInteger promptLightDuration; //提示灯时长，单位s, 默认60s
@property(nonatomic, assign) NSInteger promptLightType; //提示灯类型: 0默认
@property(nonatomic, assign) BOOL buzzerEnable; //蜂鸣器开关: 0关,1开
@property(nonatomic, assign) NSInteger buzzerDuration; //蜂鸣器响铃时长，单位s, 默认60s
@property(nonatomic, assign) NSInteger buzzerType; //蜂鸣器响铃类型: 0默认


@end


NS_ASSUME_NONNULL_END
