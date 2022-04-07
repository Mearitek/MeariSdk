//
//  TabbarVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "TabbarVC.h"

@interface TabbarVC ()<UITabBarDelegate>

@end

@implementation TabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -- UITabbarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger currentSelect = [tabBar.items indexOfObject:item];
    if (currentSelect != 0 && ![MeariUser sharedInstance].logined) {
        UIAlertController *alert = [UIAlertController alertControllerMessage:@"please login account first" sureBlock:^{
            [self setSelectedIndex:0];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
