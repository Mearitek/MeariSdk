//
//  MeariPlayer.h
//  MeariKit
//
//  Created by maj on 2019/1/24.
//  Copyright © 2019年 Meari. All rights reserved.
//


#import "IJKMediaPlayback.h"

NS_ASSUME_NONNULL_BEGIN

/**
 播放状态

 - MeariCloudStatusNone: 空
 - MeariCloudStatusPreparing: 准备播放
 - MeariCloudStatusStarted: 开始播放
 - MeariCloudStatusPaused: 暂停播放
 - MeariCloudStatusStopped: 停止播放
 - MeariCloudStatusInterrupted: 播放中断
 - MeariCloudStatusError: 播放错误
 */
typedef NS_ENUM (NSInteger, MeariCloudStatus) {
    MeariCloudStatusNone,
    MeariCloudStatusPreparing,
    MeariCloudStatusStarted,
    MeariCloudStatusPaused,
    MeariCloudStatusStopped,
    MeariCloudStatusInterrupted,
    MeariCloudStatusError
};

/**
 录制状态

 - MeariCloudRecordStateNone: 无
 - MeariCloudRecordStateStarted: 开始录制
 - MeariCloudRecordStateStopped: 结束录制
 */
typedef NS_ENUM (NSInteger, MeariCloudRecordState) {
    MeariCloudRecordStateNone,
    MeariCloudRecordStateStarted,
    MeariCloudRecordStateStopped
};

@protocol meariCloudDelegate <NSObject>
@optional
- (void)meariCloudVCDidSnapedToPath:(NSString *)path;  // 截图成功
- (void)meariCloudVCDidRecordedToPath:(NSString *)path; // 录制成功

- (void)meariCloudVCDidStartedPlay; // 开始播放
- (void)meariCloudVCDidPausedPlay; // 暂停播放
- (void)meariCloudVCDidStopedPlayNormally; // 停止播放
- (void)meariCloudVCDidStopedPlayAbnormally; // 播放错误

@end

@interface MeariCloudPlayer : NSObject

/**
 初始化

 @param url 地址
 @param startTime 开始时间
 @param superView 父视图
 @return MeariPlayer
 */
- (instancetype)initWithURL:(NSURL *)url startTime:(NSString *)startTime superView:(UIView *)superView;

@property (atomic, strong, readonly) id<IJKMediaPlayback> meariPlayer; // 播放器
@property (nonatomic, weak) id<meariCloudDelegate> delegate; // 代理
@property (nonatomic, assign, readonly) MeariCloudStatus playState; //播放状态
@property (nonatomic, assign, readonly) MeariCloudRecordState recordState; // 录制状态

@property (nonatomic, assign, readonly, getter = isPlaying) BOOL playing; // 是否正在播放
@property (nonatomic, assign) BOOL muted; // 是否静音

- (BOOL)snapToPath:(NSString *)path; // 截图,保存路径
- (BOOL)startRecord:(NSString *)path; // 录制,保存路径
- (void)stopRecord; //结束录制
- (void)play; // 开始播放
- (void)stop; // 停止播放
- (void)pause; // 暂停
- (void)shutdown; // 关闭播放
- (void)hidePlayer; // 隐藏播放器
- (void)playVideoAtTime:(NSString *)time url:(NSURL *)url;  // seek进度
- (NSTimeInterval)getVideoCurrentSecond;    // 当前播放时间（单位：秒）
- (NSTimeInterval)getVideoDuration;         // 时长（单位：秒）

@end

NS_ASSUME_NONNULL_END
