//
//  UISwitch+Extension.m
//  Meari
//
//  Created by 李兵 on 16/5/31.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UISwitch+Extension.h"

@implementation UISwitch (Extension)
/**
 *  默认的switch
 */
+ (instancetype)defaultSwitchWithTarget:(id)target action:(SEL)action {
    return [UISwitch switchWithFrame:CGRectMake(0, 0, 65, 30) on:NO target:target action:action];
}



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
                         action:(SEL)action{
    UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
    sw.on = on;
    sw.onTintColor = WY_MainColor;
    if (target) {
        [sw addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
    return sw;
}

@end


@implementation UISwitch (WYBug)
- (NSNumber *)wy_onFlag {
    return objc_getAssociatedObject(self, @selector(wy_onFlag));
}
- (void)setWy_onFlag:(NSNumber *)wy_onFlag {
    objc_setAssociatedObject(self, @selector(wy_onFlag), wy_onFlag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    WY_ExchangeInstanceImp(@selector(wy_setOn:), @selector(setOn:));
    WY_ExchangeInstanceImp(@selector(wy_setOn:animated:), @selector(setOn:animated:));
}
- (void)wy_setOn:(BOOL)on {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.wy_on = @(on);
        [self wy_setOn:on];
    });
}
- (void)wy_setOn:(BOOL)on animated:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.wy_on = @(on);
        [self wy_setOn:on animated:animated];
    });
}

@end
