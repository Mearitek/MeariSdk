//
//  WYBabyMonitorMusicVC.m
//  Meari
//
//  Created by 李兵 on 2017/3/13.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBabyMonitorMusicVC.h"
#import "WYBabyMonitorMusicModel.h"
#import "WYBabyMonitorMusicCell.h"
#import "WYBabyMonitorMusicToolBar.h"

@interface WYBabyMonitorMusicVC ()<UITableViewDelegate, UITableViewDataSource, WYBabyMonitorMusicToolBarDelegate>
@property (nonatomic, strong)WYBabyMonitorMusicToolBar *musicBar;
@end

@implementation WYBabyMonitorMusicVC

#pragma mark - Private
#pragma mark -- Getter
- (WYBabyMonitorMusicToolBar *)musicBar {
    if (!_musicBar) {
        _musicBar = [WYBabyMonitorMusicToolBar new];
    }
    return _musicBar;
}

#pragma mark -- Init
- (void)initSet {
    self.view.backgroundColor = [UIColor whiteColor];
    self.showNavigationLine = YES;
    self.navigationItem.title = WYLocalString(@"MOVE MUSIC");
    
    WY_WeakSelf
    self.setTableView = ^(UITableView *tableView) {
        tableView.rowHeight = 70;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView wy_registerClass:[WYBabyMonitorMusicCell class] fromNib:NO];
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf networkRequestList];
        }];
    };
}
- (void)initLayout {
    [self.view addSubview:self.musicBar];
    
    WY_WeakSelf
    [self.musicBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@170);
        make.top.leading.trailing.equalTo(weakSelf.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.musicBar.mas_bottom);
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- Utilities
- (void)dealNetworkDataList:(NSArray *)data {
    [self.dataSource removeAllObjects];
    for (MeariMusicInfo *info in data) {
        WYBabyMonitorMusicModel *model = [WYBabyMonitorMusicModel new];
        model.info = info;
        [self.dataSource addObject:model];
    }
    WYBabyMonitorMusicModel *model = self.dataSource.firstObject;
    [self.musicBar setFirstMusicName:model.info.musicName musicID:model.info.musicID];
    [self.tableView reloadData];
}

#pragma mark -- Network
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getMusicList:^(NSArray<MeariMusicInfo *> *musicList) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:musicList];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}


#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.musicBar.playing = NO;
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeCameraVideoOne: {
            if (WY_IsKindOfClass(obj, NSDictionary)) {
                NSDictionary *dic = (NSDictionary *)obj;
                self.musicBar.delegate = dic[@"delegate"];
                self.musicBar.volume = [dic[@"volume"] floatValue];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:WY_ClassName([WYBabyMonitorMusicCell class]) forIndexPath:indexPath];
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ((WYBabyMonitorMusicCell *)cell).model = self.dataSource[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYBabyMonitorMusicModel *model = self.dataSource[indexPath.row];
    if (model.status == WYBabyMonitorMusicStatusPaused) {
        if ([self.musicBar.delegate respondsToSelector:@selector(WYBabyMonitorMusicToolBar_Play:musicID:)]) {
            [self.musicBar.delegate WYBabyMonitorMusicToolBar_Play:self.musicBar musicID:model.info.musicID];
        }
    }else {
        if ([self.musicBar.delegate respondsToSelector:@selector(WYBabyMonitorMusicToolBar_Pause:musicID:)]) {
            [self.musicBar.delegate WYBabyMonitorMusicToolBar_Pause:self.musicBar musicID:model.info.musicID];
        }
    }
}

#pragma mark -- Public
- (void)setModel:(WYBabymonitorMusicStateModel *)model {
    _model = model;
    if(self.dataSource.count <= 0) return;
    WYBabyMonitorMusicOneModel *currentModel = model.currentModel;
    for (WYBabyMonitorMusicModel *m in self.dataSource) {
        if ([m.info.musicID isEqualToString:currentModel.musicID]) {
            m.status = currentModel.status;
            m.download_percent = currentModel.download_percent;
            currentModel.musicName = m.info.musicName;
        }else {
            m.status = WYBabyMonitorMusicStatusPaused;
            m.download_percent = 0;
        }
    }
    [self.tableView reloadData];
    self.musicBar.model = model;
}
- (void)setVolume:(CGFloat)volume {
    self.musicBar.volume = volume;
}
- (CGFloat)volume {
    return self.musicBar.volume;
}
- (void)setPlayMode:(WYBabymonitorMusicPlayMode)playMode {
    self.musicBar.playMode = playMode;
}
- (WYBabymonitorMusicPlayMode)playMode {
    return self.musicBar.playMode;
}

- (void)pauseMusic:(NSString *)musicID {
    if (!self.model) {
        return;
    }
    if ([self.model.current_musicID isEqualToString:musicID]) {
        self.model.is_playing = NO;
    }
    for (WYBabyMonitorMusicOneModel *m in self.model.play_list) {
        if ([m.musicID isEqualToString:musicID]) {
            m.is_playing = NO;
        }else {
            m.is_playing = NO;
        }
    }
    self.model = self.model;
}
- (void)playMusic:(NSString *)musicID {
    if (!self.model) {
        return;
    }
    for (WYBabyMonitorMusicOneModel *m in self.model.play_list) {
        if ([m.musicID isEqualToString:musicID]) {
            m.is_playing = YES;
            self.model.current_musicID = musicID;
            self.model.is_playing = YES;
        }else {
            m.is_playing = NO;
        }
    }
    self.model = self.model;
}
- (void)resumeMusic:(NSString *)musicID {
    if (!self.model) {
        return;
    }
    if ([self.model.current_musicID isEqualToString:musicID]) {
        self.model.is_playing = YES;
    }
    for (WYBabyMonitorMusicOneModel *m in self.model.play_list) {
        if ([m.musicID isEqualToString:musicID]) {
            m.is_playing = YES;
        }else {
            m.is_playing = NO;
        }
    }
    self.model = self.model;
}
- (void)playNext {
    if (!self.model) {
        return;
    }
    WYBabyMonitorMusicOneModel *model = self.model.nextModel;
    if (!model) {
        return;
    }
    self.model.current_musicID = model.musicID;
    self.model.is_playing = YES;
    for (WYBabyMonitorMusicOneModel *m in self.model.play_list) {
        if ([m.musicID isEqualToString:model.musicID]) {
            m.is_playing = YES;
        }else {
            m.is_playing = NO;
        }
    }
    self.model = self.model;
}
- (void)playPrevious {
    if (!self.model) {
        return;
    }
    WYBabyMonitorMusicOneModel *model = self.model.prevModel;
    if (!model) {
        return;
    }
    self.model.current_musicID = model.musicID;
    self.model.is_playing = YES;
    for (WYBabyMonitorMusicOneModel *m in self.model.play_list) {
        if ([m.musicID isEqualToString:model.musicID]) {
            m.is_playing = YES;
        }else {
            m.is_playing = NO;
        }
    }
    self.model = self.model;
}
@end
