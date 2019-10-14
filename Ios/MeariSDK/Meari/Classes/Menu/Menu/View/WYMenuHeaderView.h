//
//  LeftHeaderView.h
//  Meari
//
//  Created by 李兵 on 16/5/19.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYMenuHeaderView : WYBaseView
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

+ (instancetype)headerView;
- (void)addTarget:(id)target action:(SEL)action;

@end
