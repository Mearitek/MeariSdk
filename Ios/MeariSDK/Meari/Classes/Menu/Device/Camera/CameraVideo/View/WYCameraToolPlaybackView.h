//
//  WYCameraToolPlaybackView.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCameraToolPlaybackTimeBarView.h"
#import "WYCameraToolPlaybackAlarmMessageView.h"
#import "WYCameraToolPlaybackPictureBarView.h"

@interface WYCameraToolPlaybackView : WYBaseView

@property(nonatomic, weak)WYCameraToolPlaybackTimeBarView *timeBarView;
@property(nonatomic, weak)WYCameraToolPlaybackPictureBarView *pictureBarView;
@property(nonatomic, weak)WYCameraToolPlaybackAlarmMessageView *alarmMsgView;
- (instancetype)initWithDeviceType:(MeariDeviceSubType)deviceType;
- (void)resetToNormal;
@end
