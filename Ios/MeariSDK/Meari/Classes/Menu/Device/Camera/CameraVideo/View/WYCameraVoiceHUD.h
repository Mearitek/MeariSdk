//
//  WYVoiceHUD.h
//  test
//
//  Created by 李兵 on 2016/12/3.
//  Copyright © 2016年 李兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WY_CameraVoiceHUD [WYCameraVoiceHUD sharedVoiceHUD]

@interface WYCameraVoiceHUD : WYBaseView

WY_Singleton_Interface(VoiceHUD)

+ (void)show:(BOOL)animated;
+ (void)hide:(BOOL)animated;
+ (void)setVoiceProgress:(CGFloat)progress;
+ (BOOL)isShow;
@end
