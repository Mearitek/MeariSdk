//
//  WYNickTextField.m
//  Meari
//
//  Created by 李兵 on 16/8/16.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYNickTextField.h"

@interface WYNickTextField ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfTrailing;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL saveAction;

@end

@implementation WYNickTextField
#pragma mark - Private
#pragma mark -- Getter
#pragma mark -- Init
#pragma mark -- Life
- (void)initAction {
    self.textField.font = WYFont_Text_L_Bold;
    self.textField.placeholder     = WYLocalString(@"rectify_inputNickname");
    self.textField.returnKeyType   = UIReturnKeyDone;
    [self.textField addTarget:self action:@selector(textDidChangedAction:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    self.saveBtn.backgroundColor = WY_MainColor;
    self.saveBtn.hidden = YES;
    [self.saveBtn setImage:[UIImage imageNamed:@"btn_ok_normal"] forState:UIControlStateNormal];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = self.saveBtn.height/2;
}

#pragma mark -- Action
- (IBAction)beginEditingAction:(UITextField *)sender {
    self.saveBtn.hidden = NO;
    self.saveBtn.alpha = 0;
    self.saveBtn.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.saveBtn.alpha = 1.0;
        self.saveBtn.transform = CGAffineTransformIdentity;
        self.tfTrailing.constant = self.height;
    } completion:^(BOOL finished) {
        if (finished) {
            self.saveBtn.hidden = NO;
        }
    }];
    
}
- (IBAction)didEndEditingAction:(UITextField *)sender {
    self.saveBtn.hidden = NO;
    self.saveBtn.alpha = 1.0;
    self.saveBtn.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.saveBtn.alpha = 0.0;
        self.saveBtn.transform = CGAffineTransformMakeScale(0, 0);
        self.tfTrailing.constant = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.saveBtn.hidden = YES;
        }
    }];
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

#pragma mark - Delegate
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (WY_IsKindOfClass(self.target, UIResponder)) {
        UIResponder *target = self.target;
        if ([target canPerformAction:self.saveAction withSender:nil]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:self.saveAction withObject:nil];
#pragma clang diagnostic pop
        }
        
    }
    if (self.returnBlock) {
        self.returnBlock();
    }
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

#pragma mark - Public
+ (instancetype)textFieldWithFrame:(CGRect)frame borderd:(BOOL)bordered target:(id)target saveAction:(SEL)saveAction{
    WYNickTextField *tf = [[UINib nibWithNibName:WY_ClassName(WYNickTextField) bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    tf.frame = frame;
    
    if (bordered) {
        tf.layer.cornerRadius = 5.0f;
        tf.layer.masksToBounds = YES;
        tf.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0].CGColor;
        tf.layer.borderWidth = 1.0f;
    }
    
    if (target && saveAction) {
        tf.target = target;
        tf.saveAction = saveAction;
        [tf.saveBtn addTarget:target action:saveAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return tf;
}
+ (instancetype)roundTextFieldWithFrame:(CGRect)frame target:(id)target saveAction:(SEL)saveAction {
    WYNickTextField *tf = [[UINib nibWithNibName:WY_ClassName(WYNickTextField) bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    tf.frame = frame;
    
    tf.layer.masksToBounds = YES;
    tf.layer.cornerRadius = CGRectGetHeight(frame)/2;
    tf.layer.borderColor = WY_MainColor.CGColor;
    tf.layer.borderWidth = 1.0f;
    
    tf.textField.textAlignment = NSTextAlignmentCenter;
    
    if (target && saveAction) {
        tf.target = target;
        tf.saveAction = saveAction;
        [tf.saveBtn addTarget:target action:saveAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return tf;
}

@end
