
//
//  registerVC.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "registerVC.h"

@interface registerVC ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextView *errorCodeTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;

@end

@implementation registerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// send code to phont or email
- (IBAction)sendCodeAction:(id)sender {
    // warning!!!!!! warning!!!!  countryCode phoneCode, please user right code. check phoneCode file
    WY_WeakSelf
    [[MeariUser sharedInstance] getValidateCodeWithAccount:_accountTF.text
                                               countryCode:@"CN"
                                                 phoneCode:@"86"
                                                   success:^(NSInteger seconds) {
        UIAlertController *alert = [UIAlertController alertControllerMessage:[NSString stringWithFormat:@"code has send, leave %li seconds", seconds] sureBlock:nil];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        
        weakSelf.errorCodeTextView.text = @"code send success";
    } failure:^(NSError *error) {
        weakSelf.errorCodeTextView.text = error.domain;
    }];
}
- (IBAction)registerAction:(id)sender {
    WY_WeakSelf
    [[MeariUser sharedInstance] registerWithAccount:_accountTF.text
                                           password:_passwordTF.text
                                        countryCode:@"CN"
                                          phoneCode:@"86"
                                   verificationCode:_codeTF.text
                                           nickname:_nicknameTF.text success:^{
        
        weakSelf.errorCodeTextView.text = [NSString stringWithFormat:@"account areadly register, account : %@, password %@", weakSelf.accountTF.text, weakSelf.passwordTF.text];
    } failure:^(NSError *error) {
        weakSelf.errorCodeTextView.text = error.domain;
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
