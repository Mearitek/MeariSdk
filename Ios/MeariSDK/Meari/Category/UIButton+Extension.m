//
//  UIButton+Extension.m
//  Meari
//
//  Created by 李兵 on 15/11/30.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@implementation UIButton (Extension)
/** title **/
- (NSString *)wy_normalTitle {
    return [self titleForState:UIControlStateNormal];
}
- (void)setWy_normalTitle:(NSString *)wy_normalTitle {
    [self setTitle:wy_normalTitle forState:UIControlStateNormal];
}
- (NSString *)wy_highlightedTitle {
    return [self titleForState:UIControlStateHighlighted];
}
- (void)setWy_highlightedTitle:(NSString *)wy_highlightedTitle {
    [self setTitle:wy_highlightedTitle forState:UIControlStateHighlighted];
}
- (NSString *)wy_disabledTitle {
    return [self titleForState:UIControlStateDisabled];
}
- (void)setWy_disabledTitle:(NSString *)wy_disabledTitle {
    [self setTitle:wy_disabledTitle forState:UIControlStateDisabled];
}
- (NSString *)wy_selectedTitle {
    return [self titleForState:UIControlStateSelected];
}
- (void)setWy_selectedTitle:(NSString *)wy_selectedTitle {
    [self setTitle:wy_selectedTitle forState:UIControlStateSelected];
}
/** color **/
- (UIColor *)wy_normalTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}
- (void)setWy_normalTitleColor:(UIColor *)wy_normalTitleColor {
    [self setTitleColor:wy_normalTitleColor forState:UIControlStateNormal];
}
- (UIColor *)wy_highlightedTitleColor {
    return [self titleColorForState:UIControlStateHighlighted];
}
- (void)setWy_highlightedTitleColor:(UIColor *)wy_highlightedTitleColor {
    [self setTitleColor:wy_highlightedTitleColor forState:UIControlStateHighlighted];
}
- (UIColor *)wy_disabledTitleColor {
    return [self titleColorForState:UIControlStateDisabled];
}
- (void)setWy_disabledTitleColor:(UIColor *)wy_disabledTitleColor {
    [self setTitleColor:wy_disabledTitleColor forState:UIControlStateDisabled];
}
- (UIColor *)wy_selectedTitleColor {
    return [self titleColorForState:UIControlStateSelected];
}
- (void)setWy_selectedTitleColor:(UIColor *)wy_selectedTitleColor {
    [self setTitleColor:wy_selectedTitleColor forState:UIControlStateSelected];
}
/** image **/
- (UIImage *)wy_normalImage {
    return [self imageForState:UIControlStateNormal];
}
- (void)setWy_normalImage:(UIImage *)wy_normalImage {
    [self setImage:wy_normalImage forState:UIControlStateNormal];
}
- (UIImage *)wy_highlightedImage {
    return [self imageForState:UIControlStateHighlighted];
}
- (void)setWy_highlightedImage:(UIImage *)wy_highlightedImage {
    [self setImage:wy_highlightedImage forState:UIControlStateHighlighted];
}
- (UIImage *)wy_disabledImage {
    return [self imageForState:UIControlStateDisabled];
}
- (void)setWy_disabledImage:(UIImage *)wy_disabledImage {
    [self setImage:wy_disabledImage forState:UIControlStateDisabled];
}
- (UIImage *)wy_selectedImage {
    return [self imageForState:UIControlStateSelected];
}
- (void)setWy_selectedImage:(UIImage *)wy_selectedImage {
    [self setImage:wy_selectedImage forState:UIControlStateSelected];
}
/** backgroundImage **/
- (UIImage *)wy_normalBGImage {
    return [self imageForState:UIControlStateNormal];
}
- (void)setWy_normalBGImage:(UIImage *)wy_normalBGImage {
    [self setBackgroundImage:wy_normalBGImage forState:UIControlStateNormal];
}
- (UIImage *)wy_highlightedBGImage {
    return [self imageForState:UIControlStateHighlighted];
}
- (void)setWy_highlightedBGImage:(UIImage *)wy_highlightedBGImage {
    [self setBackgroundImage:wy_highlightedBGImage forState:UIControlStateHighlighted];
}
- (UIImage *)wy_disabledBGImage {
    return [self imageForState:UIControlStateDisabled];
}
- (void)setWy_disabledBGImage:(UIImage *)wy_disabledBGImage {
    [self setBackgroundImage:wy_disabledBGImage forState:UIControlStateDisabled];
}
- (UIImage *)wy_selectedBGImage {
    return [self imageForState:UIControlStateSelected];
}
- (void)setWy_selectedBGImage:(UIImage *)wy_selectedBGImage {
    [self setBackgroundImage:wy_selectedBGImage forState:UIControlStateSelected];
}
/** font **/
- (UIFont *)wy_titleFont {
    return self.titleLabel.font;
}
- (void)setWy_titleFont:(UIFont *)wy_titleFont {
    self.titleLabel.font = wy_titleFont;
}
/** insets **/
- (CGFloat)wy_insetTop {
    return self.imageEdgeInsets.top;
}
- (void)setWy_insetTop:(CGFloat)wy_insetTop {
    UIEdgeInsets insets = self.imageEdgeInsets;
    insets.top = wy_insetTop;
    self.imageEdgeInsets = insets;
}
- (CGFloat)wy_insetLeft {
    return self.imageEdgeInsets.left;
}
- (void)setWy_insetLeft:(CGFloat)wy_insetLeft {
    UIEdgeInsets insets = self.imageEdgeInsets;
    insets.left = wy_insetLeft;
    self.imageEdgeInsets = insets;
}
- (CGFloat)wy_insetBottom {
    return self.imageEdgeInsets.left;
}
- (void)setWy_insetBottom:(CGFloat)wy_insetBottom {
    UIEdgeInsets insets = self.imageEdgeInsets;
    insets.left = wy_insetBottom;
    self.imageEdgeInsets = insets;
}
- (CGFloat)wy_insetRight {
    return self.imageEdgeInsets.right;
}
- (void)setWy_insetRight:(CGFloat)wy_insetRight {
    UIEdgeInsets insets = self.imageEdgeInsets;
    insets.right = wy_insetRight;
    self.imageEdgeInsets = insets;
}
/** action **/
- (void)wy_addTarget:(id)target actionDown:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}
- (void)wy_addTarget:(id)target actionUpInside:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (void)wy_addTarget:(id)target actionUpOutside:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventTouchUpOutside];
}
- (void)wy_addTarget:(id)target actionDragInside:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventTouchDragInside];
}
- (void)wy_addTarget:(id)target actionDragOutside:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventTouchDragOutside];
}
- (void)wy_addTarget:(id)target actionCancel:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventTouchCancel];
}
- (void)wy_addTarget:(id)target actionValueChanged:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}
- (void)wy_addTarget:(id)target actionEditingDidBegin:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventEditingDidBegin];
}
- (void)wy_addTarget:(id)target actionEditingChanged:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventEditingChanged];
}
- (void)wy_addTarget:(id)target actionEditingDidEnd:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventEditingDidEnd];
}
- (void)wy_addTarget:(id)target actionEditingDidEndOnExit:(SEL)action {
    [self wy_addTarget:target action:action forControlEvents:UIControlEventEditingDidEndOnExit];
}
- (void)wy_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (target && action) {
        [self addTarget:target action:action forControlEvents:controlEvents];
    }
}
/** instance **/
+ (instancetype)wy_button {
    return [UIButton buttonWithType:UIButtonTypeCustom];
}


/**
 *  背景图片：正常
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
        normalBackgroundImage:(UIImage *)normalBackgroundImage
                       target:(id)target
                       action:(SEL)action {
    
    return [self buttonWithFrame:frame
           normalBackgroundImage:normalBackgroundImage
      highlightedBackgroundImage:nil
         selectedBackgroundImage:nil
                          target:target
                          action:action];
}



/**
 *  图片：正常
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
                       target:(id)target
                       action:(SEL)action {
    
    return [self buttonWithFrame:frame
                     normalImage:normalImage
                highlightedImage:nil
                   selectedImage:nil
                          target:target
                          action:action];
}

/**
 *  图片：正常＋选中
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
                       target:(id)target
                       action:(SEL)action {
    
    return [self buttonWithFrame:frame
                     normalImage:normalImage
                highlightedImage:nil
                   selectedImage:selectedImage
                          target:target
                          action:action];
}






/**
 *  图片：正常＋高亮
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                       target:(id)target
                       action:(SEL)action {
    
    return [self buttonWithFrame:frame
                     normalImage:normalImage
                highlightedImage:highlightedImage
                   selectedImage:nil
                          target:target
                          action:action];
}

/**
 默认填充绿按钮
 */
+ (UIButton *)defaultGreenFillButtonWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithFrame:CGRectZero
                        normalBackgroundImage:[UIImage bgGreenImage]
                                       target:target
                                       action:action];
    btn.titleLabel.font = WYFont_Text_M_Normal;
    return btn;
}
/**
 默认边框绿按钮
 */
+ (UIButton *)defaultGreenBounderButtonWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor = WY_MainColor.CGColor;
    btn.layer.borderWidth = 1;
    [btn setTitleColor:WY_MainColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9 alpha:0.5]] forState:UIControlStateHighlighted];
    btn.titleLabel.font = WYFont_Text_M_Normal;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+ (instancetype)wy_buttonWithStytle:(WYButtonStytle)stytle target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton wy_button];
    btn.titleLabel.font = WYFont_Text_M_Normal;
    switch (stytle) {
        case WYButtonStytleFilledGreenAndWhiteTitle: {
            btn.wy_normalTitleColor = [UIColor whiteColor];
            btn.wy_normalBGImage = [UIImage bgGreenImage];
            break;
        }
        case WYButtonStytleFilledWhiteAndGreenTitle: {
            btn.wy_normalTitleColor = WY_FontColor_Cyan;
            btn.wy_highlightedTitleColor = [UIColor whiteColor];
            btn.wy_normalBGImage = [UIImage imageWithColor:[UIColor whiteColor]];
            btn.wy_highlightedBGImage = [UIImage bgGreenImage];
            break;
        }
        default:
            break;
    }
    btn.wy_disabledTitleColor = WY_FontColor_Gray;
    btn.wy_disabledBGImage = [UIImage imageWithColor:[UIColor whiteColor]];
    if (target && action) {
        [btn wy_addTarget:target actionUpInside:action];
    }
    return btn;
}

#pragma mark - 私有
/**
 *  button : 仅文字r
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalTitle:(NSString *)normalTitle
                  normalColor:(UIColor *)normalColor
              higlightedTitle:(NSString *)higlightedTitle
              higlightedColor:(UIColor *)higlightedColor
                selectedTitle:(NSString *)selectedTitle
                selectedColor:(UIColor *)selectedColor
                       target:(id)target
                       action:(SEL)action {
    return [self buttonWithFrame:frame
                     normalTitle:normalTitle
                     normalColor:normalColor
                 higlightedTitle:higlightedTitle
                 higlightedColor:higlightedColor
                   selectedTitle:selectedTitle
                   selectedColor:selectedColor
                     normalImage:nil
                highlightedImage:nil
                   selectedImage:nil
           normalBackgroundImage:nil
      highlightedBackgroundImage:nil
         selectedBackgroundImage:nil
                          target:target
                          action:action];
}
/**
 *  button : 仅前景图片
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                selectedImage:(UIImage *)selectedImage
                       target:(id)target
                       action:(SEL)action {
    return [self buttonWithFrame:frame
                     normalTitle:nil
                     normalColor:nil
                 higlightedTitle:nil
                 higlightedColor:nil
                   selectedTitle:nil
                   selectedColor:nil
                     normalImage:normalImage
                highlightedImage:highlightedImage
                   selectedImage:selectedImage
           normalBackgroundImage:nil
      highlightedBackgroundImage:nil
         selectedBackgroundImage:nil
                          target:target
                          action:action];
}




/**
 *  button : 仅背景图片
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
        normalBackgroundImage:(UIImage *)normalBackgroundImage
   highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
      selectedBackgroundImage:(UIImage *)selectedBackgroundImage
                       target:(id)target
                       action:(SEL)action {
    return [self buttonWithFrame:frame
                     normalTitle:nil
                     normalColor:nil
                 higlightedTitle:nil
                 higlightedColor:nil
                   selectedTitle:nil
                   selectedColor:nil
                     normalImage:nil
                highlightedImage:nil
                   selectedImage:nil
           normalBackgroundImage:normalBackgroundImage
      highlightedBackgroundImage:highlightedBackgroundImage
         selectedBackgroundImage:selectedBackgroundImage
                          target:target
                          action:action];
}




/**
 *  全能方法
 *
 *  @param frame                      大小
 *  @param normalTitle                标题：正常
 *  @param normalColor                标题颜色：正常
 *  @param higlightedTitle            标题：高亮
 *  @param higlightedColor            标题颜色：高亮
 *  @param selectedTitle              标题：选中
 *  @param selectedColor              标题颜色：选中
 *  @param normalImage                图片：正常
 *  @param highlightedImage           图片：高亮
 *  @param selectedImage              图片：选中
 *  @param normalBackgroundImage      背景图片：正常
 *  @param highlightedBackgroundImage 背景图片：高亮
 *  @param selectedBackgroundImage    背景图片：选中
 *  @param target                     目标
 *  @param action                     行为
 *
 *  @return
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalTitle:(NSString *)normalTitle
                  normalColor:(UIColor *)normalColor
              higlightedTitle:(NSString *)higlightedTitle
              higlightedColor:(UIColor *)higlightedColor
                selectedTitle:(NSString *)selectedTitle
                selectedColor:(UIColor *)selectedColor
                  normalImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                selectedImage:(UIImage *)selectedImage
        normalBackgroundImage:(UIImage *)normalBackgroundImage
   highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
      selectedBackgroundImage:(UIImage *)selectedBackgroundImage
                       target:(id)target
                       action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    
    // 标题
    if (normalTitle) {
        [btn setTitle:normalTitle forState:UIControlStateNormal];
    }
    if (normalColor) {
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (higlightedTitle) {
        [btn setTitle:higlightedTitle forState:UIControlStateHighlighted];
    }
    if (higlightedColor) {
        [btn setTitleColor:higlightedColor forState:UIControlStateHighlighted];
    }
    if (selectedTitle) {
        [btn setTitle:selectedTitle forState:UIControlStateSelected];
    }
    if (selectedColor) {
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    if (normalTitle) {
        [btn setTitle:normalTitle forState:UIControlStateNormal];
    }
    
    // 前图
    if (normalImage) {
        [btn setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (selectedImage) {
        [btn setImage:selectedImage forState:UIControlStateSelected];
    }
    
    // 背景图
    if (normalBackgroundImage) {
        [btn setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    }
    if (highlightedBackgroundImage) {
        [btn setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    }
    if (selectedBackgroundImage) {
        [btn setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    }
    
    // 任务
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

@end

static CAShapeLayer *rippleLayer;
static NSTimer *rippleTimer;
@implementation UIButton (Animation)
- (void)showZoomAnimation {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:nil];
}
- (void)hideZoomAnimation {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}
- (void)showRippleAnimation {
    rippleTimer = [NSTimer timerInLoopWithInterval:.8 target:self selector:@selector(addRippleLayer)];
}
- (void)addRippleLayer {
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.position = CGPointMake(-(self.x - self.width/2), -(self.y - self.height/2.0));
    rippleLayer.bounds = self.bounds;
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    rippleLayer = rippleLayer;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.width, self.height)];
    rippleLayer.path = path.CGPath;
    rippleLayer.strokeColor = WY_MainColor.CGColor;
    rippleLayer.lineWidth = 3;
    rippleLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer insertSublayer:rippleLayer below:self.layer];
    
    //addRippleAnimation
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:self.frame];
    CGRect endRect = CGRectInset([self makeEndRect], -self.width, -self.height);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 5.0;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 3.0;
    
    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:2.0];
}
- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer {
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}
- (CGRect)makeEndRect
{
    CGRect endRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, self.height);
    endRect = CGRectInset(endRect, -50, -50);
    return endRect;
}

- (void)hideRippleAnimation {
    [rippleTimer invalidate];
    [self removeRippleLayer:rippleLayer];
}
@end


@implementation UIButton (WYConst)

+ (instancetype)wy_refreshBtnWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton wy_button];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.wy_normalImage = [UIImage imageNamed:@"btn_refresh_normal"];
    btn.wy_highlightedImage = [UIImage imageNamed:@"btn_refresh_highlighted"];
    [btn wy_addTarget:target actionUpInside:action];
    return btn;
}

@end

