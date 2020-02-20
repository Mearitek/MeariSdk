//
//  WYCoreDataManager+Add.h
//  Meari
//
//  Created by 李兵 on 2017/5/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCoreDataManager.h"

@interface WYCoreDataManager (Add)
//报警消息
- (NSArray *)getAllAlarmMessagesOfDevice:(NSNumber *)deviceID;
- (NSArray *)getAllVoiceAlarmMessagesOfDevice:(NSNumber *)deviceID;
- (NSArray *)getSortedAlarmMessagesOfDevice:(NSNumber *)deviceID count:(NSInteger)count;
- (NSArray *)getSortedVoiceMessagesOfDevice:(NSNumber *)deviceID perPageCount:(NSInteger)count pageIndex:(NSInteger)index ;
- (NSArray *)getSortedVoiceAlarmMessagesOfDevice:(NSNumber *)deviceID;
- (BOOL)hasUnreadMessageOfDevice:(NSNumber *)deviceID;
- (BOOL)hasUnreadVoiceMessageOfDevice:(NSNumber *)deviceID;
- (void)deletegetAllAlarmMessagesOfDevice:(NSNumber *)deviceID;
@end
