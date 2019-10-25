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
    int year;               //!< year
    int month;              //!< month
    int day;                //!< day
} MeariDate;

typedef struct {
    int hour;               //!< hour
    int min;                //!< minute
    int sec;                //!< second
} MeariTime;

@interface MeariDeviceTime : MeariBaseModel
@property (nonatomic, assign) MeariDate date;
@property (nonatomic, assign) MeariDate videoDay;//  date
@property (nonatomic, assign) MeariTime startTime; // startTime
@property (nonatomic, assign) MeariTime endTime; // endTime

@property (nonatomic, assign) MeariTime alarmTime; // alarmTime


@end

NS_ASSUME_NONNULL_END
