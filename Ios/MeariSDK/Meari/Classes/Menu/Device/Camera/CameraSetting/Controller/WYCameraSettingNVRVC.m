//
//  WYCameraSettingNVRVC.m
//  Meari
//
//  Created by 李兵 on 2017/1/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingNVRVC.h"

@interface WYCameraSettingNVRVC ()
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)MeariDevice *camera;

@end

@implementation WYCameraSettingNVRVC
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:WYLocalString(@"des_cameraSettingNVR")
                                       textColor:WY_FontColor_Gray
                                        textfont:WYFont_Text_S_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByWordWrapping
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:NO];
        [_bottomView addSubview:label];
        CGFloat w = WY_ScreenWidth-30;
        CGFloat h = [label ajustedHeightWithWidth:w];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(w));
            make.height.equalTo(@(h));
            make.top.equalTo(label.superview).with.offset(10);
            make.centerX.equalTo(label.superview);
        }];
        
        UIButton *btn = [UIButton defaultGreenBounderButtonWithTarget:self action:@selector(unbindAction:)];
        [btn setTitle:WYLocalString(@"REMOVE CAMERA") forState:UIControlStateNormal];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [_bottomView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(btn.superview.mas_width).multipliedBy(0.7);
            make.height.equalTo(@(40));
            make.centerX.equalTo(btn.superview);
            make.top.equalTo(label.mas_bottom).with.offset(20);
        }];
        
        _bottomView.frame = CGRectMake(0, 0, WY_ScreenWidth, h+10+20+40+20);
    }
    return _bottomView;
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"NVR");
    self.showNavigationLine = YES;
    self.tableView.scrollEnabled = NO;
}
- (void)initLayout {
    
    
}
#pragma mark -- Utilities

#pragma mark -- Network
- (void)networkRequestUnbind {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] unbindDevice:self.camera.info.ID toNVR:self.camera.info.nvrID success:^{
        WY_HUD_DISMISS
        [weakSelf dealNetworkRequestUnbind];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealNetworkRequestUnbind {
    self.camera.hasBindedNvr = NO;
    [self wy_popToVC:WYVCTypeCameraSetting sender:@(0)];
}
#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
}
#pragma mark -- Action
- (void)unbindAction:(UIButton *)sender {
    WY_WeakSelf
    [WYAlertView showWithTitle:WYLocalString(@"Unbind")
                       message:WYLocalString(@"warn_unbindDevice")
                  cancelButton:WYLocal_Cancel
                   otherButton:WYLocalString(@"Unbind")
                   alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                       if (buttonIndex == alertView.firstOtherButtonIndex) {
                           [weakSelf networkRequestUnbind];
                       }
                   }];
}


#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    switch (VCType) {
        case WYVCTypeCameraSetting: {
            if (WY_IsKindOfClass(obj, MeariDevice)) {
                self.camera = obj;
            }
            break;
        }
        default:
            break;
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell addLineViewAtBottom];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = WYLocalString(@"SN");
    cell.detailTextLabel.text = self.camera.info.sn;
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.bottomView.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.bottomView;
}



@end
