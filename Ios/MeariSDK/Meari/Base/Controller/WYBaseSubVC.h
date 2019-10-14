//
//  WYBaseSubVC.h
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//


@interface WYBaseSubVC : WYBaseVC<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *dataSourceDic;


//InitSet
@property (nonatomic, copy)WYBlock_TableView setTableView;

- (void)viewDidLoad NS_REQUIRES_SUPER;
- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;

@end
