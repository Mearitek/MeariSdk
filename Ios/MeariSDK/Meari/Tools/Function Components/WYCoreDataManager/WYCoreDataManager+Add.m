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
- (NSArray *)getSortedAlarmMessagesOfDevice:(NSNumber *)deviceID count:(NSInteger)count {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@ AND userID=%@ AND userIDS=0 OR deviceID=%@ AND userIDS=%@", deviceID, WY_USER_ID, deviceID, WY_USER_ID];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"msgID" ascending:NO];
    return [self queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate sortDescriptor:@[sort] fetchLimit:count];
    
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
- (void)deletegetAllAlarmMessagesOfDevice:(NSNumber *)deviceID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceID=%@",deviceID];
    [self deleteDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
}
@end
