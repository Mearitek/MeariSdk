//
//  WYDoorBellSettingJingleBellView.h
//  Meari
//
//  Created by FMG on 2017/7/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BellSliderValue)(NSInteger value);

@interface WYDoorBellSettingJingleBellView : UIView
@property (nonatomic, copy) NSString *bellTitle;
@property (nonatomic, copy) BellSliderValue bellVlaue;


- (instancetype)initWithFrame:(CGRect)frame sliderStallNum:(NSInteger)sliderStallNum stallDestription:(NSArray *)stallDest selectedStall:(NSInteger)selectedStall;
- (void)setSliderColor:(UIColor *)sliderColor stallColor:(UIColor *)stallColor;

@end
