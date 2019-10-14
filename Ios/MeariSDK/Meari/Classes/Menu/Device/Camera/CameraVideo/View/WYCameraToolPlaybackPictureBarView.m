//
//  WYCameraToolPlaybackPictureBarView.m
//  Meari
//
//  Created by FMG on 2017/11/21.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYCameraToolPlaybackPictureBarView.h"
//#import "WYCameraTime.h"

@interface WYCameraToolPlaybackPictureBarView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    dispatch_group_t group;
}
@property (nonatomic,   weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *tmpArr;
@property (nonatomic,   weak) UILabel *noDataLabel;
@property (nonatomic, strong) WYCameraTime *currentPlayTime;;
@property (nonatomic, strong) NSDateComponents *currentDateComponents;


@end

@implementation WYCameraToolPlaybackPictureBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setInit];
    }
    return self;
}
#pragma mark - Set
- (void)setInit {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    group = dispatch_group_create();
}
- (void)setAlarmTimes:(NSArray<WYCameraTime *> *)alarmTimes {
    dispatch_group_enter(group);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:alarmTimes.count];
    [self.tmpArr removeAllObjects];
    for (WYCameraTime *alarmTime in alarmTimes) {
        for (WYCameraTime *videoTime in self.videoTimes) {
            if (alarmTime.alarmSecond >= videoTime.startSecond && alarmTime.alarmSecond <= videoTime.endSecond) {
                alarmTime.timeType = WYTimeType_pir;
                [arr addObject:alarmTime];
            } else if(videoTime.startSecond - alarmTime.alarmSecond < 10 && alarmTime.alarmSecond <= videoTime.endSecond) {
                [arr addObject:alarmTime];
            }
        }
    }
    [self.tmpArr addObjectsFromArray:arr];
    dispatch_group_leave(group);
}
- (void)setVisitorTimes:(NSArray<WYCameraTime *> *)visitorTimes {
    dispatch_group_enter(group);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:visitorTimes.count];
    for (WYCameraTime *alarmTime in visitorTimes) {
        for (WYCameraTime *videoTime in self.videoTimes) {
            if (alarmTime.alarmSecond >= videoTime.startSecond && alarmTime.alarmSecond <= videoTime.endSecond) {
                alarmTime.timeType = WYTimeType_visitor;
                [arr addObject:alarmTime];
            } else if(alarmTime.alarmSecond + 10 >= videoTime.startSecond && alarmTime.alarmSecond + 10 <= videoTime.endSecond) {
                [arr addObject:alarmTime];
            }
        }
    }
    [self.tmpArr addObjectsFromArray:arr];
    dispatch_group_leave(group);
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *array = [self.tmpArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            WYCameraTime *model1 = (WYCameraTime *)obj1;
            WYCameraTime *model2 = (WYCameraTime *)obj2;
            //给对象排序
            NSComparisonResult result = [[NSNumber numberWithFloat:model1.alarmSecond] compare:  [NSNumber numberWithFloat:model2.alarmSecond]];
            return result;
        }];
        [self.dataSource removeAllObjects];
        for (WYCameraTime *time in array) {
            WYCameraToolPlaybackPictureBar *model  = [WYCameraToolPlaybackPictureBar new];
            model.alarmTime = time;
            model.pictureName = @"img_doorbell_placeholder";
            model.selected = self.currentPlayTime.alarmSecond == time.alarmSecond ? YES:NO;
            [self.dataSource addObject:model];
        }
        if (!self.currentPlayTime && self.dataSource.count ) {
            WYCameraToolPlaybackPictureBar *model = self.dataSource[0];
            model.selected = YES;
            [self.dataSource replaceObjectAtIndex:0 withObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dataSource.count) {
                self.noDataLabel.hidden = YES;
                for (int i = 0; i<self.dataSource.count; i++) {
                    WYCameraToolPlaybackPictureBar *tmpModel = self.dataSource[i];
                    if (self.currentPlayTime.alarmSecond == tmpModel.alarmTime.alarmSecond) {
                        [self.collectionView setContentOffsetX:(150+10)*(i)];
                    }
                }
                if (!self.currentPlayTime && self.dataSource.count) {
                    [self.collectionView setContentOffsetX:0];
                }
            } else {
                self.noDataLabel.text = WYLocalString(@"没有报警事件!");
            }
            [self.collectionView reloadData];

        });
    });
}

- (NSDateComponents *)latestVideoTimeNearTime:(NSDateComponents *)videoTime {
    if (self.currentDateComponents.year != videoTime.year || self.currentDateComponents.month != videoTime.month || self.currentDateComponents.day != videoTime.day) {
        if (!videoTime.hour&!videoTime.minute&!videoTime.second) {
            self.currentPlayTime = nil;
        } else {
            WYCameraTime *playTime = [WYCameraTime new];
            WYTime time;
            time.hour = (int)videoTime.hour;
            time.min = (int)videoTime.minute;
            time.sec = (int)videoTime.second;
            playTime.alarmTime = time;
            self.currentPlayTime = playTime;
        }
    }
    self.currentDateComponents = videoTime;
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

- (void)highlightAlarmMsgAtSecond:(int)second {
//    if (!_canHighlighted) return;
    
//    for (WYCameraToolPlaybackPictureBar *model in self.dataSource) {
//        model.selected = NO;
//    }
    if (ABS(self.currentPlayTime.alarmSecond - second) <= 10) {
        return;
    } 
    for (WYCameraToolPlaybackPictureBar *model in self.dataSource) {
        if (ABS(model.alarmTime.alarmSecond - second) <= 10) {
            model.selected = YES;
            NSInteger row = [self.dataSource indexOfObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            break;
        } else {
            model.selected = NO;
        }
//        else if(model.alarmTime.alarmSecond > second) {
//            model.selected = YES;
//            NSInteger row = [self.dataSource indexOfObject:model];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            [self showCellAtIndexPath:indexPath];
//            break;
//        }
    }
    [self.collectionView reloadData];
    
}
- (void)showStatus:(WYCameraPlayBackPictureBarStatus)status {
    if (status == WYCameraPlayBackPictureBarStatus_noData) {
        self.noDataLabel.text = WYLocalString(@"status_noRecords");
    } else if(status == WYCameraPlayBackPictureBarStatus_failure) {
        self.noDataLabel.text = WYLocalString(@"fail_openVideo");
    }
}
- (WYCameraTime *)readyPlayTimeWithComponents:(NSDateComponents*)currentComponents {
    WYCameraTime *time = [WYCameraTime new];
    WYTime tmp;
    tmp.hour = (int)currentComponents.hour;
    tmp.min = (int)currentComponents.minute;
    tmp.sec = (int)currentComponents.second;
    time.alarmTime = tmp;
    return time;
}

#pragma mark - Delegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraToolPlaybackPictureBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WY_ClassName(WYCameraToolPlaybackPictureBarCell) forIndexPath:indexPath];
    cell.pictureModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(150, 150*9/16.0 + 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(10, collectionView.height);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    return CGSizeMake(10, collectionView.height);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WYCameraToolPlaybackPictureBarCell *item = (WYCameraToolPlaybackPictureBarCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(cameraToolPlaybackPictureBarView:didSelectedSecond:)]) {
        for (WYCameraToolPlaybackPictureBar *pictureModel in self.dataSource) {
            pictureModel.selected = pictureModel == item.pictureModel;
        }
        self.currentPlayTime = item.pictureModel.alarmTime;
        [self.delegate cameraToolPlaybackPictureBarView:self didSelectedSecond:item.pictureModel.alarmTime.alarmSecond];
        [self.collectionView reloadData];
    }
}


#pragma mark - lazyLoad
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView = collect;
        [collect registerClass:[WYCameraToolPlaybackPictureBarCell class] forCellWithReuseIdentifier:WY_ClassName(WYCameraToolPlaybackPictureBarCell)];
        [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        collect.backgroundColor = [UIColor clearColor];
        collect.delegate = self;
        collect.dataSource = self;
        collect.bounces = NO;
        collect.showsHorizontalScrollIndicator = NO;
        collect.showsVerticalScrollIndicator   = NO;
        [self addSubview:collect];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)tmpArr {
    if (!_tmpArr) {
        _tmpArr = [NSMutableArray array];
    }
    return _tmpArr;
}
- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        UILabel *lab = [UILabel new];
        lab.text = WYLocalString(@"正在获取报警事件。。。");
        lab.textColor = WY_FontColor_Gray;
        [self addSubview:lab];
        _noDataLabel = lab;
    }
    return _noDataLabel;
}

@end

#pragma mark -WYCameraToolPlaybackPictureBar
@implementation WYCameraToolPlaybackPictureBar
@end

#pragma mark -WYCameraToolPlaybackPictureBarCell
@interface WYCameraToolPlaybackPictureBarCell ()
@property (nonatomic, weak) UIImageView *pictureImageView;
@property (nonatomic, weak) UIButton *alertMsgBtn;

@end
@implementation WYCameraToolPlaybackPictureBarCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressItem:)]];
    }
    return self;
}
- (void)longPressItem:(UIGestureRecognizer*)gest {
    if (gest.state == UIGestureRecognizerStateBegan) {
        self.itemSelected = YES;
    } else if(gest.state == UIGestureRecognizerStateEnded) {
        self.itemSelected = NO;
    }
}
- (void)setItemSelected:(BOOL)itemSelected{
    _itemSelected = itemSelected;
    self.alertMsgBtn.selected = _itemSelected;
    self.pictureImageView.layer.borderWidth = _itemSelected ? 2 : 0;
    self.pictureImageView.layer.borderColor = _itemSelected ? (self.pictureModel.alarmTime.timeType == WYTimeType_pir? [UIColor redColor].CGColor : WY_FontColor_Orange.CGColor) : [UIColor clearColor].CGColor;
}
- (void)setLayout {
    WY_WeakSelf
    [self.pictureImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.width, weakSelf.width *9/16.0));
    }];
    [self.alertMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.pictureImageView);
        make.top.equalTo(weakSelf.pictureImageView.mas_bottom).offset(8);
    }];
}

- (void)setPictureModel:(WYCameraToolPlaybackPictureBar *)pictureModel {
    _pictureModel = pictureModel;
    self.itemSelected = _pictureModel.selected;
    self.alertMsgBtn.wy_normalImage = _pictureModel.alarmTime.timeType == WYTimeType_visitor ? [UIImage imageNamed:@"img_playback_ alert_visitor_normal"] : [UIImage imageNamed:@"img_playback_ alert_pir_normal"];
    self.alertMsgBtn.wy_selectedImage = _pictureModel.alarmTime.timeType == WYTimeType_visitor ? [UIImage imageNamed:@"img_playback_ alert_visitor_selected"] : [UIImage imageNamed:@"img_playback_ alert_pir_selected"];
    self.alertMsgBtn.wy_selectedTitleColor = pictureModel.alarmTime.timeType == WYTimeType_visitor ? WY_FontColor_Orange:WY_FontColor_Red;
    self.pictureImageView.image = [UIImage imageNamed:_pictureModel.pictureName];
    self.alertMsgBtn.wy_normalTitle = _pictureModel.alarmTime.alarmString;
}

- (UIImageView *)pictureImageView {
    if (!_pictureImageView) {
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.contentView addSubview:view];
        _pictureImageView = view;
    }
    return _pictureImageView;
}
- (UIButton *)alertMsgBtn {
    if (!_alertMsgBtn) {
        UIButton *btn = [UIButton new];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        btn.wy_normalTitleColor = WY_FontColor_Gray;
        btn.wy_titleFont = WYFont_Text_XXS_Bold;
        _alertMsgBtn = btn;
        [self.contentView addSubview:btn];
    }
    return _alertMsgBtn;
}

@end
