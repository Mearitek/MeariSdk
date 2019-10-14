//
//  WYCountryVC.m
//  Meari
//
//  Created by 李兵 on 2017/12/7.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCountryVC.h"

@interface WYCountryVC ()

@end

@implementation WYCountryVC

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

    [self customSet];
}
- (void)customSet {
    self.navigationItem.title = WYLocalString(@"me_signup_selectCountry");
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem cancelTextItemWithTarget:self action:@selector(cancelAction:)];
}

#pragma mark -- Action
- (void)cancelAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public
+ (instancetype)wy_vcWithSelectCountry:(LBCountrySelectBlock)selectCountry {
    WYCountryVC *vc = [WYCountryVC new];
    vc.selectCountry = selectCountry;
    vc.language = [NSBundle wy_bundledLanguage];
    vc.showPhoneCodePlus = YES;
    vc.uiConfig = ^(UISearchController *searchVC, UITableView *tableView) {
        searchVC.searchBar.tintColor = WY_MainColor;
        [tableView setSectionIndexColor:WY_MainColor];
    };
    return vc;
}


@end
