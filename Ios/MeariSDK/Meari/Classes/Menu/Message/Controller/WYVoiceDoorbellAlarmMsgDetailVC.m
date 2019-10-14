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

@interface WYVoiceDoorbellAlarmMsgDetailVC ()
{
    NSInteger _deviceID;
    NSString *_deviceName;
}
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UIBarButtonItem *settingItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) MeariDevice *device;
@property (nonatomic,   copy) NSString *deviceUrl;
@property (nonatomic, strong) MeariMessageInfoVisitor *selectVoiceInfo;
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
        [self.device stopPlayVoiceMessageAudio];
    });
}
#pragma mark - init
- (void)initSet {
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
        
        tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageNum = 0;
            [weakSelf networkRequestList];
        }];
        tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            weakSelf.pageNum++;
//            WY_NotReachable ? [weakSelf localRefresh] : [weakSelf networkRequestList];
        }];
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
//    BOOL hasUnreadMsg = [WY_CoreDataM hasUnreadVoiceMessageOfDevice:@(_deviceID)];
//    [WY_NotificationCenter wy_post_Devices_ChangeAlarmMsgReadFlag:^(NSMutableArray<WYObj_Device *> *devices) {
//        WYObj_Device *device = [WYObj_Device new];
//        device.deviceID = self->_deviceID;
//        device.hasUnreadMsg = hasUnreadMsg;
//        [devices addObject:device];
//    }];
    [self wy_pop];
}

#pragma mark - 网络请求
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getVisitorMessageListForDevice:self.device.info.ID pageNum:_pageNum+1 success:^(NSArray<MeariMessageInfoVisitor *> *msgs) {
        NSLog(@"voice bell--%@",msgs);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        for (MeariMessageInfoVisitor *visitor in msgs) {
            if (visitor.msgType == MeariVisitorMessageTypeUnreadMessage ||visitor.msgType == MeariVisitorMessageTypeHasReadMessage) {
                self.selectVoiceInfo = visitor;
                NSLog(@"get voice message");
            }
        }
        if (msgs.count) {        
            self.selectVoiceInfo = msgs[0];
        }
//        weakSelf.isLoading = NO;
//        [weakSelf dealNetworkDataList:responseDic];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)dealNetworkDataList:(NSArray *)data device:(MeariDevice *)device {
    self.device = device;
    for (MeariMessageInfoVisitor *info in data) {
        [WY_CoreDataM insertEntityModel:WYEntity_DeviceAlertMsg dealBlock:^(DeviceAlertMsg * entityModel) {
            [entityModel setModelWithInfo:info UUID:self.device.info.uuid];
        }];
    }
    [self localRefresh];
}
- (void)playVoiceWithModel:(MeariMessageInfoVisitor *)model voiceCell:(WYVoiceDoorbellMsgVoiceCell *)cell {
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WYVoiceDoorbellMsgVoiceCell class]]) {
            WYVoiceDoorbellMsgVoiceCell *cell = (WYVoiceDoorbellMsgVoiceCell *)obj;
            if (cell.isPlaying) {
                cell.isPlaying = NO;
            }
        }
    }];
    
        [cell showLoading];
    if (!model) {
        WY_HUD_SHOW_TOAST(@"MeariMessageInfoVisitor is null")
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[MeariUser sharedInstance] getVoiceMessageAudioData:model.voiceUrl deviceID:self.device.info.ID success:^(NSData *data) {
        NSString *filePath = [[NSFileManager audioFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"voiceBell_voice.g711u"]];
        int result = [data writeToFile:filePath atomically:YES];
        if (result) {
            [self.device stopPlayVoiceMessageAudio];
            usleep(1000*500);
            cell.isPlaying = YES;
            [self.device startPlayVoiceMessageAudioWithFile:filePath finished:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.isPlaying = NO;
                });
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)stopVoiceWithModel:(WYVoiceMsgModel *)model {
    [self.device stopPlayVoiceMessageAudio];
}
- (void)saveVoiceData:(NSData *)data msgModel:(WYVoiceMsgModel *)model {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msgID=%@ AND userID=%@ AND deviceID=%@",model.msg.msgID,WY_USER_ID,@(_deviceID)];
    NSArray *existedMsgs = [WY_CoreDataM queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
    if (existedMsgs.count) {
        DeviceAlertMsg *msg = existedMsgs.firstObject;
//        [msg saveLocalVoiceData:data];
    }
    [WY_CoreDataM saveContext];
}
- (void)dealNetworkDataList:(NSDictionary *)responseDic {
    /*
    NSString *UUID = WY_SafeStringValue(responseDic[@"deviceUUID"]);
    if (responseDic[@"voiceBellMsgList"]) {
        NSArray *arr = responseDic[@"voiceBellMsgList"];
        if (!WY_IsKindOfClass(arr, NSArray)) return;
        
        for (NSDictionary *dic in arr) {
            NSMutableDictionary *dealDic = dic.mutableCopy;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msgID=%@ AND userID=%@ AND deviceID=%@",dic[@"msgID"],WY_USER_ID,@(_deviceID)];
            //去重
            NSArray *existedMsgs = [WY_CoreDataM queryDataWithEntityName:WYEntity_DeviceAlertMsg predicate:predicate];
            if (existedMsgs.count) {
                continue;
            }
            
            //插入数据库
            NSInteger msgType = WY_SafeStringValue(dic[@"msgType"]).integerValue;
            [WY_CoreDataM insertEntityModel:WYEntity_DeviceAlertMsg dealBlock:^(DeviceAlertMsg * entityModel) {
                [dealDic setObject:WY_SafeValue(WY_USER_ID) forKey:@"userID"];
                [entityModel setModelWithDictionary:dealDic UUID:UUID];
                if (msgType == 1 || msgType == 2 || msgType == 4) {
                    [entityModel setReaded];
                }
            }];
        }
        
        [self localRefresh];
    } else {
        [self localRefresh];
    }
     */
}

- (void)localRefresh {
    
    if (self.pageNum == 0) {
        [self.tableView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
    }else {//加载时，结束加载
        if (self.dataSource.count < self.pageNum * WYMsgAlarmMaxCountPerPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [self.tableView.mj_footer endRefreshing];
    }
    /*
    NSArray *resultArr = [WY_CoreDataM getSortedVoiceMessagesOfDevice:@(_deviceID) perPageCount:WYMsgAlarmMaxCountPerPage pageIndex:self.pageNum];
    
    
//    [self.dataSource removeAllObjects];
//    NSArray *resultArr = [WY_CoreDataM getSortedVoiceAlarmMessagesOfDevice:@(_deviceID)];
    [resultArr enumerateObjectsUsingBlock:^(DeviceAlertMsg *msg, NSUInteger idx, BOOL * _Nonnull stop) {
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
            [self.dataSource addObject:model];
        }
        
        //添加消息
        WYVoiceMsgModel *model = [WYVoiceMsgModel new];
        model.msg = msg;
        [self.dataSource addObject:model];
    }];
    [WY_CoreDataM saveContext];
     */
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
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewAutomaticDimension];
}

- (void)networkRequestDelete:(NSInteger)msgID {
    [[MeariUser sharedInstance] deleteVoice:msgID success:^{
        NSLog(@"delete voice message");
    } failure:^(NSError *error) {
        WY_HUD_SHOW_ServerError
    }];
}

- (void)networkRequestMark {
    //    NSString *url = WY_URLJAVA(MRURL_Msg_AlarmMarkRead);
    //    NSDictionary *params = @{@"deviceID":@(_deviceID)};
    //    [HttpTool HttpPOSTOnlySuccess:url parameters:params success:nil];
}

#pragma mark - WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, MeariDevice)) {
        MeariDevice *camera = (MeariDevice *)obj;
        self.device = camera;
        _deviceID = camera.info.ID;
        _deviceName = camera.info.connectName;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"获取访客事件";
            break;
        case 1:
            cell.textLabel.text = @"设置语音门铃声音";
            break;
        case 2:
            cell.textLabel.text = @"设置铃铛属性";
            break;
        case 3:
            cell.textLabel.text = @"设置访客留言";
            break;
        case 4:
            cell.textLabel.text = @"获取所有参数";
            break;
        case 5:
            cell.textLabel.text = @"播放客人留言";
            break;
        case 6:
            cell.textLabel.text = @"升级固件";
            break;
        case 7: {
            cell.textLabel.text = @"删除单条访客消息";
            break;
        }
        case 8: {
            cell.textLabel.text = @"删除所有访客消息";
            break;
        }
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WY_WeakSelf
    switch (indexPath.row) {
        case 0:
            // @"获取访客事件";
            [self networkRequestList];
            break;
        case 1: {
            // @"设置语音门铃声音";
            [self.device setVoiceBellVolume:50 success:^{
                NSLog(@"set voice bell volume success-%ld",weakSelf.device.param.voiceBell.ringSpeakerVolume);
            } failure:^(NSError *error) {
                NSLog(@"set voice bell volume failure");
            }];
            break;
        }
        case 2: {
            // @"设置铃铛属性";
            [self.device setVoiceBellCharmVolume:1 songDuration:1 songIndex:1 success:^{
                NSLog(@"set voice bell charm success-Volume-%ld-Duration-%ld-songIndex-%ld",weakSelf.device.param.voiceBell.jingleVolume,weakSelf.device.param.voiceBell.jingleDuration,weakSelf.device.param.voiceBell.jingleRing);
            } failure:^(NSError *error) {
                NSLog(@"set voice bell charm success");
            }];
            break;
        }
        case 3: {
            // @"设置访客留言";
            [self.device setVoiceBellEnterMessageTime:10 messageDurationTime:10 success:^{
                NSLog(@"set voice bell Message success--EnterMessageTime-%ld--DurationTime-%ld",weakSelf.device.param.voiceBell.waitMsgTime,weakSelf.device.param.voiceBell.msgLimitTime);
            } failure:^(NSError *error) {
                NSLog(@"set voice bell Message success");
            }];
            break;
        }
        case 4: {
            //获取所有参数
            [self.device getParamsSuccess:^(MeariDeviceParam *param) {
                NSLog(@"get voice bell params success");
            } failure:^(NSError *error) {
                NSLog(@"get voice bell params success");
            }];
            break;
        }
        case 5: {
            //播放访客留言
            [self playVoiceWithModel:self.selectVoiceInfo voiceCell:nil];
            break;
        }
        case 6: {
            //升级固件
            [self.device getParamsSuccess:^(MeariDeviceParam *param) {
                weakSelf.deviceUrl = param.voiceBell.deviceVersion;
                [[MeariUser sharedInstance] checkNewFirmwareWithCurrentFirmware:weakSelf.deviceUrl success:^(MeariDeviceFirmwareInfo *info) {
                    [weakSelf.device upgradeVoiceBellWithUrl:info.upgradeUrl latestVersion:info.latestVersion success:^{
                        NSLog(@"升级语音门铃成功");
                    } failure:^(NSError *error) {
                        NSLog(@"升级语音门铃失败%@",error);
                    }];
                } failure:^(NSError *error) {
                
                }];
            } failure:^(NSError *error) {
                
            }];
            break;
        }
        case 7: {
            //删除单条数据
            [[MeariUser sharedInstance] deleteVoiceMessage:self.selectVoiceInfo.msgID success:^{
                NSLog(@"删除消息成功");
            } failure:^(NSError *error) {
                NSLog(@"删除消息失败");
            }];
            break;
        }
        case 8: {
            //删除所有数据
            [[MeariUser sharedInstance] deleteAllVoiceMessage:self.selectVoiceInfo.deviceID success:^{
                NSLog(@"删除所有消息成功");
            } failure:^(NSError *error) {
                NSLog(@"删除所有消息失败");
            }];
            break;
        }
        default:
            break;
    }
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
        if (self.device.info.needUpdate) {
            _settingItem = [UIBarButtonItem settingRedImageItemWithTarget:self action:@selector(settingAction:)];
        }else {
            _settingItem = [UIBarButtonItem settingImageItemWithTarget:self action:@selector(settingAction:)];
        }
    }
    return _settingItem;
}
- (void)settingAction:(UIButton *)sender {
    [self wy_pushToVC:WYVCTypeCameraSetting sender:self.device];
}
- (void)dealloc {
    self.device = nil;
}
@end
