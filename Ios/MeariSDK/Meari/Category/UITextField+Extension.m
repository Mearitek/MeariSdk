//
//  UITextField+Extension.m
//  Meari
//
//  Created by 李兵 on 16/7/21.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.secureTextEntry) {
        return NO;
    }else {
        if (action == @selector(copy:)) {
            return YES;
        }else if (action == @selector(paste:)) {
            return YES;
        }else if (action == @selector(cut:)) {
            return YES;
        }else if (action == @selector(select:)) {
            return YES;
        }else if (action == @selector(selectAll:)) {
            return YES;
        }
        return [super canPerformAction:action withSender:sender];
    }
}

@end
