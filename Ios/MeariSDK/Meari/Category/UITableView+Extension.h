//
//  UITableView+Extension.h
//  Meari
//
//  Created by 李兵 on 16/2/17.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extension)

+ (instancetype)wy_tableView;
+ (instancetype)wy_tableViewWithDelegate:(id)delegate;
+ (instancetype)wy_tableViewWithDelegate:(id)delegate cellClass:(Class)cellClass fromNib:(BOOL)fromNib;


- (void)wy_setDelegate:(id)delegate;
- (void)wy_registerClass:(Class)cellClass fromNib:(BOOL)fromNib;
- (void)wy_registerClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier fromNib:(BOOL)fromNib;

@end
