//
//  UITableViewCell+Extension.m
//  Meari
//
//  Created by 李兵 on 16/7/21.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)
// 转菊花
- (void)showIndicatorView {
    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.accessoryView = ac;
    [ac startAnimating];
}


#pragma mark - super
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIView *v = [UIView new];
    v.backgroundColor = WY_BGColor_Highlighted_cell;
    self.selectedBackgroundView = v;
}
#pragma clang diagnostic pop


@end
