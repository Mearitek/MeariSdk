//
//  WYTableHeaderView+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/1/12.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYTableHeaderView+Extension.h"

@implementation WYTableHeaderView (Extension)
+ (instancetype)header_nvrCameraList {
    return [WYTableHeaderView defaultHeaderWithTitle:WYLocalString(@"header_nvrCameraList")];
}
+ (instancetype)header_nvrCameraBind {
    return [WYTableHeaderView defaultHeaderWithTitle:WYLocalString(@"header_nvrCameraBind")];
}
+ (instancetype)header_nvrShare {
    return [WYTableHeaderView defaultHeaderWithTitle:WYLocalString(@"header_nvrShare")];
}
+ (instancetype)header_cameraShare {
    return [WYTableHeaderView defaultHeaderWithTitle:WYLocalString(@"header_cameraShare")];
}
+ (instancetype)header_cameraSleepmode {
    return [WYTableHeaderView defaultHeaderWithTitle:WYLocalString(@"header_cameraSleepmode")];
}
+ (instancetype)header_prompt_jingleBellPairing {
    return [WYTableHeaderView promptHeaderWithTitlte:WYLocalString(@"des_jingleBellPairing")];
}
+ (instancetype)header_prompt_jingleBellBattery {
    return [WYTableHeaderView promptHeaderWithTitlte:WYLocalString(@"des_doorbell_batteryLock")];
}

@end
