//
//  WYLongPressImageView.m
//  Meari
//
//  Created by MJ2009 on 2018/7/5.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYLongPressImageView.h"

@implementation WYLongPressImageView

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        [self initSet];
    }
    return self;
}

- (void)initSet {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGR:)];
    [self addGestureRecognizer:longPress];
}

- (void)longPressGR:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self becomeFirstResponder];
            UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:WYLocalString(@"Delete") action:@selector(deleteAction:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:@[delete]];
            [menu setTargetRect:CGRectMake(0, 10, self.width, self.height) inView:self];
            [menu setMenuVisible:YES animated:YES];
            break;
        }
        default:
            break;
    }
    
    
}

- (void)deleteAction:(id)sender {
    if (self.deleteAction) {
        self.deleteAction();
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
