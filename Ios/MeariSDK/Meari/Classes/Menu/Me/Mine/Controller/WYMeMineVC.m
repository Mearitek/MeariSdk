//
//  WYMeMineVC.m
//  Meari
//
//  Created by 李兵 on 2017/9/20.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYMeMineVC.h"

@interface WYMeMineVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *avatarView;
@property (nonatomic, strong)UIImageView *avatarBGImageView;
@property (nonatomic, strong)UIImageView *avatarImageView;
@property (nonatomic, strong)UIImageView *editImageView;
@property (nonatomic, strong)UIButton *logoutBtn;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)WYBaseModel *nickNameModel;
@end

@implementation WYMeMineVC
#pragma mark -- Getter
WYGetter_MutableArray(dataSource)
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView wy_tableViewWithDelegate:self];
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = WY_iPhone_4 ? 50 : 70;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView addLineViewAtTop];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIView new];
        [self.view addSubview:_avatarView];
    }
    return _avatarView;
}
- (UIImageView *)avatarBGImageView {
    if (!_avatarBGImageView) {
        _avatarBGImageView = [UIImageView new];
        _avatarBGImageView.image = [UIImage imageNamed:@"img_me_avatar_shadow"];
        _avatarBGImageView.userInteractionEnabled = YES;
        [_avatarBGImageView addTapGestureTarget:self action:@selector(avatarAction:)];
        [self.avatarView addSubview:_avatarBGImageView];
    }
    return _avatarBGImageView;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        [_avatarImageView wy_setImageWithURL:[WY_USER_IMAGE wy_url] placeholderImage:[UIImage placeholder_person_image]];
        [self.avatarView addSubview:_avatarImageView];
    }
    return _avatarImageView;
}
- (UIImageView *)editImageView {
    if (!_editImageView) {
        _editImageView = [UIImageView new];
        _editImageView.image = [UIImage imageNamed:@"img_me_avatar_edit"];
        [self.avatarView addSubview:_editImageView];
    }
    return _editImageView;
}
- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton wy_buttonWithStytle:WYButtonStytleFilledGreenAndWhiteTitle target:self action:@selector(logoutAction:)];
        _logoutBtn.layer.cornerRadius = 22;
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.wy_normalTitle = WYLocalString(@"me_logout");
        [self.view addSubview:_logoutBtn];
    }
    return _logoutBtn;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.height/2;
}

#pragma mark -- Init
- (void)initSet {
    self.showNavigationLine = YES;
    self.navigationItem.title = WYLocalString(@"me_mine_title");
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backImageItemWithTarget:self action:@selector(backAction:)];
    
    WYBaseModel *account = [WYBaseModel modelWithImageName:nil text:WYLocalString(@"me_account") deatailedText:WY_USER_ACCOUNT];
    WYBaseModel *nickname = [WYBaseModel modelWithImageName:nil text:WYLocalString(@"me_nickname") deatailedText:WY_USER_NICK];
    WYBaseModel *change = [WYBaseModel modelWithImageName:nil text:WYLocalString(@"me_changePwd") deatailedText:nil];
    self.dataSource = @[account, nickname, change].mutableCopy;
    self.nickNameModel = nickname;
    if(WY_UserM.isUidLogined) {
        [self.dataSource removeObject:change];
    }
}
- (void)initLayout {
    WY_WeakSelf
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@150);
        make.top.equalTo(weakSelf.view).offset(5);
        make.centerX.equalTo(weakSelf.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(weakSelf.dataSource.count*weakSelf.tableView.rowHeight));
        make.top.equalTo(weakSelf.avatarView.mas_bottom).offset(5);
        make.centerX.width.equalTo(weakSelf.view);
    }];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(WY_iPhone_4 ? -30 : -60);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(@44);
        make.width.equalTo(weakSelf.view).multipliedBy(0.7);
    }];
    
    [self.avatarBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.avatarView);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.avatarView);
        make.width.equalTo(weakSelf.avatarView).offset(-30);
        make.height.equalTo(weakSelf.avatarView).offset(-30);
    }];
    [self.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(33, 33));
        make.bottom.equalTo(weakSelf.avatarImageView);
        make.trailing.equalTo(weakSelf.avatarImageView);
    }];
}

#pragma mark -- Action
- (void)backAction:(UIButton *)sender {
    [WY_Appdelegate wy_loadCameraVC];
    [WY_SlideVC showLeftViewController:YES];
}
- (void)logoutAction:(UIButton *)sender {
    WY_WeakSelf
    [WYAlertView showLogout:^{
        [weakSelf networkRequestLogout];
    }];
}
- (void)avatarAction:(UITapGestureRecognizer *)sender {
    [self wy_pushToVC:WYVCTypeMeMineAvatar];
}

#pragma mark -- Network
- (void)networkRequestLogout {
    WY_HUD_SHOW_WAITING
    [[MeariUser sharedInstance] logoutSuccess:^{
        WY_HUD_DISMISS
        [WY_UserM signOut];
        [WY_Appdelegate wy_loadLoginVC];
    } failure:^(NSError *error) {
        [WY_UserM dealMeariUserError:error];
    }];
}

#pragma mark - Delegate
#pragma mark -- WYTransition
- (void)transitionObject:(id)obj fromPage:(WYVCType)VCType {
    [super transitionObject:obj fromPage:VCType];
    switch (VCType) {
        case WYVCTypeMeMineNickname: {
            if (WY_IsKindOfClass(obj, NSString)) {
                self.nickNameModel.detailedText = obj;
                [self.tableView reloadData];
            }
            break;
        }
        case WYVCTypeMeMineAvatar: {
            if (WY_IsKindOfClass(obj, UIImage)) {
                self.avatarImageView.image = obj;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell addLineViewAtBottom];
    }
    WYBaseModel *model = self.dataSource[indexPath.row];
    [cell addLineViewAtBottom];
    cell.textLabel.text = model.text;
    cell.detailTextLabel.text = model.detailedText;
    switch (indexPath.row) {
        case 0: {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 1:
        case 2: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        default:
            break;
    }
    return cell;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1: [self wy_pushToVC:WYVCTypeMeMineNickname sender:WY_USER_NICK]; break;
        case 2: [self wy_pushToVC:WYVCTypeMeChangePassword sender:WY_USER_ACCOUNT]; break;
        default:
            break;
    }
}

@end
