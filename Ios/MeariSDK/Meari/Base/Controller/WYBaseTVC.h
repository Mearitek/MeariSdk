//
//  WYBaseTVC.h
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYBaseTVC : UITableViewController<WYTransition>
@property (nonatomic, assign)BOOL showNavigationLine;
- (void)backAction:(UIButton *)sender;
- (void)deallocAction;
@end
