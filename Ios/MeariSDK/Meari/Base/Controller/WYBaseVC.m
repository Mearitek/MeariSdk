//
//  WYBaseVC.m
//  Meari
//
//  Created by 李兵 on 16/8/23.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYBaseVC.h"

@interface WYBaseVC ()

@end

@implementation WYBaseVC
#pragma mark - Private
#pragma mark -- Life
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem backImageItemWithTarget:self action:@selector(backAction:)];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.showNavigationLine) {
        self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:WY_LineColor_LightGray];
    }else {
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)dealloc {
    
    [self deallocAction];
}

#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    self.wy_pushFromVCType = VCType;
}

#pragma mark - Public
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deallocAction {
    
}


@end
