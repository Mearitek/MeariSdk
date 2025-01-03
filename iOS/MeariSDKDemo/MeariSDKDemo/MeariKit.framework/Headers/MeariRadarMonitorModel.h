//
//  MeariRadarMonitorModel.h
//  MeariCameraSetting
//
//  Created by Archiver on 2024/1/20.
//

#import <Foundation/Foundation.h>

#import "MeariMessageInfo.h"

typedef NS_ENUM(NSInteger, MeariRadarSleepType) {
    MeariRadarSleepTypeNone, // 默认
    MeariRadarSleepTypeDeep, // 深睡
    MeariRadarSleepTypeLight, // 浅睡
    MeariRadarSleepTypeActive // 活动中
};

NS_ASSUME_NONNULL_BEGIN
@class MeariRadarDayMinuteDataModel,MeariRadarMonitorBodyWeekModel,MeariRadarSleepWeekModel,MeariRadarMonitorBodyModel;
@interface MeariRadarMonitorModel : MeariBaseModel
//0是心率  1是呼吸
@property (nonatomic, assign) NSInteger type;
//平均心率/分钟
@property (nonatomic, assign) NSInteger avgHeartRate;
//心率区间
@property (nonatomic, copy) NSString *heartRange;
//平均呼吸/分钟
@property (nonatomic, assign) NSInteger avgBreathe;
//呼吸区间
@property (nonatomic, copy) NSString *breatheRange;
//睡眠时长（浅睡） 分钟
@property (nonatomic, assign) NSInteger lightSleep;
//睡眠时长（深睡） 分钟
@property (nonatomic, assign) NSInteger deepSleep;
// 开始时间戳
@property (nonatomic, assign) NSInteger startTime;
// 睡眠时段 （按分钟填充，默认值为 0，1：深睡，2：浅睡，3：没睡觉）
@property (nonatomic, copy) NSString *sleepTimeLine;

/**睡眠数据
typeName 为 "bav" ，minuteData返回数据格式｛"t":1709521746, "bav":20｝
typeName 为 "hav" ，minuteData返回数据格式｛"t":1709521746, "hav":80｝
typeName 为 "sleepState" ，minuteData返回数据格式｛"str":1709521746, "end":1709521746, "sleepState":2｝
**/
@property (nonatomic, strong) NSArray <MeariRadarDayMinuteDataModel *>*minuteData;
@property (nonatomic, strong) MeariRadarMonitorBodyModel *bodyModel;

@property (nonatomic, strong) NSArray <MeariRadarSleepWeekModel *>*sleepWeekModels;
@property (nonatomic, strong) NSArray <MeariRadarMonitorBodyWeekModel *>*bodyWeekModels;

#pragma mark --- 扩展
@property (nonatomic, strong) NSDate *currentDate;
// 睡眠时段 类型数组
@property (nonatomic, copy) NSMutableArray<NSString *> *sleepTimeArray;
//计算值
//每周第一天
@property (nonatomic, strong) NSString *weekStartDay;
//每周日期 MM/dd
@property (nonatomic, strong) NSArray *weekdaysNumArr;
//每周睡眠数组 [deepSleep,lightSleep,sumSleep]
@property (nonatomic, strong) NSArray *sleepWeekChartModels;
//每周体动数组 [downSleepCount,bodyMoveCount]
@property (nonatomic, strong) NSArray *bodyWeekChartModels;
@property (nonatomic, assign) NSInteger downSleepWeekCount;
@property (nonatomic, assign) NSInteger bodyMoveWeekCount;
@property (nonatomic, assign) NSInteger lightWeekSleep;
@property (nonatomic, assign) NSInteger deepWeekSleep;
@end

@interface MeariRadarDayMinuteDataModel : MeariBaseModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger bav;
@property (nonatomic, assign) NSInteger hav;

@end


@interface MeariRadarSleepWeekModel : MeariBaseModel
@property (nonatomic, assign) NSInteger deepSleep;
@property (nonatomic, assign) NSInteger lightSleep;
//当天总睡眠时长  分钟
@property (nonatomic, assign) NSInteger sumSleep;
//日期
@property (nonatomic, strong) NSString *day;
@end

@interface MeariRadarMonitorBodySubModel : MeariBaseModel
@property (nonatomic, strong) NSString *t;
@property (nonatomic, assign) MeariAlarmMessageType type;
@end

@interface MeariRadarMonitorBodyModel : MeariBaseModel
//趴睡次数
@property (nonatomic, assign) NSInteger downSleepCount;
//体动次数
@property (nonatomic, assign) NSInteger bodyMoveCount;
//{"t": "20240302102319","type"(类型): "20"}
@property (nonatomic, strong) NSArray <MeariRadarMonitorBodySubModel*>*dateList;
@end


@interface MeariRadarMonitorBodyWeekModel : MeariBaseModel
@property (nonatomic, strong) NSString *day;
@property (nonatomic, assign) NSInteger downSleepCount;
@property (nonatomic, assign) NSInteger bodyMoveCount;
//当天体动总次数 （趴睡+体动）
@property (nonatomic, assign) NSInteger allDayCount;
@end

NS_ASSUME_NONNULL_END
