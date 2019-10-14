//
//  NSTimer+Extension.m
//  Meari
//
//  Created by 李兵 on 16/7/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

+ (NSTimer *)timerInLoopWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:aTarget selector:aSelector userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (NSTimer *)timerOnceWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:aTarget selector:aSelector userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}


@end
