//
//  FXBlurView+Add.m
//  Meari
//
//  Created by 李兵 on 2016/12/1.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "FXBlurView+Add.h"

@implementation FXBlurView (Add)
+ (instancetype)whiteBlurView {
    FXBlurView *view = [[FXBlurView alloc] init];
    view.dynamic = NO;
    view.blurRadius = 20;
    view.tintColor = [UIColor whiteColor];
    return view;
}
@end
