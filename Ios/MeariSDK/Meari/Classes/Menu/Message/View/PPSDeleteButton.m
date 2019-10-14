//
//  PPSDeleteButton.m
//  Weeye
//
//  Created by 李兵 on 15/12/15.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "PPSDeleteButton.h"

const CGFloat PPSDSpaceUp   = 8;//上边距
const CGFloat PPSDSpaceLeft = 15;//左边距

@interface PPSDeleteButton ()

@property (assign, nonatomic) WYBottomBtnType type;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIButton *markBtn;

@end

@implementation PPSDeleteButton
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5.0f;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeCenter;
        _deleteBtn = btn;
    }
    return _deleteBtn;
}

- (UIButton *)markBtn {
    if (!_markBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5.0f;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor colorWithWhite:202/255.0 alpha:1.0].CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:LocalPublic(@"btn_mark") forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:202/255.0 alpha:1.0] forState:UIControlStateNormal];
        _markBtn = btn;
    }
    return _markBtn;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)addDeleteBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(PPSDSpaceLeft, PPSDSpaceUp, self.width - 2*PPSDSpaceLeft, self.height - 2*PPSDSpaceUp);
    [btn setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [self addSubview:btn];
    _deleteBtn = btn;
}

#pragma mark - 接口

+ (instancetype)deleteBtnWithFrame:(CGRect)frame targe:(id)target action:(SEL)action {
    PPSDeleteButton *button = [PPSDeleteButton buttonWithFrame:frame type:WYBottomBtnTypeDelete];
    [button.deleteBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (instancetype)deleteAndMarkBtnWithFrame:(CGRect)frame targe:(id)target deleteAction:(SEL)deleteAction markAction:(SEL)markAction {
    PPSDeleteButton *button = [PPSDeleteButton buttonWithFrame:frame type:WYBottomBtnTypeDeleteAndMark];
    [button.deleteBtn addTarget:target action:deleteAction forControlEvents:UIControlEventTouchUpInside];
    [button.markBtn addTarget:target action:markAction forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (instancetype)buttonWithFrame:(CGRect)frame type:(WYBottomBtnType)type{
    PPSDeleteButton *button = [[self alloc] initWithFrame:frame];
    button.type = type;
    switch (type) {
        case WYBottomBtnTypeDelete: {
            [button addSubview:button.deleteBtn];
            button.deleteBtn.frame = CGRectMake(PPSDSpaceLeft, PPSDSpaceUp, frame.size.width - 2*PPSDSpaceLeft, frame.size.height - 2*PPSDSpaceUp);
            break;
        }
        case WYBottomBtnTypeDeleteAndMark: {
            [button addSubview:button.deleteBtn];
            [button addSubview:button.markBtn];
            
            button.markBtn.frame = CGRectMake(PPSDSpaceLeft, PPSDSpaceUp, (frame.size.width - 3*PPSDSpaceLeft)/2, frame.size.height - 2*PPSDSpaceUp);
            button.deleteBtn.frame = button.markBtn.frame;
            button.deleteBtn.x = CGRectGetMaxX(button.markBtn.frame) + PPSDSpaceLeft;
            break;
        }
    }
    return button;
}

@end
