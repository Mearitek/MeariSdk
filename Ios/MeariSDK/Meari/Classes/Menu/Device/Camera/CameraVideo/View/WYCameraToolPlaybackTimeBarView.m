//
//  WYCameraToolPlaybackTimeBarView.m
//  Meari
//
//  Created by 李兵 on 2016/11/29.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCameraToolPlaybackTimeBarView.h"
const CGFloat NormalRulerWidth        = 3234; //刻度尺长度
const CGFloat NormalRulerHeight       = 56;   //刻度尺高度
const CGFloat NormalRulerLeft_Margin  = 25;   //刻度0距左边距
const CGFloat NormalRulerRight_Margin = 35;   //刻度24距右边距

const CGFloat BigRulerWidth        = 1688; //刻度尺长度
const CGFloat BigRulerHeight       = 56;   //刻度尺高度
const CGFloat BigRulerLeft_Margin  = 33;   //刻度0距左边距
const CGFloat BigRulerRight_Margin = 0;    //刻度24距右边距
const CGFloat RealRulerHeight      = 28;   //真正的高度
const CGFloat RulerRadio           = (RealRulerHeight/NormalRulerHeight);

@interface WYCameraToolPlaybackTimeBarView ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    BOOL _canOffset;
    BOOL _userDrag;
}
@property (nonatomic, assign) WYCameraToolPlaybackTimeBarStytle stytle;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UICollectionView        *collectionView;
@property (nonatomic, weak) WYCameraToolPlaybackTimeBarBlueView *blueView;
@property (nonatomic, weak) WYCameraToolPlaybackTimeBarAlarmZoneView *alarmZoneView;
@property (nonatomic, weak) UIImageView *tickImageView;

@property (nonatomic, strong)NSTimer *delayTimer;

//数据源
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *normalDataSource;
@property (nonatomic, strong) NSArray *bigDataSource;

//计算
@property (nonatomic, assign) CGSize itemSize;         //cell大小
@property (nonatomic, assign) CGFloat maxOffsetX;

@property (nonatomic, assign) CGRect progressFrame;

@end

@implementation WYCameraToolPlaybackTimeBarView
#pragma mark - Private
#pragma mark -- Getter
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [UILabel labelWithFrame:CGRectZero
                                            text:nil
                                       textColor:WY_FontColor_Black
                                        textfont:WYFont_Text_S_Normal
                                   numberOfLines:0
                                   lineBreakMode:NSLineBreakByTruncatingTail
                                   lineAlignment:NSTextAlignmentCenter
                                       sizeToFit:YES];
        label.hidden = YES;
        [self addSubview:label];
        _timeLabel = label;
    }
    return _timeLabel;
}
- (UIView *)topView {
    if (!_topView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        _topView = view;
    }
    return _topView;
}
- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [UIImageView new];
        view.backgroundColor = WY_LineColor_LightGray;
        [self addSubview:view];
        _lineView = view;
    }
    return _lineView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionV.backgroundColor = [UIColor clearColor];
        collectionV.delegate = self;
        collectionV.dataSource = self;
        collectionV.bounces = NO;
        collectionV.showsHorizontalScrollIndicator = NO;
        collectionV.showsVerticalScrollIndicator   = NO;
        
        [collectionV registerClass:[WYCameraToolPlaybackTimeBarCell class] forCellWithReuseIdentifier:WY_ClassName(WYCameraToolPlaybackTimeBarCell)];
        [collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        [self addSubview:collectionV];
        self.collectionView = collectionV;
    }
    return _collectionView;
}
- (WYCameraToolPlaybackTimeBarBlueView *)blueView {
    if (!_blueView) {
        WYCameraToolPlaybackTimeBarBlueView *view = [WYCameraToolPlaybackTimeBarBlueView new];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = YES;
        [self.collectionView addSubview:view];
        _blueView = view;
    }
    return _blueView;
}
- (WYCameraToolPlaybackTimeBarAlarmZoneView *)alarmZoneView {
    if (!_alarmZoneView) {
        WYCameraToolPlaybackTimeBarAlarmZoneView *view = [WYCameraToolPlaybackTimeBarAlarmZoneView new];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = YES;
        [self.collectionView addSubview:view];
        _alarmZoneView = view;
    }
    return _alarmZoneView;
}

- (UIImageView *)tickImageView {
    if (!_tickImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"img_camera_timebar_centerLine"];
        [self.collectionView addSubview:view];
        _tickImageView = view;
    }
    return _tickImageView;
}
- (NSTimer *)delayTimer {
    if (!_delayTimer) {
        _delayTimer = [NSTimer timerOnceWithInterval:5 target:self selector:@selector(timerToDelay:)];
    }
    return _delayTimer;
}
- (NSArray *)normalDataSource {
    if (!_normalDataSource) {
        _normalDataSource = @[@"img_camera_timebar_ruler_normal"];
    }
    return _normalDataSource;
}
- (NSArray *)bigDataSource {
    if (!_bigDataSource) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:24];
        for (int i = 0; i < 24; i++) {
            NSString *imageName = [NSString stringWithFormat:@"img_camera_timebar_bigruler%02d", i];
            [arr addObject:imageName];
        }
        _bigDataSource = arr.copy;
    }
    return _bigDataSource;
}

#pragma mark -- Init
- (void)initSet {
    [self addDoubleTapGestureTarget:self action:@selector(doubleTapAction:)];
    _canOffset = YES;
    _stytle = WYCameraToolPlaybackTimeBarStytleNormal;
    self.dataSource = self.normalDataSource;
}
- (void)initLayout {
    WY_WeakSelf
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.and.trailing.equalTo(weakSelf);
        make.height.equalTo(@20).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom);
        make.height.equalTo(@28).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.height.equalTo(@(WY_1_PIXEL)).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
        make.centerY.equalTo(weakSelf.topView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLabel.mas_bottom);
        make.leading.and.trailing.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).with.offset(WY_iPhone_4 ? -5: -10).priorityHigh();
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView).with.offset(4);
        make.height.equalTo(@20);
        make.leading.equalTo(weakSelf.collectionView.mas_centerX);
        make.width.equalTo(@(weakSelf.itemSize.width*weakSelf.dataSource.count));
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [self.alarmZoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.blueView);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
//    [self.yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.blueView);
//        make.height.lessThanOrEqualTo(weakSelf);
//    }];
    [self.tickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.topView);
        make.centerX.equalTo(weakSelf);
        make.width.equalTo(@5);
        make.height.lessThanOrEqualTo(weakSelf);
    }];
}

#pragma mark -- Life
- (void)initAction {
    [self initSet];
    [self initLayout];
}
- (void)updateConstraints {
    WY_WeakSelf
    [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView).with.offset(4);
        make.height.equalTo(@20).priority(751);
        make.leading.equalTo(weakSelf.collectionView.mas_centerX);
        make.width.equalTo(@(weakSelf.itemSize.width*weakSelf.dataSource.count));
        make.height.lessThanOrEqualTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark -- Network
#pragma mark -- Notification
#pragma mark -- NSTimer
- (void)timerToDelay:(NSTimer *)sender {
    _canOffset = YES;
    [self enableDelayTimer:NO];
}

#pragma mark -- Utilities
- (void)enableDelayTimer:(BOOL)enabled {
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
- (CGSize)itemSize {
    CGSize size = CGSizeZero;
    switch (self.stytle) {
        case WYCameraToolPlaybackTimeBarStytleNormal:
            size = CGSizeMake((NormalRulerWidth - NormalRulerLeft_Margin - NormalRulerRight_Margin)*RulerRadio, self.collectionView.height);
            break;
        case WYCameraToolPlaybackTimeBarStytleBig:
            size = CGSizeMake((BigRulerWidth - BigRulerLeft_Margin - BigRulerRight_Margin)*RulerRadio, self.collectionView.height);
            break;
        default:
            break;
    }
    return size;
}
- (CGFloat)maxOffsetX {
    switch (self.stytle) {
        case WYCameraToolPlaybackTimeBarStytleNormal: {
            return self.itemSize.width;
        }
        case WYCameraToolPlaybackTimeBarStytleBig: {
            return self.itemSize.width*24;
        }
    }
    return 0;
}
- (void)showTimeLabel {
    if (self.timeLabel.hidden) {
        self.timeLabel.hidden = NO;
        self.timeLabel.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.timeLabel.alpha = 1;
        } completion:nil];
    }
}
- (void)dismissTimeLabel {
    if (!self.timeLabel.hidden) {
        self.timeLabel.hidden = NO;
        self.timeLabel.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            self.timeLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.timeLabel.hidden = YES;
        }];
    }
}
- (void)autoShowAndDismissTimeLabel {
    if (self.timeLabel.hidden) {
        self.timeLabel.hidden = NO;
        self.timeLabel.alpha = 0;
        [UIView animateWithDuration:0 animations:^{
            self.timeLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.timeLabel.alpha = 0;
            } completion:^(BOOL finished) {
                self.timeLabel.hidden = YES;
            }];
        }];
    }else {
        self.timeLabel.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.timeLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.timeLabel.hidden = YES;
        }];
    }
}
- (void)autoShowAndDismissTimeLabelWithSecond:(int)second {
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", second/3600, second/60%60, second%60];
    [self autoShowAndDismissTimeLabel];
}
- (int)totalVideoSecondsBeforeSecond:(int)second {
    if (second <= 0) {
        return 0;
    }
    int total = 0;
    for (WYCameraTime *time in self.videoTimes) {
        if (time.endSecond <= second) {
            total += time.duration;
        }else if (time.startSecond <= second) {
            total += second - time.startSecond;
            break;
        }else {
            break;
        }
    }
    return total;
}
- (int)totalVideoSeconds {
    return [self totalVideoSecondsBeforeSecond:WYSecs_PerDay];
}
- (int)totalVideoSecondsAfterSecond:(int)second {
    int diff = [self totalVideoSeconds] - [self totalVideoSecondsBeforeSecond:second];
    return diff > 5;
}

#pragma mark -- Action
- (void)doubleTapAction:(UITapGestureRecognizer *)sender {
    switch (self.stytle) {
        case WYCameraToolPlaybackTimeBarStytleNormal: {
            self.stytle = WYCameraToolPlaybackTimeBarStytleBig;
            break;
        }
        case WYCameraToolPlaybackTimeBarStytleBig: {
            self.stytle = WYCameraToolPlaybackTimeBarStytleNormal;
            break;
        }
    }
    [self enableDelayTimer:YES];
}

#pragma mark - Delegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraToolPlaybackTimeBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WY_ClassName(WYCameraToolPlaybackTimeBarCell) forIndexPath:indexPath];
    NSString *imageName = self.dataSource[indexPath.row];
    cell.imageName = imageName;
    cell.stytle = self.stytle;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = [kind isEqualToString:UICollectionElementKindSectionHeader] ? @"header" : @"footer";
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifer forIndexPath:indexPath];
    return view;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.itemSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(collectionView.width/2, collectionView.height);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(collectionView.width/2, collectionView.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _userDrag = YES;
    _canOffset = NO;
    [self enableDelayTimer:NO];
    [self.alarmView setAlarmMsgCanHighlighted:YES];
    if ([self.delegate respondsToSelector:@selector(beginToDragTimeBar:)]) {
        [self.delegate beginToDragTimeBar:self];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int second = scrollView.contentOffsetX/self.maxOffsetX*WYSecs_PerDay;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", second/3600, second/60%60, second%60];
    if (_userDrag) {
        [self showTimeLabel];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        _userDrag = NO;
        [self dismissTimeLabel];
        int second = scrollView.contentOffsetX/self.maxOffsetX*WYSecs_PerDay;
        BOOL canPlay = [self hasVideoAtSecond:second];
        if ([self.delegate respondsToSelector:@selector(endDraggingTimeBar:toSecond:canPlay:)]) {
            [self.delegate endDraggingTimeBar:self toSecond:second canPlay:canPlay];
        }
        if (!canPlay) {
            _canOffset = NO;
            [self enableDelayTimer:YES];
        }else {
            _canOffset = YES;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _userDrag = NO;
    [self dismissTimeLabel];
    int second = scrollView.contentOffsetX/self.maxOffsetX*WYSecs_PerDay;
    BOOL canPlay = [self hasVideoAtSecond:second];
    if ([self.delegate respondsToSelector:@selector(endDraggingTimeBar:toSecond:canPlay:)]) {
        [self.delegate endDraggingTimeBar:self toSecond:second canPlay:canPlay];
    }
    if (!canPlay) {
        _canOffset = NO;
        [self enableDelayTimer:YES];
    }else {
        _canOffset = YES;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark - Public
- (void)setStytle:(WYCameraToolPlaybackTimeBarStytle)stytle {
    if (_stytle == stytle) return;
    _canOffset = YES;
    CGFloat progress = self.progress;
    _stytle = stytle;
    switch (self.stytle) {
        case WYCameraToolPlaybackTimeBarStytleNormal: {
            self.dataSource = self.normalDataSource;
            [self.collectionView reloadData];
            break;
        }
        case WYCameraToolPlaybackTimeBarStytleBig: {
            self.dataSource = self.bigDataSource;
            [self.collectionView reloadData];
            break;
        }
    }
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    [self.blueView setNeedsDisplay];
    [self.alarmZoneView setNeedsDisplay];
    self.progress = progress;
}
- (CGFloat)progress {
    return self.collectionView.contentOffsetX/self.maxOffsetX;
}
- (void)setProgress:(CGFloat)progress {
    progress = progress < 0 ? 0 : (progress > 1 ? 1 : progress);
    
    if (_canOffset) {
        self.collectionView.contentOffsetX = progress*self.maxOffsetX;
    }
    int seconds = progress*WYSecs_PerDay;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", seconds/3600, seconds/60%60, seconds%60];
    if (!self.timeLabel.hidden) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissTimeLabel];
        });
    }
}
- (NSArray<WYCameraTime *> *)videoTimes {
    return self.blueView.videoTimes;
}
- (NSArray<WYCameraTime *> *)alarmTimes {
    return self.alarmZoneView.alarmTimes;
}
- (void)setVideoTimes:(NSArray<WYCameraTime *> *)videoTimes {
    self.alarmZoneView.videoTimes = videoTimes;
    self.blueView.videoTimes = videoTimes;
}
- (void)setAlarmTimes:(NSArray<WYCameraTime *> *)alarmTimes {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:alarmTimes.count];
    for (WYCameraTime *alarmTime in alarmTimes) {
        for (WYCameraTime *videoTime in self.videoTimes) {
            if (alarmTime.alarmSecond >= videoTime.startSecond && alarmTime.alarmSecond <= videoTime.endSecond) {
                [arr addObject:alarmTime];
            }
        }
    }
    self.alarmView.alarmTimes = arr;
    self.alarmZoneView.alarmTimes = arr;
}
- (void)setVisitorTimes:(NSArray<WYCameraTime *> *)visitorTimes {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:visitorTimes.count];
    for (WYCameraTime *alarmTime in visitorTimes) {
        for (WYCameraTime *videoTime in self.videoTimes) {
            if (alarmTime.alarmSecond >= videoTime.startSecond && alarmTime.alarmSecond <= videoTime.endSecond) {
                [arr addObject:alarmTime];
            }
        }
    }
    self.alarmZoneView.visitorTimes = arr;
    self.alarmView.visitorTimes = arr;
}

- (BOOL)hasVideoAtSecond:(int)second {
    BOOL hasVideo = NO;
    for (WYCameraTime *time in self.videoTimes) {
        if (second >= time.startSecond && second <= time.endSecond) {
            hasVideo = YES;
            break;
        }
    }
    return hasVideo;
}
- (NSDateComponents *)latestVideoTimeNearTime:(NSDateComponents *)videoTime {
    NSDateComponents *tmpVideoTime = videoTime.copy;
    int seconds = videoTime.secondsInday;
    for (WYCameraTime *time in self.videoTimes) {
        if (seconds < time.startSecond) {
            [tmpVideoTime setTimeWithSecond:time.startSecond];
            break;
        }else if (seconds > time.endSecond && time == self.videoTimes.lastObject) {
            [tmpVideoTime setTimeWithSecond:time.endSecond-3];
            break;
        }else {
            break;
        }
    }
    return tmpVideoTime;
}
- (NSDateComponents *)startTimeInHalfHourFragment:(NSString *)halfHourFragmentString {
    
    NSDateComponents *d1 = [NSDateComponents startDateComponentsWithFormatedHourFragmentStringNoSprit:halfHourFragmentString];
    NSDateComponents *d2 = [NSDateComponents endDateComponentsWithFormatedHourFragmentStringNoSprit:halfHourFragmentString];
    if (!d1 || !d2) return nil;
    
    int x1 = d1.secondsInday;
    int x2 = d2.secondsInday;
    for (WYCameraTime *time in self.videoTimes) {
        int t1 = (int)time.startSecond;
        int t2 = (int)time.endSecond;
        
        //2种情况
        if (t1 < x1 && t2 > x1) {
            return d1;
        }else if(t1 < x2 && t2 > x2) {
            return [NSDateComponents dateComponnentsWithSeconds:t1];
        }
        
    }
    return nil;
}
- (BOOL)hasNewVideoAfterTime:(NSDateComponents *)videoTime {
    return [self totalVideoSecondsAfterSecond:videoTime.secondsInday];
}
- (void)resetToNormal {
    _userDrag = NO;
    self.blueView.videoTimes = nil;
    self.alarmZoneView.alarmTimes = nil;
    self.stytle = WYCameraToolPlaybackTimeBarStytleNormal;
}


@end

#pragma mark -
@interface WYCameraToolPlaybackTimeBarCell ()
@property (nonatomic, weak)UIImageView *timeImageView;
@end
@implementation WYCameraToolPlaybackTimeBarCell
- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        _timeImageView = view;
    }
    return _timeImageView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}
- (void)updateConstraints {
    CGFloat leftMargin, rightMargin;
    if (self.stytle == WYCameraToolPlaybackTimeBarStytleNormal) {
        leftMargin = RulerRadio*NormalRulerLeft_Margin;
        rightMargin = RulerRadio*NormalRulerRight_Margin;
    }else {
        leftMargin = RulerRadio*BigRulerLeft_Margin;
        rightMargin = RulerRadio*BigRulerRight_Margin;
    }
    WY_WeakSelf
    [self.timeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28).priority(751);
        make.height.lessThanOrEqualTo(weakSelf);
        make.bottom.equalTo(weakSelf.contentView);
        make.leading.equalTo(weakSelf.contentView).with.offset(-1*leftMargin);
        make.trailing.equalTo(weakSelf.contentView).with.offset(rightMargin);
    }];
    [super updateConstraints];
}
- (void)setImageName:(NSString *)imageName {
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFile];
    self.timeImageView.image = image;
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

@end

#pragma mark -
@implementation WYCameraToolPlaybackTimeBarBlueView
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    [super drawRect:rect];
    
    //画蓝条
    UIImage *image = self.timebarImage;
    for (WYCameraTime *time in _videoTimes) {
        CGFloat x = (time.startSecond/WYSecs_PerDay)*CGRectGetWidth(rect);
        CGFloat w = (time.duration/WYSecs_PerDay)*CGRectGetWidth(rect);
        CGRect r = CGRectMake(x, 0, w, CGRectGetHeight(rect));
        [image drawInRect:r];
    }
}
- (void)setVideoTimes:(NSArray<WYCameraTime *> *)videoTimes {
    _videoTimes = videoTimes;
    [self setNeedsDisplay];
}
- (void)initAction {
    self.timebarImage = WY_CameraM.babyMonitor ? [UIImage imageWithColor:WY_FontColor_DarkOrange] : [UIImage imageWithColor:WY_MainColor];
}
@end


#pragma mark -
@implementation WYCameraToolPlaybackTimeBarAlarmZoneView
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    [super drawRect:rect];
    
    //计算左右半圆的大小
    CGRect leftRec = CGRectZero, rightRec = CGRectZero;
    CGFloat side = rect.size.height/2;
    if (_videoTimes.count > 0) {
        WYCameraTime *firstTime = _videoTimes.firstObject;
        CGFloat l = firstTime.startSecond/WYSecs_PerDay*CGRectGetWidth(rect);
        CGFloat dot = l - (int)l;
        dot = (dot <= 0.67 ? 0 : 0.5);
        l = (int)l + dot;
        leftRec = CGRectMake(l, 0, side*2 , side*2);
        
        WYCameraTime *lastTime = _videoTimes.lastObject;
        CGFloat r = (lastTime.startSecond/WYSecs_PerDay)*CGRectGetWidth(rect) + (lastTime.duration/WYSecs_PerDay)*CGRectGetWidth(rect) + 0.5;
        CGFloat dot2 = r - (int)r;
        dot2 = (dot >= 0.33 ? 1.0 : 0.5);
        r= (int)r + dot2;
        rightRec = CGRectMake(r-side*2, 0, side*2, side*2);
    }
    
    //画红条
    UIImage *image = [UIImage imageWithColor:[UIColor redColor]];
    for (WYCameraTime *time in _alarmTimes) {
        CGFloat x = time.alarmSecond/WYSecs_PerDay*CGRectGetWidth(rect);
        if (x < CGRectGetMinX(leftRec)) {
            x = CGRectGetMinX(leftRec);
        }
        if (x > CGRectGetMaxX(rightRec) - 0.5) {
            x = CGRectGetMaxX(rightRec) - 0.5;
        }
        CGRect r = CGRectMake(x, 0, 0.5, CGRectGetHeight(rect));
        [image drawInRect:r];
    }
    //画黄条
    UIImage *image1 = [UIImage imageWithColor:[UIColor yellowColor]];
    for (WYCameraTime *time in _visitorTimes) {
        CGFloat x = time.alarmSecond/WYSecs_PerDay*CGRectGetWidth(rect);
        if (x < CGRectGetMinX(leftRec)) {
            x = CGRectGetMinX(leftRec);
        }
        if (x > CGRectGetMaxX(rightRec) - 0.5) {
            x = CGRectGetMaxX(rightRec) - 0.5;
        }
        CGRect r = CGRectMake(x, 0, 0.5, CGRectGetHeight(rect));
        [image1 drawInRect:r];
    }

    //画左右半圆
    if (_videoTimes.count > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] setFill];
        //左半圆
        CGContextMoveToPoint(context, CGRectGetMinX(leftRec), 0);
        CGContextAddLineToPoint(context, CGRectGetMinX(leftRec), side*2);
        CGContextAddArc(context, CGRectGetMidX(leftRec), side, side, M_PI_2, -M_PI_2, 0);
        CGContextDrawPath(context, kCGPathFill);
        //右半圆
        CGContextMoveToPoint(ctx, CGRectGetMaxX(rightRec), 0);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rightRec), side*2);
        CGContextAddArc(ctx, CGRectGetMidX(rightRec), side, side, M_PI_2, -M_PI_2, 1);
        CGContextDrawPath(ctx, kCGPathFill);
    }
}
- (void)setvisitorTimes:(NSArray<WYCameraTime *> *)visitorTimes {
    _visitorTimes = visitorTimes;
    [self setNeedsDisplay];
}
- (void)setAlarmTimes:(NSArray<WYCameraTime *> *)alarmTimes {
    _alarmTimes = alarmTimes;
    [self setNeedsDisplay];
}
- (void)setVideoTimes:(NSArray<WYCameraTime *> *)videoTimes {
    _videoTimes = videoTimes;
    [self setNeedsDisplay];
}
@end
