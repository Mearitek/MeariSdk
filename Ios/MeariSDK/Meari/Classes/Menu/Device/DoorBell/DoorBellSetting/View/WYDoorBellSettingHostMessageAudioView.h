//
//  WYDoorBellSettingHostMessageAudioView.h
//  Meari
//
//  Created by FMG on 2017/7/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYDoorBellSettingHostMessageAudioView;
@protocol WYDoorBellHostMessageAudioDelegate <NSObject>

@optional
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapCancelButton:(UIButton *)btn;
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapCheckButton:(UIButton *)btn;
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView startRecordButton:(UIButton *)btn;
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView stopRecordButton:(UIButton *)btn;
- (void)HostMessageAudioView:(WYDoorBellSettingHostMessageAudioView *)audioView didTapPlayButton:(UIButton *)btn;
@end
@interface WYDoorBellSettingHostMessageAudioView : UIView
@property (nonatomic, weak) id<WYDoorBellHostMessageAudioDelegate> delegate;
@property (nonatomic, assign) BOOL enableRecord;
@property (nonatomic, assign) BOOL microphoneAuth;
- (void)setRecordLimitTime:(float)time;
//取消试听状态
- (void)cancelAudition;
//试听结束
- (void)didFinishedPlay;
@end
