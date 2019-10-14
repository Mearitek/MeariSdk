//
//  WYDoorBellSettingPowerManagementVC.m
//  Meari
//
//  Created by FMG on 2017/7/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingPowerManagementVC.h"
#import "WYDoorBellSettingSwitchView.h"

@interface WYDoorBellSettingPowerManagementVC ()<WYDoorBellSettingSwitchViewDelegate,UITableViewDelegate>
@property (nonatomic, strong) WYDoorBellSettingSwitchView *headerView;
@property (nonatomic, strong) MeariDeviceParamBell *doorBell;
@property (nonatomic, strong)MeariDevice *camera;

@end

@implementation WYDoorBellSettingPowerManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInit];
}
- (void)setInit {
    self.title = WYLocalString(@"POWER MANAGEMENT");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - WYDoorBellSettingSwitchViewDelegate
- (void)doorBellSettingSwitchView:(WYDoorBellSettingSwitchView *)view switchOpen:(BOOL)open {
    WY_WeakSelf
    [WYAlertView showWithTitle:WYLocal_Tips message:open? WYLocalString(@"alert_lowPowerOpen"):WYLocalString(@"alert_lowPowerClose") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            [weakSelf setLowPower:open];
        } else {
            [view setSwitchOpen:!open];
        }
    }];

}
- (void)setLowPower:(BOOL)open {
    WY_WeakSelf
    [self.camera setDoorBellLowPowerOpen:open success:^{
        [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
    } failure:^(NSError *error) {
        [weakSelf.headerView setSwitchOpen:NO];
        [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
    }];
}

#pragma mark - transition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if(WY_IsKindOfClass(obj, NSArray)) {
        NSArray *param = (NSArray *)obj;
        self.camera = param[0];
        if (WY_IsKindOfClass(param[1], MeariDeviceParamBell)) {
            self.doorBell = param[1];
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(UITableViewCell)];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:WY_ClassName(UITableViewCell)];
    }
    [cell addLineViewAtTop];
    [cell addLineViewAtBottom];
    cell.textLabel.textColor = WY_FontColor_Black;
    cell.detailTextLabel.textColor = WY_FontColor_Black;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!indexPath.row) {
        cell.textLabel.text = WYLocalString(@"Power Supply Mode");
        if ([self.doorBell.power isEqualToString:@"battery"]) {
            cell.detailTextLabel.text = WYLocalString(@"Battery Powered");
        } else if([self.doorBell.power isEqualToString:@"wire"]) {
            cell.detailTextLabel.text = WYLocalString(@"Power Supply");
        }
    } else {
        cell.textLabel.text = WYLocalString(@"Battery Remain");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%",self.doorBell.battery.percent];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    UILabel *title = [UILabel new];
    title.textColor = WY_FontColor_Gray;
    BOOL isPlural = self.doorBell.battery.remain/24 >1;
    title.text = [NSString stringWithFormat:@"%@ %ld %@",WYLocalString(@"Expected Remain"),self.doorBell.battery.remain/24,isPlural ? WYLocalString(@"Days"): WYLocalString(@"Day")];
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(5);
        make.trailing.equalTo(view).offset(-15);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.headerView viewHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - lazyLoad
- (WYDoorBellSettingSwitchView *)headerView {
    if (!_headerView) {
        _headerView = [[WYDoorBellSettingSwitchView alloc] initWithSwTitle:WYLocalString(@"Low Power Mode") description:WYLocalString(@"des_powerManagement")];
        _headerView.delegate = self;
        [_headerView setSwitchOpen:self.doorBell.pwm];
    }
    return _headerView;
}


@end
