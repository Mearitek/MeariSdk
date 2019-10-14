//
//  WYCameraSettingMotionVC.m
//  Meari
//
//  Created by 李兵 on 16/5/5.
//  Copyright © 2016年 PPStrong. All rights reserved.
//
#import "WYCameraSettingMotionVC.h"
#import "WYCameraSettingModel.h"
#import "WYCameraSettingMotionModel.h"

@interface WYCameraSettingMotionVC ()
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)UIButton *checkBtn;

@property (nonatomic, strong)UISwitch *sw;
@property (nonatomic, strong)UIButton *checkmarkBtn;
@property (nonatomic, strong)UIButton *overtimeBtn;
@property (nonatomic, strong)UILabel *desLabel;
@property (nonatomic, assign)MeariDeviceLevel level;
@property (nonatomic, strong) MeariDevice *camera;

@end

@implementation WYCameraSettingMotionVC
#pragma mark - Private
#pragma mark -- Getter
- (NSArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = @[@[[WYCameraSettingMotionModel motionSwitch]],
                            @[[WYCameraSettingMotionModel motionLow],
                              [WYCameraSettingMotionModel motionMedium],
                              [WYCameraSettingMotionModel motionHigh]],
                            ];
    }
    return _dataSource;
}
- (UISwitch *)sw {
    if (!_sw) {
        _sw = [UISwitch defaultSwitchWithTarget:self action:@selector(switchAction:)];
    }
    return _sw;
}
- (UIButton *)checkmarkBtn {
    UIButton *btn = [UIButton wy_button];
    btn.size = CGSizeMake(40, 40);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.wy_normalImage = [UIImage imageNamed:@"btn_select_small_selected"];
    return btn;
}
- (UIButton *)overtimeBtn {
    return [UIButton wy_refreshBtnWithTarget:self action:@selector(refreshAction:)];
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:WYLocalString(@"motion_des")
                                       textColor:WY_FontColor_LightGray
                                        textfont:WYFont_Text_S_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByWordWrapping
                                   lineAlignment:NSTextAlignmentLeft
                                       sizeToFit:NO];
        CGFloat w = WY_ScreenWidth - 15*2;
        CGFloat h = [label ajustedHeightWithWidth:w];
        label.size = CGSizeMake(w, h);
        _desLabel = label;
    }
    return _desLabel;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSet];
}
- (void)deallocAction {
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"MOTION");
    
    self.tableView.tableFooterView = [UIView new];
    self.level = self.camera.param.motion_detect.level;
}


#pragma mark -- Action
- (void)switchAction:(UISwitch *)sender {
    MeariDeviceLevel level = sender.isOn ? self.camera.param.motion_detect.level : MeariDeviceLevelOff;
    [self setMotionLevel:level bySwitch:YES];
}
- (void)refreshAction:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath || indexPath.row >= self.dataSource.count) return;
    [self.tableView reloadData];
}

#pragma mark -- Utilities
- (void)setLevel:(MeariDeviceLevel)level {
    if (_level == level) return;
    _level = level;
    for (NSArray *arr in self.dataSource) {
        for (WYCameraSettingMotionModel *model in arr) {
            model.selected = NO;
            if (model.level == level) {
                model.selected = YES;
//                self.previouLevel = level;
            }
        }
    }
    [self.tableView reloadData];
}
- (void)setMotionLevel:(MeariDeviceLevel)level bySwitch:(BOOL)bySwitch{
    if (self.level == level) return;
    
    static int f = 0;
    if (f == 1) return;
    f = 1;
    WY_WeakSelf
    [self.camera setAlarmLevel:level success:^(id obj) {
        f = 0;
        [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
        [WY_NotificationCenter wy_post_Device_ChangeParam:^(WYObj_Device *device) {
            device.deviceID = weakSelf.camera.info.ID;
            device.paramType = WYSettingCellTypeMotion;
            NSString *motionLevel;
            switch (weakSelf.camera.param.motion_detect.level) {
                    case MeariDeviceLevelOff: motionLevel = WYLocalString(@"motion_off"); break;
                    case MeariDeviceLevelLow: motionLevel = WYLocalString(@"motion_low"); break;
                    case MeariDeviceLevelMedium: motionLevel = WYLocalString(@"motion_medium"); break;
                    case MeariDeviceLevelHigh: motionLevel = WYLocalString(@"motion_high"); break;
                default: break;
            }
            device.paramValue = motionLevel;
        }];
        weakSelf.level = level;
    } failure:^(NSError *error) {
        f = 0;
        [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
        if (bySwitch) {
            weakSelf.sw.on = !weakSelf.sw.isOn;
        }
    }];
}


#pragma mark - Delegate
#pragma mark -- WYTranstion
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        self.camera = obj;
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.camera.param.motion_detect.enable == MeariDeviceLevelOff) {
        return 1;
    }
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        if (indexPath.section == 1) {
//            UILabel *label = [UILabel wy_new];
//            label.tag = 9999;
//            label.font = WYFont_Text_S_Normal;
//            [cell.contentView addSubview:label];
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.leading.equalTo(cell.contentView).offset(100);
//                make.centerY.equalTo(cell.contentView);
//            }];
//        }
        [cell addLineViewAtBottom];
    }
    cell.textLabel.textColor= WY_FontColor_Black;
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WY_iPhone_4 ? 50 : 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 0) {
        return nil;
    }
    UIView *v = [UIView new];
    [v addSubview:self.desLabel];
    WY_WeakSelf
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.desLabel.size);
        make.top.equalTo(v).offset(10);
        make.centerX.equalTo(v);
    }];
    if (self.camera.param.motion_detect.enable) {
        [v addLineViewAtBottom];
    }
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.desLabel.size.height+10+20;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    NSArray *arr = self.dataSource[indexPath.section];
    switch (indexPath.section) {
        case 0: {
            WYCameraSettingMotionModel *model = arr[indexPath.row];
            cell.textLabel.text = model.text;
            cell.accessoryView = self.sw;
            self.sw.on = self.camera.param.motion_detect.enable;
            break;
        }
        case 1: {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            WYCameraSettingMotionModel *model = arr[indexPath.row];
            cell.textLabel.text = model.text;
            UILabel *label = [cell viewWithTag:9999];
            label.text = model.detailedText;
            label.textColor = WY_FontColor_LightGray;
            if (model.selected) {
                label.textColor = WY_FontColor_LightBlack;
                cell.accessoryView = self.checkmarkBtn;
            }
            break;
        }
        case 2: {
            WYCameraSettingMotionModel *model = arr[indexPath.row];
            cell.textLabel.text = model.text;
            cell.detailTextLabel.text = model.detailedText;
            switch (model.accesoryType) {
                case WYSettingAccesoryTypeNormal: {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    break;
                }
                case WYSettingAccesoryTypeOverTime: {
                    cell.accessoryView = self.overtimeBtn;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                default: {
                    [cell showIndicatorView];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *arr = self.dataSource[indexPath.section];
    switch (indexPath.section) {
        case 0: {
            break;
        }
        case 1: {
            WYCameraSettingMotionModel *model = arr[indexPath.row];
            [self setMotionLevel:model.level bySwitch:NO];
            break;
        }
        default:
            break;
    }
    
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        btn.wy_normalImage = [UIImage imageNamed:@"btn_share_selected.png"];
        _checkBtn = btn;
    }
    return _checkBtn;
}


@end
