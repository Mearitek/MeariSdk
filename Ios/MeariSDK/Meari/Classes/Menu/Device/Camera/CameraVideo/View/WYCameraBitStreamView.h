//
//  WYBitStreamView.h
//  Meari
//
//  Created by FMG on 2017/7/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WYCameraBitStreamView;
@protocol WYCameraBitStreamViewDelegate <NSObject>

@optional
- (void)bitStreamView:(WYCameraBitStreamView *)view didSelectedStreamType:(WYVideoType)videoType;

@end

@interface WYCameraBitStreamView : UIView
@property (nonatomic, weak) id<WYCameraBitStreamViewDelegate> delegate;
@property (nonatomic, assign) WYVideoType videoType;


+ (instancetype)instanceBitStreamView;
@end
