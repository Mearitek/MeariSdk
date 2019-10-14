//
//  WYCameraToolPreviewBabyView.m
//  Meari
//
//  Created by 李兵 on 2017/3/8.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraToolPreviewBabyView.h"
const CGFloat initTempture  = 23;
const CGFloat initHumidity  = 43;
const CGFloat tMin          = -20;
const CGFloat tMax          = 40;
const CGFloat suitableTMin  = 20;
const CGFloat suitableTMax  = 26;
const CGFloat rhMin         = 0;
const CGFloat rhMax         = 100;
const CGFloat suitableRHMin = 30;
const CGFloat suitableRHMax = 70;
@interface WYCameraToolPreviewBabyView ()
@property (nonatomic, strong)WYCameraToolPreviewBabyTimebarView *tempView;
@property (nonatomic, strong)WYCameraToolPreviewBabyTimebarView *rhView;


@end

@implementation WYCameraToolPreviewBabyView

#pragma mark - Private
#pragma mark -- Getter
- (WYCameraToolPreviewBabyTimebarView *)tempView {
    if (!_tempView) {
        _tempView = [[WYCameraToolPreviewBabyTimebarView alloc] initWithTimeBarImage:[UIImage imageNamed:@"img_baby_temp_timebar"] frameImage:[UIImage imageNamed:@"img_baby_temp_frame"]];
        _tempView.type = WYCameraToolPreviewBabyTimebarTypeTemperature;
    }
    if (!_tempView.superview) {
        [self addSubview:_tempView];
    }
    return _tempView;
}
- (WYCameraToolPreviewBabyTimebarView *)rhView {
    if (!_rhView) {
        _rhView = [[WYCameraToolPreviewBabyTimebarView alloc] initWithTimeBarImage:[UIImage imageNamed:@"img_baby_rh_timebar"] frameImage:[UIImage imageNamed:@"img_baby_rh_frame"]];
        _rhView.type = WYCameraToolPreviewBabyTimebarTypeHumidity;
    }
    if (!_rhView.superview) {
        [self addSubview:_rhView];
    }
    return _rhView;
}

#pragma mark -- Init
- (void)initSet {
    self.temperature = initTempture;
    self.humidity = initHumidity;
}
- (void)initLayout {
    WY_WeakSelf
    [self.tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).with.offset(15);
    }];
    [self.rhView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.tempView.mas_trailing).with.offset(15);
        make.trailing.equalTo(weakSelf).with.offset(-15);
        make.width.equalTo(weakSelf.tempView);
    }];
}

#pragma mark -- Utilities


#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}

#pragma mark -- Action
#pragma mark - Delegate
#pragma mark - Public
- (void)setTemperature:(CGFloat)temperature {
    self.tempView.paramValue = temperature;
}
- (void)setHumidity:(CGFloat)humidity {
    self.rhView.paramValue = humidity;
}
+ (void)ajustedTemperature:(CGFloat *)temperature {
    if (*temperature < tMin) {
        *temperature = tMin;
    }
    if (*temperature > tMax) {
        *temperature = tMax;
    }
}
+ (void)ajustedHumidity:(CGFloat *)humidity {
    if (*humidity < rhMin) {
        *humidity = rhMin;
    }
    if (*humidity > rhMax) {
        *humidity = rhMax;
    }
}
- (void)showT:(BOOL)show {
    [self.tempView showValue:show];
}
- (void)showRH:(BOOL)show {
    [self.rhView showValue:show];
}
- (void)showTError {
    [self.tempView showValue:NO];
}
- (void)showRHError {
    [self.rhView showValue:NO];
}
@end


#pragma mark - WYCameraToolPreviewBabyTimebarView

@interface WYCameraToolPreviewBabyTimebarView ()
{
    CGFloat _scrollW;
}
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *frameImageView;
@property (nonatomic, strong)UIImageView *timebarImageView;
@property (nonatomic, strong)UIImageView *cursorImageView;
@property (nonatomic, strong)UILabel *valueLabel;
@property (nonatomic, strong)UILabel *levelLabel;


@property (nonatomic, strong)UILabel *temperatureLabel;
@property (nonatomic, strong)UILabel *humidityLabel;
@property (nonatomic, assign)CGFloat progress;


@end

//刻度尺
const CGFloat tL      = 39;
const CGFloat tR      = 39;
const CGFloat tW      = 1228;
const CGFloat tH      = 90;
const CGFloat rhL     = 47;
const CGFloat rhR     = 44;
const CGFloat rhW     = 1050;
const CGFloat rhH     = 90;
const CGFloat padding = 20;



@implementation WYCameraToolPreviewBabyTimebarView
#pragma mark - Private
#pragma mark -- Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.layer.masksToBounds = YES;
//        _scrollView.layer.cornerRadius = 16;
//        _scrollView.userInteractionEnabled = NO;
    }
    if (!_scrollView.superview) {
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIImageView *)frameImageView {
    if (!_frameImageView) {
        _frameImageView = [UIImageView new];
    }
    if (!_frameImageView.superview) {
        [self addSubview:_frameImageView];
    }
    return _frameImageView;
}
- (UIImageView *)timebarImageView {
    if (!_timebarImageView) {
        _timebarImageView = [UIImageView new];
    }
    if (!_timebarImageView.superview) {
        [self.scrollView addSubview:_timebarImageView];
    }
    return _timebarImageView;
}
- (UIImageView *)cursorImageView {
    if (!_cursorImageView) {
        _cursorImageView = [UIImageView new];
        _cursorImageView.image = [UIImage imageNamed:@"img_baby_cursor"];
        _cursorImageView.hidden = YES;
    }
    if (!_cursorImageView.superview) {
        [self.timebarImageView addSubview:_cursorImageView];
    }
    return _cursorImageView;
}
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [UILabel wy_new];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (!_valueLabel.superview) {
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}
- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [UILabel wy_new];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (!_levelLabel.superview) {
        [self addSubview:_levelLabel];
    }
    return _levelLabel;
}

#pragma mark -- Init
- (void)initSet {
    _scrollW = (WY_ScreenWidth-15-15-15)/2-2*padding;
}
- (void)initLayout {
    WY_WeakSelf
    [self.frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_centerY);
        make.leading.trailing.equalTo(weakSelf);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.frameImageView);
        make.leading.equalTo(weakSelf.frameImageView).with.offset(padding);
        make.trailing.equalTo(weakSelf.frameImageView).with.offset(-padding);
    }];
    [self.timebarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        make.height.equalTo(@32).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
        make.width.equalTo(weakSelf.timebarImageView.mas_height).multipliedBy(weakSelf.timebarImageView.image.size.width/weakSelf.timebarImageView.image.size.height);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.equalTo(@14).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.frameImageView.mas_bottom).with.offset(9);
    }];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.equalTo(@14).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.valueLabel.mas_bottom).with.offset(5);
    }];
    [self.cursorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.frameImageView).with.offset(-4).priority(751);
        make.height.greaterThanOrEqualTo(@0);
        make.height.lessThanOrEqualTo(weakSelf);
        make.width.equalTo(weakSelf.cursorImageView.mas_height).multipliedBy(weakSelf.cursorImageView.image.size.width/weakSelf.cursorImageView.image.size.height);
        make.centerY.equalTo(weakSelf.scrollView);
        make.centerX.equalTo(weakSelf.scrollView);
    }];
}

#pragma mark -- Utilities
- (void)setTemperature:(CGFloat)temperature {
    
//    if (temperature == initTempture) {
//        self.valueLabel.attributedText = [self stringWithDes:WYLocalString(@"Temperature") valueString:@"--" valueColor:WY_FontColor_Gray];
//        self.cursorImageView.hidden = YES;
//        return;
//    }
    [self showValue:YES];
    [WYCameraToolPreviewBabyView ajustedTemperature:&temperature];
    NSString *levelString;
    if (temperature < suitableTMin) {
        levelString = WYLocalString(@"Temperature_low");
    }else if (temperature <= suitableTMax) {
        levelString = WYLocalString(@"Temperature_normal");
    }else {
        levelString = WYLocalString(@"Temperature_high");
    }
    
    NSString *valueString = [NSString stringWithFormat:@"%.0lf℃",temperature];
    self.valueLabel.attributedText = [self stringWithDes:WYLocalString(@"Temperature") valueString:valueString valueColor:WY_FontColor_DarkOrange];
    self.levelLabel.attributedText = [NSAttributedString defaultAttributedStringWithString:levelString fontColor:WY_FontColor_Gray font:WYFont_Text_XXS_Normal alignment:NSTextAlignmentCenter];
    self.cursorImageView.hidden = NO;
    CGFloat p = (temperature-(tMin))/(tMax-tMin);
    [self setProgress:p];
}
- (void)setHumidity:(CGFloat)humidity {
//    if (humidity == initHumidity) {
//        self.valueLabel.attributedText = [self stringWithDes:WYLocalString(@"Humidity") valueString:@"--" valueColor:WY_FontColor_Gray];
//        self.cursorImageView.hidden = YES;
//        return;
//    }
    [self showValue:YES];
    [WYCameraToolPreviewBabyView ajustedHumidity:&humidity];
    NSString *levelString;
    if (humidity < suitableRHMin) {
        levelString = WYLocalString(@"Humidity_low");
    }else if (humidity <= suitableRHMax) {
        levelString = WYLocalString(@"Humidity_normal");
    }else {
        levelString = WYLocalString(@"Humidity_high");
    }
    NSString *valueString = [NSString stringWithFormat:@"%.0lf%%RH",humidity];
    self.valueLabel.attributedText = [self stringWithDes:WYLocalString(@"Humidity") valueString:valueString valueColor:WY_FontColor_Cyan];
    self.levelLabel.attributedText = [NSAttributedString defaultAttributedStringWithString:levelString fontColor:WY_FontColor_Gray font:WYFont_Text_XXS_Normal alignment:NSTextAlignmentCenter];
    self.cursorImageView.hidden = NO;
    CGFloat p = (humidity-(rhMin))/(rhMax-rhMin);
    [self setProgress:p];
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _progress = _progress > 1 ? 1 : (_progress < 0 ? 0 : _progress);
    CGFloat radio, l, r, w, W, offX = self.scrollView.contentOffsetX;
    if (self.type == WYCameraToolPreviewBabyTimebarTypeTemperature) {
        radio = 32/tH;
        l = tL*radio;
        r = tR*radio;
        w = tW*radio;
        W = w-l-r;
    }else {
        radio = 32/rhH;
        l = rhL*radio;
        r = rhR*radio;
        w = rhW*radio;
        W = w-l-r;
    }
    CGFloat x = l + _progress*W;
    CGFloat cx =  x - _scrollW/2;
    CGFloat sx = cx > 0 ? cx : 0;
    WY_WeakSelf
    [self.cursorImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.scrollView).offset(cx);
    }];
    [self.scrollView setContentOffsetX:sx animated:YES];
}
- (BOOL)isInCurrentScale:(CGFloat)value {
    CGFloat radio, l, r, w, scale, scaleMax;
    if (self.type == WYCameraToolPreviewBabyTimebarTypeTemperature) {
        radio = 32/tH;
        l = tL*radio;
        r = tR*radio;
        w = tW*radio;
        scale = 18;
        scaleMax = tMax - tMin;
    }else {
        radio = 32/rhH;
        l = rhL*radio;
        r = rhR*radio;
        w = rhW*radio;
        scale = 28;
        scaleMax = rhMax - rhMin;
    }
    CGFloat v = (_scrollW/2+self.scrollView.contentOffsetX-l)/(w-l-r)*scaleMax;
    return v + scale >= value  && v - scale <= value;
}
- (NSAttributedString *)stringWithDes:(NSString *)des valueString:(NSString *)valueString valueColor:(UIColor *)valueColor {
    NSMutableAttributedString *str1 = [NSString stringWithFormat:@"%@: ", des].wy_mutableAttributedString;
    [str1 addAttribute:NSForegroundColorAttributeName value:WY_FontColor_Gray range:NSMakeRange(0, str1.length)];
    NSMutableAttributedString *str2 = valueString.wy_mutableAttributedString;
    [str2 addAttribute:NSForegroundColorAttributeName value:valueColor range:NSMakeRange(0, str2.length)];
    [str1 appendAttributedString:str2];
    [str1 addAttribute:NSFontAttributeName value:WYFont_Text_XS_Normal range:NSMakeRange(0, str1.length)];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    [str1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str1.length)];
    return str1;
}

#pragma mark -- Life
- (void)layoutSubviews {
    [super layoutSubviews];
    self.progress = self.progress;
}

#pragma mark - Delegate
#pragma mark - Public
- (instancetype)initWithTimeBarImage:(UIImage *)timeBarImage frameImage:(UIImage *)frameImage {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.timebarImageView.image = timeBarImage;
        self.frameImageView.image = frameImage;
        [self initSet];
        [self initLayout];
    }
    return self;
}
- (void)setParamValue:(CGFloat)paramValue {
    if (_paramValue == paramValue) return;
    
    _paramValue = paramValue;
    switch (self.type) {
        case WYCameraToolPreviewBabyTimebarTypeTemperature: {
            [self setTemperature:paramValue];
            break;
        }
        case WYCameraToolPreviewBabyTimebarTypeHumidity: {
            [self setHumidity:paramValue];
            break;
        }
        default:
            break;
    }
}
- (void)showValue:(BOOL)show {
    self.cursorImageView.hidden = !show;
    if (!show) {
        switch (self.type) {
            case WYCameraToolPreviewBabyTimebarTypeTemperature: {
                self.valueLabel.attributedText = [self stringWithDes:WYLocalString(@"Temperature") valueString:@"--" valueColor:WY_FontColor_Gray];
                self.levelLabel.attributedText = nil;
                break;
            }
            case WYCameraToolPreviewBabyTimebarTypeHumidity: {
                self.valueLabel.attributedText = [self stringWithDes:WYLocalString(@"Humidity") valueString:@"--" valueColor:WY_FontColor_Gray];
                self.levelLabel.attributedText = nil;
                break;
            }
            default:
                break;
        }
        
    }
}

@end
