//
//  WYBabymonitorMusicStateModel.h
//  Meari
//
//  Created by 李兵 on 2017/3/16.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, WYBabymonitorMusicPlayMode) {
    WYBabymonitorMusicPlayModeRepeatOne = 1 << 0,
    WYBabymonitorMusicPlayModeRepeatAll = 1 << 1,
    WYBabymonitorMusicPlayModeRandom = 1 << 2,
    WYBabymonitorMusicPlayModeSingle = 1 << 3,
    WYBabymonitorMusicPlayModeDefault = WYBabymonitorMusicPlayModeSingle,
    WYBabymonitorMusicPlayModeSupport = WYBabymonitorMusicPlayModeRepeatAll | WYBabymonitorMusicPlayModeSingle,
    WYBabymonitorMusicPlayModeAll = WYBabymonitorMusicPlayModeRepeatOne | WYBabymonitorMusicPlayModeRepeatAll | WYBabymonitorMusicPlayModeRandom | WYBabymonitorMusicPlayModeSingle,
};

typedef NS_ENUM(NSInteger, WYBabyMonitorMusicStatus) {
    WYBabyMonitorMusicStatusPaused,
    WYBabyMonitorMusicStatusDownloading,
    WYBabyMonitorMusicStatusPlaying,
    WYBabyMonitorMusicStatusPlayingAndDownloading
};

@interface WYBabyMonitorMusicOneModel : NSObject
@property (nonatomic, assign)BOOL is_playing;
@property (nonatomic, copy)NSString *musicID;
@property (nonatomic, copy)NSString *musicName;
@property (nonatomic, assign)NSInteger download_percent;
@property (nonatomic, assign)WYBabyMonitorMusicStatus status;
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, assign)BOOL isLast;
@end

@interface WYBabymonitorMusicStateModel : NSObject

@property (nonatomic, assign)BOOL is_playing;
@property (nonatomic, copy)NSString *current_musicID;
@property (nonatomic, copy)NSString *mode;
@property (nonatomic, strong)NSArray <WYBabyMonitorMusicOneModel *>*play_list;


@property (nonatomic, assign)WYBabymonitorMusicPlayMode musicMode;
@property (nonatomic, strong)WYBabyMonitorMusicOneModel *currentModel;
@property (nonatomic, strong)WYBabyMonitorMusicOneModel *nextModel;
@property (nonatomic, strong)WYBabyMonitorMusicOneModel *prevModel;
@end


