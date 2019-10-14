//
//  WYCameraToolPreviewView.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCameraFullDuplexVoiceView.h"

@class WYCameraToolPreviewView,WYCameraToolPreviewSleepmodeModel;

@protocol WYCameraToolPreviewViewDelegate <NSObject>
@optional
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedAlarmButton:(UIButton *)button;
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedSleepmodeButton:(UIButton *)button model:(WYCameraToolPreviewSleepmodeModel *)sleepmode originalType:(MeariDeviceSleepmode)originalType;
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedShareButton:(UIButton *)button;
- (BOOL)WYCameraToolPreviewViewAllowSetSleepmode;
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedPIRButton:(UIButton *)button;
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedJingleBellButton:(UIButton *)button;
- (void)WYCameraToolPreviewView:(WYCameraToolPreviewView *)previewView didTapedPowerManagementButton:(UIButton *)button;

@end

@interface WYCameraToolPreviewView : WYBaseView
@property (nonatomic, weak)WYCameraFullDuplexVoiceView *fullDuplexVoiceView;
@property (nonatomic, weak)id<WYCameraToolPreviewViewDelegate>delegate;
@property (nonatomic, weak)UIImageView *deviceTypeImageView;
@property (nonatomic, assign)BOOL showMenu;
- (instancetype)initWithDeviceType:(MeariDeviceSubType)deviceType;
//设置码率
- (void)setBitrate:(NSString *)bitrate;
//设置电量
- (void)setEnergy:(NSString *)energy;
//设置温度
- (void)setTemperature:(CGFloat)temperature;
//设置湿度
- (void)setHumidity:(CGFloat)humidity;
//设置报警
- (void)setAlarmLevel:(MeariDeviceLevel)level enabled:(BOOL)enabled;
//设置休眠模式
- (void)setSleepmode:(MeariDeviceSleepmode)type enabled:(BOOL)enabled reset:(BOOL)reset;
- (void)setSleepmodeParam:(MeariDeviceParam *)param enabled:(BOOL)enabled reset:(BOOL)reset;
//设置分享
- (void)setShareEnabled:(BOOL)enabled;
//隐藏参数
- (void)setSettingHidden:(BOOL)hidden;
- (void)resetToNormal;

//doorbell
//PIR报警
- (void)setPIROpen:(BOOL)open enabled:(BOOL)enabled;
//设置铃铛
- (void)setJingleBellOpen:(BOOL)open enabled:(BOOL)enabled;
//设置低功耗
- (void)setLowPowerOpen:(BOOL)open enabled:(BOOL)enabled;
//获取温湿度
- (void)showTRHEmpty;
- (void)showTRHLoading;
- (void)showTFail;
- (void)showRHFail;
- (void)showTNone;
- (void)showRHNone;
- (void)showT:(CGFloat)temp;
- (void)showRH:(CGFloat)humidity;
- (void)showT:(CGFloat)temp rh:(CGFloat)humidity;
@end

@interface WYCameraToolPreviewSleepmodeModel : NSObject
@property (nonatomic, assign)MeariDeviceSleepmode type;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)UIImage *normalImage;
@property (nonatomic, copy)UIImage *highlightedImage;
@property (nonatomic, copy)UIImage *disabledImage;
@property (nonatomic, strong)UIColor *highlightedColor;
@property (nonatomic, assign)BOOL highlighted;
@property (nonatomic, assign)BOOL hasHomeSleeptime;

+ (instancetype)onModel;
+ (instancetype)offModel;
+ (instancetype)offByTimeModel;
+ (instancetype)baby_onModel;
+ (instancetype)baby_offModel;
+ (instancetype)baby_offByTimeModel;

@end
