//
//  MRCloudPlayer.h
//  ppsplayer
//
//  Created by xjzhuo on 2022/3/2.
//  Copyright © 2022 ppstrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRCloudPlayer.h"

#import "MRPlayerDefine.h"
#import "apple_openglview.h"
#import "cameraplayer_define.h"

#import "MRCloudPlayerProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface MRMultiCloudPlayer : NSObject <MeariCloudPlayProtocol>

@property (nonatomic, assign, readonly) MeariCloudStatus playState; // play state (播放状态)
@property (nonatomic, assign, readonly) MeariCloudRecordState recordState; // record state(录制状态)

- (instancetype)initWithSuperView:(AppleOpenGLView *)superView videoID:(NSInteger)videoID superView:(AppleOpenGLView *)superView2 videoID2:(NSInteger)videoID2;
- (void)setEncryptedVersion:(NSInteger)version password:(NSString *)password;
- (void)setLocalPlay:(BOOL)local;
+ (int)transformMultiFileToLocalMp4:(NSString *)tsFile password:(NSString *)password streamID:(NSInteger)streamID filePath:(NSString *)mp4Path streamID2:(NSInteger )streamID2 filePath2:(NSString *)mp4Path2;

@end

NS_ASSUME_NONNULL_END
