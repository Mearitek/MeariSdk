//
//  MRCloudPlayer.h
//  ppsplayer
//
//  Created by xjzhuo on 2022/3/2.
//  Copyright © 2022 ppstrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MRCloudPlayerProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface MRCloudPlayer : NSObject <MeariCloudPlayProtocol>

/**
 初始化

 @param url video url (地址)
 @param startTime start time (开始时间)
 @param superView super view (父视图)
 @return MeariPlayer
 */
- (instancetype)initWithURL:(NSURL *)url startTime:(NSString *)startTime superView:(UIView *)superView psw:(NSArray *)pswArr isVideoFirst:(BOOL)isVideoFirst;

@property (nonatomic, assign, readonly) MeariCloudStatus playState; // play state (播放状态)
@property (nonatomic, assign, readonly) MeariCloudRecordState recordState; // record state(录制状态)
@property (nonatomic, assign) BOOL muted; // mute (是否静音)

//下载m3u8 转为ts文件
//会堵塞当前线程
+ (int)downloadUrlToTsFile:(NSURL *)url password:(NSString *)password filePath:(NSString *)localPath;
+ (int)downloadVoiceBellUrlToTsFile:(NSURL *)url password:(NSString *)password filePath:(NSString *)localPath;
//检验url中的密码是否匹配 取一个Ts的url即可
+ (BOOL)checkEncryKey:(NSString *)file password:(NSString *)password;

+ (int)transformTsToMp4:(NSString *)tsFile filePath:(NSString *)mp4Path;

///  根据帧数 绘制生成对应的图片
/// @param filePath 视频文件路径
/// @param index 帧数
/// @param rectArray rectArray中为CGRect的NSValue 类型
/// @param colors 颜色数组 默认为红色
/// @param imagePath 输出图片路径
+ (int)creatDrawRectangleImageWith:(NSString *)filePath frameIndex:(int)index rectangleArray:(NSArray <NSValue *>*)rectArray colors:(NSArray <UIColor *>*)colors imagePath:(NSString *)imagePath;

+ (int)transformH264ToVideo:(NSString *)sourceVideo audioPath:(NSString *)sourceAudio password:(NSString *)password filePath:(NSString *)targetPath;
+ (int)captureFirstFrameWithMP4:(NSString *)mp4Path jpgPath:(NSString *)imgPath;
@end

NS_ASSUME_NONNULL_END
