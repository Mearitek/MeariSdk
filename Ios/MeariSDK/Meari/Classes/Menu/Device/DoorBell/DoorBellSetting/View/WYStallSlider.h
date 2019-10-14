//
//  WYStallSlider.h
//  Meari
//
//  Created by FMG on 2017/7/27.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYStallSlider;
@protocol wyStallSliderDelegate <NSObject>

@optional
- (void)stallSlider:(WYStallSlider*)slider didSelectedStall:(NSInteger)stall;

@end

@interface WYStallSlider : UISlider
@property (nonatomic, weak) id<wyStallSliderDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame stallNum:(NSInteger)stallNum selectedStall:(NSInteger)selectedStall;

@end
