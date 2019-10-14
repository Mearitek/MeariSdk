//
//  WYTableHeaderView.m
//  Meari
//
//  Created by 李兵 on 2017/1/12.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYTableHeaderView.h"

@implementation WYTableHeaderView

+ (instancetype)defaultHeaderWithTitle:(NSString *)title {
    WYTableHeaderView *v = [WYTableHeaderView new];
    v.frame = CGRectMake(0, 0, WY_ScreenWidth, 30);
    UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, WY_ScreenWidth, 30)
                                        text:title
                                   textColor:WY_FontColor_Gray
                                    textfont:WYFont_Text_XS_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByTruncatingTail
                               lineAlignment:NSTextAlignmentCenter
                                   sizeToFit:NO];
    [v addSubview:label];
    [v addLineViewAtBottom];
    return v;
}

+ (instancetype)promptHeaderWithTitlte:(NSString *)title {
    return [self promptHeaderWithTitlte:title textColor:WY_FontColor_Orange bgColor:WY_BGColor_LightOrange];
}
+ (instancetype)promptHeaderWithTitlte:(NSString *)title textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor {
    WYTableHeaderView *v = [WYTableHeaderView new];
    v.frame = CGRectMake(0, 0, WY_ScreenWidth, 30);
    UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, WY_ScreenWidth, 30)
                                        text:title
                                   textColor:textColor
                                    textfont:WYFont_Text_S_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByTruncatingTail
                               lineAlignment:NSTextAlignmentCenter
                                   sizeToFit:NO];
    v.backgroundColor = bgColor;
    [v addSubview:label];
    [v addLineViewAtBottom];
    return v;
}

@end
