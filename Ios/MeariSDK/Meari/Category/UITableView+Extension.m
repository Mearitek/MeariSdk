//
//  UITableView+Extension.m
//  Meari
//
//  Created by 李兵 on 16/2/17.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

+ (instancetype)wy_tableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.frame = CGRectZero;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [UIView new];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    return tableView;
}
+ (instancetype)wy_tableViewWithDelegate:(id)delegate {
    UITableView *tableView = [self wy_tableView];
    [tableView wy_setDelegate:delegate];
    return tableView;
}
+ (instancetype)wy_tableViewWithDelegate:(id)delegate cellClass:(Class)cellClass fromNib:(BOOL)fromNib{
    UITableView *tableView = [self wy_tableViewWithDelegate:delegate];
    [tableView wy_registerClass:cellClass fromNib:fromNib];
    return tableView;
}

- (void)wy_setDelegate:(id)delegate {
    self.delegate = delegate;
    self.dataSource = delegate;
}
- (void)wy_registerClass:(Class)cellClass fromNib:(BOOL)fromNib {
    [self wy_registerClass:cellClass reuseIdentifier:WY_ClassName(cellClass) fromNib:fromNib];
}
- (void)wy_registerClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier fromNib:(BOOL)fromNib {
    if (!cellClass || !reuseIdentifier) return;
    
    NSString *cellClassName = WY_ClassName(cellClass);
    if (cellClassName) {
        if (fromNib) {
            UINib *nib = [UINib nibWithNibName:cellClassName bundle:nil];
            [self registerNib:nib forCellReuseIdentifier:reuseIdentifier];
        }else {
            [self registerClass:cellClass forCellReuseIdentifier:reuseIdentifier];
        }
    }
}

@end
