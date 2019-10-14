//
//  WYMsgModel.m
//  Meari
//
//  Created by 李兵 on 16/3/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgModel.h"

@implementation WYMsgModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selected = NO;
        _isSysMsg = NO;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
