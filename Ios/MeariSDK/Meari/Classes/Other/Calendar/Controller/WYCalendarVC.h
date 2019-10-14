//
//  WYCalendarVC.h
//  Meari
//
//  Created by 李兵 on 16/8/3.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WY_Calendar [WYCalendarVC sharedCalendar]


@class WYCalendarVC;
@protocol WYCalendarVCDelegate <NSObject>
@optional
- (void)WYCalendarVC:(WYCalendarVC *)vc didSelectedHasVideoDay:(NSInteger)day ofMonth:(NSInteger)month ofYear:(NSInteger)year;
- (void)WYCalendarVC:(WYCalendarVC *)vc willShowMonth:(NSInteger)month ofYear:(NSInteger)year needRefresh:(BOOL)needRresh;

@end



@interface WYCalendarVC : WYBaseVC

@property (weak, nonatomic) id<WYCalendarVCDelegate> delegate;

@property (nonatomic, strong)NSDateComponents *selectedDate;       //选中日期
@property (nonatomic, strong)NSDateComponents *currentDate;        //当前日期



+ (instancetype)sharedCalendar;
- (void)updateSDCardAtMonth:(NSInteger)month ofYear:(NSInteger)year;
- (void)show;
- (void)showWithStytle:(WYUIStytle)stytle;
- (void)dismiss;

//复位
- (void)resetToToday;
- (void)resetAll;

//缓存视频天数
- (void)addSDCardVideoDays:(NSArray <WYCameraTime *> *)videoDays;



@end
