//
//  WYCameraLoadingView+Add.h
//  Meari
//
//  Created by 李兵 on 2017/3/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraLoadingView.h"

@interface WYCameraLoadingView (Add)
- (void)showEmpty;
- (void)showLoading;
- (void)showFailed;
- (void)showSuccess;
- (void)showSleepmodeLensOffWithStytle:(WYUIStytle)stytle;
- (void)showSleepmodeLensOffByTimeWithStytle:(WYUIStytle)stytle;
@end
