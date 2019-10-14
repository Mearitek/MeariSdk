//
//  NSThread+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/7/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (Extension)

+ (void)wy_doOnMainThread:(WYBlock_Void)task;
+ (void)wy_doOnSubThreadAsyn:(WYBlock_Void)task;
+ (void)wy_doOnSubThreadAsyn:(WYBlock_Void)task threadName:(NSString *)threadName;

@end
