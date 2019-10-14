//
//  WYProgressCircleView.h
//  Meari
//
//  Created by 李兵 on 2016/11/21.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WYProgressCircleView : WYBaseView
/** 填充背景色 **/
@property (nonatomic, strong)UIColor *fillCircleColor;
/** 填充背景色 **/
@property (nonatomic, assign)BOOL needFill;
/** 进度条背景色 **/
@property (nonatomic, strong)UIColor *backgroundCircleColor;
/** 进度条颜色 **/
@property (nonatomic, strong)UIColor *progressCircleColor;
/** 进度条宽度，默认3 **/
@property (nonatomic, assign)NSInteger progressWidth;
/** 文本字体 **/
@property (nonatomic, strong)UIFont *textFont;
/** 文本颜色 **/
@property (nonatomic, strong)UIColor *textColor;
/** 是否显示进度文本 **/
@property (nonatomic, assign)BOOL showText;
/** 进度文本 **/
@property (nonatomic, copy)NSString *text;

/** 进度 0.0 - 1.0 **/
@property (nonatomic, assign)CGFloat progress;
/** 消失 **/
- (void)dismiss;



@end
