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
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *shareAccount;
@property (nonatomic, copy) NSString *shareName;
@property (nonatomic, copy) NSString *shareImageUrl;    
@property (nonatomic, assign) BOOL shareStatus;

@end

NS_ASSUME_NONNULL_END
