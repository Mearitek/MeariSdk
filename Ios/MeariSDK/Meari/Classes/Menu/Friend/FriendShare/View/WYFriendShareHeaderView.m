//
//  WYFriendShareHeaderView.m
//  Meari
//
//  Created by 李兵 on 2017/9/16.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendShareHeaderView.h"

@interface WYFriendShareHeaderView()
@property (nonatomic, strong)UILabel *label;

@end
@implementation WYFriendShareHeaderView
#pragma mark -- Getter
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel labelWithFrame:CGRectZero
                                    text:nil
                               textColor:WY_FontColor_Gray
                                textfont:WYFont_Text_S_Normal
                           numberOfLines:0
                           lineBreakMode:NSLineBreakByWordWrapping
                           lineAlignment:NSTextAlignmentCenter
                               sizeToFit:NO];
        [self addSubview:_label];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    WY_WeakSelf
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).offset(0);
    }];
}
- (void)setText:(NSString *)text {
    self.label.text = text;
}
@end
