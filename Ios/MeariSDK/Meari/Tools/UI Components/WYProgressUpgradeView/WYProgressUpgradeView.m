//
//  WYProgressUpgradeView.m
//  ProgressGourpView
//
//  Created by 李兵 on 2016/12/8.
//  Copyright © 2016年 李兵. All rights reserved.
//

#import "WYProgressUpgradeView.h"
#import "WYProgressCircleView.h"

@interface WYProgressUpgradeView ()
{
    SEL _beginAction;
    SEL _endAction;
    BOOL _end;
}
@property (nonatomic, weak)WYProgressCircleView *circleView;
@property (nonatomic, weak)UIButton *btn;
@property (nonatomic, weak)UILabel *label;
@property (nonatomic, assign)CGRect originalBtnBounds;
@property (nonatomic, copy)NSString *beginString;
@property (nonatomic, copy)NSString *endString;
@property (nonatomic, copy)NSString *prepareString;



@end

@implementation WYProgressUpgradeView
#pragma mark - Private
#pragma mark -- Getter
- (WYProgressCircleView *)circleView {
    if (!_circleView) {
        WYProgressCircleView *view = [WYProgressCircleView new];
        [self addSubview:view];
        _circleView = view;
    }
    return _circleView;
}
- (UIButton *)btn {
    if (!_btn) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.wy_highlightedBGImage = [UIImage bgGreenImage];
        b.wy_highlightedTitleColor = [UIColor whiteColor];
        b.wy_normalTitleColor = WY_MainColor;
        [self addSubview:b];
        _btn = b;
    }
    return _btn;
}
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = WY_FontColor_Cyan;
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

#pragma mark -- Init
- (void)_initSet {
    self.btn.hidden = NO;
    self.label.hidden = NO;
    self.circleView.hidden = YES;
    self.originalBtnBounds = CGRectMake(0, 0, WY_ScreenWidth*0.7, 40);
    [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)_initLayout {
    __weak typeof (self) weakSelf = self;
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.lessThanOrEqualTo(weakSelf);
        make.height.equalTo(@40);
        make.width.equalTo(weakSelf).multipliedBy(0.7);
        make.center.equalTo(weakSelf);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.btn);
    }];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf);
        make.width.equalTo(weakSelf.circleView.mas_height).multipliedBy(1.0);
        make.center.equalTo(weakSelf);
    }];
}

#pragma mark -- Life
- (void)initAction {
    [self _initSet];
    [self _initLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.btn.layer.cornerRadius = self.btn.bounds.size.height/2;
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.borderWidth = 2;
    self.btn.layer.borderColor = WY_MainColor.CGColor;
}

#pragma mark -- Utilities
- (void)animateInCompletion:(void(^)())completion {
    _end = NO;
    self.circleView.hidden = NO;
    self.circleView.alpha = 0;
    self.btn.hidden = self.label.hidden = NO;
    self.btn.alpha = self.label.alpha = 1;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.btn.layer.bounds = CGRectMake(0, 0, self.btn.bounds.size.height, self.btn.bounds.size.height);
        self.label.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.btn.alpha = self.label.alpha = 0;;
    } completion:^(BOOL finished) {
        self.btn.hidden = self.label.hidden = YES;
        self.circleView.alpha = 1.0;
        self.circleView.hidden = NO;
        if (completion) {
            completion();
        }
        
    }];
    
}
- (void)animateOut {
    self.circleView.hidden = NO;
    self.circleView.alpha = 1;
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.circleView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.circleView.alpha = 0;
    } completion:^(BOOL finished) {
        self.circleView.hidden = YES;
        self.circleView.transform = CGAffineTransformIdentity;
        self.btn.hidden = self.label.hidden = NO;
        self.btn.alpha = self.label.alpha = 0;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.btn.transform = self.label.transform = CGAffineTransformIdentity;
            self.btn.bounds = self.originalBtnBounds;
            self.btn.alpha = self.label.alpha = 1;
        } completion:^(BOOL finished) {
            self.btn.hidden = self.label.hidden = NO;
            _end = YES;
            if (_progress >= 1) {
                if ([self.delegate respondsToSelector:@selector(WYProgressUpgradeViewUpdgradeSuccess:)]) {
                    [self.delegate WYProgressUpgradeViewUpdgradeSuccess:self];
                }
            }
        }];
    }];
}

#pragma mark -- Action
- (void)btnAction:(UIButton *)sender {
    if (_progress >= 1) {
        //升级成功的操作
        
        if ([self.delegate respondsToSelector:@selector(WYProgressUpgradeViewDidDoneUpgrade:)]) {
            [self.delegate WYProgressUpgradeViewDidDoneUpgrade:self];
        }
    }else {
        //开始准备升级
        
        if ([self.delegate respondsToSelector:@selector(WYProgressUpgradeViewWillUpgrade:)]) {
            [self.delegate WYProgressUpgradeViewWillUpgrade:self];
        }
    }
}

#pragma mark - Public
+ (instancetype)upgradeViewWithBeginText:(NSString *)beginText prepareText:(NSString *)prepareText endText:(NSString *)endText {
    WYProgressUpgradeView *view = [WYProgressUpgradeView new];
    view.beginString = beginText;
    view.endString = endText;
    view.prepareString = prepareText;
    view.btn.wy_normalTitle = beginText;
    view.label.text = nil;
    view.progressWidth = 5;
    view.circleView.backgroundCircleColor = WY_BGColor_LightGray3;
    view.circleView.progressCircleColor = WY_MainColor;
    view.circleView.textFont = WYFont_Text_XL_Normal;
    view.circleView.textColor = WY_FontColor_Cyan;
    view.circleView.showText = YES;
    return view;
}
- (void)setProgress:(CGFloat)progress {
    if (_end) return;
    if (progress < _progress) return;
    
    _progress = progress < 0 ? 0 : (progress > 1 ? 1 : progress);
    self.circleView.progress = _progress;
    if (self.circleView.hidden) {
        [self animateInCompletion:nil];
    }
    if (_progress == 1) {
        self.label.text = nil;
        self.btn.wy_normalTitle = self.endString;
        [self animateOut];        
    }
}
- (void)setProgressWidth:(NSInteger)progressWidth {
    self.circleView.progressWidth = progressWidth;
}
- (void)prepareToUpdate {
    WY_WeakSelf
    [self animateInCompletion:^{
//        self.circleView.text = self.prepareString;
        if ([weakSelf.delegate respondsToSelector:@selector(WYProgressUpgradeViewBeginUpgrade:)]) {
            [weakSelf.delegate WYProgressUpgradeViewBeginUpgrade:self];
        }
    }];
}
- (void)reset {
    self.btn.wy_normalTitle = self.beginString;
    self.label.text = nil;
    _progress = 0;
    [self animateOut];
}
- (void)setDone {
    _progress = 1.0f;
    self.label.text = nil;
    self.btn.wy_normalTitle = self.endString;
    if ([self.delegate respondsToSelector:@selector(WYProgressUpgradeViewUpdgradeSuccess:lajibuding:)]) {
        [self.delegate WYProgressUpgradeViewUpdgradeSuccess:self lajibuding:YES];
    }
}

@end
