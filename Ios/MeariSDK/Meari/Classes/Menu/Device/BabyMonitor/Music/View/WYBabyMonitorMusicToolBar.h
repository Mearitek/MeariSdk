//
//  WYBabyMonitorMusicToolBar.h
//  Meari
//
//  Created by 李兵 on 2017/3/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYBabyMonitorMusicToolBar;
@protocol WYBabyMonitorMusicToolBarDelegate <NSObject>
@optional
- (void)WYBabyMonitorMusicToolBar_Play:(WYBabyMonitorMusicToolBar *)toolbar musicID:(NSString *)musicID;
- (void)WYBabyMonitorMusicToolBar_Resume:(WYBabyMonitorMusicToolBar *)toolbar musicID:(NSString *)musicID;
- (void)WYBabyMonitorMusicToolBar_Pause:(WYBabyMonitorMusicToolBar *)toolbar musicID:(NSString *)musicID;
- (void)WYBabyMonitorMusicToolBar_PlayPrevSong:(WYBabyMonitorMusicToolBar *)toolbar;
- (void)WYBabyMonitorMusicToolBar_PlayNextSong:(WYBabyMonitorMusicToolBar *)toolbar;
- (void)WYBabyMonitorMusicToolBar_ChangeVolume:(WYBabyMonitorMusicToolBar *)toolbar volume:(NSInteger)volume;
@end

@interface WYBabyMonitorMusicToolBar: WYBaseView
@property (nonatomic, weak)id<WYBabyMonitorMusicToolBarDelegate>delegate;

@property (nonatomic, assign)BOOL playing;
/** 音乐状态 **/
@property (nonatomic, strong)WYBabymonitorMusicStateModel *model;
/** 音量 **/
@property (nonatomic, assign)CGFloat volume;
/** 音乐播放模式 **/
@property (nonatomic, assign)WYBabymonitorMusicPlayMode playMode;
/** 显示第一首歌 **/
- (void)setFirstMusicName:(NSString *)musicName musicID:(NSString *)musicID;
@end


