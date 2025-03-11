//
//  MeariAppModel.h
//  MeariKit
//
//  Created by maj on 2020/8/7.
//  Copyright © 2020 Meari. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeariNoticeModel : MeariBaseModel
@property (nonatomic, assign) NSInteger Id;         //公告ID
@property (nonatomic, copy)   NSString *content;    //公告内容
@property (nonatomic, assign) NSInteger startTime;  //开始时间
@property (nonatomic, assign) NSInteger endTime;    //结束时间
@property (nonatomic, assign) NSInteger jumpState;  //是否跳转 0-否 1-显示去查看"
@property (nonatomic, copy)   NSString *jumpUrl;    //跳转URL
@property (nonatomic, copy) NSString *appProtocolVer;
@end

NS_ASSUME_NONNULL_END
