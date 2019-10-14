//
//  WYMsgAlarmModel.h
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WYMsgAlarmModel : NSObject
@property (nonatomic, copy) MeariMessageInfoAlarm *info;

@property (nonatomic, assign)BOOL selected;

@end
