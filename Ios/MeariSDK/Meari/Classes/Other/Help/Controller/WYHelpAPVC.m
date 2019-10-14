//
//  WYHelpAPVC.m
//  Meari
//
//  Created by 李兵 on 2017/3/3.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYHelpAPVC.h"

@interface WYHelpAPVC ()
@property (nonatomic, strong)UIScrollView *scrollV;
@property (nonatomic, strong)UIView *v1;
@property (nonatomic, strong)UIView *v2;
@property (nonatomic, strong)UIView *v3;
@property (nonatomic, strong)UILabel *label;


@end

@implementation WYHelpAPVC

#pragma mark - Private
#pragma mark -- Getter
- (UIScrollView *)scrollV {
    if (!_scrollV) {
        _scrollV = [UIScrollView new];
    }
    if (!_scrollV.superview) {
        [self.view addSubview:_scrollV];
    }
    return _scrollV;
}
- (UIView *)v1 {
    if (!_v1) {
        _v1 = [self unitWithText:WYLocalString(@"des_help_ap1")
                        numImage:[UIImage imageNamed:@"img_camera_ap_1"]
                           image:[UIImage imageNamed:@"img_camera_ap_step1"]];
    }
    if (!_v1.superview) {
        [self.scrollV addSubview:_v1];
    }
    return _v1;
}
- (UIView *)v2 {
    if (!_v2) {
        _v2 = [self unitWithText:WYLocalString(@"des_help_ap2")
                        numImage:[UIImage imageNamed:@"img_camera_ap_2"]
                           image:[UIImage imageNamed:@"img_camera_ap_step2"]];
    }
    if (!_v2.superview) {
        [self.scrollV addSubview:_v2];
    }
    return _v2;
}
- (UIView *)v3 {
    if (!_v3) {
        _v3 = [self unitWithText:WYLocalString(@"des_help_ap3")
                        numImage:[UIImage imageNamed:@"img_camera_ap_3"]
                           image:[UIImage imageNamed:@"img_camera_ap_step3"]];
    }
    if (!_v3.superview) {
        [self.scrollV addSubview:_v3];
    }
    return _v3;
}
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.numberOfLines = 0;
        _label.attributedText = [NSAttributedString defaultAttributedStringWithString:[NSString wy_local_help_config_des] fontColor:WY_FontColor_Gray font:WYFont_Text_S_Normal];
        CGFloat w = WY_ScreenWidth*0.85;
        CGFloat h = [_label ajustedHeightWithWidth:w];
        _label.size = CGSizeMake(w, h + 30);
    }
    if (!_label.superview) {
        [self.scrollV addSubview:_label];
    }
    return _label;
}
#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"Review instruction");
}
- (void)initLayout {
    WY_WeakSelf
    [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.v1.size);
        make.centerX.equalTo(weakSelf.scrollV);
        make.top.equalTo(weakSelf.scrollV).with.offset(20);
    }];
    [self.v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.v2.size);
        make.centerX.equalTo(weakSelf.scrollV);
        make.top.equalTo(weakSelf.v1.mas_bottom).with.offset(30);
    }];
    [self.v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.v3.size);
        make.centerX.equalTo(weakSelf.scrollV);
        make.top.equalTo(weakSelf.v2.mas_bottom).with.offset(30);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.label.size);
        make.centerX.equalTo(weakSelf.scrollV);
        make.top.equalTo(weakSelf.v3.mas_bottom).with.offset(0);
        make.bottom.equalTo(weakSelf.scrollV).with.offset(-20);
    }];
    
}

#pragma mark -- Utilities
- (UIView *)unitWithText:(NSString *)text numImage:(UIImage *)numImage image:(UIImage *)image {
    UIView *v = [UIView new];
    UIImageView *numImageV = [[UIImageView alloc] initWithImage:numImage];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    UILabel *label = [UILabel labelWithFrame:CGRectZero
                                        text:text
                                   textColor:WY_FontColor_Gray
                                    textfont:WYFont_Text_S_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByWordWrapping
                               lineAlignment:NSTextAlignmentLeft
                                   sizeToFit:NO];
    [v addSubview:numImageV];
    [v addSubview:label];
    [v addSubview:imageV];
    
    CGFloat W = WY_ScreenWidth*0.75;
    CGFloat w = W - numImage.size.width/2 - 20;
    CGFloat h = [label ajustedHeightWithWidth:w];
    label.size = CGSizeMake(w, h);
    [numImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(v);
        make.size.mas_equalTo(CGSizeMake(numImage.size.width/2, numImage.size.height/2));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(label.size);
        make.top.equalTo(numImageV).with.offset(10);
        make.leading.equalTo(numImageV.mas_trailing).with.offset(10);
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(11);
        make.size.mas_equalTo(CGSizeMake(image.size.width/2, image.size.height/2));
        make.centerX.equalTo(v);
    }];
    v.size = CGSizeMake(W, MAX(numImage.size.height, h+10) + 11 + image.size.height/2);
    return v;
}
#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
}
#pragma mark -- Action
#pragma mark - Delegate
#pragma mark - Public

@end
