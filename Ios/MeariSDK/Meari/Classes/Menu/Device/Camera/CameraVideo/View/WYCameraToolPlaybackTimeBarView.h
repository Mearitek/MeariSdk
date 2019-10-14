//
//  WYCameraToolPlaybackTimeBarView.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCameraToolPlaybackAlarmMessageView.h"
typedef NS_ENUM(NSInteger, WYCameraToolPlaybackTimeBarStytle) {
    WYCameraToolPlaybackTimeBarStytleNormal = 1,
    WYCameraToolPlaybackTimeBarStytleBig
    
};

@class WYCameraToolPlaybackTimeBarView;
@protocol WYCameraToolPlaybackTimeBarViewDelegate <NSObject>
@optional
- (void)beginToDragTimeBar:(WYCameraToolPlaybackTimeBarView *)timeBar;
- (void)endDraggingTimeBar:(WYCameraToolPlaybackTimeBarView *)timeBar toSecond:(int)second canPlay:(BOOL)canPlay;
@end

@interface WYCameraToolPlaybackTimeBarView: WYBaseView
@property (nonatomic, weak)id <WYCameraToolPlaybackTimeBarViewDelegate> delegate;
@property (nonatomic, weak)WYCameraToolPlaybackAlarmMessageView *alarmView;
@property (nonatomic, assign)CGFloat progress;

@property (nonatomic, strong) NSArray <WYCameraTime *>* videoTimes;
@property (nonatomic, strong) NSArray <WYCameraTime *>* alarmTimes;
@property (nonatomic, strong) NSArray <WYCameraTime *>* visitorTimes;

- (BOOL)hasVideoAtSecond:(int)second;   //该点是否有视频
- (NSDateComponents *)latestVideoTimeNearTime:(NSDateComponents *)videoTime;//最近的视频点
- (NSDateComponents *)startTimeInHalfHourFragment:(NSString *)halfHourFragmentString;
- (BOOL)hasNewVideoAfterTime:(NSDateComponents *)videoTime;
- (void)resetToNormal;
- (void)autoShowAndDismissTimeLabel;
- (void)autoShowAndDismissTimeLabelWithSecond:(int)second;
@end

#pragma mark - cell
@interface WYCameraToolPlaybackTimeBarCell : UICollectionViewCell
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, assign)WYCameraToolPlaybackTimeBarStytle stytle;
@end


#pragma mark - blueView
@interface WYCameraToolPlaybackTimeBarBlueView: WYBaseView
@property (nonatomic, strong) NSArray <WYCameraTime *>* videoTimes;
@property (nonatomic, strong)UIImage *timebarImage;
@end


#pragma mark - redView
@interface WYCameraToolPlaybackTimeBarAlarmZoneView: WYBaseView
@property (nonatomic, strong) NSArray <WYCameraTime *>* alarmTimes;
@property (nonatomic, strong) NSArray <WYCameraTime *>* videoTimes;
@property (nonatomic, strong) NSArray <WYCameraTime *>* visitorTimes;
@end




