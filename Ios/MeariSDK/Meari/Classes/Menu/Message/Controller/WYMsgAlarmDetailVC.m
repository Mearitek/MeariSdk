//
//  WYMsgAlarmDetailVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYMsgAlarmDetailVC.h"
#import "WYMsgAlarmDetailModel.h"
#import "WYMsgAlarmDetailBigCell.h"
#import "WYMsgAlarmDetailNormalCell.h"

NSInteger const WYMsgAlarmMaxCountPerPage = 20;    //每页消息条数

@interface WYMsgAlarmDetailVC ()<WYMsgAlarmDetailNormalCellDelegate,WYMsgAlarmDetailBigCellDelegate, MWPhotoBrowserDelegate>
{
    BOOL _edited;
    NSInteger _deviceID;
    NSString *_deviceName;
    MJRefreshFooter *_footer;
    
}

@property (nonatomic, strong)NSMutableArray *selectedSource;
@property (nonatomic, strong)WYSelectAllView *selectAllView;
@property (nonatomic, assign)NSInteger pageCount;   //页数

@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)NSMutableArray *thumbs;

@property (nonatomic, copy)MeariDevice *device;
@end

@implementation WYMsgAlarmDetailVC
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
            for (WYMsgAlarmDetailModel *model in weakSelf.dataSource) {
                model.selected = selected;
            }
            [weakSelf.tableView reloadData];
            selected ? weakSelf.selectedSource = weakSelf.dataSource.mutableCopy : [weakSelf.selectedSource removeAllObjects];
        }];
    }
    return _selectAllView;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    WY_WeakSelf
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset((_edited ? -60+WY_SAFE_BOTTOM_LAYOUT : WY_SAFE_BOTTOM_LAYOUT));
    }];
}

#pragma mark - life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WY_EditM setDelegate:self editStystle:WYEditStytleDeleteDeleteAndMark];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSet];
    [self initLayout];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = _deviceName;
    
    WY_WeakSelf
    self.setTableView = ^(UITableView *tableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView wy_registerClass:[WYMsgAlarmDetailNormalCell class] fromNib:YES];
        [tableView wy_registerClass:[WYMsgAlarmDetailBigCell class] fromNib:YES];
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageCount = 0;
            [weakSelf networkRequestList];
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }];
        tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.pageCount++;
            WY_Network_NoReachable ? [weakSelf localRefresh] : [weakSelf networkRequestList];
        }];
        _footer = tableView.mj_footer;
    };
}
- (void)initLayout {
    WY_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- action
- (void)backAction:(UIButton *)sender {
    BOOL hasUnreadMsg = [WY_CoreDataM hasUnreadMessageOfDevice:@(_deviceID)];
    [WY_NotificationCenter wy_post_Devices_ChangeAlarmMsgReadFlag:^(NSMutableArray<WYObj_Device *> *devices) {
        WYObj_Device *device = [WYObj_Device new];
        device.deviceID = _deviceID;
        device.hasUnreadMsg = hasUnreadMsg;
        [devices addObject:device];
    }];
    [self wy_pop];
}

#pragma mark - 网络请求
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getAlarmMessageListForDevice:_deviceID success:^(NSArray<MeariMessageInfoAlarmDevice *> *msgs, MeariDevice *device) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf dealNetworkDataList:msgs device:device];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)dealNetworkDataList:(NSArray *)data device:(MeariDevice *)device {
    self.device = device;
    for (MeariMessageInfoAlarmDevice *info in data) {
        [WY_CoreDataM insertEntityModel:WYEntity_DeviceAlertMsg dealBlock:^(DeviceAlertMsg * entityModel) {
            [entityModel setModelWithInfo:info UUID:self.device.info.uuid];
        }];
    }
    [self localRefresh];
}
- (void)networkRequestMark {
    [[MeariUser sharedInstance] markDeviceAlarmMessage:_deviceID success:nil failure:nil];
    
}
- (void)localRefresh {
    if (self.pageCount == 0) {
        [self.tableView.mj_header endRefreshing];
    }else {//加载时，结束加载
        if (self.dataSource.count < self.pageCount * WYMsgAlarmMaxCountPerPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [self.tableView.mj_footer endRefreshing];
    }

    [self.dataSource removeAllObjects];
    NSArray *resultArr = [WY_CoreDataM getSortedAlarmMessagesOfDevice:@(_deviceID) count:(self.pageCount + 1) * WYMsgAlarmMaxCountPerPage];

    for (DeviceAlertMsg *msg in resultArr) {
        WYMsgAlarmDetailModel *model = [[WYMsgAlarmDetailModel alloc] init];
        model.msg = msg;
        model.selected = NO;
        [self.dataSource addObject:model];
    }
    [WY_CoreDataM saveContext];
    [self.tableView reloadData];
}
- (void)networkDeleteAllMessages {
    [[MeariUser sharedInstance] deleteAllAlarmMessagesForDevice:_deviceID success:nil failure:nil];
}

#pragma mark - WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        MeariDevice *camera = (MeariDevice *)obj;
        _deviceID = camera.info.ID;
        _deviceName = camera.info.nickname;
    }
}

#pragma mark - WYEditManagerDelegate
- (void)updateTableView {
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (BOOL)canEdit {
    return self.dataSource.count > 0;
}
- (void)editEdit {
    _edited = YES;
    self.selectAllView.selected = NO;
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer = nil;
    [self.tableView reloadData];
    [self updateTableView];
}
- (void)editCancel {
    _edited = NO;
    if (WY_EditM.edited) {
        WY_EditM.edited = NO;
    }
    self.selectAllView.selected = NO;
    self.tableView.mj_header.hidden = NO;
    self.tableView.mj_footer = _footer;
    for (WYMsgAlarmDetailModel *model in self.dataSource) {
        model.selected = NO;
    }
    [self.selectedSource removeAllObjects];
    [self.tableView reloadData];
    [self updateTableView];
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
                               if (weakSelf.selectAllView.selected) {
                                   [WY_CoreDataM deletegetAllAlarmMessagesOfDevice:@(_deviceID)];
                                   [weakSelf.dataSource removeAllObjects];
                                   [weakSelf.selectedSource removeAllObjects];
                                   [weakSelf editCancel];
                                   [weakSelf networkDeleteAllMessages];
                                   [weakSelf backAction:nil];
                               }else {
                                   for (WYMsgAlarmDetailModel *model in weakSelf.selectedSource) {
                                       [WY_CoreDataM deleteData:model.msg];
                                   }
                                   [weakSelf.dataSource removeObjectsInArray:weakSelf.selectedSource];
                                   [weakSelf.selectedSource removeAllObjects];
                                   if (weakSelf.dataSource.count == 0) {
                                       [weakSelf editCancel];
                                   }else {
                                       [weakSelf.tableView reloadData];
                                   }
                               }
                           }
                       }];
    }
    
}
- (void)editMark {
    if (self.selectedSource.count == 0) {
        [SVProgressHUD wy_showToast:WYLocalString(@"error_noChoice")];
        return;
    }
    if (self.selectAllView.selected) {
        [self networkRequestMark];
        NSArray *arr = [WY_CoreDataM getAllAlarmMessagesOfDevice:@(_deviceID)];
        for (DeviceAlertMsg *msg in arr) {
            [msg setReaded];
        }
        [WY_CoreDataM saveContext];
    }else {
        for (WYMsgAlarmDetailModel *model in self.selectedSource) {
            [model.msg setReaded];
        }
        [WY_CoreDataM saveContext];
    }
    [self editCancel];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYMsgAlarmDetailModel *model = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        WYMsgAlarmDetailBigCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYMsgAlarmDetailBigCell) forIndexPath:indexPath];
        cell.delegate = self;
        cell.hideBottomLine = indexPath.row == self.dataSource.count - 1;
        [cell passModel:model edited:_edited];
        return cell;
    }
    
    WYMsgAlarmDetailNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYMsgAlarmDetailNormalCell) forIndexPath:indexPath];
    cell.delegate = self;
    cell.hideBottomLine = indexPath.row == self.dataSource.count - 1;
    [cell passModel:model edited:_edited];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return _edited ? [WYMsgAlarmDetailBigCell editedCellHeight] : [WYMsgAlarmDetailBigCell cellHeight];
    }
    return [WYMsgAlarmDetailNormalCell cellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_edited && self.dataSource.count > 0) {
        return 50;
    }
    return 0;
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
        [v addSubview:self.selectAllView];
        [self.selectAllView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.leading.bottom.and.trailing.equalTo(v);
        }];
    }
    return v;
}

#pragma mark - WYMsgAlarmDetailNormalCellDelegate
- (void)WYMsgAlarmDetailNormalCell:(WYMsgAlarmDetailNormalCell *)cell didTapActionBtn:(UIButton *)button {
    [self dealCell:cell actionBtn:button];
}
- (void)WYMsgAlarmDetailNormalCell:(WYMsgAlarmDetailNormalCell *)cell didTapImageView:(UIImageView *)imageView {
    if (_edited) return;
    
    [self jumpToBrowserWithCell:cell];
}
#pragma mark - WYMsgAlarmDetailBigCellDelegate
- (void)WYMsgAlarmDetailBigCell:(WYMsgAlarmDetailBigCell *)cell didTapActionBtn:(UIButton *)button {
    [self dealCell:cell actionBtn:button];
}
- (void)WYMsgAlarmDetailBigCell:(WYMsgAlarmDetailBigCell *)cell didTapImageView:(UIImageView *)imageView {
    if (_edited) return;
    
    [self jumpToBrowserWithCell:cell];
}

- (void)dealCell:(UITableViewCell *)cell actionBtn:(UIButton *)actionBtn {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYMsgAlarmDetailModel *model = self.dataSource[indexPath.row];
    if (_edited) {
        actionBtn.selected = !actionBtn.isSelected;
        model.selected = actionBtn.isSelected;
        if (actionBtn.isSelected) {
            [self.selectedSource addObject:model];
        }else {
            [self.selectedSource removeObject:model];
        }
        self.selectAllView.selected = self.selectedSource.count == self.dataSource.count;
    }else {
        [model.msg setReaded];
        [WY_CoreDataM saveContext];
        [self editCancel];
        if (self.device.info.limitLevel == MeariDeviceLimitLevelForbidden) {
            WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"status_deviceIsDeletedByOwner"))
        }else {
            WYVideoType videoType = (self.device.hasBindedNvr ? WYVideoTypePlaybackNVR : WYVideoTypePlaybackSDCard);
            NSDateComponents *dateC = [NSDateComponents dateComponentsWithYMDHMSStringNoSprit:model.msg.devLocalTime];
            WYVideo *video = [WYVideo videoWithCamera:self.device videoType:videoType dateComponets:dateC];
            [self wy_pushToVC:WYVCTypeCameraVideoOne sender:video];
        }
    }
}
#pragma mark - 跳到回放界面
- (void)jumpToBrowserWithCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYMsgAlarmDetailModel *model = self.dataSource[indexPath.row];
    [model.msg setReaded];
    [WY_CoreDataM saveContext];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    // 跳入图片浏览器
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    NSArray *urlArr = model.msg.alarmImageUrls;
    for (NSURL *url in urlArr) {
        MWPhoto *photo = [MWPhoto photoWithURL:url];
        [photos addObject:photo];
        [thumbs addObject:photo];
    }
    self.photos = photos;
    self.thumbs = thumbs;
    WYPhotoBrowser *browser = [WYPhotoBrowser wy_browserWithDelegate:self currentIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
}



#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
}

#pragma mark - Public
- (void)networkRequestFromPush {
    if (_edited) return;
    
    [self networkRequestList];
}
- (instancetype)initWithDeviceName:(NSString *)deviceName deviceID:(NSInteger)deviceID {
    self = [super init];
    if (self) {
        _deviceID = deviceID;
        _deviceName = deviceName.copy;
    }
    return self;
}


@end
