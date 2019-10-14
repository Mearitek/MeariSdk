//
//  WYCameraSettingSleepmodeAddModel.m
//  Meari
//
//  Created by 李兵 on 2017/1/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepmodeAddModel.h"

@implementation WYCameraSettingSleepmodeAddModel
+ (instancetype)modelWithText:(NSString *)text detailedText:(NSString *)detailedText selected:(BOOL)selected weekDay:(WYCameraSettingSleepmodeWeekdays)weekday{
    WYCameraSettingSleepmodeAddModel *model = [WYCameraSettingSleepmodeAddModel new];
    model.text = text;
    model.detailedText = detailedText;
    model.selected = selected;
    model.weekday = weekday;
    return model;
}

+ (instancetype)starttimeModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"Start time") detailedText:nil selected:NO weekDay:0];
}
+ (instancetype)endtimeModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"End time") detailedText:nil selected:NO weekDay:0];
}

+ (instancetype)mondayModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"week_Monday") detailedText:nil selected:NO weekDay:WYCameraSettingSleepmodeMonday];
}
+ (instancetype)tuesdayModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"week_Tuesday") detailedText:nil selected:NO weekDay:WYCameraSettingSleepmodeTuesday];
}
+ (instancetype)wednesdayModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"week_Wednesday") detailedText:nil selected:NO weekDay:WYCameraSettingSleepmodeWednesday];
}
+ (instancetype)thursdayModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"week_Thursday") detailedText:nil selected:NO weekDay:WYCameraSettingSleepmodeThursday];
}
+ (instancetype)fridayModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"week_Friday") detailedText:nil selected:NO weekDay:WYCameraSettingSleepmodeFriday];
}
+ (instancetype)saturdayModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"week_Saturday") detailedText:nil selected:NO weekDay:WYCameraSettingSleepmodeSaturday];
}
+ (instancetype)sundayModel {
    return [WYCameraSettingSleepmodeAddModel modelWithText:WYLocalString(@"week_Sunday") detailedText:nil selected:NO weekDay:WYCameraSettingSleepmodeSunday];
}


@end
