//
//  LeftHeaderView.m
//  Meari
//
//  Created by 李兵 on 16/5/19.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMenuHeaderView.h"

@interface WYMenuHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation WYMenuHeaderView

#pragma mark -- Life
- (void)initAction {
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.layer.borderWidth = 1;
    self.backgroundImageView.layer.borderColor = WY_MainColor.CGColor;
    self.nickNameLabel.textColor = WY_MainColor;
    self.nickNameLabel.font = WYFont_Text_M_Bold;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.width/2;
    self.backgroundImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius  = self.headerImageView.width/2;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.backgroundColor = [UIColor clearColor].CGColor;
}
#pragma mark - Public
+ (instancetype)headerView {
    return [[UINib nibWithNibName:NSStringFromClass([WYMenuHeaderView class]) bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
}
- (void)addTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self.headerImageView addGestureRecognizer:tapG];
}


@end
