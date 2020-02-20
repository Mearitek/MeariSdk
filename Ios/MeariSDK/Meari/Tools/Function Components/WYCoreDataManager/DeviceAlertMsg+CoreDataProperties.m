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

@dynamic createDate;
@dynamic deviceID;
@dynamic deviceUUID;
@dynamic devLocalTime;
@dynamic imageAlertType;
@dynamic imgUrl;
@dynamic isRead;
@dynamic msgID;
@dynamic msgType;
@dynamic selected;
@dynamic thumbnailPic;
@dynamic userID;
@dynamic userIDS;
@dynamic decibel;
@dynamic isTimeTag;
@dynamic localImageArray;
@dynamic localImageData;
@dynamic localVoiceData;
@dynamic state;
@dynamic voiceDuration;
@dynamic voiceUrl;


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

- (void)setModelWithInfoVisitor:(MeariMessageInfoVisitor *)msg UUID:(NSString *)uuid{
    
    self.deviceID = @(msg.deviceID);
    self.msgType = @(msg.msgType);
    self.msgID = @(msg.msgID);
    self.userID = @([WY_USER_ID integerValue]);
    self.userIDS = @(msg.userID);
    self.createDate = msg.createDate;
    //    self.devLocalTime = msg.createDate;
    self.isRead = msg.isRead ? @"Y" : @"N";
    self.voiceUrl = msg.voiceUrl;
    self.voiceDuration = msg.voiceDuration;
    self.localImageArray = [NSMutableArray array];
    //自定义键
    self.selected   = @0;
    self.deviceUUID = uuid;
    self.isTimeTag = @(0);
}

- (void)setReaded {
    self.isRead = @"Y";
}
- (void)saveLocalImageData:(NSData *)localImageData {
    self.localImageData = localImageData;
}
- (void)saveLocalVoiceData:(NSData *)localVoiceData {
    self.localVoiceData = localVoiceData;
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
