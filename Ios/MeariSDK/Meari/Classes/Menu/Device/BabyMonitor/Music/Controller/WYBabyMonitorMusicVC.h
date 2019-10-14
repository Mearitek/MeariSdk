//
//  WYBabyMonitorMusicVC.h
//  Meari
//
//  Created by 李兵 on 2017/3/13.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYBabyMonitorMusicVC : WYBaseSubVC
/** 音乐状态 **/
@property (nonatomic, strong)WYBabymonitorMusicStateModel *model;
/** 音量 **/
@property (nonatomic, assign)CGFloat volume;
/** 音乐播放模式 **/
@property (nonatomic, assign)WYBabymonitorMusicPlayMode playMode;

- (void)pauseMusic:(NSString *)musicID;
- (void)playMusic:(NSString *)musicID;
- (void)resumeMusic:(NSString *)musicID;
- (void)playNext;
- (void)playPrevious;

@end
