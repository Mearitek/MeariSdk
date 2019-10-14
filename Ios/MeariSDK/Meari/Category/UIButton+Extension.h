//
//  UIButton+Extension.h
//  Meari
//
//  Created by 李兵 on 15/11/30.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WYButtonStytle) {
    WYButtonStytleNone,
    WYButtonStytleFilledGreenAndWhiteTitle,
    WYButtonStytleFilledWhiteAndGreenTitle,
};

@interface UIButton (Extension)
/** title **/
@property (nonatomic, copy)NSString *wy_normalTitle;
@property (nonatomic, copy)NSString *wy_highlightedTitle;
@property (nonatomic, copy)NSString *wy_disabledTitle;
@property (nonatomic, copy)NSString *wy_selectedTitle;
/** color **/
@property (nonatomic, strong)UIColor *wy_normalTitleColor;
@property (nonatomic, strong)UIColor *wy_highlightedTitleColor;
@property (nonatomic, strong)UIColor *wy_disabledTitleColor;
@property (nonatomic, strong)UIColor *wy_selectedTitleColor;
/** image **/
@property (nonatomic, strong)UIImage *wy_normalImage;
@property (nonatomic, strong)UIImage *wy_highlightedImage;
@property (nonatomic, strong)UIImage *wy_disabledImage;
@property (nonatomic, strong)UIImage *wy_selectedImage;
/** backgroundImage **/
@property (nonatomic, strong)UIImage *wy_normalBGImage;
@property (nonatomic, strong)UIImage *wy_highlightedBGImage;
@property (nonatomic, strong)UIImage *wy_disabledBGImage;
@property (nonatomic, strong)UIImage *wy_selectedBGImage;
/** font **/
@property (nonatomic, strong)UIFont *wy_titleFont;
/** insets **/
@property (nonatomic, assign)CGFloat wy_insetTop;
@property (nonatomic, assign)CGFloat wy_insetLeft;
@property (nonatomic, assign)CGFloat wy_insetBottom;
@property (nonatomic, assign)CGFloat wy_insetRight;
/** action **/
- (void)wy_addTarget:(id)target actionDown:(SEL)action;
- (void)wy_addTarget:(id)target actionUpInside:(SEL)action;
- (void)wy_addTarget:(id)target actionUpOutside:(SEL)action;
- (void)wy_addTarget:(id)target actionDragInside:(SEL)action;
- (void)wy_addTarget:(id)target actionDragOutside:(SEL)action;
- (void)wy_addTarget:(id)target actionCancel:(SEL)action;
- (void)wy_addTarget:(id)target actionValueChanged:(SEL)action;
- (void)wy_addTarget:(id)target actionEditingDidBegin:(SEL)action;
- (void)wy_addTarget:(id)target actionEditingChanged:(SEL)action;
- (void)wy_addTarget:(id)target actionEditingDidEnd:(SEL)action;
- (void)wy_addTarget:(id)target actionEditingDidEndOnExit:(SEL)action;
- (void)wy_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
/** instance **/
+ (instancetype)wy_button;



/**
 *  背景图片：正常
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
        normalBackgroundImage:(UIImage *)normalBackgroundImage
                       target:(id)target
                       action:(SEL)action;
/**
 *  图片：正常
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
                       target:(id)target
                       action:(SEL)action;

/**
 *  图片：正常＋选中
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
                       target:(id)target
                       action:(SEL)action;

/**
 *  图片：正常＋高亮
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                       target:(id)target
                       action:(SEL)action;

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
                       action:(SEL)action;

/**
 *  button : 仅前景图片
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame
                  normalImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                selectedImage:(UIImage *)selectedImage
                       target:(id)target
                       action:(SEL)action;
/**
 默认填充绿按钮
 */
+ (UIButton *)defaultGreenFillButtonWithTarget:(id)target action:(SEL)action;
/**
 默认边框绿按钮
 */
+ (UIButton *)defaultGreenBounderButtonWithTarget:(id)target action:(SEL)action;
+ (instancetype)wy_buttonWithStytle:(WYButtonStytle)stytle target:(id)target action:(SEL)action;
@end


@interface UIButton (Animation)
/** 放大 */
- (void)showZoomAnimation;
/** 放大复位 */
- (void)hideZoomAnimation;

/** 显示波纹 */
- (void)showRippleAnimation;
/** 隐藏波纹 */
- (void)hideRippleAnimation;
@end

@interface UIButton (WYConst)
+ (instancetype)wy_refreshBtnWithTarget:(id)target action:(SEL)action;
@end

