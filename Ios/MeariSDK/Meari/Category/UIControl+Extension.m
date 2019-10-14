//
//  UIControl+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/5/24.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "UIControl+Extension.h"
#import <objc/runtime.h>

const CGFloat WYControlDelayTime = 0.2f;
@implementation UIControl (Extension)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(sendAction:to:forEvent:)), class_getInstanceMethod(self, @selector(wy_sendAction:to:forEvent:)));
    });
}

- (void)setWy_isIgnored:(BOOL)wy_isIgnored {
    objc_setAssociatedObject(self, @selector(wy_isIgnored), @(wy_isIgnored), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)wy_isIgnored {
    return [objc_getAssociatedObject(self, @selector(wy_isIgnored)) boolValue];
}
- (void)setWy_needIgnored:(BOOL)wy_needIgnored {
    objc_setAssociatedObject(self, @selector(wy_needIgnored), @(wy_needIgnored), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)wy_needIgnored {
    return [objc_getAssociatedObject(self, @selector(wy_needIgnored)) boolValue];
}
- (void)setWy_delayTime:(CGFloat)wy_delayTime {
    objc_setAssociatedObject(self, @selector(wy_delayTime), @(wy_delayTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)wy_delayTime {
    if (objc_getAssociatedObject(self, @selector(wy_delayTime))) {
        return [objc_getAssociatedObject(self, @selector(wy_delayTime)) floatValue];
    }
    return WYControlDelayTime;
}
- (NSNumber *)wy_on {
    return objc_getAssociatedObject(self, @selector(wy_on));
}
- (void)setWy_on:(NSNumber *)wy_on {
    objc_setAssociatedObject(self, @selector(wy_on), wy_on, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (WY_IsKindOfClass(self, UISwitch)) {
        UISwitch *sw = (UISwitch *)self;
        if (!sw.wy_on || sw.wy_on.boolValue != sw.isOn) {
            sw.wy_on = @(sw.isOn);
            [self wy_sendAction:action to:target forEvent:event];
        }
        return;
    }
    if (!self.wy_needIgnored) {
        [self wy_sendAction:action to:target forEvent:event];
        return;
    }
    
    if (self.wy_isIgnored) return;
    
    self.wy_isIgnored = YES;
    [self performSelector:@selector(resetWy_isIgnored) withObject:nil afterDelay:self.wy_delayTime];
    [self wy_sendAction:action to:target forEvent:event];
}
- (void)resetWy_isIgnored {
    self.wy_isIgnored = NO;
}


@end
