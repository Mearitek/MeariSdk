//
//  WYBaseVC.h
//  Meari
//
//  Created by 李兵 on 16/8/23.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WYBaseVC : UIViewController<WYTransition>
@property (nonatomic, assign)BOOL showNavigationLine;
- (void)backAction:(UIButton *)sender;
- (void)deallocAction;
@end
