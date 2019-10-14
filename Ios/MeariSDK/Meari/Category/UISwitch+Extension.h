//
//  UISwitch+Extension.h
//  Meari
//
//  Created by 李兵 on 16/5/31.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (Extension)


/**
 *  默认的switch
 */
+ (instancetype)defaultSwitchWithTarget:(id)target action:(SEL)action;

/**
 *  便利构造器
 *
 *  @param frame
 *  @param on
 *  @param target
 *  @param action
 */
+ (instancetype)switchWithFrame:(CGRect)frame
                             on:(BOOL)on
                         target:(id)target
                         action:(SEL)action;
@end


@interface UISwitch (WYBug)

@end
