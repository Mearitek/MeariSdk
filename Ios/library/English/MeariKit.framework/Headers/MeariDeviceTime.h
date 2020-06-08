//
//  MeariDeviceTime.h
//  MeariKit
//
//  Created by MJ2009 on 2019/1/14.
//  Copyright © 2019 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct {
    int year;
    int month;
    int day;
} MeariDate;

typedef struct {
    int hour;
    int min;
    int sec;
} MeariTime;

@interface MeariDeviceTime : MeariBaseModel
@property (nonatomic, assign) MeariDate date;
@property (nonatomic, assign) MeariDate videoDay;
@property (nonatomic, assign) MeariTime startTime;
@property (nonatomic, assign) MeariTime endTime;

@property (nonatomic, assign) MeariTime alarmTime;


@end

NS_ASSUME_NONNULL_END
