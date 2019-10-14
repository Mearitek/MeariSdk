//
//  WYCalendarModel.h
//  Meari
//
//  Created by 李兵 on 16/8/4.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYCalendarModel : NSObject

@property (nonatomic, strong)NSDateComponents *date;
@property (nonatomic, assign)BOOL hasVideo;
@property (nonatomic, assign, getter=isSelected)BOOL selected;
@property (nonatomic, assign)WYUIStytle uistytle;
@end
