//
//  WYDoorbellSettingJingleBellPairingVC.m
//  Meari
//
//  Created by FMG on 2017/11/6.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorbellSettingJingleBellPairingVC.h"
#import "WYDoorbellSettingJingleBellPairCell.h"
#import "WYDoorbellSettingJingleBellPairFooterView.h"

@interface WYDoorbellSettingJingleBellPairingVC ()<WYDoorbellSettingJingleBellPairDelegate>
@property (nonatomic, strong) WYDoorbellSettingJingleBellPairFooterView *footerView;

@property (nonatomic, strong)MeariDevice *camera;

@end

@implementation WYDoorbellSettingJingleBellPairingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
}
- (void)initSet {
    self.title = WYLocalString(@"JINGLE BELL PAIRING");
    [self.tableView registerNib:[UINib nibWithNibName:WY_ClassName(WYDoorbellSettingJingleBellPairCell) bundle:nil] forCellReuseIdentifier:WY_ClassName(WYDoorbellSettingJingleBellPairCell)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [WYTableHeaderView header_prompt_jingleBellPairing];
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - transition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if(WY_IsKindOfClass(obj, MeariDevice)) {
        self.camera = obj;
    }
}

#pragma mark - WYDoorbellSettingJingleBellPairDelegate
- (void)doorbellSettingJingleBellPairFooterView:(WYDoorbellSettingJingleBellPairFooterView *)footerView didClickPairButton:(UIButton *)btn {
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [self.camera setDoorBellJingleBellPairingSuccess:^{
        WY_HUD_DISMISS
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WY_HUD_SHOW_TOAST(WYLocalString(@"device_jingleBell_pairing"))
            //            [footerView successdPairing];
        });
        //无法获取状态
        //[footerView startPairing];
        //[weakSelf getDoorbellJingleBellPairStatusWithFooterView:footerView];
    } failure:^(NSError *error) {
         WY_HUD_SHOW_Failure
    }];
}
- (void)getDoorbellJingleBellPairStatusWithFooterView:(WYDoorbellSettingJingleBellPairFooterView *)footerView {
    WY_WeakSelf
    footerView.timeout = ^{
        return;
    };
//    [self.camera getDoorebllJingleBellStatusSuccess:^(id obj) {
//        NSInteger status = [obj[@"status"] integerValue];
//        if (status == 1) {
//            [footerView successdPairing];
//        } else {
//            [weakSelf getDoorbellJingleBellPairStatusWithFooterView:footerView];
//        }
//    } failure:^(NSString *error) {
//        [footerView failuredPairing];
//        WY_HUD_SHOW_Failure
//    }];
}
- (void)doorbellSettingJingleBellPairFooterView:(WYDoorbellSettingJingleBellPairFooterView *)footerView didClickUnbindButton:(UIButton *)btn {
    [WYAlertView showWithTitle:WYLocal_Tips message:WYLocalString(@"alert_jingleBellUnbind") cancelButton:WYLocal_Cancel otherButton:WYLocal_OK alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex) {
            WY_HUD_SHOW_WAITING
            [self.camera setDoorebllJingleBellUnbindSuccess:^{
                WY_HUD_SHOW_TOAST(WYLocalString(@"status_success_unbind"));
            } failure:^(NSError *error) {
                WY_HUD_SHOW_TOAST(WYLocalString(@"fail_unbind"));
            }];
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYDoorbellSettingJingleBellPairCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYDoorbellSettingJingleBellPairCell)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WYDoorbellSettingJingleBellPairCell cellHeight];
}

#pragma mark - lazyLoad
- (WYDoorbellSettingJingleBellPairFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[WYDoorbellSettingJingleBellPairFooterView alloc] initWithFrame:CGRectMake(0, 0, WY_ScreenWidth, 200)];
        _footerView.delegate = self;
    }
    return _footerView;
}
@end
