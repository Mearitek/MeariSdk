//
//  WYCameraToolPlaybackPictureBarView.h
//  Meari
//
//  Created by FMG on 2017/11/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WYCameraPlayBackPictureBarStatus) {
    WYCameraPlayBackPictureBarStatus_connect,
    WYCameraPlayBackPictureBarStatus_request,
    WYCameraPlayBackPictureBarStatus_noData,
    WYCameraPlayBackPictureBarStatus_failure
};
@class WYCameraToolPlaybackAlarmMessageView,WYCameraToolPlaybackPictureBarView;

@protocol WYCameraToolPlaybackPictureBarViewDelegate <NSObject>
@optional
- (void)cameraToolPlaybackPictureBarView:(WYCameraToolPlaybackPictureBarView*)pictureBarView didSelectedSecond:(int)second;;
@end

@interface WYCameraToolPlaybackPictureBarView : UIView
@property (nonatomic,   weak) id<WYCameraToolPlaybackPictureBarViewDelegate>delegate;
@property (nonatomic, strong) NSArray <WYCameraTime *>* videoTimes;
@property (nonatomic, strong) NSArray <WYCameraTime *>* alarmTimes;
@property (nonatomic, strong) NSArray <WYCameraTime *>* visitorTimes;

- (void)playbackWithComponents:(NSDateComponents*)currentComponents;
- (NSDateComponents *)latestVideoTimeNearTime:(NSDateComponents *)videoTime;
- (void)showStatus:(WYCameraPlayBackPictureBarStatus)status;
- (void)highlightAlarmMsgAtSecond:(int)second;
@end

@interface WYCameraToolPlaybackPictureBar : NSObject
@property (nonatomic, assign) WYCameraTime *alarmTime;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy)NSString *pictureName;
@end

#pragma mark - cell
@interface WYCameraToolPlaybackPictureBarCell : UICollectionViewCell
@property (nonatomic, strong) WYCameraToolPlaybackPictureBar * pictureModel;
@property (nonatomic, assign) BOOL itemSelected;
@end
