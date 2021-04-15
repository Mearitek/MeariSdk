//
//  ViewController.m
//  MeariSDKDemo
//
//  Created by Meari on 2020/6/4.
//  Copyright © 2020 Meari. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UIButton *loginInButton;
@property (weak, nonatomic) IBOutlet UITextView *errorCodeTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _errorCodeTextView.layer.borderWidth = 1;
    _errorCodeTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _errorCodeTextView.layer.cornerRadius = 5;
    _errorCodeTextView.layer.masksToBounds = YES;
    
    if ([MeariUser sharedInstance].logined) {
        [self.loginInButton setTitle:@"you already login" forState:(UIControlStateNormal)];
    }
    // Do any additional setup after loading the view.
}

#pragma mark --- navigation
// logout
- (IBAction)logoutItemAction:(id)sender {
    // login first
    if (![MeariUser sharedInstance].logined) {
        UIAlertController *alert = [UIAlertController alertControllerMessage:@"please login account first" sureBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [[MeariUser sharedInstance] logoutSuccess:^{
        self.errorCodeTextView.text = @"logout success";
        [self.loginInButton setTitle:@"login" forState:(UIControlStateNormal)];
    } failure:^(NSError *error) {
        self.errorCodeTextView.text = error.domain;
    }];
    
}

// login account
- (IBAction)loginAction:(id)sender {
    if ([MeariUser sharedInstance].logined) {
        UIAlertController *alert = [UIAlertController alertControllerMessage:@"you already login" sureBlock:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // Choose one of the methods below

    // If you want to use our account system, please use this
    // warning!!!!!! warning!!!!  countryCode phoneCode, please user right code. check phoneCode file
    [[MeariUser sharedInstance] loginWithAccount:_accountTF.text password:_passwordTF.text countryCode:@"CN" phoneCode:@"86" success:^(NSDictionary *dic){
        self.errorCodeTextView.text = @"login success";
        [self.loginInButton setTitle:@"you already login" forState:(UIControlStateNormal)];
    
    } failure:^(NSError *error) {
        self.errorCodeTextView.text = error.domain;
    }];
    
    return;
    
    // If you have your own account system, please use this. Account use arbitrary string, not need register
    // warning!!!!!! warning!!!!  countryCode phoneCode, please user right code. check phoneCode file
    [[MeariUser sharedInstance] loginWithUid:_accountTF.text countryCode:@"CN" phoneCode:@"86" success:^{
        self.errorCodeTextView.text = @"login success";
        [self.loginInButton setTitle:@"you already login" forState:(UIControlStateNormal)];
        
    } failure:^(NSError *error) {
        self.errorCodeTextView.text = error.domain;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)nicknameTF:(id)sender {
}
@end
