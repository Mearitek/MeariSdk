//
//  WYMsgAlarmVC.m
//  Meari
//
//  Created by 李兵 on 15/12/28.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import "WYMsgAlarmVC.h"
#import "WYMsgAlarmCell.h"
#import "WYMsgAlarmModel.h"


@interface WYMsgAlarmVC ()<WYMsgAlarmCellDelegate>
{
    BOOL _edited;
}
@property (nonatomic, strong)NSMutableArray *selectedSource;
@property (nonatomic, strong)WYSelectAllView *selectAllView;


@end

@implementation WYMsgAlarmVC
#pragma mark - getter
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
            for (WYMsgAlarmModel *model in weakSelf.dataSource) {
                model.selected = selected;
            }
            [weakSelf.tableView reloadData];
            selected ? weakSelf.selectedSource = weakSelf.dataSource.mutableCopy : [weakSelf.selectedSource removeAllObjects];
        }];
    }
    return _selectAllView;
}

#pragma mark - life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s [%04d]", __func__, __LINE__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s [%04d]", __func__, __LINE__);
    [self initSet];
    [self initLayout];
}

#pragma mark - init
- (void)initSet {
    WY_WeakSelf
    self.setTableView = ^(UITableView *tableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView wy_registerClass:[WYMsgAlarmCell class] fromNib:YES];
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf networkRequestList];
        }];
    };
}
- (void)initLayout {
    WY_WeakSelf
    [weakSelf.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark - 网络请求
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getAlarmMessageList:^(NSArray<MeariMessageInfoAlarm *> *msgs) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:msgs];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealNetworkDataList:(NSArray *)data {
    [self.dataSource removeAllObjects];
    for (MeariMessageInfoAlarm *info in data) {
        WYMsgAlarmModel *model = [WYMsgAlarmModel new];
        model.info = info;
        
        if (model.info.hasMsg) {
            [self.dataSource addObject:model];
        }else {
            if ([WY_CoreDataM getAllAlarmMessagesOfDevice:@(model.info.deviceID)].count > 0) {
                if ([WY_CoreDataM hasUnreadMessageOfDevice:@(model.info.deviceID)]) {
                    model.info.hasMsg = YES;
                }
                [self.dataSource addObject:model];
            }
        }
    }
    int i = 0;
    for (WYMsgAlarmModel *model in self.dataSource) {
        if (!model.info.hasMsg) {
            i++;
        }
    }
    [self.tableView reloadData];
}
- (void)networkRequestDelete {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.selectedSource.count];
    for (WYMsgAlarmModel *model in self.selectedSource) {
        [arr addObject:@(model.info.deviceID)];
    }
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] deleteAlarmMessages:arr success:^{
        WY_HUD_DISMISS
        [weakSelf dealNetworkDataDelete];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealNetworkDataDelete {
    for (WYMsgAlarmModel *model in self.selectedSource) {
        [WY_CoreDataM deletegetAllAlarmMessagesOfDevice:@(model.info.deviceID)];
    }
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


#pragma mark - WYEditManagerDelegate
- (BOOL)canEdit {
    return self.dataSource.count > 0;
}
- (void)editEdit {
    _edited = YES;
    self.selectAllView.selected = NO;
    self.tableView.mj_header.hidden = YES;
    [self.tableView reloadData];
}
- (void)editCancel {
    _edited = NO;
    if (WY_EditM.edited) {
        WY_EditM.edited = NO;
    }
    self.tableView.mj_header.hidden = NO;
    self.selectAllView.selected = NO;
    for (WYMsgAlarmModel *model in self.dataSource) {
        model.selected = NO;
    }
    [self.selectedSource removeAllObjects];
    [self.tableView reloadData];
}
- (void)editDelete {
    WY_WeakSelf
    if (self.selectedSource.count == 0) {
        [SVProgressHUD wy_showToast:WYLocalString(@"error_noChoice")];
    }else {
        [WYAlertView showWithTitle:WYLocalString(@"Delete")
                           message:WYLocalString(@"DeleteAllMessages")
                      cancelButton:WYLocal_Cancel
                       otherButton:WYLocalString(@"Delete")
                       alertAction:^(WYAlertView *alertView, NSInteger buttonIndex) {
                           if (buttonIndex == alertView.cancelButtonIndex) {
                               
                           }else {
                               [weakSelf networkRequestDelete];
                           }
                       }];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMsgAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYMsgAlarmCell) forIndexPath:indexPath];
    cell.delegate = self;
    WYMsgAlarmModel *model  = self.dataSource[indexPath.row];
    [cell passModel:model edited:_edited];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_edited) return;
    
    WYMsgAlarmModel *model = self.dataSource[indexPath.row];
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(model.info.deviceName, model.info.deviceID);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _edited ? [WYMsgAlarmCell editedCellHeight] : [WYMsgAlarmCell cellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_edited && self.dataSource.count > 0) {
        return 50;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_edited && self.dataSource.count > 0) {
        return self.selectAllView;
    }
    return nil;
}

#pragma mark - WYMsgAlarmCellDelegate
- (void)WYMsgAlarmCell:(WYMsgAlarmCell *)cell selectButton:(UIButton *)button {
    button.selected = !button.isSelected;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYMsgAlarmModel *model = self.dataSource[indexPath.row];
    model.selected = button.isSelected;
    if (button.isSelected) {
        [self.selectedSource addObject:model];
    }else {
        [self.selectedSource removeObject:model];
    }
    self.selectAllView.selected = self.selectedSource.count == self.dataSource.count;
}

#pragma mark - public
- (void)networkRequestFromPush {
    if (_edited) return;
    
    [self networkRequestList];
}

@end


