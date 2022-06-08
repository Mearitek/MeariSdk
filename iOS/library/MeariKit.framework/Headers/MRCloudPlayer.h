//
//  MRCloudPlayer.h
//  ppsplayer
//
//  Created by xjzhuo on 2022/3/2.
//  Copyright © 2022 ppstrong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 播放状态

 - MeariCloudStatusNone: none (空)
 - MeariCloudStatusPreparing: prepare play (准备播放)
 - MeariCloudStatusStarted: start play (开始播放)
 - MeariCloudStatusPaused: pause play (暂停播放)
 - MeariCloudStatusStopped: stop play (停止播放)
 - MeariCloudStatusInterrupted: play interrupt (播放中断)
 - MeariCloudStatusError: play error (播放错误)
 */
typedef NS_ENUM (NSInteger, MeariCloudStatus) {
    MeariCloudStatusNone,
    MeariCloudStatusPreparing,
    MeariCloudStatusStarted,
    MeariCloudStatusPaused,
    MeariCloudStatusStopped,
    MeariCloudStatusEnd,
    MeariCloudStatusInterrupted,
    MeariCloudStatusError
};

/**
 record state
 录制状态

 - MeariCloudRecordStateNone: none (无)
 - MeariCloudRecordStateStarted: start record (开始录制)
 - MeariCloudRecordStateStopped: stop record (结束录制)
 */
typedef NS_ENUM (NSInteger, MeariCloudRecordState) {
    MeariCloudRecordStateNone,
    MeariCloudRecordStateStarted,
    MeariCloudRecordStateStopped
};

@protocol MeariCloudDelegate <NSObject>
@optional
- (void)meariCloudVCDidSnapedToPath:(NSString *)path;  // Screenshot successful (截图成功)
- (void)meariCloudVCDidRecordedToPath:(NSString *)path; // record Successful (录制成功)

- (void)meariCloudVCDidStartedPlay; // start play (开始播放)
- (void)meariCloudVCDidPausedPlay; // stop play (暂停播放)
- (void)meariCloudVCDidStopedPlayNormally; // stop play (停止播放)
- (void)meariCloudVCDidStopedPlayAbnormally; // play error (播放错误)
- (void)meariCloudVCDidPlayEnd; // play error (播放结束)
- (void)meariCloudVCDidPlayPswError:(NSTimeInterval)t; // play fail (播放密码错误)
@end



NS_ASSUME_NONNULL_BEGIN

@interface MRCloudPlayer : NSObject

/**
 初始化

 @param url video url (地址)
 @param startTime start time (开始时间)
 @param superView super view (父视图)
 @return MeariPlayer
 */
- (instancetype)initWithURL:(NSURL *)url startTime:(NSString *)startTime superView:(UIView *)superView psw:(NSString *)psw;

@property (nonatomic, weak) id<MeariCloudDelegate> delegate; // delegate (代理)
@property (nonatomic, assign, readonly) MeariCloudStatus playState; // play state (播放状态)
@property (nonatomic, assign, readonly) MeariCloudRecordState recordState; // record state(录制状态)

@property (nonatomic, assign, readonly, getter = isPlaying) BOOL playing; // Whether it is playing (是否正在播放)
@property (nonatomic, assign) BOOL muted; // mute (是否静音) 默认为NO
@property (nonatomic, assign) float speed; // 播放速率 // 支持0到4的速度  默认为1

- (BOOL)snapToPath:(NSString *)path; // Screenshot path : save path (截图,保存路径)
- (BOOL)startRecord:(NSString *)path; // Record path : save path (录制,保存路径)
- (void)stopRecord; //End recording (结束录制)
- (void)play; // start play (开始播放)
- (void)stop; // stop play (停止播放)
- (void)pause; // pause (暂停)
- (void)resetPlayerComplete:(void(^)(void))complete; // Turn off playback (关闭播放)
- (void)hidePlayer; // hide  player (隐藏播放器)
- (void)playVideoAtTime:(NSString *)time url:(NSURL *)url psw:(NSString *)psw;  // Play video at a certain time (seek进度)
- (NSTimeInterval)getVideoCurrentSecond;    // Current playback time (unit: second) (当前播放时间（单位：秒）)
- (NSTimeInterval)getVideoDuration;         // Duration (unit: second)   (时长（单位：秒）)
+ (BOOL)checkPasswordCorrectWithUrl:(NSURL *)url time:(NSString *)time password:(NSString *)password;//检测当前的密码是否匹配

@end

NS_ASSUME_NONNULL_END
