//
//  PPSNavigationController.m
//  Meari
//
//  Created by 李兵 on 15/12/26.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "WYBaseNVC.h"

@interface WYBaseNVC ()

@end

@implementation WYBaseNVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (BOOL)shouldAutorotate {
    return self.viewControllers.lastObject.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.viewControllers.lastObject.supportedInterfaceOrientations;
}

#pragma mark - super
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [[MeariUser sharedInstance] cancelAllRequest];
    WY_HUD_DISMISS
    return [super popViewControllerAnimated:animated];
}
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    WY_HUD_DISMISS
    return [super popToRootViewControllerAnimated:animated];
}
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    WY_HUD_DISMISS
    return [super popToViewController:viewController animated:animated];
}

@end
