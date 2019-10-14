//
//  MeariShareInfo.h
//  MeariKit
//
//  Created by maj on 2019/8/20.
//  Copyright © 2019 Meari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariShareInfo : MeariBaseModel
@property (nonatomic, assign) NSInteger userID;     //被分享者ID
@property (nonatomic, copy) NSString *shareAccount;  //被分享者账号
@property (nonatomic, copy) NSString *shareName;     //被分享者昵称
@property (nonatomic, copy) NSString *shareImageUrl;    //被分享者头像
@property (nonatomic, assign) BOOL shareStatus;    //设备是否给该账号分享

@end

NS_ASSUME_NONNULL_END
