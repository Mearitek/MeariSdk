//
//  WYCoreDataManager+Add.m
//  Meari
//
//  Created by 李兵 on 2017/5/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCoreDataManager+Add.h"
#import "DeviceAlertMsg+CoreDataProperties.h"

@implementation WYCoreDataManager (Add)

- (NSArray *)getAllAlarmMessagesOfDevice:(NSNumber *)deviceID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@ AND (userID=%@ AND userIDS=0 OR userIDS=%@)",deviceID, WY_USER_ID, WY_USER_ID];
    return [self queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
}
- (NSArray *)getAllVoiceAlarmMessagesOfDevice:(NSNumber *)deviceID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@ AND userID=%@",deviceID,WY_USER_ID];
    return [self queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
}
- (NSArray *)getSortedAlarmMessagesOfDevice:(NSNumber *)deviceID count:(NSInteger)count {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@ AND userID=%@ AND userIDS=0 OR deviceID=%@ AND userIDS=%@", deviceID, WY_USER_ID, deviceID, WY_USER_ID];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"msgID" ascending:NO];
    return [self queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate sortDescriptor:@[sort] fetchLimit:count];
}
- (NSArray *)getSortedVoiceMessagesOfDevice:(NSNumber *)deviceID perPageCount:(NSInteger)count pageIndex:(NSInteger)index {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@ AND userID=%@", deviceID, WY_USER_ID];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    return [self queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate sortDescriptor:@[sort] fetchLimit:count fetchOffset:index];
    
}
- (NSArray *)getSortedVoiceAlarmMessagesOfDevice:(NSNumber *)deviceID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@", deviceID];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES];
    return [self queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate sortDescriptor:@[sort] fetchLimit:-1 fetchOffset:-1];
    
}
- (BOOL)hasUnreadMessageOfDevice:(NSNumber *)deviceID {
    NSArray *arr = [self getAllAlarmMessagesOfDevice:deviceID];
    BOOL res = NO;
    for (DeviceAlertMsg *msg in arr) {
        if ([msg.isRead isEqualToString:@"N"]) {
            res = YES;
            break;
        }
    }
    return res;
}
- (BOOL)hasUnreadVoiceMessageOfDevice:(NSNumber *)deviceID {
    NSArray *arr = [self getAllVoiceAlarmMessagesOfDevice:deviceID];
    BOOL res = NO;
    for (DeviceAlertMsg *msg in arr) {
        if ([msg.isRead isEqualToString:@"N"]) {
            res = YES;
            break;
        }
    }
    return res;
}
- (void)deletegetAllAlarmMessagesOfDevice:(NSNumber *)deviceID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@",deviceID];
    [self deleteDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
}
@end
