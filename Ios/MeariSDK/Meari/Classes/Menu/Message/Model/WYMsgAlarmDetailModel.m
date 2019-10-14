//
//  WYMsgAlarmDetailModel.m
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgAlarmDetailModel.h"

@implementation WYMsgAlarmDetailModel

- (void)setMsg:(DeviceAlertMsg *)msg {
    _msg = msg;
    if (msg.imageAlertType && !self.customAlarmType) {
        switch ([msg.imageAlertType integerValue]) {
            case 1: {
                self.customAlarmType = WYMsgAlarmTypeMotion;
                break;
            }
            case 2: {
                self.customAlarmType = WYMsgAlarmTypePIRDetection;
                break;
            }
            case 3: {
                self.customAlarmType = WYMsgAlarmTypeVisitor;
                break;
            }
            default:
                self.customAlarmType = WYMsgAlarmTypeNone;
                break;
        }
    }
}

@end
