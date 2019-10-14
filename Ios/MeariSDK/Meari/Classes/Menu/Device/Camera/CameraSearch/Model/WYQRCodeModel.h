//
//  WYQRCodeModel.h
//  Meari
//
//  Created by 李兵 on 2017/5/10.
//  Copyright © 2017年 PPStrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYQRCodeModel : NSObject

//设备二维码
@property (nonatomic, copy)NSString *uuid;
@property (nonatomic, copy)NSString *sn;
@property (nonatomic, copy)NSString *serialno;
@property (nonatomic, copy)NSString *tp;

//登录二维码
@property (nonatomic, copy)NSString *tmpID;
@property (nonatomic, copy)NSString *clientID;
@property (nonatomic, copy)NSString *topic;
@property (nonatomic, copy)NSString *action;


@property (nonatomic, assign)BOOL qrDeviceIsValid;
@property (nonatomic, assign)BOOL qrLoginIsValid;
@end


