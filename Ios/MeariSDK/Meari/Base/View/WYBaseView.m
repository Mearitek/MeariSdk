//
//  WYBaseView.m
//  Meari
//
//  Created by 李兵 on 2017/4/7.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseView.h"

@implementation WYBaseView
#pragma mark -- Life
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        
        [self initAction];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
//    
    [self initAction];
}
- (void)dealloc {
//    
    [self deallocAction];
}

#pragma mark - Public
- (void)initAction {
    
}
- (void)deallocAction {
    
}

@end
