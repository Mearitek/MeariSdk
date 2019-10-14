//
//  UIBarButtonItem+Extension.m
//  Meari
//
//  Created by 李兵 on 16/4/14.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "WYProgressCircleView.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
@implementation UIBarButtonItem (Extension)

+ (void)load {
    WY_ExchangeInstanceImp(@selector(setEnabled:), @selector(wy_setEnabled:))
}

- (void)wy_setEnabled:(BOOL)enabled {
    if (WY_IsKindOfClass(self.customView, UIControl)) {
        ((UIControl *)self.customView).enabled = enabled;
    }
    [self wy_setEnabled:enabled];
}


- (void)setSeletect:(BOOL)selected {
    if (WY_IsKindOfClass(self.customView, UIButton)) {
        UIButton *btn = (UIButton *)self.customView;
        btn.selected = selected;
    }
}

- (BOOL)isSelected {
    if (WY_IsKindOfClass(self.customView, UIButton)) {
        UIButton *btn = (UIButton *)self.customView;
        return btn.isSelected;
    }
    return NO;
}



#pragma mark - 导航条按钮：图片
/**
 *  菜单
 */
+ (UIBarButtonItem *)menuImageItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_menu_normal"
                                         highlightedImageName:@"nav_menu_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:YES];
}

/**
 *  返回
 */
+ (UIBarButtonItem *)backImageItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_back_normal"
                                         highlightedImageName:@"nav_back_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:NO];
}
+ (UIBarButtonItem *)backImageBabyItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_back_normal"
                                         highlightedImageName:@"nav_back_baby_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:NO];
}

/**
 *  NVR
 */
+ (UIBarButtonItem *)nvrImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_nvr_normal"
                                         highlightedImageName:@"nav_nvr_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:NO];
}
+ (UIBarButtonItem *)nvrImageBabyItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_nvr_normal"
                                         highlightedImageName:@"nav_nvr_baby_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:NO];
}
/**
 *  sd卡
 */
+ (UIBarButtonItem *)sdCardImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_sdcard_normal"
                                         highlightedImageName:@"nav_sdcard_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:NO];
}
+ (UIBarButtonItem *)sdCardImageBabyItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_sdcard_normal"
                                         highlightedImageName:@"nav_sdcard_baby_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:NO];
}




/**
 添加
 */
+ (UIBarButtonItem *)addImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_add_normal"
                                         highlightedImageName:@"nav_add_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:YES];
}

/**
 删除
 */
+ (UIBarButtonItem *)deleteImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_delete_normal"
                                         highlightedImageName:@"nav_delete_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:YES];
}

/**
 取消
 */
+ (UIBarButtonItem *)cancelImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_cancel_normal"
                                         highlightedImageName:@"nav_cancel_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:YES];
}
/**
 确定
 */
+ (UIBarButtonItem *)checkmarkImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"nav_checkmark_normal"
                                         highlightedImageName:@"nav_checkmark_highlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:YES];
}
/**
 设置
 */
+ (UIBarButtonItem *)settingImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"btn_camera_setting_normal"
                                         highlightedImageName:@"btn_camera_setting_hignlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:YES];
}
/**
 设置带点
 */
+ (UIBarButtonItem *)settingRedImageItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem imageBarButtonItemWithNormalImage:@"btn_camera_settingRed_normal"
                                         highlightedImageName:@"btn_camera_settingRed_hignlighted"
                                             seletedImageName:nil
                                                       Target:target
                                                       action:action
                                             equalToImageSize:YES];
}

#pragma mark - 导航条按钮：文本
/**
 *  取消
 */
+ (UIBarButtonItem *)cacelTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocal_Cancel
                                               Target:target
                                               action:action];
}

/**
 *  保存
 */
+ (UIBarButtonItem *)saveTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Save")
                                               Target:target
                                               action:action];
}

/**
 *  完成
 */
+ (UIBarButtonItem *)finishTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Done")
                                               Target:target
                                               action:action];
}
/**
 *  OK
 */
+ (UIBarButtonItem *)OKTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocal_OK
                                               Target:target
                                               action:action];
}


/**
 *  下一步
 */
+ (UIBarButtonItem *)nextTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocal_Next
                                               Target:target
                                               action:action];
}

/**
 *  播放
 */
+ (UIBarButtonItem *)playTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Play")
                                               Target:target
                                               action:action];
}


/**
 *  选择
 */
+ (UIBarButtonItem *)selectTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Select")
                                               Target:target
                                               action:action];
}


/**
 *  编辑
 */
+ (UIBarButtonItem *)editTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Edit")
                                               Target:target
                                               action:action];
}

/**
 *  重做
 */
+ (UIBarButtonItem *)redoTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Redo")
                                               Target:target
                                               action:action];
}

/**
 *  手动添加
 */
+ (UIBarButtonItem *)manuallyAddTextItemWithTarget:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Manually Add")
                                               Target:target
                                               action:action];
}
/**
 *  Other distribution network
 */
+ (UIBarButtonItem *)otherDistributionMethod:(id)target action:(SEL)action {
    
    return [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"OtherMethod")
                                               Target:target
                                               action:action];
}

/**
 *  hd
 */
+ (UIBarButtonItem *)hdTextItemWithTarget:(id)target action:(SEL)action {
    
    UIBarButtonItem *item = [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"HD") Target:target action:action];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:WY_FontColor_Cyan} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:WY_FontColor_Gray} forState:UIControlStateDisabled];
    return item;
}


/**
 *  sd
 */
+ (UIBarButtonItem *)sdTextItemWithTarget:(id)target action:(SEL)action {
    
    UIBarButtonItem *item = [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"SD") Target:target action:action];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:WY_FontColor_Cyan} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:WY_FontColor_Gray} forState:UIControlStateDisabled];
    return item;
}

/**
 *  删除设备
 */
+ (UIBarButtonItem *)deleteDeviceTextItemWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *item = [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Delete Device") Target:target action:action];
    return item;
}
/**
 *  wifi配网
 */
+ (UIBarButtonItem *)wifiConfigTextItemWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *item = [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"device_config_wifi") Target:target action:action];
    return item;
}
/**
 *  取消
 */
+ (UIBarButtonItem *)cancelTextItemWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *item = [UIBarButtonItem textBarButtonItemWithText:WYLocalString(@"Cancel") Target:target action:action];
    return item;
}
#pragma mark - 导航条按钮：自定义
/**
 *  菊花
 */
+ (UIBarButtonItem *)juhuaViewItem {
    WYProgressCircleView *view = [[WYProgressCircleView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}


#pragma mark - 全能方法


/**
 *  导航条按钮：图片
 *
 *  @param normalImageName      正常图片
 *  @param highlightedImageName 高亮图片
 *  @param target               目标
 *  @param action               行为
 *  @param equalToImageSize     是否和图片一样大，NO－（20，20）
 *
 */
+ (UIBarButtonItem *)imageBarButtonItemWithNormalImage:(NSString *)normalImageName
                                  highlightedImageName:(NSString *)highlightedImageName
                                      seletedImageName:(nullable NSString *)selectedImageName
                                                Target:(id)target
                                                action:(SEL)action
                                      equalToImageSize:(BOOL)equalToImageSize{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    btn.frame = normalImage && equalToImageSize && normalImage.size.width > 32 ? CGRectMake(0, 0, normalImage.size.width, normalImage.size.height) :
    CGRectMake(0, 0, 32, 44);
    if (normalImageName)
        [btn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    if (highlightedImageName)
        [btn setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    if (selectedImageName)
        [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    if (target && action)
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}


                                                                  
/**
 *  导航条按钮：文本
 *
 *  @param text   按钮文本
 *  @param target 目标
 *  @param action 行为
 *
 */
+ (UIBarButtonItem *)textBarButtonItemWithText:(NSString *)text
                                        Target:(id)target
                                        action:(SEL)action {
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:text
                                                            style:UIBarButtonItemStylePlain
                                                           target:target
                                                           action:action];
                                            
    NSDictionary *normalDic = @{NSForegroundColorAttributeName:WY_FontColor_Black,
                                NSFontAttributeName:WYFont_Text_S_Normal
                                };
    [bar setTitleTextAttributes:normalDic forState:UIControlStateNormal];
                                            
    NSDictionary *highLightDic = @{NSForegroundColorAttributeName:WY_FontColor_Cyan};
    [bar setTitleTextAttributes:highLightDic forState:UIControlStateHighlighted];
    return bar;
}


@end

NS_ASSUME_NONNULL_END


