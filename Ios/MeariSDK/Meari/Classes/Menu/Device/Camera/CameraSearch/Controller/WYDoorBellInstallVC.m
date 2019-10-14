//
//  WYDoorBellInstallVC.m
//  Meari
//
//  Created by FMG on 2017/9/7.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellInstallVC.h"

@interface WYDoorBellInstallVC ()

@end

@implementation WYDoorBellInstallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self setDoorBellInstall];
}
#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"INSTALL DOORBELL");
    self.navigationItem.rightBarButtonItem = nil;
}



@end
