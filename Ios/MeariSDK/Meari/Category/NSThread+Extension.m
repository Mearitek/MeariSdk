//
//  NSThread+Extension.m
//  Meari
//
//  Created by 李兵 on 2017/7/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "NSThread+Extension.h"

@implementation NSThread (Extension)


+ (void)wy_doOnMainThread:(WYBlock_Void)task {
    WYDo_Block_Safe_Main(task)
}
+ (void)wy_doOnSubThreadAsyn:(WYBlock_Void)task {
    [self wy_doOnSubThreadAsyn:task threadName:@"default"];
}
+ (void)wy_doOnSubThreadAsyn:(WYBlock_Void)task threadName:(NSString *)threadName {
    dispatch_queue_t q = dispatch_queue_create(nil, nil);
    dispatch_sync(q, ^{
        [[NSThread currentThread] setName:threadName];
    });
    dispatch_async(q,task);
}
@end
