//
//  UIScrollView+Extension.m
//  Meari
//
//  Created by 李兵 on 16/8/14.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)
- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    CGPoint point = self.contentOffset;
    point.x = contentOffsetX;
    self.contentOffset = point;
}
- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    CGPoint point = self.contentOffset;
    point.y = contentOffsetY;
    self.contentOffset = point;
}
- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}
- (void)setContentOffsetX:(CGFloat)contentOffsetX animated:(BOOL)animated {
    CGPoint point = self.contentOffset;
    point.x = contentOffsetX;
    [self setContentOffset:point animated:animated];
}
- (void)setContentOffsetY:(CGFloat)contentOffsetY animated:(BOOL)animated {
    CGPoint point = self.contentOffset;
    point.y = contentOffsetY;
    [self setContentOffset:point animated:animated];
}



- (void)setContentSizeWidth:(CGFloat)contentSizeWidth {
    CGSize size = self.contentSize;
    size.width = contentSizeWidth;
    self.contentSize = size;
}
- (CGFloat)contentSizeWidth {
    return self.contentSize.width;
}

- (void)setContentSizeHeight:(CGFloat)contentSizeHeight {
    CGSize size = self.contentSize;
    size.height = contentSizeHeight;
    self.contentSize = size;
}
- (CGFloat)contentSizeHeight {
    return self.contentSize.height;
}


@end
