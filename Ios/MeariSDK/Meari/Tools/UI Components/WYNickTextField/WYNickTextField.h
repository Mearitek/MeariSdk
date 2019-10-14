//
//  WYNickTextField.h
//  Meari
//
//  Created by 李兵 on 16/8/16.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYNickTextField : WYBaseView

@property (nonatomic, copy)WYBlock_Void returnBlock;
@property (weak, nonatomic) IBOutlet UITextField *textField;
+ (instancetype)textFieldWithFrame:(CGRect)frame borderd:(BOOL)bordered target:(id)target saveAction:(SEL)saveAction;

+ (instancetype)roundTextFieldWithFrame:(CGRect)frame target:(id)target saveAction:(SEL)saveAction;
@end
