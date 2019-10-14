//
//  WYTableHeaderView.h
//  Meari
//
//  Created by 李兵 on 2017/1/12.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYTableHeaderView : UIView
+ (instancetype)defaultHeaderWithTitle:(NSString *)title;
+ (instancetype)promptHeaderWithTitlte:(NSString *)title;
+ (instancetype)promptHeaderWithTitlte:(NSString *)title textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor;
@end
