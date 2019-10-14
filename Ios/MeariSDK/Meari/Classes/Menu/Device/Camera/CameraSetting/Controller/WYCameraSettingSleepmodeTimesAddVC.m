//
//  WYCameraSettingSleepmodeTimesAddVC.m
//  Meari
//
//  Created by 李兵 on 2017/1/15.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraSettingSleepmodeTimesAddVC.h"
#import "WYCameraSettingSleepmodeTimesModel.h"
#import "WYCameraSettingSleepmodeAddModel.h"

typedef NS_ENUM(NSInteger, WYSleepModeTimeType) {
    WYSleepModeTimeTypeStarttime = 10000,
    WYSleepModeTimeTypeStoptime = 10001
};
@interface WYCameraSettingSleepmodeTimesAddVC ()
{
    BOOL _saved;
    NSMutableArray *_tmpDataSource;
    WYCameraSettingSleepmodeWeekdays _finalWeekdays;
    BOOL _needSetSleep;
}
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)WYDatePicker *datePicker;

@property (nonatomic, strong)WYCameraSettingSleepmodeTimesModel *sleepmodeModel;
@property (nonatomic, strong)WYCameraSettingSleepmodeTimesModel *originalSleepmodeModel;
@property (nonatomic, strong)NSArray *times;
@property (nonatomic, strong)NSArray *weekdays;
@property (nonatomic, strong)WYCameraSettingSleepmodeAddModel *startTime;
@property (nonatomic, strong)WYCameraSettingSleepmodeAddModel *stopTime;
@property (nonatomic, strong)MeariDevice *camera;


@end

@implementation WYCameraSettingSleepmodeTimesAddVC
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [WYInstructionView cameraSetting_SleepmodeTimesAdd];
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView =
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel labelWithFrame:CGRectZero text:WYLocalString(@"Select weekday") textColor:WY_FontColor_Gray textfont:WYFont_Text_S_Normal numberOfLines:0 lineBreakMode:NSLineBreakByWordWrapping lineAlignment:NSTextAlignmentLeft sizeToFit:NO];
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_headerView).with.offset(15);
            make.trailing.equalTo(_headerView).with.offset(-15);
            make.centerY.equalTo(_headerView);
        }];
        [_headerView addLineViewAtBottom];
        _headerView.frame = CGRectMake(0, 0, WY_ScreenWidth, 30);
    }
    return _headerView;
}
- (WYDatePicker *)datePicker {
    if (!_datePicker) {
        WY_WeakSelf
        WYDatePicker *dateP = [WYDatePicker datePickerWithSaveTask:^(NSString *time) {
            if (weakSelf.datePicker.tag == WYSleepModeTimeTypeStarttime) {
                weakSelf.startTime.detailedText = time;
            }else {
                if ([time isEqualToString:@"00:00"]) {
                    time = @"24:00";
                }
                weakSelf.stopTime.detailedText = time;
            }
            [weakSelf.tableView reloadData];
        }];
        _datePicker = dateP;
        [self.view addSubview:_datePicker];
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
    }
    return _datePicker;
}

- (NSArray *)times {
    if (!_times) {
        WYCameraSettingSleepmodeAddModel *startM = [WYCameraSettingSleepmodeAddModel starttimeModel];
        WYCameraSettingSleepmodeAddModel *endM = [WYCameraSettingSleepmodeAddModel endtimeModel];
        startM.detailedText = self.sleepmodeModel.startTime;
        endM.detailedText = self.sleepmodeModel.stopTime;
        _times = @[startM, endM];
    }
    return _times;
}
- (NSArray *)weekdays {
    if (!_weekdays) {
        WYCameraSettingSleepmodeAddModel *m1 = [WYCameraSettingSleepmodeAddModel mondayModel];
        WYCameraSettingSleepmodeAddModel *m2 = [WYCameraSettingSleepmodeAddModel tuesdayModel];
        WYCameraSettingSleepmodeAddModel *m3 = [WYCameraSettingSleepmodeAddModel wednesdayModel];
        WYCameraSettingSleepmodeAddModel *m4 = [WYCameraSettingSleepmodeAddModel thursdayModel];
        WYCameraSettingSleepmodeAddModel *m5 = [WYCameraSettingSleepmodeAddModel fridayModel];
        WYCameraSettingSleepmodeAddModel *m6 = [WYCameraSettingSleepmodeAddModel saturdayModel];
        WYCameraSettingSleepmodeAddModel *m7 = [WYCameraSettingSleepmodeAddModel sundayModel];
        m1.selected = self.sleepmodeModel.weekdays & WYCameraSettingSleepmodeMonday;
        m2.selected = self.sleepmodeModel.weekdays & WYCameraSettingSleepmodeTuesday;
        m3.selected = self.sleepmodeModel.weekdays & WYCameraSettingSleepmodeWednesday;
        m4.selected = self.sleepmodeModel.weekdays & WYCameraSettingSleepmodeThursday;
        m5.selected = self.sleepmodeModel.weekdays & WYCameraSettingSleepmodeFriday;
        m6.selected = self.sleepmodeModel.weekdays & WYCameraSettingSleepmodeSaturday;
        m7.selected = self.sleepmodeModel.weekdays & WYCameraSettingSleepmodeSunday;

        _weekdays = @[m1, m2, m3, m4, m5, m6, m7];
    }
    return _weekdays;
}
- (WYCameraSettingSleepmodeAddModel *)startTime {
    return self.times.firstObject;
}
- (WYCameraSettingSleepmodeAddModel *)stopTime {
    return self.times.lastObject;
}


#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"EditSleepModeTime");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem checkmarkImageItemWithTarget:self action:@selector(saveAction:)];

    self.sleepmodeModel.startTime  = self.sleepmodeModel.startTime ? self.sleepmodeModel.startTime : @"00:00";
    self.sleepmodeModel.stopTime  = self.sleepmodeModel.stopTime ? self.sleepmodeModel.stopTime : @"00:00";
}
- (void)initLayout {
    WY_WeakSelf
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.topView.size);
        make.centerX.top.equalTo(weakSelf.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];

}

#pragma mark -- Utilities
- (UIButton *)createSelectBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.userInteractionEnabled = NO;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setImage:[UIImage select_small_normal_image] forState:UIControlStateNormal];
    [btn setImage:[UIImage select_small_selected_image] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
}


#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [self wy_popToVC:WYVCTypeCameraSettingSleepmodeTimes sender:_saved ? self.sleepmodeModel : nil];
}
- (void)saveAction:(UIButton *)sender {

    if (_finalWeekdays == 0) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"fail_setWeekday"))
        return;
    }
    if (self.datePicker.showing) {
        return;
    }
    if ([self.startTime.detailedText isEqualToString:@"00:00"] && [self.stopTime.detailedText isEqualToString:@"00:00"]) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"fail_setSleepmodeTime0000"))
        return;
    }
    if ([self.startTime.detailedText compare:self.stopTime.detailedText] != NSOrderedAscending) {
        WY_HUD_SHOW_STATUS(WYLocalString(@"fail_setSleepmodeTime"))
        return ;
    }
    if ([self.startTime.detailedText isEqualToString:self.originalSleepmodeModel.startTime] &&
        [self.stopTime.detailedText isEqualToString:self.originalSleepmodeModel.stopTime] &&
        _finalWeekdays == self.originalSleepmodeModel.weekdays) {
        return;
    }
    for (WYCameraSettingSleepmodeTimesModel *model in _tmpDataSource) {
        if ([self.startTime.detailedText isEqualToString:model.startTime] &&
            [self.stopTime.detailedText isEqualToString:model.stopTime] &&
            _finalWeekdays == model.weekdays) {
            WY_HUD_SHOW_STATUS(WYLocalString(@"status_sleepmodeTimeHasBeenAdded"));
            return;
        }
    }
    self.sleepmodeModel.startTime = self.startTime.detailedText;
    self.sleepmodeModel.stopTime = self.stopTime.detailedText;
    self.sleepmodeModel.weekdays = _finalWeekdays;
    NSMutableArray *arr = _tmpDataSource.mutableCopy;
    if (![arr containsObject:self.sleepmodeModel]) {
        [arr addObject:self.sleepmodeModel];
    }
    
    NSMutableArray *timesArr = [NSMutableArray arrayWithCapacity:arr.count];
    for (WYCameraSettingSleepmodeTimesModel *m in arr) {
        if (m.time) {
            [timesArr addObject:m.time];
        }
    }
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    UIViewController <WYTransition> *vc = self.wy_pushFromVC;
    BOOL open = (_needSetSleep || vc.wy_pushFromVCType == WYVCTypeCameraVideoOne);
    [self.camera setSleepmodeTime:open times:timesArr success:^{
        WY_HUD_SHOW_SUCCESS_STATUS_VC(WYLocalString(@"success_set"), weakSelf)
        _saved = YES;
        [weakSelf backAction:nil];
    }failure:^(NSError *error) {
        WY_HUD_SHOW_FAILURE_STATUS_VC(WYLocalString(@"fail_set"), weakSelf)
    }];
}
- (void)selectAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYCameraSettingSleepmodeWeekdays weekday = 1 << indexPath.row;
    WYCameraSettingSleepmodeAddModel *model = self.weekdays[indexPath.row];
    model.selected = weekday == model.weekday;
    if (sender.isSelected) {
        _finalWeekdays |= weekday;
    }else {
        _finalWeekdays &= ~weekday;
    }
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeCameraSettingSleepmodeTimes: {
            if (WY_IsKindOfClass(obj, NSArray)) {
                NSArray *arr = obj;
                if (WY_IsKindOfClass(arr.lastObject, NSString)) {
                    _needSetSleep = YES;
                    if (arr.count == 3) {
                        self.camera = arr[0];
                        _tmpDataSource = arr[1];
                        self.sleepmodeModel = [WYCameraSettingSleepmodeTimesModel new];
                        self.sleepmodeModel.enabled = YES;
                    }else if (arr.count == 4) {
                        self.camera = arr[0];
                        self.sleepmodeModel = arr[1];
                        _tmpDataSource = arr[2];
                    }
                }else {
                    if (arr.count == 2) {
                        self.camera = arr[0];
                        _tmpDataSource = arr[1];
                        self.sleepmodeModel = [WYCameraSettingSleepmodeTimesModel new];
                        self.sleepmodeModel.enabled = YES;
                    }else if (arr.count == 3) {
                        self.camera = arr[0];
                        self.sleepmodeModel = arr[1];
                        _tmpDataSource = arr[2];
                    }
                }
                self.originalSleepmodeModel = self.sleepmodeModel.copy;
                _finalWeekdays = self.originalSleepmodeModel.weekdays;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.times.count;
    }
    return self.weekdays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell addLineViewAtBottom];
    }
    switch (indexPath.section) {
        case 0: {
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            WYCameraSettingSleepmodeAddModel *model = self.times[indexPath.row];
            cell.textLabel.text = model.text;
            cell.detailTextLabel.text = model.detailedText;
            break;
        }
        case 1: {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            WYCameraSettingSleepmodeAddModel *model = self.weekdays[indexPath.row];
            cell.textLabel.text = model.text;
            cell.detailTextLabel.text = nil;
            cell.accessoryView = [self createSelectBtn];
            ((UIButton*)cell.accessoryView).selected = model.selected;
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.headerView.height;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    self.datePicker.tag = WYSleepModeTimeTypeStarttime;
                    [self.datePicker showTime:cell.detailTextLabel.text];
                    break;
                }
                case 1: {
                    self.datePicker.tag = WYSleepModeTimeTypeStoptime;
                    [self.datePicker showTime:cell.detailTextLabel.text];
                    break;
                }

                default:
                    break;
            }
            break;
        }
        case 1: {
            [self selectAction:(UIButton *)cell.accessoryView];
        }
        default:
            break;
    }
}

@end
