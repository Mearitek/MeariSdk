//
//  WYBaseSearchVC.m
//  Meari
//
//  Created by 李兵 on 2016/11/18.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYBaseSubSearchVC.h"
#import "WYProgressPageView.h"

const CGFloat WYCamearaSearchTotalTime = 90.0f;

@interface WYBaseSubSearchVC ()
{
    NSInteger _currentTime;
    BOOL _labelEnabled;
}
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIView *labelView;
@property (nonatomic, weak) UIButton *topBtn;
@property (nonatomic, weak) UIButton *bottomBtn;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) WYProgressPageView *pageView;

@property (nonatomic, weak) WYProgressCircleView *juhuaBarItem;
@property (nonatomic, strong)UIBarButtonItem *juhuaItem;
@property (nonatomic, strong)UIBarButtonItem *redoItem;
@property(nonatomic, strong)NSTimer *searchTimer;       

@end

@implementation WYBaseSubSearchVC
#pragma mark - Private
#pragma mark -- Getter
- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        _bottomView = view;
    }
    return _bottomView;
}
- (UIView *)labelView {
    if (!_labelView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.bottomView addSubview:view];
        [view addLineViewAtBottom];
        self.lineView = view.subviews.lastObject;
        _labelView = view;
    }
    return _labelView;
}
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:nil
                                       textColor:WY_FontColor_Gray
                                        textfont:WYFont_Text_XS_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByWordWrapping
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:YES];
        [self.labelView addSubview:label];
        _label = label;
    }
    return _label;
}
- (UIButton *)topBtn {
    if (!_topBtn) {
        UIButton *topBtn = [UIButton defaultGreenBounderButtonWithTarget:self action:@selector(topAction:)];
        topBtn.layer.cornerRadius = 20;
        topBtn.layer.masksToBounds = YES;
        [self.bottomView addSubview:topBtn];
        _topBtn = topBtn;
    }
    return _topBtn;
}
- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        UIButton *bottomBtn = [UIButton defaultGreenBounderButtonWithTarget:self action:@selector(bottomAction:)];
        bottomBtn.layer.cornerRadius = 20;
        bottomBtn.layer.masksToBounds = YES;
        [self.bottomView addSubview:bottomBtn];
        _bottomBtn = bottomBtn;
    }
    return _bottomBtn;
}
- (UIBarButtonItem *)juhuaItem {
    if (!_juhuaItem) {
        _juhuaItem = [UIBarButtonItem juhuaViewItem];
    }
    return _juhuaItem;
}
- (UIBarButtonItem *)redoItem {
    if (!_redoItem) {
        _redoItem = [UIBarButtonItem redoTextItemWithTarget:self action:@selector(redoAction:)];
    }
    return _redoItem;
}
- (WYProgressCircleView *)juhuaBarItem {
    if (!_juhuaBarItem) {
        self.juhuaBarItem = self.juhuaItem.customView;
        self.juhuaBarItem.textFont = WYFont_Text_XS_Normal;
        self.juhuaBarItem.textColor = WY_FontColor_Cyan;
        self.juhuaBarItem.backgroundCircleColor = WY_FontColor_Cyan;
        self.juhuaBarItem.progressCircleColor = WY_BGColor_LightGray3;
    }
    return _juhuaBarItem;
}

#pragma mark -- Init
- (void)_initSet {
    self.showNavigationLine = YES;
    self.navigationItem.rightBarButtonItem = self.juhuaItem;
}
- (void)_initLayout {
    WY_WeakSelf
    UITableView *tableV = [UITableView new];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableV];
    self.tableView = tableV;
    self.tableView.mj_header = [WYRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf startSearch];
    }];
    self.tableView.tableFooterView = [WYProgressPageView pageView];
    self.pageView = (WYProgressPageView *)self.tableView.tableFooterView;
    
    [self _reLayout];
}
- (void)_initKVO {
    self.dataSource= [NSMutableArray array];
    [self wy_addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -- KVO
- (void)insertObject:(id)object inDataSourceAtIndex:(NSUInteger)index {
    [self.dataSource insertObject:object atIndex:index];
}
- (void)removeObjectFromDataSourceAtIndex:(NSUInteger)index {
    [self.dataSource removeObjectAtIndex:index];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -- Timer
- (NSTimer *)searchTimer {
    if (!_searchTimer) {
        _searchTimer = [NSTimer timerInLoopWithInterval:1 target:self selector:@selector(timerToSearch:)];
    }
    return _searchTimer;
}
- (void)enableSearchTimer:(BOOL)enabled {
    if (enabled) {
        if (!_searchTimer) {
            self.stopedByOvertime = NO;
            _currentTime = 0;
            [self.pageView show];
            self.navigationItem.rightBarButtonItem = self.juhuaItem;
            [self.searchTimer fire];
        }
    }else {
        if (_searchTimer) {
            self.stopedByOvertime = _currentTime >= WYCamearaSearchTotalTime;
            _currentTime = 0;
            [self.pageView hide];
            self.navigationItem.rightBarButtonItem = self.redoItem;
            [_searchTimer invalidate];
            _searchTimer = nil;
        }
    }
}
- (void)timerToSearch:(id)sender {
    _currentTime++;
    self.juhuaBarItem.progress = _currentTime/WYCamearaSearchTotalTime;
    self.juhuaBarItem.text = @(WYCamearaSearchTotalTime-_currentTime).stringValue;
    if (_currentTime >= WYCamearaSearchTotalTime) {
        [self stopSearch];
    }
}


#pragma mark -- Utilities
- (void)_reLayout {
    CGFloat labelTop = 20, labelBottom = 20, topBtnTop = 20, bottomBtnTop = 10, bottomBtnBottom = 25;
    CGFloat labelH = [self.label ajustedHeightWithWidth:WY_ScreenWidth*0.7];
    CGFloat topBtnH = 40, bottomBtnH = 40;
    if (_labelEnabled) {
        labelBottom = 0;
    }
    CGFloat labelViewH = labelH+labelTop+labelBottom;
    if (self.hideTopLabel) {
        labelViewH = 0;
    }
    if (self.hideTopBtn) {
        topBtnH = 0;
        topBtnTop = 0;
        bottomBtnTop = _labelEnabled ? 5 : 20;
    }
    if (self.hideBottomBtn) {
        bottomBtnH = 0;
        bottomBtnTop = 0;
    }
    CGFloat bottomViewH = labelViewH + topBtnTop + topBtnH + bottomBtnTop + bottomBtnH + bottomBtnBottom;
    if (self.hideBottomView) {
        bottomViewH = 0;
    }
    WY_WeakSelf
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf.view);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(WY_SAFE_BOTTOM_LAYOUT);
        make.top.equalTo(weakSelf.tableView.mas_bottom);
        make.height.equalTo(@(bottomViewH));
    }];
    [self.labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(weakSelf.bottomView);
        make.height.equalTo(@(labelViewH));
    }];
    [self.topBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(topBtnH).priority(751);
        make.height.lessThanOrEqualTo(weakSelf.bottomView);
        make.width.mas_equalTo(weakSelf.bottomView).multipliedBy(0.6);
        make.centerX.equalTo(weakSelf.bottomView);
        make.top.equalTo(weakSelf.labelView.mas_bottom).with.offset(topBtnTop);
    }];
    [self.bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomBtnH).priority(751);
        make.height.lessThanOrEqualTo(weakSelf.bottomView);
        make.width.mas_equalTo(weakSelf.bottomView).multipliedBy(0.6);
        make.centerX.equalTo(weakSelf.bottomView);
        make.top.equalTo(weakSelf.topBtn.mas_bottom).with.offset(bottomBtnTop).priority(752);
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.labelView);
        make.width.equalTo(weakSelf.bottomView.mas_width).multipliedBy(0.7);
        make.height.equalTo(@(labelViewH)).priorityHigh(751);
        make.height.lessThanOrEqualTo(weakSelf.labelView);
    }];
}

#pragma mark -- Life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initSet];
    [self _initLayout];
    [self _initKVO];
}
- (void)deallocAction {
    
    [self wy_removeObserver:self forKeyPath:@"dataSource"];
}

#pragma mark -- Action
- (void)topAction:(UIButton *)sender {
    [self clickTopBtn:sender];
}
- (void)bottomAction:(UIButton *)sender {
    [self clickBottomBtn:sender];
}
- (void)redoAction:(UIButton *)sender {
    [self startSearch];
}
- (void)labelAction:(UITapGestureRecognizer *)sender {
    [self clickLabel];
}

#pragma mark - Delegate
#pragma mark - Public
- (void)setHideTopLabel:(BOOL)hideTopLabel {
    _hideTopLabel = hideTopLabel;
    [self _reLayout];
}
- (void)setHideTopBtn:(BOOL)hideTopBtn {
    _hideTopBtn = hideTopBtn;
    [self _reLayout];
}
- (void)setHideBottomBtn:(BOOL)hideBottomBtn {
    _hideBottomBtn = hideBottomBtn;
    [self _reLayout];
}
- (void)setHideBottomView:(BOOL)hideBottomView {
    _hideBottomView = hideBottomView;
    [self _reLayout];
}

- (void)setLabelText:(NSString *)text {
    self.label.text = text;
    [self _reLayout];
}
- (void)setLabelEnabled:(BOOL)enabled {
    _labelEnabled = enabled;
    self.lineView.hidden = _labelEnabled;
    if (enabled) {
        self.label.textColor = WY_FontColor_Cyan;
        [self.label addTapGestureTarget:self action:@selector(labelAction:)];
        [self _reLayout];
    }else {
        self.label.textColor = WY_FontColor_Gray;
        for (UIGestureRecognizer *g in self.label.gestureRecognizers) {
            [self.label removeGestureRecognizer:g];
        }
    }
}
- (void)setTopBtnTitle:(NSString *)title {
    [self.topBtn setTitle:title forState:UIControlStateNormal];
}
- (void)setBottomBtnTitle:(NSString *)title filled:(BOOL)filled {
    [self.bottomBtn setTitle:title forState:UIControlStateNormal];
    if (filled) {
        [self.bottomBtn setBackgroundImage:[UIImage bgGreenImage] forState:UIControlStateNormal];
        [self.bottomBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
        [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)clickTopBtn:(UIButton *)sender {
    
}
- (void)clickBottomBtn:(UIButton *)sender {
    
}
- (void)clickLabel {
    
}

- (void)startSearch {
    [self enableSearchTimer:YES];
}
- (void)stopSearch {
    [self.pageView hide];
    [self enableSearchTimer:NO];
    [self.juhuaBarItem dismiss];
    self.navigationItem.rightBarButtonItem = self.redoItem;
    [self.tableView reloadData];
}

@end
