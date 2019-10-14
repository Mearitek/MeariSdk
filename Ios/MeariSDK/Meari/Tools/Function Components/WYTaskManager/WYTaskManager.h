//
//  WYTaskManager.h
//  Meari
//
//  Created by 李兵 on 2017/9/28.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYTask : NSObject
- (void)doSucees;
- (void)doFinish;
@end

@interface WYTaskManager : NSObject
+ (void)obj:(id)obj want:(NSString *)want doTaskSyn:(void(^)(WYTask *task))doTask;
+ (void)obj:(id)obj want:(NSString *)want doTaskSynOnce:(void(^)(WYTask *task))doTask;
+ (void)obj:(id)obj want:(NSString *)want doTask:(void(^)(WYTask *task))doTask syn:(BOOL)syn once:(BOOL)once;
@end


