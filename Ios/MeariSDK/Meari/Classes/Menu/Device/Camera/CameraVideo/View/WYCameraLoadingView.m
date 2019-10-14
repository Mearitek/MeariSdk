//
//  WYCameraLoadingView.m
//  Meari
//
//  Created by 李兵 on 2016/11/30.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraLoadingView.h"


@interface WYCameraLoadingView ()
@property (nonatomic, weak)UIView *backView;
@property (nonatomic, weak)UIView *backLabelView;
@property (nonatomic, weak)UILabel *backLabel;
@property (nonatomic, weak)UIImageView *loadingImageView;
@property (nonatomic, weak)UILabel *loadingLabel;
@property (nonatomic, strong)NSTimer *loadingTimer;

@end

@implementation WYCameraLoadingView
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)backView {
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor blackColor];
        [self addSubview:view];
        _backView = view;
    }
    return _backView;
}
- (UIView *)backLabelView {
    if (!_backLabelView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 15;
        view.layer.borderWidth = 1;
        view.layer.borderColor = WY_FontColor_Cyan.CGColor;
        [self addSubview:view];
        _backLabelView = view;
    }
    return _backLabelView;
}
- (UILabel *)backLabel {
    if (!_backLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:nil
                                       textColor:WY_FontColor_Cyan
                                        textfont:WYFont_Text_XS_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByWordWrapping
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:NO];
        [self addSubview:label];
        _backLabel = label;
    }
    return _backLabel;
}
- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        UIImageView *imageV = [UIImageView new];
        imageV.backgroundColor = [UIColor clearColor];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.image = self.loadingImage;
        imageV.layer.shadowColor = [UIColor blackColor].CGColor;
        imageV.layer.shadowRadius = 3.0f;
        imageV.layer.shadowOpacity = 0.5f;
        imageV.layer.shadowOffset = CGSizeMake(0, 0);
        [self addSubview:imageV];
        _loadingImageView = imageV;
    }
    return _loadingImageView;
}
- (UILabel *)loadingLabel {
    if (!_loadingLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:WYLocalString(@"waiting")
                                       textColor:[UIColor whiteColor]
                                        textfont:WYFont_Text_XXS_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByTruncatingTail
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:YES];
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        _loadingLabel = label;
    }
    return _loadingLabel;
}
- (NSTimer *)loadingTimer {
    if (!_loadingTimer) {
        _loadingTimer = [NSTimer timerInLoopWithInterval:0.05 target:self selector:@selector(timerToLoading:)];
    }
    return _loadingTimer;
}

#pragma mark -- Init
- (void)initSet {
    self.hidden = YES;
    self.showLoadingText = YES;
    self.loadingImage = [UIImage loadingImage];
    [self addTapGestureTarget:self action:@selector(tapAction:)];
}
- (void)initLayout {
    WY_WeakSelf
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.backLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 30));
        make.center.equalTo(weakSelf);
    }];
    [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.backLabelView).offset(-40);
        make.height.equalTo(weakSelf.backLabelView);
        make.center.equalTo(weakSelf);
    }];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.equalTo(weakSelf);
    }];
    [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];
}

#pragma mark -- Utilities
- (void)enableLoadingTimer:(BOOL)enabled {
    if (enabled) {
        if (!_loadingTimer) {
            [self.loadingTimer fire];
        }
    }else {
        if (_loadingTimer) {
            [_loadingTimer invalidate];
            _loadingTimer = nil;
        }
    }
}
- (void)ajustBackLabelSize {
    CGFloat maxW = self.width - 60;
    CGFloat maxH = self.height - 60;
    CGSize size = [self.backLabel sizeThatFits:CGSizeMake(maxW, maxH)];
    CGFloat w = size.width+size.height+30;
    w = floorf(w > maxW ? maxW : w)+1;
    CGFloat h = size.height+20;
    h = floorf(h > maxH ? maxH : h)+1;
    self.backLabelView.layer.cornerRadius = h/2;
    self.backLabelView.layer.masksToBounds = YES;
    WY_WeakSelf
    [self.backLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(w, h));
    }];
    [self.backLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.backLabelView).offset(-(h));
    }];
}


#pragma mark -- Life
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSet];
        [self initLayout];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSet];
    [self initLayout];
}

#pragma mark -- Action
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (self.loadingStatus != WYCameraLoadingStatusLoading) {
        if ([self.delegate respondsToSelector:@selector(WYCameraLoadingViewDidLoading:)]) {
            [self.delegate WYCameraLoadingViewDidLoading:self];
        }
    }
    [self showLoading];
}

#pragma mark -- Timer
- (void)timerToLoading:(NSTimer *)sender {
    self.loadingImageView.layer.transform = CATransform3DRotate(self.loadingImageView.layer.transform, M_PI / 10.0f, 0, 0, 1);
}

#pragma mark - Delegate
#pragma mark - Public
- (void)setLoadingStatus:(WYCameraLoadingStatus)loadingStatus {
    self.backView.hidden = self.backLabelView.hidden = self.backLabel.hidden = YES;
    if (_loadingStatus == loadingStatus) return;
    _loadingStatus = loadingStatus;
    switch (_loadingStatus) {
        case WYCameraLoadingStatusLoading: {
            self.hidden = NO;
            self.userInteractionEnabled = NO;
            self.loadingImageView.hidden = NO;
            self.loadingImageView.image = self.loadingImage;
            self.loadingLabel.hidden = NO;
            [self enableLoadingTimer:YES];
            break;
        }
        case WYCameraLoadingStatusEmpty: {
            self.hidden = YES;
            self.userInteractionEnabled = YES;
            self.loadingImageView.hidden = YES;
            self.loadingImageView.image = self.loadingImage;
            self.loadingLabel.hidden = YES;
            [self enableLoadingTimer:NO];
            break;
        }
        case WYCameraLoadingStatusFailed: {
            self.hidden = NO;
            self.userInteractionEnabled = YES;
            self.loadingImageView.hidden = NO;
            self.loadingImageView.image = [UIImage imageNamed:@"img_offline"];
            self.loadingLabel.hidden = YES;
            [self enableLoadingTimer:NO];
            break;
        }
        case WYCameraLoadingStatusSuccessfull: {
            self.hidden = YES;
            self.userInteractionEnabled = YES;
            self.loadingImageView.hidden = YES;
            self.loadingImageView.userInteractionEnabled = NO;
            self.loadingImageView.image = self.loadingImage;
            self.loadingLabel.hidden = YES;
            [self enableLoadingTimer:NO];
            break;
        }
            
        default:
            break;
    }
    if (!self.showLoadingText) {
        self.loadingLabel.hidden = YES;
    }
}
- (void)showText:(NSString *)text stytle:(WYUIStytle)stytle {
    self.loadingStatus = WYCameraLoadingStatusEmpty;
    self.hidden = self.backView.hidden = self.backLabelView.hidden = self.backLabel.hidden = NO;
    self.userInteractionEnabled = NO;
    self.backLabel.text = text;
    switch (stytle) {
        case WYUIStytleCyan: {
            self.backLabel.layer.borderColor = WY_FontColor_Cyan.CGColor;
            self.backLabel.textColor = WY_FontColor_Cyan;
            self.backLabelView.layer.borderColor = WY_FontColor_Cyan.CGColor;
            break;
        }
        case WYUIStytleOrange: {
            self.backLabel.layer.borderColor = WY_FontColor_DarkOrange.CGColor;
            self.backLabel.textColor = WY_FontColor_DarkOrange;
            self.backLabelView.layer.borderColor = WY_FontColor_DarkOrange.CGColor;
            break;
        }
        default:
            break;
    }
    [self ajustBackLabelSize];
}


@end
