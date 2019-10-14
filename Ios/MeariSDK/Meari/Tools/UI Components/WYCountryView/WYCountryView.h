//
//  WYCountryView.h
//  Meari
//
//  Created by 李兵 on 2017/12/26.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseView.h"
@class LBCountryModel;
@interface WYCountryView : WYBaseView

+ (instancetype)viewWithTarget:(id)target action:(SEL)action;
@property (nonatomic, strong) LBCountryModel *country;

@end
