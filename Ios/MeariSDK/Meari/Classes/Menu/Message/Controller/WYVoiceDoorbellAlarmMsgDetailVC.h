//
//  WYVoiceDoorbellAlarmMsgDetailVC.h
//  Meari
//
//  Created by MJ2009 on 2018/7/4.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYBaseSubVC.h"

@interface WYVoiceDoorbellAlarmMsgDetailVC : WYBaseSubVC

- (instancetype)initWithDeviceName:(NSString *)deviceName deviceID:(NSInteger)deviceID;
- (instancetype)init NS_UNAVAILABLE;

- (void)networkRequestFromPush;

@end
