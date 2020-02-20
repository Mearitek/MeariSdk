//
//  WYCameraSettingMessageBoardVC.m
//  Meari
//
//  Created by MJ2009 on 2018/7/6.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYCameraSettingMessageBoardVC.h"

@interface WYCameraSettingMessageBoardVC ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomSelectView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) BOOL isSelectingWaitDuration;

@end

@implementation WYCameraSettingMessageBoardVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 30;
        _tableView.sectionHeaderHeight = 50;
        _tableView.sectionFooterHeight = 0;
    }
    return _tableView;
}

- (UIView *)bottomSelectView {
    if (!_bottomSelectView) {
        _bottomSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, WY_ScreenHeight, WY_ScreenWidth, 200)];
        _bottomSelectView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomSelectView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = WYLocalString(@"device_setting_message_board");
    [self initLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initLayout {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.view addSubview:self.bottomSelectView];
    
    UIButton *cancelBtn = [UIButton new];
    [self.bottomSelectView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    [cancelBtn setWy_normalTitle:WYLocalString(@"CANCEL")];
    [cancelBtn setWy_normalTitleColor:WY_MainColor];
    [cancelBtn addTapGestureTarget:self action:@selector(cancelBtnClicked:)];
    
    UIButton *confirmBtn = [UIButton new];
    [self.bottomSelectView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(cancelBtn);
        make.size.mas_equalTo(cancelBtn);
    }];
    [confirmBtn setWy_normalTitle:WYLocalString(@"OK")];
    [confirmBtn setWy_normalTitleColor:WY_MainColor];
    [confirmBtn addTapGestureTarget:self action:@selector(confirmBtnClicked:)];
    
    [self.bottomSelectView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(cancelBtn.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Tool Method
- (void)cancelBtnClicked:(UIButton *)btn {
    [self hideBottomView];
}
- (void)confirmBtnClicked:(UIButton *)btn {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    float selectedValue = (selectedRow + 2) * 10;
    if (self.isSelectingWaitDuration) {
        [self.camera iotSetDoorBellCallWaitTime:selectedValue success:^{
            [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
        }];
    } else {
        [self.camera iotSetDoorBellMessageLimitTime:selectedValue success:^{
            [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
        }];
    }
    
    [self hideBottomView];
}

- (void)showBottomView {
    NSInteger row = 0;
    if (self.isSelectingWaitDuration) {
        row  = self.camera.param.voiceBell.callWaitTime / 10 - 2;
    } else {
        row = self.camera.param.voiceBell.msgLimitTime / 10 - 2;
    }
    if (row < 0) {
        row = 0;
    }
    if (row > 5) {
        row = 5;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomSelectView.frame = CGRectMake(0, WY_ScreenHeight - WY_TopBar_H - 200, WY_ScreenWidth, 200);
        [self.pickerView selectRow:row inComponent:0 animated:YES];
    }];
}
- (void)hideBottomView {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomSelectView.frame = CGRectMake(0, WY_ScreenHeight, WY_ScreenWidth, 200);
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = WY_FontColor_Black;
        cell.detailTextLabel.textColor = WY_FontColor_Gray;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = WYLocalString(@"des_msg_wait_time");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0lds", (long)self.camera.param.voiceBell.callWaitTime];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = WYLocalString(@"des_msg_max_time");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0lds", (long)self.camera.param.voiceBell.msgLimitTime];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isSelectingWaitDuration = NO;
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.isSelectingWaitDuration = YES;
    }
    [self showBottomView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideBottomView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return WYLocalString(@"des_msg_wait_time_title");
    }
    return WYLocalString(@"des_msg_max_time_title");
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 5;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%lds",(row + 2) * 10];
}

@end
