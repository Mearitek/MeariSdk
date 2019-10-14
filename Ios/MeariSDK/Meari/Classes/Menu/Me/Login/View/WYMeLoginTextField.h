//
//  WYMeLoginTextField.h
//  Meari
//
//  Created by 李兵 on 2017/9/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseView.h"

@interface WYMeLoginTextField : WYBaseView
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *btn;

+ (instancetype)accountTextField;
+ (instancetype)passwordTextField;


@end
