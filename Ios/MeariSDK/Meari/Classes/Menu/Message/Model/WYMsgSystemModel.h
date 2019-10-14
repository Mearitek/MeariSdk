//
//  WYMsgSystemModel.h
//  Meari
//
//  Created by 李兵 on 16/3/28.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYMsgSystemModel : NSObject
@property (nonatomic, copy)MeariMessageInfoSystem *info;

@property (nonatomic, copy)NSString *descWhole;
@property (nonatomic, copy)NSString *accountWhole;
@property (nonatomic, assign)BOOL selected;

@end
