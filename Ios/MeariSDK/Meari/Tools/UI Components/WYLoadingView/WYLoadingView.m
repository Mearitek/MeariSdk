//
//  WYLoadingView.m
//  hud
//
//  Created by 李兵 on 2017/3/4.
//  Copyright © 2017年 李兵. All rights reserved.
//

#import "WYLoadingView.h"
#define WY_SIDE  40

@interface WYLoadingView ()
{
    UIColor *_circleColor;
}
@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, assign) BOOL showCircle;
@property (nonatomic, assign) BOOL showImage;
@property (nonatomic, strong) UIImage *image;
@end

@implementation WYLoadingView
#pragma mark - Private
#pragma mark -- Getter
- (CAReplicatorLayer *)replicatorLayer {
    if (!_replicatorLayer) {
        _replicatorLayer = [[CAReplicatorLayer alloc] init];
        _replicatorLayer.frame = CGRectMake(0, 0, WY_SIDE, WY_SIDE);
        _replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _replicatorLayer;
}
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = _circleColor.CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 2;
        _shapeLayer.frame = CGRectMake(0, 0, WY_SIDE, WY_SIDE);
        _shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(WY_SIDE/2, WY_SIDE/2)
                                                          radius:WY_SIDE/2
                                                      startAngle:-M_PI_2
                                                        endAngle:3*M_PI_2
                                                       clockwise:YES].CGPath;
    }
    if (!_shapeLayer.superlayer) {
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WY_SIDE, WY_SIDE)];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    if (!_imageView.superview) {
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (NSTimer *)countTimer {
    if (!_countTimer) {
        _countTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(countAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
    }
    return _countTimer;
}

#pragma mark -- Init
- (void)initSet {
    _circleColor = [UIColor greenColor];
}


#pragma mark -- Utilities
- (void)enableCountTimer:(BOOL)enabled {
    if (enabled) {
        if (!_countTimer) {
            [self.countTimer fire];
        }
    }else {
        if (_countTimer) {
            [_countTimer invalidate];
            _countTimer = nil;
        }
    }
}
- (void)setShowCircle:(BOOL)showCircle {
    if (_showCircle == showCircle) return;
    _showCircle = showCircle;
    
    if (_showCircle) {
        CABasicAnimation *endAnimation = [CABasicAnimation animation];
        endAnimation.keyPath = @"strokeEnd";
        endAnimation.duration = 1.5;
        endAnimation.fromValue = @0.0;
        endAnimation.toValue = @1.0;
        endAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *startAnimation = [CABasicAnimation animation];
        startAnimation.keyPath = @"strokeStart";
        startAnimation.beginTime = endAnimation.duration/4;
        startAnimation.duration = endAnimation.duration;
        startAnimation.fromValue = @0.0;
        startAnimation.toValue = @1.0;
        startAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[endAnimation, startAnimation];
        group.duration = endAnimation.duration + startAnimation.beginTime;
        group.repeatCount = INFINITY;
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animation];
        rotateAnimation.keyPath = @"transform.rotation.z";
        rotateAnimation.fromValue = @0;
        rotateAnimation.toValue = @(2*M_PI);
        rotateAnimation.duration = 2*endAnimation.duration;
        rotateAnimation.repeatCount = INFINITY;
        rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.shapeLayer addAnimation:rotateAnimation forKey:nil];
        [self.shapeLayer addAnimation:group forKey:nil];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            _shapeLayer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        } completion:^(BOOL finished) {
            if (finished) {
                [_shapeLayer removeAllAnimations];
                [_shapeLayer removeFromSuperlayer];
                _shapeLayer = nil;
            }
        }];
    }
}
- (void)setShowImage:(BOOL)showImage {
    if (_showImage == showImage) return;
    _showImage = showImage;
    if (_showImage) {
        [self bringSubviewToFront:self.imageView];
        self.imageView.image = self.image;
        [self.imageView sizeToFit];
        self.imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.imageView.hidden = NO;
        self.imageView.alpha = 0.5f;
        self.imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imageView.alpha = 1.0f;
            self.imageView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }else {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imageView.alpha = 0.0f;
            self.imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            if (finished) {
                [_imageView removeFromSuperview];
                _imageView = nil;
                _image = nil;
            }
        }];
    }
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = CGRectMake((self.bounds.size.width - WY_SIDE)/2, (self.bounds.size.height - WY_SIDE)/2, WY_SIDE, WY_SIDE);
    _label.frame = rect;
    _shapeLayer.frame = rect;
}

#pragma mark -- Action
- (void)countAction:(id)sender {
    static CGFloat count = 0;
    count += 0.1;
    self.label.text = [NSString stringWithFormat:@"%f", count];
}

#pragma mark - Public
- (void)setCircleColor:(UIColor *)color {
    _circleColor = color;
    self.shapeLayer.strokeColor = color.CGColor;
}
- (void)showWithCircle {
    if (self.showImage) {
        self.showImage = NO;
    }
    self.showCircle = YES;
}
- (void)showWithImage:(UIImage *)image {
    if (!image) {
        return;
    }
    
    if (self.showCircle) {
        self.showCircle = NO;
    }
    self.image = image;
    self.showImage = YES;
}
- (void)dismiss {
    if (self.showCircle) {
        self.showCircle = NO;
    }
    if (self.showImage) {
        self.showImage = NO;
    }
}

@end
