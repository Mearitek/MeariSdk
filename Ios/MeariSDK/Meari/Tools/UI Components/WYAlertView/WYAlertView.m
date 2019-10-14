//
//  WYAlertView.m
//  WYAlertVIew
//
//  Created by 李兵 on 2016/12/20.
//  Copyright © 2016年 李兵. All rights reserved.
//

#import "WYAlertView.h"

@interface WYAlertView ()
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *otherBtn;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, copy)NSAttributedString *attributedMessage;
@property (nonatomic, copy)NSString *cancelTitle;
@property (nonatomic, copy)NSString *otherTitle;
@property (nonatomic, assign)NSTextAlignment alignment;
@property (nonatomic, assign)WYUIStytle stytle;
@property (nonatomic, assign)BOOL dismissedOnClickBtn;
@property (nonatomic, assign)BOOL dismissedOnClickBackground;


@end

@implementation WYAlertView

#pragma mark - Private
#pragma mark -- Getter
- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}
- (UIView *)alertView {
    if(!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectZero];
        _alertView.userInteractionEnabled = YES;
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 14;
        _alertView.layer.masksToBounds = NO;
        _alertView.layer.shadowRadius = 5;
        _alertView.layer.shadowColor = [UIColor blackColor].CGColor;
        _alertView.layer.shadowOffset = CGSizeMake(0, 0);
        _alertView.layer.shadowOpacity = 0.1;
        
        _alertView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
//        if ([_alertView respondsToSelector:@selector(addMotionEffect:)]) {
//            UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.x" type: UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//            effectX.minimumRelativeValue = @(-10);
//            effectX.maximumRelativeValue = @(10);
//            
//            UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.y" type: UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//            effectY.minimumRelativeValue = @(-10);
//            effectY.maximumRelativeValue = @(10);
//            
//            UIMotionEffectGroup *effectGroup = [[UIMotionEffectGroup alloc] init];
//            effectGroup.motionEffects = @[effectX, effectY];
//            [_alertView addMotionEffect:effectGroup];
//        }
    }
    
    if(!_alertView.superview)
        [self addSubview:_alertView];
    
    return _alertView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = WY_FontColor_Black;
        _titleLabel.font = WYFont_Text_M_Normal;
    }
    
    if(!_titleLabel.superview)
        [self.alertView addSubview:_titleLabel];
    return _titleLabel;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.adjustsFontSizeToFitWidth = YES;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = WY_FontColor_Gray;
        _messageLabel.font = WYFont_Text_S_Normal;
    }
    
    if(!_messageLabel.superview)
        [self.alertView addSubview:_messageLabel];
    
    return _messageLabel;
}
- (UITextView *)messageTextView {
    if (!_messageTextView) {
        _messageTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _messageTextView.backgroundColor = [UIColor clearColor];
        _messageTextView.textAlignment = NSTextAlignmentCenter;
        _messageTextView.textColor = WY_FontColor_Gray;
        _messageTextView.font = WYFont_Text_S_Normal;
        _messageTextView.hidden = YES;
    }
    
    if(!_messageTextView.superview)
        [self.alertView addSubview:_messageTextView];
    
    return _messageTextView;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectZero;
        _cancelBtn.layer.borderColor = WY_FontColor_Cyan.CGColor;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.titleLabel.font = WYFont_Text_M_Normal;
        [_cancelBtn setTitleColor:WY_FontColor_Cyan forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage bgGreenImage] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(!_cancelBtn.superview)
        [self.alertView addSubview:_cancelBtn];
    
    return _cancelBtn;
}
- (UIButton *)otherBtn {
    if (!_otherBtn) {
        _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherBtn.frame = CGRectZero;
        _otherBtn.layer.borderColor = WY_FontColor_Cyan.CGColor;
        _otherBtn.layer.borderWidth = 1;
        _otherBtn.titleLabel.font = WYFont_Text_M_Normal;
        [_otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_otherBtn setTitleColor:WY_FontColor_Cyan forState:UIControlStateHighlighted];
        [_otherBtn setBackgroundImage:[UIImage bgGreenImage] forState:UIControlStateNormal];
        [_otherBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
        [_otherBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(!_otherBtn.superview)
        [self.alertView addSubview:_otherBtn];
    
    return _otherBtn;
}
- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = WY_BGColor_LightGray2;
    }
    if(!_line.superview)
        [self.alertView addSubview:_line];
    return _line;
}

#pragma mark -- Init
- (void)initSet {
    self.emptyIndex = -1;
    self.cancelButtonIndex = 0;
    self.firstOtherButtonIndex = 1;
    self.dismissedOnClickBtn = YES;
    self.dismissedOnClickBackground = NO;
    self.alignment = NSTextAlignmentCenter;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark -- Life
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_cancelBtn) {
        _cancelBtn.layer.cornerRadius = _cancelBtn.height/2;
        _cancelBtn.layer.masksToBounds = YES;
    }
    if (_otherBtn) {
        _otherBtn.layer.cornerRadius = _otherBtn.height/2;
        _otherBtn.layer.masksToBounds = YES;
    }
}

#pragma mark -- Network
#pragma mark -- Notification
#pragma mark -- NSTimer
#pragma mark -- Utilities
- (void)show {
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        UIScreen *mainScreen = UIScreen.mainScreen;
        
        for (UIWindow *window in frontToBackWindows)
            if (window.screen == mainScreen && window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if(!self.superview) {
        self.frame = self.overlayView.bounds;
        [self.overlayView addSubview:self];
    }
    
    self.titleLabel.text = self.title;
    if (self.attributedMessage) {
        self.messageLabel.attributedText = self.attributedMessage;
    }else {
        self.messageLabel.text = self.message;
    }
    [self.cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [self.otherBtn setTitle:self.otherTitle forState:UIControlStateNormal];
    if (self.title.length <= 0 && self.message.length > 0) {
        self.messageLabel.font = WYFont_Text_M_Normal;
    }
    [self updatePosition];
    
    
    self.overlayView.hidden = NO;
    if (self.alpha != 1) {
        self.alpha = 1;
        self.alertView.alpha = .0f;
        self.alertView.transform = CGAffineTransformScale(self.alertView.transform, 1.1, 1.1);
        [UIView animateKeyframesWithDuration:0.15 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut animations:^{
            self.alpha = 1.0;
            self.alertView.alpha = 1.0;
            self.alertView.transform = CGAffineTransformScale(self.alertView.transform, 1/1.1, 1/1.1);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
- (void)updatePosition {
    CGFloat space = 15.0f;
    CGFloat midSpace = 10.0f;
    CGFloat bigSpace = 40.0f;
    CGFloat alertWidth = WY_iPhone_4||WY_iPhone_5 ? 240.0f : 270.0f;
    CGFloat alertHeight = 170.0f;
    CGFloat btnH = 35.0f;
    CGFloat bottomH = 23.0f;
    
    CGRect titleRect = CGRectZero;
    CGRect messageRect = CGRectZero;
    CGRect lineRect = CGRectZero;
    CGRect cancelRect = CGRectZero;
    CGRect otherRect = CGRectZero;
    BOOL showTV = NO;
    
    if (self.title) {
        CGFloat titleH = CGRectIntegral([self.titleLabel.text boundingRectWithSize:CGSizeMake(alertWidth-2*space, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil]).size.height;
        titleRect = CGRectMake(space, 0, alertWidth-2*space, MAX(titleH+2*space, 51));
        lineRect = CGRectMake(0, CGRectGetMaxY(titleRect), alertWidth, WY_1_PIXEL);
    }
    if (self.attributedMessage) {
        CGFloat messageH = [self.messageLabel sizeThatFits:CGSizeMake(alertWidth-3*space, CGFLOAT_MAX)].height;
        messageH = round(messageH+0.5);
        messageH = messageH+space+bigSpace;
        if (messageH > WY_ScreenHeight-titleRect.size.height-btnH-space-bigSpace*4) {
            messageH = WY_ScreenHeight-titleRect.size.height-btnH-space-bigSpace*4;
            showTV = YES;
        }
        messageRect = CGRectMake(1.5*space,CGRectGetMaxY(lineRect), alertWidth-3*space, messageH);
    }else {
        if (self.message) {
            CGFloat messageH = [self.messageLabel.text boundingRectWithSize:CGSizeMake(alertWidth-3*space, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size.height;
            messageH = round(messageH+0.5);
            messageRect = CGRectMake(1.5*space,CGRectGetMaxY(lineRect), alertWidth-3*space, messageH+space+bigSpace);
        }
    }
    
    CGFloat btnY = MAX(CGRectGetMaxY(lineRect), CGRectGetMaxY(messageRect)+space);
    if (self.cancelTitle && self.otherTitle) {
        cancelRect = CGRectMake(space, btnY, (alertWidth-2*space-midSpace)/2, btnH);
        otherRect = CGRectMake(CGRectGetMaxX(cancelRect)+midSpace, CGRectGetMinY(cancelRect), CGRectGetWidth(cancelRect), CGRectGetHeight(cancelRect));
    }else if (self.cancelTitle && !self.otherTitle) {
        cancelRect = CGRectMake(space, btnY, (alertWidth-2*space), btnH);
        cancelRect.size.width /= 2;
        cancelRect.origin.x += cancelRect.size.width/2;
    }else if (!self.cancelTitle && self.otherTitle) {
        otherRect = CGRectMake(space, btnY, (alertWidth-2*space), btnH);
        otherRect.size.width /= 2;
        otherRect.origin.x += otherRect.size.width/2;
    }
    
    self.messageTextView.hidden = !showTV;
    self.messageLabel.hidden = showTV;
    if (!self.messageTextView.hidden) {
        if (self.attributedMessage) {
            NSMutableAttributedString *str = self.attributedMessage.mutableCopy;
            [str addAttribute:NSForegroundColorAttributeName value:self.messageTextView.textColor range:NSMakeRange(0, self.attributedMessage.length)];
            self.messageTextView.attributedText = str;
        }else if (self.message) {
            self.messageTextView.text = self.message;
        }
    }
    self.titleLabel.frame = titleRect;
    self.messageLabel.frame = messageRect;
    self.messageTextView.frame = messageRect;
    self.line.frame = lineRect;
    self.cancelBtn.frame = cancelRect;
    self.otherBtn.frame = otherRect;
    
    alertHeight = (otherRect.size.height > 0 ? CGRectGetMaxY(otherRect)+bottomH :
                   (cancelRect.size.height > 0 ? CGRectGetMaxY(cancelRect)+bottomH :
                    (messageRect.size.height > 0 ? CGRectGetMaxY(messageRect) :
                     (lineRect.size.height > 0 ? CGRectGetMaxY(lineRect) :
                      btnH))));
    self.alertView.bounds = CGRectMake(0, 0, alertWidth, alertHeight);
    self.alertView.center = self.center;
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = .0f;
    } completion:^(BOOL finished) {
        if (self.alpha == .0f) {
            [_alertView removeFromSuperview];
            _alertView = nil;
            [_overlayView removeFromSuperview];
            _overlayView = nil;
            self.attributedMessage = nil;
            self.title = nil;
            self.message = nil;
            self.cancelTitle = nil;
            self.otherTitle = nil;
            self.stytle = WYUIStytleDefault;
        }
    }];
}
- (void)setStytle:(WYUIStytle)stytle {
    switch (stytle) {
        case WYUIStytleCyan: {
            self.cancelBtn.layer.borderColor = WY_FontColor_Cyan.CGColor;
            [self.cancelBtn setTitleColor:WY_FontColor_Cyan forState:UIControlStateNormal];
            [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage bgGreenImage] forState:UIControlStateHighlighted];
            self.otherBtn.layer.borderColor = WY_FontColor_Cyan.CGColor;
            [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:WY_FontColor_Cyan forState:UIControlStateHighlighted];
            [self.otherBtn setBackgroundImage:[UIImage bgGreenImage] forState:UIControlStateNormal];
            [self.otherBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
            break;
        }
        case WYUIStytleOrange: {
            self.cancelBtn.layer.borderColor = WY_FontColor_DarkOrange.CGColor;
            [self.cancelBtn setTitleColor:WY_FontColor_DarkOrange forState:UIControlStateNormal];
            [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage bgOrangeImage] forState:UIControlStateHighlighted];
            self.otherBtn.layer.borderColor = WY_FontColor_DarkOrange.CGColor;
            [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:WY_FontColor_DarkOrange forState:UIControlStateHighlighted];
            [self.otherBtn setBackgroundImage:[UIImage bgOrangeImage] forState:UIControlStateNormal];
            [self.otherBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
            break;
        }
        default:
            break;
    }
}

#pragma mark -- Action
- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    if (self.dismissedOnClickBackground) {
        [self dismiss];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.dismissedOnClickBackground) {
        [self dismiss];
    }
}
- (void)buttonClickAction:(UIButton *)sender {
    NSInteger index = self.emptyIndex;
    if (sender == self.cancelBtn) {
        index = self.cancelButtonIndex;
    }else if (sender == self.otherBtn) {
        index = self.firstOtherButtonIndex;
    }
    if (self.alertAction && index != self.emptyIndex) {
        __weak typeof(self) weakSelf = self;
        self.alertAction(weakSelf, index);
    }
    if (self.dismissedOnClickBtn) {
        [self dismiss];
    }
}

#pragma mark - Delegate
#pragma mark - Public
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSet];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSet];
    }
    return self;
}
+ (instancetype)sharedView {
    static WYAlertView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}
//非强制show
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton  otherButton:(NSString *)otherButton alertAction:(WYAlertAction)alertAction {
    [self showWithTitle:title message:message.wy_attributedString cancelButton:cancelButton otherButton:otherButton alignment:NSTextAlignmentCenter alertAction:alertAction];
}
+ (void)showWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment alertAction:(WYAlertAction)alertAction {
    [self showWithTitle:title message:message cancelButton:cancelButton otherButton:otherButton alignment:alignment stytle:WYUIStytleCyan alertAction:alertAction];
}
+ (void)showWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment stytle:(WYUIStytle)stytle alertAction:(WYAlertAction)alertAction {
    [self showWithTitle:title message:message cancelButton:cancelButton otherButton:otherButton alignment:alignment stytle:stytle dismissedOnClickBtn:YES dismissedOnClickBackground:NO alertAction:alertAction];
}

//非强制show，点空白处消失
+ (void)softShowWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton  otherButton:(NSString *)otherButton alertAction:(WYAlertAction)alertAction {
    [self softShowWithTitle:title message:message.wy_attributedString cancelButton:cancelButton otherButton:otherButton alignment:NSTextAlignmentCenter alertAction:alertAction];
}
+ (void)softShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment alertAction:(WYAlertAction)alertAction {
    [self softShowWithTitle:title message:message cancelButton:cancelButton otherButton:otherButton alignment:alignment stytle:WYUIStytleCyan alertAction:alertAction];
}
+ (void)softShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment stytle:(WYUIStytle)stytle alertAction:(WYAlertAction)alertAction {
    [self showWithTitle:title message:message cancelButton:cancelButton otherButton:otherButton alignment:alignment stytle:stytle dismissedOnClickBtn:YES dismissedOnClickBackground:YES alertAction:alertAction];
}

//强制show
+ (void)forceShowWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton  otherButton:(NSString *)otherButton  alertAction:(WYAlertAction)alertAction {
    [self forceShowWithTitle:title message:message.wy_attributedString cancelButton:cancelButton otherButton:otherButton alignment:NSTextAlignmentCenter alertAction:alertAction];
}
+ (void)forceShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment alertAction:(WYAlertAction)alertAction {
    [self forceShowWithTitle:title message:message cancelButton:cancelButton otherButton:otherButton alignment:alignment stytle:WYUIStytleCyan alertAction:alertAction];
}
+ (void)forceShowWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment stytle:(WYUIStytle)stytle alertAction:(WYAlertAction)alertAction {
    [self showWithTitle:title message:message cancelButton:cancelButton otherButton:otherButton alignment:alignment stytle:stytle dismissedOnClickBtn:NO dismissedOnClickBackground:NO alertAction:alertAction];
}


+ (void)showWithTitle:(NSString *)title message:(NSAttributedString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton alignment:(NSTextAlignment)alignment stytle:(WYUIStytle)stytle dismissedOnClickBtn:(BOOL)dismissedOnClickBtn dismissedOnClickBackground:(BOOL)dismissedOnClickBackground alertAction:(WYAlertAction)alertAction {
    WYAlertView *view = [WYAlertView sharedView];
    view.title = title;
    view.attributedMessage = message;
    view.cancelTitle = cancelButton;
    view.otherTitle = otherButton;
    view.alignment = alignment;
    view.alertAction = alertAction;
    view.messageLabel.textAlignment = view.alignment;
    view.stytle = stytle;
    view.dismissedOnClickBtn = dismissedOnClickBtn;
    view.dismissedOnClickBackground = dismissedOnClickBackground;
    [view show];
}


+ (void)dismiss {
    [[WYAlertView sharedView] dismiss];
}

@end
