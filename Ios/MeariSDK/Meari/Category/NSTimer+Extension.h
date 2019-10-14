//
//  NSTimer+Extension.h
//  Meari
//
//  Created by 李兵 on 16/7/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

+ (NSTimer *)timerInLoopWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector;
+ (NSTimer *)timerOnceWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector;


@end
