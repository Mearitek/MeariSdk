//
//  MRCloudPlayerProtocol.h
//  mrplayer
//
//  Created by pc on 2023/12/19.
//

#ifndef MRCloudPlayerProtocol_h
#define MRCloudPlayerProtocol_h

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

- (void)meariCloudVCDidSnapedToPath:(NSString *)path path2:(NSString *)path2;  // Screenshot successful (截图成功)
- (void)meariCloudVCDidRecordedToPath:(NSString *)path path2:(NSString *)path2; // record Successful (录制成功)

- (void)meariCloudVCDidStartedPlay; // start play (开始播放)
- (void)meariCloudVCDidPausedPlay; // stop play (暂停播放)
- (void)meariCloudVCDidStopedPlayNormally; // stop play (停止播放)
- (void)meariCloudVCDidStopedPlayAbnormally; // play error (播放错误)
- (void)meariCloudVCDidPlayEnd; // play error (播放结束)
- (void)meariCloudVCDidPlayPswError:(NSTimeInterval)t m3u8File:(NSURL *)m3u8; // play fail (播放密码错误)

@end

@protocol MeariCloudPlayProtocol <NSObject>

@property (nonatomic, weak) id<MeariCloudDelegate> delegate;

@property (nonatomic, assign, readonly, getter = isPlaying) BOOL playing; // Whether it is playing (是否正在播放)
@property (nonatomic, assign) BOOL muted; // mute (是否静音)
// 支持0到4的速度  默认为1
@property (nonatomic, assign) float speed; // 播放速率

- (void)stopRecord; //End recording (结束录制)
- (void)play; // start play (开始播放)
- (void)playWithPostion:(double)pos; //start play with postion (开始从第几秒开始播放)
- (void)stop; // stop play (停止播放)
- (void)pause; // pause (暂停)
- (void)resetPlayerComplete:(void(^)(void))complete; // Turn off playback (关闭播放)
- (void)hidePlayer; // hide  player (隐藏播放器)
- (void)playVideoAtTime:(NSString *)time url:(NSURL *)url psw:(NSArray *)pswArr;  // Play video at a certain time (seek进度)
- (NSTimeInterval)getVideoCurrentSecond;    // Current playback time (unit: second) (当前播放时间（单位：秒）)
- (NSTimeInterval)getVideoDuration;         // Duration (unit: second)   (时长（单位：秒）)
+ (BOOL)checkPasswordCorrectWithUrl:(NSURL *)url time:(NSString *)time password:(NSString *)password;//检测当前的密码是否匹配
- (void)seekTime:(double)time;

//检验url中的密码是否匹配 取一个Ts的url即可
+ (BOOL)checkEncryKey:(NSString *)file password:(NSString *)password;

+ (int)transformTsToMp4:(NSString *)tsFile filePath:(NSString *)mp4Path;

@optional

- (BOOL)snapToPath:(NSString *)path; // Screenshot path : save path (截图,保存路径)
- (BOOL)startRecord:(NSString *)path; // Record path : save path (录制,保存路径)

- (BOOL)multiSnapToPath:(NSString *)path path2:(NSString *)path2; // Screenshot path : save path (截图,保存路径)
- (BOOL)multiStartRecord:(NSString *)path path2:(NSString *)path2; // Record path : save path (录制,保存路径)

//下载m3u8 转为ts文件
+ (int)downloadVoiceBellUrlToTsFile:(NSURL *)url password:(NSString *)password filePath:(NSString *)localPath;
//会堵塞当前线程
+ (int)downloadUrlToTsFile:(NSURL *)url password:(NSString *)password filePath:(NSString *)localPath;

@end

#endif /* MRCloudPlayerProtocol_h */
