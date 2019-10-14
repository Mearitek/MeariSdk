//
//  WYCameraManuallyAddVC.m
//  Meari
//
//  Created by 李兵 on 2017/3/3.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraManuallyAddVC.h"

@interface WYCameraManuallyAddVC ()
@property (nonatomic, strong)YLImageView *imageV;
@property (nonatomic, strong)UILabel *desLabel;
@property (nonatomic, strong)UIButton *nextBtn;
@property (nonatomic, strong)UILabel *helpLabel;
@end

@implementation WYCameraManuallyAddVC
#pragma mark - Private
#pragma mark -- Getter
- (YLImageView *)imageV {
    if (!_imageV) {
        _imageV = [YLImageView new];;
        _imageV.image = [YLGIFImage imageNamed:@"gif_blueLightFlashShow.gif"];
    }
    if (!_imageV.superview) {
        [self.view addSubview:_imageV];
    }
    return _imageV;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel labelWithFrame:CGRectZero
                                       text:WYLocalString(@"des_manuallyAdd")
                                  textColor:WY_FontColor_Gray
                                   textfont:WYFont_Text_S_Normal
                              numberOfLines:0
                              lineBreakMode:NSLineBreakByWordWrapping
                              lineAlignment:NSTextAlignmentCenter
                                  sizeToFit:NO];
        CGFloat w = WY_ScreenWidth-60;
        CGFloat h = [_desLabel ajustedHeightWithWidth:w];
        _desLabel.size = CGSizeMake(w, h);
    }
    if (!_desLabel.superview) {
        [self.view addSubview:_desLabel];
    }
    return _desLabel;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(nextAction:)];
        _nextBtn.layer.cornerRadius = 20;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn setTitle:WYLocal_Next forState:UIControlStateNormal];
    }
    if (!_nextBtn.superview) {
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
}
- (UILabel *)helpLabel {
    if (!_helpLabel) {
        _helpLabel = [UILabel labelWithFrame:CGRectZero
                                        text:WYLocalString(@"des_help_lightInOtherStatus")
                                   textColor:WY_FontColor_Cyan
                                    textfont:WYFont_Text_S_Normal
                               numberOfLines:0
                               lineBreakMode:NSLineBreakByWordWrapping
                               lineAlignment:NSTextAlignmentCenter
                                   sizeToFit:NO];
        CGFloat w = WY_ScreenWidth-60;
        CGFloat h = [_helpLabel ajustedHeightWithWidth:w];
        _helpLabel.size = CGSizeMake(w, h);
        [_helpLabel setHighlightedTextColor:WY_FontColor_Gray];
        [_helpLabel addTapGestureTarget:self action:@selector(helpAction:)];
    }
    if (!_helpLabel.superview) {
        [self.view addSubview:_helpLabel];
    }
    return _helpLabel;
}


#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"Manually Add");
}
- (void)initLayout {
    WY_WeakSelf
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(weakSelf.imageV.image.size.width/2, weakSelf.imageV.image.size.height/2));
        make.top.equalTo(weakSelf.view).with.offset(55).priorityHigh();
        make.top.greaterThanOrEqualTo(weakSelf.view).with.offset(10);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.greaterThanOrEqualTo(weakSelf.imageV.mas_bottom).with.offset(20);
        make.top.equalTo(weakSelf.imageV.mas_bottom).with.offset(55).priorityHigh();
        make.size.mas_equalTo(weakSelf.desLabel.size);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(@40);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
        make.bottom.equalTo(weakSelf.view).with.offset(-112);
        make.top.greaterThanOrEqualTo(weakSelf.desLabel.mas_bottom).offset(20);
    }];
    [self.helpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.size.mas_equalTo(weakSelf.helpLabel.size);
        make.top.equalTo(weakSelf.nextBtn.mas_bottom).with.offset(30);
    }];
    
}

#pragma mark -- Utilities
#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}

#pragma mark -- Action
- (void)nextAction:(UIButton *)sender {
    [self wy_pushToVC:WYVCTypeCameraWifi];
}
- (void)helpAction:(UITapGestureRecognizer *)sender {
    [self wy_pushToVC:WYVCTypeHelpLight];
}

@end
