//
//  WYDoorBellSettingJingleBellVC.m
//  Meari
//
//  Created by FMG on 2017/7/18.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYDoorBellSettingJingleBellVC.h"
#import "WYDoorBellSettingJingleBellView.h"

static const NSInteger FooterHeight = 220;


static const NSInteger CellHeight = 60;

@interface WYDoorBellSettingJingleBellVC ()<UITableViewDelegate,UITableViewDataSource>
{
    MeariDeviceLevel _jingleBellVolumeLevel;
    NSInteger _repeatTimes;
}
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) WYDoorBellSettingJingleBellView *bellVolumeView;
@property (nonatomic, strong) WYDoorBellSettingJingleBellView *bellRepeatTimesView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger desHeight;
@property (nonatomic, assign) MeariDeviceParamBellSound *jingleBell;
@property (nonatomic,   copy) NSString *selectedSong;

@property (nonatomic, strong)MeariDevice *camera;


@end

@implementation WYDoorBellSettingJingleBellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInit];
    [self setLayout];
}
- (void)setInit {
    self.title = WYLocalString(@"JINGLE BELL SETTING");
    self.desHeight = [self.descriptionLabel labelHeighWithWidth:WY_ScreenWidth-45] + 30;
    self.dataSource = self.jingleBell.song;
    self.selectedSong = self.jingleBell.selected;
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem saveTextItemWithTarget:self action:@selector(saveBtnAction)];
}
- (void)setLayout {
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.height.equalTo(@(WY_ScreenHeight - self.desHeight - FooterHeight/2.0 - WY_TopBar_H));
        make.height.equalTo(@(WY_ScreenHeight));
    }];
    
    [self.bellVolumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTableView.mas_bottom);
        make.left.width.equalTo(self.view);
        make.height.equalTo(@110);
    }];
    /*
     [self.bellRepeatTimesView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.bellVolumeView.mas_bottom);
     make.left.width.equalTo(self.bellVolumeView);
     make.height.equalTo(@110);
     }];*/
    UIView *line = [UIView new];
    line.backgroundColor = WY_LineColor_LightGray;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.bellVolumeView.mas_bottom);
        make.height.equalTo(@1);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.leading.equalTo(@25);
        make.trailing.equalTo(self.view).offset(-18);
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)saveBtnAction {
    WY_HUD_SHOW_WAITING
    _repeatTimes = 1;
    [self.camera setDoorBellJingleBellVolumeType:_jingleBellVolumeLevel selectedSong:self.selectedSong repeatTimes:_repeatTimes success:^(id obj) {
        [SVProgressHUD wy_showToast:WYLocalString(@"success_set")];
    } failure:^(NSError *error) {
        [SVProgressHUD wy_showToast:WYLocalString(@"fail_set")];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        [cell addLineViewAtBottom];
    }
    if (!indexPath.row) {
        cell.textLabel.text = WYLocalString(@"Jingle Bell Pairing");
        cell.imageView.image = [UIImage imageNamed:@"img_doorbell_jingleBellAdd"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = self.dataSource[indexPath.row -1];
        cell.accessoryView  = [self.selectedSong isEqualToString:cell.textLabel.text] ? self.checkBtn : nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.row) {
         [self wy_pushToVC:WYVCTypeJingleBellPairing sender:self.camera];
    } else {
        self.selectedSong = self.dataSource[indexPath.row - 1];
        [self.myTableView reloadData];
        [self saveBtnAction];
    }
}


#pragma mark - transition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if(WY_IsKindOfClass(obj, MeariDevice)) {
        self.camera = obj;
        self.jingleBell = self.camera.param.bell.charm;
    }
}


#pragma mark - lazyLoad

- (WYDoorBellSettingJingleBellView *)bellVolumeView {
    if (!_bellVolumeView) {
        NSArray *arr = @[WYLocalString(@"motion_low"),WYLocalString(@"motion_medium"),WYLocalString(@"motion_high")];
         NSInteger selectedStall = self.jingleBell.level;
        WYDoorBellSettingJingleBellView *view = [[WYDoorBellSettingJingleBellView alloc] initWithFrame:CGRectZero sliderStallNum:3 stallDestription:arr selectedStall:selectedStall];
        _bellVolumeView = view;
        _jingleBellVolumeLevel =  (MeariDeviceLevel)selectedStall;
        view.bellVlaue = ^(NSInteger value) {
            if (!_jingleBellVolumeLevel) {
                _jingleBellVolumeLevel = (MeariDeviceLevel)value;
                return;
            }
            _jingleBellVolumeLevel = (MeariDeviceLevel)value;
            [self saveBtnAction];
        };
        [view setSliderColor:WY_MainColor stallColor:WY_MainColor];
        view.bellTitle = WYLocalString(@"Jingle Bell Volume");
        [self.view addSubview:view];
    }
    return _bellVolumeView;
}
- (WYDoorBellSettingJingleBellView *)bellRepeatTimesView {
    if (!_bellRepeatTimesView) {
        NSArray *arr = @[[@"1"stringByAppendingString:WYLocalString(@"Time")],
                         [@"2"stringByAppendingString:WYLocalString(@"Times")],
                         [@"3"stringByAppendingString:WYLocalString(@"Times")],
                         [@"4"stringByAppendingString:WYLocalString(@"Times")],
                         [@"5"stringByAppendingString:WYLocalString(@"Times")]
                         ];
        WYDoorBellSettingJingleBellView *view = [[WYDoorBellSettingJingleBellView alloc] initWithFrame:CGRectZero sliderStallNum:5 stallDestription:arr selectedStall:self.jingleBell.repetition];
        view.bellVlaue = ^(NSInteger value) {
            _repeatTimes = value;
        };
        _bellRepeatTimesView = view;
        view.bellTitle = WYLocalString(@"Repeat Times");
        [self.view addSubview:view];
    }
    return _bellRepeatTimesView;
}
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = ({
            UITableView *tab = [UITableView new];
            tab.separatorStyle = UITableViewCellSeparatorStyleNone;
            tab.delegate = self;
            tab.dataSource = self;
            [self.view addSubview:tab];
            tab;
        });
    }
    return _myTableView;
}
- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        UILabel *label = [UILabel wy_new];
        label.text = WYLocalString(@"des_jingleBellSetting");
        label.textColor = WY_FontColor_Gray;
        _descriptionLabel = label;
        [self.view addSubview:label];
    }
    return _descriptionLabel;
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
