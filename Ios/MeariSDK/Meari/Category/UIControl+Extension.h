//
//  UIControl+Extension.h
//  Meari
//
//  Created by 李兵 on 2017/5/24.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Extension)
@property (nonatomic, assign)BOOL wy_isIgnored;
@property (nonatomic, assign)BOOL wy_needIgnored;
@property (nonatomic, assign)CGFloat wy_delayTime;

@property (nonatomic, copy)NSNumber *wy_on;
@end
