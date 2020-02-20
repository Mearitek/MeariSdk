//
//  WYVoiceDoorbellMsgCallCell.m
//  Meari
//
//  Created by MJ2009 on 2018/7/5.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYVoiceDoorbellMsgCallCell.h"
#import "WYLongPressImageView.h"

@interface WYVoiceDoorbellMsgCallCell()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) WYLongPressImageView *bubbleIV;
@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) UIImageView *phoneIV;

@property (nonatomic, assign) BOOL isReceived;
@end

@implementation WYVoiceDoorbellMsgCallCell

- (void)setModel:(WYVoiceMsgModel *)model {
    _model = model;
    self.isReceived = model.msg.msgType.integerValue == 2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.isReceived = NO;
    }
    return self;
}

- (void)initLayout {
    [self.contentView addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(8);
        make.size.mas_equalTo(50);
    }];
    self.iconIV.layer.cornerRadius = 25;
    self.iconIV.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.bubbleIV];
    [self.bubbleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconIV.mas_right).offset(8);
        make.top.mas_equalTo(self.iconIV).offset(8);
        make.right.mas_lessThanOrEqualTo(-8);
        make.bottom.mas_equalTo(-16);
    }];
    
    [self.bubbleIV addSubview:self.tipLB];
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(8);
        make.height.mas_greaterThanOrEqualTo(20);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-25);
    }];
    
    [self.bubbleIV addSubview:self.phoneIV];
    [self.phoneIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipLB.mas_right).offset(5);
        make.centerY.mas_equalTo(self.tipLB);
        make.size.mas_equalTo(15);
    }];
}

- (void)setIsReceived:(BOOL)isReceived {
    _isReceived = isReceived;
    self.tipLB.text = WY_BOOL(isReceived, WYLocalString(@"des_message_answered"), WYLocalString(@"des_message_missed"));
    NSString *phoneImgName = WY_BOOL(isReceived, @"receivedCall", @"unreceivedCall");
    self.phoneIV.image = [UIImage imageNamed:phoneImgName];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"img_voice_doorBell_msg"];
    }
    return _iconIV;
}

- (void)setDeleteAction:(void (^)(void))deleteAction {
    self.bubbleIV.deleteAction = deleteAction;
}

- (WYLongPressImageView *)bubbleIV {
    if (!_bubbleIV) {
        _bubbleIV = [WYLongPressImageView new];
        _bubbleIV.image = [UIImage imageNamed:@"grayBubble"];
    }
    return _bubbleIV;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [UILabel new];
        _tipLB.font = WYFont_Text_XS_Normal;
        _tipLB.numberOfLines = 0;
        _tipLB.text = WYLocalString(@"des_message_answered");
    }
    return _tipLB;
}

- (UIImageView *)phoneIV {
    if (!_phoneIV) {
        _phoneIV = [UIImageView new];
        _phoneIV.image = [UIImage imageNamed:@"receivedCall"];
    }
    return _phoneIV;
}

@end
