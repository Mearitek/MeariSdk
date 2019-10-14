//
//  UIScrollView+Extension.h
//  Meari
//
//  Created by 李兵 on 16/8/14.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extension)

@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat contentOffsetY;
- (void)setContentOffsetX:(CGFloat)contentOffsetX animated:(BOOL)animated;
- (void)setContentOffsetY:(CGFloat)contentOffsetY animated:(BOOL)animated;

@property (nonatomic, assign) CGFloat contentSizeWidth;
@property (nonatomic, assign) CGFloat contentSizeHeight;

@end
