//
//  WYMeMineNicknameVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeMineNicknameVC.h"

@interface WYMeMineNicknameVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *tf;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UIButton *doneBtn;
@end

@implementation WYMeMineNicknameVC
#pragma mark -- Getter
- (UITextField *)tf {
    if (!_tf) {
        _tf = [UITextField new];
        _tf.font = WYFont_Text_S_Normal;
//        [_tf setValue:WYFont_Text_S_Normal forKeyPath:@"_placeholderLabel.font"];
        _tf.text = WY_USER_NICK;
        _tf.delegate = self;
        _tf.returnKeyType = UIReturnKeyDone;
        [_tf addTarget:self action:@selector(textDidChangedAction:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_tf];
    }
    return _tf;
}
- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = WY_LineColor_LightGray;
        [self.view addSubview:_line];
    }
    return _line;
}
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledWhiteAndGreenTitle target:self action:@selector(doneAction:)];
        _doneBtn.wy_normalTitle = WYLocalString(@"me_finish");
        _doneBtn.layer.borderColor = WY_MainColor.CGColor;
        _doneBtn.layer.borderWidth = 1.0f;
        [self.view addSubview:_doneBtn];
    }
    return _doneBtn;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = self.doneBtn.height/2;
}

#pragma mark -- Init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = WYLocalString(@"me_mine_nickname_title");
    
}
- (void)initLayout {
    WY_WeakSelf
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view).offset(35);
        make.trailing.equalTo(weakSelf.view).offset(-40);
        make.top.equalTo(weakSelf.view).offset(50);
        make.height.equalTo(@50);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(WY_1_PIXEL));
        make.leading.trailing.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.tf.mas_bottom).offset(20);
    }];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.line.mas_bottom).offset(20);
    }];
    
}

#pragma mark -- Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)backAction:(UIButton *)sender {
    [self wy_popToVC:WYVCTypeMeMine sender:WY_USER_NICK];
}
- (void)doneAction:(UIButton *)sender {
    if (self.tf.text.length <= 0) {
        WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"me_fail_noNickname"));
        return;
    }
    if ([self.tf.text isEqualToString:WY_USER_NICK]) {
        return;
    }
    [self networkRequestChangeNickName];
}
- (void)textDidChangedAction:(UITextField *)sender {
    [NSThread wy_doOnMainThread:^{
        if (sender.text.wy_containsEmoji) {
            WY_HUD_SHOW_NOEMOJI
            sender.text = sender.text.wy_stringByFilerEmoji;
        }
        if (sender.text.length > 20 && sender.markedTextRange == nil) {
            NSString *subString = [sender.text substringToIndex:20];
            sender.text = subString;
            WY_HUD_SHOW_STATUS(WYLocalString(@"error_nicknameTooLong"))
        }
    }];
}


#pragma mark -- Network
- (void)networkRequestChangeNickName {
    NSString *newName = self.tf.text;
    [[MeariUser sharedInstance] renameNickname:newName success:^{
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"success_changeNickname"));
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

#pragma mark - Delegate
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneAction:self.doneBtn];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([[UITextInputMode currentInputMode].primaryLanguage isEqualToString:@"emoji"]) {
#pragma clang diagnostic pop
        WY_HUD_SHOW_NOEMOJI
        return NO;
    }
    return YES;
}

@end
