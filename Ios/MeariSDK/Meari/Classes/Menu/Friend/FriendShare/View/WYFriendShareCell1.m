//
//  WYFriendShareCell1.m
//  Meari
//
//  Created by 李兵 on 2017/9/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendShareCell1.h"
#import "WYFriendShareModel1.h"
@interface WYFriendShareCell1 ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation WYFriendShareCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.label.font = WYFont_Text_M_Normal;
    self.label.textColor = WY_FontColor_Black;
    self.tf.font = WYFont_Text_S_Normal;
    self.tf.textColor = WY_FontColor_LightBlack;
    self.tf.delegate = self;
    self.tf.textAlignment = NSTextAlignmentRight;
    self.tf.returnKeyType = UIReturnKeyDone;
    self.btn.hidden = YES;
    self.btn.wy_normalImage = [UIImage select_small_selected_image];
    [self addLineViewAtBottom];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- Action
- (IBAction)saveAction:(UIButton *)sender {
    [self.tf resignFirstResponder];
    self.btn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(WYFriendShareCell1:didTapedSaveBtn:)]) {
        [self.delegate WYFriendShareCell1:self didTapedSaveBtn:sender];
    }
}
- (IBAction)didEndEditing:(UITextField *)sender {
    self.btn.hidden = YES;
}
- (IBAction)didBeginEditing:(UITextField *)sender {
}
- (IBAction)didChanged:(UITextField *)sender {
    self.btn.hidden = NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveAction:self.btn];
    return YES;
}


#pragma mark - Public
- (void)setModel:(WYFriendShareModel1 *)model {
    _model = model;
    self.label.text = model.text;
    self.tf.text = model.detailedText;
    self.tf.enabled = model.editable;
}

@end

