//
//  WYCameraTime.h
//  Meari
//
//  Created by 李兵 on 2016/11/30.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct {
    int year;               //!< 年
    int month;              //!< 月
    int day;                //!< 日
} WYDate;

typedef struct {
    int hour;               //!< 时
    int min;                //!< 分
    int sec;                //!< 秒
} WYTime;

typedef NS_ENUM(NSInteger, WYTimeType) {
    WYTimeType_pir  = 0,
    WYTimeType_visitor,
};


@interface WYCameraTime : NSObject


@property (nonatomic, assign) WYDate date;
@property (nonatomic, assign) WYDate videoDay;
@property (nonatomic, assign) WYTime startTime;
@property (nonatomic, assign) WYTime endTime;
@property (nonatomic, assign) WYTime alarmTime;
@property (nonatomic, assign) WYTimeType timeType;


@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *videoDayStr;
@property (nonatomic, copy) NSString *startTimeStr;
@property (nonatomic, copy) NSString *endTimeStr;



@property (nonatomic, assign)CGFloat startSecond;
@property (nonatomic, assign)CGFloat endSecond;
@property (nonatomic, assign)CGFloat duration;

@property (nonatomic, assign)CGFloat alarmSecond;
@property (nonatomic, copy)NSString *alarmString;

+ (instancetype)timeWithVideoTimesString:(char*)str year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (instancetype)timeWithVideoTimesString:(char*)str;
+ (instancetype)timeWithAlarmTimeString:(NSString *)alarmString;
+ (instancetype)timeWithTimesDictionary:(NSDictionary *)dic;
+ (instancetype)timeWithVideoDaysDictionary:(NSDictionary *)dic;
+ (NSArray <WYCameraTime *>*)videoTimesByTidied:(NSArray<WYCameraTime *>*)originalVideoTimes;


@end
