//
//  WYInstructionView.m
//  Meari
//
//  Created by 李兵 on 2017/2/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYInstructionView.h"

@implementation WYInstructionView
#pragma mark - Private
+ (instancetype)instructionWithText:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor needLine:(BOOL)needLine{
    WYInstructionView *v = [WYInstructionView new];
    v.backgroundColor = backgroundColor;
    UILabel *label = [UILabel labelWithFrame:CGRectZero
                                        text:text
                                   textColor:textColor
                                    textfont:WYFont_Text_S_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByWordWrapping
                               lineAlignment:NSTextAlignmentCenter
                                   sizeToFit:NO];
    [v addSubview:label];
    if (needLine) {
        [v addLineViewAtBottom];
    }
    CGFloat lr = 20;
    CGFloat ub = 15;
    CGFloat w = WY_ScreenWidth-2*lr;
    CGFloat h = [label ajustedHeightWithWidth:w];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(w, h));
        make.center.equalTo(v);
    }];
    v.bounds = CGRectMake(0, 0, WY_ScreenWidth, h + 2*ub);
    return v;
}
+ (instancetype)grayInstructionWithText:(NSString *)text {
    return [self instructionWithText:text textColor:WY_FontColor_Gray backgroundColor:WY_BGColor_LightGray needLine:YES];
}
+ (instancetype)orangeInstructionWithText:(NSString *)text {
    return [self instructionWithText:text textColor:WY_FontColor_Orange backgroundColor:WY_BGColor_LightOrange needLine:NO];
}



#pragma mark - Public

+ (instancetype)nvrSetting_CameraManagement {
    return [self grayInstructionWithText:WYLocalString(@"status_nvrBindingTooMore")];
}
+ (instancetype)nvrSetting_SelectWifi {
    return [self orangeInstructionWithText:WYLocalString(@"des_selectWIFI")];
}
+ (instancetype)nvrSetting_CameraBinding {
    return [self nvrSetting_CameraManagement];
}
+ (instancetype)cameraSetting_Sleepmode {
    return [self orangeInstructionWithText:WYLocalString(@"SleepMode_Warning")];
}
+ (instancetype)cameraSetting_SleepmodeTimesAdd {
    return [self grayInstructionWithText:WYLocalString(@"des_cameraSettingSleepmodeAdd")];
}
+ (instancetype)config_qr {
    return [self orangeInstructionWithText:WYLocalString(@"qrcode_deviceScan_operation_des")];
}

@end
