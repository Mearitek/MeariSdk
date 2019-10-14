//
//  WYLoadingView+Add.m
//  Meari
//
//  Created by 李兵 on 2017/3/7.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYLoadingView+Add.h"

@implementation WYLoadingView (Add)

- (void)showSuccess {
    [self showWithImage:[UIImage imageNamed:@"img_apSuccess"]];
}
- (void)showFailure {
    [self showWithImage:[UIImage imageNamed:@"img_apFailure"]];
}

@end
