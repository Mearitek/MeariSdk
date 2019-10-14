//
//  WYCameraToolPreviewView.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraToolPreviewView.h"
#import "WYCameraToolPreviewBabyView.h"

NSString *const WYCameraToolPreviewNoneParameter = @"--";
const CGFloat menuHeight = 32;
@interface WYCameraToolPreviewView ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL _babyMonitor;
    BOOL _loading;
}
@property (nonatomic, weak)UIView *topView;
@property (nonatomic, weak)UIView *middleNormalView;
@property (nonatomic, weak)UIView *middleBellView;
@property (nonatomic, weak)WYCameraToolPreviewBabyView *babyView;
@property (nonatomic, weak)UIButton *motionBtn;
@property (nonatomic, weak)UIButton *sleepmodeBtn;
@property (nonatomic, weak)UIButton *shareBtn;

@property (nonatomic, weak)UIButton *PIRBtn;
@property (nonatomic, weak)UIButton *jingleBellBtn;
@property (nonatomic, weak)UIButton *powerManagementBtn;

@property (nonatomic, weak)UIView *line1;
@property (nonatomic, weak)UIView *line2;
@property (nonatomic, weak)UITableView *sleepmodeMenuView;

@property (nonatomic, weak)UILabel *bitrateLabel;
@property (nonatomic, weak)UILabel *energyLabel;
@property (nonatomic, weak)UILabel *tempLabel;
@property (nonatomic, weak)UILabel *humidityLabel;


@property (nonatomic, weak)UIView *trhView;
@property (nonatomic, weak)UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak)UILabel *trhLabel;

@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, strong)NSArray *originalSource;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)MeariDeviceSubType deviceType;
@property (nonatomic, assign)BOOL doorbell;;


@end

@implementation WYCameraToolPreviewView
#pragma mark - Private
#pragma mark -- Getter
- (UIButton *)motionBtn {
    if (!_motionBtn) {
        UIImage *image = _babyMonitor ? [UIImage imageNamed:@"btn_baby_preview_motion_highlighted"] : [UIImage imageNamed:@"btn_camera_preview_motion_highlighted"];
        UIButton *motionBtn = [self bottomButtonWithImage:[UIImage imageNamed:@"btn_camera_preview_motion_normal"]
                                         highlightedImage:image
                                            selectedImage:image
                                            disabledImage:[UIImage imageNamed:@"btn_camera_preview_motion_disabled"]
                                                    title:WYCameraToolPreviewNoneParameter
                                                   action:@selector(alarmAction:)];
        [motionBtn setTitleColor:WY_FontColor_LightBlack forState:UIControlStateNormal];
        [motionBtn setTitleColor:WY_FontColor_LightGray forState:UIControlStateDisabled];
        _motionBtn = motionBtn;
        [self.middleNormalView addSubview:motionBtn];
    }
    return _motionBtn;
}
- (UIButton *)sleepmodeBtn {
    if (!_sleepmodeBtn) {
        UIImage *selectedImage = _babyMonitor ? [UIImage sleepmodeOn_baby_preview_highlighted_image] : [UIImage sleepmodeOn_camera_preview_highlighted_image];
        UIButton *sleepmodeBtn = [self bottomButtonWithImage:[UIImage sleepmodeOn_camera_preview_normal_image]
                                         highlightedImage:nil
                                            selectedImage:selectedImage
                                            disabledImage:[UIImage sleepmodeOn_camera_preview_disabled_image]
                                                    title:WYCameraToolPreviewNoneParameter
                                                   action:@selector(sleepmodeAction:)];

        [sleepmodeBtn setTitleColor:WY_FontColor_LightBlack forState:UIControlStateNormal];
        [sleepmodeBtn setTitleColor:WY_FontColor_LightGray forState:UIControlStateDisabled];
        _sleepmodeBtn = sleepmodeBtn;
        [self.middleNormalView addSubview:sleepmodeBtn];
    }
    return _sleepmodeBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        UIImage *image = _babyMonitor ? [UIImage imageNamed:@"btn_baby_preview_share_highlighted"] : [UIImage imageNamed:@"btn_camera_preview_share_highlighted"];
        UIButton *shareBtn = [self bottomButtonWithImage:[UIImage imageNamed:@"btn_camera_preview_share_normal"]
                                        highlightedImage:image
                                           selectedImage:image
                                           disabledImage:[UIImage imageNamed:@"btn_camera_preview_share_disabled"]
                                                   title:WYLocalString(@"Share")
                                                  action:@selector(shareAction:)];
        [shareBtn setTitleColor:WY_FontColor_LightBlack forState:UIControlStateNormal];
        [shareBtn setTitleColor:WY_FontColor_LightGray forState:UIControlStateDisabled];
        _shareBtn = shareBtn;
        [self.doorbell? self.middleBellView :self.middleNormalView  addSubview:shareBtn];
    }
    return _shareBtn;
}
- (UIButton *)PIRBtn {
    if (!_PIRBtn) {
        UIImage *image = [UIImage imageNamed:@"btn_doorbell_pir_highlighted"];
        UIButton *PIRBtn = [self bottomButtonWithImage:[UIImage imageNamed:@"btn_doorbell_pir_normal"]
                                        highlightedImage:image
                                           selectedImage:image
                                           disabledImage:[UIImage imageNamed:@"btn_doorbell_pir_disabled"]
                                                   title:WYLocalString(@"Pir Abbreviation")
                                                  action:@selector(PIRAction:)];
        [PIRBtn setTitleColor:WY_FontColor_LightBlack forState:UIControlStateNormal];
        [PIRBtn setTitleColor:WY_FontColor_SLightBlack forState:UIControlStateDisabled];
        [PIRBtn setTitleColor:WY_MainColor forState:UIControlStateSelected];
        [PIRBtn setTitleColor:WY_MainColor forState:UIControlStateHighlighted];

        _PIRBtn = PIRBtn;
        [self.middleBellView addSubview:PIRBtn];
    }
    return _PIRBtn;
}
- (UIButton *)jingleBellBtn {
    if (!_jingleBellBtn) {
        UIImage *image = [UIImage imageNamed:@"btn_doorbell_jinglebell_highlighted"];
        UIButton *btn = [self bottomButtonWithImage:[UIImage imageNamed:@"btn_doorbell_jinglebell_normal"]
                                      highlightedImage:image
                                         selectedImage:image
                                         disabledImage:[UIImage imageNamed:@"btn_doorbell_jinglebell_disabled"]
                                                 title:WYLocalString(@"Jingle Bell Remind Abbreviation")
                                                action:@selector(jingleBellAction:)];
        [btn setTitleColor:WY_FontColor_LightBlack forState:UIControlStateNormal];
        [btn setTitleColor:WY_FontColor_SLightBlack forState:UIControlStateDisabled];
        [btn setTitleColor:WY_MainColor forState:UIControlStateSelected];
        [btn setTitleColor:WY_MainColor forState:UIControlStateHighlighted];
        _jingleBellBtn = btn;
        [self.middleBellView addSubview:btn];
    }
    return _jingleBellBtn;
}
- (UIButton *)powerManagementBtn {
    if (!_powerManagementBtn) {
        UIImage *image = [UIImage imageNamed:@"btn_doorbell_power_highlighted"];
        UIButton *powerMBtn = [self bottomButtonWithImage:[UIImage imageNamed:@"btn_doorbell_power_normal"]
                                      highlightedImage:image
                                         selectedImage:image
                                         disabledImage:[UIImage imageNamed:@"btn_doorbell_power_disabled"]
                                                 title:WYLocalString(@"Low Power")
                                                action:@selector(powerManagementAction:)];
        [powerMBtn setTitleColor:WY_FontColor_LightBlack forState:UIControlStateNormal];
        [powerMBtn setTitleColor:WY_FontColor_SLightBlack forState:UIControlStateDisabled];
        [powerMBtn setTitleColor:WY_MainColor forState:UIControlStateSelected];
        [powerMBtn setTitleColor:WY_MainColor forState:UIControlStateHighlighted];
        _powerManagementBtn = powerMBtn;
        [self.middleBellView addSubview:powerMBtn];
    }
    return _powerManagementBtn;
}
- (UIView *)line1 {
    if (!_line1) {
        UIView *line1 = [UIView new];
        line1.backgroundColor = WY_LineColor_LightGray;
        [self.middleNormalView addSubview:line1];
        _line1 = line1;
    }
    return _line1;
}
- (UIView *)line2 {
    if (!_line2) {
        UIView *line2 = [UIView new];
        line2.backgroundColor = WY_LineColor_LightGray;
        [self.middleNormalView addSubview:line2];
        _line2 = line2;
    }
    return _line2;
}
- (UITableView *)sleepmodeMenuView {
    if (!_sleepmodeMenuView) {
        UITableView *view = [UITableView wy_tableViewWithDelegate:self];
        view.backgroundColor = [UIColor whiteColor];
        view.rowHeight = WY_iPhone_4 ? menuHeight-2 : menuHeight;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.layer.borderWidth = WY_1_PIXEL;
        view.layer.borderColor = WY_LineColor_LightGray.CGColor;
        view.backgroundColor = WY_BGColor_White_A;
        view.hidden = YES;
        view.allowsSelection = NO;
        view.scrollEnabled = NO;
        [self insertSubview:view belowSubview:self.middleNormalView];
        _sleepmodeMenuView = view;
    }
    return _sleepmodeMenuView;
}

- (UIView *)topView {
    if (!_topView) {
        UIView *view = [UIView new];
        [self insertSubview:view belowSubview:self.middleNormalView];
        _topView = view;
        UIImageView *imageView = [UIImageView new];
        [imageView wy_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage placeholder_device_image]];
        [view addSubview:imageView];
        self.deviceTypeImageView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@63).priority(751);
            make.height.lessThanOrEqualTo(view).with.offset(9);
            make.width.equalTo(imageView.mas_height).multipliedBy(1);
            make.leading.equalTo(view).with.offset(14);
            make.bottom.equalTo(view);
        }];
        NSString *totalString = [NSString stringWithFormat:@"%@:000:99KB/s  %@:%@", WYLocalString(@"Bit rate"), WYLocalString(@"Mode"), WYLocalString(@"Relay")];
        CGFloat w = [totalString sizeWithAttributes:@{NSFontAttributeName:WYFont_Text_S_Bold}].width;
        BOOL horizontal = w+63+2*14 <= WY_ScreenWidth;
        UILabel *bitrateLabel1 = [UILabel labelWithFrame:CGRectZero
                                                    text:[NSString stringWithFormat:@"%@:",WYLocalString(@"Bit rate")]
                                               textColor:WY_FontColor_Gray2
                                                textfont:WYFont_Text_S_Bold
                                           numberOfLines:0
                                           lineBreakMode:NSLineBreakByWordWrapping
                                           lineAlignment:NSTextAlignmentLeft
                                               sizeToFit:YES];
        [view addSubview:bitrateLabel1];
        [bitrateLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            if (horizontal) {
                make.leading.greaterThanOrEqualTo(imageView.mas_trailing).with.offset(15);
                make.leading.equalTo(view).with.offset(WY_ScreenWidth/3).priorityLow();
                make.centerY.equalTo(imageView.mas_centerY).with.offset((WY_iPhone_4 && _babyMonitor) ? -5 : 5);
                make.height.lessThanOrEqualTo(view);
            }else {
                make.leading.greaterThanOrEqualTo(imageView.mas_trailing).with.offset(15);
                make.leading.equalTo(view).with.offset(WY_ScreenWidth/3).priorityLow();
                make.centerY.equalTo(imageView.mas_centerY).with.offset((WY_iPhone_4 && _babyMonitor) ? -5 : 5);
                make.height.lessThanOrEqualTo(view);
            }
        }];
        UILabel *bitrateLabel2 = [UILabel labelWithFrame:CGRectZero
                                                    text:WYCameraToolPreviewNoneParameter
                                               textColor:WY_FontColor_Gray2
                                                textfont:WYFont_Text_S_Normal
                                           numberOfLines:0
                                           lineBreakMode:NSLineBreakByWordWrapping
                                           lineAlignment:NSTextAlignmentLeft
                                               sizeToFit:YES];
        [view addSubview:bitrateLabel2];
        self.bitrateLabel = bitrateLabel2;
        CGFloat bitrateLabelW2 = ((int)[@"99.99Kb/s" sizeWithAttributes:@{NSFontAttributeName:bitrateLabel2.font}].width+1.0);
        [bitrateLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bitrateLabel1);
            make.leading.equalTo(bitrateLabel1.mas_trailing);
            make.width.greaterThanOrEqualTo(@(bitrateLabelW2));
            make.height.lessThanOrEqualTo(view);
        }];
        
        UILabel *energyLabel1 = [UILabel labelWithFrame:CGRectZero
                                                 text:[NSString stringWithFormat:@"%@:",WYLocalString(@"Electricity")]
                                            textColor:WY_FontColor_Gray2
                                             textfont:WYFont_Text_S_Bold
                                        numberOfLines:0
                                        lineBreakMode:NSLineBreakByWordWrapping
                                        lineAlignment:NSTextAlignmentLeft
                                            sizeToFit:YES];
        [view addSubview:energyLabel1];
        [energyLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            if (horizontal) {
                make.leading.greaterThanOrEqualTo(bitrateLabel2.mas_trailing)
                .with.offset(15).priorityMedium();
                make.centerY.equalTo(bitrateLabel1);
                make.height.lessThanOrEqualTo(view);
            }else {
                make.leading.equalTo(bitrateLabel1);
                make.top.equalTo(bitrateLabel1.mas_bottom).with.offset(6);
                make.height.lessThanOrEqualTo(view);
            }
            if (!self.doorbell) {
                make.width.equalTo(@0);
            }
        }];
        UILabel *energyLabel2 = [UILabel labelWithFrame:CGRectZero
                                                 text:WYCameraToolPreviewNoneParameter
                                            textColor:WY_FontColor_Gray2
                                             textfont:WYFont_Text_S_Normal
                                        numberOfLines:0
                                        lineBreakMode:NSLineBreakByWordWrapping
                                        lineAlignment:NSTextAlignmentLeft
                                            sizeToFit:YES];
        [view addSubview:energyLabel2];
        self.energyLabel = energyLabel2;
        [energyLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(energyLabel1.mas_trailing);
            make.centerY.equalTo(energyLabel1);
            make.height.lessThanOrEqualTo(view);
            if (!self.doorbell) {
                make.width.equalTo(@0);
            }
        }];
        
        if (WY_iPhone_4 && _babyMonitor) {
            UILabel *tempLabel1 = [UILabel labelWithFrame:CGRectZero
                                                     text:[NSString stringWithFormat:@"%@:",WYLocalString(@"Temperature")]
                                                textColor:WY_FontColor_Gray2
                                                 textfont:WYFont_Text_S_Bold
                                            numberOfLines:0
                                            lineBreakMode:NSLineBreakByWordWrapping
                                            lineAlignment:NSTextAlignmentLeft
                                                sizeToFit:YES];
            [view addSubview:tempLabel1];
            [tempLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                if (horizontal) {
                    make.leading.greaterThanOrEqualTo(imageView.mas_trailing).with.offset(15);
                    make.leading.equalTo(view).with.offset(WY_ScreenWidth/3).priorityLow();
                    make.top.equalTo(bitrateLabel1.mas_bottom).with.offset(5);
                    make.height.lessThanOrEqualTo(view);
                }else {
                    make.leading.greaterThanOrEqualTo(imageView.mas_trailing).with.offset(15);
                    make.leading.equalTo(view).with.offset(WY_ScreenWidth/3).priorityLow();
                    make.top.equalTo(bitrateLabel1.mas_bottom).with.offset(5);
                    make.height.lessThanOrEqualTo(view);
                }
            }];
            UILabel *tempLabel2 = [UILabel labelWithFrame:CGRectZero
                                                     text:WYCameraToolPreviewNoneParameter
                                                textColor:WY_FontColor_Gray2
                                                 textfont:WYFont_Text_S_Normal
                                            numberOfLines:0
                                            lineBreakMode:NSLineBreakByWordWrapping
                                            lineAlignment:NSTextAlignmentLeft
                                                sizeToFit:YES];
            [view addSubview:tempLabel2];
            self.tempLabel = tempLabel2;
            CGFloat tempLabelW2 = ((int)[@"99.99Kb/s" sizeWithAttributes:@{NSFontAttributeName:tempLabel2.font}].width+1.0);
            [tempLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempLabel1);
                make.leading.equalTo(tempLabel1.mas_trailing);
                make.width.greaterThanOrEqualTo(@(tempLabelW2));
                make.height.lessThanOrEqualTo(view);
            }];
            
            UILabel *humidityLabel1 = [UILabel labelWithFrame:CGRectZero
                                                         text:[NSString stringWithFormat:@"%@:",WYLocalString(@"Humidity")]
                                                    textColor:WY_FontColor_Gray2
                                                     textfont:WYFont_Text_S_Bold
                                                numberOfLines:0
                                                lineBreakMode:NSLineBreakByWordWrapping
                                                lineAlignment:NSTextAlignmentLeft
                                                    sizeToFit:YES];
            [view addSubview:humidityLabel1];
            [humidityLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(tempLabel1);
                make.top.equalTo(tempLabel1.mas_bottom).with.offset(6);
                make.height.lessThanOrEqualTo(view);
            }];
            UILabel *humidityLabel2 = [UILabel labelWithFrame:CGRectZero
                                                         text:WYCameraToolPreviewNoneParameter
                                                    textColor:WY_FontColor_Gray2
                                                     textfont:WYFont_Text_S_Normal
                                                numberOfLines:0
                                                lineBreakMode:NSLineBreakByWordWrapping
                                                lineAlignment:NSTextAlignmentLeft
                                                    sizeToFit:YES];
            [view addSubview:humidityLabel2];
            self.humidityLabel = humidityLabel2;
            [humidityLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(humidityLabel1.mas_trailing);
                make.centerY.equalTo(humidityLabel1);
                make.height.lessThanOrEqualTo(view);
            }];
        }
    }
    return _topView;
}
- (UIView *)middleNormalView {
    if (!_middleNormalView) {
        UIView *view = [UIView new];
        [self addSubview:view];
        _middleNormalView = view;
    }
    return _middleNormalView;
}
- (UIView *)middleBellView {
    if (!_middleBellView) {
        UIView *view = [UIView new];
        [self addSubview:view];
        _middleBellView = view;
    }
    return _middleBellView;
}
- (WYCameraToolPreviewBabyView *)babyView {
    if (!_babyView) {
        WYCameraToolPreviewBabyView *view = [WYCameraToolPreviewBabyView new];
        view.backgroundColor = WY_BGColor_LightGray;
        [self.trhView addSubview:view];
        _babyView = view;
    }
    return _babyView;
}
- (WYCameraFullDuplexVoiceView *)fullDuplexVoiceView {
    if (!_fullDuplexVoiceView) {
        WYCameraFullDuplexVoiceView *view = [WYCameraFullDuplexVoiceView new];
        [self insertSubview:view atIndex:0];
        self.fullDuplexVoiceView = view;
    }
    return _fullDuplexVoiceView;
}
- (NSArray *)originalSource {
    if (!_originalSource) {
        if (_babyMonitor) {
            _originalSource = @[[WYCameraToolPreviewSleepmodeModel baby_onModel],
                                [WYCameraToolPreviewSleepmodeModel baby_offModel],
                                [WYCameraToolPreviewSleepmodeModel baby_offByTimeModel]
                                ];
        }else {
            _originalSource = @[[WYCameraToolPreviewSleepmodeModel onModel],
                                [WYCameraToolPreviewSleepmodeModel offModel],
                                [WYCameraToolPreviewSleepmodeModel offByTimeModel]
                                ];
        }
    }
    return _originalSource;
}

- (UIView *)trhView {
    if (!_trhView) {
        UIView *v = [UIView new];
        v.backgroundColor = WY_BGColor_LightGray;
        [self insertSubview:v atIndex:0];
        _trhView = v;
    }
    return _trhView;
}
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.trhView addSubview:v];
        _indicatorView = v;
    }
    return _indicatorView;
}
- (UILabel *)trhLabel {
    if (!_trhLabel) {
        UILabel *l = [UILabel labelWithFrame:CGRectZero
                                       text:@"正在获取温湿度..."
                                  textColor:WY_FontColor_Gray
                                   textfont:WYFont_Text_S_Normal
                              numberOfLines:0
                              lineBreakMode:NSLineBreakByWordWrapping
                              lineAlignment:NSTextAlignmentLeft
                                  sizeToFit:NO];
        [self.trhView addSubview:l];
        _trhLabel = l;
    }
    return _trhLabel;
}

#pragma mark -- Init
- (void)initSet {
    _babyMonitor = WY_CameraM.babyMonitor;
    if (_babyMonitor) {
        [self showTRHEmpty];
    }
}
- (BOOL)doorbell {
    return self.deviceType == MeariDeviceSubTypeIpcBell;
}
- (void)initAdvancedSet {
    if (self.doorbell) {
        [self setPIROpen:NO enabled:NO];
        [self setJingleBellOpen:NO enabled:NO];
        [self setShareEnabled:NO];
    } else {
        [self setShareEnabled:NO];
        [self setAlarmLevel:MeariDeviceLevelNone enabled:NO];
        [self setSleepmode:MeariDeviceSleepmodeUnknown enabled:NO reset:YES];
    }
}
- (void)setLayout {
    if (self.deviceType == MeariDeviceSubTypeIpcBell) {
        [self initLayoutBell];
    }else {
        [self initLayout];
    }
}
- (void)initLayout {
    MASAttachKeys(self.motionBtn, self.sleepmodeBtn, self.shareBtn);
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@54).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    
    [self.middleNormalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.topView.mas_bottom).with.offset(20).priorityHigh();
            make.leading.and.trailing.equalTo(weakSelf);
            make.height.equalTo(@32).priorityHigh();
            make.height.lessThanOrEqualTo(weakSelf);
    }];
    
    if (self.deviceType == MeariDeviceSubTypeIpcBaby && !WY_iPhone_4) {
        [self.trhView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.middleNormalView.mas_bottom).offset(10);
            make.leading.trailing.bottom.equalTo(weakSelf);
        }];
        [self.babyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.trhView);
        }];
    }
    
    CGFloat extraWidth = 22 + 20 + 30;
    CGFloat motionStringWidth = [@[WYLocalString(@"motion_on"),
                                   WYLocalString(@"motion_off"),
                                   ] wy_maxWidthWithFont:self.motionBtn.titleLabel.font]+extraWidth;
    CGFloat sleepStringWidth = [@[WYLocalString(@"sleepmodeLensOn"),
                                  WYLocalString(@"sleepmodeLensOff"),
                                  WYLocalString(@"sleepmodeLensOffByTime"),
                                  ] wy_maxWidthWithFont:self.sleepmodeBtn.titleLabel.font]+extraWidth;
    CGFloat shareStringWidth = [@[WYLocalString(@"Share"),
                                  ] wy_maxWidthWithFont:self.shareBtn.titleLabel.font]+extraWidth;
    CGFloat surplusWidth = WY_ScreenWidth-motionStringWidth-sleepStringWidth-shareStringWidth;
    motionStringWidth += surplusWidth/3;
    sleepStringWidth += surplusWidth/3;
    shareStringWidth += surplusWidth/3;
    [self.motionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(motionStringWidth);
        make.top.bottom.leading.equalTo(weakSelf.middleNormalView);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.sleepmodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sleepStringWidth-10);
        make.leading.equalTo(weakSelf.motionBtn.mas_trailing).offset(10);
        make.top.bottom.equalTo(weakSelf.middleNormalView);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(shareStringWidth);
        make.top.bottom.trailing.equalTo(weakSelf.middleNormalView);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WY_1_PIXEL));
        make.height.equalTo(@25).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerY.equalTo(weakSelf.middleNormalView);
        make.trailing.equalTo(weakSelf.motionBtn);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WY_1_PIXEL));
        make.height.equalTo(@25).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerY.equalTo(weakSelf.middleNormalView);
        make.trailing.equalTo(weakSelf.sleepmodeBtn);
    }];
    [self.sleepmodeMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((3)*(WY_iPhone_4 ? menuHeight-2 : menuHeight)));
        make.leading.equalTo(weakSelf.line1.mas_trailing);
        make.trailing.equalTo(weakSelf.line2.mas_leading);
        if (WY_iPhone_4) {
            make.bottom.equalTo(weakSelf.middleNormalView.mas_top);
        }else {
            make.top.equalTo(weakSelf.middleNormalView.mas_bottom);
        }
    }];
}
- (void)initLayoutBell {
    MASAttachKeys(self.PIRBtn, self.jingleBellBtn, self.shareBtn);
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@54).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    
    [self.middleBellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topView.mas_bottom).with.offset(20).priorityHigh();
        make.leading.and.trailing.equalTo(weakSelf);
        make.height.equalTo(@32).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    if(self.deviceType == MeariDeviceSubTypeIpcBell && !WY_iPhone_4) {
        [self.fullDuplexVoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.middleBellView.mas_bottom);
            make.leading.trailing.bottom.equalTo(weakSelf);
        }];
    }
    [self.PIRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.middleBellView).multipliedBy(1.0/2);
        make.top.bottom.leading.equalTo(weakSelf.middleBellView);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.middleBellView).multipliedBy(1.0/2);
        make.top.bottom.trailing.equalTo(weakSelf.middleBellView);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WY_1_PIXEL));
        make.height.equalTo(@25).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerY.equalTo(weakSelf.middleBellView);
        make.trailing.equalTo(weakSelf.PIRBtn);
    }];
}

#pragma mark -- Utilities
- (UIButton *)bottomButtonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage disabledImage:(UIImage *)disabledImage title:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [btn setImage:disabledImage forState:UIControlStateDisabled];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:WY_FontColor_LightBlack forState:UIControlStateNormal];
    [btn setTitleColor:_babyMonitor ? WY_FontColor_DarkOrange : WY_FontColor_Cyan forState:UIControlStateHighlighted];
    [btn setTitleColor:_babyMonitor ? WY_FontColor_DarkOrange : WY_FontColor_Cyan forState:UIControlStateSelected];
    btn.titleLabel.font = WYFont_Text_S_Bold;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    if (action) {
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
- (void)showRTHDes:(NSString *)text loading:(BOOL)loading {
    self.trhLabel.hidden = NO;
    self.trhLabel.text = text;
    WY_WeakSelf
    if (!loading) {
        self.indicatorView.hidden = YES;
        self.trhLabel.textAlignment = NSTextAlignmentCenter;
        [self.trhLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.trhView).offset(-30);
            make.center.equalTo(weakSelf.trhView);
            make.height.equalTo(weakSelf.trhView).offset(-30);
        }];
        return;
    }
    
    self.indicatorView.hidden = NO;
    self.trhLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat w = WY_ScreenWidth - 75;
    CGFloat h = [self.trhLabel ajustedHeightWithWidth:w];
    if (h > 20) {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.trhView).offset(15);
            make.size.mas_equalTo(CGSizeMake(37, 37));
            make.centerY.equalTo(weakSelf.trhView);
        }];
        [self.trhLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.indicatorView.mas_trailing).offset(8);
            make.size.mas_equalTo(CGSizeMake(w, h));
            make.centerY.equalTo(weakSelf.trhView);
        }];
    }else {
        [self.trhLabel sizeToFit];
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(weakSelf.trhView);
        }];
        [self.trhLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.indicatorView.mas_trailing).offset(8);
            make.size.mas_equalTo(weakSelf.trhLabel.size);
            make.centerY.equalTo(weakSelf.trhView);
            make.centerX.equalTo(weakSelf.trhView).offset(22);
        }];
    }
    [self.indicatorView startAnimating];
}

#pragma mark -- Life
- (instancetype)initWithDeviceType:(MeariDeviceSubType)deviceType {
    if (self = [super init]) {
        self.deviceType = deviceType;
        [self initSet];
        [self setLayout];
        [self initAdvancedSet];
    }
    return self;
}

#pragma mark -- Action
- (void)alarmAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPreviewView:didTapedAlarmButton:)]) {
        [self.delegate WYCameraToolPreviewView:self didTapedAlarmButton:sender];
    }
}
- (void)sleepmodeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPreviewViewAllowSetSleepmode)]) {
        if (![self.delegate WYCameraToolPreviewViewAllowSetSleepmode]) return;
    }
    self.showMenu = !self.showMenu;
}
- (void)shareAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPreviewView:didTapedShareButton:)]) {
        [self.
         delegate WYCameraToolPreviewView:self didTapedShareButton:sender];
    }
}
- (void)PIRAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPreviewView:didTapedPIRButton:)]) {
        [self.delegate WYCameraToolPreviewView:self didTapedPIRButton:sender];
    }
}
- (void)jingleBellAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPreviewView:didTapedJingleBellButton:)]) {
        [self.delegate WYCameraToolPreviewView:self didTapedJingleBellButton:sender];
    }
}
- (void)powerManagementAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPreviewView:didTapedPowerManagementButton:)]) {
        [self.delegate WYCameraToolPreviewView:self didTapedPowerManagementButton:sender];
    }
}
- (void)btnAction:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.sleepmodeMenuView indexPathForCell:cell];
    WYCameraToolPreviewSleepmodeModel *model = self.dataSource[indexPath.row];
    WYCameraToolPreviewSleepmodeModel *originalModel;
    for (WYCameraToolPreviewSleepmodeModel *m in self.originalSource) {
        if (![self.dataSource containsObject:m]) {
            originalModel = m;
            break;
        }
    }
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPreviewView:didTapedSleepmodeButton:model:originalType:)]) {
        [self.delegate WYCameraToolPreviewView:self didTapedSleepmodeButton:sender model:model originalType:originalModel.type];
    }
    model.highlighted = YES;
    [self.sleepmodeMenuView reloadData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.showMenu = NO;
}

#pragma mark - Delegate
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"c"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"c"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000;
        btn.titleLabel.font = WYFont_Text_S_Bold;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitleColor:WY_FontColor_Black forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
        btn.contentHorizontalAlignment = WY_BundleCH ? UIControlContentHorizontalAlignmentCenter: UIControlContentHorizontalAlignmentLeft;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell).insets(UIEdgeInsetsMake(0, 10, 0, 0));
        }];
        [cell addLineViewAtBottom];
    }
    UIButton *b = [cell viewWithTag:1000];
    WYCameraToolPreviewSleepmodeModel *model = self.dataSource[indexPath.row];
    [b setImage:model.normalImage forState:UIControlStateNormal];
    [b setImage:model.highlightedImage forState:UIControlStateHighlighted];
    [b setImage:model.highlightedImage forState:UIControlStateSelected];
    [b setImage:model.disabledImage forState:UIControlStateDisabled];
    [b setTitle:model.text forState:UIControlStateNormal];
    [b setTitleColor:model.highlightedColor forState:UIControlStateHighlighted];
    [b setTitleColor:model.highlightedColor forState:UIControlStateSelected];
    b.selected = model.highlighted;
    return cell;
}

#pragma mark - Public
- (void)setBitrate:(NSString *)bitrate {
    self.bitrateLabel.text = bitrate ? bitrate : WYCameraToolPreviewNoneParameter;
}
- (void)setEnergy:(NSString *)energy {
    self.energyLabel.text = energy ? energy : WYCameraToolPreviewNoneParameter;
}
- (void)setTemperature:(CGFloat)temperature {
    _babyView.temperature = temperature;
    if (WY_iPhone_4) {
        [WYCameraToolPreviewBabyView ajustedTemperature:&temperature];
        self.tempLabel.text = [NSString stringWithFormat:@"%.1lf℃",temperature];
        self.tempLabel.textColor = WY_FontColor_DarkOrange;
    }
}
- (void)setHumidity:(CGFloat)humidity {
    _babyView.humidity = humidity;
    if (WY_iPhone_4) {
        [WYCameraToolPreviewBabyView ajustedHumidity:&humidity];
        self.humidityLabel.text = [NSString stringWithFormat:@"%.1lf%%RH",humidity];
        self.humidityLabel.textColor = WY_FontColor_Cyan;
    }
}
- (void)setAlarmLevel:(MeariDeviceLevel)level enabled:(BOOL)enabled {
    
    self.motionBtn.enabled = enabled;
    UIControlState state = enabled ? UIControlStateNormal : UIControlStateDisabled;
    switch (level) {
        case MeariDeviceLevelNone: {
            [self.motionBtn setTitle:WYCameraToolPreviewNoneParameter forState:state];
            self.motionBtn.selected = NO;
            break;
        }
        case MeariDeviceLevelOff: {
            [self.motionBtn setTitle:WYLocalString(@"motion_off") forState: state];
            self.motionBtn.selected = NO;
            break;
        }
        case MeariDeviceLevelLow: {
            [self.motionBtn setTitle:WYLocalString(@"motion_on") forState: state];
            self.motionBtn.selected = enabled;
            break;
        }
        case MeariDeviceLevelMedium: {
            [self.motionBtn setTitle:WYLocalString(@"motion_on") forState: state];
            self.motionBtn.selected = enabled;
            break;
        }
        case MeariDeviceLevelHigh: {
            [self.motionBtn setTitle:WYLocalString(@"motion_on") forState: state];
            self.motionBtn.selected = enabled;
            break;
        }
        default:
            break;
    }
    
}
- (void)setSleepmode:(MeariDeviceSleepmode)type enabled:(BOOL)enabled reset:(BOOL)reset {
    self.dataSource = self.originalSource.mutableCopy;
    WYCameraToolPreviewSleepmodeModel *model;
    for (WYCameraToolPreviewSleepmodeModel *m in self.dataSource) {
        m.highlighted = NO;
        if (m.type == type) {
            model = m;
            break;
        }
    }
    if (!model) {
        UIImage *highlightedImage = _babyMonitor ? [UIImage sleepmodeOn_baby_preview_highlighted_image] : [UIImage sleepmodeOn_camera_preview_highlighted_image];
        [self.sleepmodeBtn setImage:[UIImage sleepmodeOn_camera_preview_normal_image] forState:UIControlStateNormal];
        [self.sleepmodeBtn setImage:highlightedImage forState:UIControlStateHighlighted | UIControlStateSelected];
        [self.sleepmodeBtn setImage:[UIImage sleepmodeOn_camera_preview_disabled_image] forState:UIControlStateDisabled];
        self.sleepmodeBtn.enabled = enabled;
        self.sleepmodeBtn.selected = !reset;
        [self.sleepmodeBtn setTitle:WYCameraToolPreviewNoneParameter forState:UIControlStateNormal];
        [self.sleepmodeBtn setTitle:WYCameraToolPreviewNoneParameter forState:UIControlStateDisabled];
        WY_WeakSelf
        [self.sleepmodeMenuView reloadData];
        [self.sleepmodeMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@((weakSelf.dataSource.count)*(WY_iPhone_4 ? menuHeight-2 : menuHeight)));
        }];
        return;
    }
    [self.sleepmodeBtn setImage:model.normalImage forState:UIControlStateNormal];
    [self.sleepmodeBtn setImage:model.highlightedImage forState:UIControlStateHighlighted];
    [self.sleepmodeBtn setImage:model.highlightedImage forState:UIControlStateSelected];
    [self.sleepmodeBtn setImage:model.disabledImage forState:UIControlStateDisabled];
    self.sleepmodeBtn.enabled = enabled;
    [self.sleepmodeBtn setTitle:reset ? WYCameraToolPreviewNoneParameter : model.text forState:enabled ? UIControlStateNormal : UIControlStateDisabled];
    self.sleepmodeBtn.selected = !reset;
    [self.dataSource removeObject:model];
    
    WY_WeakSelf
    [self.sleepmodeMenuView reloadData];
    [self.sleepmodeMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((weakSelf.dataSource.count)*(WY_iPhone_4 ? menuHeight-2 : menuHeight)));
    }];
}
- (void)setSleepmodeParam:(MeariDeviceParam *)param enabled:(BOOL)enabled reset:(BOOL)reset {
    for (WYCameraToolPreviewSleepmodeModel *model in self.originalSource) {
        model.hasHomeSleeptime = param.sleep_time.count > 0;
    }
    [self setSleepmode:param.sleepmode enabled:enabled reset:reset];
}
- (void)setShareEnabled:(BOOL)enabled {
    self.shareBtn.enabled = enabled;
}
- (void)setSettingHidden:(BOOL)hidden {
    self.middleNormalView.hidden = hidden;
    self.middleBellView.hidden = hidden;
}
- (void)setShowMenu:(BOOL)showMenu {
    if (_showMenu == showMenu) return;
    
    _showMenu = showMenu;
    [self.sleepmodeMenuView wy_animationByAlphaWithDuration:0.2 show:showMenu];
    
    self.sleepmodeBtn.contentHorizontalAlignment = WY_BundleCH ? UIControlContentHorizontalAlignmentCenter : (showMenu ?  UIControlContentHorizontalAlignmentLeft: UIControlContentHorizontalAlignmentCenter);
    for (WYCameraToolPreviewSleepmodeModel *model in self.dataSource) {
        model.highlighted = NO;
    }
    [self.sleepmodeMenuView reloadData];
}
#pragma mark - doorbell
- (void)setPIROpen:(BOOL)open enabled:(BOOL)enabled {
    self.PIRBtn.selected = open;
    self.PIRBtn.enabled = enabled;
}
- (void)setJingleBellOpen:(BOOL)open enabled:(BOOL)enabled {
    self.jingleBellBtn.selected = open;
    self.jingleBellBtn.enabled = enabled;
}
- (void)setLowPowerOpen:(BOOL)open enabled:(BOOL)enabled {
    self.powerManagementBtn.selected = open;
    self.powerManagementBtn.enabled = enabled;
}

- (void)resetToNormal {
    self.showMenu = NO;
}

- (void)showTRHEmpty {
    self.babyView.hidden = YES;
    self.tempLabel.hidden = YES;
    self.humidityLabel.hidden = YES;
    self.trhLabel.hidden = YES;
    self.indicatorView.hidden = YES;
}
- (void)showTRHLoading {
    if (_loading) return;
    _loading = YES;
    if (WY_iPhone_4) {
        self.babyView.hidden = self.trhLabel.hidden = self.indicatorView.hidden = YES;
        self.tempLabel.hidden = self.humidityLabel.hidden = NO;
        self.tempLabel.text = self.humidityLabel.text = WYLocalString(@"device_rth_getting_4s");
    }else {
        self.babyView.hidden = !(self.trhLabel.hidden = self.indicatorView.hidden = NO);
        [self showRTHDes:WYLocalString(@"device_rth_getting") loading:YES];
    }
}
- (void)showTFail {
    self.trhLabel.hidden = self.indicatorView.hidden = YES;
    if (WY_iPhone_4) {
        self.tempLabel.hidden = NO;
        self.tempLabel.text = WYCameraToolPreviewNoneParameter;
        self.babyView.hidden = YES;
    }else {
        self.babyView.hidden = NO;
        [self.babyView showTError];
    }
}
- (void)showRHFail {
    self.trhLabel.hidden = self.indicatorView.hidden = YES;
    if (WY_iPhone_4) {
        self.humidityLabel.hidden = NO;
        self.humidityLabel.text = WYCameraToolPreviewNoneParameter;
        self.babyView.hidden = YES;
    }else {
        self.babyView.hidden = NO;
        [self.babyView showRHError];
    }
}
- (void)showTNone {
    if (WY_iPhone_4) {
        self.babyView.hidden = self.trhLabel.hidden = self.indicatorView.hidden = YES;
        self.tempLabel.hidden = self.humidityLabel.hidden = NO;
        self.tempLabel.text = self.humidityLabel.text = WYLocalString(@"device_rth_getFail_4s");
    }else {
        self.babyView.hidden = YES;
        self.indicatorView.hidden = YES;
        self.trhLabel.hidden = NO;
        [self showRTHDes:WYLocalString(@"device_rth_getFail") loading:NO];
    }
}
- (void)showRHNone {
    [self showTNone];
}
- (void)showT:(CGFloat)temp rh:(CGFloat)humidity {
    [self showT:temp];
    [self showRH:humidity];
}
- (void)showT:(CGFloat)temp {
    self.trhLabel.hidden = YES;
    self.indicatorView.hidden = YES;
    self.babyView.hidden = NO;
    self.tempLabel.hidden = NO;
    self.humidityLabel.hidden = NO;
    [self setTemperature:temp];
}
- (void)showRH:(CGFloat)humidity {
    self.trhLabel.hidden = YES;
    self.indicatorView.hidden = YES;
    self.babyView.hidden = NO;
    self.tempLabel.hidden = NO;
    self.humidityLabel.hidden = NO;
    [self setHumidity:humidity];
}
@end

@implementation WYCameraToolPreviewSleepmodeModel
- (instancetype)initWithDeviceType:(MeariDeviceType)deviceType {
    self = [super init];
    if (self) {
        self.type = MeariDeviceSleepmodeUnknown;
    }
    return self;
}
+ (instancetype)modelWithType:(MeariDeviceSleepmode)type text:(NSString *)text normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage highlightedColor:(UIColor *)highlightedColor {
    WYCameraToolPreviewSleepmodeModel *model = [WYCameraToolPreviewSleepmodeModel new];
    model.type = type;
    model.text = text;
    model.normalImage = normalImage;
    model.highlightedImage = highlightedImage;
    model.highlightedColor = highlightedColor;
    model.highlighted = NO;
    return model;
}

+ (instancetype)onModel {
    return [self modelWithType:MeariDeviceSleepmodeLensOn
                          text:WYLocalString(@"sleepmodeLensOn")
                   normalImage:[UIImage sleepmodeOn_camera_preview_normal_image]
              highlightedImage:[UIImage sleepmodeOn_camera_preview_highlighted_image]
            disabledImage:[UIImage sleepmodeOn_camera_preview_disabled_image]
              highlightedColor:WY_FontColor_Cyan];
}
+ (instancetype)offModel {
    return [self modelWithType:MeariDeviceSleepmodeLensOff
                          text:WYLocalString(@"sleepmodeLensOff")
                   normalImage:[UIImage sleepmodeOff_camera_preview_normal_image]
              highlightedImage:[UIImage sleepmodeOff_camera_preview_highlighted_image]
                 disabledImage:[UIImage sleepmodeOff_camera_preview_disabled_image]
              highlightedColor:WY_FontColor_Cyan];
}
+ (instancetype)offByTimeModel {
    return [self modelWithType:MeariDeviceSleepmodeLensOffByTime
                          text:WYLocalString(@"sleepmodeLensOffByTime")
                   normalImage:[UIImage sleepmodeOffByTime_camera_preview_normal_image]
              highlightedImage:[UIImage sleepmodeOffByTime_camera_preview_highlighted_image]
                 disabledImage:[UIImage sleepmodeOffByTime_camera_preview_disabled_image]
              highlightedColor:WY_FontColor_Cyan];
}

+ (instancetype)baby_onModel {
    WYCameraToolPreviewSleepmodeModel *model = [self onModel];
    model.highlightedColor = WY_FontColor_DarkOrange;
    model.highlightedImage = [UIImage sleepmodeOn_baby_preview_highlighted_image];
    return model;
}
+ (instancetype)baby_offModel {
    WYCameraToolPreviewSleepmodeModel *model = [self offModel];
    model.highlightedColor = WY_FontColor_DarkOrange;
    model.highlightedImage = [UIImage sleepmodeOff_baby_preview_highlighted_image];
    return model;
}
+ (instancetype)baby_offByTimeModel {
    WYCameraToolPreviewSleepmodeModel *model = [self offByTimeModel];
    model.highlightedColor = WY_FontColor_DarkOrange;
    model.highlightedImage = [UIImage sleepmodeOffByTime_baby_preview_highlighted_image];
    return model;
}

@end
