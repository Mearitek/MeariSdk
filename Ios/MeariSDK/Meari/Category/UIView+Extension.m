
//
//  UIView+Extension.m
//  Meari
//
//  Created by 李兵 on 15/11/29.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}
- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size{
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint newCenter = self.center;
    newCenter.x = centerX;
    self.center = newCenter;
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint newCenter = self.center;
    newCenter.y = centerY;
    self.center = newCenter;
}
- (CGFloat)centerY {
    return self.center.y;
}

- (void)setMaxX:(CGFloat)maxX {
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}
- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY {
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}
- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setMinX:(CGFloat)minX {
    CGRect frame = self.frame;
    frame.origin.x = minX;
    self.frame = frame;
}
- (CGFloat)minX {
    return CGRectGetMinX(self.frame);
}

- (void)setMinY:(CGFloat)minY {
    CGRect frame = self.frame;
    frame.origin.y = minY;
    self.frame = frame;
}
- (CGFloat)minY {
    return CGRectGetMinY(self.frame);
}

- (void)setRadius:(CGFloat)radius {
    if (!self.layer.masksToBounds) {
        self.layer.masksToBounds = YES;
    }
    if (self.layer.cornerRadius != radius) {
        self.layer.cornerRadius = radius;
    }
}
- (CGFloat)radius {
    return self.layer.cornerRadius;
}

- (BOOL)containsRectOfView:(UIView *)view {
    return CGRectContainsRect([self convertRect:self.bounds toView:WY_KeyWindow],
                              [view convertRect:view.bounds toView:WY_KeyWindow]);
}
@end


@implementation UIView (GestureRecognize)
- (void)addTapGestureTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapG];
}
- (void)addDoubleTapGestureTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapG.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapG];
}
- (void)addPanGestureTarget:(id)target action:(SEL)action {
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:action];
    [self addGestureRecognizer:panG];
}
- (void)addSwipeGesture:(UISwipeGestureRecognizerDirection)direction target:(id)target action:(SEL)action {
    UISwipeGestureRecognizer *swipeG = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    swipeG.cancelsTouchesInView = NO;
    swipeG.direction = direction;
    [self addGestureRecognizer:swipeG];
}
- (void)addPinchGestureTarget:(id)target action:(SEL)action {
    UIPinchGestureRecognizer *pinchG = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:action];
    pinchG.cancelsTouchesInView = NO;
    [self addGestureRecognizer:pinchG];
}
- (void)addLongPressGestureTarget:(id)target action:(SEL)action {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    longPress.minimumPressDuration = 0.8;
    [self addGestureRecognizer:longPress];
}

@end

@implementation UIView (SubView)
+ (instancetype)redDotView {
    UIImageView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.size = CGSizeMake(8, 8);
    view.layer.cornerRadius = view.width/2;
    view.layer.masksToBounds = YES;
    return view;
}
- (void)addRedDotViewAtCorner:(WYRedDotPosition)position {
    UIView *redDot = [UIView redDotView];
    switch (position) {
        case WYRedDotPositionTopRight: {
            redDot.x = self.width+3;
            redDot.y = 0;
            break;
        }
        case WYRedDotPositionMiddleRight: {
            redDot.x = self.width;
            redDot.y = self.height/2;
            break;
        }
        case WYRedDotPositionBottomeRight: {
            redDot.x = self.width;
            redDot.y = self.height - redDot.height;
            break;
        }
    }
    
    [self addSubview:redDot];
}
- (void)addRedDotView {
    [self addRedDotViewAtCorner:WYRedDotPositionTopRight];
}
- (void)addLineViewAtBottom {
    UIImageView *line = [UIImageView new];
    line.backgroundColor = WY_LineColor_LightGray;
    [self addSubview:line];
    WY_WeakSelf
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(WY_1_PIXEL));
        make.width.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
    }];
}
- (void)addLineViewAtTop {
    UIImageView *line = [UIImageView new];
    line.backgroundColor = WY_LineColor_LightGray;
    [self addSubview:line];
    WY_WeakSelf
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(WY_1_PIXEL));
        make.width.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
    }];
}

@end

@implementation UIView (WYAnimation)
- (void)wy_animationByAlphaWithDuration:(CGFloat)duration show:(BOOL)show {
    if (show) {
        self.hidden = NO;
        self.alpha = 0;
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.hidden = NO;
        }];
    }else {
        self.hidden = NO;
        self.alpha = 1;
        [UIView animateWithDuration:duration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

@end

@implementation UIView (WYUtilities)
- (UIImage *)wy_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
