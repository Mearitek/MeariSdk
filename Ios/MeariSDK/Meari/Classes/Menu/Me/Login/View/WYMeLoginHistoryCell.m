//
//  WYMeLoginHistoryCell.m
//  Meari
//
//  Created by 李兵 on 2017/9/19.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeLoginHistoryCell.h"

@interface WYMeLoginHistoryCell ()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end

@implementation WYMeLoginHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addLineViewAtBottom];
    self.accountLabel.font = WYFont_Text_XS_Normal;
    self.accountLabel.textColor = WY_FontColor_Gray;
    self.deleteBtn.wy_normalImage = [UIImage imageNamed:@"btn_me_delete_normal"];
}
- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(WYMeLoginHistoryCell:deleteUser:)]) {
        [self.delegate WYMeLoginHistoryCell:self deleteUser:self.accountLabel.text];
    }
}



@end
