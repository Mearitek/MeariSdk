//
//  WYCameraToolPreviewBabyView.h
//  Meari
//
//  Created by 李兵 on 2017/3/8.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WYCameraToolPreviewBabyTimebarType) {
    WYCameraToolPreviewBabyTimebarTypeTemperature = 1,
    WYCameraToolPreviewBabyTimebarTypeHumidity
};
@interface WYCameraToolPreviewBabyView : WYBaseView
@property (nonatomic, assign)CGFloat temperature;
@property (nonatomic, assign)CGFloat humidity;
+ (void)ajustedTemperature:(CGFloat *)temperature;
+ (void)ajustedHumidity:(CGFloat *)humidity;
- (void)showTError;
- (void)showRHError;
@end


@interface WYCameraToolPreviewBabyTimebarView : WYBaseView
@property (nonatomic, assign)WYCameraToolPreviewBabyTimebarType type;
@property (nonatomic, assign)CGFloat paramValue;

- (instancetype)initWithTimeBarImage:(UIImage *)timeBarImage frameImage:(UIImage *)frameImage;
- (void)showValue:(BOOL)show;
@end
