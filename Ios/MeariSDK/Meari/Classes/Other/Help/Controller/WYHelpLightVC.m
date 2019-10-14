//
//  WYHelpLightVC.m
//  Meari
//
//  Created by 李兵 on 2017/3/3.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYHelpLightVC.h"

@interface WYHelpLightVC ()
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UITextView *textView;

@end

@implementation WYHelpLightVC
#pragma mark - Private
#pragma mark -- Getter
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel labelWithFrame:CGRectZero
                                    text:WYLocalString(@"des_help_resetHow")
                               textColor:WY_FontColor_Cyan
                                textfont:WYFont_Text_S_Normal
                           numberOfLines:0
                           lineBreakMode:NSLineBreakByWordWrapping
                           lineAlignment:NSTextAlignmentLeft
                               sizeToFit:NO];
        CGFloat w = WY_ScreenWidth-40;
        CGFloat h = [_label ajustedHeightWithWidth:w];
        _label.size = CGSizeMake(w, h);
    }
    if (!_label.superview) {
        [self.view addSubview:_label];
    }
    return _label;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = WY_BGColor_LightGray;
        UIImageView *imageV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_camera_reset"]];
        UIImageView *imageV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_camera_redLight"]];
        UILabel *label1 = [UILabel labelWithFrame:CGRectZero
                                             text:WYLocalString(@"des_help_reset")
                                        textColor:WY_FontColor_Cyan
                                         textfont:WYFont_Text_XS_Normal
                                    numberOfLines:0
                                    lineBreakMode:NSLineBreakByWordWrapping
                                    lineAlignment:NSTextAlignmentCenter
                                        sizeToFit:NO];
        
        UILabel *label2 = [UILabel labelWithFrame:CGRectZero
                                             text:WYLocalString(@"des_help_resetSuc")
                                        textColor:WY_FontColor_Cyan
                                         textfont:WYFont_Text_XS_Normal
                                    numberOfLines:0
                                    lineBreakMode:NSLineBreakByWordWrapping
                                    lineAlignment:NSTextAlignmentCenter
                                        sizeToFit:NO];
        [_topView addSubview:imageV1];
        [_topView addSubview:imageV2];
        [_topView addSubview:label1];
        [_topView addSubview:label2];
        
        
        CGFloat lr = 20;
        CGFloat m = 30;
        CGFloat tb = 20;
        CGFloat w = (WY_ScreenWidth - 2*lr - m)/2;
        label1.size = CGSizeMake(w, [label1 ajustedHeightWithWidth:w]+2);
        label2.size = CGSizeMake(w, [label2 ajustedHeightWithWidth:w]+2);
        
        [imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(_topView).offset(tb);
            make.width.equalTo(imageV1.mas_height).multipliedBy(1.0f);
            make.centerX.equalTo(label1).priority(751);
        }];
        [imageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.top.equalTo(imageV1);
            make.centerX.equalTo(label2).priority(751);
        }];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(label1.size);
            make.top.equalTo(imageV1.mas_bottom).offset(tb);
            make.bottom.equalTo(_topView).offset(-tb);
            make.leading.equalTo(_topView).offset(lr);
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(label2.size);
            make.top.equalTo(label1);
            make.leading.equalTo(label1.mas_trailing).offset(m);
            make.trailing.equalTo(_topView).offset(-lr);
        }];
    }
    if (!_topView.superview) {
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 20, 20, 20);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attributes = @{NSFontAttributeName : WYFont_Text_S_Normal,
                                     NSParagraphStyleAttributeName : paragraphStyle,
                                     NSForegroundColorAttributeName : WY_FontColor_Gray};
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString wy_local_help_config_des] attributes:attributes];
//        _textView.attributedText = attrStr;
        _textView.attributedText = [NSAttributedString attributedHelp_Config];
    }
    if (!_textView.superview) {
        [self.view addSubview:_textView];
    }
    return _textView;
}
#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"Review instruction");
}
- (void)initLayout {
    WY_WeakSelf
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view).with.offset(10);
//        make.leading.equalTo(weakSelf.view).with.offset(20);
//        make.size.mas_equalTo(weakSelf.label.size);
//    }];
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.label.mas_bottom).with.offset(10);
//        make.leading.trailing.equalTo(weakSelf.view);
//        make.height.equalTo(WY_iPhone_4 ? @150 : @240);
//    }];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.topView.mas_bottom).with.offset(0);
//        make.leading.trailing.bottom.equalTo(weakSelf.view);
//    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
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
#pragma mark - Delegate
#pragma mark - Public

@end
