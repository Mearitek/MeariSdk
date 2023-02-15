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
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger jumpState;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *appProtocolVer;
@end

NS_ASSUME_NONNULL_END
