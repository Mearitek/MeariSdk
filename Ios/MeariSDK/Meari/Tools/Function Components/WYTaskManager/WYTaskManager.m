//
//  WYTaskManager.m
//  Meari
//
//  Created by 李兵 on 2017/9/28.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYTaskManager.h"
#define WYLogTask(task, fmt, ...)  WYLog(@"%@ want %@" fmt, task.target, task.command, ##__VA_ARGS__)

typedef NS_ENUM(NSInteger, WYTaskStatus) {
    WYTaskStatusNone,
    WYTaskStatusDoing,
    WYTaskStatusFinished,
};
@interface WYTask()
@property (nonatomic, assign)WYTaskStatus status;
@property (nonatomic, assign)BOOL success;
@property (nonatomic, weak)id target;
@property (nonatomic, copy)NSString *command;
@end
@implementation WYTask
- (void)doSucees {
    self.success = YES;
    [self doFinish];
}
- (void)doFinish {
    self.status = WYTaskStatusFinished;
}
@end

static NSMutableDictionary *_taskContainer;
@implementation WYTaskManager
+ (void)load {
    _taskContainer = [NSMutableDictionary dictionaryWithCapacity:0];
}

#pragma mark -- Private
+ (WYTask *)_findTaskWithTarget:(id)target command:(NSString *)command {
    WYTask *task = _taskContainer[command];
    if (task && task.target == target) {
        return task;
    }
    task = [WYTask new];
    task.target = target;
    task.command = command;
    task.status = WYTaskStatusNone;
    task.success = NO;
    _taskContainer[command] = task;
    return task;
}

#pragma mark -- Public
+ (void)obj:(id)obj want:(NSString *)want doTaskSyn:(void(^)(WYTask *task))doTask {
    [self obj:obj want:want doTask:doTask syn:YES once:NO];
}
+ (void)obj:(id)obj want:(NSString *)want doTaskSynOnce:(void(^)(WYTask *task))doTask {
    [self obj:obj want:want doTask:doTask syn:YES once:YES];
}
+ (void)obj:(id)obj want:(NSString *)want doTask:(void(^)(WYTask *task))doTask syn:(BOOL)syn once:(BOOL)once {
    if (!obj || !want) {
        return;
    }
    
    WYTask *task = [self _findTaskWithTarget:obj command:want];
    
    if (once) {
        if (task.success) {
            return;
        }
    }
    if (syn) {
        if (task.status == WYTaskStatusDoing) {
            return;
        }
    }
    task.status = WYTaskStatusDoing;
    __weak typeof(task) weakTask = task;
    WYDo_Block_Safe1(doTask, weakTask)
    
}
@end



