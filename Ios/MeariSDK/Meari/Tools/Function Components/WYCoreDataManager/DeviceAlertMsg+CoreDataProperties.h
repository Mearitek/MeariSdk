//
//  DeviceAlertMsg+CoreDataProperties.h
//  Meari
//
//  Created by 李兵 on 2017/5/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "DeviceAlertMsg+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceAlertMsg (CoreDataProperties)

+ (NSFetchRequest<DeviceAlertMsg *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *deviceID;
@property (nullable, nonatomic, copy) NSString *deviceUUID;
@property (nullable, nonatomic, copy) NSString *devLocalTime;
@property (nullable, nonatomic, copy) NSNumber *imageAlertType;
@property (nullable, nonatomic, copy) NSString *imgUrl;
@property (nullable, nonatomic, copy) NSString *isRead;
@property (nullable, nonatomic, copy) NSNumber *msgID;
@property (nullable, nonatomic, copy) NSNumber *selected;
@property (nullable, nonatomic, copy) NSNumber *userID;
@property (nullable, nonatomic, copy) NSNumber *userIDS;
@property (nullable, nonatomic, copy) NSString *thumbnailPic;
@property (nullable, nonatomic, copy) NSNumber *msgType;


- (void)setModelWithInfo:(MeariMessageInfoAlarmDevice *)info UUID:(NSString *)uuid;
- (void)setReaded;
- (NSArray <NSURL *> *)alarmImageUrls;
- (NSURL *)alarmImageUrl;

@end

NS_ASSUME_NONNULL_END
