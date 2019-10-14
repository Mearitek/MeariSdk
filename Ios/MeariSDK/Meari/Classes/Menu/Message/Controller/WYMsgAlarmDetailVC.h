//
//  WYMsgAlarmDetailVC.h
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYBaseSubVC.h"

UIKIT_EXTERN NSInteger const WYMsgAlarmMaxCountPerPage;

@interface WYMsgAlarmDetailVC : WYBaseSubVC<WYEditManagerDelegate>

- (instancetype)initWithDeviceName:(NSString *)deviceName deviceID:(NSInteger)deviceID;
- (instancetype)init NS_UNAVAILABLE;

- (void)networkRequestFromPush;

@end
