//
//  WYBaseSubVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYBaseSubVC.h"

@interface WYBaseSubVC ()
@end

@implementation WYBaseSubVC
#pragma mark - Private
#pragma mark -- Getter
WYGetter_MutableArray(dataSource)
WYGetter_MutableDictionary(dataSourceDic)
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView wy_tableView];
        [_tableView wy_setDelegate:self];
        WYDo_Block_Safe1(self.setTableView, _tableView)
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark -- Init

#pragma mark -- Life
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- Network
#pragma mark -- Notification
#pragma mark -- NSTimer
#pragma mark -- Utilities
#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [self wy_pop];
}

#pragma mark - Delegate
#pragma mark UITabelViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    return cell;
}


@end

