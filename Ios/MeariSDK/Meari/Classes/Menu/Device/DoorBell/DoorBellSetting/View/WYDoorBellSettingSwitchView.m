//
//  WYDoorBellSettingSwitchView.m
//  Meari
//
//  Created by FMG on 2017/7/26.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingSwitchView.h"

@interface WYDoorBellSettingSwitchView ()
@property (nonatomic, weak) UILabel *headerTitle;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UILabel *desLabel;
@property (nonatomic, strong) UISwitch *normalSW;
@property (nonatomic, copy) NSString *swTitle;
@property (nonatomic, copy) NSString *descriptionStr;

@end
@implementation WYDoorBellSettingSwitchView

- (instancetype)initWithSwTitle:(NSString *)swTitle description:(NSString *)description {
    self = [super init];
    if (self) {
        self.swTitle = swTitle;
        self.backgroundColor = [UIColor whiteColor];
        self.descriptionStr = description;
        [self setInit];
        [self setLayout];
    }
    return self;
}

- (void)setInit {
    
    UILabel *headerTitle = [UILabel wy_new];
    self.headerTitle = headerTitle;
    headerTitle.textColor = WY_FontColor_Black;
    headerTitle.text = self.swTitle;
    [self addSubview:headerTitle];

    UIView *line = [UIView new];
    self.line = line;
    line.backgroundColor = WY_LineColor_LightGray;
    [self addSubview:line];
   
    UILabel *desLabel = [UILabel wy_new];
    self.desLabel = desLabel;
    desLabel.font = WYFontNormal(15);
    desLabel.text = self.descriptionStr;
    desLabel.textColor = WY_FontColor_Gray;
    [self addSubview:desLabel];
    [desLabel setAdjustsFontSizeToFitWidth:WY_ScreenWidth - 43];
}
- (void)setLayout {
    [self.normalSW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-18);
        make.size.mas_equalTo(CGSizeMake(50, 32));
    }];
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(25);
        make.trailing.equalTo(self.normalSW.mas_leading);
        make.height.equalTo(@45);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.headerTitle.mas_bottom).offset(10);
        make.height.equalTo(@1);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerTitle);
        make.top.equalTo(self.line.mas_bottom).offset(5);
        make.trailing.equalTo(self.normalSW.mas_trailing);
    }];

}
- (BOOL)isOpen {
    return self.normalSW.isOn;
}
- (void)setSwitchOpen:(BOOL)open {
    [self.normalSW setOn:open];
}
- (void)normalSWAction:(UISwitch *)sw {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doorBellSettingSwitchView:switchOpen:)]) {
        [self.delegate doorBellSettingSwitchView:self switchOpen:sw.isOn];
    }
}

- (NSInteger)viewHeight {
  CGFloat height = [self.desLabel.text wy_heightWithWidth:WY_ScreenWidth -28 font:[UIFont systemFontOfSize:15] breakMode:NSLineBreakByWordWrapping];
    return height + 85;
}

#pragma mark - lazyLoad

- (UISwitch *)normalSW {
    if (!_normalSW) {
        _normalSW = [UISwitch switchWithFrame:CGRectZero on:YES target:self action:@selector(normalSWAction:)];
        [_normalSW setOn:YES];
        [self addSubview:_normalSW];
    }
    return _normalSW;
}

@end
