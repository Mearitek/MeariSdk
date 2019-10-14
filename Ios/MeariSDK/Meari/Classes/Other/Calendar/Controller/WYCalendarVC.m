//
//  WYCalendarVC.m
//  Meari
//
//  Created by 李兵 on 16/8/3.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import "WYCalendarVC.h"
#import "WYCalendarCell.h"
#import "WYCalendarModel.h"

#define WYLogCalendar(format, ...) //NSLog(@"📅日历---"format, ##__VA_ARGS__);
@interface WYCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *prevMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextMonthBtn;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunLabel;
@property (weak, nonatomic) IBOutlet UILabel *monLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedLabel;
@property (weak, nonatomic) IBOutlet UILabel *thuLabel;
@property (weak, nonatomic) IBOutlet UILabel *friLabel;
@property (weak, nonatomic) IBOutlet UILabel *satLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;


@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)NSDateFormatter *dateFormatter;

//视频天数
@property (nonatomic, strong)NSMutableArray <WYCameraTime *> *sdcardVideoDays;
@property (nonatomic, strong)NSArray <WYCameraTime *> *videoDays;


@property (nonatomic, assign)WYUIStytle uistytle;
@end

@implementation WYCalendarVC

#pragma mark - Private
#pragma mark -- Getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            WYCalendarModel *model = [WYCalendarModel new];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:[NSBundle wy_bundledLanguage]];
        _dateFormatter.dateFormat = @"MMM YYYY";
    }
    return _dateFormatter;
}
- (NSMutableArray<WYCameraTime *> *)sdcardVideoDays {
    if (!_sdcardVideoDays) {
        _sdcardVideoDays = [NSMutableArray array];
    }
    return _sdcardVideoDays;
}
- (NSArray<WYCameraTime *> *)videoDays {
    return self.sdcardVideoDays.copy;
}
- (NSDateComponents *)selectedDate {
    if (!_selectedDate) {
        _selectedDate = [NSDateComponents todayZero];
    }
    return _selectedDate;
}
- (NSDateComponents *)currentDate {
    if (!_currentDate) {
        _currentDate = [NSDateComponents todayZero];
    }
    return _currentDate;
}

- (void)setUistytle:(WYUIStytle)uistytle {
    _uistytle = uistytle;
    switch (uistytle) {
        case WYUIStytleCyan: {
            self.monthYearLabel.textColor =  WY_FontColor_Cyan;
            [self.prevMonthBtn setImage:[UIImage imageNamed:@"btn_camera_calendar_left"] forState:UIControlStateNormal];
            [self.nextMonthBtn setImage:[UIImage imageNamed:@"btn_camera_calendar_right"] forState:UIControlStateNormal];
            break;
        }
        case WYUIStytleOrange: {
            self.monthYearLabel.textColor =  WY_FontColor_DarkOrange;
            [self.prevMonthBtn setImage:[UIImage imageNamed:@"btn_baby_calendar_left"] forState:UIControlStateNormal];
            [self.nextMonthBtn setImage:[UIImage imageNamed:@"btn_baby_calendar_right"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark -- Init
- (void)initSet {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    self.view.frame  = WY_ScreenBounds;
    
    self.monthYearLabel.text = WYLocalString(@"Calendar");
    self.sunLabel.text       = WYLocalString(@"week_SUN");
    self.monLabel.text       = WYLocalString(@"week_MON");
    self.tueLabel.text       = WYLocalString(@"week_TUE");
    self.wedLabel.text       = WYLocalString(@"week_WED");
    self.thuLabel.text       = WYLocalString(@"week_THU");
    self.friLabel.text       = WYLocalString(@"week_FRI");
    self.satLabel.text       = WYLocalString(@"week_SAT");
    
    self.uistytle = _uistytle;
    self.containerView.layer.cornerRadius = 5.0f;
    self.calendarCollectionView.layer.cornerRadius = 5.0f;
    
    [self.calendarCollectionView registerClass:[WYCalendarCell class] forCellWithReuseIdentifier:WY_ClassName([WYCalendarCell class])];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(self.calendarCollectionView.width/7, self.calendarCollectionView.height/6);
    self.calendarCollectionView.collectionViewLayout = layout;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCalendarFrame:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)updateCalendarFrame:(NSNotification *)sender {
    self.view.frame = WY_ScreenBounds;
}

#pragma mark -- Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSet];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -- Super
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint p = [touches.anyObject locationInView:self.view];
    if (CGRectContainsPoint(self.containerView.frame, p)) {
        return;
    }
    [self dismiss];
}


#pragma mark - Delegate
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WY_ClassName([WYCalendarCell class]) forIndexPath:indexPath];
    WYCalendarModel *model = self.dataSource[indexPath.row];
    model.uistytle = _uistytle;
    cell.model = model;
    
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WYCalendarModel *model = self.dataSource[indexPath.row];
    if (model.hasVideo) {
        self.currentDate = self.selectedDate = model.date.copy;
        if ([self.delegate respondsToSelector:@selector(WYCalendarVC:didSelectedHasVideoDay:ofMonth:ofYear:)]) {
            [self.delegate WYCalendarVC:self didSelectedHasVideoDay:self.selectedDate.day ofMonth:self.selectedDate.month ofYear:self.selectedDate.year];
        }
        [self dismiss];
    }else {
        
        [self dismiss];
    }
    
}


#pragma mark - Action
- (IBAction)prevMonthAction:(UIButton *)sender {
    self.currentDate.month-=1;
    self.currentDate = [self.currentDate correctDateComponents];
    [self updateCalendarAtMonth:self.currentDate.month ofYear:self.currentDate.year];
    
    BOOL needRefresh = ![self hasVideoDaysInInDate:self.currentDate];
    if([self.delegate respondsToSelector:@selector(WYCalendarVC:willShowMonth:ofYear:needRefresh:)]) {
        [self.delegate WYCalendarVC:self willShowMonth:self.currentDate.month ofYear:self.currentDate.year needRefresh:needRefresh];
        
    }
    
}
- (IBAction)nextMonthAction:(UIButton *)sender {
    self.currentDate.month+=1;
    self.currentDate = [self.currentDate correctDateComponents];
    [self updateCalendarAtMonth:self.currentDate.month ofYear:self.currentDate.year];
    
    BOOL needRefresh = ![self hasVideoDaysInInDate:self.currentDate];
    if([self.delegate respondsToSelector:@selector(WYCalendarVC:willShowMonth:ofYear:needRefresh:)]) {
        [self.delegate WYCalendarVC:self willShowMonth:self.currentDate.month ofYear:self.currentDate.year needRefresh:needRefresh];
        
    }
}

#pragma mark - Utility
- (BOOL)isVideoDayAtDate:(NSDateComponents *)date {
    BOOL res = NO;
    for (WYCameraTime *time in self.videoDays) {
        if (time.videoDay.year == date.year && time.videoDay.month == date.month && time.videoDay.day == date.day) {
            res = YES;
            break;
        }
    }
    return res;
}
- (BOOL)hasVideoDaysInInDate:(NSDateComponents *)date{
    NSDateComponents *dateC = [date correctDateComponents];
    BOOL res = NO;
    for (WYCameraTime *time in self.videoDays) {
        if (time.videoDay.year == dateC.year && time.videoDay.month == dateC.month) {
            res = YES;
            break;
        }
    }
    WYLogCalendar(@"%ld月%@视频",dateC.month, WY_BOOL(res, @"有", @"无"))
    return res;
}
- (void)updateCalendarAtMonth:(NSInteger)month ofYear:(NSInteger)year {
    
    NSDateComponents *dateC = [NSDateComponents todayZero];
    dateC.year = year;
    dateC.month = month;
    dateC.day = 1;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateC];
    self.monthYearLabel.text = [self.dateFormatter stringFromDate:date];
    
    NSInteger daysOfCurMonth  = date.daysOfMonth;
    NSInteger daysOfPreMonth = date.AMonthPrior.daysOfMonth;
    NSInteger lastDaysOfPreMonth  = date.weekDay - 1;
    WY_WeakSelf
    [self.dataSource enumerateObjectsUsingBlock:^(WYCalendarModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hasVideo = NO;
        obj.selected = NO;
        if (idx < lastDaysOfPreMonth) {

            obj.date.year = dateC.year;
            obj.date.month = dateC.month - 1;
            obj.date.day = daysOfPreMonth - lastDaysOfPreMonth + 1 + (NSInteger)idx;
            obj.date = [obj.date correctDateComponents];
            
        }else if (idx >= lastDaysOfPreMonth && idx < lastDaysOfPreMonth+daysOfCurMonth) {
            obj.date.year = dateC.year;
            obj.date.month = dateC.month;
            obj.date.day = idx - lastDaysOfPreMonth + 1;
            obj.date = [obj.date correctDateComponents];
            
        }else {
            obj.date.year = dateC.year;
            obj.date.month = dateC.month + 1;
            obj.date.day = idx - lastDaysOfPreMonth - daysOfCurMonth + 1;
            
        }
        obj.date = [obj.date correctDateComponents];
        obj.hasVideo = [weakSelf isVideoDayAtDate:obj.date];
        obj.selected = obj.hasVideo && weakSelf.selectedDate.day == obj.date.day;
    }];
    [self.calendarCollectionView reloadData];
    
}

#pragma mark - Public
+ (instancetype)sharedCalendar {
    static WYCalendarVC *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WYCalendarVC alloc] initWithNibName:WY_ClassName([WYCalendarVC class]) bundle:nil];
    });
    return instance;
}
- (void)updateSDCardAtMonth:(NSInteger)month ofYear:(NSInteger)year {
    [self updateCalendarAtMonth:month ofYear:year];
}
- (void)show {
    [self showWithStytle:WYUIStytleDefault];
}
- (void)showWithStytle:(WYUIStytle)stytle {
    self.uistytle = stytle;
    
    WYLogCalendar(@"出现 %ld年%ld月", self.selectedDate.year, self.selectedDate.month)
    [WY_KeyWindow addSubview:self.view];
    [WY_KeyWindow.rootViewController didMoveToParentViewController:self];
    self.currentDate = self.selectedDate.copy;
    [self updateCalendarAtMonth:self.selectedDate.month ofYear:self.selectedDate.year];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.4f animations:^{
        self.view.alpha = 1.0f;
    }];
    
    if ([WY_KeyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        ((UINavigationController*)WY_KeyWindow.rootViewController).view.userInteractionEnabled = NO;
    }
    
    BOOL needRefresh = ![self hasVideoDaysInInDate:self.selectedDate];
    if ([self.delegate respondsToSelector:@selector(WYCalendarVC:willShowMonth:ofYear:needRefresh:)]) {
        [self.delegate WYCalendarVC:self willShowMonth:self.selectedDate.month ofYear:self.selectedDate.year needRefresh:needRefresh];
    }
}
- (void)dismiss {
    WYLogCalendar(@"消失")
    [UIView animateWithDuration:0.4f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        if ([WY_KeyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
            ((UINavigationController*)WY_KeyWindow.rootViewController).view.userInteractionEnabled = YES;
        }
    }];
}

- (void)resetToToday {
    self.selectedDate = [NSDateComponents todayZero];
    self.currentDate = [NSDateComponents todayZero];
}
- (void)resetAll {
    self.sdcardVideoDays = nil;
    self.videoDays = nil;
    self.selectedDate = self.currentDate = nil;
}
- (void)addSDCardVideoDays:(NSArray <WYCameraTime *> *)videoDays {
    [self.sdcardVideoDays addObjectsFromArray:videoDays];
}


@end
