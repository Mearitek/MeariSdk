//
//  LeftModel.h
//  Meari
//
//  Created by 李兵 on 16/2/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WYMenuType) {
    WYMenuTypeCamera = 1,
    WYMenuTypeMsg,
    WYMenuTypeFriend,
};


@interface WYMenuModel : NSObject
@property (nonatomic, assign) WYMenuType menuType;                      //菜单类型
@property (nonatomic, copy  ) NSString *title;                          //标题
@property (nonatomic, copy  ) NSString *normalImage;                    //正常图片
@property (nonatomic, copy  ) NSString *highlightedImage;               //高亮图片
@property (nonatomic, assign, getter = isHighlighted) BOOL highlighted; //高亮状态
@property (nonatomic, assign)BOOL showReddot;



+ (instancetype)deviceMenu;
+ (instancetype)msgMenu;
+ (instancetype)friendMenu;
@end
