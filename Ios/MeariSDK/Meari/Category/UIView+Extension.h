//
//  UIView+Extension.h
//  Meari
//
//  Created by 李兵 on 15/11/29.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WYRedDotPosition) {
    WYRedDotPositionTopRight,
    WYRedDotPositionMiddleRight,
    WYRedDotPositionBottomeRight
};

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat radius;
- (BOOL)containsRectOfView:(UIView *)view;
@end


@interface UIView (GestureRecognize)
- (void)addTapGestureTarget:(id)target action:(SEL)action;
- (void)addDoubleTapGestureTarget:(id)target action:(SEL)action;    
- (void)addPanGestureTarget:(id)target action:(SEL)action;
- (void)addSwipeGesture:(UISwipeGestureRecognizerDirection)direction target:(id)target action:(SEL)action;
- (void)addPinchGestureTarget:(id)target action:(SEL)action;
- (void)addLongPressGestureTarget:(id)target action:(SEL)action;

@end


@interface UIView (SubView)
+ (instancetype)redDotView;
- (void)addRedDotViewAtCorner:(WYRedDotPosition)position;
- (void)addRedDotView;
- (void)addLineViewAtBottom;
- (void)addLineViewAtTop;

@end

@interface UIView (WYAnimation)
- (void)wy_animationByAlphaWithDuration:(CGFloat)duration show:(BOOL)show;
@end

@interface UIView (WYUtilities)
- (UIImage *)wy_snapshotImage;
@end

