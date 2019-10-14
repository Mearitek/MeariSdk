//
//  WYCountryVC.h
//  Meari
//
//  Created by 李兵 on 2017/12/7.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "LBCountryVC.h"

@interface WYCountryVC : LBCountryVC
+ (instancetype)wy_vcWithSelectCountry:(LBCountrySelectBlock)selectCountry;
@end
