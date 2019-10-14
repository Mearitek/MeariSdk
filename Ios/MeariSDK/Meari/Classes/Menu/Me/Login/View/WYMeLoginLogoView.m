//
//  WYMeLoginLogoView.m
//  Meari
//
//  Created by 李兵 on 2017/9/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeLoginLogoView.h"

@interface WYMeLoginLogoView ()
@property (nonatomic, strong)UIImageView *picLogo;
@property (nonatomic, strong)UIImageView *fontLogo;
@end

@implementation WYMeLoginLogoView
#pragma mark -- Getter
- (UIImageView *)picLogo {
    if (!_picLogo) {
        _picLogo = [UIImageView new];
        _picLogo.image = [UIImage imageNamed:@"img_logo_pic"];
        [self addSubview:_picLogo];
    }
    return _picLogo;
}
- (UIImageView *)fontLogo {
    if (!_fontLogo) {
        _fontLogo = [UIImageView new];
        _fontLogo.image = [UIImage imageNamed:@"img_logo_font"];
        [self addSubview:_fontLogo];
    }
    return _fontLogo;
}

#pragma mark -- Life
- (void)initAction {
    [self initLayout];
}
- (void)initLayout {
    WY_WeakSelf
    CGSize picSize = self.picLogo.image.size;
    CGSize fontSize = self.fontLogo.image.size;
    CGFloat space = 0;
    CGFloat margin = (WY_ScreenWidth-picSize.width-space-fontSize.width)/2;
    [self.picLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(picSize);
        make.leading.equalTo(weakSelf).offset(margin);
        make.centerY.equalTo(weakSelf);
    }];
    [self.fontLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(fontSize);
        make.centerY.equalTo(weakSelf.picLogo);
        make.leading.equalTo(weakSelf.picLogo.mas_trailing).offset(space);
    }];
}

@end
