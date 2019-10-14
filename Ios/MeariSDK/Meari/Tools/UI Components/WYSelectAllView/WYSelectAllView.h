//
//  WYSelectAllView.h
//  Meari
//
//  Created by 李兵 on 2016/11/24.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYSelectAllView : WYBaseView
@property (nonatomic, assign)BOOL selected;
+ (instancetype)selectAllViewWithSelectTask:(void(^)(BOOL selected))selectTask;
@end
