//
//  WYCameraToolPlaybackAlarmMessageView.h
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYCameraToolPlaybackAlarmMessageView;
@protocol WYCameraToolPlaybackAlarmMessageViewDelegate <NSObject>
@optional
- (void)WYCameraToolPlaybackAlarmMessageView:(WYCameraToolPlaybackAlarmMessageView *)alarmMessageView didSelectedSecond:(int)second;
@end

@class WYCameraTime;
@interface WYCameraToolPlaybackAlarmMessageView: WYBaseView
@property (nonatomic, weak)id<WYCameraToolPlaybackAlarmMessageViewDelegate>delegate;
@property (nonatomic, strong) NSArray <WYCameraTime *>* alarmTimes;
@property (nonatomic, strong) NSArray <WYCameraTime *>* visitorTimes;
//复位
- (void)resetToNormal;
//高亮报警时刻
- (void)highlightAlarmMsgAtSecond:(int)second;
//高亮
- (void)setAlarmMsgCanHighlighted:(BOOL)canHighlighted;
@end

@class WYCameraToolPlaybackAlarmMessageModel;
@interface WYCameraToolPlaybackAlarmMessageCell : UICollectionViewCell
@property (nonatomic, strong)WYCameraToolPlaybackAlarmMessageModel *model;
@end


@interface WYCameraToolPlaybackAlarmMessageModel : NSObject
@property (nonatomic, strong)WYCameraTime *time;
@property (assign, nonatomic)BOOL selected;
@property (assign, nonatomic)BOOL babyMonitor;
@property (assign, nonatomic)BOOL visitor;
@end
