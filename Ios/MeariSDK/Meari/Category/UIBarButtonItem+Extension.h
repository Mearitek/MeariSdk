//
//  UIBarButtonItem+Extension.h
//  Meari
//
//  Created by 李兵 on 16/4/14.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
- (void)setSeletect:(BOOL)selected;
- (BOOL)isSelected;


#pragma mark - 导航条按钮：图片
/**
 *  菜单
 */
+ (UIBarButtonItem *)menuImageItemWithTarget:(id)target action:(SEL)action;

/**
 *  返回
 */
+ (UIBarButtonItem *)backImageItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backImageBabyItemWithTarget:(id)target action:(SEL)action;

/**
 *  NVR
 */
+ (UIBarButtonItem *)nvrImageItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)nvrImageBabyItemWithTarget:(id)target action:(SEL)action;

/**
 *  sd卡
 */
+ (UIBarButtonItem *)sdCardImageItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)sdCardImageBabyItemWithTarget:(id)target action:(SEL)action;

/**
    添加
 */
+ (UIBarButtonItem *)addImageItemWithTarget:(id)target action:(SEL)action;
/**
 删除
 */
+ (UIBarButtonItem *)deleteImageItemWithTarget:(id)target action:(SEL)action;
/**
 取消
 */
+ (UIBarButtonItem *)cancelImageItemWithTarget:(id)target action:(SEL)action;
/**
 确定
 */
+ (UIBarButtonItem *)checkmarkImageItemWithTarget:(id)target action:(SEL)action;
/**
 设置
 */
+ (UIBarButtonItem *)settingImageItemWithTarget:(id)target action:(SEL)action;
/**
 设置带点
 */
+ (UIBarButtonItem *)settingRedImageItemWithTarget:(id)target action:(SEL)action;


#pragma mark - 导航条按钮：文本
/**
 *  取消
 */
+ (UIBarButtonItem *)cacelTextItemWithTarget:(id)target action:(SEL)action;


/**
 *  保存
 */
+ (UIBarButtonItem *)saveTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  OK
 */
+ (UIBarButtonItem *)OKTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  完成
 */
+ (UIBarButtonItem *)finishTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  下一步
 */
+ (UIBarButtonItem *)nextTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  播放
 */
+ (UIBarButtonItem *)playTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  选择
 */
+ (UIBarButtonItem *)selectTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  编辑
 */
+ (UIBarButtonItem *)editTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  重做
 */
+ (UIBarButtonItem *)redoTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  手动添加
 */
+ (UIBarButtonItem *)manuallyAddTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  Other distribution network
 */
+ (UIBarButtonItem *)otherDistributionMethod:(id)target action:(SEL)action;

/**
 *  hd
 */
+ (UIBarButtonItem *)hdTextItemWithTarget:(id)target action:(SEL)action;
/**
 *  sd
 */
+ (UIBarButtonItem *)sdTextItemWithTarget:(id)target action:(SEL)action;

/**
 *  删除设备
 */
+ (UIBarButtonItem *)deleteDeviceTextItemWithTarget:(id)target action:(SEL)action;
/**
 *  wifi配网
 */
+ (UIBarButtonItem *)wifiConfigTextItemWithTarget:(id)target action:(SEL)action;
/**
 *  取消
 */
+ (UIBarButtonItem *)cancelTextItemWithTarget:(id)target action:(SEL)action;

#pragma mark - 导航条按钮：自定义
/**
 *  菊花
 */
+ (UIBarButtonItem *)juhuaViewItem;

@end
