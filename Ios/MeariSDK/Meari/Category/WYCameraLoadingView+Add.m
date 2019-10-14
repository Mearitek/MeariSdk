//
//  WYCameraLoadingView+Add.m
//  Meari
//
//  Created by 李兵 on 2017/3/22.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraLoadingView+Add.h"

@implementation WYCameraLoadingView (Add)
- (void)showEmpty {
    self.loadingStatus = WYCameraLoadingStatusEmpty;
}
- (void)showLoading {
    self.loadingStatus = WYCameraLoadingStatusLoading;
}
- (void)showFailed {
    self.loadingStatus = WYCameraLoadingStatusFailed;
}
- (void)showSuccess {
    self.loadingStatus = WYCameraLoadingStatusSuccessfull;
}
- (void)showSleepmodeLensOffWithStytle:(WYUIStytle)stytle {
    [self showText:WYLocalString(@"des_sleepmodeLensOff") stytle:stytle];
}
- (void)showSleepmodeLensOffByTimeWithStytle:(WYUIStytle)stytle {
    [self showText:WYLocalString(@"des_sleepmodeLensOffByTime") stytle:stytle];
}



@end
