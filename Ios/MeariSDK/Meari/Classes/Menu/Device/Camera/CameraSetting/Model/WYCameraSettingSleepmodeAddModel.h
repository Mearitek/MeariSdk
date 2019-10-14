//
//  WYCameraSettingSleepmodeAddModel.h
//  Meari
//
//  Created by 李兵 on 2017/1/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYCameraSettingSleepmodeTimesModel.h"

@interface WYCameraSettingSleepmodeAddModel : NSObject
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *detailedText;
@property (nonatomic, assign)WYCameraSettingSleepmodeWeekdays weekday;
@property (nonatomic, assign)BOOL   selected;

+ (instancetype)starttimeModel;
+ (instancetype)endtimeModel;
+ (instancetype)mondayModel;
+ (instancetype)tuesdayModel;
+ (instancetype)wednesdayModel;
+ (instancetype)thursdayModel;
+ (instancetype)fridayModel;
+ (instancetype)saturdayModel;
+ (instancetype)sundayModel;


@end
