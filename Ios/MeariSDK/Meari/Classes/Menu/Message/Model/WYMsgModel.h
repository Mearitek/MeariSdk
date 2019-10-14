//
//  WYMsgModel.h
//  Meari
//
//  Created by 李兵 on 16/3/27.
//  Copyright © 2016年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  
     {
        "hasMessgFlag": "Y",
         "deviceID": 43,
         "deviceUUID": "8MCDBCGKXX3BADMH111A",
         "deviceName": "IPC李兵" 
     }
 */

@interface WYMsgModel : NSObject

@property (nonatomic, copy) NSString *hasMessgFlag; //是否有消息
@property (nonatomic, copy) NSNumber *deviceID;     //设备ID
@property (nonatomic, copy) NSString *deviceUUID;   //设备UUID
@property (nonatomic, copy) NSString *snNum;        //设备sn号
@property (nonatomic, copy) NSString *deviceName;   //设备名称
@property (nonatomic, assign) BOOL isSysMsg;        //是否是系统消息
@property (nonatomic, assign) BOOL hasMsg;          //是否有未读消息
@property (nonatomic, copy)NSURL *msgImg;           // 报警消息图片URL
@property (nonatomic, assign, getter = isSelected)BOOL selected;//是否被选中

@end
