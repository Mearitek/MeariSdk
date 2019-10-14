//
//  WYBaseModel.m
//  Meari
//
//  Created by 李兵 on 2017/4/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseModel.h"

@implementation WYBaseModel
- (instancetype)init {
    self = [super init];
    if (self) {
        //
        [self initAction];
    }
    return self;
}
- (void)dealloc {
    //
    [self deallocAction];
}
- (void)initAction {
    
}
- (void)deallocAction {
    
}
+ (instancetype)modelWithImageName:(NSString *)imageName text:(NSString *)text deatailedText:(NSString *)detailedText {
    WYBaseModel *model = [self new];
    model.imageName = imageName;
    model.text = text;
    model.detailedText = detailedText;
    return model;
}
@end


@implementation WYBaseModel (WYConst)
#pragma mark -- CameraSelectKind
+ (instancetype)CameraSelectKindCamera {
    return [self modelWithImageName:@"img_camera" text:WYLocalString(@"CAMERA") deatailedText:nil];
}
+ (instancetype)CameraSelectKindNVR {
    return [self modelWithImageName:@"img_nvr" text:WYLocalString(@"NVR") deatailedText:nil];
}
+ (instancetype)CameraSelectKindBatteryCamera {
    return [self modelWithImageName:@"img_battery_camera_selected" text:WYLocalString(@"Battery Camera") deatailedText:nil];
}
+ (instancetype)CameraSelectKindDoorBell {
    return [self modelWithImageName:@"img_doorBell" text:WYLocalString(@"Doorbell") deatailedText:nil];
}
+ (instancetype)CameraSelectKindVoiceDoorBell {
    return [self modelWithImageName:@"img_voice_doorBell" text:WYLocalString(@"device_voice_doorbell") deatailedText:nil];
}
@end
