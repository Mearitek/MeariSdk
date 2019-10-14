//
//  WYCameraToolPlaybackAlarmMessageView.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraToolPlaybackAlarmMessageView.h"

@interface WYCameraToolPlaybackAlarmMessageView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL _canHighlighted;
    BOOL _babyMonitor;
}
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSTimer *delayTimer;
@end
@implementation WYCameraToolPlaybackAlarmMessageView
#pragma mark - Private
#pragma mark -- Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text: WYLocalString(@"Alert Message")
                                       textColor:WY_FontColor_Gray
                                        textfont:WYFont_Text_S_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByTruncatingTail
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:NO];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionV.backgroundColor = [UIColor clearColor];
        collectionV.delegate = self;
        collectionV.dataSource = self;
        collectionV.bounces = NO;
        collectionV.showsHorizontalScrollIndicator = NO;
        collectionV.showsVerticalScrollIndicator   = NO;
        
        [collectionV registerClass:[WYCameraToolPlaybackAlarmMessageCell class] forCellWithReuseIdentifier:WY_ClassName(WYCameraToolPlaybackAlarmMessageCell)];
        [self addSubview:collectionV];
        _collectionView = collectionV;
    }
    return _collectionView;
}
- (NSTimer *)delayTimer {
    if (!_delayTimer) {
        _delayTimer = [NSTimer timerOnceWithInterval:5 target:self selector:@selector(timerToDelay:)];
    }
    return _delayTimer;
}

#pragma mark -- Init
- (void)initLayout {
    WY_WeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(WY_iPhone_4 ? 0 : 30)).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.top.leading.and.trailing.equalTo(weakSelf);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.leading.trailing.equalTo(weakSelf);
    }];
}

#pragma mark -- Life
- (void)initAction {
    _canHighlighted = YES;
    _babyMonitor = WY_CameraM.babyMonitor;
    [self initLayout];
    [self resetToNormal];
}

#pragma mark -- NSTimer
- (void)timerToDelay:(NSTimer *)sender {
    _canHighlighted = YES;
    [self enabledDelayTimer:NO];
}

#pragma mark -- Utilities
- (void)enabledDelayTimer:(BOOL)enabled {
    if (enabled) {
        if (!_delayTimer) {
            [self delayTimer];
        }
    }else {
        if (_delayTimer) {
            [_delayTimer invalidate];
            _delayTimer = nil;
        }
    }
}
- (void)showCellAtIndexPath:(NSIndexPath *)indexPath {
    BOOL visible = NO;
    for (NSIndexPath *indexP in self.collectionView.indexPathsForVisibleItems) {
        if (indexPath.row == indexP.row) {
            visible = YES;
            break;
        }
    }
    
    if (visible) {
        WYCameraToolPlaybackAlarmMessageCell *cell = (WYCameraToolPlaybackAlarmMessageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        CGRect rec1 = [self.collectionView convertRect:self.collectionView.bounds toView:self];
        CGRect rec2 = [cell convertRect:cell.bounds toView:self];
        int diffRight = CGRectGetMaxX(rec1) - CGRectGetMaxX(rec2);
        if (diffRight < 0) {
            CGPoint p = self.collectionView.contentOffset;
            p.x += ABS(diffRight);
            [self.collectionView setContentOffset:p animated:YES];
        }
        int diffLeft = rec2.origin.x - rec1.origin.x;
        if (diffLeft < 0) {
            CGPoint p = self.collectionView.contentOffset;
            p.x -= ABS(diffLeft);
            [self.collectionView setContentOffset:p animated:YES];
        }
    }else {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark -- Action
#pragma mark - Delegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraToolPlaybackAlarmMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WY_ClassName(WYCameraToolPlaybackAlarmMessageCell) forIndexPath:indexPath];
    WYCameraToolPlaybackAlarmMessageModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 45);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _canHighlighted = NO;
    WYCameraToolPlaybackAlarmMessageModel *model = self.dataSource[indexPath.row];
    for (WYCameraToolPlaybackAlarmMessageModel *model in self.dataSource) {
        model.selected = NO;
    }
    model.selected = YES;
    [collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(WYCameraToolPlaybackAlarmMessageView:didSelectedSecond:)]) {
        [self.delegate WYCameraToolPlaybackAlarmMessageView:self didSelectedSecond:model.time.alarmSecond];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _canHighlighted = YES;
    });
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _canHighlighted = NO;
    [self enabledDelayTimer:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self enabledDelayTimer:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self enabledDelayTimer:YES];
}

#pragma mark - Public
- (void)setAlarmTimes:(NSArray<WYCameraTime *> *)alarmTimes {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (WYCameraTime *time in alarmTimes) {
        WYCameraToolPlaybackAlarmMessageModel *model  = [WYCameraToolPlaybackAlarmMessageModel new];
        model.time = time;
        model.selected = NO;
        model.visitor = NO;
        model.babyMonitor = _babyMonitor;
        [tempArr addObject:model];
    }
    if (self.dataSource && tempArr.count) {
        [self.dataSource addObjectsFromArray:tempArr];
    } else {
        self.dataSource = tempArr.mutableCopy;
    }
    self.hidden = self.dataSource.count == 0;


    [self.collectionView reloadData];
}
- (void)setVisitorTimes:(NSArray<WYCameraTime *> *)visitorTimes {
    for (WYCameraTime *time in visitorTimes) {
        WYCameraToolPlaybackAlarmMessageModel *model  = [WYCameraToolPlaybackAlarmMessageModel new];
        model.time = time;
        model.selected = NO;
        model.babyMonitor = NO;
        model.visitor = YES;
        [self.dataSource addObject:model];
    }
    
    NSArray *array = [self.dataSource sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       WYCameraToolPlaybackAlarmMessageModel *model1 = (WYCameraToolPlaybackAlarmMessageModel *)obj1;
       WYCameraToolPlaybackAlarmMessageModel *model2 = (WYCameraToolPlaybackAlarmMessageModel *)obj2;
        //给对象排序
        NSComparisonResult result = [[NSNumber numberWithFloat:model1.time.alarmSecond] compare:  [NSNumber numberWithFloat:model2.time.alarmSecond]];
        return result;
    }];
    self.dataSource = array.mutableCopy;
    self.hidden = self.dataSource.count == 0;
    [self.collectionView reloadData];
}

- (void)resetToNormal {
    self.alarmTimes = nil;
    _canHighlighted = YES;
    [self enabledDelayTimer:NO];
}
- (void)highlightAlarmMsgAtSecond:(int)second {
    if (!_canHighlighted) return;
    
    for (WYCameraToolPlaybackAlarmMessageModel *model in self.dataSource) {
        model.selected = NO;
    }
    for (WYCameraToolPlaybackAlarmMessageModel *model in self.dataSource) {
        if (ABS(model.time.alarmSecond - second) <= 5) {
            model.selected = YES;
            NSInteger row = [self.dataSource indexOfObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self showCellAtIndexPath:indexPath];
            break;
        }else if(model.time.alarmSecond > second) {
            model.selected = YES;
            NSInteger row = [self.dataSource indexOfObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self showCellAtIndexPath:indexPath];
            break;
        }
    }
    [self.collectionView reloadData];
    
}
- (void)setAlarmMsgCanHighlighted:(BOOL)canHighlighted {
    _canHighlighted = YES;
    [self enabledDelayTimer:NO];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end

#pragma mark -
@interface WYCameraToolPlaybackAlarmMessageCell ()
@property (nonatomic, weak)UIButton *btn;
@end
@implementation WYCameraToolPlaybackAlarmMessageCell
- (UIButton *)btn {
    if (!_btn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        btn.titleLabel.font = WYFont_Text_XXS_Bold;
        [btn setImage:[UIImage imageNamed:@"btn_camera_alert_play_normal"]
             forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_camera_alert_play_highlighted"]
             forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"btn_camera_alert_play_highlighted"]
             forState:UIControlStateSelected];
        [btn setTitleColor:WY_FontColor_Gray forState:UIControlStateNormal];
        [btn setTitleColor:WY_FontColor_Red forState:UIControlStateHighlighted];
        [btn setTitleColor:WY_FontColor_Red forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [self.contentView addSubview:btn];
        WY_WeakSelf
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(10);
            make.trailing.top.bottom.equalTo(weakSelf.contentView);
        }];
        _btn = btn;
    }
    return _btn;
}
- (void)setModel:(WYCameraToolPlaybackAlarmMessageModel *)model {
    _model = model;
    
    UIImage *highlightedImage = model.babyMonitor ? [UIImage imageNamed:@"btn_baby_alert_play_highlighted"] : model.visitor ? [UIImage imageNamed:@"btn_doorBell_visitor_selected"] : [UIImage imageNamed:@"btn_camera_alert_play_highlighted"];
    UIImage *selectedImage = model.babyMonitor ? [UIImage imageNamed:@"btn_baby_alert_play_selected"] : model.visitor ? [UIImage imageNamed:@"btn_doorBell_visitor_selected"] : [UIImage imageNamed:@"btn_camera_alert_play_selected"];
    [self.btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [self.btn setImage:selectedImage forState:UIControlStateSelected];
    [self.btn setTitleColor:model.babyMonitor ? WY_FontColor_DarkOrange : model.visitor ? WY_FontColor_DarkYellow : WY_FontColor_Red forState:UIControlStateHighlighted];
    [self.btn setTitleColor:model.babyMonitor ? WY_FontColor_DarkOrange : model.visitor ? WY_FontColor_DarkYellow : WY_FontColor_Red forState:UIControlStateSelected];
    [self.btn setTitle:model.time.alarmString forState:UIControlStateNormal];
    self.btn.titleLabel.text = model.time.alarmString;
    self.btn.selected = model.selected;
}
@end

#pragma mark - 
@implementation WYCameraToolPlaybackAlarmMessageModel
@end
