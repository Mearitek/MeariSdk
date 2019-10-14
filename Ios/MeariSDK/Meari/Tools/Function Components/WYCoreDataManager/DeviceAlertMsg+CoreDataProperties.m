//
//  DeviceAlertMsg+CoreDataProperties.m
//  Meari
//
//  Created by 李兵 on 2017/5/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "DeviceAlertMsg+CoreDataProperties.h"

@implementation DeviceAlertMsg (CoreDataProperties)

+ (NSFetchRequest<DeviceAlertMsg *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DeviceAlertMsg"];
}

@dynamic deviceID;
@dynamic deviceUUID;
@dynamic devLocalTime;
@dynamic imageAlertType;
@dynamic imgUrl;
@dynamic isRead;
@dynamic msgID;
@dynamic selected;
@dynamic userID;
@dynamic userIDS;
@dynamic thumbnailPic;

- (void)setModelWithInfo:(MeariMessageInfoAlarmDevice *)info UUID:(NSString *)uuid {
    self.deviceID       = @(info.deviceID);
    self.imageAlertType = @(info.msgType);
    self.msgID          = @(info.msgID);
    self.userID         = @(info.userID);
    self.userIDS        = @(info.ownerID);
    self.imgUrl         = [info.alarmImages componentsJoinedByString:@","];
    self.thumbnailPic   = info.alarmThumbImage;
    self.devLocalTime   = info.alarmTime;

    //自定义键
    self.isRead     = info.isRead ? @"Y" : @"N";
    self.selected   = @0;
    self.deviceUUID = uuid;
}
- (void)setReaded {
    self.isRead = @"Y";
}
- (NSArray <NSURL *> *)alarmImageUrls {
    NSArray *arr = nil;
    if ([self.imgUrl rangeOfString:@","].length > 0) {
        NSArray *arr1 = [self.imgUrl componentsSeparatedByString:@","];
        NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:arr1.count];
        for (NSString *str in arr1) {
            NSURL *url = str.wy_url;
            if (url && url.absoluteString.length > 0) {
                [arr2 addObject:url];
            }
        }
        if (arr2.count > 0) {
            arr = arr2.copy;
        }
    }else {
        NSURL *url = self.imgUrl.wy_url;
        if (url) {
            arr = @[url];
        }
    }
    return arr;
}
- (NSURL *)alarmImageUrl {
    NSURL *url = nil;
    if (self.thumbnailPic.length > 0) {
        url = [NSURL URLWithString:self.thumbnailPic];
    }
    if (!url) {
        url = self.alarmImageUrls.firstObject;
    }
    return url;
}


@end
