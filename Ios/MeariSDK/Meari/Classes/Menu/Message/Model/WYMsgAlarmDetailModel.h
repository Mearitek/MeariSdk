//
//  WYMsgAlarmDetailModel.h
//  Meari
//
//  Created by 李兵 on 2016/11/22.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WYMsgAlarmType) {
    WYMsgAlarmTypeNone,
    WYMsgAlarmTypeMotion,           /** 移动侦测报警 **/
    WYMsgAlarmTypePIRDetection,     /** PIR侦测报警 **/
    WYMsgAlarmTypeVisitor           /** 访客来访报警 **/
};

@interface WYMsgAlarmDetailModel : NSObject
@property (nonatomic, strong)DeviceAlertMsg *msg;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign) WYMsgAlarmType customAlarmType;

@end
