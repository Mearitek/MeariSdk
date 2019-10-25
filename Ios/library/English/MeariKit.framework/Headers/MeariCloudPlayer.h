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
 play state
 
 - MeariCloudStatusNone: none
 - MeariCloudStatusPreparing: prepare play
 - MeariCloudStatusStarted: start play
 - MeariCloudStatusPaused: pause play
 - MeariCloudStatusStopped: stop plat
 - MeariCloudStatusInterrupted: play interrupt
 - MeariCloudStatusError: play error
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
 record state
 
 - MeariCloudRecordStateNone: none
 - MeariCloudRecordStateStarted: start record
 - MeariCloudRecordStateStopped: stop record
 */
typedef NS_ENUM (NSInteger, MeariCloudRecordState) {
    MeariCloudRecordStateNone,
    MeariCloudRecordStateStarted,
    MeariCloudRecordStateStopped
};

@protocol meariCloudDelegate <NSObject>
@optional
- (void)meariCloudVCDidSnapedToPath:(NSString *)path;  // Successful screenshot
- (void)meariCloudVCDidRecordedToPath:(NSString *)path; // Successful record

- (void)meariCloudVCDidStartedPlay; // start play
- (void)meariCloudVCDidPausedPlay; // stop play
- (void)meariCloudVCDidStopedPlayNormally; // stop plat
- (void)meariCloudVCDidStopedPlayAbnormally; // play error

@end

@interface MeariCloudPlayer : NSObject

/**
 init
 @param url : video url
 @param startTime : start time
 @param superView : super view
 @return MeariPlayer
 */
- (instancetype)initWithURL:(NSURL *)url startTime:(NSString *)startTime superView:(UIView *)superView;

@property (atomic, strong, readonly) id<IJKMediaPlayback> meariPlayer; // player
@property (nonatomic, weak) id<meariCloudDelegate> delegate; // delegate
@property (nonatomic, assign, readonly) MeariCloudStatus playState; // play state
@property (nonatomic, assign, readonly) MeariCloudRecordState recordState; // record state

@property (nonatomic, assign, readonly, getter = isPlaying) BOOL playing; // Whether it is playing
@property (nonatomic, assign) BOOL muted; // mute

- (BOOL)snapToPath:(NSString *)path; // Screenshot, path : save path
- (BOOL)startRecord:(NSString *)path;  // Record, path : save path
- (void)stopRecord; //End recording
- (void)play; // start play
- (void)stop; // stop play
- (void)pause; // pause
- (void)shutdown; // Turn off playback
- (void)hidePlayer; // hide  player

- (void)playVideoAtTime:(NSString *)time url:(NSURL *)url;  // Play video at a certain time
- (NSTimeInterval)getVideoCurrentSecond;    // Current playback time (unit: second)
- (NSTimeInterval)getVideoDuration;         //Duration (unit: second)

@end

NS_ASSUME_NONNULL_END
