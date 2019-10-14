//
//  WYLoadingView.h
//  hud
//
//  Created by 李兵 on 2017/3/4.
//  Copyright © 2017年 李兵. All rights reserved.
//

#import "WYBaseView.h"

@interface WYLoadingView : WYBaseView
- (void)setCircleColor:(UIColor *)color;
- (void)showWithCircle;
- (void)showWithImage:(UIImage *)image;
- (void)dismiss;

@end
