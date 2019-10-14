//
//  WYMeSignupModel.h
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseModel.h"
typedef NS_ENUM(NSInteger, WYTextFieldType) {
    WYTextFieldTypeAccount,
    WYTextFieldTypeNickName,
    WYTextFieldTypeCode,
    WYTextFieldTypePassword,
    WYTextFieldTypePassword2,
};
@interface WYMeSignupModel : WYBaseModel
@property (nonatomic, copy)NSString *placeholder;
@property (nonatomic, assign)UIReturnKeyType returnType;
@property (nonatomic, assign)UIKeyboardType keyboardType;
@property (nonatomic, assign)BOOL secure;
@property (nonatomic, assign)WYTextFieldType tfType;

+ (instancetype)accountModel;
+ (instancetype)nicknameModel;
+ (instancetype)passwordModel;
+ (instancetype)password2Model;

@end
