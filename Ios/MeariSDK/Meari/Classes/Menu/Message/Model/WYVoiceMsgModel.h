//
//  WYVoiceMsgModel.h
//  Meari
//
//  Created by MJ2009 on 2018/7/12.
//  Copyright © 2018年 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYVoiceMsgModel : NSObject
@property (nonatomic, assign) BOOL isTimeTag;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) double createDateInterval;
@property (nonatomic, strong) DeviceAlertMsg *msg;
@end
