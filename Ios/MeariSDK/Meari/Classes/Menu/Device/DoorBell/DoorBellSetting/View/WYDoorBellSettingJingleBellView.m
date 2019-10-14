//
//  WYDoorBellSettingJingleBellView.m
//  Meari
//
//  Created by FMG on 2017/7/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingJingleBellView.h"
#import "WYStallSlider.h"

@interface WYDoorBellSettingJingleBellView()<wyStallSliderDelegate>
@property (nonatomic, weak) WYStallSlider *jingleBellSlider;
@property (nonatomic, weak) UILabel *sliderNum;
@property (nonatomic, weak) UILabel *desTitle;
@property (nonatomic, assign) NSInteger sliderStallNum;
@property (nonatomic, copy) NSArray *stallDest;
@property (nonatomic, assign) NSInteger selectedStall;

@end

@implementation WYDoorBellSettingJingleBellView

- (instancetype)initWithFrame:(CGRect)frame sliderStallNum:(NSInteger)sliderStallNum stallDestription:(NSArray *)stallDest selectedStall:(NSInteger)selectedStall;
{
    self = [super init];
    if (self) {
        self.sliderStallNum = sliderStallNum;
        self.selectedStall = selectedStall;
        self.stallDest = stallDest;
        [self setLayout];
    }
    return self;
}
- (void)setBellTitle:(NSString *)bellTitle {
    _bellTitle = bellTitle;
    self.desTitle.text = bellTitle;
}

- (void)setLayout {
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, 1)];
    line1.backgroundColor = WY_LineColor_LightGray;
    [self addSubview:line1];
    [self.desTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(WY_ScreenWidth, 20));
    }];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(18, 35, WY_ScreenWidth-25, 1)];
    line2.backgroundColor = WY_LineColor_LightGray;
    [self addSubview:line2];
 
    [self.jingleBellSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.desTitle.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(WY_ScreenWidth - 100, 80));
    }];
    [self.sliderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jingleBellSlider);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}
#pragma mark - sliderAction

- (void)setSliderColor:(UIColor *)sliderColor stallColor:(UIColor *)stallColor {
    [self.jingleBellSlider setTintColor:sliderColor];
}

#pragma mark - sliderDelegate
- (void)stallSlider:(WYStallSlider *)slider didSelectedStall:(NSInteger)stall {
    self.sliderNum.text = self.stallDest[stall -1];
    if (_bellVlaue) {
        self.bellVlaue(stall);
    }
}

#pragma mark - lazyLoad
- (UILabel *)desTitle {
    if (!_desTitle) {
        UILabel *desTitle = [[UILabel alloc] init];
        _desTitle = desTitle;
        _desTitle.textColor = WY_FontColor_Gray;
        [self addSubview:desTitle];
    }
    return _desTitle;
}
- (WYStallSlider *)jingleBellSlider {
    if (!_jingleBellSlider) {
       WYStallSlider *jingleBellSlider = [[WYStallSlider alloc] initWithFrame:CGRectZero stallNum:self.sliderStallNum selectedStall:self.selectedStall];
        jingleBellSlider.delegate = self;
        jingleBellSlider.tintColor = WY_MainColor;
        _jingleBellSlider = jingleBellSlider;
        [self addSubview:_jingleBellSlider];
    }
    return _jingleBellSlider;
}
- (UILabel *)sliderNum {
    if (!_sliderNum) {
        UILabel *label = [UILabel new];
        _sliderNum = label;
        NSInteger seletecd = self.selectedStall - 1;
        if (seletecd >=0 && seletecd < self.stallDest.count ) {
            label.text = self.stallDest[seletecd];
        }else {
            label.text = self.stallDest[0];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = WY_MainColor;
        [self addSubview:label];
    }
    return _sliderNum;
}
@end
