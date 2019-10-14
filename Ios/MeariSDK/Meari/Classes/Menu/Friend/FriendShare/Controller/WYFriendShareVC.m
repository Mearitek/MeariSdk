//
//  WYFriendShareVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/14.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYFriendShareVC.h"
#import "WYFriendListModel.h"
#import "WYFriendShareModel1.h"
#import "WYFriendShareModel2.h"
#import "WYFriendShareCell1.h"
#import "WYFriendShareCell2.h"
#import "WYFriendShareHeaderView.h"

@interface WYFriendShareVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, WYFriendShareCell1Delegate>
@property (nonatomic, strong)WYFriendListModel *model;
@property (nonatomic, strong)UITableView *infoTableView;
@property (nonatomic, strong)UITextField *tf;
@property (nonatomic, strong)NSMutableArray *dataSource1;
@property (nonatomic, strong)NSMutableArray *dataSource2;

@end

@implementation WYFriendShareVC
#pragma mark -- Getter
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [UITableView wy_tableView];
        [_infoTableView wy_setDelegate:self];
        [self.view addSubview:_infoTableView];
    }
    return _infoTableView;
}
- (UITextField *)tf {
    if (!_tf) {
        WYFriendShareCell1 *cell = [self.infoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        for (UIView *v in cell.contentView.subviews) {
            if (WY_IsKindOfClass(v, UITextField)) {
                _tf = v;
            }
        }
    }
    return _tf;
}
WYGetter_MutableArray(dataSource1)
WYGetter_MutableArray(dataSource2)

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
    [self initNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)deallocAction {
    [WY_NotificationCenter removeObserver:self];
}

#pragma mark -- Init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = WYLocalString(@"friendShare_title");
    self.dataSource1 = @[[WYFriendShareModel1 friend_mark:self.model.info.nickName],
                         [WYFriendShareModel1 friend_account:self.model.info.userAccount],
                         ].mutableCopy;
    self.infoTableView.scrollEnabled = NO;
    [self.infoTableView wy_registerClass:[WYFriendShareCell1 class] fromNib:YES];
    
    
    WY_WeakSelf
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    NSInteger padding1 = 15;
    NSInteger padding2 = 25;
    CGFloat width = (WY_ScreenWidth - 2*padding1 - padding2)/2;
    CGFloat height = width*9.0/16+28;
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumInteritemSpacing = padding2;
    layout.minimumLineSpacing = 20;
    layout.sectionInset = UIEdgeInsetsMake(0, padding1, 20, padding1);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(WY_ScreenWidth, 60);
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:layout];
    collectionV.dataSource = self;
    collectionV.delegate = self;
    collectionV.backgroundColor = [UIColor whiteColor];
    collectionV.bounces = YES;
    [collectionV registerClass:[WYFriendShareHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionV registerNib:[UINib nibWithNibName:WY_ClassName(WYFriendShareCell2) bundle:nil] forCellWithReuseIdentifier:@"cell2"];
    collectionV.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf networkRequestList];
    }];

    [self.view addSubview:collectionV];
    self.collectionView = collectionV;
    [self.collectionView.mj_header beginRefreshing];

}
- (void)initLayout {
    WY_WeakSelf
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@140);
        make.top.leading.trailing.equalTo(weakSelf.view);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.infoTableView.mas_bottom);
        make.leading.trailing.bottom.equalTo(weakSelf.view);
    }];
}
- (void)initNotification {
    [WY_NotificationCenter addObserver:self selector:@selector(n_keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark -- Notification
- (void)n_keyboardShow:(NSNotification *)sender {
    [self.infoTableView addTapGestureTarget:self action:@selector(tapAction:)];
    [self.collectionView addTapGestureTarget:self action:@selector(tapAction:)];
}

#pragma mark -- Network
- (void)networkRequestChangeMark {
    WY_WeakSelf
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] renameFriend:self.model.info.userID markname:self.tf.text success:^{
        WY_HUD_SHOW_SUCCESS_STATUS(WYLocalString(@"friendShare_remark_suc"))
        weakSelf.model.info.nickName = weakSelf.tf.text;
        [weakSelf.wy_pushFromVC transitionObject:weakSelf.model fromPage:WYVCTypeFriendShare];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestList {
    WY_WeakSelf
    [[MeariUser sharedInstance] getDeviceListForFriend:self.model.info.userID success:^(NSArray<MeariDevice *> *devices) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf dealNetworkRequestList:devices];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [WY_UserM dealMeariUserError:error];
    }];
}
- (void)networkRequestShare:(BOOL)share device:(WYFriendShareModel2 *)model {
    WY_HUD_SHOW_WAITING
    WY_WeakSelf
    if (share) {
        [[MeariUser sharedInstance] shareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:model.device.info.ID deviceUUID:model.device.info.uuid toFriend:self.model.info.userID success:^{
            WY_HUD_DISMISS
            model.device.info.shared = share;
            [weakSelf.collectionView reloadData];
        } failure:^(NSError *error) {
            [WY_UserM dealMeariUserError:error];
        }];
    } else {
        [[MeariUser sharedInstance] cancelShareDeviceWithDeviceType:MeariDeviceTypeIpc deviceID:model.device.info.ID deviceUUID:model.device.info.uuid toFriend:self.model.info.userID success:^{
            WY_HUD_DISMISS
            model.device.info.shared = share;
            [weakSelf.collectionView reloadData];
        } failure:^(NSError *error) {
            [WY_UserM dealMeariUserError:error];
        }];
    }
}
#pragma mark -- Utilities
- (void)dealNetworkRequestList:(NSArray *)dataDic {
    
    [self.dataSource2 removeAllObjects];
    for (MeariDevice *device in dataDic) {
        WYFriendShareModel2 *model = [WYFriendShareModel2 new];
        model.device = device;
        [self.dataSource2 addObject:model];
    }
    [self.collectionView reloadData];
}

#pragma mark -- Action
- (void)saveAction:(UIButton *)sender {
    if ([self.tf.text isEqualToString:self.model.info.nickName]) {
        return;
    }
    if (self.tf.text.length <= 0) {
        WY_HUD_SHOW_ERROR_STATUS(WYLocalString(@"friendShare_remark_fail_empty"))
        return;
    }
    
    [self networkRequestChangeMark];
}
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self.infoTableView removeGestureRecognizer:sender];
    [self.collectionView removeGestureRecognizer:sender];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    if (WY_IsKindOfClass(obj, WYFriendListModel)) {
        self.model = obj;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource1.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYFriendShareCell1 *cell = [tableView dequeueReusableCellWithIdentifier:WY_ClassName(WYFriendShareCell1) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    WYFriendShareModel1 *model = self.dataSource1[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource2.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYFriendShareCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
    WYFriendShareModel2 *model = self.dataSource2[indexPath.row];
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        WYFriendShareHeaderView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerV.text = self.dataSource2.count > 0 ? WYLocalString(@"friendShare_share_des") : nil;
        return headerV;
    }
    return nil;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WYFriendShareModel2 *model = self.dataSource2[indexPath.row];
    [self networkRequestShare:!model.device.info.shared device:model];
}

#pragma mark -- UICollectionViewLayoutDelegate

#pragma mark -- WYFriendShareCell1Delegate
- (void)WYFriendShareCell1:(WYFriendShareCell1 *)cell didTapedSaveBtn:(UIButton *)sender {
    [self saveAction:sender];
}

@end
