//
//  WYRefreshNormalFooter.m
//  Meari
//
//  Created by 李兵 on 2017/3/1.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYRefreshNormalFooter.h"

@implementation WYRefreshNormalFooter

- (void)prepare {
    [super prepare];
    [self setTitle:WYLocalString(@"Pull-up-to-load") forState:MJRefreshStateIdle];
    [self setTitle:WYLocalString(@"Loading...")      forState:MJRefreshStateRefreshing];
    [self setTitle:WYLocalString(@"No more data")    forState:MJRefreshStateNoMoreData];
        
}

@end
