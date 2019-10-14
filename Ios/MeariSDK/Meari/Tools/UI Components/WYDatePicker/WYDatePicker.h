//
//  WYDatePicker.h
//  Meari
//
//  Created by 李兵 on 2017/1/17.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WYDatePickerTask)(NSString *time);
@interface WYDatePicker : WYBaseView
@property (nonatomic, assign)BOOL showing;
+ (instancetype)datePickerWithSaveTask:(WYDatePickerTask)saveTask;
- (void)showTime:(id)time;

@end
