//
//  WYMsgSystemVC.m
//  Meari
//
//  Created by Strong on 15/12/24.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "WYMsgSystemVC.h"
#import "WYMsgSystemCell.h"
#import "WYMsgSystemModel.h"

@interface WYMsgSystemVC ()<WYMsgSystemCellDelegate,UIAlertViewDelegate>
{
    BOOL _edited;
}
@property (nonatomic, strong)NSMutableArray *selectedSource;
@property (nonatomic, strong)WYSelectAllView *selectAllView;

@end

@implementation WYMsgSystemVC
#pragma mark - Private
#pragma mark -- Getter
- (NSMutableArray *)selectedSource {
    if (!_selectedSource) {
        _selectedSource = [NSMutableArray array];
    }
    return _selectedSource;
}
- (WYSelectAllView *)selectAllView {
    if (!_selectAllView) {
        WY_WeakSelf
        _selectAllView = [WYSelectAllView selectAllViewWithSelectTask:^(BOOL selected) {
            for (WYMsgSystemModel *model in weakSelf.dataSource) {
                model.selected = selected;
            }
            [weakSelf.tableView reloadData];
            selected ? weakSelf.selectedSource = weakSelf.dataSource.mutableCopy : [weakSelf.selectedSource removeAllObjects];
        }];
    }
    return _selectAllView;
}

#pragma mark -- Init
- (void)initSet {
    WY_WeakSelf
    self.setTableView = ^(UITableView *tableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView wy_registerClass:[WYMsgSystemCell class] fromNib:YES];
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf networkRequestList];
        }];
    };
}
- (void)initLayout {
    WY_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- Life
- (void)updateViewConstraints {
    [super updateViewConstraints];
    WY_WeakSelf
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset(_edited ? -60+WY_SAFE_BOTTOM_LAYOUT : WY_SAFE_BOTTOM_LAYOUT);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}

#pragma mark -- Network
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getSystemMessageList:^(NSArray<MeariMessageInfoSystem *> *msgs) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:msgs];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestDelete {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.selectedSource.count];
    for (WYMsgSystemModel *model in self.selectedSource) {
        [arr addObject:@(model.info.msgID)];
    }
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    [[MeariUser sharedInstance] deleteSystemMessages:arr success:^{
        WY_HUD_DISMISS
        [weakSelf dealNetworkDataDelete];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestDealMsgType:(MeariSystemMessageType)type agree:(BOOL)agreed{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    WYMsgSystemModel *model = self.dataSource[indexPath.row];
    WY_WeakSelf
    WYBlock_Void suc = ^{
        WY_HUD_DISMISS
        if (indexPath) {
            [weakSelf.dataSource removeObject:model];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
    };
    WYBlock_Error fail = ^(NSError *error){
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    };
    if (type == MeariSystemMessageTypeFriendAdd) {
        WY_HUD_SHOW_WAITING
        if (agreed) {
            [[MeariUser sharedInstance] agreeAddFriend:model.info.friendID msgID:model.info.msgID success:suc failure:fail];
            
        }else {
            [[MeariUser sharedInstance] refuseAddFriend:model.info.friendID msgID:model.info.msgID success:suc failure:fail];
        }
    }else if(type == MeariSystemMessageTypeDeviceShare){
        WY_HUD_SHOW_WAITING
        if (agreed) {
            [[MeariUser sharedInstance] agreeShareDevice:model.info.deviceID toFriend:model.info.friendID msgID:model.info.msgID success:suc failure:fail];
        }else {
            [[MeariUser sharedInstance] refuseShareDevice:model.info.deviceID toFriend:model.info.friendID msgID:model.info.msgID success:suc failure:fail];
        }
    }
}

#pragma mark -- Notification
#pragma mark -- NSTimer
#pragma mark -- Utilities
- (void)updateTableView {
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)dealNetworkDataList:(NSArray *)data {
    [self.dataSource removeAllObjects];
    for (MeariMessageInfoSystem *info in data) {
        WYMsgSystemModel *model = [WYMsgSystemModel new];
        model.info = info;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}
- (void)dealNetworkDataDelete {
    [self.dataSource removeObjectsInArray:self.selectedSource];
    [self.selectedSource removeAllObjects];
    [self.tableView reloadData];
    if (self.dataSource.count == 0) {
        if ([self.parentViewController canPerformAction:NSSelectorFromString(@"editCancel") withSender:nil]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.parentViewController performSelector:NSSelectorFromString(@"editCancel") withObject:nil];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark -- Action
#pragma mark - Delegate
#pragma mark -- WYEditManagerDelegate
- (BOOL)canEdit {
    return self.dataSource.count > 0;
}
- (void)editEdit {
    _edited = YES;
    self.selectAllView.selected = NO;
    self.tableView.mj_header.hidden = YES;
    [self.tableView reloadData];
    [self updateTableView];
}
- (void)editCancel {
    _edited = NO;
    WY_EditM.edited = NO;
    self.selectAllView.selected = NO;
    self.tableView.mj_header.hidden = NO;
    for (WYMsgSystemModel *model in self.dataSource) {
        model.selected = NO;
    }
    [self.selectedSource removeAllObjects];
    [self.tableView reloadData];
    [self updateTableView];
}
- (void)editDelete {
    if (self.selectedSource.count == 0) {
        [SVProgressHUD wy_showToast:WYLocalString(@"error_noChoice")];
    }else {
        WY_WeakSelf
        [WYAlertView showMsg_DeleteWithOtherAction:^{
            [weakSelf networkRequestDelete];
        }];
    }
    
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMsgSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYMsgSystemCell) forIndexPath:indexPath];
    WYMsgSystemModel *model = self.dataSource[indexPath.row];
    cell.delegate = self;
    [cell passModel:model edited:_edited];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_edited) return;
    
    WYMsgSystemModel *model = self.dataSource[indexPath.row];
    if (model.info.msgType == MeariSystemMessageTypeFriendAdd || model.info.msgType == MeariSystemMessageTypeDeviceShare) {
        NSString *des = [NSString stringWithFormat:@"%@ %@", model.accountWhole, model.descWhole];
        WY_WeakSelf
        [WYAlertView showMsg_AgreeRefuseWithDescription:des cancelAction:^{
            [weakSelf networkRequestDealMsgType:model.info.msgType agree:NO];
        } otherAction:^{
            [weakSelf networkRequestDealMsgType:model.info.msgType agree:YES];
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_edited && self.dataSource.count > 0) {
        return 50;
    }
    return WY_1_PIXEL;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    UIView *line = [UIView new];
    line.backgroundColor = WY_LineColor_LightGray;
    [v addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(WY_1_PIXEL));
        make.leading.top.and.trailing.equalTo(v);
    }];
    if (_edited && self.dataSource.count > 0) {
        line.hidden = YES;
        [v addSubview:self.selectAllView];
        [self.selectAllView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.leading.bottom.and.trailing.equalTo(v);
        }];
    }
    return v;
}
#pragma mark -- WYMsgSystemCellDelegate
- (void)WYMsgSystemCell:(WYMsgSystemCell *)cell selectButton:(UIButton *)button {
    button.selected = !button.isSelected;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYMsgSystemModel *model = self.dataSource[indexPath.row];
    model.selected = button.isSelected;
    if (button.isSelected) {
        [self.selectedSource addObject:model];
    }else {
        [self.selectedSource removeObject:model];
    }
    self.selectAllView.selected = self.selectedSource.count == self.dataSource.count;
}

#pragma mark - Public
- (void)networkRequestFromPush {
    
}


@end
