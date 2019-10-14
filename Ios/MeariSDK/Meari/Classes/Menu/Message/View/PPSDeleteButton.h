//
//  PPSDeleteButton.h
//  Weeye
//
//  Created by 李兵 on 15/12/15.
//  Copyright © 2015年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WYBottomBtnType) {
    WYBottomBtnTypeDelete,
    WYBottomBtnTypeDeleteAndMark
    
};

@interface PPSDeleteButton : UIView


+ (instancetype)deleteBtnWithFrame:(CGRect)frame targe:(id)target action:(SEL)action;
+ (instancetype)deleteAndMarkBtnWithFrame:(CGRect)frame targe:(id)target deleteAction:(SEL)deleteAction markAction:(SEL)markAction;


@end
