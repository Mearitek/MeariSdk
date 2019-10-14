//
//  WYCameraSelectConfigView.m
//  Meari
//
//  Created by 李兵 on 2017/11/27.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSelectConfigView.h"

@interface WYCameraSelectConfigView()
@property (nonatomic, strong)YLImageView *imageView;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIButton *btn;
@end

@implementation WYCameraSelectConfigView
#pragma mark -- Getter
- (YLImageView *)imageView {
    if (!_imageView) {
        _imageView = [YLImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel labelWithFrame:CGRectZero
                                    text:nil
                               textColor:WY_FontColor_Gray
                                textfont:WYFont_Text_S_Normal
                           numberOfLines:0
                           lineBreakMode:NSLineBreakByWordWrapping
                           lineAlignment:NSTextAlignmentCenter
                               sizeToFit:NO];
        [self addSubview:_label];
    }
    return _label;
}
- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledGreenAndWhiteTitle target:nil action:nil];
        [self addSubview:_btn];
    }
    return _btn;
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = self.btn.height/2;
}

#pragma mark -- Init
- (void)initSet {

}
- (void)initLayout {
    WY_WeakSelf
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.mas_width).multipliedBy(0.6);
        make.bottom.equalTo(weakSelf).offset(-20);
        make.height.equalTo(@40);
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerX.equalTo(weakSelf);
    }];
    CGFloat w = WY_ScreenWidth-40;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(w));
        make.height.equalTo(@(30)).priorityHigh(751);
        make.height.lessThanOrEqualTo(weakSelf);
        make.bottom.equalTo(weakSelf.btn.mas_top).offset(-16);
        make.height.lessThanOrEqualTo(@60);
        make.centerX.equalTo(weakSelf);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(165, 140));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(20);
        make.bottom.greaterThanOrEqualTo(weakSelf.label.mas_top).offset(-20);
    }];
}

#pragma mark -- Utilities
- (void)updateLayout {
    CGFloat w = WY_ScreenWidth-40;
    CGFloat h = [self.label ajustedHeightWithWidth:w];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h)).priorityHigh(751);
    }];
    if (self.imageView.image) {
        CGFloat r = self.imageView.image.size.height/self.imageView.image.size.width;
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(165, 165*r));
        }];
    }
}

#pragma mark -- Public
+ (instancetype)viewWithImage:(YLGIFImage *)image des:(NSString *)des btnTitle:(NSString *)title target:(id)target action:(SEL)action {
    WYCameraSelectConfigView *view = [WYCameraSelectConfigView new];
    view.imageView.image = image;
    view.label.text = des;
    view.btn.wy_normalTitle = title;
    [view.btn wy_addTarget:target actionUpInside:action];
    [view updateLayout];
    return view;
}
@end
