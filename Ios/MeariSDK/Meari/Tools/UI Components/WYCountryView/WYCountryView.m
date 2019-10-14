//
//  WYCountryView.m
//  Meari
//
//  Created by 李兵 on 2017/12/26.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCountryView.h"

@interface WYCountryView()
@property (nonatomic, strong)UIButton *btn;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UIImageView *imgView;
@end

@implementation WYCountryView
#pragma mark -- Getter
- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton wy_button];
        _btn.wy_highlightedBGImage = [UIImage bgLightGrayImage];
        [self addSubview:_btn];
    }
    return _btn;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFrame:CGRectZero
                                          text:[self.country localizedCountryNameInLanguage:[NSBundle wy_bundledLanguage]]
                                     textColor:WY_FontColor_Gray
                                      textfont:WYFont_Text_S_Normal
                                 numberOfLines:0
                                 lineBreakMode:NSLineBreakByTruncatingTail
                                 lineAlignment:NSTextAlignmentLeft
                                     sizeToFit:NO];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithFrame:CGRectZero
                                                text:self.country.phoneCodePlus
                                           textColor:WY_FontColor_Gray
                                            textfont:WYFont_Text_S_Normal
                                       numberOfLines:0
                                       lineBreakMode:NSLineBreakByTruncatingMiddle
                                       lineAlignment:NSTextAlignmentRight
                                           sizeToFit:NO];
        [self addSubview:_phoneLabel];
    }
    return _phoneLabel;
}
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_arrow_right"]];
        [self addSubview:_imgView];
    }
    return _imgView;
}

#pragma mark -- Init
- (void)initAction {
    [self initSet];
    [self initLayout];
}

- (void)initSet {
    self.backgroundColor = WY_BGColor_LightGray;
    if (!self.country) {
        self.country = [LBCountryModel wy_localCountry];
    }
}
- (void)initLayout {
    WY_WeakSelf
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(8);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.trailing.equalTo(weakSelf.imgView.mas_leading).offset(-8);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.imgView.image.size);
        make.trailing.equalTo(weakSelf).offset(-8);
        make.centerY.equalTo(weakSelf);
    }];
}


#pragma mark - Public
+ (instancetype)viewWithTarget:(id)target action:(SEL)action {
    WYCountryView *v = [WYCountryView new];
    [v.btn wy_addTarget:target actionUpInside:action];
    return v;
}
- (void)setCountry:(LBCountryModel *)country {
    _country = country;
    self.nameLabel.text = country.displayCountryName  ? country.displayCountryName : [country localizedCountryNameInLanguage:[NSBundle wy_bundledLanguage]];
    self.phoneLabel.text = country.phoneCodePlus;
}

@end
