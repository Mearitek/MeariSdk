//
//  WYLongPressImageView.h
//  Meari
//
//  Created by MJ2009 on 2018/7/5.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import "YLImageView.h"

@interface WYLongPressImageView : UIImageView
@property (nonatomic, strong) void(^deleteAction)(void);
@end
