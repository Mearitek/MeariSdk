//
//  WYMeSignupCodeButton.h
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseView.h"

@interface WYMeSignupCodeButton : WYBaseView
@property (nonatomic, strong)UITextField *tf;
- (void)reset;
- (void)setCountDown:(NSInteger)second;
- (void)addTarget:(id)target getCodeAction:(SEL)action;

@end
