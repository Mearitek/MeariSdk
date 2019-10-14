//
//  WYCameraSearchCell.m
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraSearchCell.h"


@interface WYCameraSearchCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendIconWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBtnWidth;

@end

@implementation WYCameraSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.font = WYFont_Text_S_Normal;
    self.nameLabel.textColor = WY_FontColor_Black;
    self.accountLabel.font = WYFont_Text_XS_Normal;
    self.accountLabel.textColor = WY_FontColor_Gray;
    self.actionBtn.layer.cornerRadius = 15;
    self.actionBtn.layer.masksToBounds = YES;
    self.actionBtn.titleLabel.font = WYFont_Text_M_Normal;
    [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bottomLine.backgroundColor = WY_LineColor_LightGray;
    self.leftLine.backgroundColor = WY_LineColor_LightGray;
    self.friendIconWidthConstraint.constant = 0;
    self.accountLeadingConstraint.constant = 0;
    self.actionBtnWidth.constant = [self actionBtnMaxWidth];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.actionBtn.layer.cornerRadius = self.actionBtn.height/2;
    self.actionBtn.layer.masksToBounds = YES;
}
- (CGFloat)actionBtnMaxWidth {
    NSArray *arr = @[WYLocalString(@"ADD"),
                     WYLocalString(@"ADDED"),
                     WYLocalString(@"NOT SHARED"),
                     WYLocalString(@"SHARED"),
                     WYLocalString(@"SHARING")
                     ];
    NSDictionary *dic = @{NSFontAttributeName:self.actionBtn.titleLabel.font};
    CGFloat w = 50;
    for (NSString *str in arr) {
        CGFloat w2 = round([str sizeWithAttributes:dic].width);
        w = w2 > w ? w2 : w;
    }
    return w+16;
}
- (void)setDevice:(MeariDevice *)device {
    _device = device;
    if (device.info.type == MeariDeviceTypeNVR) {
        [self setNVR];
    }else {
        [self setCamera];
    }
}

#pragma mark private
- (void)setNVR {
    self.friendIconWidthConstraint.constant = self.device.info.shared ? 20 : 0;
    self.accountLeadingConstraint.constant = self.device.info.shared ? 5 : 0;
    
    BOOL enabled;
    NSString *account;
    NSString *title;
    UIImage *bgImage;
    NSString *iconUrl;
    switch (self.device.info.addStatus) {
        case MeariDeviceAddStatusSelf: {
            enabled = NO;
            account = WYLocalString(@"My NVR");
            bgImage = [UIImage imageNamed:@"bg_gray"];
            title = WYLocalString(@"ADDED");
            iconUrl = @"img_nvr_gray";
            break;
        }
//        case MeariDeviceAddStatusUnShare: {
//            enabled = YES;
//            account = self.device.userAccount;
//            title = WYLocalString(@"NOT SHARED");
//            bgImage = [UIImage bgGreenImage];
//            iconUrl = @"img_nvr_green";
//            break;
//        }
        case MeariDeviceAddStatusNone: {
            enabled = YES;
            account = WYLocalString(@"Not added");
            title = WYLocalString(@"ADD");
            bgImage = [UIImage bgGreenImage];
            iconUrl = @"img_nvr_green";
            break;
        }
//        case MeariDeviceAddStatusShared: {
//            enabled = NO;
//            account = self.device.userAccount;
//            title = WYLocalString(@"SHARED");
//            bgImage = [UIImage imageNamed:@"bg_gray"];
//            iconUrl = @"img_nvr_gray";
//            break;
//        }
//        case MeariDeviceAddStatusSharing: {
//            enabled = NO;
//            account = self.device.userAccount;
//            title = WYLocalString(@"SHARING");
//            bgImage = [UIImage imageNamed:@"bg_gray"];
//            iconUrl = @"img_nvr_gray";
//            break;
//        }
        default: {
            enabled = NO;
            account = self.device.info.userAccount;
            bgImage = nil;
            title = nil;
            iconUrl = @"img_nvr_gray";
            break;
        }
    }
    self.accountLabel.text = account;
    self.actionBtn.userInteractionEnabled = enabled;
    [self.actionBtn setTitle:title forState:UIControlStateNormal];
    [self.actionBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    self.leftLine.hidden = YES;
    self.nameLabel.text = self.device.info.sn;
    self.typeIconImageView.image = [UIImage imageNamed:iconUrl];
}
- (void)setCamera {
    self.friendIconWidthConstraint.constant = self.device.info.shared ? 20 : 0;
    self.accountLeadingConstraint.constant = self.device.info.shared ? 5 : 0;

    BOOL enabled;
    NSString *account;
    NSString *title;
    UIImage *bgImage;
    NSString *iconUrl;
    
    switch (self.device.info.addStatus) {
        case MeariDeviceAddStatusSelf: {
            enabled = NO;
            account = WYLocalString(@"My Camera");
            title = WYLocalString(@"ADDED");
            bgImage = [UIImage imageNamed:@"bg_gray"];
            iconUrl = self.device.info.grayIconUrl;
            break;
        }
        case MeariDeviceAddStatusUnShare: {
            enabled = YES;
            account = self.device.info.userAccount;
            title = WYLocalString(@"NOT SHARED");
            bgImage = [UIImage bgGreenImage];
            iconUrl = self.device.info.iconUrl;
            break;
        }
        case MeariDeviceAddStatusNone: {
            enabled = YES;
            account = WYLocalString(@"Not added");
            title = WYLocalString(@"ADD");
            bgImage = [UIImage bgGreenImage];
            iconUrl = self.device.info.iconUrl;
            break;
        }
        case MeariDeviceAddStatusShared: {
            enabled = NO;
            account = self.device.info.userAccount;
            title = WYLocalString(@"SHARED");
            bgImage = [UIImage imageNamed:@"bg_gray"];
            iconUrl = self.device.info.iconUrl;
            break;
        }
        case MeariDeviceAddStatusSharing: {
            enabled = NO;
            account = self.device.info.userAccount;
            title = WYLocalString(@"SHARING");
            bgImage = [UIImage imageNamed:@"bg_gray"];
            iconUrl = self.device.info.grayIconUrl;;
            break;
        }
    }
    self.accountLabel.text = account;
    self.actionBtn.userInteractionEnabled = enabled;
    [self.actionBtn setTitle:title forState:UIControlStateNormal];
    [self.actionBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    self.leftLine.hidden = YES;
    self.nameLabel.text = self.device.info.nickname;
    [self.typeIconImageView wy_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage placeholder_device2_image]];
    
    
}

- (IBAction)actionAction:(UIButton *)sender {
    switch (self.device.info.addStatus) {
        case MeariDeviceAddStatusUnShare: {
            if ([self.delegate respondsToSelector:@selector(WYCameraSearchCell:tapActionButtonToShare:)]) {
                [self.delegate WYCameraSearchCell:self tapActionButtonToShare:sender];
            }
            break;
        }
        case MeariDeviceAddStatusNone: {
            if ([self.delegate respondsToSelector:@selector(WYCameraSearchCell:tapActionButtonToAdd:)]) {
                [self.delegate WYCameraSearchCell:self tapActionButtonToAdd:sender];
            }
            break;
        }
        default: {
            break;
        }
    }
}

@end
