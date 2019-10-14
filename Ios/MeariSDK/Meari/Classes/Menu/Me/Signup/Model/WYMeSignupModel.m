//
//  WYMeSignupModel.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeSignupModel.h"

@implementation WYMeSignupModel
+ (instancetype)modelWithImageName:(NSString *)imageName placeholder:(NSString *)placeholder returnType:(UIReturnKeyType)returnType keyboardType:(UIKeyboardType)keyboardType secure:(BOOL)secure type:(WYTextFieldType)type{
    WYMeSignupModel *model = [self new];
    model.imageName = imageName;
    model.placeholder = placeholder;
    model.returnType = returnType;
    model.keyboardType = keyboardType;
    model.secure = secure;
    model.tfType = type;
    return model;
}

+ (instancetype)accountModel {
    return [self modelWithImageName:@"img_me_email"
                        placeholder:[NSString wy_placeholder_me_account]
                         returnType:UIReturnKeyNext
                       keyboardType:UIKeyboardTypeDefault
                             secure:NO
                               type:WYTextFieldTypeAccount];
}
+ (instancetype)nicknameModel {
    return [self modelWithImageName:@"img_me_account"
                        placeholder:WYLocalString(@"me_nickname_placeholder")
                         returnType:UIReturnKeyNext
                       keyboardType:UIKeyboardTypeDefault
                             secure:NO
                               type:WYTextFieldTypeNickName];
}
+ (instancetype)passwordModel {
    return [self modelWithImageName:@"img_me_password"
                        placeholder:WYLocalString(@"me_password_placeholder")
                         returnType:UIReturnKeyNext
                       keyboardType:UIKeyboardTypeAlphabet
                             secure:YES
                               type:WYTextFieldTypePassword];
}
+ (instancetype)password2Model {
    return [self modelWithImageName:@"img_me_password"
                        placeholder:WYLocalString(@"me_password2_placeholder")
                         returnType:UIReturnKeyDone
                       keyboardType:UIKeyboardTypeAlphabet
                             secure:YES
                               type:WYTextFieldTypePassword2];
}
@end
