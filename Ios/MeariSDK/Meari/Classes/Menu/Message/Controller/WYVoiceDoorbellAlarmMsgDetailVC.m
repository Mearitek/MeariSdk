//
//  WYVoiceDoorbellAlarmMsgDetailVC.m
//  Meari
//
//  Created by MJ2009 on 2018/7/4.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "WYVoiceDoorbellAlarmMsgDetailVC.h"
#import "WYMsgAlarmDetailVC.h"
#import "WYVoiceMsgModel.h"
#import "WYVoiceDoorbellMsgTimeCell.h"
#import "WYVoiceDoorbellMsgCallCell.h"
#import "WYVoiceDoorbellMsgVoiceCell.h"
const NSInteger WYMsgVoiceBellMaxCountPerPage = 5;    //每页消息条数
@interface WYVoiceDoorbellAlarmMsgDetailVC ()
{
    NSInteger _deviceID;
    NSString *_deviceName;
}
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UIBarButtonItem *settingItem;
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation WYVoiceDoorbellAlarmMsgDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.camera stopPlayVoiceMessageAudio];
    });
}
#pragma mark - init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = WYLocalString(@"device_visitor_message");
    self.navigationItem.rightBarButtonItem = self.settingItem;
    
    WY_WeakSelf
    self.setTableView = ^(UITableView *tableView) {
        [tableView wy_registerClass:[WYVoiceDoorbellMsgTimeCell class] fromNib:YES];
        [tableView wy_registerClass:[WYVoiceDoorbellMsgCallCell class] fromNib:NO];
        [tableView wy_registerClass:[WYVoiceDoorbellMsgVoiceCell class] fromNib:NO];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
        weakSelf.pageNum = -1;
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageNum++;
            [weakSelf networkRequestList];
        }];
        //        tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        //            weakSelf.pageNum++;
        //            WY_NotReachable ? [weakSelf localRefresh] : [weakSelf networkRequestList];
        //        }];
    };
}

- (void)initLayout {
    WY_WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
    }];
}

#pragma mark -- action
- (void)backAction:(UIButton *)sender {
    BOOL hasUnreadMsg = [WY_CoreDataM hasUnreadVoiceMessageOfDevice:@(_deviceID)];
    [WY_NotificationCenter wy_post_Devices_ChangeAlarmMsgReadFlag:^(NSMutableArray<WYObj_Device *> *devices) {
        WYObj_Device *device = [WYObj_Device new];
        device.deviceID = self->_deviceID;
        device.hasUnreadMsg = hasUnreadMsg;
        [devices addObject:device];
    }];
    [self wy_pop];
}

#pragma mark - 网络请求
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getVoiceMessagesWithDeviceID:self.camera.info.ID pageNum:_pageNum + 1 success:^(NSArray<MeariMessageInfoVisitor *> *msgs) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf dealNetworkDataList:msgs];
    } failure:^(NSError *error) {
        WY_HUD_SHOW_ERROR(error);
    }];
}
- (void)networkMakeVoiceMessageAsRead:(WYVoiceMsgModel*)model {
    [[MeariUser sharedInstance] updateVoiceMessageStatusWithMessageID:[model.msg.msgID integerValue] success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)playVoiceWithModel:(WYVoiceMsgModel *)model voiceCell:(WYVoiceDoorbellMsgVoiceCell *)cell {
    [self networkMakeVoiceMessageAsRead:model];
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WYVoiceDoorbellMsgVoiceCell class]]) {
            WYVoiceDoorbellMsgVoiceCell *cell = (WYVoiceDoorbellMsgVoiceCell *)obj;
            if (cell.isPlaying) {
                cell.isPlaying = NO;
            }
        }
    }];
    if (model.msg.localVoiceData) {
        NSLog(@"音频已下载");
        NSData *data = model.msg.localVoiceData;
        NSString *filePath = [[NSFileManager audioFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"voiceBell_voice.g711u"]];
        int result = [data writeToFile:filePath atomically:YES];
        if (result) {
            cell.isPlaying = YES;
            [self.camera stopPlayVoiceMessageAudio];
            usleep(1000*500);
            [self.camera startPlayVoiceMessageAudioWithFile:filePath finished:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.isPlaying = NO;
                });
            }];
        }
    } else {
        NSLog(@"音频未下载");
        [cell showLoading];
        [[MeariUser sharedInstance] getVoiceOssTokenWithRemoteUrl:model.msg.voiceUrl deviceID:self.camera.info.ID success:^(NSData *data) {
            NSString *filePath = [[NSFileManager audioFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"voiceBell_voice.g711u"]];
            int result = [data writeToFile:filePath atomically:YES];
            if (result) {
                [self.camera stopPlayVoiceMessageAudio];
                usleep(1000*500);
                cell.isPlaying = YES;
                [self.camera startPlayVoiceMessageAudioWithFile:filePath finished:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.isPlaying = NO;
                    });
                }];
            }
            [self saveVoiceData:data msgModel:model];
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)stopVoiceWithModel:(WYVoiceMsgModel *)model {
    [self.camera stopPlayVoiceMessageAudio];
}
//保存消息状态
- (void)saveVoiceData:(NSData *)data msgModel:(WYVoiceMsgModel *)model {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate=%@ AND userID=%@ AND deviceID=%@",model.msg.msgID,WY_USER_ID,@(_deviceID)];
    NSArray *existedMsgs = [WY_CoreDataM queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
    if (existedMsgs.count) {
        DeviceAlertMsg *msg = existedMsgs.firstObject;
        model.msg.msgType = @(4);
        [msg setReaded];
        if (data) {
            [msg saveLocalVoiceData:data];
        }
    }
    [WY_CoreDataM saveContext];
}
- (void)dealNetworkDataList:(NSArray *)msgs {
    for (MeariMessageInfoVisitor *info in msgs) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createDate=%@ AND userID=%@ AND deviceID=%@",info.createDate,WY_USER_ID,@(_deviceID)];
        //去重
        NSArray *existedMsgs = [WY_CoreDataM queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
        if (existedMsgs.count) {
            continue;
        }
        //插入数据库
        NSInteger msgType = info.msgID;
        [WY_CoreDataM insertEntityModel:WYEntity_DeviceAlertMsg dealBlock:^(DeviceAlertMsg * entityModel) {
            [entityModel setModelWithInfoVisitor:info UUID:self.camera.info.uuid];
            if (msgType == 1 || msgType == 2 || msgType == 4) {
                [entityModel setReaded];
            }
        }];
    }
     [self localRefresh];
}

- (void)localRefresh {
    
    if (self.pageNum == 0) {
        [self.tableView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
    }else {//加载时，结束加载
        //if (self.dataSource.count < self.pageNum * WYMsgAlarmMaxCountPerPage) {
        //[self.tableView.mj_footer endRefreshingWithNoMoreData];
        //return;
        //}
        //[self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    
    NSArray *resultArr = [WY_CoreDataM getSortedVoiceMessagesOfDevice:@(_deviceID) perPageCount:WYMsgVoiceBellMaxCountPerPage pageIndex:self.pageNum];
    
    NSArray *sortArr = [resultArr sortedArrayUsingComparator:^NSComparisonResult(DeviceAlertMsg   *obj1, DeviceAlertMsg  *obj2) {
        NSComparisonResult result = [obj1.createDate compare:obj2.createDate];
        return result == NSOrderedDescending;
    }];
    NSMutableArray *temArr = [NSMutableArray array];
    [sortArr enumerateObjectsUsingBlock:^(DeviceAlertMsg *msg, NSUInteger idx, BOOL * _Nonnull stop) {
        //添加时间标签
        BOOL isNeedTimeLabel = NO;
        if (idx == 0) {
            isNeedTimeLabel = YES;
        }
        if (idx > 0) {
            DeviceAlertMsg *preMsg = resultArr[idx - 1];
            if (msg.createDate.doubleValue - preMsg.createDate.doubleValue > 3 * 60) {//超过3分钟
                isNeedTimeLabel = YES;
            }
        }
        if (isNeedTimeLabel) {
            WYVoiceMsgModel *model = [WYVoiceMsgModel new];
            model.isTimeTag = YES;
            model.createDateInterval = msg.createDate.doubleValue;
            [temArr addObject:model];
        }
        //添加消息
        WYVoiceMsgModel *model = [WYVoiceMsgModel new];
        model.msg = msg;
        [temArr addObject:model];
    }];
    [self.dataSource insertObjects:temArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temArr.count)]];
    [WY_CoreDataM saveContext];
    [self.tableView reloadData];
}

- (void)deleteMsg:(WYVoiceMsgModel *)model {
    NSInteger index = [self.dataSource indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    //删除相邻的时间标签
    NSIndexPath *preIndexPath = nil;
    WYVoiceMsgModel *preModel = nil;
    NSArray *indexPaths = @[indexPath];
    if (index > 0) {
        preIndexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
        preModel = self.dataSource[index - 1];
        indexPaths = @[preIndexPath, indexPath];
    }
    if (preModel.isTimeTag) {
        [self.dataSource removeObject:preModel];
    }
    
    [self networkRequestDelete:model.msg.msgID.integerValue];
    [self.dataSource removeObject:model];
    [WY_CoreDataM deleteData:model.msg];
    [self.tableView reloadData];
}

- (void)networkRequestDelete:(NSInteger)msgID {
    [[MeariUser sharedInstance] deleteSingleVoiceMessageWithMessageID:msgID success:^{
        
    } failure:^(NSError *error) {
        WY_HUD_SHOW_ERROR(error)
    }];
}

- (void)networkRequestMark {
    //    NSString *url = WY_URLJAVA(WYURL_Msg_AlarmMarkRead);
    //    NSDictionary *params = @{@"deviceID":@(_deviceID)};
    //    [HttpTool HttpPOSTOnlySuccess:url parameters:params success:nil];
}

#pragma mark - WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        MeariDevice *camera = (MeariDevice *)obj;
        self.camera = camera;
        _deviceID = camera.info.ID;
        _deviceName = camera.info.nickname;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYVoiceMsgModel *model = self.dataSource[indexPath.row];
    
    if (model.isTimeTag) {
        WYVoiceDoorbellMsgTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYVoiceDoorbellMsgTimeCell) forIndexPath:indexPath];
        timeCell.model = model;
        return timeCell;
    }
    
    WY_WeakSelf
    DeviceAlertMsg *msg = model.msg;
    if (msg.msgType.integerValue == 1 || msg.msgType.integerValue == 2) {
        WYVoiceDoorbellMsgCallCell *callCell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYVoiceDoorbellMsgCallCell) forIndexPath:indexPath];
        callCell.model = model;
        callCell.deleteAction = ^{
            [weakSelf deleteMsg:model];
        };
        return callCell;
    }
    
    if (msg.msgType.integerValue == 3 || msg.msgType.integerValue == 4) {
        WYVoiceDoorbellMsgVoiceCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYVoiceDoorbellMsgVoiceCell) forIndexPath:indexPath];
        voiceCell.model = model;
        voiceCell.deleteAction = ^{
            [weakSelf deleteMsg:model];
        };
        __weak typeof(voiceCell) weakVoiceCell = voiceCell;
        voiceCell.playAction = ^(WYVoiceMsgModel *model) {
            [weakSelf playVoiceWithModel:model voiceCell:weakVoiceCell];
        };
        voiceCell.stopAction = ^(WYVoiceMsgModel *model) {
            [weakSelf stopVoiceWithModel:model];
        };
        return voiceCell;
    }
    
    return [UITableViewCell new];
}

#pragma mark - Public
- (void)networkRequestFromPush {
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

#pragma mark - Other
- (UIBarButtonItem *)settingItem {
    if (!_settingItem) {
        if (self.camera.info.needUpdate) {
            _settingItem = [UIBarButtonItem settingRedImageItemWithTarget:self action:@selector(settingAction:)];
        }else {
            _settingItem = [UIBarButtonItem settingImageItemWithTarget:self action:@selector(settingAction:)];
        }
    }
    return _settingItem;
}
- (void)settingAction:(UIButton *)sender {
    [self wy_pushToVC:WYVCTypeCameraSetting sender:self.camera];
}
@end
