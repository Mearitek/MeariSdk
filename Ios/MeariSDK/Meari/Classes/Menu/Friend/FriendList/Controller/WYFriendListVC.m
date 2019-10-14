//
//  WYFriendListVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendListVC.h"
#import "WYFriendListModel.h"
#import "WYFriendListCell.h"
#import "WYFriendListSearchView.h"

@interface WYFriendListVC ()<WYEditManagerDelegate>
{
    BOOL _edited;
    BOOL _notInMenu;
}
@property (nonatomic, strong)WYFriendListSearchView *searchView;
@property (nonatomic, strong)NSMutableArray *selectedSource;
@end

@implementation WYFriendListVC
#pragma mark -- Getter
WYGetter_MutableArray(selectedSource)
- (WYFriendListSearchView *)searchView {
    if (!_searchView) {
        _searchView = [WYFriendListSearchView new];
        [_searchView addTarget:self action:@selector(addAction:)];
        [self.view addSubview:_searchView];
    }
    return _searchView;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self initNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WY_EditM setDelegate:self editStystle:WYEditStytleDeleteDelete];
    WY_EditM.edited = _edited;
    if (_notInMenu) {
        WY_SlideVC.needSwipeShowMenu = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- Init
- (void)initSet {
    self.navigationItem.title = WYLocalString(@"friend_title");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem deleteImageItemWithTarget:self action:@selector(deleteAction:)];
    if (_notInMenu) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem backImageItemWithTarget:self action:@selector(backAction:)];
    }
    
    WY_WeakSelf
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView wy_registerClass:[WYFriendListCell class] fromNib:YES];
    self.tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf networkRequestList];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)initLayout {
    WY_WeakSelf
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf.view);
        make.height.equalTo(@60);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchView.mas_bottom);
        make.leading.trailing.bottom.equalTo(weakSelf.view);
    }];
}
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(n_keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark -- Notification
- (void)n_keyboardShow:(NSNotification *)sender {
    [self.tableView addTapGestureTarget:self action:@selector(tapAction:)];
}

#pragma mark -- Network
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getFriendList:^(NSArray<MeariFriendInfo *> *friends) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkRequestListData:friends];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestAdd{
    [[MeariUser sharedInstance] addFriend:self.searchView.text success:^{
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"friend_add_suc"))
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
//    case WYCodeTypeDataNotExist: WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"friend_add_fail_notExist")) break;
//    case WYCodeTypeIsFriends: WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"friend_add_fail_isFriend")) break;
//    case WYCodeTypeWaitForDealing: WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"friend_add_fail_wait")) break;
//    case WYCodeTypeAccountNotExist: WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"friend_add_fail_notExist")) break;
//    case WYCodeTypeCanNotAddSelf: WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"friend_add_fail_self")) break;
//    case WYCodeTypeFriendAlreadyAddYou: WY_HUD_SHOW_STATUS(WYLocalString(@"friend_add_fail_addyou")) break;
//    default: WY_HUD_SHOW_ServerError break;
    }];
}
- (void)networkRequestDelete{
    NSMutableArray *userIDs = [NSMutableArray arrayWithCapacity:self.selectedSource.count];
    for (WYFriendListModel *model in self.selectedSource) {
        [userIDs addObject:@(model.info.userID)];
    }
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] deleteFriends:userIDs success:^{
        WY_HUD_DISMISS
        [weakSelf.dataSource removeObjectsInArray:weakSelf.selectedSource];
        [weakSelf.selectedSource removeAllObjects];
        if (weakSelf.dataSource.count == 0) {
            [weakSelf editCancel];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

#pragma mark -- Utilities
- (void)dealNetworkRequestListData:(NSArray *)data {
    [self.dataSource removeAllObjects];
    for (MeariFriendInfo *info in data) {
        WYFriendListModel *model  = [WYFriendListModel new];
        model.info = info;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark -- Action
- (void)deleteAction:(UIButton *)sender {
    
}
- (void)addAction:(UIButton *)sender {
    if (self.searchView.text.length <= 0) {
        [self.view endEditing:YES];
        return;
    }
    if (![self.searchView.text wy_validateAccount]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"friend_add_fail_invalid"))
        });
        return;
    }
    [self networkRequestAdd];
}
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self.tableView removeGestureRecognizer:sender];
}
- (void)backAction:(UIButton *)sender {
    [self wy_pop];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeFriendShare: {
            [self.tableView reloadData];
            break;
        }
        case WYVCTypeCameraSettingShare: {
            _notInMenu = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark -- WYEditManagerDelegate
- (BOOL)canEdit {
    return self.dataSource.count > 0;
}
- (void)editEdit {
    _edited = YES;
    self.searchView.enabled = NO;
    [self.tableView reloadData];
}
- (void)editCancel {
    WY_EditM.edited = NO;
    _edited = NO;
    self.searchView.enabled = YES;
    [self.selectedSource removeAllObjects];
    for (WYFriendListModel *m in self.dataSource) {
        m.selected = NO;
    }
    [self.tableView reloadData];
}
- (void)editDelete {
    if (self.selectedSource.count == 0) {
        [SVProgressHUD wy_showToast:WYLocalString(@"friend_del_none")];
        return;
    }
    WY_WeakSelf
    [WYAlertView showDeleteFriend:^{
        [weakSelf networkRequestDelete];
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYFriendListCell) forIndexPath:indexPath];
    WYFriendListModel *model = self.dataSource[indexPath.row];
    [cell passModel:model edited:_edited];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_edited) {
        WYFriendListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        WYFriendListModel *model = self.dataSource[indexPath.row];
        model.selected = !model.selected;
        [cell passModel:model edited:_edited];
        if (model.selected) {
            if (![self.selectedSource containsObject:model]) {
                [self.selectedSource addObject:model];
            }
        }else {
            if ([self.selectedSource containsObject:model]) {
                [self.selectedSource removeObject:model];
            }
        }
        return;
    }
    WYFriendListModel *m = self.dataSource[indexPath.row];
    [self wy_pushToVC:WYVCTypeFriendShare sender:m];
}


@end
