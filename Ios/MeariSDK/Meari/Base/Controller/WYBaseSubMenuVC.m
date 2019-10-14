//
//  WYBaseVC.m
//  Meari
//
//  Created by Strong on 15/11/7.
//  Copyright © 2015年 PPStrong. All rights reserved.
//


#import "WYBaseSubMenuVC.h"

@interface WYBaseSubMenuVC ()

@end

@implementation WYBaseSubMenuVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WY_SlideVC.needSwipeShowMenu = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    WY_SlideVC.needSwipeShowMenu = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuImageItemWithTarget:self action:@selector(menuAction:)];
    
    WY_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];

}


- (void)menuAction:(UIButton *)sender {
    [self.view endEditing:YES];
    WY_HUD_DISMISS
    [WY_SlideVC showLeftViewController:YES];
}





@end
