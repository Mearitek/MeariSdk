//
//  WYProgressCircleView.m
//  Meari
//
//  Created by 李兵 on 2016/11/21.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYProgressCircleView.h"

@interface WYProgressCircleView ()

@property (nonatomic, weak)UILabel *textLabel;              //文本
@property (nonatomic, weak)CAShapeLayer *fillLayer;   //背景
@property (nonatomic, weak)CAShapeLayer *backgroundLayer;   //背景
@property (nonatomic, weak)CAShapeLayer *foreheadLayer;     //前景

@end

@implementation WYProgressCircleView
#pragma mark - Private
#pragma mark -- Getter
- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = _textFont;
        label.textColor = _textColor;
        label.minimumScaleFactor = 0.5;
        [self addSubview:label];
        _textLabel = label;
    }
    return _textLabel;
}
- (CAShapeLayer *)fillLayer {
    if (!_fillLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = _fillCircleColor.CGColor;
        [self.layer addSublayer:layer];
        _fillLayer = layer;
    }
    return _fillLayer;
}
- (CAShapeLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = _progressWidth;
        layer.lineCap = kCALineCapRound;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = _backgroundCircleColor.CGColor;
        [self.layer addSublayer:layer];
        _backgroundLayer = layer;
    }
    return _backgroundLayer;
}
- (CAShapeLayer *)foreheadLayer {
    if (!_foreheadLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = _progressWidth;
        layer.lineCap = kCALineCapRound;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = _progressCircleColor.CGColor;
        [self.layer addSublayer:layer];
        _foreheadLayer = layer;
    }
    return _foreheadLayer;
}

#pragma mark -- Init
- (void)_initSet {
    _progressWidth = 3.0;
    _fillCircleColor = [UIColor clearColor];
    _backgroundCircleColor = [UIColor lightGrayColor];
    _progressCircleColor = [UIColor blueColor];
    _textFont = WYFont_Text_S_Normal;
    _textColor = [UIColor blackColor];
    _showText = YES;
    _progress = 0.0;
    _needFill = YES;
    self.backgroundColor = [UIColor clearColor];
    self.fillLayer.hidden = NO;
    self.backgroundLayer.hidden = NO;
    self.foreheadLayer.hidden = NO;
    self.textLabel.hidden = !_showText;
}
- (void)_initLayout {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.textLabel.frame = self.backgroundLayer.frame = self.foreheadLayer.frame = self.bounds;
    self.fillLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    self.backgroundLayer.path = self.foreheadLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.height/2 startAngle:-M_PI_2 endAngle:-M_PI_2-0.0001 clockwise:YES].CGPath;
    self.foreheadLayer.strokeEnd = _progress;
    self.backgroundLayer.strokeColor = self.backgroundCircleColor.CGColor;
    self.foreheadLayer.strokeColor = self.progressCircleColor.CGColor;
}

#pragma mark -- Life
- (void)initAction {
    [self _initSet];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self _initLayout];
}

#pragma mark - Public
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _progress = _progress < 0 ? 0 : (_progress > 1 ? 1 : _progress);
    
    self.textLabel.text = [NSString stringWithFormat:@"%d%%",(int)(_progress*100)];
    
    self.hidden = NO;
    self.backgroundLayer.hidden = NO;
    self.foreheadLayer.hidden = NO;
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.foreheadLayer.strokeEnd = _progress;
    } completion:nil];
}
- (void)setShowText:(BOOL)showText {
    _showText = showText;
    self.textLabel.hidden = !_showText;
}
- (void)setFillCircleColor:(UIColor *)fillCircleColor {
    _fillCircleColor = fillCircleColor;
    self.fillLayer.fillColor = fillCircleColor.CGColor;
}
- (void)setNeedFill:(BOOL)needFill {
    _needFill = needFill;
    self.fillLayer.hidden = !needFill;
}
- (void)setBackgroundCircleColor:(UIColor *)backgroundCircleColor {
    _backgroundCircleColor = backgroundCircleColor;
    self.backgroundLayer.strokeColor = backgroundCircleColor.CGColor;
}
- (void)setProgressCircleColor:(UIColor *)progressCircleColor {
    _progressCircleColor = progressCircleColor;
    self.foreheadLayer.strokeColor = progressCircleColor.CGColor;
}
- (void)setTextColor:(UIColor *)textColor {
    self.textLabel.textColor = _textColor = textColor;
}
- (void)setTextFont:(UIFont *)textFont {
    self.textLabel.font = _textFont = textFont;
}
- (void)setText:(NSString *)text {
    self.textLabel.text = text;
}
- (void)setProgressWidth:(NSInteger)progressWidth {
    _progressWidth = progressWidth;
    self.backgroundLayer.lineWidth = self.foreheadLayer.lineWidth = _progressWidth;
}
- (void)dismiss {
    self.hidden = YES;
}

@end
