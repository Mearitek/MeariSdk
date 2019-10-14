//
//  WYDoorBellSettingBellVolumeVC.m
//  Meari
//
//  Created by FMG on 2017/7/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingBellVolumeVC.h"

@interface WYDoorBellSettingBellVolumeVC ()
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) MeariDeviceParamBell *doorBell;
@property (nonatomic, strong) MeariDevice *camera;
@end

@implementation WYDoorBellSettingBellVolumeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
}
- (void)initSubview {
    self.title = WYLocalString(@"TALKBACK VOLUME");
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - volumeSliderAction
- (void)vlolumeValueChange:(UISlider *)slider {
    self.volumeLabel.text = @(roundf(slider.value)).stringValue;
}
- (void)volumeSliderFinished:(UISlider *)slider {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [self.camera setDoorBellVolume:roundf(slider.value) success:^{
        [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
    } failure:^(NSError *error) {
        slider.value = weakSelf.doorBell.volume;
        weakSelf.volumeLabel.text = @(slider.value).stringValue;
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        [cell addLineViewAtTop];
        [cell addLineViewAtBottom];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, WY_ScreenWidth - 40, 40)];
    title.textColor = WY_FontColor_Gray;
    title.text = WYLocalString(@"Volume Control");
    [view  addSubview:title];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    UILabel *title = [UILabel new];
    title.textColor = WY_FontColor_Gray;
    title.numberOfLines = 0;
    title.font = WYFontNormal(15);
    [title ajustedHeightWithWidth:WY_ScreenWidth - 40];
    title.text = WYLocalString(@"des_doorBellVolume");
    [view  addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(view).offset(20);
        make.top.equalTo(view).offset(10);
        make.trailing.equalTo(view).offset(-18);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"img_doorbell_volume"];
    [cell addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@25);
        make.centerY.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [cell addSubview:self.volumeLabel];
    [self.volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV);
        make.trailing.equalTo(cell);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [cell addSubview:self.volumeSlider];
    [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(imageV.mas_trailing).offset(8);
        make.centerY.equalTo(imageV);
        make.trailing.equalTo(self.volumeLabel.mas_leading).offset(-15);
    }];
    
}

#pragma mark - lazyLoad
- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        _volumeSlider  = [[UISlider alloc] init];
        _volumeSlider.minimumValue = 0;
        _volumeSlider.maximumValue = 100;
        _volumeSlider.value = self.doorBell.volume;
        [_volumeSlider setTintColor:WY_MainColor];
        [_volumeSlider addTarget:self action:@selector(vlolumeValueChange:) forControlEvents:UIControlEventValueChanged];
        [_volumeSlider addTarget:self action:@selector(volumeSliderFinished:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _volumeSlider;
}
- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.textColor = WY_MainColor;
        _volumeLabel.text = @(self.doorBell.volume).stringValue;
    }
    return _volumeLabel;
}

@end
