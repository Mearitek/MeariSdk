//
//  WYCameraLoadingView.h
//  Meari
//
//  Created by 李兵 on 2016/11/30.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WYCameraLoadingStatus) {
    WYCameraLoadingStatusLoading = 1,
    WYCameraLoadingStatusFailed,
    WYCameraLoadingStatusSuccessfull,
    WYCameraLoadingStatusEmpty
};

@class WYCameraLoadingView;
@protocol WYCameraLoadingViewDelegate <NSObject>
- (void)WYCameraLoadingViewDidLoading:(WYCameraLoadingView *)loadingView;
@end

@interface WYCameraLoadingView : UIView
@property (nonatomic, weak)id<WYCameraLoadingViewDelegate>delegate;
@property (nonatomic, assign)WYCameraLoadingStatus loadingStatus;
@property (nonatomic, assign)BOOL showLoadingText;
@property (nonatomic, strong)UIImage *loadingImage;
- (void)showText:(NSString *)text stytle:(WYUIStytle)stytle;

@end
