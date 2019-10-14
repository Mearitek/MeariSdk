//
//  WYCameraTime.m
//  Meari
//
//  Created by 李兵 on 2016/11/30.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraTime.h"

static const char daysSource[] = {1<<0, 1<<1, 1<<2, 1<<3, 1<<4, 1<<5, 1<<6, 1<<7};
static const char minsSource[] = {1<<7, 1<<6, 1<<5, 1<<4, 1<<3, 1<<2, 1<<1, 1<<0};

@implementation WYCameraTime

#pragma mark - Private
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"startTime":self.startTimeStr,
                                               @"endTime":self.endTimeStr,
                                               @"alarmTime":self.alarmString,
                                               @"videoDay":self.videoDayStr,
                                               @"date":self.dateStr
                                               }];
}
#pragma mark - Init
- (instancetype)initWithVideoTimeStrings:(char*)str year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    if (self = [super init]) {
        int sh = 0,sm = 0,ss = 0,eh = 0,em = 0,es = 0;
        if (!str || str[0] == 0)return nil;
        if (strlen(str) == 13) {
            sscanf(str, "%02d%02d%02d-%02d%02d%02d", &sh, &sm, &ss, &eh, &em, &es);
        }
        self.date = (WYDate) {
            (int)year,
            (int)month,
            (int)day,
        };
        
        self.startTime = (WYTime){sh,sm,ss};
        self.endTime   = (WYTime){eh,em,es};
    }
    return self;
}
- (instancetype)initWithAlarmTimeStrings:(NSString *)alarmString {
    self = [super init];
    if (self) {
        if (alarmString.length != 14) return nil;
        NSString *h = [alarmString substringWithRange:NSMakeRange(8, 2)];
        NSString *m = [alarmString substringWithRange:NSMakeRange(10, 2)];
        NSString *s = [alarmString substringWithRange:NSMakeRange(12, 2)];
        self.alarmTime = (WYTime) {
            h.intValue,
            m.intValue,
            s.intValue
        };
    }
    return self;
}
- (instancetype)initWithTimesDictionary:(nonnull NSDictionary *)dic {
    self = [super init];
    if (self) {
        NSString *startTime = dic[@"starttime"];
        NSString *endtime = dic[@"endtime"];
        if (WY_IsKindOfClass(startTime, NSString) && WY_IsKindOfClass(endtime, NSString)) {
            if (startTime.length == 14 && endtime.length == 14) {
                int year, month, day, sh, sm, ss, eh, em, es;
                year = [[startTime substringWithRange:NSMakeRange(0, 4)] intValue];
                month = [[startTime substringWithRange:NSMakeRange(4, 2)] intValue];
                day = [[startTime substringWithRange:NSMakeRange(6, 2)] intValue];
                sh = [[startTime substringWithRange:NSMakeRange(8, 2)] intValue];
                sm = [[startTime substringWithRange:NSMakeRange(10, 2)] intValue];
                ss = [[startTime substringWithRange:NSMakeRange(12, 2)] intValue];
                eh = [[endtime substringWithRange:NSMakeRange(8, 2)] intValue];
                em = [[endtime substringWithRange:NSMakeRange(10, 2)] intValue];
                es = [[endtime substringWithRange:NSMakeRange(12, 2)] intValue];
                
                self.startTime = (WYTime){sh, sm, ss};
                self.endTime = (WYTime){eh, em, es};
            }
        }
    }
    return self;
}
- (instancetype)initWithVideoDaysDictionary:(nonnull NSDictionary *)dic {
    self = [super init];
    if (self) {
        NSString *date = dic[@"date"];
        
        if (WY_IsKindOfClass(date, NSString) && date.length == 8) {
            int year, month, day;
            year = [[date substringWithRange:NSMakeRange(0, 4)] intValue];
            month = [[date substringWithRange:NSMakeRange(4, 2)] intValue];
            day = [[date substringWithRange:NSMakeRange(6, 2)] intValue];
            self.videoDay = (WYDate){year,month,day};
        }
    }
    return self;
}


#pragma mark - Public
- (NSString *)startTimeStr {
    _startTimeStr = [NSString stringWithFormat:@"%02d%02d%02d", self.startTime.hour, self.startTime.min, self.startTime.sec];
    return _startTimeStr;
}
- (NSString *)endTimeStr {
    _endTimeStr = [NSString stringWithFormat:@"%02d%02d%02d", self.endTime.hour, self.endTime.min, self.endTime.sec];
    return _endTimeStr;
}
- (NSString *)videoDayStr {
    return [NSString stringWithFormat:@"%02d%02d%02d", self.videoDay.year, self.videoDay.month, self.videoDay.day];
}
- (NSString *)dateStr {
    return [NSString stringWithFormat:@"%02d%02d%02d", self.date.year, self.date.month, self.date.day];
}

- (CGFloat)startSecond {
    _startSecond = self.startTime.hour*3600 + self.startTime.min*60 + self.startTime.sec;
    return _startSecond;
}
- (CGFloat)endSecond {
    _endSecond = self.endTime.hour*3600 + self.endTime.min*60 + self.endTime.sec;
    return _endSecond;
}
- (CGFloat)duration {
    _duration = self.endSecond - self.startSecond;
    return _duration;
}

- (NSString *)alarmString {
    int second = self.alarmSecond;
    _alarmString = [NSString stringWithFormat:@"%02d:%02d:%02d", second/3600, second/60%60, second%60];
    return _alarmString;
}
- (CGFloat)alarmSecond {
    _alarmSecond = self.alarmTime.hour*3600 + self.alarmTime.min*60 + self.alarmTime.sec;
    return _alarmSecond;
}

+ (instancetype)timeWithVideoTimesString:(char*)str year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [[self alloc] initWithVideoTimeStrings:str year:year month:month day:day];
}
+ (instancetype)timeWithVideoTimesString:(char*)str {
    return [self timeWithVideoTimesString:str year:0 month:0 day:0];
}
+ (instancetype)timeWithAlarmTimeString:(NSString *)alarmString {
    return  [[self alloc] initWithAlarmTimeStrings:alarmString];
}
+ (instancetype)timeWithTimesDictionary:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]] || dic.count <= 0) return nil;
    
    return [[WYCameraTime alloc] initWithTimesDictionary:dic];
}
+ (instancetype)timeWithVideoDaysDictionary:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]] || dic.count <= 0) return nil;
    return [[WYCameraTime alloc] initWithVideoDaysDictionary:dic];
}
+ (NSArray <WYCameraTime *>*)videoTimesByTidied:(NSArray<WYCameraTime *>*)originalVideoTimes {
    if (originalVideoTimes.count <= 1) {
        return originalVideoTimes;
    }
    
    NSMutableArray *tidiedArr = [NSMutableArray arrayWithCapacity:originalVideoTimes.count];
    [tidiedArr addObject:originalVideoTimes.firstObject];
    [originalVideoTimes enumerateObjectsUsingBlock:^(WYCameraTime * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WYCameraTime *lastTime = tidiedArr.lastObject;
        if (obj.startSecond <= lastTime.endSecond) {
            lastTime.endTime = (WYTime){obj.endTime.hour, obj.endTime.min, obj.endTime.sec};
        }else {
            [tidiedArr addObject:obj];
        }
    }];
    return tidiedArr;
}



@end
