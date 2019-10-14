//
//  WYPhotoBrowser.m
//  Meari
//
//  Created by 李兵 on 2017/3/2.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYPhotoBrowser.h"

@interface WYPhotoBrowser ()
{
    BOOL _wy_barTranslucent;
}
@end

@implementation WYPhotoBrowser

#pragma mark - Private
#pragma mark -- Init
- (void)wy_initSet {
    _wy_barTranslucent = self.navigationController.navigationBar.translucent;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backImageItemWithTarget:self action:@selector(backAction:)];
}
#pragma mark - Super
- (void)viewDidLoad {
    [super viewDidLoad];
    [self wy_initSet];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsCompact];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public
+ (instancetype)wy_browserWithDelegate:(id<MWPhotoBrowserDelegate>)delegate currentIndex:(NSInteger)index {
    WYPhotoBrowser *browser = [[WYPhotoBrowser alloc] initWithDelegate:delegate];
    browser.displayActionButton     = YES;
    browser.displayNavArrows        = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls      = NO;
    browser.zoomPhotosToFill        = YES;
    browser.enableGrid              = YES;
    browser.startOnGrid             = NO;
    browser.enableSwipeToDismiss    = NO;
    browser.autoPlayOnAppear        = NO;
    [browser setCurrentPhotoIndex:index];
    return browser;
}

@end
