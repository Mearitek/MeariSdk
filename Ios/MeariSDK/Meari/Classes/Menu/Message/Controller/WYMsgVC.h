//
//  WYMsgVC.h
//  HYRtspSDK
//
//  Created by Strong on 15/8/19.
//  Copyright (c) 2015年 PPStrong. All rights reserved.
//
typedef NS_ENUM(NSInteger, WYMsgType) {
    WYMsgTypeAlarm = 1,
    WYMsgTypeSystem
};

@interface WYMsgVC : WYBaseSubMenuVC

@property (nonatomic, assign)WYMsgType msgType;
@property (nonatomic, assign)WYMsgType msgTypeFromPush;

- (void)networkRequestFromPush;

@end
