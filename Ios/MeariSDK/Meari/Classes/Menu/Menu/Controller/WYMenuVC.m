//
//  LeftViewController.m
//  HYSlideWebDemo
//
//  Created by Strong on 15/8/14.
//  Copyright (c) 2015年 PPStrong. All rights reserved.
//

#import "WYMenuVC.h"

#import "WYMenuCell.h"
#import "WYMenuHeaderView.h"
#import "WYAppDelegate.h"


#define WYHeight_header 100

@interface WYMenuVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong) WYMenuHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *bgImageView;


@end

@implementation WYMenuVC
#pragma mark - Private
#pragma mark -- Getter
- (WYMenuHeaderView *)headerView {
    if (!_headerView) {
        WYMenuHeaderView *headerV = [WYMenuHeaderView headerView];
        headerV.bounds = CGRectMake(0, 0, WY_ScreenWidth, WYHeight_header);
        [headerV addTarget:self action:@selector(headerAction:)];
        if (WY_USER_IMAGE && [WY_USER_IMAGE isKindOfClass:[NSString class]]) {
            [headerV.headerImageView wy_setImageWithURL:[NSURL URLWithString:WY_USER_IMAGE] placeholderImage:[UIImage placeholder_person_image]];
        }else {
            headerV.headerImageView.image = [UIImage placeholder_person_image];
        }
        headerV.nickNameLabel.text = WY_USER_NICK;
        _headerView = headerV;
    }
    return _headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView wy_tableViewWithDelegate:self cellClass:[WYMenuCell class] fromNib:YES];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
    }
    if (!_tableView.superview) {
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu"]];
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}

#pragma mark -- Init
- (void)initLayout {
    WY_WeakSelf
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(weakSelf.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view);
        make.width.equalTo(@(WY_SideViewController_Width));
        make.top.equalTo(weakSelf.view).offset(WY_iPhone_X ? WY_SAFE_TOP : 20);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- Life
- (instancetype)init {
    self = [super init];
    if (self) {
        _dataSource = @[[WYMenuModel deviceMenu],
                        [WYMenuModel msgMenu],
                        [WYMenuModel friendMenu],
                        ].mutableCopy;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (WY_USER_IMAGE && [WY_USER_IMAGE isKindOfClass:[NSString class]]) {
        [self.headerView.headerImageView wy_setImageWithURL:[NSURL URLWithString:WY_USER_IMAGE] placeholderImage:[UIImage placeholder_person_image]];
    }else {
        self.headerView.headerImageView.image = [UIImage placeholder_person_image];
    }
    self.headerView.nickNameLabel.text = WY_USER_NICK;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.menuType = self.menuType;
}

#pragma mark -- Action
- (void)headerAction:(UITapGestureRecognizer *)sender {
    [WY_Appdelegate wy_loadMineVC];
}

#pragma mark -- Utilities
- (WYMenuType)menuTypeWithIndex:(NSInteger)index {
    return [_dataSource[index] menuType];
}
- (NSInteger)indexWithMenuType:(WYMenuType)menuType {
    __block NSInteger index = 0;
    [_dataSource enumerateObjectsUsingBlock:^(WYMenuModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (menuType == obj.menuType) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

#pragma mark - Delegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYMenuCell) forIndexPath:indexPath];
    WYMenuModel *model = _dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMenuType type = [self menuTypeWithIndex:indexPath.row];
    if (_menuType == type) {
        [(SlideViewController *)self.parentViewController hideSideViewController:YES];
        return;
    }
    self.menuType = type;
    switch (self.menuType) {
        case WYMenuTypeCamera: [WY_Appdelegate wy_loadCameraVC]; break;
        case WYMenuTypeMsg: [WY_Appdelegate wy_loadMsgVC]; break;
        case WYMenuTypeFriend: [WY_Appdelegate wy_loadFriendVC]; break;
        default: break;
    }
    [WY_SlideVC hideSideViewController:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (WY_ScreenHeight-40-11.5-WYHeight_header)/7;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return WYHeight_header;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

#pragma mark - Public
- (void)setMenuType:(WYMenuType)menuType {
    _menuType = menuType;
    for (WYMenuModel *model in _dataSource) {
        model.highlighted = NO;
    }
    WYMenuModel *model = _dataSource[[self indexWithMenuType:_menuType]];
    model.highlighted = YES;
    [self.tableView reloadData];
}

- (void)testFeedback {
    [[MeariUser sharedInstance] feedbackWithContent:@"sdk测试" mark:@"123" contactInfo:nil lightStatus:nil sn:nil type:nil imageDataArray:nil snImageData:nil success:^{
        NSLog(@"反馈成功");
    } failure:^(NSError *error) {
        NSLog(@"反馈失败");
    }];
}

- (void)testOpenSound {
    [[MeariUser sharedInstance] notificationSoundSwitch:YES success:^{
        NSLog(@"设置成功");
    } failure:^(NSError *error) {
        NSLog(@"设置失败");
    }];
}

@end
