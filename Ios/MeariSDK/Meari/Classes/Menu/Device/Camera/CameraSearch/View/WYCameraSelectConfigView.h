//
//  WYCameraSelectConfigView.h
//  Meari
//
//  Created by 李兵 on 2017/11/27.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import "WYBaseView.h"

@interface WYCameraSelectConfigView : WYBaseView
+ (instancetype)viewWithImage:(YLGIFImage *)image des:(NSString *)des btnTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
