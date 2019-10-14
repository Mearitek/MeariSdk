//
//  WYMeSignupCell.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeSignupCell.h"
#import "WYMeSignupModel.h"
@interface WYMeSignupCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation WYMeSignupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.line.backgroundColor = WY_LineColor_LightGray;
    self.tf.font = WYFont_Text_S_Normal;
    [self.tf setValue:WYFont_Text_S_Normal forKeyPath:@"_placeholderLabel.font"];
    self.tf.clearButtonMode = UITextFieldViewModeNever;
    
    [self.tf addTarget:self action:@selector(textDidChangedAction:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textDidChangedAction:(UITextField *)sender {
    if (self.model.tfType == WYTextFieldTypeNickName) {
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
}

#pragma mark - Public
- (void)setModel:(WYMeSignupModel *)model {
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.imageName];
    self.tf.text = model.text;
    self.tf.placeholder = model.placeholder;
    self.tf.returnKeyType = model.returnType;
    self.tf.keyboardType = model.keyboardType;
    self.tf.secureTextEntry = model.secure;
}

@end
