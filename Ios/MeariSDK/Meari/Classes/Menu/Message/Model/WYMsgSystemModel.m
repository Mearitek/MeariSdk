//
//  WYMsgSystemModel.m
//  Meari
//
//  Created by 李兵 on 16/3/28.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgSystemModel.h"

@implementation WYMsgSystemModel

- (NSString *)accountWhole {
    if (self.info.msgType == MeariSystemMessageTypeDeviceLowBattery) {
        _accountWhole = [NSString stringWithFormat:@"%@",self.info.deviceName];
    } else {
        _accountWhole = [NSString stringWithFormat:@"%@ (%@)", self.info.deviceName, self.info.friendAccount];
    }
    return _accountWhole;
}
- (NSString *)descWhole {
    switch (self.info.msgType) {
        case MeariSystemMessageTypeNone: {
            break;
        }
        case MeariSystemMessageTypeFriendAdd: {
            self.descWhole = WYLocalString(@"RequestAddFriend");
            break;
        }
        case MeariSystemMessageTypeFriendAgree: {
            self.descWhole = WYLocalString(@"AgreeAddFriend");
            break;
        }
        case MeariSystemMessageTypeFriendRefuse: {
            self.descWhole = WYLocalString(@"RefuseAddFriend");
            break;
        }
        case MeariSystemMessageTypeDeviceShare: {
            self.descWhole = [WYLocalString(@"RequestShareDevice") stringByAppendingFormat:@" (%@)", self.info.deviceName];
            break;
        }
        case MeariSystemMessageTypeDeviceAgree: {
            self.descWhole = [WYLocalString(@"AgreeShareDevice")  stringByAppendingFormat:@" (%@)", self.info.deviceName];
            break;
        }
        case MeariSystemMessageTypeDeviceRefuse: {
            self.descWhole = [WYLocalString(@"RefuseShareDevice")  stringByAppendingFormat:@" (%@)", self.info.deviceName];
            break;
        }
        case MeariSystemMessageTypeDeviceLowBattery: {
            self.descWhole = WYLocalString(@"Low Power Reminder");
            break;
        }
  
        default:
            break;
    }
    return _descWhole;
}

@end
