//
//  WYMsgVC.m
//  HYRtspSDK
//
//  Created by Strong on 15/8/19.
//  Copyright (c) 2015年 PPStrong. All rights reserved.
//

#import "WYMsgVC.h"
#import "WYMsgAlarmVC.h"
#import "WYMsgSystemVC.h"
#import "WYMsgAlarmDetailVC.h"

const CGFloat WYMsgTopViewBtnHeight = 34.0f;

@interface WYMsgVC ()<WYEditManagerDelegate,UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIView *scrollContainerView;
@property (nonatomic, weak)UIButton *sysBtn;
@property (nonatomic, weak)UIButton *alarmBtn;
@property (nonatomic, weak)UIView *topView;
@property (nonatomic, weak)UIViewController <WYEditManagerDelegate> *currentVC;
@property (nonatomic, weak)UIViewController <WYEditManagerDelegate> *alarmVC;
@property (nonatomic, weak)UIViewController <WYEditManagerDelegate> *sysVC;

@property (nonatomic, strong)MASConstraint *topViewHeight;

@end


@implementation WYMsgVC
@synthesize msgType = _msgType;
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)topView {
    if (!_topView) {
        UIView *topView = [UIView new];
        [self.view addSubview:topView];
        _topView = topView;
    }
    return _topView;
}
- (UIButton *)alarmBtn {
    if (!_alarmBtn) {
        UIButton *alarmBtn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(alarmAction:)];
        alarmBtn.layer.cornerRadius = WYMsgTopViewBtnHeight/2;
        alarmBtn.layer.masksToBounds = YES;
        alarmBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [alarmBtn setTitle:WYLocalString(@"ALARM MESSAGES") forState:UIControlStateNormal];
        [self.topView addSubview:alarmBtn];
        _alarmBtn = alarmBtn;
    }
    return _alarmBtn;
}
- (UIButton *)sysBtn {
    if (!_sysBtn) {
        UIButton *sysBtn = [UIButton defaultGreenFillButtonWithTarget:self action:@selector(systemAction:)];
        sysBtn.layer.cornerRadius = WYMsgTopViewBtnHeight/2;
        sysBtn.layer.masksToBounds = YES;
        sysBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [sysBtn setTitle:WYLocalString(@"SYSTEM MESSAGES") forState:UIControlStateNormal];
        [self.topView addSubview:sysBtn];
        _sysBtn = sysBtn;
    }
    return _sysBtn;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollV = [UIScrollView new];
        scrollV.pagingEnabled = YES;
        scrollV.bounces = NO;
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        scrollV.delegate = self;
        scrollV.contentSize = CGSizeMake(2*WY_ScreenWidth, 0);
        [self.view addSubview:scrollV];
        _scrollView = scrollV;
    }
    return _scrollView;
}
- (UIView *)scrollContainerView {
    if (!_scrollContainerView) {
        UIView *v = [UIView new];
        [self.scrollView addSubview:v];
        _scrollContainerView = v;
    }
    return _scrollContainerView;
}

#pragma mark -- Init
- (void)initSet {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    self.navigationItem.title = WYLocalString(@"MESSAGE");

}
- (void)initLayout {
    WY_WeakSelf
    [self.alarmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.topView).with.offset(12);
        make.centerY.equalTo(weakSelf.topView);
        make.height.equalTo(@(WYMsgTopViewBtnHeight));
    }];
    [self.sysBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(weakSelf.alarmBtn);
        make.leading.equalTo(weakSelf.alarmBtn.mas_trailing).with.offset(20);
        make.trailing.equalTo(weakSelf.topView).with.offset(-12);
        make.centerY.equalTo(weakSelf.topView);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf.view);
        weakSelf.topViewHeight = make.height.equalTo(@52);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.topView.mas_bottom);
    }];
    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        make.height.equalTo(weakSelf.scrollView);
        make.width.equalTo(@(2*WY_ScreenWidth));
    }];
    
    WYMsgSystemVC *sysVC = [[WYMsgSystemVC alloc] init];
    WYMsgAlarmVC *alarmVC = [[WYMsgAlarmVC alloc] init];
    [self addChildViewController:sysVC];
    [self addChildViewController:alarmVC];
    self.sysVC = sysVC;
    self.alarmVC = alarmVC;
    alarmVC.didSelectCellBlock = ^(NSString *deviceName, NSInteger deviceID) {
        WYMsgAlarmDetailVC *alarmVC = [[WYMsgAlarmDetailVC alloc] initWithDeviceName:deviceName deviceID:deviceID];
        [weakSelf.navigationController pushViewController:alarmVC animated:YES];
    };
}


#pragma mark -- Utilities
- (void)setButton:(UIButton *)btn selected:(BOOL)selected {
    [btn setBackgroundImage:[UIImage imageNamed: selected ? @"bg_green" : @"bg_gray"]
                   forState:UIControlStateNormal];
    [btn setTitleColor:selected ? [UIColor whiteColor] : [UIColor whiteColor]
              forState:UIControlStateNormal];
}

#pragma mark -- Life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WY_EditM setDelegate:self editStystle:WYEditStytleDeleteDelete];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSet];
    [self initLayout];
    self.msgType = self.msgTypeFromPush == WYMsgTypeSystem ? WYMsgTypeSystem : WYMsgTypeAlarm;
}


#pragma mark -- Action
- (void)alarmAction:(UIButton *)sender {
    self.msgType = WYMsgTypeAlarm;
    
}
- (void)systemAction:(UIButton *)sender {
    self.msgType = WYMsgTypeSystem;
}


#pragma mark - Delegate
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffsetX == WY_ScreenWidth) {
        self.msgType = WYMsgTypeSystem;
    }else {
        self.msgType = WYMsgTypeAlarm;
    }
}

#pragma mark - WYEditManagerDelegate
- (BOOL)canEdit {
    return [self.currentVC canEdit];
}
- (void)editEdit {
    self.topViewHeight.equalTo(@0);
    self.scrollView.scrollEnabled = NO;
    [self.currentVC editEdit];
}
- (void)editCancel {
    self.topViewHeight.equalTo(@52);
    self.scrollView.scrollEnabled = YES;
    [self.currentVC editCancel];
}
- (void)editDelete {
    [self.currentVC editDelete];
}
- (void)editMark {
    [self.currentVC editMark];
}
- (UIViewController<WYEditManagerDelegate> *)currentVC {
    switch (self.msgType) {
        case WYMsgTypeAlarm:{
            return self.alarmVC;
        }
        case WYMsgTypeSystem:{
            return self.sysVC;
        }
        default:
            return nil;
    }
}

#pragma mark - Public
- (void)networkRequestFromPush {
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc respondsToSelector:@selector(networkRequestFromPush)]) {
            [vc performSelector:@selector(networkRequestFromPush)];
        }
    }
}
- (void)setMsgType:(WYMsgType)msgType {
    if (_msgType == msgType) return;
    _msgType = msgType;
    switch (_msgType) {
        case WYMsgTypeAlarm: {
            [self setButton:self.sysBtn selected:NO];
            [self setButton:self.alarmBtn selected:YES];
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            if (!self.alarmVC.view.superview) {
                [self.scrollContainerView addSubview:self.alarmVC.view];
                WY_WeakSelf
                [self.alarmVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.leading.equalTo(weakSelf.scrollContainerView);
                    make.width.equalTo(weakSelf.scrollContainerView).multipliedBy(0.5);
                }];
            }
            break;
        }
        case WYMsgTypeSystem: {
            [self setButton:self.sysBtn selected:YES];
            [self setButton:self.alarmBtn selected:NO];
            if (!self.sysVC.view.superview) {
                [self.scrollContainerView addSubview:self.sysVC.view];
                WY_WeakSelf
                [self.sysVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.trailing.equalTo(weakSelf.scrollContainerView);
                    make.width.equalTo(weakSelf.scrollContainerView).multipliedBy(0.5);
                }];
            }
            [self.scrollView setContentOffset:CGPointMake(WY_ScreenWidth, 0) animated:YES];
            break;
        }
        default:
            break;
    }
}

@end

