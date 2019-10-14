//
//  WYCameraHDSDButton.h
//  Meari
//
//  Created by 李兵 on 2016/12/1.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYCameraHDSDButton : UIView

@property (nonatomic, assign)BOOL hdFlag;
@property (nonatomic, assign)BOOL hdsdEnabled;

- (instancetype)initWithTarget:(id)target hdAction:(SEL)hdaction sdAction:(SEL)sdAction;
- (instancetype)initWithTarget:(id)target hdAction:(SEL)hdaction sdAction:(SEL)sdAction touchAction:(SEL)touchAction;
- (void)setTitleColor:(UIColor *)color;

@end
